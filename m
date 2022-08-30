Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4805A6F76
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 23:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231738AbiH3Vt2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 17:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiH3Vt1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 17:49:27 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6618A8E9A7
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:25 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-32a115757b6so190457837b3.13
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 14:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc;
        bh=1lX3k8bH6+3ighIlH+rh55fF9o5O4fyOugMRXdd7M+o=;
        b=TLaJItWbDQbvhKHzG038LNGm0CScYZSKmwQZZ5uimu3NF1cUdVRiMphTcTUfMFGxbA
         5MXDa00pC4jx1dox6rXbqMWBtWC4G64n3rtvQ9WFmciJtHtJLVCWET5Kdb7EyuzkVYPX
         i4J0Y6C4bz8XfJq1YpoTofkF51DS5zPKbupPaaT66wch8+NkTWL2E1S5s0ZkHIotLxVb
         lHmExQmnrBRVXZ4L6czz/14NhyHQZKxDWFmpYXVuNp5UTUZUPBV0MZqwCFaN6+K53hjG
         Et4iC4dnJNUgJmAGWozRlGh2FkpEq40YiSSTQfp1Q8IZTvSW9ersWg+tDXVZ8w+7HE/r
         XOYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc;
        bh=1lX3k8bH6+3ighIlH+rh55fF9o5O4fyOugMRXdd7M+o=;
        b=CBVqOJ+tdU0BjY/KxVm+SOTDkYNRkTPGrY6ufBjnFjbmKXGWAT4g0sic1lDSQasCfN
         xXsrqj4mdiz05XAugXBafwRPBIurCQPPZx3S/wHSbj7qSOWfIVfmgSEtN1sB99WnAEda
         4hopmrW246cl4MrY6hjF89QjjNaDp3AkKa0KXpHI9GTjvfs5gClhrlLu3wIbkcTsX189
         MAc1EpnEC3c5Zv2FFwIzSNMUE+L5aqsUwdHYggp8Sx1wmiZaCNKYrk4XRvvY75mP2K4C
         dShDT801zvxrwJz18n6bO4Q9n+yz+ebTeTJe4NTNeLSHwVe33yRv9vBVO86vzR4656J0
         K9ng==
X-Gm-Message-State: ACgBeo1FhejmdqPEPuPV1WTVtcBsZj9jJ6udtdF3LuqQ8n1gcUbBtF3J
        z6qNuQd2aJWQ4SGWYNweJh98pH3iC04=
X-Google-Smtp-Source: AA6agR5j08Skk81v71QmaDi/WT6bCECv+zqPYuRoUXIcSYHRwqbk8VPDDLd37sGsnmTNsd8iQzIrOAzDMtY=
X-Received: from surenb-desktop.mtv.corp.google.com ([2620:15c:211:200:a005:55b3:6c26:b3e4])
 (user=surenb job=sendgmr) by 2002:a81:7992:0:b0:336:8015:4889 with SMTP id
 u140-20020a817992000000b0033680154889mr16036203ywc.80.1661896164558; Tue, 30
 Aug 2022 14:49:24 -0700 (PDT)
Date:   Tue, 30 Aug 2022 14:48:49 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220830214919.53220-1-surenb@google.com>
Subject: [RFC PATCH 00/30] Code tagging framework and applications
From:   Suren Baghdasaryan <surenb@google.com>
To:     akpm@linux-foundation.org
Cc:     kent.overstreet@linux.dev, mhocko@suse.com, vbabka@suse.cz,
        hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de,
        dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com,
        void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com,
        ldufour@linux.ibm.com, peterx@redhat.com, david@redhat.com,
        axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org,
        nathan@kernel.org, changbin.du@intel.com, ytcoode@gmail.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, bristot@redhat.com,
        vschneid@redhat.com, cl@linux.com, penberg@kernel.org,
        iamjoonsoo.kim@lge.com, 42.hyeyoo@gmail.com, glider@google.com,
        elver@google.com, dvyukov@google.com, shakeelb@google.com,
        songmuchun@bytedance.com, arnd@arndb.de, jbaron@akamai.com,
        rientjes@google.com, minchan@google.com, kaleshsingh@google.com,
        surenb@google.com, kernel-team@android.com, linux-mm@kvack.org,
        iommu@lists.linux.dev, kasan-dev@googlegroups.com,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

===========================
Code tagging framework
===========================
Code tag is a structure identifying a specific location in the source code
which is generated at compile time and can be embedded in an application-
specific structure. Several applications of code tagging are included in
this RFC, such as memory allocation tracking, dynamic fault injection,
latency tracking and improved error code reporting.
Basically, it takes the old trick of "define a special elf section for
objects of a given type so that we can iterate over them at runtime" and
creates a proper library for it.

