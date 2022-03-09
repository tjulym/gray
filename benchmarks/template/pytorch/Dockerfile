FROM openfaas/classic-watchdog:0.15.4 as watchdog
FROM libai3/masr-env

COPY --from=watchdog /fwatchdog /usr/bin/fwatchdog
RUN chmod +x /usr/bin/fwatchdog

RUN groupadd -r func && useradd func -r -g func
RUN mkdir /home/func \
    && chown func /home/func

WORKDIR /home/func/function
COPY function /home/func/function
#RUN ./helper_script.sh
RUN pip install -r requirements.txt
RUN chown func /home/func/function


USER func
ENV fprocess="python index.py"
HEALTHCHECK --interval=3s CMD [ -e /tmp/.lock ] || exit 1

CMD ["fwatchdog"]
