Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5145999FE
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 12:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348445AbiHSKk5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 06:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348451AbiHSKky (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 06:40:54 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93747F4383
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 03:40:52 -0700 (PDT)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220819104047epoutp028c2f083ffd46a67451058f83698cf05d~MuOL5Ixpa1795917959epoutp02P
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 10:40:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220819104047epoutp028c2f083ffd46a67451058f83698cf05d~MuOL5Ixpa1795917959epoutp02P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1660905647;
        bh=jbua48Q58XlA+8adVklDtQ//CCw/sQv/vde37Fg5XWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MeAJnTGwBOpKMZLGTuurQaVDjDEfEFxLLX2f9pN5VdMBn0VVi/BO/VpMl+L84qHRW
         N7j/CdysudUV/KKLuG42j1QfAuVr41PWEbTio7TmmqjFJMzepMb7TacYVyqEl8xZrX
         8z+orTDdSMhwy1CJSkefg8CG6ptG7jqcTfS025Zs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20220819104043epcas5p248f8ce6ed4cbbc4e4ca7d141b2a7b874~MuOIcVbzi3177231772epcas5p2D;
        Fri, 19 Aug 2022 10:40:43 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4M8JF52rytz4x9Pv; Fri, 19 Aug
        2022 10:40:41 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.63.49150.7A86FF26; Fri, 19 Aug 2022 19:40:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae~MuODxaAfn3086930869epcas5p22;
        Fri, 19 Aug 2022 10:40:38 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220819104038epsmtrp103129c4c48ecb00fbb7dcbdb843f3b49~MuODwby3d1513515135epsmtrp1E;
        Fri, 19 Aug 2022 10:40:38 +0000 (GMT)
X-AuditID: b6c32a4b-37dff7000000bffe-d0-62ff68a77345
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        FD.7C.08905.6A86FF26; Fri, 19 Aug 2022 19:40:38 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220819104037epsmtip1bbf0de911f42c1ac039aac8296d27063~MuOCQaBz40577205772epsmtip1h;
        Fri, 19 Aug 2022 10:40:37 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: [PATCH for-next 2/4] io_uring: introduce fixed buffer support for
 io_uring_cmd
Date:   Fri, 19 Aug 2022 16:00:19 +0530
Message-Id: <20220819103021.240340-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819103021.240340-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBJsWRmVeSWpSXmKPExsWy7bCmlu7yjP9JBht/sVo0TfjLbLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PK4fLbUY9OqTjaP
        zUvqPXbfbGDzeL/vKptH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74dqqLpeCUesX/hz3MDYyHFboYOTkkBEwkvj48
        z9bFyMUhJLCbUeJz+2QmCOcTo8T6+b8YIZxvjBIde1uAyjjAWlrmx0LE9zJKXF3zjBXC+cwo
        sXP+akaQIjYBTYkLk0tBVogIGEns/3QSrIZZ4AKjxMmmr8wgCWGBSIlvt2+ygtSzCKhKnL+m
        CBLmFbCUuPj5EBvEefISMy99ZwexOQWsJGYtvcoGUSMocXLmExYQmxmopnnrbGaQ+RICnRwS
        V/ZsZ4JodpE4v+ITK4QtLPHq+BZ2CFtK4mV/G5SdLHFp5jmo+hKJx3sOQtn2Eq2n+plBbmMG
        +mX9Ln2IXXwSvb+fMEHCgVeio00IolpR4t6kp1CbxCUezlgCZXtIfNjSAA3QXkaJ/3OWMU5g
        lJ+F5IVZSF6YhbBtASPzKkbJ1ILi3PTUYtMC47zUcni8JufnbmIEJ1Et7x2Mjx580DvEyMTB
        eIhRgoNZSYT3xp0/SUK8KYmVValF+fFFpTmpxYcYTYFBPJFZSjQ5H5jG80riDU0sDUzMzMxM
        LI3NDJXEeb2ubkoSEkhPLEnNTk0tSC2C6WPi4JRqYNp9o1RnUtdbfkX1XPbHgvlJZ3UV336a
        99vUZ9mqIqtHvr1bDL7ePHdAYqGlT2TYp4OM/WeL7zcvkFx55ZDKkYvTNvsdv8veLHOuffH6
        1ZWOL5aqCV76f2NX0yrtvAX7hN0FL09/+mp5b9bc1NZpfo4pD34WKd0Kmb/SaOqvywHaD3xX
        8S1z4Xecq3D+26HLt06weTLFX5n70uUsl5XAev/j2uc+blKef2f+6oZQRokt5T3CanYnGGQv
        B14Pmu1VLiHG+Lf36eInp5mip3xkeLZWzG1D6fb026ddu97l5nV0CKY2JrC2WF+1PucQs+//
        nkaejT8mXXv24bL9LE0blskTLHaKLeP4qGmwcsYB0U2zlViKMxINtZiLihMB0hfIcisEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnO6yjP9JBo+uals0TfjLbLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5NbmZy4PK4fLbUY9OqTjaP
        zUvqPXbfbGDzeL/vKptH35ZVjB6fN8kFsEdx2aSk5mSWpRbp2yVwZXw71cVScEq94v/DHuYG
        xsMKXYwcHBICJhIt82O7GLk4hAR2M0o0XnvL3MXICRQXl2i+9oMdwhaWWPnvOTtE0UdGiZ07
        v7CANLMJaEpcmFwKUiMiYCax9PAaFhCbWeAGo8S2CfkgJcIC4RJztjqAmCwCqhLnrymCVPAK
        WEpc/HyIDWK6vMTMS9/BNnEKWEnMWnoVLC4EVPPrbwcTRL2gxMmZT6Cmy0s0b53NPIFRYBaS
        1CwkqQWMTKsYJVMLinPTc4sNCwzzUsv1ihNzi0vz0vWS83M3MYJDX0tzB+P2VR/0DjEycTAe
        YpTgYFYS4b1x50+SEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NTC1KLYLJM
        HJxSDUx5S58nqvY76h/pfJp1y3zG8kD2b1FT22cEFD3PXDbpfZq66XotcefllhX15efXsNyu
        X/c/Tnr30YxTjJNnHt1S8OvytLnREn/9u88FeVh6FL++nht8a4XdNLGlU0Neihg/SjmjrKPd
        cmyXwP2iHDXRsG/zWQ1+R64UMXB5/ell2IRnP+ZwJB3dcTo9JOVIX+Pb8yJ/9gi8PFsc77rH
        cMv7VWtlMp1uT1xdv2Gy52zmx6vjY3faH7tavb56tovjrq5ZWntfeB745eTqEuzwhys//cSF
        TKWTcgnNddZFVje2bH7wR32h37NvR19WttwzzVW/yamhNfmfbarX6d3s0nPeyGVfWdfx83hC
        2OScI9+fK7EUZyQaajEXFScCAF5fVavsAgAA
X-CMS-MailID: 20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae
References: <20220819103021.240340-1-joshi.k@samsung.com>
        <CGME20220819104038epcas5p265c9385cfd9189d20ebfffeaa4d5efae@epcas5p2.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Anuj Gupta <anuj20.g@samsung.com>

Add IORING_OP_URING_CMD_FIXED opcode that enables sending io_uring
command with previously registered buffers. User-space passes the buffer
index in sqe->buf_index, same as done in read/write variants that uses
fixed buffers.

Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
---
 include/linux/io_uring.h      |  5 ++++-
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              | 10 ++++++++++
 io_uring/rw.c                 |  3 ++-
 io_uring/uring_cmd.c          | 18 +++++++++++++++++-
 5 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 60aba10468fc..40961d7c3827 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -5,6 +5,8 @@
 #include <linux/sched.h>
 #include <linux/xarray.h>
 
+#include<uapi/linux/io_uring.h>
+
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
 	IO_URING_F_UNLOCKED		= 2,
@@ -15,6 +17,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_SQE128		= 4,
 	IO_URING_F_CQE32		= 8,
 	IO_URING_F_IOPOLL		= 16,
+	IO_URING_F_FIXEDBUFS		= 32,
 };
 
 struct io_uring_cmd {
@@ -33,7 +36,7 @@ struct io_uring_cmd {
 
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
-		struct iov_iter *iter, void *ioucmd)
+		struct iov_iter *iter, void *ioucmd);
 void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret, ssize_t res2);
 void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 			void (*task_work_cb)(struct io_uring_cmd *));
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1463cfecb56b..80ea35d1ed5c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -203,6 +203,7 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_SENDZC_NOTIF,
+	IORING_OP_URING_CMD_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9a0df19306fe..7d5731b84c92 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -472,6 +472,16 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_uring_cmd,
 		.prep_async		= io_uring_cmd_prep_async,
 	},
