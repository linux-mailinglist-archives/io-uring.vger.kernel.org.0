Return-Path: <io-uring+bounces-3043-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8486B96D314
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 11:27:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 138081F22EF8
	for <lists+io-uring@lfdr.de>; Thu,  5 Sep 2024 09:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1F1195FCE;
	Thu,  5 Sep 2024 09:27:21 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2481192B94;
	Thu,  5 Sep 2024 09:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528440; cv=none; b=K351WTfgpg7bLCoGZ7MiGfSDdHmrGltyj6xTka/07PsIxAAMU8sNBaGubucsKmyrJSey2XMunRo1a4l/guq1nXWvRKAoHdCXOsS3GNan1k5FOP/g5SqzCOB+exzUF+29X2ZGuC1b0mvd6/h5FatLv0FHYslJFdyIeT3Fri4ZzA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528440; c=relaxed/simple;
	bh=Cis/wUq/EmY9mnCA1Jn9HK9UPgcA6gzMNb6SXRatAuw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZyFTIa8mp5hwzuw07v3dlsTZAHBDs0tImSCm6suSWjYTmANtBiXu4WLj4g6K6P5XlSc7ucw44SmoZr8eYY85rDJP75HZ5B7rs1jIyg6Ogd01ilXUixWPdER4acBwZIkwLYArcVr+xSSak6U2fDZr+bYwOYaNBHF7TGJmfLrG7+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F6AA1063;
	Thu,  5 Sep 2024 02:27:44 -0700 (PDT)
Received: from e127648.arm.com (unknown [10.57.75.86])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 24E8B3F73F;
	Thu,  5 Sep 2024 02:27:12 -0700 (PDT)
From: Christian Loehle <christian.loehle@arm.com>
To: linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rafael@kernel.org,
	peterz@infradead.org
Cc: juri.lelli@redhat.com,
	mingo@redhat.com,
	dietmar.eggemann@arm.com,
	vschneid@redhat.com,
	vincent.guittot@linaro.org,
	Johannes.Thumshirn@wdc.com,
	adrian.hunter@intel.com,
	ulf.hansson@linaro.org,
	bvanassche@acm.org,
	andres@anarazel.de,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	qyousef@layalina.io,
	dsmythies@telus.net,
	axboe@kernel.dk,
	Christian Loehle <christian.loehle@arm.com>
Subject: [RFT RFC PATCH 0/8] cpufreq: cpuidle: Remove iowait behaviour
Date: Thu,  5 Sep 2024 10:26:37 +0100
Message-Id: <20240905092645.2885200-1-christian.loehle@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I wanted to share my current status after working on the schedutil
iowait boost issue for a while now. This is what I consider the best
solution, happy for anyone to share thoughts and test results (it's
simply impossible to cover them all).
I'm hoping to remove some (bad) heuristics that have been in the kernel
for a long time and are seemingly impossible to evolve. Since the
introduction of these heuristics IO workloads have changed and those
heuristics can be removed while only really affecting synthetic
benchmarks.

A task can set the in_iowait flag before calling schedule() to indicate
that it is waiting for IO to complete (traditionally this was block IO
only).
Initially the reason for introducing the flag was almost cosmetic: To
distinguish a CPU idle system that has no tasks to run from a CPU idle
system that has tasks waiting for IO in order to continue running.

I have outlined the issues with the current iowait behaviour and
grouped them into: A) iowait as a performance metric, B) for cpuidle
specifically, C) for cpufreq specifically.

====== iowait for performance ======
Issues with using iowait as a performance metric:

1. The definition of iowait altogether is vague at best, it is
sprinkled across kernel code. Traditionally is for block io only but
grepping the tree for shows many counterexamples.
2. Not every IO task is performance-critical (consider writebacks).

====== cpuidle ======
In the cpuidle governor menu, the number of iowaiting tasks is used to
determine an interactivity requirement, the more tasks the CPU has with
with iowait set the shallower the state selected will be.

Relying on iowait for cpuidle is problematic for the following reasons:
1. There is no guarantee for an iowaiting task to be woken up on the
same CPU.
2. The task being in iowait says nothing about the idle duration, we
could be selecting shallower states for a long time.
3. The task being in iowait doesn't always imply a performance hit
with increased latency.
4. If there is such a performance hit, the number of iowaiting tasks
doesn't directly correlate.

The cpuidle governor teo shows that the reliance on using iowait isn't
critical to performance. So this series replaces menu with teo.

