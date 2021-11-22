Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F257459801
	for <lists+io-uring@lfdr.de>; Mon, 22 Nov 2021 23:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhKVW5k (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 17:57:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbhKVW5d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 17:57:33 -0500
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239F7C061574;
        Mon, 22 Nov 2021 14:54:26 -0800 (PST)
Received: by mail-pl1-x644.google.com with SMTP id b11so15363227pld.12;
        Mon, 22 Nov 2021 14:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4cok9Tz08yrGdyczu0wBiLU6ZEq/77kot/uk7jnqN1E=;
        b=R64fWR9VYltkjmImML2Kj2eq0VylG14px0w5ewqU5p4v6H3XW5yvntcelrJReBzmE7
         58aXVlr03ORv7X8zDbXJT9/vSASIyC2ZymMDlzbegsyShh7VwlfEZzSvCMP+LGVWKBrD
         su6ftVP5DQFy/FmOkaOjGMqbfVtND6D1CMs5NV7sdl/dM+PpFgWy9qx6s/lBrTOB5t5R
         muJg+rcBlfGY9W2aQlUD/T3i3wsHsdRfafsBMrtLOVSeVJF4zZ3eR6sAzo9I6dN+m7Qo
         mC5VGZDkcGHiw2SqZCVq73pjmBimwRdqK+1NLPoVvv9gteP0Y5BY8BXg2+wjWqWb+d+B
         qZIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4cok9Tz08yrGdyczu0wBiLU6ZEq/77kot/uk7jnqN1E=;
        b=o55WkufXGNfnWfqt2d0pog1K0n0oJQOoOdSpEwpEhwGRMz+GHM63678NExaeJCRTZN
         U4hbNy4ArkBXvaOAtHKVVgiHNY49Jyx1BPjAVrl9hs8qZVPf+6vwHMas0uqnDeLMnZBg
         LBz078zSdtatQ7vQCyVQMQ8eUE0pompaO3WJCSzgwLPcToJTAhOuYnQ83tlyQM3vXzh+
         SiKOTP8BCDC0BiGjQrT0jqEum6DPRHEtwATbCLlKyscQz+Sw7tX93Qe4T5OKRH3OX8v4
         2Ot3Ga2OsNtvd20cHJD/BA3ZNI8SzbqrFOUFbTaESUdyQomFnGucvTzSEIhvfa++RoNT
         cwrQ==
X-Gm-Message-State: AOAM533fEg9n+rv4LjIvwF5KsB3xdEaGd94JFZFzRV8FIzM8w/8nn5/6
        jZoR/w5dNyJv0giPzyW12w5VPyz9Dhw=
X-Google-Smtp-Source: ABdhPJwp+S1EaC5sTWsT+tWJVlCVc622hccd4Xj0lBupgc5hzhr1CsfrA013Xf1NBe666WwJJEdrtw==
X-Received: by 2002:a17:90b:3b8d:: with SMTP id pc13mr588811pjb.112.1637621664785;
        Mon, 22 Nov 2021 14:54:24 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id m15sm9732461pfk.186.2021.11.22.14.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 14:54:24 -0800 (PST)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Pavel Emelyanov <ovzxemul@gmail.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Andrei Vagin <avagin@gmail.com>, criu@openvz.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH RFC bpf-next v2 10/10] samples/bpf: Add example to checkpoint/restore io_uring
Date:   Tue, 23 Nov 2021 04:23:52 +0530
Message-Id: <20211122225352.618453-11-memxor@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211122225352.618453-1-memxor@gmail.com>
References: <20211122225352.618453-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=35650; h=from:subject; bh=gubKs0gG51pcL083ucyNsTa+Pt9iyeRpdz3TMFpnKCM=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhnBrMEXdEu2vFCLQigSnJmZ3LZ4d+hAbw0Ni1E4On aBu9DOiJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYZwazAAKCRBM4MiGSL8RyhFTEA CjLOlz1UNGQX/UBI1ob2fUI38ePjeUHil0k7a1RvSrOOI77Mnfx7H7THe4DPU4i5xYSsAJElupHBZ7 zVPijtUU/Vb9aUFud5f1UHdnQlHcOIlZrfQmjpMlNpvKKzKIzvTizPq2Zfk0buETvZ1oZPldlmwXpH 2txqUzOczeAY7uOgsSb/rOxx8CeRhmPXd0rfsHOvg2aPfKoH17Z0tIyjfaaPfSouEEvFNaVNRmQQv0 aCUfkNdAlifVEWBRp0ttNn3GUXMtK5xuYY6MApImOmw1pbSH4FJ4/d1vegHX+MUhKoo3fmf8yH7Y6w khrCmgTsJpOWYtMj7zNw4efM6HIaaoTF8I0XVOpXgEgadxgS8jayZeagrld8DnJL6mcnerhLU1m09l p6RBOlMwb/fQtWXOeKI1AHiMLQ5LdEzda29ouHS6X6uDrzNEZ5AOv2Qdc3r2bTBEOrFbqRODhGtOtG NGjHGPe5sOkKp1CeKhoL45+Ydp+cjsfL28BDxHgWSOOROmQZKRxXZO/JUF+SgtDVyJZ69fsCcjUTj4 +2owCLz1HZGP5p2ZkzZle5emkIwMr2G968NOh0tTsVVpM+azAfw17zsFuiEnucA7lvHjf3dLEe611o 9Act/fYJ4paySfmgFaTlQh9lKgaSUmt5aJoCneRl8lJsARvDGZkbZB2mSBOQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The sample demonstrates how BPF iterators for task and io_uring can be
used to checkpoint the state of an io_uring instance and then recreate
it using that information, as a working example of how the iterator
will be utilized for the same by userspace projects like CRIU.

This is very similar to how CRIU actually works in principle, by writing
all data on dump to protobuf images, which are then read during restore
to reconstruct the task and its resources. Here we use a custom binary
format and pipe the io_uring "image(s)" (in case of wq_fd there will be
multiple images), to the restorer, which then consumes this information
to form a total ordering of restore actions it has to execute to reach
the same state.

