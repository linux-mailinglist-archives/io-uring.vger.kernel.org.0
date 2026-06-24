Return-Path: <io-uring+bounces-13827-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lQa1DlvVO2rLdwgAu9opvQ
	(envelope-from <io-uring+bounces-13827-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:02:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BBDE6BE62F
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 15:02:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NfHfWAOU;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13827-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13827-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8D68830448CA
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2026 12:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456C93B6BFD;
	Wed, 24 Jun 2026 12:59:27 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E812F3B47D7
	for <io-uring@vger.kernel.org>; Wed, 24 Jun 2026 12:59:24 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782305967; cv=none; b=DIeYcut9g5ZtsF+Wx18kgIpadkvrjNXex90oYw9lGo28eSO7xzWO1R94lFaqH4GSwc9xuYYMCfcxjDmM5oNL+mAVptWu0n/KuWirYiD/R3YFl3nm+jatTL4agRW0Qa2TvfvduV7AZrpy43gQ1YWRLuArvACfaFS5976zEbftQGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782305967; c=relaxed/simple;
	bh=Hp21DabkdJmBrm5olpg71oNYzii2pCB3Ctg0A3bYMZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mjk6g1RoVFmyfu+F9wlV1mox+rwt4eNP7vLwQr+9SVXlfWf7YRfUSX3zvJRsYGDhJeeyii2rLOT4zGTcfVMqaK6KZ4bHnXaVzAWyXxvZ/PKOmL+obLdtZwGNkNp4R4afAQNj/6m2CaZSdddYbfa55MRElJeUueFx3V6mgCsId5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NfHfWAOU; arc=none smtp.client-ip=95.215.58.181
Message-ID: <dbfce6fd-1a70-49e4-84f0-f8abe0b0686d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782305952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7mwncPJFc52L9GcJuLCemWszY1t/5oa8NDDGKNs5Xo=;
	b=NfHfWAOUjme+ZS3K2cqW3zzBU9DDghXYBUACVwF1DP1IhHC7OpK5Dg+VG056EyHSeeXnq+
	d2hck8f1B4+5aF6WEjOXUu98tizJ3d/dkoetmJwOT+C8sRL9MoCoWbRSgtT56dE5GZhUKK
	23iu6/01orE+jSg9Lvj5Ccw4UnfNStE=
Date: Wed, 24 Jun 2026 20:58:49 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Paul Moore <paul@paul-moore.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 "Paul E. McKenney" <paulmck@kernel.org>,
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
 chengkaitao <chengkaitao@kylinos.cn>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
 <8f98a3a6-f97b-4673-964f-fb09c8879e2e@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <8f98a3a6-f97b-4673-964f-fb09c8879e2e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13827-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:david@kernel.org,m:alexei.starovoitov@gmail.com,m:akpm@linux-foundation.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:lin
 ux-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:alexeistarovoitov@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FREEMAIL_TO(0.00)[kernel.org,gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,linux.dev:dkim,linux.dev:email,linux.dev:mid,linux.dev:from_mime,vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5BBDE6BE62F



在 2026/6/22 19:27, David Hildenbrand (Arm) 写道:
> On 6/22/26 07:28, Alexei Starovoitov wrote:
>> On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>
>>> From: chengkaitao <chengkaitao@kylinos.cn>
>>>
>>> The list_for_each*_safe() helpers are used when the loop body may remove
>>> the current entry.  Their current interface, however, forces every caller
>>> to define a temporary cursor outside the macro and pass it in, even when
>>> the caller never uses that cursor directly.  For most call sites this
>>> extra cursor is just boilerplate required by the macro implementation.
>>>
>>> This is awkward because the saved next pointer is an internal detail of
>>> the iteration.  Callers that only remove or move the current entry do not
>>> need to spell it out.
>>>
>>> The _safe() suffix has also caused confusion.  Christian Koenig pointed
>>> out that the name is easy to read as a thread-safe variant, especially
>>> for beginners, even though it only means that the iterator keeps enough
>>> state to tolerate removal of the current entry.  He suggested _mutable()
>>> as a clearer description of what the loop permits.
>>>
>>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>>> helpers are variadic and support both forms.  In the common case, the
>>> caller omits the temporary cursor and the macro creates a unique internal
>>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>>> explicit temporary cursor, the caller can still pass it and the helper
>>> keeps the existing *_safe() behaviour.
>>>
>>> For example, a call site may use the shorter form:
>>>
>>>   list_for_each_entry_mutable(pos, head, member)
>>>
>>> or keep the explicit temporary cursor form:
>>>
>>>   list_for_each_entry_mutable(pos, tmp, head, member)
>>>
>>> The existing *_safe() helpers remain available for compatibility.  This
>>> series only converts users in mm, block, kernel, init and io_uring.  If
>>> this approach looks acceptable, the remaining users can be converted in
>>> follow-up series.
>>>
>>> Changes in v3 (Christian König, Andy Shevchenko):
>>> - Convert safe list walks to mutable iterators
>>>
>>> Changes in v2 (Muchun Song, Andy Shevchenko):
>>> - Drop the list_for_each_entry_mutable*() helpers from v1 and make the
>>>   cursor change directly in the existing list_for_each_entry*() helpers.
>>> - Open-code special list walks that rely on updating the loop cursor in
>>>   the body, preserving their existing traversal semantics.
>>>
>>> Link to v2:
>>> https://lore.kernel.org/all/20260609061347.93688-1-kaitao.cheng@linux.dev/
>>>
>>> Link to v1:
>>> https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/
>>>
>>> Kaitao Cheng (7):
>>>   list: Add mutable iterator variants
>>>   llist: Add mutable iterator variants
>>>   mm: Use mutable list iterators
>>>   block: Use mutable list iterators
>>>   kernel: Use mutable list iterators
>>>   initramfs: Use mutable list iterator
>>>   io_uring: Use mutable list iterators
>>>
>>>  block/bfq-iosched.c                 |  17 +-
>>>  block/blk-cgroup.c                  |  12 +-
>>>  block/blk-flush.c                   |   4 +-
>>>  block/blk-iocost.c                  |  18 +-
>>>  block/blk-mq.c                      |   8 +-
>>>  block/blk-throttle.c                |   4 +-
>>>  block/kyber-iosched.c               |   4 +-
>>>  block/partitions/ldm.c              |   8 +-
>>>  block/sed-opal.c                    |   4 +-
>>>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>>>  include/linux/llist.h               |  81 +++++++--
>>>  init/initramfs.c                    |   5 +-
>>>  io_uring/cancel.c                   |   6 +-
>>>  io_uring/poll.c                     |   3 +-
>>>  io_uring/rw.c                       |   4 +-
>>>  io_uring/timeout.c                  |   8 +-
>>>  io_uring/uring_cmd.c                |   3 +-
>>>  kernel/audit_tree.c                 |   4 +-
>>>  kernel/audit_watch.c                |  16 +-
>>>  kernel/auditfilter.c                |   4 +-
>>>  kernel/auditsc.c                    |   4 +-
>>>  kernel/bpf/arena.c                  |  10 +-
>>>  kernel/bpf/arraymap.c               |   8 +-
>>>  kernel/bpf/bpf_local_storage.c      |   3 +-
>>>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>>>  kernel/bpf/btf.c                    |  18 +-
>>>  kernel/bpf/cgroup.c                 |   7 +-
>>>  kernel/bpf/cpumap.c                 |   4 +-
>>>  kernel/bpf/devmap.c                 |  10 +-
>>>  kernel/bpf/helpers.c                |   8 +-
>>>  kernel/bpf/local_storage.c          |   4 +-
>>>  kernel/bpf/memalloc.c               |  16 +-
>>>  kernel/bpf/offload.c                |   8 +-
>>>  kernel/bpf/states.c                 |   4 +-
>>>  kernel/bpf/stream.c                 |   4 +-
>>>  kernel/bpf/verifier.c               |   6 +-
>>>  kernel/cgroup/cgroup-v1.c           |   4 +-
>>>  kernel/cgroup/cgroup.c              |  54 +++---
>>>  kernel/cgroup/dmem.c                |  12 +-
>>>  kernel/cgroup/rdma.c                |   8 +-
>>>  kernel/events/core.c                |  44 +++--
>>>  kernel/events/uprobes.c             |  12 +-
>>>  kernel/exit.c                       |   8 +-
>>>  kernel/fail_function.c              |   4 +-
>>>  kernel/gcov/clang.c                 |   4 +-
>>>  kernel/irq_work.c                   |   4 +-
>>>  kernel/kexec_core.c                 |   4 +-
>>>  kernel/kprobes.c                    |  16 +-
>>>  kernel/livepatch/core.c             |   4 +-
>>>  kernel/livepatch/core.h             |   4 +-
>>>  kernel/liveupdate/kho_block.c       |   4 +-
>>>  kernel/liveupdate/luo_flb.c         |   4 +-
>>>  kernel/locking/rwsem.c              |   2 +-
>>>  kernel/locking/test-ww_mutex.c      |   2 +-
>>>  kernel/module/main.c                |  11 +-
>>>  kernel/padata.c                     |   4 +-
>>>  kernel/power/snapshot.c             |   8 +-
>>>  kernel/power/wakelock.c             |   4 +-
>>>  kernel/printk/printk.c              |  11 +-
>>>  kernel/ptrace.c                     |   4 +-
>>>  kernel/rcu/rcutorture.c             |   3 +-
>>>  kernel/rcu/tasks.h                  |   9 +-
>>>  kernel/rcu/tree.c                   |   6 +-
>>>  kernel/resource.c                   |   4 +-
>>>  kernel/sched/core.c                 |   4 +-
>>>  kernel/sched/ext.c                  |  22 +--
>>>  kernel/sched/fair.c                 |  28 +--
>>>  kernel/sched/topology.c             |   4 +-
>>>  kernel/sched/wait.c                 |   4 +-
>>>  kernel/seccomp.c                    |   4 +-
>>>  kernel/signal.c                     |  11 +-
>>>  kernel/smp.c                        |   4 +-
>>>  kernel/taskstats.c                  |   8 +-
>>>  kernel/time/clockevents.c           |   6 +-
>>>  kernel/time/clocksource.c           |   4 +-
>>>  kernel/time/posix-cpu-timers.c      |   4 +-
>>>  kernel/time/posix-timers.c          |   3 +-
>>>  kernel/torture.c                    |   3 +-
>>>  kernel/trace/bpf_trace.c            |   4 +-
>>>  kernel/trace/ftrace.c               |  49 +++--
>>>  kernel/trace/ring_buffer.c          |  25 ++-
>>>  kernel/trace/trace.c                |  12 +-
>>>  kernel/trace/trace_dynevent.c       |   6 +-
>>>  kernel/trace/trace_dynevent.h       |   5 +-
>>>  kernel/trace/trace_events.c         |  35 ++--
>>>  kernel/trace/trace_events_filter.c  |   4 +-
>>>  kernel/trace/trace_events_hist.c    |   8 +-
>>>  kernel/trace/trace_events_trigger.c |  17 +-
>>>  kernel/trace/trace_events_user.c    |  16 +-
>>>  kernel/trace/trace_stat.c           |   4 +-
>>>  kernel/user-return-notifier.c       |   3 +-
>>>  kernel/workqueue.c                  |  16 +-
>>>  mm/backing-dev.c                    |   8 +-
>>>  mm/balloon.c                        |   8 +-
>>>  mm/cma.c                            |   4 +-
>>>  mm/compaction.c                     |   4 +-
>>>  mm/damon/core.c                     |   4 +-
>>>  mm/damon/sysfs-schemes.c            |   4 +-
>>>  mm/dmapool.c                        |   4 +-
>>>  mm/huge_memory.c                    |   8 +-
>>>  mm/hugetlb.c                        |  56 +++---
>>>  mm/hugetlb_vmemmap.c                |  16 +-
>>>  mm/khugepaged.c                     |  14 +-
>>>  mm/kmemleak.c                       |   7 +-
>>>  mm/ksm.c                            |  25 +--
>>>  mm/list_lru.c                       |   4 +-
>>>  mm/memcontrol-v1.c                  |   8 +-
>>>  mm/memory-failure.c                 |  12 +-
>>>  mm/memory-tiers.c                   |   4 +-
>>>  mm/migrate.c                        |  23 ++-
>>>  mm/mmu_notifier.c                   |   9 +-
>>>  mm/page_alloc.c                     |   8 +-
>>>  mm/page_reporting.c                 |   2 +-
>>>  mm/percpu.c                         |  11 +-
>>>  mm/pgtable-generic.c                |   4 +-
>>>  mm/rmap.c                           |  10 +-
>>>  mm/shmem.c                          |   9 +-
>>>  mm/slab_common.c                    |  14 +-
>>>  mm/slub.c                           |  33 ++--
>>>  mm/swapfile.c                       |   4 +-
>>>  mm/userfaultfd.c                    |  12 +-
>>>  mm/vmalloc.c                        |  24 +--
>>>  mm/vmscan.c                         |   7 +-
>>>  mm/zsmalloc.c                       |   4 +-
>>>  124 files changed, 875 insertions(+), 681 deletions(-)
>>
>> Not sure what you were thinking, but this diff stat
>> is not landable.
> 
> Agreed. If we decide we want this, I guess we should target per-subsystem
> conversions.
> 
> If this goes through the MM tree, I would even appreciate doing this on a per-MM
> component granularity.
> 
> (unless we have some magic "Linus converts all of them" script, which I doubt we
> will have)

I strongly agree with the point above.

> Is there a way forward to replace list_for_each_*_safe entirely, possibly just
> reusing the old name but simply the parameter?

David Laight, Christian König, and Jani Nikula do not agree with using
clever macro syntax to support both calling forms at the same time,
so for now it is not possible to keep the original macro name and only
simplify the parameter. I may revert to the v1 version and ask everyone
for their opinions again.

-- 
Thanks
Kaitao Cheng


