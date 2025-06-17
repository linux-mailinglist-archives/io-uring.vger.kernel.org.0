Return-Path: <io-uring+bounces-8403-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 228C4ADDBA6
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 20:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5D737174EFC
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 18:50:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8BD528B507;
	Tue, 17 Jun 2025 18:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WJC86T/e"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7B22EF9D4
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 18:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750186205; cv=none; b=dc6ihXLzu3AdEQrDfYuduoG5jVLqAUAKmuCKdZ9vzjWAN1iJsePIM+lToVVNExjtHtk4MbD/N8fJxjq13YysKxN5jBHN2WvPMfkCa3a7G5KXCgG7TR4Wc2xSeltajUvIXmKiOIetFujU/+mHyIsx2/4XMwEm1b/UzJ1wLVsZAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750186205; c=relaxed/simple;
	bh=5fhaCT1mRmMNs4gzZUJZJ6yj9+qYbt1jrFm1k1xtKzg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=vBj0hjt9aKz3Y6UyXFvDQr25RSSlFsWLeFGFm3Led9dVBwHarXAW33RzfSU3WlM93hLWbayoO7DEqDmqoi9uCC/tsbSHuCu4xeZaBFi/opprqyC+WGjl7RKrJuZvR+vSKXO64N2OMKDBJzr6ISIF0lmdFXrBQZ/8eOxz1RjrrJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WJC86T/e; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HIUB3a025466;
	Tue, 17 Jun 2025 11:50:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=dhOuFDCRwfiG/lQb86
	DB9z5l2RO0ZN5DwV/44cfBoT4=; b=WJC86T/eFd7G40y2Ttyq3M7acoyecRMEzx
	EIetuqQn9nNIb0QLgpne6YhhbljmLo1ME4awhDEXx4bsVVOHWt7t2e0vzJD+f9HU
	BqNFgAHMmd9BlO7Y8IdN6QdBGyA76DqXIWY40//AkO9weF53p3y5MbaD4sGoxDyM
	HG8KuFh5tS1Lba8SZrpakqsU/wyj9oVo2luXhBd9kQGJR0VS9D9SlFNNlcP1+YPV
	w0kSOxThqAP390Yb2LgflcvLLuj8M0YaeSq/Cz+oviWMD5QuhVg+fLwboEDiANmr
	SJfb+dSr6UyQCk5z2nbmL5kfD9AVxipKB0+PzfTpIEFP7RELVb1w==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 47b3tpng0q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Tue, 17 Jun 2025 11:50:01 -0700 (PDT)
Received: from localhost (2620:10d:c085:208::7cb7) by mail.thefacebook.com
 (2620:10d:c08b:78::c78f) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.24; Tue, 17 Jun
 2025 18:50:01 +0000
From: Vishwanath Seshagiri <vishs@meta.com>
To: Jens Axboe <axboe@kernel.dk>
CC: <io-uring@vger.kernel.org>, Vishwanath Seshagiri <vishs@fb.com>
Subject: [PATCH] io_uring: add header include guards to all header files
Date: Tue, 17 Jun 2025 11:50:01 -0700
Message-ID: <20250617185001.1782992-1-vishs@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDE1MCBTYWx0ZWRfXz1yyIBC6DbNg 1+zIDttehwuJ8qAeMpXLQ/L5QTCG/XMBLkVs4MhkCY+1QRmBJakRnNdalAU+neLW9svJfh6npnp SsEwxm5cOWvzUxkN9l7b1z3d5bzXoLSycAwbjkWt4CjmOqrqZzSr66wdsEkyYgDHE5Cj8zhePVS
 N3X5t5mORKP5zwDK19ECIuhQ1svPBpn8ovmyYjOHnHp4X8/Lvdlc68hh1AuglPmMxA4ies34Ii+ 7flBkq2HZTIRw7erNOicT1SmFAl0eN/DtdM5cZosMT+772qMMuPS3Cxi86tShxkJFQP3MitJ8Qq 5v6DEBUxi7s0XRHWbaMfkmofvsEv/hiFGYthi8QyBdYV2AV0VdvxtSmJ7i60hCqrlgT+vc0npKP
 mL8zjrYr9grS42FJXbEermNeOxP7PmO8I5j7SdOEPcxoSaqm76t6V4r9B93jgCvatn1pPdZj
