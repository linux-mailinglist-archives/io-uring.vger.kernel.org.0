Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE674D1C19
	for <lists+io-uring@lfdr.de>; Tue,  8 Mar 2022 16:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiCHPoK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Mar 2022 10:44:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347943AbiCHPoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Mar 2022 10:44:09 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46EB034B8B
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 07:43:12 -0800 (PST)
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220308154310epoutp0171f986bf8765f21ef81112201c267948~acjYsFjFE1289012890epoutp01R
        for <io-uring@vger.kernel.org>; Tue,  8 Mar 2022 15:43:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220308154310epoutp0171f986bf8765f21ef81112201c267948~acjYsFjFE1289012890epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1646754190;
        bh=sJAKQq5cu+BeAFJ67QPYN1xE08QBey0SZKYq+gcQQjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QCLr6pgvjZtLJE9I8XcJP7YQm69nAvaKqy3uk+8g/p6uT4+2vBquxURhsyoBMXZtx
         QcRRZAXNUEtfdO+AOKyJsr/D/IyWnKR7i02Xq8ExuHhamNDDJ5j3PV0KwyeDkrJlBU
         Juv8svSF94ZI7+B1KvihMrsW5wDWJa+Iyt2PeyoQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220308154310epcas5p39e8f0de73e701e8816476ccce48f652d~acjYKbEDG1091910919epcas5p3z;
        Tue,  8 Mar 2022 15:43:10 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.180]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4KCfjk4Zs8z4x9Pv; Tue,  8 Mar
        2022 15:43:06 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        A4.F6.46822.2B677226; Wed,  9 Mar 2022 00:30:58 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
        20220308152723epcas5p34460b4af720e515317f88dbb78295f06~acVmPNsAI0623006230epcas5p30;
        Tue,  8 Mar 2022 15:27:23 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220308152723epsmtrp2ee59c041947572c36d5357c97abd96cd~acVmOWS_E2706527065epsmtrp2F;
        Tue,  8 Mar 2022 15:27:23 +0000 (GMT)
X-AuditID: b6c32a4a-de5ff7000000b6e6-58-622776b2f68a
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        BC.51.29871.AD577226; Wed,  9 Mar 2022 00:27:23 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20220308152720epsmtip1007a153d494d25e1583d17ab1e2ec74a~acVkHsp6q3168431684epsmtip1H;
        Tue,  8 Mar 2022 15:27:20 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: [PATCH 14/17] io_uring: add polling support for uring-cmd
