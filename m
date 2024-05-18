Return-Path: <io-uring+bounces-1934-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A97B8C90A7
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 13:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3776CB2155F
	for <lists+io-uring@lfdr.de>; Sat, 18 May 2024 11:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8192E28DDF;
	Sat, 18 May 2024 11:40:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7622C8C0;
	Sat, 18 May 2024 11:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716032426; cv=none; b=L/0TitRWe0lL5efC4ZvEiMRckhQGlEV2DOA29KLylZ5HPUeeJlbRlkQHkH0yadVyQ/IFBGSlCDc1OU85+xrrOH7Bv7aM7HnBVsehKuSvLUUT65pkr+5YtwFQdiL+IjXIZKnmCr73Hs+SSHyM0dhq+fLsef6KNqKSoxyhPBw0CuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716032426; c=relaxed/simple;
	bh=J+3mENzbVSJnvLinktuaO4d9K1C2sjGltlD4pSm7uZY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aqS6siZjGkLdM9dlVfMXy8BZe8tg/r41kKY/6hPXEIxNkN9Iupqzqde9OaaCg5WOVg84/Da+LnigafFwsc06LBVBOHeXK4sPJGrYaL0z+xeYDlHvYawt5Q9X/2ntBY1SMcx5LdKtLZM9hM0P9AS+N3bK7JUoLVM1ysu5hFJnZkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C6B521424;
	Sat, 18 May 2024 04:40:40 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.69.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 84EB83F641;
	Sat, 18 May 2024 04:40:12 -0700 (PDT)
From: Christian Loehle <christian.loehle@arm.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org,
	juri.lelli@redhat.com,
	mingo@redhat.com,
	rafael@kernel.org,
	dietmar.eggemann@arm.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com,
	ulf.hansson@linaro.org,
	bvanassche@acm.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-pm@vger.kernel.org,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	qyousef@layalina.io,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFC PATCH v2 0/1] Introduce per-task io utilization boost
Date: Sat, 18 May 2024 12:39:46 +0100
Message-Id: <20240518113947.2127802-1-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a feature inside of both schedutil and intel_pstate called
iowait boosting which tries to prevent selecting a low frequency
during IO workloads when it impacts throughput.
The feature is implemented by checking for task wakeups that have
the in_iowait flag set and boost the CPU of the rq accordingly
(implemented through cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT)).

The necessity of the feature is argued with the potentially low
utilization of a task being frequently in_iowait (i.e. most of the
time not enqueued on any rq and cannot build up utilization).

The RFC focuses on the schedutil implementation.
intel_pstate implementation is possible, but with reviews of v1 it
seems a governor-based implementation is preferred.
Current schedutil iowait boosting has several issues:
1. Boosting happens even in scenarios where it doesn't improve
throughput. [1]
2. The boost is not accounted for in EAS: a) feec() will only consider
 the actual task utilization for task placement, but another CPU might
 be more energy-efficient at that capacity than the boosted one.)
 b) When placing a non-IO task while a CPU is boosted compute_energy()
 assumes a lower OPP than what is actually applied. This leads to
 wrong EAS decisions.
3. Actual IO heavy workloads are hardly distinguished from infrequent
in_iowait wakeups.
4. The boost isn't associated with a task, it therefore isn't considered
for task placement, potentially missing out on higher capacity CPUs on
heterogeneous CPU topologies.
5. The boost isn't associated with a task, it therefore lingers on the
rq even after the responsible task has migrated / stopped.
6. The boost isn't associated with a task, it therefore needs to ramp
up again when migrated.
7. Since schedutil doesn't know which task is getting woken up,
multiple unrelated in_iowait tasks might lead to boosting.
8. Boosting is hard to control with UCLAMP_MAX.

We attempt to mitigate all of the above by reworking the way the
iowait boosting (io boosting from here on) works in two major ways:
- Carry the boost in task_struct, so it is a per-task attribute and
behaves similar to utilization of the task in some ways.
- Employ a counting-based tracking strategy that only boosts as long
as it sees benefits and returns to minimal boosting dynamically.

Note that some the issues (1, 3) can be solved by using a
counting-based strategy on a per-rq basis, i.e. in sugov entirely.
Experiments with Android in particular showed that such a strategy
(which necessarily needs longer intervals to be reasonably stable)
is too prone to migrations to be useful generally.
We therefore consider the additional complexity of such a per-task
based approach like proposed to be worth it.

We require a minimum of 1000 iowait wakeups per second to start
boosting.
This isn't too far off from what sugov currently does, since it resets
the boost if it hasn't seen an iowait wakeup for TICK_NSEC.
For CONFIG_HZ=1000 we are on par, for anything below we are stricter.
We justify this by the small possible improvement by boosting in the
first place with 'rare' iowait wakeups.

