See the list of all available meters for all the resources:

```bash
# ceilometer meter-list
```

See the list of samples for the image meter:

```bash
# ceilometer sample-list -m image
```

Look at the consolidated statistics for the image meter:

```bash
# ceilometer statistics -m image
```

List the meters gathered for the instance:

```bash
# ceilometer meter-list -q resource_id=<VM ID>
```

See the data samples for cpu meter of c_vm instance:

```bash
# ceilometer sample-list -m cpu -q resource_id=<VM ID>
# ceilometer sample-list --meter cpu_util --query resource=<VM ID>
```

Let’s look at the statistics for the cpu_util meter of c_vm instance in 1 hour intervals:

```bash
# ceilometer statistics -m cpu_util -p 3600 -q resource_id=<VM ID>
# ceilometer statistics -m cpu_util -q stack_id=<STACK ID> -p 3600 -a avg
```

Create an alarm based on the upper bound on the CPU utilization for the instance we created:

```bash
# ceilometer alarm-threshold-create --name cpu_high --description 'running hot' -m cpu_util --statistic avg --period 300 \
  --evaluation-periods 3 --comparison-operator gt --threshold 70.0 --alarm-action 'log://' -q resource_id=<VM ID>
```

List the created alarm and note its ID:

```bash
# ceilometer alarm-list
```


Modify the cpu_high alarm to increase the threshold:

```bash
# ceilometer alarm-update --threshold 75 -a <alarm ID>
```

Look at the history of an alarm:

```bash
# ceilometer alarm-history -a <alarm ID>
```

Disable the cpu_high alarm:

```bash
# ceilometer alarm-update --enabled False -a <alarm ID>
```

Delete the cpu_high alarm:

```bash
# ceilometer alarm-delete -a <alarm ID>
```
