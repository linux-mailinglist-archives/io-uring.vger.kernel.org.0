Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE6069F552
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 14:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjBVN1x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 08:27:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231309AbjBVN1w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 08:27:52 -0500
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD9934C1A;
        Wed, 22 Feb 2023 05:27:47 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R291e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046051;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VcH1bAp_1677072464;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VcH1bAp_1677072464)
          by smtp.aliyun-inc.com;
          Wed, 22 Feb 2023 21:27:44 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [PATCH] Add ebpf support.
Date:   Wed, 22 Feb 2023 21:27:44 +0800
Message-Id: <20230222132744.117182-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
References: <20230222132534.114574-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 Makefile.am            |   2 +-
 bpf/Makefile           |  48 ++++++++++++++++++++
 bpf/ublk.bpf.c         | 101 +++++++++++++++++++++++++++++++++++++++++
 bpf/ublk.c             |  56 +++++++++++++++++++++++
 include/ublk_cmd.h     |   2 +
 include/ublksrv.h      |   8 ++++
 include/ublksrv_priv.h |   1 +
 include/ublksrv_tgt.h  |   1 +
 lib/ublksrv.c          |   6 ++-
 lib/ublksrv_cmd.c      |  19 ++++++++
 tgt_loop.cpp           |  31 ++++++++++++-
 ublksrv_tgt.cpp        |  32 +++++++++++++
 12 files changed, 304 insertions(+), 3 deletions(-)
 create mode 100644 bpf/Makefile
 create mode 100644 bpf/ublk.bpf.c
 create mode 100644 bpf/ublk.c

diff --git a/Makefile.am b/Makefile.am
index a340bed..04ecbab 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -9,7 +9,7 @@ EXTRA_DIST = \
 
 SUBDIRS = include lib tests
 
-AM_CXXFLAGS = -fcoroutines -std=c++20
+AM_CXXFLAGS = -fcoroutines -std=c++20 /root/ublk/tools/bpf/bpftool/bootstrap/libbpf/libbpf.a -lelf -lz
 
 sbin_PROGRAMS = ublk ublk_user_id
 noinst_PROGRAMS = demo_null demo_event
