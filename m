Return-Path: <io-uring+bounces-13811-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id XvkbKUITOWqemQcAu9opvQ
	(envelope-from <io-uring+bounces-13811-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 12:49:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B9D76AEDBB
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 12:49:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=intel.com header.s=Intel header.b=nzU+mGOE;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13811-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13811-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6B5893009F3B
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 10:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7443A376BE8;
	Mon, 22 Jun 2026 10:46:38 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961B12E1746;
	Mon, 22 Jun 2026 10:46:36 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782125198; cv=none; b=dgZlRRYEwgCL3MepyIsJLbjvMQetRZGhD4GjIQtkoglAXK0Ii7sEy185/W7VwLFjDVPiYVOSIlWpQFjF2nBj+eGCJf+W/bYamDEXpjTpe+ZS2sb7w8e0jXIQWXPBPHLO+PCCBUfRIxQMEA9Muq+3ReNAsJEfLZIKImeBlpECDPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782125198; c=relaxed/simple;
	bh=/hKgAevfumO8x7LfebeUyLh/erlFr2Hmr9kpKNVbH0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RXODWZKElkwNYpFJonxchYxL7m7+buIIWgUiJMAD0MYfyKNwNMLSslVv6yBoc/HcLQI6ALqaWoX3hI7BUhDfYNAOp/d/O61d+5hIwFcf2eExAjaRh+yyxF4FlmXcJqP/2R2L+iPy0pH17SBJrNaylwgCZ4MV+XxvZHUJxlT/gKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nzU+mGOE; arc=none smtp.client-ip=192.198.163.9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782125197; x=1813661197;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=/hKgAevfumO8x7LfebeUyLh/erlFr2Hmr9kpKNVbH0Q=;
  b=nzU+mGOEqWcv1ZhOmQPh7A2Vpfo+LMNqc4tcIPxCOVAjg5E+B8987oJm
   CRk7qHz3x3v+O+oG7cXujRDkzL1gtlG6mhDITbvghfqBqcfJ18psAc+PI
   Tg6A1WV+wrBAYDeVjinRSZ8iVzEiuhmQJVGAURRe3kSmW2jMrs7sROlGE
   u8+D/V9jaSTcCF1v2EIm0ssuPCon5Qce2IQ+52WID3KKCx1hIbTl0AP50
   tBvVqFdniXMiI+R7HhzvDTzP1eZ59wlltT5mIxb+U8IVJjshC3XaerKJ+
   nuUFkH1Xgheje/msjZOEt2IJ3ymfBjkuClzZN1MPvQKC7KGcG7O1ntKDW
   A==;
X-CSE-ConnectionGUID: RGyONYQVSea0+pxWnZOPdg==
X-CSE-MsgGUID: tWucpBD+SQmz4hzgmxAYMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11824"; a="93506230"
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="93506230"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 03:46:35 -0700
X-CSE-ConnectionGUID: xNR2+KjtQLGBpSv9fyyNaQ==
X-CSE-MsgGUID: i0RzaMPlRGCEVMh1muYCuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,218,1774335600"; 
   d="scan'208";a="253099713"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO localhost) ([10.245.245.152])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2026 03:46:25 -0700
Date: Mon, 22 Jun 2026 13:46:22 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Paul Moore <paul@paul-moore.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	David Howells <dhowells@redhat.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Philipp Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	"open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>,
	linux-ntfs-dev@lists.sourceforge.net,
	Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
	io-uring <io-uring@vger.kernel.org>, audit@vger.kernel.org,
	bpf <bpf@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	"linux-perf-use." <linux-perf-users@vger.kernel.org>,
	linux-trace-kernel <linux-trace-kernel@vger.kernel.org>,
	kexec@lists.infradead.org, live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Power Management <linux-pm@vger.kernel.org>,
	rcu@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-mm <linux-mm@kvack.org>, virtualization@lists.linux.dev,
	damon@lists.linux.dev, clang-built-linux <llvm@lists.linux.dev>,
	chengkaitao <chengkaitao@kylinos.cn>,
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH v3 0/7] Prepare mutable list iterators to cache cursor
 state
