# Global Requirements

\newcommand{\Normal}{\textsc{Normal}\xspace}
\newcommand{\Tolerating}{\textsc{Tolerating}\xspace}
\newcommand{\Ringing}{\textsc{Ringing}\xspace}
\newcommand{\Dead}{\textsc{Dead}\xspace}
\newcommand{\Standby}{\textsc{Standby}\xspace}
\newcommand{\true}{\text{true}\xspace}
\newcommand{\false}{\text{false}\xspace}

\newcommand{\act}[1]{\textsc{#1}\xspace}

## Assumptions about the external world

1.  The ERTMS system comes into charge whenever it detects the presense of ERTMS signals; it goes out of charge when the ATP system asks it to do so.

1.  When the ERTMS system is in charge, it controls the brake and UI according to the ERTMS signals it receives. When it is not, it polls the current speed and brake status periodically and make this information available to the ATP system. When the ATP system requests it to ring the bell or start emergency braking, it acts accordingly.

1.  The APT system always polls ATP signals on the antenna, whether it is in charge or not. There is a special signal that indicates ATP should be switched off called “BD” (buiten dienst).

1.  After emergency braking, the driver cannot release the brake until the whole system is reset.

## Note on ATP modes

We designate five **modes** for the ATP system, namely \Normal{}, \Tolerating{}, \Ringing{}, \Dead{} and \Standby{}. Ideally, knowledge about the different modes should be internal details. However, we find it very tricky to specify the requirements without explicitly considering modes. Below is an informal description of the different modes:

1.  ATP is in \Standby{} mode either when ERTMS is in charge, or the last ATP signal was BD.

1.  ATP is in \Dead{} mode after emergency brake and a reset is required.

1.  The other three modes are best explained by illustrating a typical scenerio of over-speeding. As shown in \autoref{fig:over-speeding},

    1.  At time $t=0$, ATP is in \Normal{} mode. The train is found to be over-speeding, due to a change in the ATP signal; the maximum speed allowed is $vm$. The brake is off ATP rings the bell and enters the \Ringing{} mode which always lasts for 3 seconds.

    1.  The \Ringing{} mode is special in that *no* speed limits are enfored; instead, ATP waits for the driver to take action. After 3 seconds, ATP finds out that the brake is now on, and comes back to \Normal{} mode.

    1.  The speed of train now starts to decrease, until it reaches $vm + \Delta v$, and ATP now ring the bell three times and enters \Tolerating{} mode.

    1.  The \Tolerating{} mode will enfore a modified speed limit of $vm + \Delta v$ instead of $vm$, so the current speed is now considered over-speeding and the driver may release the brake. After the speed $vm$ is reached, ATP goes back to \Normal{} mode.

\begin{figure}[h]
\begin{center}
    \includegraphics{figures/over-speeding}
    \caption{A typical over-speeding scenerio}
    \label{fig:over-speeding}
\end{center}
\end{figure}

The exact relationships between the modes are specified in the requirements.

## Requirements

1.  When ATP is in \Normal{} mode:

    1.  If the brake is off, and the current speed is higher than the maximum speed allowed on the antenna (known as $vm$ afterwards), ATP requests ERTMS to ring the bell and enters \Ringing{} mode.

    1.  If the brake is on, and current speed is between $vm$ and $vm + \Delta v$, ATP requests ERTMS to ring the bell three times and enter \Tolerating{} mode.

    1.  Otherwise, no bell is ringed and ATP stays in this mode.

1.  When ATP is in \Tolerating{} mode:

    1.  If the brake is off, and the current speed is higher than $vm + \Delta v$, ATP requests ERTMS to ring the bell and enters \Ringing{} mode.

    1.  If the current speed is lower than $vm$, ATP enters \Normal{} mode.

    1.  ATP always enters \Normal{} after a specified amount of time, $\Delta t$.

    1.  If the current speed is higher than $vm$, ATP will stay in \Tolerating{} mode within $\Delta t$.

1.  Three seconds after ATP enters \Ringing{} mode:

    1.  If the brake is on, ATP enters \Normal{} mode.

    1.  If the brake is off, ATP initates an emergency brake.

1.  When ATP is not in \Standby{} mode and a beacon-stop signal is detected, it will request ERTMS to start emergency braking.

1.  When ATP is in \Standby{} mode, it will not request ERTMS to ring the bell or start emergency braking.

1.  When ATP is in \Standby{} mode, and it receives signals on the antenna it will inform ERTMS that ATP will be in charge. If the signal is not BD, it will then enter \Normal{} mode.

1.  Whenever ATP receives BD signal on the antenna, it enters \Standby{} mode.

1.  When the current speed is 0, the whole system may be reset.

1.  When the current speed is not 0, the whole system may not be reset.

1.  The system is free of deadlocks.

# External Actions

\act{update}$(s, v, b)$: ATP is informed of the current ATP signal, the current speed and the current brake status. This action always happens when an ATP signal is received on the antenna.

\act{ertms-signal}: ERTMS informs ATP that ERTMS signal is detected and therefore ERTMS will be in charge.

\act{beacon-stop}: ATP receives a stop signal from a beacon.

\act{bell}: ATP requests ERTMS to ring the bell.

\act{ebrake}: ATP requests ERTMS to start an emergency brake.

\act{ertms-standby}: ATP requests ERTMS to enter standby mode because ATP will be in charge.

\act{timer1}: ATP starts timer 1 which will go off in 3 seconds.

\act{timeout1}: timer1 goes off.

\act{timer2}: ATP starts timer 2 which will go off in 3 minutes.

\act{timeout2}: timer2 goes off.

\act{reset}: The driver resets the whole system so that the brake can be released.

\act{atp-mode}$(m)$: ATP announces its new mode.

# Global Requirements (In Terms of External Actions)

## Assumptions about the external world

1.  The ERTMS system comes into charge whenver it detects the presense of ERTMS signals; it goes out of charge when the ATP system initiates an \act{ertms-enter-standby} action.

1.  When the ERTMS system is in charge, it controls the brake and UI according to the ERTMS signals it receives. When it is not, it controls the brake and the bell according to the \act{ebrake} and \act{bell} actions initiated by ATP.

1.  The action \act{update} happens periodically, if ATP signal is received on the antenna. It also informs the ATP system of the current speed and brake status. This action happens

1.  After an \act{ebrake} action, the driver cannot release the brake until a \act{reset} action happens.

## Definition

1.  The **mode** of the ATP system is defined to be the data in the last $\act{atp-mode}(m)$ action. When no such action has happened, ATP is in \Standby mode.

## Requirements

1.  When ATP is in \Normal{} mode and \act{update}$(s, v, b)$ happens:

    1.  If $v > vm(s)$ and $b = \false$, ATP initiates \act{bell} and enters \Ringing{} mode.

    1.  If $vm(s) < v < vm(s) + \Delta v$, ATP intiates three \act{bell} actions and enter \Tolerating{} mode.

    1.  Otherwise, no \act{bell} happens and no mode change happens.

1.  When ATP is in \Tolerating{} mode:

    1. When \act{update}$(s, v, b)$ happens:

        1.  If $v > vm(s) + \Delta v$ and $b = \false{}$, ATP initiates \act{bell} and enters \Ringing{} mode.

        1.  If $v \le vm(s)$, ATP enters \Normal{} mode.

        1.  Otherwise, no \act{bell} happens and no mode change happens.

    1.  When \act{timeout2} happens, it enters \Normal{} mode.

    1.  When no \act{timeout2} or \act{update} happens, no mode change happens.

1.  When ATP is in \Ringing{} mode, and \act{timeout1} and \act{update}$(s, v, b)$ happens:

    1.  If $b = \true{}$, ATP enters \Normal{} mode.

    1.  If $b = \false{}$, ATP initiates \act{ebrake} and enters \Dead{} mode.

1.  When ATP is not in \Standby{} mode and \act{beacon-stop} happens, ATP will initiate \act{ebrake}.

1.  When ATP is in \Standby{} mode, it will not initiate \act{bell} or \act{ebrake}.

1.  When ATP is in \Standby{} mode and \act{update}$(s, v, b)$ happens, it intiates \act{ertms-standby}. If $s \neq \text{BD}$, it then enters \Normal mode.

1.  Whenever \act{update}$(\text{BD}, v, b)$ happens, ATP enters \Standby{} mode.

1.  When $v = 0$, \act{reset} is allowed.

1.  When $v > 0$, \act{reset} is not allowed.

1.  The system is free of deadlocks.

# Process definition

\verbinput{p.mcrl2}

<!-- vi: se tw=0 ai: -->