X-Proofpoint-ORIG-GUID: LC7BZQU38UVVNwkU53vvqTI07VEnxP1e
X-Authority-Analysis: v=2.4 cv=W+U4VQWk c=1 sm=1 tr=0 ts=6851b8da cx=c_pps a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17 a=6IFa9wvqVegA:10 a=FOH2dFAWAAAA:8 a=qmvXmCLe00YvF5sAUzcA:9
X-Proofpoint-GUID: LC7BZQU38UVVNwkU53vvqTI07VEnxP1e
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_08,2025-06-13_01,2025-03-28_01

From: Vishwanath Seshagiri <vishs@fb.com>

Add missing header include guards to all *.h files in the io_uring/
directory to prevent multiple inclusion issues. This follows the
established pattern used in io_uring/zcrx.h and other kernel headers.

The guards use the format IOU_<NAME>_H to maintain consistency with
the io_uring subsystem naming conventions.

Testing: Verified functionality with liburing test suite - all tests pass.
---
 io_uring/advise.h    | 3 +++
 io_uring/epoll.h     | 3 +++
 io_uring/eventfd.h   | 4 ++++
 io_uring/fdinfo.h    | 3 +++
 io_uring/fs.h        | 4 +++-
 io_uring/futex.h     | 4 +++-
 io_uring/msg_ring.h  | 4 +++-
 io_uring/net.h       | 3 +++
 io_uring/nop.h       | 3 +++
 io_uring/openclose.h | 3 +++
 io_uring/rw.h        | 3 +++
 io_uring/splice.h    | 3 +++
 io_uring/sqpoll.h    | 3 +++
 io_uring/statx.h     | 3 +++
 io_uring/sync.h      | 3 +++
 io_uring/tctx.h      | 3 +++
 io_uring/timeout.h   | 3 +++
 io_uring/truncate.h  | 3 +++
 io_uring/uring_cmd.h | 3 +++
 io_uring/waitid.h    | 3 +++
 io_uring/xattr.h     | 3 +++
 21 files changed, 64 insertions(+), 3 deletions(-)

diff --git a/io_uring/advise.h b/io_uring/advise.h
index 5ece2a045185..d6ba942751da 100644
--- a/io_uring/advise.h
+++ b/io_uring/advise.h
@@ -1,7 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_ADVISE_H
+#define IOU_ADVISE_H
 
 int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_madvise(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_fadvise(struct io_kiocb *req, unsigned int issue_flags);
+#endif
diff --git a/io_uring/epoll.h b/io_uring/epoll.h
index 4111997c360b..b74ea0edb975 100644
--- a/io_uring/epoll.h
+++ b/io_uring/epoll.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_EPOLL_H
+#define IOU_EPOLL_H
 
 #if defined(CONFIG_EPOLL)
 int io_epoll_ctl_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
@@ -6,3 +8,4 @@ int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags);
 int io_epoll_wait_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_epoll_wait(struct io_kiocb *req, unsigned int issue_flags);
 #endif
+#endif
diff --git a/io_uring/eventfd.h b/io_uring/eventfd.h
index e2f1985c2cf9..200ea096786d 100644
--- a/io_uring/eventfd.h
+++ b/io_uring/eventfd.h
@@ -1,3 +1,6 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_EVENT_FD_H
+#define IOU_EVENT_FD_H
 
 struct io_ring_ctx;
 int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -5,3 +8,4 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 
 void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event);