The sample restores all features that currently cannot be restored
without bpf iterators, hence is a good demonstration of what we would
like to achieve using these new facilities. As is evident, we need a
single iteration pass in each iterator to obtain all the information we
require.

io_uring ring buffer restoration is orthogonal and not specific to
iterators, so it has been left out.

Our example app also shares the workqueue with parent io_uring, which is
detected by our dumper tool and it moves to first dump the parent
io_uring. io_uring doesn't allow creating cycles in this case, so the
chain ends eventually in practice. For now only single parent is
supported, but it easy to extend to arbitrary length chains (by
recursing with limit in do_dump_parent after detecting presence of wq_fd > 0).

The epoll iterator usecase is similar to what we do in dump_io_uring_file,
and would significantly simplify current implementation [0].

  [0]: https://github.com/checkpoint-restore/criu/blob/criu-dev/criu/eventpoll.c

The dry-run mode of bpf_cr tool prints the dump image:

$ ./bpf_cr app &
PID: 318, Parent io_uring: 3, Dependent io_uring: 4

$ ./bpf_cr dump 318 4 | ./bpf_cr restore --dry-run
DUMP_SETUP:
	io_uring_fd: 3
	end: true
		flags: 14
		sq_entries: 2
		cq_entries: 4
		sq_thread_cpu: 0
		sq_thread_idle: 1500
		wq_fd: 0
DUMP_SETUP:
	io_uring_fd: 4
	end: false
		flags: 46
		sq_entries: 2
		cq_entries: 4
		sq_thread_cpu: 0
		sq_thread_idle: 1500
		wq_fd: 3
DUMP_EVENTFD:
	io_uring_fd: 4
	end: false
		eventfd: 5
		async: true
DUMP_REG_FD:
	io_uring_fd: 4
	end: false
		reg_fd: 0
		index: 0
DUMP_REG_FD:
	io_uring_fd: 4
	end: false
		reg_fd: 0
		index: 2
DUMP_REG_FD:
	io_uring_fd: 4
	end: false
		reg_fd: 0
		index: 4
DUMP_REG_BUF:
	io_uring_fd: 4
	end: false
		addr: 0
		len: 0
		index: 0
DUMP_REG_BUF:
	io_uring_fd: 4
	end: true
		addr: 140721288339216
		len: 120
		index: 1
Nothing to do, exiting...

======

The trace is as follows:
// We can shift fd number around randomly, it doesn't impact C/R
$ exec 3<> /dev/urandom
$ exec 4<> /dev/random
$ exec 5<> /dev/null
$ strace ./bpf_cr app &
	...
	io_uring_setup(2, {flags=IORING_SETUP_SQPOLL|IORING_SETUP_SQ_AFF|IORING_SETUP_CQSIZE, sq_thread_cpu=0, sq_thread_idle=1500, sq_entries=2, cq_entries=4, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS, sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, dropped=272, array=384}, cq_off={head=128, tail=192, ring_mask=260, ring_entries=268, overflow=284, cqes=320, flags=0x118 /* IORING_CQ_??? */}}) = 6
	getpid()                                = 324
	...
	io_uring_setup(2, {flags=IORING_SETUP_SQPOLL|IORING_SETUP_SQ_AFF|IORING_SETUP_CQSIZE|IORING_SETUP_ATTACH_WQ, sq_thread_cpu=0, sq_thread_idle=1500, wq_fd=6, sq_entries=2, cq_entries=4, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS, sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, dropped=272, array=384}, cq_off={head=128, tail=192, ring_mask=260, ring_entries=268, overflow=284, cqes=320, flags=0x118 /* IORING_CQ_??? */}}) = 7
	...
	// PID: 324, Parent io_uring: 6, Dependent io_uring: 7
	...
	eventfd2(42, 0)                         = 8
	io_uring_register(7, IORING_REGISTER_EVENTFD_ASYNC, [8], 1) = 0
	io_uring_register(7, IORING_REGISTER_FILES, [0, -1, 1, -1, 2], 5) = 0
	io_uring_register(7, IORING_REGISTER_BUFFERS, [{iov_base=NULL, iov_len=0}, {iov_base=0x7ffdf1a27680, iov_len=120}], 2) = 0

The restore's trace is as follows (which detects the wq_fd on its own)
and dumps and restores it as well, before restoring fd 7:

$ ./bpf_cr dump 326 7 | strace ./bpf_cr restore
	...
	io_uring_setup(2, {flags=IORING_SETUP_SQPOLL|IORING_SETUP_SQ_AFF|IORING_SETUP_CQSIZE, sq_thread_cpu=0, sq_thread_idle=1500, sq_entries=2, cq_entries=4, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS, sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, dropped=272, array=384}, cq_off={head=128, tail=192, ring_mask=260, ring_entries=268, overflow=284, cqes=320, flags=0x118 /* IORING_CQ_??? */}}) = 6
	dup2(6, 6)                              = 6
	...
	io_uring_setup(2, {flags=IORING_SETUP_SQPOLL|IORING_SETUP_SQ_AFF|IORING_SETUP_CQSIZE|IORING_SETUP_ATTACH_WQ, sq_thread_cpu=0, sq_thread_idle=1500, wq_fd=6, sq_entries=2, cq_entries=4, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|IORING_FEAT_SQPOLL_NONFIXED|IORING_FEAT_EXT_ARG|IORING_FEAT_NATIVE_WORKERS|IORING_FEAT_RSRC_TAGS, sq_off={head=0, tail=64, ring_mask=256, ring_entries=264, flags=276, dropped=272, array=384}, cq_off={head=128, tail=192, ring_mask=260, ring_entries=268, overflow=284, cqes=320, flags=0x118 /* IORING_CQ_??? */}}) = 7
	dup2(7, 7)                              = 7
	...
	eventfd2(42, 0)                         = 8
	io_uring_register(7, IORING_REGISTER_EVENTFD_ASYNC, [8], 1) = 0
	...
	// fd number 0 is same as 1 and 2, hence the lowest one is used during restore,
	// it doesn't matter as underlying struct file is same...
	io_uring_register(7, IORING_REGISTER_FILES, [0, -1, 0, -1, 0], 5) = 0
	// This step would happen after restoring mm, so it fails for now for second iovec
	io_uring_register(7, IORING_REGISTER_BUFFERS, [{iov_base=NULL, iov_len=0}, {iov_base=0x7ffdf1a27680, iov_len=120}], 2) = -1 EFAULT (Bad address)
	...