===========================
Memory allocation tracking
===========================
The goal for using codetags for memory allocation tracking is to minimize
performance and memory overhead. By recording only the call count and
allocation size, the required operations are kept at the minimum while
collecting statistics for every allocation in the codebase. With that
information, if users are interested in mode detailed context for a
specific allocation, they can enable more in-depth context tracking,
which includes capturing the pid, tgid, task name, allocation size,
timestamp and call stack for every allocation at the specified code
location.
Memory allocation tracking is implemented in two parts:

part1: instruments page and slab allocators to record call count and total
memory allocated at every allocation in the source code. Every time an
allocation is performed by an instrumented allocator, the codetag at that
location increments its call and size counters. Every time the memory is
freed these counters are decremented. To decrement the counters upon free,
allocated object needs a reference to its codetag. Page allocators use
page_ext to record this reference while slab allocators use memcg_data of
the slab page.
The data is exposed to the user space via a read-only debugfs file called
alloc_tags.

Usage example:

$ sort -hr /sys/kernel/debug/alloc_tags|head
  153MiB     8599 mm/slub.c:1826 module:slub func:alloc_slab_page
 6.08MiB      49 mm/slab_common.c:950 module:slab_common func:_kmalloc_order
 5.09MiB     6335 mm/memcontrol.c:2814 module:memcontrol func:alloc_slab_obj_exts
 4.54MiB      78 mm/page_alloc.c:5777 module:page_alloc func:alloc_pages_exact
 1.32MiB      338 include/asm-generic/pgalloc.h:63 module:pgtable func:__pte_alloc_one
 1.16MiB      603 fs/xfs/xfs_log_priv.h:700 module:xfs func:xlog_kvmalloc
 1.00MiB      256 mm/swap_cgroup.c:48 module:swap_cgroup func:swap_cgroup_prepare
  734KiB     5380 fs/xfs/kmem.c:20 module:xfs func:kmem_alloc
  640KiB      160 kernel/rcu/tree.c:3184 module:tree func:fill_page_cache_func
  640KiB      160 drivers/char/virtio_console.c:452 module:virtio_console func:alloc_buf

part2: adds support for the user to select a specific code location to capture
allocation context. A new debugfs file called alloc_tags.ctx is used to select
which code location should capture allocation context and to read captured
context information.

Usage example:

$ cd /sys/kernel/debug/
$ echo "file include/asm-generic/pgalloc.h line 63 enable" > alloc_tags.ctx
$ cat alloc_tags.ctx
  920KiB      230 include/asm-generic/pgalloc.h:63 module:pgtable func:__pte_alloc_one
    size: 4096
    pid: 1474
    tgid: 1474
    comm: bash
    ts: 175332940994
    call stack:
         pte_alloc_one+0xfe/0x130
         __pte_alloc+0x22/0xb0
         copy_page_range+0x842/0x1640
         dup_mm+0x42d/0x580
         copy_process+0xfb1/0x1ac0
         kernel_clone+0x92/0x3e0
         __do_sys_clone+0x66/0x90
         do_syscall_64+0x38/0x90
         entry_SYSCALL_64_after_hwframe+0x63/0xcd
...

NOTE: slab allocation tracking is not yet stable and has a leak that
shows up in long-running tests. We are working on fixing it and posting
the RFC early to collect some feedback and to have a reference code in
public before presenting the idea at LPC2022.

===========================
Dynamic fault injection
===========================
Dynamic fault injection lets you do fault injection with a single call
to dynamic_fault(), with a debugfs interface similar to dynamic_debug.

Calls to dynamic_fault are listed in debugfs and can be enabled at
runtime (oneshot mode or a defined frequency are also available). This
patch also uses the memory allocation wrapper macros introduced by the
memory allocation tracking patches to add distinct fault injection
points for every memory allocation in the kernel.

Example fault injection points, after hooking memory allocation paths:

  fs/xfs/libxfs/xfs_iext_tree.c:606 module:xfs func:xfs_iext_realloc_rootclass:memory disabled "
  fs/xfs/libxfs/xfs_inode_fork.c:503 module:xfs func:xfs_idata_reallocclass:memory disabled "
  fs/xfs/libxfs/xfs_inode_fork.c:399 module:xfs func:xfs_iroot_reallocclass:memory disabled "
  fs/xfs/xfs_buf.c:373 module:xfs func:xfs_buf_alloc_pagesclass:memory disabled "
  fs/xfs/xfs_iops.c:497 module:xfs func:xfs_vn_get_linkclass:memory disabled "
  fs/xfs/xfs_mount.c:85 module:xfs func:xfs_uuid_mountclass:memory disabled "

