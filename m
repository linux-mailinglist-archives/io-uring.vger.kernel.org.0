Return-Path: <io-uring+bounces-13812-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XV6tHFAcOWoFnAcAu9opvQ
	(envelope-from <io-uring+bounces-13812-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 13:28:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id D52B06AF0F7
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 13:28:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP5vIVfj;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13812-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13812-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F1F130166E4
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 11:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FC53A5E64;
	Mon, 22 Jun 2026 11:27:49 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF753A4F47;
	Mon, 22 Jun 2026 11:27:47 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782127669; cv=none; b=eVZH/Zgg4diWX7A/vL3ZM6uOVUNs8pT0j/SkTQFOGa4nttJDYAzZ1tNHNj9BbowU657N/sBrd02KpbdAMq5ICKU1evE98i+LuoBSxd/vJjNFw0Uz6vDHy+31UMYdiFcaOkPb/LZe/PAd5h7L01K8P8lvZ2ZREaTEPDNsWLbGh+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782127669; c=relaxed/simple;
	bh=N/vuDHI9SQW1janB0j5sO1lsg3p3zPSFITHHbgn1I9o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N6BSQiUlze+NFvrkVh5/fninGhgV2NrV1roGLM0qGbypx0hb7Z0Kf/1BM9MBGcyUjr8tbjJqaA7Tg4JzDhDs5ZyVqzzLxKsB7548qWFBecXGhk6lOxjaf7mAlCtlp1XBCsQfx+aPtIXP0JU5aLOwIuhHjj9lxRfMN1yAk95Q6zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NP5vIVfj; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AED81F000E9;
	Mon, 22 Jun 2026 11:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782127667;
	bh=CxKnwWbJ6o3Gp2gCYHflIyVCw0BGlYpweEWWlR7Zxlc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NP5vIVfjsp4feyIcuAfoiRvYPwPZKLTXzyb0N0wUNoKxJZDnW14mB+Ksso1zMBEZX
	 fUxTpjrKClw00GwNOT/ge4xL2rriBHbh5PxOP732GJlaoArFBmxyEOXdYsklIEobB9
	 /pFQVIcOni9/exs8OPh0iGTCF0YrB1elReGRM0Pk+0VV64ksMWO5Yff5O4AFlcbETU
	 7oQHcuU8AyNBq9zKQ3Q/5sFiPWawUkfJJPp52WQ+UesWgVbFX7LlIhxh77+4lU8xhN
	 0Mxv8uME2L+nRo7wVhECL6694CE+9AKg1Xt97qlcIjmOAoH39Xw4JyyfVaAkL3HiaO
	 P5VjuChOEJC/w==
Message-ID: <8f98a3a6-f97b-4673-964f-fb09c8879e2e@kernel.org>
Date: Mon, 22 Jun 2026 13:27:34 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13812-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:alexei.starovoitov@gmail.com,m:kaitao.cheng@linux.dev,m:akpm@linux-foundation.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org
 ,m:linux-trace-kernel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:alexeistarovoitov@gmail.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,linux.dev];
	FORGED_SENDER(0.00)[david@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCPT_COUNT_GT_50(0.00)[52];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[david@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D52B06AF0F7

On 6/22/26 07:28, Alexei Starovoitov wrote:
> On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>
>> From: chengkaitao <chengkaitao@kylinos.cn>
>>
>> The list_for_each*_safe() helpers are used when the loop body may remove
>> the current entry.  Their current interface, however, forces every caller
>> to define a temporary cursor outside the macro and pass it in, even when
>> the caller never uses that cursor directly.  For most call sites this
>> extra cursor is just boilerplate required by the macro implementation.
>>
>> This is awkward because the saved next pointer is an internal detail of
>> the iteration.  Callers that only remove or move the current entry do not
>> need to spell it out.
>>
>> The _safe() suffix has also caused confusion.  Christian Koenig pointed
>> out that the name is easy to read as a thread-safe variant, especially
>> for beginners, even though it only means that the iterator keeps enough
>> state to tolerate removal of the current entry.  He suggested _mutable()
>> as a clearer description of what the loop permits.
>>
>> Add *_mutable() iterator variants for list, hlist and llist.  The new
>> helpers are variadic and support both forms.  In the common case, the
>> caller omits the temporary cursor and the macro creates a unique internal
>> cursor with typeof(pos) and __UNIQUE_ID().  If a loop really needs an
>> explicit temporary cursor, the caller can still pass it and the helper
>> keeps the existing *_safe() behaviour.
>>
>> For example, a call site may use the shorter form:
>>
>>   list_for_each_entry_mutable(pos, head, member)
>>
>> or keep the explicit temporary cursor form:
>>
>>   list_for_each_entry_mutable(pos, tmp, head, member)
>>
>> The existing *_safe() helpers remain available for compatibility.  This
>> series only converts users in mm, block, kernel, init and io_uring.  If
>> this approach looks acceptable, the remaining users can be converted in
>> follow-up series.
>>
>> Changes in v3 (Christian König, Andy Shevchenko):
>> - Convert safe list walks to mutable iterators
>>
>> Changes in v2 (Muchun Song, Andy Shevchenko):
>> - Drop the list_for_each_entry_mutable*() helpers from v1 and make the
>>   cursor change directly in the existing list_for_each_entry*() helpers.
>> - Open-code special list walks that rely on updating the loop cursor in
>>   the body, preserving their existing traversal semantics.
>>
>> Link to v2:
>> https://lore.kernel.org/all/20260609061347.93688-1-kaitao.cheng@linux.dev/
>>
>> Link to v1:
>> https://lore.kernel.org/all/20260529082149.76764-1-kaitao.cheng@linux.dev/
>>
>> Kaitao Cheng (7):
>>   list: Add mutable iterator variants
>>   llist: Add mutable iterator variants
>>   mm: Use mutable list iterators
>>   block: Use mutable list iterators
>>   kernel: Use mutable list iterators
>>   initramfs: Use mutable list iterator
>>   io_uring: Use mutable list iterators
>>
>>  block/bfq-iosched.c                 |  17 +-
>>  block/blk-cgroup.c                  |  12 +-
>>  block/blk-flush.c                   |   4 +-
>>  block/blk-iocost.c                  |  18 +-
>>  block/blk-mq.c                      |   8 +-
>>  block/blk-throttle.c                |   4 +-
>>  block/kyber-iosched.c               |   4 +-
>>  block/partitions/ldm.c              |   8 +-
>>  block/sed-opal.c                    |   4 +-
>>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
>>  include/linux/llist.h               |  81 +++++++--
>>  init/initramfs.c                    |   5 +-
>>  io_uring/cancel.c                   |   6 +-
>>  io_uring/poll.c                     |   3 +-
>>  io_uring/rw.c                       |   4 +-
>>  io_uring/timeout.c                  |   8 +-
>>  io_uring/uring_cmd.c                |   3 +-
>>  kernel/audit_tree.c                 |   4 +-
>>  kernel/audit_watch.c                |  16 +-
>>  kernel/auditfilter.c                |   4 +-
>>  kernel/auditsc.c                    |   4 +-
>>  kernel/bpf/arena.c                  |  10 +-
>>  kernel/bpf/arraymap.c               |   8 +-
>>  kernel/bpf/bpf_local_storage.c      |   3 +-
>>  kernel/bpf/bpf_lru_list.c           |  25 ++-
>>  kernel/bpf/btf.c                    |  18 +-
>>  kernel/bpf/cgroup.c                 |   7 +-
>>  kernel/bpf/cpumap.c                 |   4 +-
>>  kernel/bpf/devmap.c                 |  10 +-
>>  kernel/bpf/helpers.c                |   8 +-
>>  kernel/bpf/local_storage.c          |   4 +-
>>  kernel/bpf/memalloc.c               |  16 +-
>>  kernel/bpf/offload.c                |   8 +-
>>  kernel/bpf/states.c                 |   4 +-
>>  kernel/bpf/stream.c                 |   4 +-
>>  kernel/bpf/verifier.c               |   6 +-
>>  kernel/cgroup/cgroup-v1.c           |   4 +-
>>  kernel/cgroup/cgroup.c              |  54 +++---
>>  kernel/cgroup/dmem.c                |  12 +-
>>  kernel/cgroup/rdma.c                |   8 +-
>>  kernel/events/core.c                |  44 +++--
>>  kernel/events/uprobes.c             |  12 +-
>>  kernel/exit.c                       |   8 +-
>>  kernel/fail_function.c              |   4 +-
>>  kernel/gcov/clang.c                 |   4 +-
>>  kernel/irq_work.c                   |   4 +-
>>  kernel/kexec_core.c                 |   4 +-
>>  kernel/kprobes.c                    |  16 +-
>>  kernel/livepatch/core.c             |   4 +-
>>  kernel/livepatch/core.h             |   4 +-
>>  kernel/liveupdate/kho_block.c       |   4 +-
>>  kernel/liveupdate/luo_flb.c         |   4 +-
>>  kernel/locking/rwsem.c              |   2 +-
>>  kernel/locking/test-ww_mutex.c      |   2 +-
>>  kernel/module/main.c                |  11 +-
>>  kernel/padata.c                     |   4 +-
>>  kernel/power/snapshot.c             |   8 +-
>>  kernel/power/wakelock.c             |   4 +-
>>  kernel/printk/printk.c              |  11 +-
>>  kernel/ptrace.c                     |   4 +-
>>  kernel/rcu/rcutorture.c             |   3 +-
>>  kernel/rcu/tasks.h                  |   9 +-
>>  kernel/rcu/tree.c                   |   6 +-
>>  kernel/resource.c                   |   4 +-
>>  kernel/sched/core.c                 |   4 +-
>>  kernel/sched/ext.c                  |  22 +--
>>  kernel/sched/fair.c                 |  28 +--
>>  kernel/sched/topology.c             |   4 +-
>>  kernel/sched/wait.c                 |   4 +-
>>  kernel/seccomp.c                    |   4 +-
>>  kernel/signal.c                     |  11 +-
>>  kernel/smp.c                        |   4 +-
>>  kernel/taskstats.c                  |   8 +-
>>  kernel/time/clockevents.c           |   6 +-
>>  kernel/time/clocksource.c           |   4 +-
>>  kernel/time/posix-cpu-timers.c      |   4 +-
>>  kernel/time/posix-timers.c          |   3 +-
>>  kernel/torture.c                    |   3 +-
>>  kernel/trace/bpf_trace.c            |   4 +-
>>  kernel/trace/ftrace.c               |  49 +++--
>>  kernel/trace/ring_buffer.c          |  25 ++-
>>  kernel/trace/trace.c                |  12 +-
>>  kernel/trace/trace_dynevent.c       |   6 +-
>>  kernel/trace/trace_dynevent.h       |   5 +-
>>  kernel/trace/trace_events.c         |  35 ++--
>>  kernel/trace/trace_events_filter.c  |   4 +-
>>  kernel/trace/trace_events_hist.c    |   8 +-
>>  kernel/trace/trace_events_trigger.c |  17 +-
>>  kernel/trace/trace_events_user.c    |  16 +-
>>  kernel/trace/trace_stat.c           |   4 +-
>>  kernel/user-return-notifier.c       |   3 +-
>>  kernel/workqueue.c                  |  16 +-
>>  mm/backing-dev.c                    |   8 +-
>>  mm/balloon.c                        |   8 +-
>>  mm/cma.c                            |   4 +-
>>  mm/compaction.c                     |   4 +-
>>  mm/damon/core.c                     |   4 +-
>>  mm/damon/sysfs-schemes.c            |   4 +-
>>  mm/dmapool.c                        |   4 +-
>>  mm/huge_memory.c                    |   8 +-
>>  mm/hugetlb.c                        |  56 +++---
>>  mm/hugetlb_vmemmap.c                |  16 +-
>>  mm/khugepaged.c                     |  14 +-
>>  mm/kmemleak.c                       |   7 +-
>>  mm/ksm.c                            |  25 +--
>>  mm/list_lru.c                       |   4 +-
>>  mm/memcontrol-v1.c                  |   8 +-
>>  mm/memory-failure.c                 |  12 +-
>>  mm/memory-tiers.c                   |   4 +-
>>  mm/migrate.c                        |  23 ++-
>>  mm/mmu_notifier.c                   |   9 +-
>>  mm/page_alloc.c                     |   8 +-
>>  mm/page_reporting.c                 |   2 +-
>>  mm/percpu.c                         |  11 +-
>>  mm/pgtable-generic.c                |   4 +-
>>  mm/rmap.c                           |  10 +-
>>  mm/shmem.c                          |   9 +-
>>  mm/slab_common.c                    |  14 +-
>>  mm/slub.c                           |  33 ++--
>>  mm/swapfile.c                       |   4 +-
>>  mm/userfaultfd.c                    |  12 +-
>>  mm/vmalloc.c                        |  24 +--
>>  mm/vmscan.c                         |   7 +-
>>  mm/zsmalloc.c                       |   4 +-
>>  124 files changed, 875 insertions(+), 681 deletions(-)
> 
> Not sure what you were thinking, but this diff stat
> is not landable.

Agreed. If we decide we want this, I guess we should target per-subsystem
conversions.

If this goes through the MM tree, I would even appreciate doing this on a per-MM
component granularity.

(unless we have some magic "Linus converts all of them" script, which I doubt we
will have)

Is there a way forward to replace list_for_each_*_safe entirely, possibly just
reusing the old name but simply the parameter?

-- 
Cheers,

David

