Return-Path: <io-uring+bounces-13825-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id eTPfMgfPO2oOdggAu9opvQ
	(envelope-from <io-uring+bounces-13825-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 14:35:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2748F6BE2DE
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 14:35:19 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0l5uaRB;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13825-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13825-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 01B7F3080E5E
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 12:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9BEA3AEF5A;
	Wed, 24 Jun 2026 12:30:11 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFD1399CFC
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 12:30:09 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782304211; cv=none; b=E3bQ6AZFG/Dc2EDtpcGMe2y4e6tAxdZhqoKe5MJfZLLgVxPsMuTF8Xey5rjfQnwIzYAFW5M+F5AlL9eV3amSLUTxHd0RSKCqPrHwBptihqr4qoZZA+25zK+z90T+DZL6bmkYGb/LSbspu5sdT15Tfo6JaWc4WQkF3N9vf9x70sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782304211; c=relaxed/simple;
	bh=x+wrByIgOH4VvEI96gvWujAPl3WM8xGYqVOhtQGJNvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uD29StXT8KBuXsAVFLCZPlkAZexRlAMcVcNZ2gTb0dsqLkPU3wtnAPiAfpOL0xNKL5cbaJ/iLfxA/nuZxDiruel64fMc7E7MHrOh98SxNNiq5ckdfHOFCUe8jBH1D3CEjUHtaXEGAC+SCB/2Iz1dXC1SEUr0fC/QyH7qlEqm+Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=R0l5uaRB; arc=none smtp.client-ip=95.215.58.180
Message-ID: <f99b70cc-e11c-42a9-a986-d20b3f232a31@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782304195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eNfuHxO86n8b93ev9jYNFJxXkathlRXlXpz1k/8S9nI=;
	b=R0l5uaRBMcxiN2aXXeE7sJmbbWZ+nIwvYOIBg2hW4xeZNywWJj11l3PcvXG3Ip7YlbinqT
	P/PQ6kfAvOv13VlW7fdMv2tpC85uXP91R5VJRz9HOOc6aZfnOL/SuWOVvCXI8elJq6bVmX
	Hq88NW9qj4aWnLm21y4nDBq7fAgYa9M=
Date: Wed, 24 Jun 2026 20:29:26 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 David Howells <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>,
 Randy Dunlap <rdunlap@infradead.org>,
 Luca Ceresoli <luca.ceresoli@bootlin.com>,
 Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>,
 "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
 linux-ntfs-dev@lists.sourceforge.net,
 Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
 io-uring <io-uring@vger.kernel.org>, audit@vger.kernel.org,
 bpf <bpf@vger.kernel.org>, Network Development <netdev@vger.kernel.org>,
 dri-devel@lists.freedesktop.org,
 "linux-perf-use." <linux-perf-users@vger.kernel.org>,
 linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Linux Power Management <linux-pm@vger.kernel.org>, rcu@vger.kernel.org,
 sched-ext@lists.linux.dev, linux-mm <linux-mm@kvack.org>,
 virtualization@lists.linux.dev, damon@lists.linux.dev,
 clang-built-linux <llvm@lists.linux.dev>,
 chengkaitao <chengkaitao@kylinos.cn>, Muchun Song <muchun.song@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
 <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
 <ajkSftEbdGoiJXYs@ashevche-desk.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <ajkSftEbdGoiJXYs@ashevche-desk.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13825-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:andriy.shevchenko@linux.intel.com,m:alexei.starovoitov@gmail.com,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:lin
 ux-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:muchun.song@linux.dev,m:alexeistarovoitov@gmail.com,s:lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,linux-foundation.org,kernel.org,kernel.dk,zeniv.linux.org.uk,iogearbox.net,cmpxchg.org,infradead.org,redhat.com,linaro.org,paul-moore.com,linux.dev,amd.com,ffwll.ch,bootlin.com,vger.kernel.org,lists.sourceforge.net,lists.freedesktop.org,lists.infradead.org,lists.linux.dev,kvack.org,kylinos.cn];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[53];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2748F6BE2DE