Message-ID: <ajkSftEbdGoiJXYs@ashevche-desk.local>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
 <CAADnVQJmPWFT01b7DuLdtafv=8FyB84GYHNZ8zSTck+9Aw0JpA@mail.gmail.com>
 <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c8f1849-86d3-4c69-be27-30bbdffdf616@linux.dev>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[intel.com:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13811-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:kaitao.cheng@linux.dev,m:alexei.starovoitov@gmail.com,m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linux-trace-ke
 rnel@vger.kernel.org,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,m:muchun.song@linux.dev,m:alexeistarovoitov@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[andriy.shevchenko@linux.intel.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,linux-foundation.org,kernel.org,kernel.dk,zeniv.linux.org.uk,iogearbox.net,cmpxchg.org,infradead.org,redhat.com,linaro.org,paul-moore.com,linux.dev,amd.com,ffwll.ch,bootlin.com,vger.kernel.org,lists.sourceforge.net,lists.freedesktop.org,lists.infradead.org,lists.linux.dev,kvack.org,kylinos.cn];
	FORWARDED(0.00)[lists@lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[andriy.shevchenko@linux.intel.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_GT_50(0.00)[53];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	TO_DN_SOME(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9B9D76AEDBB

On Mon, Jun 22, 2026 at 02:15:01PM +0800, Kaitao Cheng wrote:
> 在 2026/6/22 13:28, Alexei Starovoitov 写道:
> > On Sun, Jun 21, 2026 at 9:06 PM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

...

> >>  block/bfq-iosched.c                 |  17 +-
> >>  block/blk-cgroup.c                  |  12 +-
> >>  block/blk-flush.c                   |   4 +-
> >>  block/blk-iocost.c                  |  18 +-
> >>  block/blk-mq.c                      |   8 +-
> >>  block/blk-throttle.c                |   4 +-
> >>  block/kyber-iosched.c               |   4 +-
> >>  block/partitions/ldm.c              |   8 +-
> >>  block/sed-opal.c                    |   4 +-
> >>  include/linux/list.h                | 269 ++++++++++++++++++++++++----
> >>  include/linux/llist.h               |  81 +++++++--
> >>  init/initramfs.c                    |   5 +-
> >>  io_uring/cancel.c                   |   6 +-
> >>  io_uring/poll.c                     |   3 +-
> >>  io_uring/rw.c                       |   4 +-
> >>  io_uring/timeout.c                  |   8 +-
> >>  io_uring/uring_cmd.c                |   3 +-
> >>  kernel/audit_tree.c                 |   4 +-
> >>  kernel/audit_watch.c                |  16 +-
> >>  kernel/auditfilter.c                |   4 +-
> >>  kernel/auditsc.c                    |   4 +-
> >>  kernel/bpf/arena.c                  |  10 +-
> >>  kernel/bpf/arraymap.c               |   8 +-
> >>  kernel/bpf/bpf_local_storage.c      |   3 +-
> >>  kernel/bpf/bpf_lru_list.c           |  25 ++-
> >>  kernel/bpf/btf.c                    |  18 +-
> >>  kernel/bpf/cgroup.c                 |   7 +-
> >>  kernel/bpf/cpumap.c                 |   4 +-
> >>  kernel/bpf/devmap.c                 |  10 +-
> >>  kernel/bpf/helpers.c                |   8 +-
> >>  kernel/bpf/local_storage.c          |   4 +-
> >>  kernel/bpf/memalloc.c               |  16 +-
> >>  kernel/bpf/offload.c                |   8 +-
> >>  kernel/bpf/states.c                 |   4 +-
> >>  kernel/bpf/stream.c                 |   4 +-
> >>  kernel/bpf/verifier.c               |   6 +-
> >>  kernel/cgroup/cgroup-v1.c           |   4 +-
> >>  kernel/cgroup/cgroup.c              |  54 +++---
> >>  kernel/cgroup/dmem.c                |  12 +-
> >>  kernel/cgroup/rdma.c                |   8 +-
> >>  kernel/events/core.c                |  44 +++--
> >>  kernel/events/uprobes.c             |  12 +-
> >>  kernel/exit.c                       |   8 +-
> >>  kernel/fail_function.c              |   4 +-
> >>  kernel/gcov/clang.c                 |   4 +-
> >>  kernel/irq_work.c                   |   4 +-
> >>  kernel/kexec_core.c                 |   4 +-
> >>  kernel/kprobes.c                    |  16 +-
> >>  kernel/livepatch/core.c             |   4 +-
> >>  kernel/livepatch/core.h             |   4 +-
> >>  kernel/liveupdate/kho_block.c       |   4 +-
> >>  kernel/liveupdate/luo_flb.c         |   4 +-
> >>  kernel/locking/rwsem.c              |   2 +-
> >>  kernel/locking/test-ww_mutex.c      |   2 +-
> >>  kernel/module/main.c                |  11 +-
> >>  kernel/padata.c                     |   4 +-
> >>  kernel/power/snapshot.c             |   8 +-
> >>  kernel/power/wakelock.c             |   4 +-
> >>  kernel/printk/printk.c              |  11 +-
> >>  kernel/ptrace.c                     |   4 +-
> >>  kernel/rcu/rcutorture.c             |   3 +-
> >>  kernel/rcu/tasks.h                  |   9 +-
> >>  kernel/rcu/tree.c                   |   6 +-
> >>  kernel/resource.c                   |   4 +-
> >>  kernel/sched/core.c                 |   4 +-
> >>  kernel/sched/ext.c                  |  22 +--
> >>  kernel/sched/fair.c                 |  28 +--
> >>  kernel/sched/topology.c             |   4 +-
> >>  kernel/sched/wait.c                 |   4 +-
> >>  kernel/seccomp.c                    |   4 +-
> >>  kernel/signal.c                     |  11 +-
> >>  kernel/smp.c                        |   4 +-
> >>  kernel/taskstats.c                  |   8 +-
> >>  kernel/time/clockevents.c           |   6 +-
> >>  kernel/time/clocksource.c           |   4 +-
> >>  kernel/time/posix-cpu-timers.c      |   4 +-
> >>  kernel/time/posix-timers.c          |   3 +-
> >>  kernel/torture.c                    |   3 +-
> >>  kernel/trace/bpf_trace.c            |   4 +-
> >>  kernel/trace/ftrace.c               |  49 +++--
> >>  kernel/trace/ring_buffer.c          |  25 ++-
> >>  kernel/trace/trace.c                |  12 +-
> >>  kernel/trace/trace_dynevent.c       |   6 +-
> >>  kernel/trace/trace_dynevent.h       |   5 +-
> >>  kernel/trace/trace_events.c         |  35 ++--
> >>  kernel/trace/trace_events_filter.c  |   4 +-
> >>  kernel/trace/trace_events_hist.c    |   8 +-
> >>  kernel/trace/trace_events_trigger.c |  17 +-
> >>  kernel/trace/trace_events_user.c    |  16 +-
> >>  kernel/trace/trace_stat.c           |   4 +-
> >>  kernel/user-return-notifier.c       |   3 +-
> >>  kernel/workqueue.c                  |  16 +-
> >>  mm/backing-dev.c                    |   8 +-
> >>  mm/balloon.c                        |   8 +-
> >>  mm/cma.c                            |   4 +-
> >>  mm/compaction.c                     |   4 +-
> >>  mm/damon/core.c                     |   4 +-
> >>  mm/damon/sysfs-schemes.c            |   4 +-
> >>  mm/dmapool.c                        |   4 +-
> >>  mm/huge_memory.c                    |   8 +-
> >>  mm/hugetlb.c                        |  56 +++---
> >>  mm/hugetlb_vmemmap.c                |  16 +-
> >>  mm/khugepaged.c                     |  14 +-
> >>  mm/kmemleak.c                       |   7 +-
> >>  mm/ksm.c                            |  25 +--
> >>  mm/list_lru.c                       |   4 +-
> >>  mm/memcontrol-v1.c                  |   8 +-
> >>  mm/memory-failure.c                 |  12 +-
> >>  mm/memory-tiers.c                   |   4 +-
> >>  mm/migrate.c                        |  23 ++-
> >>  mm/mmu_notifier.c                   |   9 +-
> >>  mm/page_alloc.c                     |   8 +-
> >>  mm/page_reporting.c                 |   2 +-
> >>  mm/percpu.c                         |  11 +-
> >>  mm/pgtable-generic.c                |   4 +-
> >>  mm/rmap.c                           |  10 +-
> >>  mm/shmem.c                          |   9 +-
> >>  mm/slab_common.c                    |  14 +-
> >>  mm/slub.c                           |  33 ++--
> >>  mm/swapfile.c                       |   4 +-
> >>  mm/userfaultfd.c                    |  12 +-
> >>  mm/vmalloc.c                        |  24 +--
> >>  mm/vmscan.c                         |   7 +-
> >>  mm/zsmalloc.c                       |   4 +-
> >>  124 files changed, 875 insertions(+), 681 deletions(-)
> > 
> > Not sure what you were thinking, but this diff stat
> > is not landable.
> 
> [PATCH v3 1/7] and [PATCH v3 2/7] contain the main logic and can
> be merged directly. They are also compatible with the old API.
> [PATCH v3 3/7] through [PATCH v3 7/7] are just simple interface
> replacements and do not change any functional logic. They can be
> left unmerged for now; individual modules can pick them up later
> if needed.
> 
> In v2, Andy Shevchenko mentioned: "If it's done by Linus himself
> during the day when he prepares -rc1, it's fine."

Yes, but you need to get his blessing first to go with this.
Have you communicated with him on this?

> Even so, the
> changes in this patch series are indeed quite large and touch
> almost every subsystem. I have only converted part of them for
> now, so I wanted to send this out first and see what people think.

That's why it's better to provide a script to convert (e.g., coccinelle)
instead of tons of patches.

-- 
With Best Regards,
Andy Shevchenko



