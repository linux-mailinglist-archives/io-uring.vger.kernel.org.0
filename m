Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6F74D1C0C
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiCHPnm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347978AbiCHPni (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:43:38 -0500
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2784A1BF
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:42:33 -0800 (PST)
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220308154232epoutp02d81f5a88a0ade040d7bf8450ae75f9b2~aci0vPLvb3200332003epoutp02H
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:42:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220308154232epoutp02d81f5a88a0ade040d7bf8450ae75f9b2~aci0vPLvb3200332003epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754152;
        bh=U1RoaKLfaYKKu6QFXNo2zVIHlpoVqjMAIXls6xb1dJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0+fQGVzaa8WKvFE2lSkYZ+2nki6kTlkbRCr/6tQzEFLWWkub9G4Vi8ZxYdcbnFgO
         adcnKiJ8rLMZlV1dR6sdQXU+VM5jAEbT7cCqX4VufBnpI9ITHkuab0CwIDJAiFVJqV
         7NoefeDySOEoVCo5sHUVrqkoTDYGRoFiPSIISidc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220308154231epcas5p431d6bcee1f60b67d6b7c521b685471ff~aciz5kKHo2304623046epcas5p40;
        Tue,  8 Mar 2022 15:42:31 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.179]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfhx4kp6z4x9Pw; Tue,  8 Mar
        2022 15:42:25 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        F7.E6.46822.98677226; Wed,  9 Mar 2022 00:30:17 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220308152707epcas5p430127761a7fd4bf90c2501eabe9ee96e~acVXUfkd11840518405epcas5p4L;
        Tue,  8 Mar 2022 15:27:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152707epsmtrp27029ff4754249d2e5c83ff78fba113ce~acVXTxYdo2706527065epsmtrp29;
        Tue,  8 Mar 2022 15:27:07 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-20-62277689114a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        87.51.29871.BC577226; Wed,  9 Mar 2022 00:27:07 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152705epsmtip1ff777caf077ea0206ffaf6a7f753e9ea~acVVRlEJC0990109901epsmtip1a;
        Tue,  8 Mar 2022 15:27:04 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 07/17] io_uring: add support for uring_cmd with fixed-buffer
Date:   Tue,  8 Mar 2022 20:50:55 +0530
Message-Id: <20220308152105.309618-8-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPJsWRmVeSWpSXmKPExsWy7bCmlm5nmXqSwYlGFYvphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFZVtk5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr
        5OIToOuWmQP0g5JCWWJOKVAoILG4WEnfzqYov7QkVSEjv7jEVim1ICWnwKRArzgxt7g0L10v
        L7XEytDAwMgUqDAhO2Pjvjb2gmWyFT0vjjA2MP4U72Lk5JAQMJH4tfosexcjF4eQwG5GiYsn
        FjNCOJ8YJab23ILKfGOUuN79iQmm5f9LmMReRokHbx9CtXxmlFi4+AZLFyMHB5uApsSFyaUg
        DSICXhL3b79nBalhFuhikni77z4bSEJYwEdixq/9jCA2i4CqxNLDPcwgNq+ApcS/RRPYILbJ
        S8y89J0dxOYUsJL4eWsrK0SNoMTJmU9YQGxmoJrmrbOZQRZICJzgkNhx9jPUqS4SB6/OZYaw
        hSVeHd/CDmFLSXx+txdqQbHErztHoZo7gP5smMkCkbCXuLjnLxPIN8xA36zfpQ8RlpWYemod
        E8RiPone30+gdvFK7JgHYytK3Jv0lBXCFpd4OGMJlO0h8ePfDmjQ9TJKtKxaxTyBUWEWkodm
        IXloFsLqBYzMqxglUwuKc9NTi00LjPJSy+HxnJyfu4kRnLK1vHYwPnzwQe8QIxMH4yFGCQ5m
        JRHe++dVkoR4UxIrq1KL8uOLSnNSiw8xmgJDfCKzlGhyPjBr5JXEG5pYGpiYmZmZWBqbGSqJ
        855O35AoJJCeWJKanZpakFoE08fEwSnVwJRycUHI484tNueXxzxaI6sxJT/6QXrB7JYEv9Ce
        YPHDHNcjnvmfUvi+Nzj/zKG1Meb7zPZW5VdssG+Xvt3TKhAmOU9MPTp/4/2ErytV+uWqbl25
        9uP2VR+Zw2/uLTqm3Kd9xsZRPO2EzC4n9kNXs78wT7tn3nvQ0frBv5cVjm+tDbY7yLHHnH+8
        nudHCFuGGste2U8bvvnmtz7RPCvjLWTwduIU0ee/6o9XuDpzX6hbY7Zo2szH4toS0200JHdr
        /f3yJLngmOH944Zt/6fnu/1Lr1X9///7jh3L+vdbeYQUCm+1DdBneXatfnvPnsWtu3Mvd3y+
        mbHtP1P+hqP2P26sMLbgUquzz9KIMRRbMlGJpTgj0VCLuag4EQA3j5XuYgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42LZdlhJTvd0qXqSwZceNovphxUtmib8ZbaY
        s2obo8Xqu/1sFitXH2WyeNd6jsWi8/QFJovzbw8zWUw6dI3RYu8tbYv5y56yWyxpPc5mcWPC
        U0aLNTefslh8PjOP1YHf49nVZ4weO2fdZfdoXnCHxePy2VKPTas62Tw2L6n32H2zgc1j2+KX
        rB59W1YxenzeJBfAFcVlk5Kak1mWWqRvl8CVsXFfG3vBMtmKnhdHGBsYf4p3MXJySAiYSPx/
        eYu9i5GLQ0hgN6PEj90z2CAS4hLN136wQ9jCEiv/PYcq+sgosb/vJXMXIwcHm4CmxIXJpSA1
        IgIBEgcbL4PVMAvMYJLoaf7MApIQFvCRmPFrPyOIzSKgKrH0cA8ziM0rYCnxb9EEqGXyEjMv
        fQdbxilgJfHz1lZWEFsIqGbFut9sEPWCEidnPgGbyQxU37x1NvMERoFZSFKzkKQWMDKtYpRM
        LSjOTc8tNiwwzEst1ytOzC0uzUvXS87P3cQIjigtzR2M21d90DvEyMTBeIhRgoNZSYT3/nmV
        JCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYzjH93nAm
        9GG7Nme+PcMSmTZeqYPfthmqta2auV6I1e7Lnf1HJpc9feGwUHT6jYdlWhun97VfTtfoPP5m
        eTdr+IT/C2p3HCx0zzSS8T5bpKxxLyIueOXu84/rpKftOnOgq6tZhuOC1d2Z7sfn8rNsX9be
        +9nE4Fv3ipXp2y3fzp+/6OmGLWc2vtD4fkEz4rDyr20ct7dz3K0wfWR1cJK9qkdq22lH1wmZ
        HEGqHEe/15y4G2Sqsu2qbvOW3jWr+6v81RuW9a1RjWHbeuCQ4LFjNVPirhjM+RfYonf/R1uR
        gafZ5XvHbs08mme/1er5+VnbYk1s5mlVtXaL/NCqtQ9OTD56xnLSy8QUWft9DpuuyiqxFGck
        GmoxFxUnAgBLwz6ZFwMAAA==