When IO even leads to a task being in iowait isn't as straightforward
to explain.
Of course if the issued IO can be served by the page cache (e.g. on
reads because the pages are contained, on writes because they can be
marked dirty and the writeback takes care of it later) the actual
issuing task is usually not in iowait.
We consider this the good case, since whenever the scheduler and a
potential userspace / kernel switch is in the critical path for IO
there is possibly overhead impacting throughput.
We therefore focus on random read from here on, because (on synchronous
IO [3]) this will lead to the task being set in iowait for every IO.
This is where iowait boosting shows its biggest throughput improvement.
From here on IOPS (IO operations per second, assume 4K size) and iowait
wakeups may therefore be used interchangeably.

Performance:
Throughput for random read tries to be on par with the sugov
implementation of iowait boosting for reasonably long-lived workloads.
See the following table for some results, values are in IOPS, the tests
are ran for 30s with pauses in-between, results are sorted.

nvme on rk3399 without LITTLEs (no EAS)
[3135, 3285, 3728, 3857, 3863] sugov mainline
[3073, 3078, 3164, 3867, 3892] per-task tracking sugov
[2741, 2743, 2753, 2755, 2793] sugov no iowait boost
[3107, 3113, 3126, 3156, 3168] performance governor

Showcasing some different IO scenarios, again all random read,
median out of 5 runs, all on rk3399 with nvme.
e.g. io_uring6x4 means 6 threads with 4 iodepth each, results can be
obtained using:
fio --minimal --time_based --name=test --filename=/dev/nvme0n1 --runtime=30 --rw=randread --bs=4k --ioengine=io_uring --iodepth=4 --numjobs=6 --group_reporting | cut -d \; -f 8

+---------------+----------------+-------------------+----------------+-------------+-----------+
|               | Sugov mainline | Per-task tracking | Sugov no boost | Performance | Powersave |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|       psyncx1 |           3683 |              3564 |           2905 |        3747 |      2578 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|       psyncx4 |          12395 |             12441 |          10289 |       12718 |      9349 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|       psyncx6 |          16409 |             16501 |          14331 |       17127 |     13214 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|      psyncx12 |          24349 |             24979 |          24273 |       24535 |     20884 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|     libaio1x1 |           2853 |              2825 |           2868 |        3623 |      2564 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|   libaio1x128 |          33053 |             33020 |          33560 |       32439 |     14034 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|   libaio4x128 |          33096 |             33020 |          33174 |       31989 |     33581 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|   libaio6x128 |          32566 |             33233 |          33138 |       31997 |     33120 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|   io_uring1x1 |           3343 |              3433 |           2819 |        3661 |      2525 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|  io_uring4x64 |          33167 |             33665 |          33656 |       32648 |     33636 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
|   io_uring6x4 |          30330 |             30077 |          30234 |       30103 |     29310 |
+---------------+----------------+-------------------+----------------+-------------+-----------+
| io_uring6x128 |          32525 |             32027 |          33117 |       32067 |     32915 |
+---------------+----------------+-------------------+----------------+-------------+-----------+

Based on the above we can basically categorize these into the following
three:
a) boost is useful
b) boost irrelevant (util dominates)
c) boost is energy-inefficient (boost dominates)

The aim of the patch is to boost as much as necessary for a) while
boosting little for c) (thus saving energy).

Energy-savings:
Regarding sugov iowait boosting problem 1 mentioned earlier,
some improvement can be seen:
Tested on rk3399 (LLLL)(bb) with an NVMe, 30s runtime
CPU0 perf domain spans 0-3 with 400MHz to 1400MHz
CPU4 perf domain spans 4-5 with 400MHz to 1800MHz

iouring6x128:
Sugov iowait boost:
Average frequency for CPU0 : 1.180 GHz
Average frequency for CPU4 : 1.504 GHz
Per-task tracking:
Average frequency for CPU0 : 0.858 GHz
Average frequency for CPU4 : 1.271 GHz

iouring12x128:
Sugov iowait boost:
Average frequency for CPU0 : 1.324 GHz
Average frequency for CPU4 : 1.444 GHz
Per-task tracking:
Average frequency for CPU0 : 0.962 GHz
Average frequency for CPU4 : 1.155 GHz
(In both cases actually 400MHz on both perf domains is possible, more
fine-tuning could get us closer. [2])