====== cpufreq ======
cpufreq governors had iowait-based behavior since a long time, the
initial git release in 2.6.12 with the ondemand governor already had
iowait_time essentially counting as busy time and thus increasing
frequency.
iowait boost in schedutil was introduced by
commit ("21ca6d2c52f8 cpufreq: schedutil: Add iowait boosting")
with it more or less following intel_pstate's approach.
Both intel_pstate and schedutil use the enqueueing of a (FAIR) task on
the rq to determine the boost. The more often a task that has iowait
set is enqueued the higher the applied boost.
The underlying problem is that while a task might only utilize the CPU
to a small degree (due to the task mostly blocking for IO), the time
in-between enqueue and dequeue might be critical to performance
(consider that a storage device has no outstanding requests in the
meantime and therefore is idling).
The low utilization will lead to a low frequency being selected and
thus the task's throughput being sub-optimal.
We call this the io utilization problem.

Relying on iowait wakeups for cpufreq is problematic for the following reasons:

1. Specifically for asynchronous or multi-threaded IO the assumption
that we are missing out on block device throughput because it is idling
isn't true. We are often boosting (to an inefficient) frequency just to
have another request in a queue.
2. It assumes a task that has waited on IO will send io requests in the
future.

There are additional schedutil-specific reasons listed in the patch.

====== Per-task iowait boosting ======
There is a general consensus that schedutil iowait boosting needed
to at least evolve.
Attempts of this have been made, mostly centered around associating the
boost to the task that is frequently being enqueued.

Unfortunately there are problems to this in addition to the ones
mentioned about iowait generally:

