Return-Path: <io-uring+bounces-1195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3820F8872A4
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 19:09:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5C9BE1C21953
	for <lists+io-uring@lfdr.de>; Fri, 22 Mar 2024 18:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CD9627EA;
	Fri, 22 Mar 2024 18:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i2M4bAgB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E6E626C4
	for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 18:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711130952; cv=none; b=FE4NIvFJ8g2OigGkfNKHxOc5JlWZRYW1+7JJbKovaxegwgCBvkvW0j5r+heIE9iXp+EYutMoVHw+SUZmsATmJq5dOjTZVxdvxVEiMPMZcaLao5yAYBzaONQEDhlOWufTudkUXHUz24Y2v7TInmybBLG5T3rM2JnjDs81BqS4TJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711130952; c=relaxed/simple;
	bh=V9qH8Hqz75lvC7fcWia7IDuZ4H/IPMayPvgEtvd7OTs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LT4ABkjfYy4RM8oxFrzqXtNV+Neyd2L2qTmWJi9Aqjw9h8bpuP4S84UWI8NYS3JzHHLtNfmxEx7dCTKlzB3aRS968lLHwtvCuhayUEkZ1FmyMjq9gZEH8Bl8qBM5CtgJP/3eyDryumXAF1KkbPTMhzagZTpxzYuAbdlaLJecKb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i2M4bAgB; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-29c731ba369so1672161a91.3
        for <io-uring@vger.kernel.org>; Fri, 22 Mar 2024 11:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711130949; x=1711735749; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zIDjLYOAoTtitEy2EbjJ+uIGL56wEX/Yq/x0rNRFB3U=;
        b=i2M4bAgBNQxkmaX8jGphlRkkWXonoOaEDsSYqkW2jk+rT/WX3E1vhkb2kVARZlp5JJ
         rCb1v2VRXuqjy+ech3mE0VMYbou2ueaZjI53AbialqLjR0fIQJUWDbXwOuASbVIeMzny
         GSJGCGUgCHv5Cms28rh07Hko6oC47VjscajjOD1Gayn/ElZOeJwm2tjRmAcjKkmPyj1l
         Eij4vNKs1cmwe4XzJCxcOgvK9+s/GREzXZAW6a0LrFgzZ/KQHtlW4lj6Ij/aGZtYo/ft
         vFgwp4TytamQA2NzA5Pg+PsLTowGBVjt/9JAu04mczq6TVkDTu2VLaQQa5y98uwwZzYS
         fC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711130949; x=1711735749;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zIDjLYOAoTtitEy2EbjJ+uIGL56wEX/Yq/x0rNRFB3U=;
        b=gR8QYvC5qjdf6pGUaMdpo6yOC3bs04xhziczCZvJmIOhPX4c7IBKwHGjGYxVKuNnAT
         4iBzhMC12RJEjktitPHP7ogoFWWwIZx/v2OeXIUBot5yBAeN135DRw4FYQIv5rTHW3za
         v1YDAFtsrlur112A8Gm/fq1aUG12t00GpJ//aN4KT8DqKt3oENAlE1h1FV+6Gb5IBw+Y
         H+VCmEu8heN+TgN+EXqyj4l5kZIYKq+x68v12HgQ0YkZe34dgmDdCTCh2qP8rvfIruDw
         L71BIStJBdJREcFN1DBJaap3QAe6Vi/bFcG7aDwwDZIypjnFidbGCXA1xEcFFMsdonyD
         bxeQ==
X-Forwarded-Encrypted: i=1; AJvYcCXmfaW3zlowq6arjZ9OmVsn+35q1CXQkMWPGRO8dXRFqdjRXfHFbikephGUTNBdYgPxQQ1sc7keR6Ocwyi+cxIrxA2syT7b9S8=
X-Gm-Message-State: AOJu0Yz7N2jSCWbVB/SMePLzzEUKyAvbPEzDq6R8WWwRFB6nY3O3OyWg
	hWtYVNf1VrD2/Ahu0OrlTa0wzIT5sE1kae+qBiOG+tJ/JHsCx/0DggI4EJWTfyp3hQ9J1afHi2y
	X9BbuNyWeouilRKIz8NKgngIdbstQzLUuD1EcOeeJyPVpxsYE
X-Google-Smtp-Source: AGHT+IGvJlKqALa9BjwZx4qwm/OSmLcvHiP8qUMTEcDuG2KQ4oqXk1Hb1cBcfDxOS0fa1yC5aZyttjpfCb1shzfhtG4=
X-Received: by 2002:a17:90b:37ce:b0:29b:c0a5:1143 with SMTP id
 nc14-20020a17090b37ce00b0029bc0a51143mr430917pjb.29.1711130949112; Fri, 22
 Mar 2024 11:09:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240304201625.100619-1-christian.loehle@arm.com>
