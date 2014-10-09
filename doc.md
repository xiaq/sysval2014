# Global Requirements

Notes:

1.  When the ERTMS system is in charge, it controls the brake and UI according to the ERTMS signals it receives. When it is not, it polls the current speed and brake status periodically and make this information available to the ATP system. When the ATP system requests it to ring the bell or start emergency braking, it acts accordingly.

1.  The APT system always polls ATP signals on the antenna, whether it is in charge or not. There is a special signal that indicates ATP should be switched off called “BD” (buiten dienst).

1.  When the ATP system is in charge, it may be “tolerating”. This is needed for the situations where the brake may be released, even if current speed is greater than the required maximum speed.

1.  After emergency braking, the driver cannot release the brake until the whole system is reset.

Definition:

1.  The ATP system is defined to be in charge whenever it receives a non-BD signal on its antenna until ERTMS signal is detected or a BD signal is received.

1.  The ERTMS system is defined to be in charge whenever ERTMS signal is detected until the ATP system asks it to enter standby mode.

Requirements:

1.  When the ATP system is in charge:

    1.  If the current speed V is higher than the maximum speed required on the antenna, Vm (or Vm + some predefined value ΔV, when ATP is tolerating),
        1.  If the brake is off, ATP will request ERTMS to ring the bell. If in 3 seconds, the brake is still off, ATP will request ERTMS to start emergency braking.
        1.  If the brake is on and ATP is non-tolerating, and V < Vm + ΔV, ATP will request ERTMS to ring the bell 3 times. ATP will then become “tolerating”.
        1.  If the brake is on and ATP is non-tolerating, then as long as $V \ge V_m \Delta V$, ATP will stay non-tolerating.

    1.  If ATP is tolerating,
        1.  If the current speed V is lower than Vm, it will become non-tolerating.
        1.  It will become non-tolerating after a predefined time period of Δt.
        1.  If the current V is higher than Vm, it will stay tolerating within a time period of Δt.

    1.  If it detects a “beacon-stop” signal, it will request ERTMS to start emergency braking.

    1.  If the current speed V is not higher than the aforementioned speed, and no “beacon-stop” signal is detected, then ATP will not request ERTMS to ring the bell or start emergency braking.

1.  When the ATP system is not in charge, it will not request ERTMS to ring the bell or start emergency braking.

1.  When the ATP system is not in charge, and it receives a non-BD signals on the antenna it will inform ERTMS that ATP will be in charge.

1.  When the current speed is 0, the whole system may be reset.

1.  When the current speed is not 0, the whole system may not be reset.

# External Actions

speed(V)
:    ERTMS informs ATP about the current speed of the train V, a number.

brake-status(B)
:    ERTMS informs ATP about the current brake status B, a boolean value.

ertms-signal
:    ERTMS informs ATP that ERTMS signal is detected and therefore ERTMS will be in charge.

atp-signal(S)
:    ATP reads from the antenna a signal S. Some possible values of S are BD, Speed60, Speed80, Speed130 and Speed140.

beacon-stop
:    ATP receives a stop signal from a beacon.

bell
:    ATP requests ERTMS to ring the bell.

ebrake
:    ATP requests ERTMS to start an emergency brake.

ertms-standby
:    ATP requests ERTMS to enter standby mode because ATP will be in charge.

timer1
:    ATP starts timer 1 which will go off in 3 seconds.

timeout1
:    timer1 goes off.

timer2
:    ATP starts timer 2 which will go off in 3 minutes.

timeout2
:    timer2 goes off.

reset
:    The driver resets the whole system so that the brake can be released.


# Global Requirements (In Terms of External Actions)

Notes:

1.  When the ERTMS system is in charge, it controls the brake and UI according to the ERTMS signals it receives. When it is not, speed(V) and brake-status(B) actions periodically. When the ATP system initiates a bell or ebrake action, it acts accordingly.

1.  The action atp-signal(S) happens periodically, whether the ATP system is in charge or not. There is a special value of S, BD, that indicates ATP should be switched off. There is a function as-to-speed(S) that maps a signal to the corresponding required maximum speed.

1.  When the ATP system is in charge, it may be “tolerating”. This is needed for the situations where the brake may be released, even if current speed is greater than the required maximum speed.

1.  After an ebrake action, the driver cannot release the brake until the whole system is reset.

Definitions:

1.  The ATP system is defined to be in charge whenever atp-signal(S) happens and S is not equal to BD, until ertms-signal or atp-signal(BD) happens.

1.  The ERTMS system is defined to be in charge whenever ERTMS signal is detected until ertms-enter-standby happens.

1.  V is defined to be the data in the last speed(V) action.

1.  B is defined to be the data in the last brake-status(B) action.

1.  S is defined to be the data in the last atp-signal(S) action. Vm is defined to be as-to-speed(S).

Requirements:

1.  When the ATP system is in charge:

    1.  If V is higher than Vm (or Vm + some predefined value ΔV, when ATP is tolerating),
        1.  If B is false, ATP initiates a bell action. If in 3 seconds, B is still false, ATP initiates ebrake.
        1.  If B is true and ATP is non-tolerating, and V < Vm + ΔV, ATP will initiate 3 bell actions. ATP will then become “tolerating”.
        1.  If B is true and ATP is non-tolerating, then as long as V $\ge$  Vm + ΔV, ATP will stay non-tolerating.

    1.  If ATP is tolerating,
        1.  If V is lower than Vm, it will become non-tolerating.
        1.  It will become non-tolerating after a predefined time period of Δt.
        1.  If the current V is higher than Vm, it will stay tolerating within a time period of Δt.

    1.  If beacon-stop happens, it will initiate ebrake.

    1.  If V is not higher than the aforementioned speed, and no beacon-stop happens, then ATP will initate bell or ebrake.

1.  When the ATP system is not in charge, it will not initiate bell or ebrake.

1.  When the ATP system is not in charge, when atp-signal(S) happens it intiates ertms-standby.

1.  When V = 0, the reset action is allowed.

1.  When V is not equal to 0, the reset action is not allowed.

# Process definitions

\begin{alltt}
\input{p.mcrl2}
\end{alltt}

<!-- vi: se tw=0 ai sw=2 sts=2 ts=2: -->