+#endif
diff --git a/io_uring/fdinfo.h b/io_uring/fdinfo.h
index 6fde48c450e3..56772731e7a1 100644
--- a/io_uring/fdinfo.h
+++ b/io_uring/fdinfo.h
@@ -1,3 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_FD_INFO_H
+#define IOU_FD_INFO_H
 
 void io_uring_show_fdinfo(struct seq_file *m, struct file *f);
+#endif
diff --git a/io_uring/fs.h b/io_uring/fs.h
index 0bb5efe3d6bb..b84fb1730b84 100644
--- a/io_uring/fs.h
+++ b/io_uring/fs.h
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-
+#ifndef IOU_FS_H
+#define IOU_FS_H
 int io_renameat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_renameat(struct io_kiocb *req, unsigned int issue_flags);
 void io_renameat_cleanup(struct io_kiocb *req);
@@ -18,3 +19,4 @@ int io_symlinkat(struct io_kiocb *req, unsigned int issue_flags);
 int io_linkat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_linkat(struct io_kiocb *req, unsigned int issue_flags);
 void io_link_cleanup(struct io_kiocb *req);
+#endif
diff --git a/io_uring/futex.h b/io_uring/futex.h
index d789fcf715e3..abdc621690a1 100644
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
-
+#ifndef IOU_FUTEX_H
+#define IOU_FUTEX_H
 #include "cancel.h"
 
 int io_futex_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
@@ -35,3 +36,4 @@ static inline void io_futex_cache_free(struct io_ring_ctx *ctx)
 {
 }
 #endif
+#endif
diff --git a/io_uring/msg_ring.h b/io_uring/msg_ring.h
index 32236d2fb778..e1c648652c30 100644
--- a/io_uring/msg_ring.h
+++ b/io_uring/msg_ring.h
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-
+#ifndef IOU_MSG_RING_H
+#define IOU_MSG_RING_H
 int io_uring_sync_msg_ring(struct io_uring_sqe *sqe);
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags);
 void io_msg_ring_cleanup(struct io_kiocb *req);
+#endif
diff --git a/io_uring/net.h b/io_uring/net.h
index 43e5ce5416b7..3d8084d7b7e2 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_NET_H
+#define IOU_NET_H
 
 #include <linux/net.h>
 #include <linux/uio.h>
@@ -65,3 +67,4 @@ static inline void io_netmsg_cache_free(const void *entry)
 {
 }
 #endif
+#endif
diff --git a/io_uring/nop.h b/io_uring/nop.h
index 97f1535c9dec..23c715d9761c 100644
--- a/io_uring/nop.h
+++ b/io_uring/nop.h
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_NOP_H
+#define IOU_NOP_H
 
 int io_nop_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_nop(struct io_kiocb *req, unsigned int issue_flags);
+#endif
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 4ca2a9935abc..1460650c1353 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_OPEN_CLOSE_H
+#define IOU_OPEN_CLOSE_H
 
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset);
@@ -18,3 +20,4 @@ int io_pipe(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_install_fixed_fd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_install_fixed_fd(struct io_kiocb *req, unsigned int issue_flags);
+#endif
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 129a53fe5482..ce77feadd953 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_RW_H
+#define IOU_RW_H
 
 #include <linux/io_uring_types.h>
 #include <linux/pagemap.h>
@@ -50,3 +52,4 @@ void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw);
 int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags);
 void io_rw_cache_free(const void *entry);
+#endif
diff --git a/io_uring/splice.h b/io_uring/splice.h
index b9b2848327fb..0cf2d0e5ac3e 100644
--- a/io_uring/splice.h
+++ b/io_uring/splice.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_SPLICE_H
+#define IOU_SPLICE_H
 
 int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_tee(struct io_kiocb *req, unsigned int issue_flags);
@@ -6,3 +8,4 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags);
 void io_splice_cleanup(struct io_kiocb *req);
 int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_splice(struct io_kiocb *req, unsigned int issue_flags);