Date:   Tue,  8 Mar 2022 20:51:02 +0530
Message-Id: <20220308152105.309618-15-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220308152105.309618-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNJsWRmVeSWpSXmKPExsWy7bCmhu6mMvUkgz3P5CymH1a0aJrwl9li
        zqptjBar7/azWaxcfZTJ4l3rORaLztMXmCzOvz3MZDHp0DVGi723tC3mL3vKbrGk9TibxY0J
        Txkt1tx8ymLx+cw8Vgd+j2dXnzF67Jx1l92jecEdFo/LZ0s9Nq3qZPPYvKTeY/fNBjaPbYtf
        snr0bVnF6PF5k1wAV1S2TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqt
        kotPgK5bZg7QD0oKZYk5pUChgMTiYiV9O5ui/NKSVIWM/OISW6XUgpScApMCveLE3OLSvHS9
        vNQSK0MDAyNToMKE7Iz3HQkFXUoViy88Y2pgnCbdxcjBISFgIjH5f0oXIyeHkMBuRokPf827
        GLmA7E+MEjOfLGeHcL4xSuxcvoQdpAqkYd25+WwQib2MEp8frIOq+swo8eP/UiaQsWwCmhIX
        JpeCNIgIeEncv/2eFaSGWaCLSeLtvvtsIAlhASeJjz39TCA2i4CqxIeZF5lBenkFrCQmbJKA
        WCYvMfPSd7DFnEDhn7e2soLYvAKCEidnPmEBsZmBapq3zmYGmS8hcIRD4szNK4wQzS4S12bu
        h7paWOLV8S1QtpTE53d72SDsYolfd45CNXcwSlxvmMkCkbCXuLjnL9gzzEDPrN+lDxGWlZh6
        ah0TxGI+id7fT5gg4rwSO+bB2IoS9yY9ZYWwxSUezlgCZXtIzN32BxpYvYwSE/edZJ7AqDAL
        yUOzkDw0C2H1AkbmVYySqQXFuempxaYFRnmp5fA4Ts7P3cQITtVaXjsYHz74oHeIkYmD8RCj
        BAezkgjv/fMqSUK8KYmVValF+fFFpTmpxYcYTYEBPpFZSjQ5H5gt8kriDU0sDUzMzMxMLI3N
        DJXEeU+nb0gUEkhPLEnNTk0tSC2C6WPi4JRqYOq6NTnB2SVHW0ns8UV9w4drTf5vbznfXKTf
        eFqwY7bY5tdaAYVrc+YK/K64GjQnmK8smunoauMPz9Pe/OyoLloldyEtyDrRleFZ6KWP19ZL
        y1qrZB7gzjgoIrdk1xzhs4/nGi+IF18zs3wuy41fa6f4SZxkmvml3Opi1ndX+R1FKneuWd5a
        sr34gvyXFfoZ503j33/xsHp+brpFYNcD6etbvH51XawKPZ2wjenedbfWH2/UI1Qm7U427fzm
        liv4hDFPoPqi5gmbP6eZb07ZeTGLdUJBq8X2X7W+u344aSbwrLD+8MJik8WW8ye+bn99VZrt
        ZfirZ2Hbb6dPmvZ01cRFCXb/5Nh87BqeGURu9nilxFKckWioxVxUnAgAaxm27l4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpikeLIzCtJLcpLzFFi42LZdlhJTvd2qXqSwdTzTBbTDytaNE34y2wx
        Z9U2RovVd/vZLFauPspk8a71HItF5+kLTBbn3x5msph06Bqjxd5b2hbzlz1lt1jSepzN4saE
        p4wWa24+ZbH4fGYeqwO/x7Orzxg9ds66y+7RvOAOi8fls6Uem1Z1snlsXlLvsftmA5vHtsUv
        WT36tqxi9Pi8SS6AK4rLJiU1J7MstUjfLoEr431HQkGXUsXiC8+YGhinSXcxcnJICJhIrDs3
        n62LkYtDSGA3o8SRrYfYIBLiEs3XfrBD2MISK/89Z4co+sgosWD1dpYuRg4ONgFNiQuTS0Fq
        RAQCJA42XgarYRaYwSTR0/yZBSQhLOAk8bGnnwnEZhFQlfgw8yIzSC+vgJXEhE0SEPPlJWZe
        +g62ixMo/PPWVlYQW0jAUmLFut9g9/AKCEqcnPkEbCQzUH3z1tnMExgFZiFJzUKSWsDItIpR
        MrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIziatDR3MG5f9UHvECMTB+MhRgkOZiUR3vvn
        VZKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYOJQ1r28
        tYQ912z5GadfFRqH2VIf9fn4+CfeacorK3SZVRH4PSw/MHL2XlZDrwuaKnFHRVzVguUm75d2
        Sj/eNevyn3M7n1/yLWm8ksTxpn/xMWbLYOufjUksx3edfhry4p1QkMLmyM0C77NnNPbJyvh/
        zp7Vkur7O4WhpEGfTTWovDT/0dT2yS9OFByaz3DhfivnyYU/+fla7/1ZnsgXacL6T8b1tKdU
        y2JGg9+vQszTfp+7/XYSd4PYf77lM87nT3nOeLyxfaX+jh9SK8tn5uyU4P26I8qJfdnZVxLL
        NyV71k8OXN4jtSR8nq6Zz/Iv0wwMBIIiFmc/UDcWPvzFvrW5Tn7NoURbK1Vu579pSizFGYmG
        WsxFxYkAD8GTJBUDAAA=
X-CMS-MailID: 20220308152723epcas5p34460b4af720e515317f88dbb78295f06
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220308152723epcas5p34460b4af720e515317f88dbb78295f06
References: <20220308152105.309618-1-joshi.k@samsung.com>
        <CGME20220308152723epcas5p34460b4af720e515317f88dbb78295f06@epcas5p3.samsung.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pankaj Raghav <p.raghav@samsung.com>