===========================
Latency tracking
===========================
This lets you instrument code for measuring latency with just two calls
to code_tag_time_stats_start() and code_tag_time_stats_finish(), and
makes statistics available in debugfs on a per-callsite basis.

Recorded statistics include total count, frequency/rate, average
duration, max duration, and event duration quantiles.

Additionally, this patch instruments prepare_to_wait() and finish_wait().

Example output:

  fs/xfs/xfs_extent_busy.c:589 module:xfs func:xfs_extent_busy_flush
  count:          61
  rate:           0/sec
  frequency:    19 sec
  avg duration:   632 us
  max duration:   2 ms
  quantiles (us): 274 288 288 296 296 296 296 336 336 336 336 336 336 336 336

===========================
Improved error codes
===========================
Ever waste hours trying to figure out which line of code from some
obscure module is returning you -EINVAL and nothing else?

What if we had... more error codes?

This patch adds ERR(), which returns a unique error code that is related
to the error code that passed to it: the original error code can be
recovered with error_class(), and errname() (as well as %pE) returns an
error string that includes the file and line number of the ERR() call.

Example output:

  VFS: Cannot open root device "sda" or unknown-block(8,0): error -EINVAL at fs/ext4/super.c:4387

===========================
Dynamic debug conversion to code tagging
===========================
There are several open coded implementations of the "define a special elf
section for objects and iterate" technique that should be converted to
code tagging. This series just converts dynamic debug; there are others
(multiple in ftrace, in particular) that should also be converted.

===========================

The patchset applies cleanly over Linux 6.0-rc3
The tree for testing is published at:
https://github.com/surenbaghdasaryan/linux/tree/alloc_tags_rfc

The structure of the patchset is:
- code tagging framework (patches 1-6)
- page allocation tracking (patches 7-10)
- slab allocation tracking (patch 11-16)
- allocation context capture (patch 17-21)
- dynamic fault injection (patch 22)
- latency tracking (patch 23-27)
- improved error codes (patch 28)
- dynamic debug conversion to code tagging (patch 29)
- MAINTAINERS update (patch 30)

Next steps:
- track and fix slab allocator leak mentioned earlier;
- instrument more allocators: vmalloc, per-cpu allocations, others?


Kent Overstreet (14):
  lib/string_helpers: Drop space in string_get_size's output
  Lazy percpu counters
  scripts/kallysms: Always include __start and __stop symbols
  lib/string.c: strsep_no_empty()
  codetag: add codetag query helper functions
  Code tagging based fault injection
  timekeeping: Add a missing include
  wait: Clean up waitqueue_entry initialization
  lib/time_stats: New library for statistics on events
  bcache: Convert to lib/time_stats
  Code tagging based latency tracking
  Improved symbolic error names
  dyndbg: Convert to code tagging
  MAINTAINERS: Add entries for code tagging & related