[1]
There are many scenarios when it doesn't, so let's start with
explaining when it does:
Boosting improves throughput if there is frequent IO to a device from
one or few origins, such that the device is likely idle when the task
is enqueued on the rq and reducing this time cuts down on the device
idle time.
This might not be true (and boosting doesn't help) if:
- The device uses the idle time to actually commit the IO to
persistent storage or do other management activity (this can be
observed with e.g. writes to flash-based storage, which will usually
write to cache and flush the cache when idle or necessary).
- The device is under thermal pressure and needs idle time to cool off
(not uncommon for e.g. nvme devices).
Furthermore the assumption (the device being idle while task is
enqueued) is false altogether if:
- Other tasks use the same device.
- The task uses asynchronous IO with iodepth > 1 like io_uring, the
in_iowait is then just to fill the queue on the host again.
- The task just sets in_iowait to signal it is waiting on io to not
appear as system idle, it might not send any io at all (cf. with
the various occurrences of in_iowait, io_mutex_lock, io_schedule*
and wait_for_*io*).

[3]
Unfortunately even for asynchronous IO iowait may be set, in the case
of io_uring this is specifically for the iowait boost to trigger, see
commit ("8a796565cec3 io_uring: Use io_schedule* in cqring wait")
which is why the energy-savings are so significant here, as io_uring
load on the CPU is minimal.

Problems encountered:
- Higher cap is not always beneficial, we might place the task away
from the CPU where the interrupt handler is running, making it run
on an unboosted CPU which may have a bigger impact than the difference
between the CPU's capacity the task moved to. (Of course the boost will
then be reverted again, but a ping-pong every interval is possible).
- [2] tracking and scaling can be improved (io_uring12 still shows
boosting): Unfortunately tracking purely per-task shows some limits.
One task might show more iowaits per second when boosted, but overall
throughput doesn't increase => there is still some boost.
The task throughput improvement is somewhat limited though,
so by fine-tuning the thresholds there could be mitigations.

v1 discussion:
https://lore.kernel.org/lkml/20240304201625.100619-1-christian.loehle@arm.com/

Changes since v1:
- Rebase onto 6.9
- Range from reducing the level to increasing depends on the total number
of iowaits now. (io_boost_threshold())
- Fixed bug at io_boost_level reduce.
- Removed open-coding for task placement through uclamp_eff_value()
- Move most of the logic into sugov.
- Added a mechanism to maintain boost when boosted task is not on the rq.
v1 relied on rate_limit_us being high enough to maintain the boost.
Thereby also removing the rq max-aggregation and its atomic update.
This is implemented by the most recent io boost being held, which
works well enough in practice to not warrant anything like a rolling
window tracking of recent io boosts at the rq.
- Benchmark numbers all taken with direct and none as io scheduler to
address Bart's comments. Also removed most benchmarks for now as
discussion from v1 suggested to ignore single completion-queue systems,
as they are more and more becoming a thing of the past.

v1 reviews not (yet) addressed:
- Qais would prefer the logic to take affect during actual in_iowait flag
setting, instead of enqueue/dequeue, that is a bit awkward as of now, as
in_iowait is being set both through various wrappers and directly.
This might change though:
https://lore.kernel.org/lkml/20240416121526.67022-1-axboe@kernel.dk/
Until then moving the cpufreq_update_util shouldn't be a problem anymore,
it doesn't depend on enqueue/dequeue (actually at context_switch, the
currently present hack can be removed.)
(context is
https://lore.kernel.org/lkml/20240516204802.846520-1-qyousef@layalina.io/
I assume. The patch is written with the context-switch update in mind
and will be a lot cleaner if that precedes it.)
- UFS device with multi-completion queue benchmarks (Bart):
Sorry haven't gotten my hands on one I can experiment nicely with.
- Peter's comments about the design of the tracking.
I agree that it's complexity is hard to swallow, but "iowait wakeup" is
very little information to work with. I don't see a way that provides
us with some inference on whether the boost was effective and worth
keeping (while still being reasonably on par with previous sugov iowait
boosting performance and an acceptable ramp-up time).
The current design must evolve if we want to do per-task tracking and
therefore already necessarily comes with increased complexity that
needs to be justified, the proposed design at least adds potential
power-savings during IO workloads as a benefit.

Christian Loehle (1):
  sched/fair: sugov: Introduce per-task io util boost

 include/linux/sched.h            |  10 ++
 kernel/sched/core.c              |   8 +-
 kernel/sched/cpufreq_schedutil.c | 258 ++++++++++++++++++++-----------
 kernel/sched/fair.c              |  37 +++--
 kernel/sched/sched.h             |  10 +-
 5 files changed, 218 insertions(+), 105 deletions(-)

--
2.34.1