1. If the time a task is runnable (so between enqueue and dequeue) is
critical to throughput, so is the interrupt handling and the block
layer completion. For a simple fio example that goes to userspace and
back everytime even for a block device driver like nvme-pci that is
highly optimised, more than half of the time between io requests is
spent on the CPU without the task being enqueued. If the CPU is only
boosted for the time that the task is runnable, there is little gain.
For !MCQ devices we cannot assume the non-task part migrates with the
task, so migration even to a higher capacity CPU might not be
beneficial. (This is getting less important though with widespread
MCQ devices, see Bart's comments in [1].)
2. If the task benefits from boosting it will be very short-lived
(otherwise it would build up utilization on it's own), much shorter
than hardware can switch frequency, thus the boost won't be effective
until at least the next enqueue-dequeue cycle. Together with the
previous reason this means we have to hold the boosted frequency
even if the task is off the rq.
3. The increased complexity of implementation.

I don't think a per-task io boost strategy that is practical and
improves enough on the per-rq design. See my proposals [1] and the
OSPM24 discussion [2] about iowait boosting.

====== Performance impact ======
Overall performance impact will depend to some degree on the workload
and the platform.
Performance is compared for mainline menu and mainline teo with
schedutil with or without iowait boost.

----- Synthetic benchmark -----
The worst case is a simple fio benchmark with minimal time spend in
userspace and IOs issued sequentially back-to-back.
fio --minimal --time_based --name=fiotest --filename=/dev/nvme0n1 --runtime=30 --rw=randread --bs=4k --ioengine=psync --iodepth=1 --direct=1 | cut -f 8 -d ";"

The fio task will not exceed utilization for anything but the lowest
OPP being requested on an otherwise idle system.

On a RK3399 which has high latency incurring sleep states (reported as
state1:370us state2:900us, observed on average more like state1:50us
state2:100us) using teo can actually offset the performance loss
incurred by not using schedutil iowait boosting.

RK3399:
menu iowait boost
/dev/nvme0n1
[2584, 2622, 2629]
menu no iowait boost
/dev/nvme0n1
[2068, 2097, 2647]
teo iowait boost
/dev/nvme0n1
[4476, 4478, 4492]
teo no iowait boost
/dev/nvme0n1
[3728, 3733, 3737]

Menu despite the performance multiplier of iowait will often select a
deeper state even if the current workload makes these a worse choice
for both throughput and energy-efficiency.

On a M1 which has just state1 during which the hardware will power-gate
WFI which leads to exit latencies of 10us to 20us there is no gain due
to using teo, so a regression is visible altogether:

M1 Pro:
menu iowait boost
/dev/nvme0n1
[12780, 12788, 12790]
menu no iowait boost
/dev/nvme0n1
[8354, 8359, 8389]
teo iowait boost
/dev/nvme0n1
[12680, 12708, 12728]
teo no iowait boost
/dev/nvme0n1
[7981, 8005, 8093]

One can see the diminishing effect of iowait boosting, even for the synchronous
single-threaded case if the workload builds up utilization on it's own by using
the --thinkcycles fio parameter.

----- Benchmarks -----

Fortunately most real-world io workloads don't suffer from the io
utilization problem.
To illustrate here are a few, all done on the M1 Pro again.
All are run with default mmtests configs except for the filebench
ones where I have set FILEBENCH_MIN_THREADS=8 and
FILEBENCH_MAX_THREADS=16. M1 Pro has 8 CPUs.
The test are run with mainline menu and mainline teo and the sugov
iowait boost knob on or off:
menu + iowait_boost, menu - iowait_boost, teo + iowait_boost, teo - iowait_boost, menu + iowait_boost
The last column is to get a feel on the error margin of the test.

config-db-pgbench-timed-rw-large
pgbench Transactions
Hmean     1       726.68 (   0.00%)      713.79 (  -1.77%)      764.83 (   5.25%)      686.74 (  -5.50%)      715.22 (  -1.58%)
Hmean     4      2213.45 (   0.00%)     2302.69 (   4.03%)     2155.90 (  -2.60%)     2716.60 *  22.73%*     2099.55 (  -5.15%)
Hmean     7      3048.96 (   0.00%)     2530.59 * -17.00%*     2761.00 (  -9.44%)     2601.78 * -14.67%*     3967.59 *  30.13%*
Hmean     12     3223.91 (   0.00%)     3166.93 (  -1.77%)     3503.41 (   8.67%)     3122.70 (  -3.14%)     3228.43 (   0.14%)
Hmean     16     3510.04 (   0.00%)     3405.16 (  -2.99%)     3462.12 (  -1.37%)     3584.56 (   2.12%)     3476.20 (  -0.96%)

The multithreaded tests look good, the upper 3 aren't stable on this
platform IMV. I have seen pgbench run fine even for 1 and 4 with teo,
the original io_uring regression seemed to be from using menu.

config-io-blogbench
blogbench
Hmean     WriteScore    12060.71 (   0.00%)    12179.88 (   0.99%)    12155.41 (   0.79%)    11936.12 (  -1.03%)    12159.15 (   0.82%)
Hmean     ReadScore    206741.40 (   0.00%)   205900.19 (  -0.41%)   204815.61 (  -0.93%)   220167.94 (   6.49%)   207404.34 (   0.32%)

config-io-bonniepp-dir-async
bonnie Throughput
Hmean     SeqCreate ops        742.63 (   0.00%)      756.90 (   1.92%)      784.49 (   5.64%)      734.96 (  -1.03%)      762.66 (   2.70%)
Hmean     SeqCreate read       637.83 (   0.00%)      539.57 * -15.40%*      645.19 (   1.15%)      533.63 * -16.34%*      642.83 (   0.78%)
Hmean     SeqCreate del          0.00 (   0.00%)        0.00 (   0.00%)        0.00 (   0.00%)        0.00 (   0.00%)        0.00 (   0.00%)
Hmean     RandCreate ops      1456.37 (   0.00%)     1418.19 (  -2.62%)     1465.71 (   0.64%)     1484.20 (   1.91%)     1552.98 (   6.63%)
Hmean     RandCreate read      595.00 (   0.00%)      581.01 (  -2.35%)      563.78 (  -5.25%)      563.58 (  -5.28%)      562.95 (  -5.39%)

The SeqCreate read line looks like a ~15% regression wihout iowait boost.

config-io-filebench-varmail-medium
filebench
Hmean     varmail-8     27995.82 (   0.00%)    27463.93 (  -1.90%)    28341.78 (   1.24%)    27237.85 *  -2.71%*    28164.97 (   0.60%)
Hmean     varmail-16    42904.57 (   0.00%)    41633.66 *  -2.96%*    41641.88 *  -2.94%*    40831.48 *  -4.83%*    41756.76 (  -2.68%)

config-io-filebench-webproxy-medium
filebench
Hmean     webproxy-8    191686.03 (   0.00%)   190237.03 (  -0.76%)   192915.82 (   0.64%)   190706.94 (  -0.51%)   192282.81 (   0.31%)
Hmean     webproxy-16   181528.22 (   0.00%)   185743.13 *   2.32%*   185432.54 *   2.15%*   186597.08 *   2.79%*   183376.19 (   1.02%)

config-io-filebench-webserver-medium
filebench
Hmean     webserver-4     49974.72 (   0.00%)    44327.69 * -11.30%*    49498.08 (  -0.95%)    44223.22 * -11.51%*    50726.92 *   1.51%*
Hmean     webserver-6     73232.09 (   0.00%)    65999.99 *  -9.88%*    73396.77 (   0.22%)    65628.80 * -10.38%*    72996.77 (  -0.32%)
Hmean     webserver-12   149138.05 (   0.00%)   148735.35 (  -0.27%)   148853.11 (  -0.19%)   148119.96 *  -0.68%*   148458.42 (  -0.46%)

If threads < nr_cpus then there's a ~10% regression due to iowait boosting.

config-io-fio-io_uring-randread-direct
fio Throughput
Hmean     kb/sec-randread-read   459665.40 (   0.00%)   460498.37 (   0.18%)   442021.24 *  -3.84%*   449985.77 *  -2.11%*   459446.89 (  -0.05%)

Indicates a slight teo regression.

config-io-fsmark-xfsrepair
fsmark
Hmean     4-files/sec   203535.32 (   0.00%)   202487.47 (  -0.51%)   208261.00 (   2.32%)   211015.56 *   3.68%*   208432.18 *   2.41%*

config-workload-ebizzy
ebizzy Overall Throughput
Hmean     Rsec-1    112650.58 (   0.00%)   117498.40 (   4.30%)   112201.69 (  -0.40%)   112297.30 (  -0.31%)   111077.71 (  -1.40%)
Hmean     Rsec-3    413238.27 (   0.00%)   385083.09 (  -6.81%)   407349.16 (  -1.43%)   418227.30 (   1.21%)   418465.17 (   1.26%)
Hmean     Rsec-5    638089.98 (   0.00%)   637027.84 (  -0.17%)   637337.67 (  -0.12%)   639066.37 (   0.15%)   638654.41 (   0.09%)
Hmean     Rsec-7    761622.12 (   0.00%)   761506.36 (  -0.02%)   761725.47 (   0.01%)   760639.83 (  -0.13%)   761642.36 (   0.00%)
Hmean     Rsec-12   783093.40 (   0.00%)   765566.10 (  -2.24%)   786634.19 (   0.45%)   792604.59 (   1.21%)   796267.24 (   1.68%)
Hmean     Rsec-18   784677.51 (   0.00%)   783555.79 (  -0.14%)   785633.74 (   0.12%)   771189.93 (  -1.72%)   790559.21 (   0.75%)
Hmean     Rsec-24   779544.14 (   0.00%)   781893.47 (   0.30%)   777973.36 (  -0.20%)   776038.68 (  -0.45%)   775678.94 (  -0.50%)
Hmean     Rsec-30   757447.59 (   0.00%)   733989.03 (  -3.10%)   729435.88 (  -3.70%)   746541.43 (  -1.44%)   752617.47 (  -0.64%)
Hmean     Rsec-32   760912.43 (   0.00%)   773417.23 (   1.64%)   735356.71 (  -3.36%)   743558.83 (  -2.28%)   751862.45 (  -1.19%)

No obvious trend here, but since it was used a couple times for cpuidle
governor development in the past I did include it.


Note:
Technically the entire series saves some time on the enqueue path, that
is not reflected here as it's all measured with the sysfs knob.

====== RFT ======

The series is structured in a way to make bisecting easy in case of
regressions. Additionally I provided two test patches in schedutil to
cap the boost using a sysfs knob. In case there are regressions I would
be interested if setting a relatively low cap mitigates the issue.
I can provide a similar knob for intel_state if regressions are
reported that bisect to that.
Information about the CPU capacities / topology would be useful if it
bisects to the cpufreq changes, about the idle states if it bisects to
cpuidle respectively.

====== TODO ======

I haven't touched cpufreq_ondemand yet, that would need to be done as
well, but wanted to get some comments and/or testresults first.
should_io_be_busy() occurrences also still needs to be addressed.

[1]
v1 per-task io boost
https://lore.kernel.org/lkml/20240304201625.100619-1-christian.loehle@arm.com/
v2 per-task io boost
https://lore.kernel.org/lkml/20240518113947.2127802-2-christian.loehle@arm.com/
[2]
OSPM24 discussion iowait boosting
https://www.youtube.com/watch?v=MSQGEsSziZ4

Regards,
Christian

Christian Loehle (8):
  cpuidle: menu: Remove iowait influence
  cpuidle: Prefer teo over menu governor
  TEST: cpufreq/schedutil: Linear iowait boost step
  TEST: cpufreq/schedutil: iowait boost cap sysfs
  cpufreq/schedutil: Remove iowait boost
  cpufreq: intel_pstate: Remove iowait boost
  cpufreq: Remove SCHED_CPUFREQ_IOWAIT update
  io_uring: Do not set iowait before sleeping

 drivers/cpufreq/intel_pstate.c   |  50 +----------
 drivers/cpuidle/Kconfig          |   5 +-
 drivers/cpuidle/governors/menu.c |  78 +++--------------
 drivers/cpuidle/governors/teo.c  |   2 +-
 include/linux/sched/cpufreq.h    |   2 -
 io_uring/io_uring.c              |  17 ----
 kernel/sched/cpufreq_schedutil.c | 144 +------------------------------
 kernel/sched/fair.c              |   8 --
 8 files changed, 18 insertions(+), 288 deletions(-)

--
2.34.1