+#endif
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index b83dcdec9765..563e2c9bfac8 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_SQ_POLL_H
+#define IOU_SQ_POLL_H
 
 struct io_sq_data {
 	refcount_t		refs;
@@ -35,3 +37,4 @@ static inline struct task_struct *sqpoll_task_locked(struct io_sq_data *sqd)
 	return rcu_dereference_protected(sqd->thread,
 					 lockdep_is_held(&sqd->lock));
 }
+#endif
diff --git a/io_uring/statx.h b/io_uring/statx.h
index 9a17f4d45a7d..ea9122e6b1c6 100644
--- a/io_uring/statx.h
+++ b/io_uring/statx.h
@@ -1,5 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_STATX_H
+#define IOU_STATX_H
 
 int io_statx_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_statx(struct io_kiocb *req, unsigned int issue_flags);
 void io_statx_cleanup(struct io_kiocb *req);
+#endif
diff --git a/io_uring/sync.h b/io_uring/sync.h
index e873c888da79..0efc35b34cf7 100644
--- a/io_uring/sync.h
+++ b/io_uring/sync.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_SYNC_H
+#define IOU_SYNC_H
 
 int io_sfr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags);
@@ -8,3 +10,4 @@ int io_fsync(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_fallocate(struct io_kiocb *req, unsigned int issue_flags);
 int io_fallocate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+#endif
diff --git a/io_uring/tctx.h b/io_uring/tctx.h
index 608e96de70a2..80894af31b94 100644
--- a/io_uring/tctx.h
+++ b/io_uring/tctx.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_TC_TX_H
+#define IOU_TC_TX_H
 
 struct io_tctx_node {
 	struct list_head	ctx_node;
@@ -31,3 +33,4 @@ static inline int io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 
 	return __io_uring_add_tctx_node_from_submit(ctx);
 }
+#endif
diff --git a/io_uring/timeout.h b/io_uring/timeout.h
index 2b7c9ad72992..f766f95f8815 100644
--- a/io_uring/timeout.h
+++ b/io_uring/timeout.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_TIMEOUT_H
+#define IOU_TIMEOUT_H
 
 struct io_timeout_data {
 	struct io_kiocb			*req;
@@ -21,3 +23,4 @@ int io_link_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_timeout(struct io_kiocb *req, unsigned int issue_flags);
 int io_timeout_remove_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags);
+#endif
diff --git a/io_uring/truncate.h b/io_uring/truncate.h
index ec088293a478..87b7d0602c60 100644
--- a/io_uring/truncate.h
+++ b/io_uring/truncate.h
@@ -1,4 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_TRUNCATE_H
+#define IOU_TRUNCATE_H
 
 int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags);
+#endif
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index a6dad47afc6b..4bfe4fc59244 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_URING_CMD_H
+#define IOU_URING_CMD_H
 
 #include <linux/io_uring/cmd.h>
 #include <linux/io_uring_types.h>
@@ -18,3 +20,4 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all);
 
 void io_cmd_cache_free(const void *entry);
+#endif
diff --git a/io_uring/waitid.h b/io_uring/waitid.h
index d5544aaf302a..dad2ecc4e629 100644
--- a/io_uring/waitid.h
+++ b/io_uring/waitid.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_WAIT_ID_H
+#define IOU_WAIT_ID_H
 
 #include "../kernel/exit.h"
 
@@ -13,3 +15,4 @@ int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags);
 bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  bool cancel_all);
+#endif
diff --git a/io_uring/xattr.h b/io_uring/xattr.h
index 9b459d2ae90c..a7abee1454cb 100644
--- a/io_uring/xattr.h
+++ b/io_uring/xattr.h
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_XATTR_H
+#define IOU_XATTR_H
 
 void io_xattr_cleanup(struct io_kiocb *req);
 
@@ -13,3 +15,4 @@ int io_fgetxattr(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_getxattr_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_getxattr(struct io_kiocb *req, unsigned int issue_flags);
+#endif
-- 
2.47.1