+	[IORING_OP_URING_CMD_FIXED] = {
+		.needs_file		= 1,
+		.plug			= 1,
+		.name			= "URING_CMD_FIXED",
+		.iopoll			= 1,
+		.async_size		= uring_cmd_pdu_size(1),
+		.prep			= io_uring_cmd_prep,
+		.issue			= io_uring_cmd,
+		.prep_async		= io_uring_cmd_prep_async,
+	},
 	[IORING_OP_SENDZC_NOTIF] = {
 		.name			= "SENDZC_NOTIF",
 		.needs_file		= 1,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a4fb8a44b9a..3c7b94bffa62 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1005,7 +1005,8 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		if (req->opcode == IORING_OP_URING_CMD) {
+		if (req->opcode == IORING_OP_URING_CMD ||
+				req->opcode == IORING_OP_URING_CMD_FIXED) {
 			struct io_uring_cmd *ioucmd = (struct io_uring_cmd *)rw;
 
 			ret = req->file->f_op->uring_cmd_iopoll(ioucmd);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index ff65cc8ab6cc..9383150b2949 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,11 +3,13 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring.h>
+#include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
 #include "uring_cmd.h"
+#include "rsrc.h"
 
 static void io_uring_cmd_work(struct io_kiocb *req, bool *locked)
 {
@@ -74,6 +76,18 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (sqe->rw_flags || sqe->__pad1)
 		return -EINVAL;
+
+	req->buf_index = READ_ONCE(sqe->buf_index);
+	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
+		struct io_ring_ctx *ctx = req->ctx;
+		u16 index;
+
+		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+			return -EFAULT;
+		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
+		req->imu = ctx->user_bufs[index];
+		io_req_set_rsrc_node(req, ctx, 0);
+	}
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	return 0;
@@ -98,6 +112,8 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		req->iopoll_completed = 0;
 		WRITE_ONCE(ioucmd->cookie, NULL);
 	}
+	if (req->opcode == IORING_OP_URING_CMD_FIXED)
+		issue_flags |= IO_URING_F_FIXEDBUFS;
 
 	if (req_has_async_data(req))
 		ioucmd->cmd = req->async_data;
@@ -125,7 +141,7 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len,
 		int rw, struct iov_iter *iter, void *ioucmd)
 {
-	struct io_kiocb *req = container_of(ioucmd, struct io_kiocb, uring_cmd);
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
 	struct io_mapped_ubuf *imu = req->imu;
 
 	return io_import_fixed(rw, iter, imu, ubuf, len);
-- 
2.25.1