Suren Baghdasaryan (16):
  kernel/module: move find_kallsyms_symbol_value declaration
  lib: code tagging framework
  lib: code tagging module support
  lib: add support for allocation tagging
  lib: introduce page allocation tagging
  change alloc_pages name in dma_map_ops to avoid name conflicts
  mm: enable page allocation tagging for __get_free_pages and
    alloc_pages
  mm: introduce slabobj_ext to support slab object extensions
  mm: introduce __GFP_NO_OBJ_EXT flag to selectively prevent slabobj_ext
    creation
  mm/slab: introduce SLAB_NO_OBJ_EXT to avoid obj_ext creation
  mm: prevent slabobj_ext allocations for slabobj_ext and kmem_cache
    objects
  lib: introduce slab allocation tagging
  mm: enable slab allocation tagging for kmalloc and friends
  move stack capture functionality into a separate function for reuse
  lib: introduce support for storing code tag context
  lib: implement context capture support for page and slab allocators

 MAINTAINERS                         |  34 ++
 arch/x86/kernel/amd_gart_64.c       |   2 +-
 drivers/iommu/dma-iommu.c           |   2 +-
 drivers/md/bcache/Kconfig           |   1 +
 drivers/md/bcache/bcache.h          |   1 +
 drivers/md/bcache/bset.c            |   8 +-
 drivers/md/bcache/bset.h            |   1 +
 drivers/md/bcache/btree.c           |  12 +-
 drivers/md/bcache/super.c           |   3 +
 drivers/md/bcache/sysfs.c           |  43 ++-
 drivers/md/bcache/util.c            |  30 --
 drivers/md/bcache/util.h            |  57 ---
 drivers/xen/grant-dma-ops.c         |   2 +-
 drivers/xen/swiotlb-xen.c           |   2 +-
 include/asm-generic/codetag.lds.h   |  18 +
 include/asm-generic/vmlinux.lds.h   |   8 +-
 include/linux/alloc_tag.h           |  84 +++++
 include/linux/codetag.h             | 159 +++++++++
 include/linux/codetag_ctx.h         |  48 +++
 include/linux/codetag_time_stats.h  |  54 +++
 include/linux/dma-map-ops.h         |   2 +-
 include/linux/dynamic_debug.h       |  11 +-
 include/linux/dynamic_fault.h       |  79 +++++
 include/linux/err.h                 |   2 +-
 include/linux/errname.h             |  50 +++
 include/linux/gfp.h                 |  10 +-
 include/linux/gfp_types.h           |  12 +-
 include/linux/io_uring_types.h      |   2 +-
 include/linux/lazy-percpu-counter.h |  67 ++++
 include/linux/memcontrol.h          |  23 +-
 include/linux/module.h              |   1 +
 include/linux/page_ext.h            |   3 +-
 include/linux/pgalloc_tag.h         |  63 ++++
 include/linux/sbitmap.h             |   6 +-
 include/linux/sched.h               |   6 +-
 include/linux/slab.h                | 136 +++++---
 include/linux/slab_def.h            |   2 +-
 include/linux/slub_def.h            |   4 +-
 include/linux/stackdepot.h          |   3 +
 include/linux/string.h              |   1 +
 include/linux/time_stats.h          |  44 +++
 include/linux/timekeeping.h         |   1 +
 include/linux/wait.h                |  72 ++--
 include/linux/wait_bit.h            |   7 +-
 init/Kconfig                        |   5 +
 kernel/dma/mapping.c                |   4 +-
 kernel/module/internal.h            |   3 -
 kernel/module/main.c                |  27 +-
 kernel/sched/wait.c                 |  15 +-
 lib/Kconfig                         |   6 +
 lib/Kconfig.debug                   |  46 +++
 lib/Makefile                        |  10 +
 lib/alloc_tag.c                     | 391 +++++++++++++++++++++
 lib/codetag.c                       | 519 ++++++++++++++++++++++++++++
 lib/codetag_time_stats.c            | 143 ++++++++
 lib/dynamic_debug.c                 | 452 +++++++++---------------
 lib/dynamic_fault.c                 | 372 ++++++++++++++++++++
 lib/errname.c                       | 103 ++++++
 lib/lazy-percpu-counter.c           | 141 ++++++++
 lib/pgalloc_tag.c                   |  22 ++
 lib/stackdepot.c                    |  68 ++++
 lib/string.c                        |  19 +
 lib/string_helpers.c                |   3 +-
 lib/time_stats.c                    | 236 +++++++++++++
 mm/kfence/core.c                    |   2 +-
 mm/memcontrol.c                     |  62 ++--
 mm/mempolicy.c                      |   4 +-
 mm/page_alloc.c                     |  13 +-
 mm/page_ext.c                       |   6 +
 mm/page_owner.c                     |  54 +--
 mm/slab.c                           |   4 +-
 mm/slab.h                           | 125 ++++---
 mm/slab_common.c                    |  49 ++-
 mm/slob.c                           |   2 +
 mm/slub.c                           |   7 +-
 scripts/kallsyms.c                  |  13 +
 scripts/module.lds.S                |   7 +
 77 files changed, 3406 insertions(+), 703 deletions(-)
 create mode 100644 include/asm-generic/codetag.lds.h
 create mode 100644 include/linux/alloc_tag.h
 create mode 100644 include/linux/codetag.h
 create mode 100644 include/linux/codetag_ctx.h
 create mode 100644 include/linux/codetag_time_stats.h
 create mode 100644 include/linux/dynamic_fault.h
 create mode 100644 include/linux/lazy-percpu-counter.h
 create mode 100644 include/linux/pgalloc_tag.h
 create mode 100644 include/linux/time_stats.h
 create mode 100644 lib/alloc_tag.c
 create mode 100644 lib/codetag.c
 create mode 100644 lib/codetag_time_stats.c
 create mode 100644 lib/dynamic_fault.c
 create mode 100644 lib/lazy-percpu-counter.c
 create mode 100644 lib/pgalloc_tag.c
 create mode 100644 lib/time_stats.c

-- 
2.37.2.672.g94769d06f0-goog

