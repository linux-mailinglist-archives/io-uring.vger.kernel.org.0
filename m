Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BD976972C0
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 01:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjBOAlc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 19:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbjBOAl2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 19:41:28 -0500
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE7430E91;
        Tue, 14 Feb 2023 16:41:26 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VbhQb3h_1676421683;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VbhQb3h_1676421683)
          by smtp.aliyun-inc.com;
          Wed, 15 Feb 2023 08:41:23 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     ming.lei@redhat.com, axboe@kernel.dk, asml.silence@gmail.com,
        ZiyangZhang@linux.alibaba.com
Subject: [RFC 1/3] bpf: add UBLK program type
Date:   Wed, 15 Feb 2023 08:41:20 +0800
Message-Id: <20230215004122.28917-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
References: <20230215004122.28917-1-xiaoguang.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new program type BPF_PROG_TYPE_UBLK for ublk, which is a generic
framework for implementing block device logic from userspace. Typical
userspace block device impementations need to copy data between kernel
block layer's io requests and userspace block device's userspace daemon,
which will consume cpu resources, especially for large io.

There are methods trying to reduce these cpu overheads, then userspace
block device's io performance will be improved further. These methods
contain: 1) use special hardware to do memory copy, but seems not all
architectures have these special hardware; 2) sofeware methods, such as
mmap kernel block layer's io requests's data to userspace daemon [1],
but it has page table's map/unmap, tlb flush overhead, etc, which maybe
only friendly to large io.

To solve this problem, I'd propose a new method which will use io_uring
to submit userspace daemon's io requests in kernel and use kernel block
device io requests's pages. Further, userspace block devices may have
different userspace logic about how to complete kernel io requests, here
we can use ebpf to implement various userspace log in kernel. In the
example of ublk loop target, we can easily implement such below logic in
ebpf prog:
  1. userspace daemon registers this ebpf prog and passes two backend file
fd in ebpf map structure。
  2. For kernel io requests against the first half of userspace device,
ebpf prog prepares an io_uring sqe, which will submit io against the first
backend file fd and sqe's buffer comes from kernel io reqeusts. Kernel
io requests against second half of userspace device has similar logic,
only sqe's fd will be the second backend file fd.
  3. When ublk driver blk-mq queue_rq() is called, this ebpf prog will
be executed and completes kernel io requests.

From above expample, we can see that this method has 3 advantages at least:
  1. Remove memory copy between kernel block layer and userspace daemon
completely.
  2. Save memory. Userspace daemon doesn't need to maintain memory to
issue and complete io requests, and use kernel block layer io requests
memory directly.
  2. We may reduce the numberr of  round trips between kernel and userspace
daemon.

Currently for this patchset, I just make ublk ebpf prog submit io requests
using io_uring in kernel, cqe event still needs to be handled in userspace
daemon. Once later we succeed in make io_uring handle cqe in kernel, ublk
ebpf prog can implement io in kernel.

[1] https://lore.kernel.org/all/20220318095531.15479-1-xiaoguang.wang@linux.alibaba.com/

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 drivers/block/ublk_drv.c       | 23 +++++++++++++++++++++++
 include/linux/bpf_types.h      |  2 ++
 include/uapi/linux/bpf.h       |  1 +
 kernel/bpf/syscall.c           |  1 +
 kernel/bpf/verifier.c          |  9 +++++++--
 tools/include/uapi/linux/bpf.h |  1 +
 tools/lib/bpf/libbpf.c         |  2 ++
 7 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6368b56eacf1..b628e9eaefa6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -43,6 +43,8 @@
 #include <asm/page.h>
 #include <linux/task_work.h>
 #include <uapi/linux/ublk_cmd.h>
+#include <linux/filter.h>
+#include <linux/bpf.h>
 
 #define UBLK_MINORS		(1U << MINORBITS)
 
@@ -187,6 +189,27 @@ static DEFINE_MUTEX(ublk_ctl_mutex);
 
 static struct miscdevice ublk_misc;
 