diff --git a/bpf/Makefile b/bpf/Makefile
new file mode 100644
index 0000000..6f6ad6c
--- /dev/null
+++ b/bpf/Makefile
@@ -0,0 +1,48 @@
+out_dir := .tmp
+CLANG ?= clang
+LLVM_STRIP ?= llvm-strip
+BPFTOOL ?= /root/ublk/tools/bpf/bpftool/bpftool
+INCLUDES := -I$(out_dir)
+CFLAGS := -g -O2 -Wall
+ARCH := $(shell uname -m | sed 's/x86_64/x86/')
+# LIBBPF := <linux-tree>/tools/lib/bpf/libbpf.a
+LIBBPF := /root/ublk/tools/bpf/bpftool/bootstrap/libbpf/libbpf.a
+
+targets = ublk
+
+all: $(targets)
+
+$(targets): %: $(out_dir)/%.o | $(out_dir) libbpf_target
+	$(QUIET_CC)$(CC) $(CFLAGS) $^ -lelf -lz  $(LIBBPF) -o $@
+
+$(patsubst %,$(out_dir)/%.o,$(targets)): %.o: %.skel.h
+
+$(out_dir)/%.o: %.c $(wildcard %.h) | $(out_dir)
+	$(QUIET_CC)$(CC) $(CFLAGS) $(INCLUDES) -c $(filter %.c,$^) -o $@
+
+$(out_dir)/%.skel.h: $(out_dir)/%.bpf.o | $(out_dir)
+	$(BPFTOOL) gen skeleton $< > $@
+
+$(out_dir)/%.bpf.o: %.bpf.c $(wildcard %.h) vmlinux | $(out_dir)
+	$(QUIET_CC)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(ARCH)	\
+		     $(INCLUDES) -c $(filter %.c,$^) -o $@ &&		\
+	$(LLVM_STRIP) -g $@
+
+$(out_dir):
+	mkdir -p $@
+
+vmlinux:
+ifeq (,$(wildcard ./vmlinux.h))
+	$(BPFTOOL) btf dump file /sys/kernel/btf/vmlinux format c > ./vmlinux.h
+endif
+
+libbpf_target:
+ifndef LIBBPF
+	$(error LIBBPF is undefined)
+endif
+	@
+
+clean:
+	$(Q)rm -rf $(out_dir) $(targets) ./vmlinux.h
+
+.PHONY: all clean vmlinux libbpf_target
diff --git a/bpf/ublk.bpf.c b/bpf/ublk.bpf.c
new file mode 100644
index 0000000..45eb8db
--- /dev/null
+++ b/bpf/ublk.bpf.c
@@ -0,0 +1,101 @@
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_core_read.h>
+
+
+static long (*bpf_ublk_queue_sqe)(void *ctx, struct io_uring_sqe *sqe,
+		u32 sqe_len, u32 fd) = (void *) 212;
+
+int target_fd = -1;
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 128);
+	__type(key, int);
+	__type(value, int);
+} uring_fd_map SEC(".maps");
+
+static inline void io_uring_prep_rw(__u8 op, struct io_uring_sqe *sqe, int fd,
+				    const void *addr, unsigned int len,
+				    __u64 offset)
+{
+	sqe->opcode = op;
+	sqe->flags = 0;
+	sqe->ioprio = 0;
+	sqe->fd = fd;
+	sqe->off = offset;
+	sqe->addr = (unsigned long) addr;
+	sqe->len = len;
+	sqe->fsync_flags = 0;
+	sqe->buf_index = 0;
+	sqe->personality = 0;
+	sqe->splice_fd_in = 0;
+	sqe->addr3 = 0;
+	sqe->__pad2[0] = 0;
+}
+
+static inline void io_uring_prep_nop(struct io_uring_sqe *sqe)
+{
+	io_uring_prep_rw(IORING_OP_NOP, sqe, -1, 0, 0, 0);
+}
+
+static inline void io_uring_prep_read(struct io_uring_sqe *sqe, int fd,
+			void *buf, unsigned int nbytes, off_t offset)
+{
+	io_uring_prep_rw(IORING_OP_READ, sqe, fd, buf, nbytes, offset);
+}
+
+static inline void io_uring_prep_write(struct io_uring_sqe *sqe, int fd,
+	const void *buf, unsigned int nbytes, off_t offset)
+{
+	io_uring_prep_rw(IORING_OP_WRITE, sqe, fd, buf, nbytes, offset);
+}
+
+static inline __u64 build_user_data(unsigned int tag, unsigned int op,
+			unsigned int tgt_data, unsigned int is_target_io,
+			unsigned int is_bpf_io)
+{
+	return tag | (op << 16) | (tgt_data << 24) | (__u64)is_target_io << 63 |
+		(__u64)is_bpf_io << 60;
+}
+
+SEC("ublk.s/")
+int ublk_io_bpf_prog(struct ublk_bpf_ctx *ctx)
+{
+	struct io_uring_sqe *sqe;
+	char sqe_data[128] = {0};
+	int q_id = ctx->q_id;
+	u8 op;
+	u32 nr_sectors = ctx->nr_sectors;
+	u64 start_sector = ctx->start_sector;
+	int *ring_fd;
+
+	ring_fd = bpf_map_lookup_elem(&uring_fd_map, &q_id);
+	if (!ring_fd)
+		return UBLK_BPF_IO_PASS;
+
+	bpf_probe_read_kernel(&op, 1, &ctx->op);
+	sqe = (struct io_uring_sqe *)sqe_data;
+	if (op == REQ_OP_READ) {
+		char fmt[] = "sqe for REQ_OP_READ is issued\n";
+
+		bpf_trace_printk(fmt, sizeof(fmt));
+		io_uring_prep_read(sqe, target_fd, 0, nr_sectors << 9,
+				   start_sector << 9);
+		sqe->user_data = build_user_data(ctx->tag, op, 0, 1, 1);
+		bpf_ublk_queue_sqe(ctx, sqe, 128, *ring_fd);
+	} else if (op == REQ_OP_WRITE) {
+		char fmt[] = "sqe for REQ_OP_WRITE is issued\n";
+
+		bpf_trace_printk(fmt, sizeof(fmt));
+		io_uring_prep_write(sqe, target_fd, 0, nr_sectors << 9,
+				    start_sector << 9);
+		sqe->user_data = build_user_data(ctx->tag, op, 0, 1, 1);
+		bpf_ublk_queue_sqe(ctx, sqe, 128, *ring_fd);
+	} else {
+		return UBLK_BPF_IO_PASS;
+	}
+	return UBLK_BPF_IO_REDIRECT;
+}
+
+char LICENSE[] SEC("license") = "GPL";
diff --git a/bpf/ublk.c b/bpf/ublk.c
new file mode 100644
index 0000000..296005d
--- /dev/null
+++ b/bpf/ublk.c
@@ -0,0 +1,56 @@
+// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
+#include <argp.h>
+#include <assert.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/time.h>
+#include <time.h>
+#include <unistd.h>
+
+#include "ublk.skel.h"
+
+static void ublk_ebp_prep(struct ublk_bpf **pobj)
+{
+	struct ublk_bpf *obj;
+	int ret, prog_fds;
+
+	obj = ublk_bpf__open();
+	if (!obj) {
+		fprintf(stderr, "failed to open and/or load BPF object\n");
+		exit(1);
+	}
+	ret = ublk_bpf__load(obj);
+	if (ret) {
+		fprintf(stderr, "failed to load BPF object: %d\n", ret);
+		exit(1);
+	}
+
+	prog_fds = bpf_program__fd(obj->progs.ublk_io_bpf_prog);
+	*pobj = obj;
+
+
+	ret = bpf_map__set_max_entries(obj->maps.uring_fd_map, 16);
+
+	printf("prog_fds: %d\n", prog_fds);
+}
+
+static int ublk_ebpf_test(void)
+{
+	struct ublk_bpf *obj;
+
+	ublk_ebp_prep(&obj);
+	sleep(5);
+	ublk_bpf__destroy(obj);
+	return 0;
+}
+
+int main(int arg, char **argv)
+{
+	fprintf(stderr, "test1() ============\n");
+	ublk_ebpf_test();
+
+	return 0;
+}
diff --git a/include/ublk_cmd.h b/include/ublk_cmd.h
index f6238cc..893ba8c 100644
--- a/include/ublk_cmd.h
+++ b/include/ublk_cmd.h
@@ -17,6 +17,8 @@
 #define	UBLK_CMD_STOP_DEV	0x07
 #define	UBLK_CMD_SET_PARAMS	0x08
 #define	UBLK_CMD_GET_PARAMS	0x09