---
 samples/bpf/.gitignore   |   1 +
 samples/bpf/Makefile     |   8 +-
 samples/bpf/bpf_cr.bpf.c | 185 +++++++++++
 samples/bpf/bpf_cr.c     | 686 +++++++++++++++++++++++++++++++++++++++
 samples/bpf/bpf_cr.h     |  48 +++
 samples/bpf/hbm_kern.h   |   2 -
 6 files changed, 926 insertions(+), 4 deletions(-)
 create mode 100644 samples/bpf/bpf_cr.bpf.c
 create mode 100644 samples/bpf/bpf_cr.c
 create mode 100644 samples/bpf/bpf_cr.h

diff --git a/samples/bpf/.gitignore b/samples/bpf/.gitignore
index 0e7bfdbff80a..9c542431ea45 100644
--- a/samples/bpf/.gitignore
+++ b/samples/bpf/.gitignore
@@ -1,4 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
+bpf_cr
 cpustat
 fds_example
 hbm
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index a886dff1ba89..a64f2e019bfc 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += bpf_cr

 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_redirect_map_multi
@@ -118,6 +119,7 @@ task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
+bpf_cr-objs := bpf_cr.o

 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o $(XDP_SAMPLE)
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
@@ -198,7 +200,7 @@ BPF_EXTRA_CFLAGS += -I$(srctree)/arch/mips/include/asm/mach-generic
 endif
 endif

-TPROGS_CFLAGS += -Wall -O2
+TPROGS_CFLAGS += -Wall -O2 -g
 TPROGS_CFLAGS += -Wmissing-prototypes
 TPROGS_CFLAGS += -Wstrict-prototypes

@@ -337,6 +339,7 @@ $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
 $(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
 $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
+$(obj)/bpf_cr.o: $(obj)/bpf_cr.skel.h

 $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
 $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
@@ -392,7 +395,7 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(LIBBPF_INCLUDE) $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@

-LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
+LINKED_SKELS := bpf_cr.skel.h xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
 		xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)

@@ -401,6 +404,7 @@ xdp_redirect_map_multi.skel.h-deps := xdp_redirect_map_multi.bpf.o xdp_sample.bp
 xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
+bpf_cr.skel.h-deps := bpf_cr.bpf.o

 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))