In-Reply-To: <20240304201625.100619-1-christian.loehle@arm.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Fri, 22 Mar 2024 19:08:57 +0100
Message-ID: <CAKfTPtDcTXBosFpu6vYW_cXLGwnqJqYCUW19XyxRmAc233irqA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Introduce per-task io utilization boost
To: Christian Loehle <christian.loehle@arm.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, juri.lelli@redhat.com, 
	mingo@redhat.com, rafael@kernel.org, dietmar.eggemann@arm.com, 
	vschneid@redhat.com, Johannes.Thumshirn@wdc.com, adrian.hunter@intel.com, 
	ulf.hansson@linaro.org, andres@anarazel.de, asml.silence@gmail.com, 
	linux-pm@vger.kernel.org, linux-block@vger.kernel.org, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Christian,

On Mon, 4 Mar 2024 at 21:17, Christian Loehle <christian.loehle@arm.com> wrote:
>
> There is a feature inside of both schedutil and intel_pstate called
> iowait boosting which tries to prevent selecting a low frequency
> during IO workloads when it impacts throughput.
> The feature is implemented by checking for task wakeups that have
> the in_iowait flag set and boost the CPU of the rq accordingly
> (implemented through cpufreq_update_util(rq, SCHED_CPUFREQ_IOWAIT)).
>
> The necessity of the feature is argued with the potentially low
> utilization of a task being frequently in_iowait (i.e. most of the
> time not enqueued on any rq and cannot build up utilization).
>
> The RFC focuses on the schedutil implementation.
> intel_pstate frequency selection isn't touched for now, suggestions are
> very welcome.
> Current schedutil iowait boosting has several issues:
> 1. Boosting happens even in scenarios where it doesn't improve
> throughput. [1]
> 2. The boost is not accounted for in EAS: a) feec() will only consider
>  the actual utilization for task placement, but another CPU might be
>  more energy-efficient at that capacity than the boosted one.)
>  b) When placing a non-IO task while a CPU is boosted compute_energy()
>  will not consider the (potentially 'free') boosted capacity, but the
>  one it would have without the boost (since the boost is only applied
>  in sugov).
> 3. Actual IO heavy workloads are hardly distinguished from infrequent
> in_iowait wakeups.
> 4. The boost isn't associated with a task, it therefore isn't considered
> for task placement, potentially missing out on higher capacity CPUs on
> heterogeneous CPU topologies.
> 5. The boost isn't associated with a task, it therefore lingers on the
> rq even after the responsible task has migrated / stopped.
> 6. The boost isn't associated with a task, it therefore needs to ramp
> up again when migrated.
> 7. Since schedutil doesn't know which task is getting woken up,
> multiple unrelated in_iowait tasks might lead to boosting.
>
> We attempt to mitigate all of the above by reworking the way the
> iowait boosting (io boosting from here on) works in two major ways:
> - Carry the boost in task_struct, so it is a per-task attribute and
> behaves similar to utilization of the task in some ways.
> - Employ a counting-based tracking strategy that only boosts as long
> as it sees benefits and returns to no boosting dynamically.

Thanks for working on improving IO boosting. I have started to read
your patchset and have few comments about your proposal:

The main one is that the io boosting decision should remain a cpufreq
governor decision and so the io boosting value should be applied by
the governor like in sugov_effective_cpu_perf() as an example instead
of everywhere in the scheduler code.

Then, the algorithm to track the right interval bucket and the mapping
of intervals into utilization really looks like a policy which has
been defined with heuristics and as a result further seems to be a
governor decision

Finally adding some atomic operation in the fast path is not really desirable

I will continue to review your patchset