+#define UBLK_CMD_REG_BPF_PROG		0x0a
+#define UBLK_CMD_UNREG_BPF_PROG		0x0b
 #define	UBLK_CMD_START_USER_RECOVERY	0x10
 #define	UBLK_CMD_END_USER_RECOVERY	0x11
 #define	UBLK_CMD_GET_DEV_INFO2		0x12
diff --git a/include/ublksrv.h b/include/ublksrv.h
index d38bd46..800a6a0 100644
--- a/include/ublksrv.h
+++ b/include/ublksrv.h
@@ -106,6 +106,7 @@ struct ublksrv_tgt_info {
 	unsigned int nr_fds;
 	int fds[UBLKSRV_TGT_MAX_FDS];
 	void *tgt_data;
+	void *tgt_bpf_obj;
 
 	/*
 	 * Extra IO slots for each queue, target code can reserve some
@@ -263,6 +264,8 @@ struct ublksrv_tgt_type {
 	int (*init_queue)(const struct ublksrv_queue *, void **queue_data_ptr);
 	void (*deinit_queue)(const struct ublksrv_queue *);
 
+	int (*init_queue_bpf)(const struct ublksrv_dev *dev, const struct ublksrv_queue *q);
+
 	unsigned long reserved[5];
 };
 
@@ -318,6 +321,11 @@ extern void ublksrv_ctrl_prep_recovery(struct ublksrv_ctrl_dev *dev,
 		const char *recovery_jbuf);
 extern const char *ublksrv_ctrl_get_recovery_jbuf(const struct ublksrv_ctrl_dev *dev);
 
+extern void ublksrv_ctrl_set_bpf_obj_info(struct ublksrv_ctrl_dev *dev,
+					  void *obj);
+extern int ublksrv_ctrl_reg_bpf_prog(struct ublksrv_ctrl_dev *dev,
+				     int io_bpf_fd);
+
 /* ublksrv device ("/dev/ublkcN") level APIs */
 extern const struct ublksrv_dev *ublksrv_dev_init(const struct ublksrv_ctrl_dev *
 		ctrl_dev);
diff --git a/include/ublksrv_priv.h b/include/ublksrv_priv.h
index 2996baa..8da8866 100644
--- a/include/ublksrv_priv.h
+++ b/include/ublksrv_priv.h
@@ -42,6 +42,7 @@ struct ublksrv_ctrl_dev {
 
 	const char *tgt_type;
 	const struct ublksrv_tgt_type *tgt_ops;
+	void *bpf_obj;
 
 	/*
 	 * default is UBLKSRV_RUN_DIR but can be specified via command line,
diff --git a/include/ublksrv_tgt.h b/include/ublksrv_tgt.h
index 234d31e..e0db7d9 100644
--- a/include/ublksrv_tgt.h
+++ b/include/ublksrv_tgt.h
@@ -9,6 +9,7 @@
 #include <getopt.h>
 #include <string.h>
 #include <stdarg.h>
+#include <limits.h>
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/ioctl.h>
diff --git a/lib/ublksrv.c b/lib/ublksrv.c
index 96bed95..1cf24ae 100644
--- a/lib/ublksrv.c
+++ b/lib/ublksrv.c
@@ -163,7 +163,7 @@ static inline int ublksrv_queue_io_cmd(struct _ublksrv_queue *q,
 	sqe->fd		= 0;	/*dev->cdev_fd*/
 	sqe->opcode	=  IORING_OP_URING_CMD;
 	sqe->flags	= IOSQE_FIXED_FILE;
-	sqe->rw_flags	= 0;
+	sqe->uring_cmd_flags = 2;
 	cmd->tag	= tag;
 	cmd->addr	= (__u64)io->buf_addr;
 	cmd->q_id	= q->q_id;
@@ -603,6 +603,9 @@ skip_alloc_buf:
 		goto fail;
 	}
 
+	if (dev->tgt.ops->init_queue_bpf)
+		dev->tgt.ops->init_queue_bpf(tdev, local_to_tq(q));
+
 	ublksrv_dev_init_io_cmds(dev, q);
 
 	/*
@@ -723,6 +726,7 @@ const struct ublksrv_dev *ublksrv_dev_init(const struct ublksrv_ctrl_dev *ctrl_d
 	}
 
 	tgt->fds[0] = dev->cdev_fd;
+	tgt->tgt_bpf_obj = ctrl_dev->bpf_obj;
 
 	ret = ublksrv_tgt_init(dev, ctrl_dev->tgt_type, ctrl_dev->tgt_ops,
 			ctrl_dev->tgt_argc, ctrl_dev->tgt_argv);
diff --git a/lib/ublksrv_cmd.c b/lib/ublksrv_cmd.c
index 0d7265d..1c1f3fc 100644
--- a/lib/ublksrv_cmd.c
+++ b/lib/ublksrv_cmd.c
@@ -502,6 +502,25 @@ int ublksrv_ctrl_end_recovery(struct ublksrv_ctrl_dev *dev, int daemon_pid)
 	return ret;
 }
 
+int ublksrv_ctrl_reg_bpf_prog(struct ublksrv_ctrl_dev *dev,
+			      int io_bpf_fd)
+{
+	struct ublksrv_ctrl_cmd_data data = {
+		.cmd_op = UBLK_CMD_REG_BPF_PROG,
+		.flags = CTRL_CMD_HAS_DATA,
+	};
+	int ret;
+
+	data.data[0] = io_bpf_fd;
+	ret = __ublksrv_ctrl_cmd(dev, &data);
+	return ret;
+}
+
+void ublksrv_ctrl_set_bpf_obj_info(struct ublksrv_ctrl_dev *dev,  void *obj)
+{
+	dev->bpf_obj = obj;
+}
+
 const struct ublksrv_ctrl_dev_info *ublksrv_ctrl_get_dev_info(
 		const struct ublksrv_ctrl_dev *dev)
 {
diff --git a/tgt_loop.cpp b/tgt_loop.cpp
index 79a65d3..6e884b0 100644
--- a/tgt_loop.cpp
+++ b/tgt_loop.cpp
@@ -4,7 +4,11 @@
 
 #include <poll.h>
 #include <sys/epoll.h>
+#include <linux/bpf.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
 #include "ublksrv_tgt.h"
+#include "bpf/.tmp/ublk.skel.h"
 
 static bool backing_supports_discard(char *name)
 {
@@ -88,6 +92,20 @@ static int loop_recovery_tgt(struct ublksrv_dev *dev, int type)
 	return 0;
 }
 
+static int loop_init_queue_bpf(const struct ublksrv_dev *dev,
+			       const struct ublksrv_queue *q)
+{
+	int ret, q_id, ring_fd;
+	const struct ublksrv_tgt_info *tgt = &dev->tgt;
+	struct ublk_bpf *obj = (struct ublk_bpf*)tgt->tgt_bpf_obj;
+
+	q_id = q->q_id;
+	ring_fd = q->ring_ptr->ring_fd;
+	ret = bpf_map_update_elem(bpf_map__fd(obj->maps.uring_fd_map), &q_id,
+				  &ring_fd,  0);
+	return ret;
+}
+
 static int loop_init_tgt(struct ublksrv_dev *dev, int type, int argc, char
 		*argv[])
 {
@@ -125,6 +143,7 @@ static int loop_init_tgt(struct ublksrv_dev *dev, int type, int argc, char
 		},
 	};
 	bool can_discard = false;
+	struct ublk_bpf *bpf_obj;
 
 	strcpy(tgt_json.name, "loop");
 
@@ -218,6 +237,10 @@ static int loop_init_tgt(struct ublksrv_dev *dev, int type, int argc, char
 			jbuf = ublksrv_tgt_realloc_json_buf(dev, &jbuf_size);
 	} while (ret < 0);
 
+	if (tgt->tgt_bpf_obj) {
+		bpf_obj = (struct ublk_bpf *)tgt->tgt_bpf_obj;
+		bpf_obj->data->target_fd = tgt->fds[1];
+	}
 	return 0;
 }
 
@@ -252,9 +275,14 @@ static int loop_queue_tgt_io(const struct ublksrv_queue *q,
 		const struct ublk_io_data *data, int tag)
 {
 	const struct ublksrv_io_desc *iod = data->iod;
-	struct io_uring_sqe *sqe = io_uring_get_sqe(q->ring_ptr);
+	struct io_uring_sqe *sqe;
 	unsigned ublk_op = ublksrv_get_op(iod);
 
+	/* Currently ebpf prog wil handle read/write requests. */
+	if ((ublk_op == UBLK_IO_OP_READ) || (ublk_op == UBLK_IO_OP_WRITE))
+		return 1;
+
+	sqe = io_uring_get_sqe(q->ring_ptr);
 	if (!sqe)
 		return 0;
 
@@ -374,6 +402,7 @@ struct ublksrv_tgt_type  loop_tgt_type = {
 	.type	= UBLKSRV_TGT_TYPE_LOOP,
 	.name	=  "loop",
 	.recovery_tgt = loop_recovery_tgt,
+	.init_queue_bpf = loop_init_queue_bpf,
 };
 
 static void tgt_loop_init() __attribute__((constructor));
diff --git a/ublksrv_tgt.cpp b/ublksrv_tgt.cpp
index 5ed328d..34e59b2 100644
--- a/ublksrv_tgt.cpp
+++ b/ublksrv_tgt.cpp
@@ -2,6 +2,7 @@
 
 #include "config.h"
 #include "ublksrv_tgt.h"
+#include "bpf/.tmp/ublk.skel.h"
 
 /* per-task variable */
 static pthread_mutex_t jbuf_lock;
@@ -575,6 +576,30 @@ static void ublksrv_tgt_set_params(struct ublksrv_ctrl_dev *cdev,
 	}
 }
 