diff --git a/samples/bpf/bpf_cr.bpf.c b/samples/bpf/bpf_cr.bpf.c
new file mode 100644
index 000000000000..6b0bb019f2be
--- /dev/null
+++ b/samples/bpf/bpf_cr.bpf.c
@@ -0,0 +1,185 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "vmlinux.h"
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+#include "bpf_cr.h"
+
+/* struct file -> int fd */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __u64);
+	__type(value, int);
+	__uint(max_entries, 16);
+} fdtable_map SEC(".maps");
+
+struct ctx_map_val {
+	int fd;
+	bool init;
+};
+
+/* io_ring_ctx -> int fd */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __u64);
+	__type(value, struct ctx_map_val);
+	__uint(max_entries, 16);
+} io_ring_ctx_map SEC(".maps");
+
+/* ctx->sq_data -> int fd */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __u64);
+	__type(value, int);
+	__uint(max_entries, 16);
+} sq_data_map SEC(".maps");
+
+/* eventfd_ctx -> int fd */
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__type(key, __u64);
+	__type(value, int);
+	__uint(max_entries, 16);
+} eventfd_ctx_map SEC(".maps");
+
+const volatile pid_t tgid = 0;
+
+extern void eventfd_fops __ksym;
+extern void io_uring_fops __ksym;
+
+SEC("iter/task_file")
+int dump_task(struct bpf_iter__task_file *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct task_struct *task = ctx->task;
+	struct file *file = ctx->file;
+	struct ctx_map_val val = {};
+	__u64 f_priv;
+	int fd;
+
+	if (!task)
+		return 0;
+	if (task->tgid != tgid)
+		return 0;
+	if (!file)
+		return 0;
+
+	f_priv = (__u64)file->private_data;
+	fd = ctx->fd;
+	val.fd = fd;
+	if (file->f_op == &eventfd_fops) {
+		bpf_map_update_elem(&eventfd_ctx_map, &f_priv, &fd, 0);
+	} else if (file->f_op == &io_uring_fops) {
+		struct io_ring_ctx *ctx;
+		void *sq_data;
+		__u64 key;
+
+		bpf_map_update_elem(&io_ring_ctx_map, &f_priv, &val, 0);
+		ctx = file->private_data;
+		bpf_probe_read_kernel(&sq_data, sizeof(sq_data), &ctx->sq_data);
+		key = (__u64)sq_data;
+		bpf_map_update_elem(&sq_data_map, &key, &fd, BPF_NOEXIST);
+	}
+	f_priv = (__u64)file;
+	bpf_map_update_elem(&fdtable_map, &f_priv, &fd, BPF_NOEXIST);
+	return 0;
+}
+
+static void dump_io_ring_ctx(struct seq_file *seq, struct io_ring_ctx *ctx, int ring_fd)
+{
+	struct io_uring_dump dump;
+	struct ctx_map_val *val;
+	__u64 key;
+	int *fd;
+
+	key = (__u64)ctx;
+	val = bpf_map_lookup_elem(&io_ring_ctx_map, &key);
+	if (val && val->init)
+		return;
+	__builtin_memset(&dump, 0, sizeof(dump));
+	if (val)
+		val->init = true;
+	dump.type = DUMP_SETUP;
+	dump.io_uring_fd = ring_fd;
+	key = (__u64)ctx->sq_data;
+#define ATTACH_WQ_FLAG (1 << 5)
+	if (ctx->flags & ATTACH_WQ_FLAG) {
+		fd = bpf_map_lookup_elem(&sq_data_map, &key);
+		if (fd)
+			dump.desc.setup.wq_fd = *fd;
+	}
+	dump.desc.setup.flags = ctx->flags;
+	dump.desc.setup.sq_entries = ctx->sq_entries;
+	dump.desc.setup.cq_entries = ctx->cq_entries;
+	dump.desc.setup.sq_thread_cpu = ctx->sq_data->sq_cpu;
+	dump.desc.setup.sq_thread_idle = ctx->sq_data->sq_thread_idle;
+	bpf_seq_write(seq, &dump, sizeof(dump));
+	if (ctx->cq_ev_fd) {
+		dump.type = DUMP_EVENTFD;
+		key = (__u64)ctx->cq_ev_fd;
+		fd = bpf_map_lookup_elem(&eventfd_ctx_map, &key);
+		if (fd)
+			dump.desc.eventfd.eventfd = *fd;
+		dump.desc.eventfd.async = ctx->eventfd_async;
+		bpf_seq_write(seq, &dump, sizeof(dump));
+	}
+}
+
+SEC("iter/io_uring_buf")
+int dump_io_uring_buf(struct bpf_iter__io_uring_buf *ctx)
+{
+	struct io_mapped_ubuf *ubuf = ctx->ubuf;
+	struct seq_file *seq = ctx->meta->seq;
+	struct io_uring_dump dump;
+	__u64 key;
+	int *fd;
+
+	__builtin_memset(&dump, 0, sizeof(dump));
+	key = (__u64)ctx->ctx;
+	fd = bpf_map_lookup_elem(&io_ring_ctx_map, &key);
+	if (!ctx->meta->seq_num)
+		dump_io_ring_ctx(seq, ctx->ctx, fd ? *fd : 0);
+	if (!ubuf)
+		return 0;
+	dump.type = DUMP_REG_BUF;
+	if (fd)
+		dump.io_uring_fd = *fd;
+	dump.desc.reg_buf.index = ctx->index;
+	if (ubuf != ctx->ctx->dummy_ubuf) {
+		dump.desc.reg_buf.addr = ubuf->ubuf;
+		dump.desc.reg_buf.len = ubuf->ubuf_end - ubuf->ubuf;
+	}
+	bpf_seq_write(seq, &dump, sizeof(dump));
+	return 0;
+}
+
+SEC("iter/io_uring_file")
+int dump_io_uring_file(struct bpf_iter__io_uring_file *ctx)
+{
+	struct seq_file *seq = ctx->meta->seq;
+	struct file *file = ctx->file;
+	struct io_uring_dump dump;
+	__u64 key;
+	int *fd;
+
+	__builtin_memset(&dump, 0, sizeof(dump));
+	key = (__u64)ctx->ctx;
+	fd = bpf_map_lookup_elem(&io_ring_ctx_map, &key);
+	if (!ctx->meta->seq_num)
+		dump_io_ring_ctx(seq, ctx->ctx, fd ? *fd : 0);
+	if (!file)
+		return 0;
+	dump.type = DUMP_REG_FD;
+	if (fd)
+		dump.io_uring_fd = *fd;
+	dump.desc.reg_fd.index = ctx->index;
+	key = (__u64)file;
+	fd = bpf_map_lookup_elem(&fdtable_map, &key);
+	if (fd)
+		dump.desc.reg_fd.reg_fd = *fd;
+	bpf_seq_write(seq, &dump, sizeof(dump));
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/bpf_cr.c b/samples/bpf/bpf_cr.c
new file mode 100644
index 000000000000..53c7fd85246c
--- /dev/null
+++ b/samples/bpf/bpf_cr.c
@@ -0,0 +1,686 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * BPF C/R
+ *
+ * Tool to use BPF iterators to dump process state.  This currently supports
+ * dumping io_uring fd state, by taking process PID and fd number pair, then
+ * dumping to stdout the state as binary struct, which can be passed to the
+ * tool consuming it, to recreate io_uring.
+ */
+
+#include <errno.h>
+#include <stdio.h>
+#include <assert.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <bpf/bpf.h>
+#include <stdbool.h>
+#include <sys/uio.h>
+#include <bpf/libbpf.h>
+#include <sys/eventfd.h>
+#include <sys/syscall.h>
+#include <linux/io_uring.h>
+
+#include "bpf_cr.h"
+#include "bpf_cr.skel.h"
+
+/* Approx. 4096/40 */
+#define MAX_DESC 96
+size_t dump_desc_cnt;
+size_t reg_fd_cnt;
+size_t reg_buf_cnt;
+struct io_uring_dump *dump_desc[MAX_DESC];
+int fds[MAX_DESC];
+struct iovec bufs[MAX_DESC];
+
+static int sys_pidfd_open(pid_t pid, unsigned int flags)
+{
+	return syscall(__NR_pidfd_open, pid, flags);
+}
+
+static int sys_pidfd_getfd(int pidfd, int targetfd, unsigned int flags)
+{
+	return syscall(__NR_pidfd_getfd, pidfd, targetfd, flags);
+}
+
+static int sys_io_uring_setup(uint32_t entries, struct io_uring_params *p)
+{
+	return syscall(__NR_io_uring_setup, entries, p);
+}
+
+static int sys_io_uring_register(unsigned int fd, unsigned int opcode,
+				 void *arg, unsigned int nr_args)
+{
+	return syscall(__NR_io_uring_register, fd, opcode, arg, nr_args);
+}
+
+static const char *type2str[__DUMP_MAX] = {
+	[DUMP_SETUP]   = "DUMP_SETUP",
+	[DUMP_EVENTFD] = "DUMP_EVENTFD",
+	[DUMP_REG_FD]  = "DUMP_REG_FD",
+	[DUMP_REG_BUF] = "DUMP_REG_BUF",
+};
+
+static int do_dump_parent(struct bpf_cr *skel, int parent_fd)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {};
+	int ret = 0, buf_it, file_it;
+	struct bpf_link *lb, *lf;
+	char buf[4096];
+
+	linfo.io_uring.io_uring_fd = parent_fd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+
+	lb = bpf_program__attach_iter(skel->progs.dump_io_uring_buf, &opts);
+	if (!lb) {
+		ret = -errno;
+		fprintf(stderr, "Failed to attach to io_uring_buf: %m\n");
+		return ret;
+	}
+
+	lf = bpf_program__attach_iter(skel->progs.dump_io_uring_file, &opts);
+	if (!lf) {
+		ret = -errno;
+		fprintf(stderr, "Failed to attach io_uring_file: %m\n");
+		goto end;
+	}
+
+	buf_it = bpf_iter_create(bpf_link__fd(lb));
+	if (buf_it < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to create io_uring_buf: %m\n");
+		goto end_lf;
+	}
+
+	file_it = bpf_iter_create(bpf_link__fd(lf));
+	if (file_it < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to create io_uring_file: %m\n");
+		goto end_buf_it;
+	}
+
+	ret = read(file_it, buf, sizeof(buf));
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to read from io_uring_file iterator: %m\n");
+		goto end_file_it;
+	}
+
+	ret = write(STDOUT_FILENO, buf, ret);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to write to stdout: %m\n");
+		goto end_file_it;
+	}
+
+	ret = read(buf_it, buf, sizeof(buf));
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to read from io_uring_buf iterator: %m\n");
+		goto end_file_it;
+	}
+
+	ret = write(STDOUT_FILENO, buf, ret);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to write to stdout: %m\n");
+		goto end_file_it;
+	}
+
+end_file_it:
+	close(file_it);
+end_buf_it:
+	close(buf_it);
+end_lf:
+	bpf_link__destroy(lf);
+end:
+	bpf_link__destroy(lb);
+	return ret;
+}
+
+static int do_dump(pid_t tpid, int tfd)
+{
+	int pidfd, ret = 0, buf_it, file_it, task_it;
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	union bpf_iter_link_info linfo = {};
+	const struct io_uring_dump *d;
+	struct bpf_cr *skel;
+	char buf[4096];
+
+	pidfd = sys_pidfd_open(tpid, 0);
+	if (pidfd < 0) {
+		fprintf(stderr, "Failed to open pidfd for PID %d: %m\n", tpid);
+		return 1;
+	}
+
+	tfd = sys_pidfd_getfd(pidfd, tfd, 0);
+	if (tfd < 0) {
+		fprintf(stderr, "Failed to acquire io_uring fd from PID %d: %m\n", tpid);
+		ret = 1;
+		goto end;
+	}
+
+	skel = bpf_cr__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to open BPF prog: %m\n");
+		ret = 1;
+		goto end_tfd;
+	}
+	skel->rodata->tgid = tpid;
+
+	ret = bpf_cr__load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to load BPF prog: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+
+	skel->links.dump_task = bpf_program__attach_iter(skel->progs.dump_task, NULL);
+	if (!skel->links.dump_task) {
+		fprintf(stderr, "Failed to attach task_file iterator: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+
+	task_it = bpf_iter_create(bpf_link__fd(skel->links.dump_task));
+	if (task_it < 0) {
+		fprintf(stderr, "Failed to create task_file iterator: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+
+	/* Drive task iterator */
+	ret = read(task_it, buf, sizeof(buf));
+	close(task_it);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to read from task_file iterator: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+
+	linfo.io_uring.io_uring_fd = tfd;
+	opts.link_info = &linfo;
+	opts.link_info_len = sizeof(linfo);
+	skel->links.dump_io_uring_buf = bpf_program__attach_iter(skel->progs.dump_io_uring_buf,
+								 &opts);
+	if (!skel->links.dump_io_uring_buf) {
+		fprintf(stderr, "Failed to attach io_uring_buf iterator: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+	skel->links.dump_io_uring_file = bpf_program__attach_iter(skel->progs.dump_io_uring_file,
+								  &opts);
+	if (!skel->links.dump_io_uring_file) {
+		fprintf(stderr, "Failed to attach io_uring_file iterator: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+
+	buf_it = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_buf));
+	if (buf_it < 0) {
+		fprintf(stderr, "Failed to create io_uring_buf iterator: %m\n");
+		ret = 1;
+		goto end_skel;
+	}
+
+	file_it = bpf_iter_create(bpf_link__fd(skel->links.dump_io_uring_file));
+	if (file_it < 0) {
+		fprintf(stderr, "Failed to create io_uring_file iterator: %m\n");
+		ret = 1;
+		goto end_buf_it;
+	}
+
+	ret = read(file_it, buf, sizeof(buf));
+	if (ret < 0) {
+		fprintf(stderr, "Failed to read from io_uring_file iterator: %m\n");
+		ret = 1;
+		goto end_file_it;
+	}
+
+	/* Check if we have to dump its parent as well, first descriptor will
+	 * always be DUMP_SETUP, if so, recurse and dump it first.
+	 */
+	d = (void *)buf;
+	if (ret >= sizeof(*d) && d->type == DUMP_SETUP && d->desc.setup.wq_fd) {
+		int r;
+
+		r = sys_pidfd_getfd(pidfd, d->desc.setup.wq_fd, 0);
+		if (r < 0) {
+			fprintf(stderr, "Failed to obtain parent io_uring: %m\n");
+			ret = 1;
+			goto end_file_it;
+		}
+		r = do_dump_parent(skel, r);
+		if (r < 0) {
+			ret = 1;
+			goto end_file_it;
+		}
+	}
+
+	ret = write(STDOUT_FILENO, buf, ret);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to write to stdout: %m\n");
+		ret = 1;
+		goto end_file_it;
+	}
+
+	ret = read(buf_it, buf, sizeof(buf));
+	if (ret < 0) {
+		fprintf(stderr, "Failed to read from io_uring_buf iterator: %m\n");
+		ret = 1;
+		goto end_file_it;
+	}
+
+	ret = write(STDOUT_FILENO, buf, ret);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to write to stdout: %m\n");
+		ret = 1;
+		goto end_file_it;
+	}
+
+end_file_it:
+	close(file_it);
+end_buf_it:
+	close(buf_it);
+end_skel:
+	bpf_cr__destroy(skel);
+end_tfd:
+	close(tfd);
+end:
+	close(pidfd);
+	return ret;
+}
+
+static int dump_desc_cmp(const void *a, const void *b)
+{
+	const struct io_uring_dump *da = a;
+	const struct io_uring_dump *db = b;
+	uint64_t dafd = da->io_uring_fd;
+	uint64_t dbfd = db->io_uring_fd;
+
+	if (dafd < dbfd)
+		return -1;
+	else if (dafd > dbfd)
+		return 1;
+	else if (da->type < db->type)
+		return -1;
+	else if (da->type > db->type)
+		return 1;
+	return 0;
+}
+
+static int do_restore_setup(const struct io_uring_dump *d)
+{
+	struct io_uring_params p;
+	int fd, nfd;
+
+	memset(&p, 0, sizeof(p));
+
+	p.flags = d->desc.setup.flags;
+	if (p.flags & IORING_SETUP_SQ_AFF)
+		p.sq_thread_cpu = d->desc.setup.sq_thread_cpu;
+	if (p.flags & IORING_SETUP_SQPOLL)
+		p.sq_thread_idle = d->desc.setup.sq_thread_idle;
+	if (p.flags & IORING_SETUP_ATTACH_WQ)
+		p.wq_fd = d->desc.setup.wq_fd;
+	if (p.flags & IORING_SETUP_CQSIZE)
+		p.cq_entries = d->desc.setup.cq_entries;
+
+	fd = sys_io_uring_setup(d->desc.setup.sq_entries, &p);
+	if (fd < 0) {
+		fprintf(stderr, "Failed to restore DUMP_SETUP desc: %m\n");
+		return -errno;
+	}
+
+	nfd = dup2(fd, d->io_uring_fd);
+	if (nfd < 0) {
+		fprintf(stderr, "Failed to dup io_uring_fd: %m\n");
+		close(fd);
+		return -errno;
+	}
+	return 0;
+}
+
+static int do_restore_eventfd(const struct io_uring_dump *d)
+{
+	int evfd, ret, opcode;
+
+	/* This would require restoring the eventfd first in CRIU, which would
+	 * be found using eventfd_ctx and peeking into struct file guts from
+	 * task_file iterator. Here, we just reopen a normal eventfd and
+	 * register it. The BPF program does have code which does eventfd
+	 * matching to report the fd number.
+	 */
+	evfd = eventfd(42, 0);
+	if (evfd < 0) {
+		fprintf(stderr, "Failed to open eventfd: %m\n");
+		return -errno;
+	}
+
+	opcode = d->desc.eventfd.async ? IORING_REGISTER_EVENTFD_ASYNC : IORING_REGISTER_EVENTFD;
+	ret = sys_io_uring_register(d->io_uring_fd, opcode, &evfd, 1);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to register eventfd: %m\n");
+		goto end;
+	}
+
+	ret = 0;
+end:
+	close(evfd);
+	return ret;
+}
+
+static void print_desc(const struct io_uring_dump *d)
+{
+	printf("%s:\n\tio_uring_fd: %d\n\tend: %s\n",
+	       type2str[d->type % __DUMP_MAX], d->io_uring_fd, d->end ? "true" : "false");
+	switch (d->type) {
+	case DUMP_SETUP:
+		printf("\t\tflags: %u\n\t\tsq_entries: %u\n\t\tcq_entries: %u\n"
+		       "\t\tsq_thread_cpu: %d\n\t\tsq_thread_idle: %d\n\t\twq_fd: %d\n",
+		       d->desc.setup.flags, d->desc.setup.sq_entries,
+		       d->desc.setup.cq_entries, d->desc.setup.sq_thread_cpu,
+		       d->desc.setup.sq_thread_idle, d->desc.setup.wq_fd);
+		break;
+	case DUMP_EVENTFD:
+		printf("\t\teventfd: %d\n\t\tasync: %s\n",
+		       d->desc.eventfd.eventfd,
+		       d->desc.eventfd.async ? "true" : "false");
+		break;
+	case DUMP_REG_FD:
+		printf("\t\treg_fd: %d\n\t\tindex: %lu\n",
+		       d->desc.reg_fd.reg_fd, d->desc.reg_fd.index);
+		break;
+	case DUMP_REG_BUF:
+		printf("\t\taddr: %lu\n\t\tlen: %lu\n\t\tindex: %lu\n",
+		       d->desc.reg_buf.addr, d->desc.reg_buf.len,
+		       d->desc.reg_buf.index);
+		break;
+	default:
+		printf("\t\t{Unknown}\n");
+		break;
+	}
+}
+
+static int do_restore_reg_fd(const struct io_uring_dump *d)
+{
+	int ret;
+
+	/* In CRIU, we restore the fds to be registered before executing the
+	 * restore action that registers file descriptors to io_uring.
+	 * Our example app would register stdin/stdout/stderr in a sparse
+	 * table, so the test case in the commit works.
+	 */
+	if (reg_fd_cnt == MAX_DESC || d->desc.reg_fd.index >= MAX_DESC) {
+		fprintf(stderr, "Exceeded max fds MAX_DESC (%d)\n", MAX_DESC);
+		return -EDOM;
+	}
+	assert(reg_fd_cnt <= d->desc.reg_fd.index);
+	/* Fill sparse entries */
+	while (reg_fd_cnt < d->desc.reg_fd.index)
+		fds[reg_fd_cnt++] = -1;
+	fds[reg_fd_cnt++] = d->desc.reg_fd.reg_fd;
+	if (d->end) {
+		ret = sys_io_uring_register(d->io_uring_fd,
+					    IORING_REGISTER_FILES, &fds,
+					    reg_fd_cnt);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to register files: %m\n");
+			return -errno;
+		}
+	}
+	return 0;
+}
+
+static int do_restore_reg_buf(const struct io_uring_dump *d)
+{
+	struct iovec *iov;
+	int ret;
+
+	/* This step in CRIU for buffers with intact source buffers must be
+	 * executed with care. There are primarily three cases (each with corner
+	 * cases excluded for brevity):
+	 * 1. Source VMA is intact ([ubuf->ubuf, ubuf->ubuf_end) is in VMA, base
+	 *    page PFN is same)
+	 * 2. Source VMA is split (with multiple pages of ubuf overlaying over
+	 *    holes) using munmap(s).
+	 * 3. Source VMA is absent (no VMA or full VMA with incorrect PFN).
+	 *
+	 * PFN remains unique as pages are pinned, hence one with same PFN will
+	 * not be recycled to be part of another mapping by page allocator. 2
+	 * and 3 required page contents dumping.
+	 *
+	 * VMA with holes (registered before punching holes) also needs partial
+	 * page content dumping to restore without holes, and then punch the
+	 * holes. This can be detected when buffer touches two VMAs with holes,
+	 * and base page PFN matches (split VMA case).
+	 *
+	 * All of this is too complicated to demonstrate here, and is done in
+	 * userspace, hence left out. Future patches will implement the page
+	 * dumping from ubuf iterator part.
+	 *
+	 * In usual cases we might be able to dump page contents from inside
+	 * io_uring that we are dumping, by submitting operations, but we want
+	 * to avoid manipulating the ring while dumping, and opcodes we might
+	 * need for doing that may be restricted, hence preventing dump.
+	 */
+	if (reg_buf_cnt == MAX_DESC) {
+		fprintf(stderr, "Exceeded max buffers MAX_DESC (%d)\n", MAX_DESC);
+		return -EDOM;
+	}
+	assert(d->desc.reg_buf.index == reg_buf_cnt);
+	iov = &bufs[reg_buf_cnt++];
+	iov->iov_base = (void *)d->desc.reg_buf.addr;
+	iov->iov_len  = d->desc.reg_buf.len;
+	if (d->end) {
+		if (reg_fd_cnt) {
+			ret = sys_io_uring_register(d->io_uring_fd,
+						    IORING_REGISTER_FILES, &fds,
+						    reg_fd_cnt);
+			if (ret < 0) {
+				fprintf(stderr, "Failed to register files: %m\n");
+				return -errno;
+			}
+		}
+
+		ret = sys_io_uring_register(d->io_uring_fd,
+					    IORING_REGISTER_BUFFERS, &bufs,
+					    reg_buf_cnt);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to register buffers: %m\n");
+			return -errno;
+		}
+	}
+	return 0;
+}
+
+static int do_restore_action(const struct io_uring_dump *d, bool dry_run)
+{
+	int ret;
+
+	print_desc(d);
+
+	if (dry_run)
+		return 0;
+
+	switch (d->type) {
+	case DUMP_SETUP:
+		ret = do_restore_setup(d);
+		break;
+	case DUMP_EVENTFD:
+		ret = do_restore_eventfd(d);
+		break;
+	case DUMP_REG_FD:
+		ret = do_restore_reg_fd(d);
+		break;
+	case DUMP_REG_BUF:
+		ret = do_restore_reg_buf(d);
+		break;
+	default:
+		fprintf(stderr, "Unknown dump descriptor\n");
+		return -EDOM;
+	}
+	return ret;
+}
+
+static int do_restore(bool dry_run)
+{
+	struct io_uring_dump dump;
+	int ret, prev_fd = 0;
+
+	while ((ret = read(STDIN_FILENO, &dump, sizeof(dump)))) {
+		struct io_uring_dump *d;
+
+		if (ret < 0) {
+			fprintf(stderr, "Failed to read descriptor: %m\n");
+			return 1;
+		}
+
+		d = calloc(1, sizeof(*d));
+		if (!d) {
+			fprintf(stderr, "Failed to allocate dump descriptor: %m\n");
+			goto free;
+		}
+
+		if (dump_desc_cnt == MAX_DESC) {
+			fprintf(stderr, "Cannot process more than MAX_DESC (%d) dump descs\n",
+				MAX_DESC);
+			goto free;
+		}
+
+		*d = dump;
+		if (!prev_fd)
+			prev_fd = d->io_uring_fd;
+		if (prev_fd != d->io_uring_fd) {
+			dump_desc[dump_desc_cnt - 1]->end = true;
+			prev_fd = d->io_uring_fd;
+		}
+		dump_desc[dump_desc_cnt++] = d;
+		qsort(dump_desc, dump_desc_cnt, sizeof(dump_desc[0]), dump_desc_cmp);
+	}
+	if (dump_desc_cnt)
+		dump_desc[dump_desc_cnt - 1]->end = true;
+
+	for (size_t i = 0; i < dump_desc_cnt; i++) {
+		ret = do_restore_action(dump_desc[i], dry_run);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to execute restore action\n");
+			goto free;
+		}
+	}
+
+	if (!dry_run && dump_desc_cnt)
+		sleep(10000);
+	else
+		puts("Nothing to do, exiting...");
+	ret = 0;
+free:
+	while (dump_desc_cnt--)
+		free(dump_desc[dump_desc_cnt]);
+	return ret;
+}
+
+static int run_app(void)
+{
+	struct io_uring_params p;
+	int r, ret, fd, evfd;
+
+	memset(&p, 0, sizeof(p));
+	p.flags |= IORING_SETUP_CQSIZE | IORING_SETUP_SQPOLL | IORING_SETUP_SQ_AFF;
+	p.sq_thread_idle = 1500;
+	p.cq_entries = 4;
+	/* Create a test case with parent io_uring, dependent io_uring,
+	 * registered files, eventfd (async), buffers, etc.
+	 */
+	fd = sys_io_uring_setup(2, &p);
+	if (fd < 0) {
+		fprintf(stderr, "Failed to create io_uring: %m\n");
+		return 1;
+	}
+
+	r = 1;
+	printf("PID: %d, Parent io_uring: %d, ", getpid(), fd);
+	p.flags |= IORING_SETUP_ATTACH_WQ;
+	p.wq_fd = fd;
+
+	fd = sys_io_uring_setup(2, &p);
+	if (fd < 0) {
+		fprintf(stderr, "\nFailed to create io_uring: %m\n");
+		goto end_wq_fd;
+	}
+
+	printf("Dependent io_uring: %d\n", fd);
+
+	evfd = eventfd(42, 0);
+	if (evfd < 0) {
+		fprintf(stderr, "Failed to create eventfd: %m\n");
+		goto end_fd;
+	}
+
+	ret = sys_io_uring_register(fd, IORING_REGISTER_EVENTFD_ASYNC, &evfd, 1);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to register eventfd (async): %m\n");
+		goto end_evfd;
+	}
+
+	ret = sys_io_uring_register(fd, IORING_REGISTER_FILES, &(int []){0, -1, 1, -1, 2}, 5);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to register files: %m\n");
+		goto end_evfd;
+	}
+
+	/* Register dummy buf as well */
+	ret = sys_io_uring_register(fd, IORING_REGISTER_BUFFERS, &(struct iovec[]){{}, {&p, sizeof(p)}}, 2);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to register buffers: %m\n");
+		goto end_evfd;
+	}
+
+	pause();
+
+	r = 0;
+end_evfd:
+	close(evfd);
+end_fd:
+	close(fd);
+end_wq_fd:
+	close(p.wq_fd);
+	return r;
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc < 2 || argc > 4) {
+usage:
+		fprintf(stderr, "Usage: %s dump PID FD > dump.out\n"
+			"\tcat dump.out | %s restore [--dry-run]\n"
+			"\t%s app\n", argv[0], argv[0], argv[0]);
+		return 1;
+	}
+
+	if (libbpf_set_strict_mode(LIBBPF_STRICT_ALL)) {
+		fprintf(stderr, "Failed to set libbpf strict mode\n");
+		return 1;
+	}
+
+	if (!strcmp(argv[1], "app")) {
+		return run_app();
+	} else if (!strcmp(argv[1], "dump")) {
+		if (argc != 4)
+			goto usage;
+		return do_dump(atoi(argv[2]), atoi(argv[3]));
+	} else if (!strcmp(argv[1], "restore")) {
+		if (argc < 2 || argc > 3)
+			goto usage;
+		if (argc == 3 && strcmp(argv[2], "--dry-run"))
+			goto usage;
+		return do_restore(argc == 3 /* dry_run mode */);
+	}
+	fprintf(stderr, "Unknown argument\n");
+	goto usage;
+}
diff --git a/samples/bpf/bpf_cr.h b/samples/bpf/bpf_cr.h
new file mode 100644
index 000000000000..74d4ca639db5
--- /dev/null
+++ b/samples/bpf/bpf_cr.h
@@ -0,0 +1,48 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#ifndef BPF_CR_H
+#define BPF_CR_H
+
+/* The order of restore actions is in order of declaration for each type,
+ * hence on restore consumed descriptors can be sorted based on their type,
+ * and then each action for the corresponding descriptor can be invoked, to
+ * recreate the io_uring.
+ */
+enum io_uring_state_type {
+	DUMP_SETUP,	/* Record setup parameters */
+	DUMP_EVENTFD,	/* eventfd registered in io_uring */
+	DUMP_REG_FD,	/* fd registered in io_uring */
+	DUMP_REG_BUF,	/* buffer registered in io_uring */
+	__DUMP_MAX,
+};
+
+struct io_uring_dump {
+	enum io_uring_state_type type;
+	int32_t io_uring_fd;
+	bool end;
+	union {
+		struct /* DUMP_SETUP */ {
+			uint32_t flags;
+			uint32_t sq_entries;
+			uint32_t cq_entries;
+			int32_t sq_thread_cpu;
+			int32_t sq_thread_idle;
+			uint32_t wq_fd;
+		} setup;
+		struct /* DUMP_EVENTFD */ {
+			uint32_t eventfd;
+			bool async;
+		} eventfd;
+		struct /* DUMP_REG_FD */ {
+			uint32_t reg_fd;
+			uint64_t index;
+		} reg_fd;
+		struct /* DUMP_REG_BUF */ {
+			uint64_t addr;
+			uint64_t len;
+			uint64_t index;
+		} reg_buf;
+	} desc;
+};
+
+#endif
diff --git a/samples/bpf/hbm_kern.h b/samples/bpf/hbm_kern.h
index 722b3fadb467..1752a46a2b05 100644
--- a/samples/bpf/hbm_kern.h
+++ b/samples/bpf/hbm_kern.h
@@ -9,8 +9,6 @@
  * Include file for sample Host Bandwidth Manager (HBM) BPF programs
  */
 #define KBUILD_MODNAME "foo"
-#include <stddef.h>
-#include <stdbool.h>
 #include <uapi/linux/bpf.h>
 #include <uapi/linux/if_ether.h>
 #include <uapi/linux/if_packet.h>
--
2.34.0