+static const struct bpf_func_proto *
+ublk_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id);
+}
+
+static bool ublk_bpf_is_valid_access(int off, int size,
+			enum bpf_access_type type,
+			const struct bpf_prog *prog,
+			struct bpf_insn_access_aux *info)
+{
+	return false;
+}
+
+const struct bpf_prog_ops bpf_ublk_prog_ops = {};
+
+const struct bpf_verifier_ops bpf_ublk_verifier_ops = {
+	.get_func_proto		= ublk_bpf_func_proto,
+	.is_valid_access	= ublk_bpf_is_valid_access,
+};
+
 static void ublk_dev_param_basic_apply(struct ublk_device *ub)
 {
 	struct request_queue *q = ub->ub_disk->queue;
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index d4ee3ccd3753..4ef0bc0251b7 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -79,6 +79,8 @@ BPF_PROG_TYPE(BPF_PROG_TYPE_LSM, lsm,
 #endif
 BPF_PROG_TYPE(BPF_PROG_TYPE_SYSCALL, bpf_syscall,
 	      void *, void *)
+BPF_PROG_TYPE(BPF_PROG_TYPE_UBLK, bpf_ublk,
+	      void *, void *)
 
 BPF_MAP_TYPE(BPF_MAP_TYPE_ARRAY, array_map_ops)
 BPF_MAP_TYPE(BPF_MAP_TYPE_PERCPU_ARRAY, percpu_array_map_ops)
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 464ca3f01fe7..515b7b995b3a 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -986,6 +986,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_UBLK,
 };
 
 enum bpf_attach_type {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ecca9366c7a6..eb1752243f4f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2432,6 +2432,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
 	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
 	case BPF_PROG_TYPE_CGROUP_SYSCTL:
 	case BPF_PROG_TYPE_SOCK_OPS:
+	case BPF_PROG_TYPE_UBLK:
 	case BPF_PROG_TYPE_EXT: /* extends any prog */
 		return true;
 	case BPF_PROG_TYPE_CGROUP_SKB:
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7ee218827259..1e5bc89aea36 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12235,6 +12235,10 @@ static int check_return_code(struct bpf_verifier_env *env)
 		}
 		break;
 
+	case BPF_PROG_TYPE_UBLK:
+		range = tnum_const(0);
+		break;
+
 	case BPF_PROG_TYPE_EXT:
 		/* freplace program can return anything as its return value
 		 * depends on the to-be-replaced kernel func or bpf program.
@@ -16770,8 +16774,9 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
 	}
 
 	if (prog->aux->sleepable && prog->type != BPF_PROG_TYPE_TRACING &&
-	    prog->type != BPF_PROG_TYPE_LSM && prog->type != BPF_PROG_TYPE_KPROBE) {
-		verbose(env, "Only fentry/fexit/fmod_ret, lsm, and kprobe/uprobe programs can be sleepable\n");
+	    prog->type != BPF_PROG_TYPE_LSM && prog->type != BPF_PROG_TYPE_KPROBE &&
+	    prog->type != BPF_PROG_TYPE_UBLK) {
+		verbose(env, "Only fentry/fexit/fmod_ret, lsm, and kprobe/uprobe, ublk programs can be sleepable\n");
 		return -EINVAL;
 	}
 
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 464ca3f01fe7..515b7b995b3a 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -986,6 +986,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_LSM,
 	BPF_PROG_TYPE_SK_LOOKUP,
 	BPF_PROG_TYPE_SYSCALL, /* a program that can execute syscalls */
+	BPF_PROG_TYPE_UBLK,
 };
 
 enum bpf_attach_type {
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2a82f49ce16f..6fe77f9a2cc8 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8606,6 +8606,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("cgroup/dev",		CGROUP_DEVICE, BPF_CGROUP_DEVICE, SEC_ATTACHABLE_OPT),
 	SEC_DEF("struct_ops+",		STRUCT_OPS, 0, SEC_NONE),
 	SEC_DEF("sk_lookup",		SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE),
+	SEC_DEF("ublk/",		UBLK, 0, SEC_SLEEPABLE),
+	SEC_DEF("ublk.s/",		UBLK, 0, SEC_SLEEPABLE),
 };
 
 static size_t custom_sec_def_cnt;
-- 
2.31.1