+static int ublksrv_tgt_load_bpf_prog(struct ublksrv_ctrl_dev *cdev)
+{
+	struct ublk_bpf *obj;
+	int ret, io_bpf_fd;
+
+	obj = ublk_bpf__open();
+	if (!obj) {
+		fprintf(stderr, "failed to open BPF object\n");
+		return -1;
+	}
+	ret = ublk_bpf__load(obj);
+	if (ret) {
+		fprintf(stderr, "failed to load BPF object\n");
+		return -1;
+	}
+
+
+	io_bpf_fd = bpf_program__fd(obj->progs.ublk_io_bpf_prog);
+	ret = ublksrv_ctrl_reg_bpf_prog(cdev, io_bpf_fd);
+	if (!ret)
+		ublksrv_ctrl_set_bpf_obj_info(cdev, obj);
+	return ret;
+}
+
 static int cmd_dev_add(int argc, char *argv[])
 {
 	static const struct option longopts[] = {
@@ -696,6 +721,13 @@ static int cmd_dev_add(int argc, char *argv[])
 		goto fail;
 	}
 
+	ret = ublksrv_tgt_load_bpf_prog(dev);
+	if (ret < 0) {
+		fprintf(stderr, "dev %d load bpf prog failed, ret %d\n",
+			data.dev_id, ret);
+		goto fail_stop_daemon;
+	}
+
 	{
 		const struct ublksrv_ctrl_dev_info *info =
 			ublksrv_ctrl_get_dev_info(dev);
-- 
2.31.1