>
> Note that some the issues (1, 3) can be solved by using a
> counting-based strategy on a per-rq basis, i.e. in sugov entirely.
> Experiments with Android in particular showed that such a strategy
> (which necessarily needs longer intervals to be reasonably stable)
> is too prone to migrations to be useful generally.
> We therefore consider the additional complexity of such a per-task
> based approach like proposed to be worth it.
>
> We require a minimum of 1000 iowait wakeups per second to start
> boosting.
> This isn't too far off from what sugov currently does, since it resets
> the boost if it hasn't seen an iowait wakeup for TICK_NSEC.
> For CONFIG_HZ=1000 we are on par, for anything below we are stricter.
> We justify this by the small possible improvement by boosting in the
> first place with 'rare' few iowait wakeups.
>
> When IO even leads to a task being in iowait isn't as straightforward
> to explain.
> Of course if the issued IO can be served by the page cache (e.g. on
> reads because the pages are contained, on writes because they can be
> marked dirty and the writeback takes care of it later) the actual
> issuing task is usually not in iowait.
> We consider this the good case, since whenever the scheduler and a
> potential userspace / kernel switch is in the critical path for IO
> there is possibly overhead impacting throughput.
> We therefore focus on random read from here on, because (on synchronous
> IO [3]) this will lead to the task being set in iowait for every IO.
> This is where iowait boosting shows its biggest throughput improvement.
> From here on IOPS (IO operations per second) and iowait wakeups may
> therefore be used interchangeably.
>
> Performance:
> Throughput for random read tries to be on par with the sugov
> implementation of iowait boosting for reasonably long-lived workloads.
> See the following table for some results, values are in IOPS, the
> tests are ran for 30s with pauses in-between, results are sorted.
>
> nvme on rk3399
> [3588, 3590, 3597, 3632, 3745] sugov mainline
> [3581, 3751, 3770, 3771, 3885] per-task tracking
> [2592, 2639, 2701, 2717, 2784] sugov no iowait boost
> [3218, 3451, 3598, 3848, 3921] performance governor
>
> emmc with cqe on rk3399
> [4146, 4155, 4159, 4161, 4193] sugov mainline
> [2848, 3217, 4375, 4380, 4454] per-task tracking
> [2510, 2665, 3093, 3101, 3105] sugov no iowait boost
> [4690, 4803, 4860, 4976, 5069] performance governor
>
> sd card on rk3399
> [1777, 1780, 1806, 1827, 1850] sugov mainline
> [1470, 1476, 1507, 1534, 1586] per-task tracking
> [1356, 1372, 1373, 1377, 1416] sugov no iowait boost
> [1861, 1890, 1901, 1905, 1908] performance governor
>
> Pixel 6 ufs Android 14 (7 runs for because device showed some variance)
> [6605, 6622, 6633, 6652, 6690, 6697, 6754] sugov mainline
> [7141, 7173, 7198, 7220, 7280, 7427, 7452] per-task tracking
> [2390, 2392, 2406, 2437, 2464, 2487, 2813] sugov no iowait boost
> [7812, 7837, 7837, 7851, 7900, 7959, 7980] performance governor
>
> Apple M1 apple-nvme
> [27421, 28331, 28515, 28699, 29529] sugov mainline
> [27274, 27344, 27345, 27384, 27930] per-task tracking
> [14480, 14512, 14625, 14872, 14967] sugov no iowait boost
> [31595, 32085, 32386, 32465, 32643] performance governor
>
> Showcasing some different IO scenarios, again all random read,
> median out of 5 runs, all on rk3399 with NVMe.
> e.g. io_uring6x4 means 6 threads with 4 iodepth each, results can be
> obtained using:
> fio --minimal --time_based --name=test --filename=/dev/nvme0n1 --runtime=30 --rw=randread --bs=4k --ioengine=io_uring --iodepth=4 --numjobs=6 --group_reporting | cut -d \; -f 8
>
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |               | Sugov mainline | Per-task tracking | Sugov no boost | Performance | Powersave |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |       psyncx1 |           4073 |              3793 |           2979 |        4190 |      2788 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |       psyncx4 |          13921 |             13503 |          10635 |       13931 |     10225 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |       psyncx6 |          18473 |             17866 |          15902 |       19080 |     15789 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |       psyncx8 |          22498 |             21242 |          19867 |       22650 |     18837 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |      psyncx10 |          24801 |             23552 |          23658 |       25096 |     21474 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |      psyncx12 |          26743 |             25377 |          26372 |       26663 |     23613 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |     libaio1x1 |           4054 |              3542 |           2776 |        4055 |      2780 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |   libaio1x128 |           3959 |              3516 |           2758 |        3590 |      2560 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |   libaio4x128 |          13451 |             12517 |          10313 |       13403 |      9994 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |     libaio6x1 |          18394 |             17432 |          15340 |       18954 |     15251 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |     libaio6x4 |          18329 |             17100 |          15238 |       18623 |     15270 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |   libaio6x128 |          18066 |             16964 |          15139 |       18577 |     15192 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |   io_uring1x1 |           4043 |              3548 |           2810 |        4039 |      2689 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |  io_uring4x64 |          35790 |             32814 |          35983 |       34934 |     33254 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> | io_uring1x128 |          32651 |             30427 |          32429 |       33232 |      9973 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> | io_uring2x128 |          34928 |             32595 |          34922 |       33726 |     18790 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> | io_uring4x128 |          34414 |             32173 |          34932 |       33332 |     33005 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> |   io_uring6x4 |          31578 |             29260 |          31714 |       31399 |     31784 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
> | io_uring6x128 |          34480 |             32634 |          34973 |       33390 |     36452 |
> +---------------+----------------+-------------------+----------------+-------------+-----------+
>
> Based on the above we can basically categorize these into the following
> three:
> a) boost is useful
> b) boost irrelevant (util dominates)
> c) boost is energy-inefficient (boost dominates)
>
> The aim of the patch 1/2 is to boost as much as necessary for a) while
> boosting little for c) (thus saving energy).
>
> Energy-savings:
> Regarding sugov iowait boosting problem 1 mentioned earlier,
> some improvement can be seen:
> Tested on rk3399 (LLLL)(bb) with an NVMe, 30s runtime
> CPU0 perf domain spans 0-3 with 400MHz to 1400MHz
> CPU4 perf domain spans 4-5 with 400MHz to 1800MHz
>
> io_uring6x128:
> Sugov iowait boost:
> Average frequency for CPU0 : 1.180 GHz
> Average frequency for CPU4 : 1.504 GHz
> Per-task tracking:
> Average frequency for CPU0 : 1.070 GHz
> Average frequency for CPU4 : 1.211 GHz
>
> io_uring12x128:
> Sugov iowait boost:
> Average frequency for CPU0 : 1.324 GHz
> Average frequency for CPU4 : 1.444 GHz
> Per-task tracking:
> Average frequency for CPU0 : 1.260 GHz
> Average frequency for CPU4 : 1.062 GHz
> (In both cases actually 400MHz on both perf domains is optimal, more
> fine-tuning could get us closer [2])
>
> [1]
> There are many scenarios when it doesn't, so let's start with
> explaining when it does:
> Boosting improves throughput if there is frequent IO to a device from
> one or few origins, such that the device is likely idle when the task
> is enqueued on the rq and reducing this time cuts down on the storage
> device idle time.
> This might not be true (and boosting doesn't help) if:
> - The storage device uses the idle time to actually commit the IO to
> persistent storage or do other management activity (this can be
> observed with e.g. writes to flash-based storage, which will usually
> write to cache and flush the cache when idle or necessary).
> - The device is under thermal pressure and needs idle time to cool off
> (not uncommon for e.g. nvme devices).
> Furthermore the assumption (the device being idle while task is
> enqueued) is false altogether if:
> - Other tasks use the same storage device.
> - The task uses asynchronous IO with iodepth > 1 like io_uring, the
> in_iowait is then just to fill the queue on the host again.
> - The task just sets in_iowait to signal it is waiting on io to not
> appear as system idle, it might not send any io at all (cf with
> the various occurrences of in_iowait, io_mutex_lock and io_schedule*).
>
> [3]
> Unfortunately even for asynchronous IO iowait may be set, in the case
> of io_uring this is specifically for the iowait boost to trigger, see
> commit ("8a796565cec3 io_uring: Use io_schedule* in cqring wait")
> which is why the energy-savings are so significant here, as io_uring
> load on the CPU is minimal.
>
> Problems encountered:
> - Higher cap is not always beneficial, we might place the task away
> from the CPU where the interrupt handler is running, making it run
> on an unboosted CPU which may have a bigger impact than the difference
> between the CPU's capacity the task moved to. (Of course the boost will
> then be reverted again, but a ping-pong every interval is possible).
> - [2] tracking and scaling can be improved (io_uring12x128 still shows
> boosting): Unfortunately tracking purely per-task shows some limits.
> One task might show more iowaits per second when boosted, but overall
> throughput doesn't increase => there is still some boost.
> The task throughput improvement is somewhat limited though,
> so by fine-tuning the thresholds there could be mitigations.
>
> Christian Loehle (2):
>   sched/fair: Introduce per-task io util boost
>   cpufreq/schedutil: Remove iowait boost
>
>  include/linux/sched.h            |  15 +++
>  kernel/sched/cpufreq_schedutil.c | 150 ++--------------------------
>  kernel/sched/fair.c              | 165 +++++++++++++++++++++++++++++--
>  kernel/sched/sched.h             |   4 +-
>  4 files changed, 182 insertions(+), 152 deletions(-)
>
> --
> 2.34.1
>