X-CMS-MailID: 20220308152707epcas5p430127761a7fd4bf90c2501eabe9ee96e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152707epcas5p430127761a7fd4bf90c2501eabe9ee96e
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152707epcas5p430127761a7fd4bf90c2501eabe9ee96e@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_OP_URING_CMD_FIXED opcode that enables performing the
operation with previously registered buffers.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 fs/io_uring.c                 | 29 ++++++++++++++++++++++++++++-
 include/linux/io_uring.h      |  1 +
 include/uapi/linux/io_uring.h |  1 +
 3 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ead0cbae8416..6a1dcea0f538 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1107,6 +1107,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_URING_CMD] = {
 		.needs_file		= 1,
 	},
+	[IORING_OP_URING_CMD_FIXED] = {
+		.needs_file		= 1,
+	},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -4148,16 +4151,25 @@ EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 static int io_uring_cmd_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cmd *ioucmd = &req->uring_cmd;
 
 	if (!req->file->f_op->async_cmd || !(req->ctx->flags & IORING_SETUP_SQE128))
 		return -EOPNOTSUPP;
 	if (req->ctx->flags & IORING_SETUP_IOPOLL)
 		return -EOPNOTSUPP;
+	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
+		req->imu = NULL;
+		io_req_set_rsrc_node(req, ctx);
+		req->buf_index = READ_ONCE(sqe->buf_index);
+		ioucmd->flags = IO_URING_F_UCMD_FIXEDBUFS;
+	} else {
+		ioucmd->flags = 0;
+	}
+
 	ioucmd->cmd = (void *) &sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 	ioucmd->cmd_len = READ_ONCE(sqe->cmd_len);
-	ioucmd->flags = 0;
 	return 0;
 }
 
@@ -4167,6 +4179,19 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 	struct io_uring_cmd *ioucmd = &req->uring_cmd;
 
+	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
+		u32 index, buf_index = req->buf_index;
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_mapped_ubuf *imu = req->imu;
+
+		if (likely(!imu)) {
+			if (unlikely(buf_index >= ctx->nr_user_bufs))
+				return -EFAULT;
+			index = array_index_nospec(buf_index, ctx->nr_user_bufs);
+			imu = READ_ONCE(ctx->user_bufs[index]);
+			req->imu = imu;
+		}
+	}
 	ioucmd->flags |= issue_flags;
 	ret = file->f_op->async_cmd(ioucmd);
 	/* queued async, consumer will call io_uring_cmd_done() when complete */
@@ -6656,6 +6681,7 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
 	case IORING_OP_URING_CMD:
+	case IORING_OP_URING_CMD_FIXED:
 		return io_uring_cmd_prep(req, sqe);
 	}
 
@@ -6941,6 +6967,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_linkat(req, issue_flags);
 		break;
 	case IORING_OP_URING_CMD:
+	case IORING_OP_URING_CMD_FIXED:
 		ret = io_uring_cmd(req, issue_flags);
 		break;
 	default:
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 1888a5ea7dbe..abad6175739e 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -8,6 +8,7 @@
 enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
 	IO_URING_F_UNLOCKED		= 2,
+	IO_URING_F_UCMD_FIXEDBUFS	= 4,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 };
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9bf1d6c0ed7f..ee84be4b6be8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -155,6 +155,7 @@ enum {
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
 	IORING_OP_URING_CMD,
+	IORING_OP_URING_CMD_FIXED,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.25.1