在 2026/6/22 18:46, Andy Shevchenko 写道:
> On Mon, Jun 22, 2026 at 02:15:01PM +0800, Kaitao Cheng wrote:
>> 在 2026/6/22 13:28, Alexei Starovoitov 写道:
>>> On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
> ...
> 
>>>>  block/bfq-iosched.c                 |  17 +-
>>>>  block/blk-cgroup.c                  |  12 +-
>>>>  block/blk-flush.c                   |   4 +-
>>>>  block/blk-iocost.c                  |  18 +-
>>>>  block/blk-mq.c                      |   8 +-
>>>>  block/blk-throttle.c                |   4 +-
>>>>  block/kyber-iosched.c               |   4 +-
>>>>  block/partitions/ldm.c              |   8 +-
>>>>  block/sed-opal.c                    |   4 +-
>>>>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>>>>  include/linux/llist.h               |  81 +++++++--
>>>>  init/initramfs.c                    |   5 +-
>>>>  io_uring/cancel.c                   |   6 +-
>>>>  io_uring/poll.c                     |   3 +-
>>>>  io_uring/rw.c                       |   4 +-
>>>>  io_uring/timeout.c                  |   8 +-
>>>>  io_uring/uring_cmd.c                |   3 +-
>>>>  kernel/audit_tree.c                 |   4 +-
>>>>  kernel/audit_watch.c                |  16 +-
>>>>  kernel/auditfilter.c                |   4 +-
>>>>  kernel/auditsc.c                    |   4 +-
>>>>  kernel/bpf/arena.c                  |  10 +-
>>>>  kernel/bpf/arraymap.c               |   8 +-
>>>>  kernel/bpf/bpf_local_storage.c      |   3 +-
>>>>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>>>>  kernel/bpf/btf.c                    |  18 +-
>>>>  kernel/bpf/cgroup.c                 |   7 +-
>>>>  kernel/bpf/cpumap.c                 |   4 +-
>>>>  kernel/bpf/devmap.c                 |  10 +-
>>>>  kernel/bpf/helpers.c                |   8 +-
>>>>  kernel/bpf/local_storage.c          |   4 +-
>>>>  kernel/bpf/memalloc.c               |  16 +-
>>>>  kernel/bpf/offload.c                |   8 +-
>>>>  kernel/bpf/states.c                 |   4 +-
>>>>  kernel/bpf/stream.c                 |   4 +-
>>>>  kernel/bpf/verifier.c               |   6 +-
>>>>  kernel/cgroup/cgroup-v1.c           |   4 +-
>>>>  kernel/cgroup/cgroup.c              |  54 +++---
>>>>  kernel/cgroup/dmem.c                |  12 +-
>>>>  kernel/cgroup/rdma.c                |   8 +-
>>>>  kernel/events/core.c                |  44 +++--
>>>>  kernel/events/uprobes.c             |  12 +-
>>>>  kernel/exit.c                       |   8 +-
>>>>  kernel/fail_function.c              |   4 +-
>>>>  kernel/gcov/clang.c                 |   4 +-
>>>>  kernel/irq_work.c                   |   4 +-
>>>>  kernel/kexec_core.c                 |   4 +-
>>>>  kernel/kprobes.c                    |  16 +-
>>>>  kernel/livepatch/core.c             |   4 +-
>>>>  kernel/livepatch/core.h             |   4 +-
>>>>  kernel/liveupdate/kho_block.c       |   4 +-
>>>>  kernel/liveupdate/luo_flb.c         |   4 +-
>>>>  kernel/locking/rwsem.c              |   2 +-
>>>>  kernel/locking/test-ww_mutex.c      |   2 +-
>>>>  kernel/module/main.c                |  11 +-
>>>>  kernel/padata.c                     |   4 +-
>>>>  kernel/power/snapshot.c             |   8 +-
>>>>  kernel/power/wakelock.c             |   4 +-
>>>>  kernel/printk/printk.c              |  11 +-
>>>>  kernel/ptrace.c                     |   4 +-
>>>>  kernel/rcu/rcutorture.c             |   3 +-
>>>>  kernel/rcu/tasks.h                  |   9 +-
>>>>  kernel/rcu/tree.c                   |   6 +-
>>>>  kernel/resource.c                   |   4 +-
>>>>  kernel/sched/core.c                 |   4 +-
>>>>  kernel/sched/ext.c                  |  22 +--
>>>>  kernel/sched/fair.c                 |  28 +--
>>>>  kernel/sched/topology.c             |   4 +-
>>>>  kernel/sched/wait.c                 |   4 +-
>>>>  kernel/seccomp.c                    |   4 +-
>>>>  kernel/signal.c                     |  11 +-
>>>>  kernel/smp.c                        |   4 +-
>>>>  kernel/taskstats.c                  |   8 +-
>>>>  kernel/time/clockevents.c           |   6 +-
>>>>  kernel/time/clocksource.c           |   4 +-
>>>>  kernel/time/posix-cpu-timers.c      |   4 +-
>>>>  kernel/time/posix-timers.c          |   3 +-
>>>>  kernel/torture.c                    |   3 +-
>>>>  kernel/trace/bpf_trace.c            |   4 +-
>>>>  kernel/trace/ftrace.c               |  49 +++--
>>>>  kernel/trace/ring_buffer.c          |  25 ++-
>>>>  kernel/trace/trace.c                |  12 +-
>>>>  kernel/trace/trace_dynevent.c       |   6 +-
>>>>  kernel/trace/trace_dynevent.h       |   5 +-
>>>>  kernel/trace/trace_events.c         |  35 ++--
>>>>  kernel/trace/trace_events_filter.c  |   4 +-
>>>>  kernel/trace/trace_events_hist.c    |   8 +-
>>>>  kernel/trace/trace_events_trigger.c |  17 +-
>>>>  kernel/trace/trace_events_user.c    |  16 +-
>>>>  kernel/trace/trace_stat.c           |   4 +-
>>>>  kernel/user-return-notifier.c       |   3 +-
>>>>  kernel/workqueue.c                  |  16 +-
>>>>  mm/backing-dev.c                    |   8 +-
>>>>  mm/balloon.c                        |   8 +-
>>>>  mm/cma.c                            |   4 +-
>>>>  mm/compaction.c                     |   4 +-
>>>>  mm/damon/core.c                     |   4 +-
>>>>  mm/damon/sysfs-schemes.c            |   4 +-
>>>>  mm/dmapool.c                        |   4 +-
>>>>  mm/huge_memory.c                    |   8 +-
>>>>  mm/hugetlb.c                        |  56 +++---
>>>>  mm/hugetlb_vmemmap.c                |  16 +-
>>>>  mm/khugepaged.c                     |  14 +-
>>>>  mm/kmemleak.c                       |   7 +-
>>>>  mm/ksm.c                            |  25 +--
>>>>  mm/list_lru.c                       |   4 +-
>>>>  mm/memcontrol-v1.c                  |   8 +-
>>>>  mm/memory-failure.c                 |  12 +-
>>>>  mm/memory-tiers.c                   |   4 +-
>>>>  mm/migrate.c                        |  23 ++-
>>>>  mm/mmu_notifier.c                   |   9 +-
>>>>  mm/page_alloc.c                     |   8 +-
>>>>  mm/page_reporting.c                 |   2 +-
>>>>  mm/percpu.c                         |  11 +-
>>>>  mm/pgtable-generic.c                |   4 +-
>>>>  mm/rmap.c                           |  10 +-
>>>>  mm/shmem.c                          |   9 +-
>>>>  mm/slab_common.c                    |  14 +-
>>>>  mm/slub.c                           |  33 ++--
>>>>  mm/swapfile.c                       |   4 +-
>>>>  mm/userfaultfd.c                    |  12 +-
>>>>  mm/vmalloc.c                        |  24 +--
>>>>  mm/vmscan.c                         |   7 +-
>>>>  mm/zsmalloc.c                       |   4 +-
>>>>  124 files changed, 875 insertions(+), 681 deletions(-)
>>>
>>> Not sure what you were thinking, but this diff stat
>>> is not landable.
>>
>> [PATCH v3 1/7] and [PATCH v3 2/7] contain the main logic and can
>> be merged directly. They are also compatible with the old API.
>> [PATCH v3 3/7] through [PATCH v3 7/7] are just simple interface
>> replacements and do not change any functional logic. They can be
>> left unmerged for now; individual modules can pick them up later
>> if needed.
>>
>> In v2, Andy Shevchenko mentioned: "If it's done by Linus himself
>> during the day when he prepares -rc1, it's fine."
> 
> Yes, but you need to get his blessing first to go with this.
> Have you communicated with him on this?

Not yet, because the overall approach is still not mature. People
have different opinions on the implementation details and on how
to move this forward, so I think we should iterate through a few
versions first before making a final decision.

>> Even so, the
>> changes in this patch series are indeed quite large and touch
>> almost every subsystem. I have only converted part of them for
>> now, so I wanted to send this out first and see what people think.
> 
> That's why it's better to provide a script to convert (e.g., coccinelle)
> instead of tons of patches.

I tried writing conversion scripts with Coccinelle, but there were
always cases that got missed. In contrast, I found that using AI
for focused replacements was actually more efficient.

As David Hildenbrand mentioned, "If we decide we want this, I guess
we should target per-subsystem conversions." I would like to provide
the new interface first; adapting each subsystem on demand later may
be easier to achieve.
-- 
Thanks
Kaitao Cheng