Enable polling support infra for uring-cmd.
Collect the bio during submission, and use that to implement polling on
completion.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 fs/io_uring.c            | 51 ++++++++++++++++++++++++++++++++++------
 include/linux/io_uring.h |  9 +++++--
 2 files changed, 51 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f04bb497bd88..8bd9401f9964 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2664,7 +2664,20 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob, poll_flags);
+		if (req->opcode == IORING_OP_URING_CMD ||
+		    req->opcode == IORING_OP_URING_CMD_FIXED) {
+			/* uring_cmd structure does not contain kiocb struct */
+			struct kiocb kiocb_uring_cmd;
+
+			kiocb_uring_cmd.private = req->uring_cmd.bio;
+			kiocb_uring_cmd.ki_filp = req->uring_cmd.file;
+			ret = req->uring_cmd.file->f_op->iopoll(&kiocb_uring_cmd,
+			      &iob, poll_flags);
+		} else {
+			ret = kiocb->ki_filp->f_op->iopoll(kiocb, &iob,
+							   poll_flags);
+		}
+
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
@@ -2777,6 +2790,15 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    wq_list_empty(&ctx->iopoll_list))
 				break;
 		}
+
+		/*
+		 * In some scenarios, completion callback has been queued up to be
+		 * completed in-task context but polling happens in the same task
+		 * not giving a chance for the completion callback to complete.
+		 */
+		if (current->task_works)
+			io_run_task_work();
+
 		ret = io_do_iopoll(ctx, !min);
 		if (ret < 0)
 			break;
@@ -4136,6 +4158,14 @@ static int io_linkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static void io_complete_uring_cmd_iopoll(struct io_kiocb *req, long res)
+{
+	WRITE_ONCE(req->result, res);
+	/* order with io_iopoll_complete() checking ->result */
+	smp_wmb();
+	WRITE_ONCE(req->iopoll_completed, 1);
+}
+
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
@@ -4146,7 +4176,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret)
 
 	if (ret < 0)
 		req_set_fail(req);
-	io_req_complete(req, ret);
+
+	if (req->uring_cmd.flags & IO_URING_F_UCMD_POLLED)
+		io_complete_uring_cmd_iopoll(req, ret);
+	else
+		io_req_complete(req, ret);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
@@ -4158,15 +4192,18 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 
 	if (!req->file->f_op->async_cmd || !(req->ctx->flags & IORING_SETUP_SQE128))
 		return -EOPNOTSUPP;
-	if (req->ctx->flags & IORING_SETUP_IOPOLL)
-		return -EOPNOTSUPP;
+	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
+		ioucmd->flags = IO_URING_F_UCMD_POLLED;
+		ioucmd->bio = NULL;
+		req->iopoll_completed = 0;
+	} else {
+		ioucmd->flags = 0;
+	}
 	if (req->opcode == IORING_OP_URING_CMD_FIXED) {
 		req->imu = NULL;
 		io_req_set_rsrc_node(req, ctx);
 		req->buf_index = READ_ONCE(sqe->buf_index);
-		ioucmd->flags = IO_URING_F_UCMD_FIXEDBUFS;
-	} else {
-		ioucmd->flags = 0;
+		ioucmd->flags |= IO_URING_F_UCMD_FIXEDBUFS;
 	}
 
 	ioucmd->cmd = (void *) &sqe->cmd;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index abad6175739e..65db83d703b7 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -9,6 +9,7 @@ enum io_uring_cmd_flags {
 	IO_URING_F_COMPLETE_DEFER	= 1,
 	IO_URING_F_UNLOCKED		= 2,
 	IO_URING_F_UCMD_FIXEDBUFS	= 4,
+	IO_URING_F_UCMD_POLLED		= 8,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 };
@@ -16,8 +17,12 @@ enum io_uring_cmd_flags {
 struct io_uring_cmd {
 	struct file     *file;
 	void            *cmd;
-	/* for irq-completion - if driver requires doing stuff in task-context*/
-	void (*driver_cb)(struct io_uring_cmd *cmd);
+	union {
+		void *bio; /* used for polled completion */
+
+		/* for irq-completion - if driver requires doing stuff in task-context*/
+		void (*driver_cb)(struct io_uring_cmd *cmd);
+	};
 	u32             flags;
 	u32             cmd_op;
 	u16		cmd_len;
-- 
2.25.1

