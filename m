Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8280A59EA9B
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 20:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbiHWSNQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 14:13:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbiHWSMq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 14:12:46 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCC09C500
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 09:25:18 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220823162515epoutp04ccd06da1c05d529f8e5934bd99f8c333~OBgFmejwT3171431714epoutp04Z
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 16:25:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220823162515epoutp04ccd06da1c05d529f8e5934bd99f8c333~OBgFmejwT3171431714epoutp04Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1661271915;
        bh=7uxpW2z8PgV6QmCh80XCC5JE20bOhAeRfZs6FnbP8ws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVdMOmlv10ByaXWOAPzBVCZN89aO+dSCyENBbRFe52cCoU/3HTkHdaoRfMWkQYaAW
         LUfNbgZ37CNZgyUFcJ7kFsH5RtVz8l1h5a+gnZ4//fRh3PJ3MlzCNjmPz+pVol6TZC
         /TYep2mm3pha9OWXtVA0Um+w1svoz1Q7V31/3Tvk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220823162514epcas5p4bab52d83513af7624c72983dc6483d77~OBgEwqAQt1443914439epcas5p4D;
        Tue, 23 Aug 2022 16:25:14 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MBvhm1wwMz4x9Pv; Tue, 23 Aug
        2022 16:25:12 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        8A.15.18001.86FF4036; Wed, 24 Aug 2022 01:25:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220823162511epcas5p46fc0e384524f0a386651bc694ff21976~OBgCFk0bl1443914439epcas5p4C;
        Tue, 23 Aug 2022 16:25:11 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220823162511epsmtrp2348517518c30dc9194b2c3270f5341d1~OBgCEx5n20268302683epsmtrp2q;
        Tue, 23 Aug 2022 16:25:11 +0000 (GMT)
X-AuditID: b6c32a4a-2c3ff70000004651-f8-6304ff68a585
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        E3.A2.18644.76FF4036; Wed, 24 Aug 2022 01:25:11 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220823162510epsmtip2860888bab5114fedd5a902771318d48f~OBgAdulrt3114031140epsmtip2a;
        Tue, 23 Aug 2022 16:25:09 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH for-next v3 2/4] io_uring: add iopoll infrastructure for
 io_uring_cmd
Date:   Tue, 23 Aug 2022 21:44:41 +0530
Message-Id: <20220823161443.49436-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823161443.49436-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmum7Gf5Zkgy+LuCzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5Nbmay+Ly0hd2B22PnrLvs
        HpfPlnpsWtXJ5rF5Sb3H7psNbB7v911l8+jbsorR4/MmuQCOqGybjNTElNQihdS85PyUzLx0
        WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAzlRTKEnNKgUIBicXFSvp2NkX5pSWp
        Chn5xSW2SqkFKTkFJgV6xYm5xaV56Xp5qSVWhgYGRqZAhQnZGcunrWUtuChX8fXQFZYGxh8S
        XYwcHBICJhLft6p3MXJxCAnsZpSYemgJI4TziVFi3qN3TBDOZ0aJmUtPsnUxcoJ1PH5zhRki
        sYtR4tKCg2xwVc+fT2UHmcsmoClxYXIpSIOIgJfE/dvvWUFqmAUuM0q0dU5hBkkIC4RLbJ17
        jwnEZhFQlfh/ajoriM0rYCFxfmEvK8Q2eYmZl76DzeQUsJQ4fVAOokRQ4uTMJywgNjNQSfPW
        2WAHSQjM5JBYc7+fDeI3F4kV/yMhxghLvDq+hR3ClpL4/G4v1DPJEpdmnmOCsEskHu85CGXb
        S7Se6mcGGcMM9Mr6XfoQq/gken8/YYKYzivR0SYEUa0ocW/SU6iDxSUezljCClHiIfH2mz8k
        cHoYJVafnsQ0gVF+FpIHZiF5YBbCsgWMzKsYJVMLinPTU4tNC4zyUsvhsZqcn7uJEZxUtbx2
        MD588EHvECMTB+MhRgkOZiURXqtjLMlCvCmJlVWpRfnxRaU5qcWHGE2BATyRWUo0OR+Y1vNK
        4g1NLA1MzMzMTCyNzQyVxHmnaDMmCwmkJ5akZqemFqQWwfQxcXBKNTDpf2LT2srKZ/p30hyj
        TdVvhBPnuDat4Tkmei90yY9AJiWFP7w19yIOH4zNyJA3E/iiy7FiU2lW236fsg7lN0K8RlOf
        H5DRu/Q0nPl0Wc/bT6mvZ7CZGPws/cF4e+3JG+dU21e+V0x1DQjzFVSQfhij3j/T6pbqxNtr
        /A6s3Xn56roL+vmRJQIhfWsec1U/6NmTPtfwauf3XxOm8ha4XLp4tcjSUNgw26WNh33l2aUR
        Vzi+2t4KbC5Y7P2S6cFXy0/C8bvW3lOPWC/gcfPInDcnN7wwzmxpL523POO7yMMXaxdt3rs9
        LPvowxQv/3nvLx9+lPY7X6HCoj3ePSZFfOKOjpxSe+XsKVkJX7XF9vAqsRRnJBpqMRcVJwIA
        appf+jMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSvG76f5Zkg9V7tCzmrNrGaLH6bj+b
        xc0DO5ksVq4+ymTxrvUci8XR/2/ZLCYdusZosfeWtsX8ZU/ZLQ5Nbmay+Ly0hd2B22PnrLvs
        HpfPlnpsWtXJ5rF5Sb3H7psNbB7v911l8+jbsorR4/MmuQCOKC6blNSczLLUIn27BK6M5dPW
        shZclKv4eugKSwPjD4kuRk4OCQETicdvrjCD2EICOxglPnzjgoiLSzRf+8EOYQtLrPz3HMjm
        Aqr5yCjxb/9qpi5GDg42AU2JC5NLQWpEBAIkDjZeBqthFrjNKDF3+ikWkISwQKjE7KZnTCA2
        i4CqxP9T01lBbF4BC4nzC3tZIRbIS8y89J0dZCangKXE6YNyEPdYSPzZ1MAGUS4ocXLmE7CR
        zEDlzVtnM09gFJiFJDULSWoBI9MqRsnUguLc9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgmNDS
        2sG4Z9UHvUOMTByMhxglOJiVRHitjrEkC/GmJFZWpRblxxeV5qQWH2KU5mBREue90HUyXkgg
        PbEkNTs1tSC1CCbLxMEp1cB0wKH7kfrx9AqPfI1lRx5/DDNmnBn/e2qZqOejyEWKha59tU+u
        hK5LEfutefXCksX3Vf47b3ENO+c+7WSJdfx7T65O7msH75Umfd97jKtGjsn6cVu2TXLa89eG
        j3Sr2v8cml5dZdAuIlKsnz2TZ728tscq/u9dnC4r1JI0Zt2fZphgkdceq/s59dzqlzua+l9t
        3LKIrTzbQyS2w8Fw+0rBpd9Wiaq0ZN4zuzXDZoP5U6en2vFHDZ9O4r3+zDDTvnNFZHbx17Rd
        bg/m7yy1MGby6Njy4WN47tLLz4Mrnu3YHP9gl06+0N5f51Kc/l/I5HnfuF5OtvWKp/2/w5On
        HVmQKnpMZOtZLZv+DWdyjIuUWIozEg21mIuKEwGN2Eyq+AIAAA==
X-CMS-MailID: 20220823162511epcas5p46fc0e384524f0a386651bc694ff21976
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220823162511epcas5p46fc0e384524f0a386651bc694ff21976
References: <20220823161443.49436-1-joshi.k@samsung.com>
        <CGME20220823162511epcas5p46fc0e384524f0a386651bc694ff21976@epcas5p4.samsung.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put this up in the same way as iopoll is done for regular read/write IO.
Make place for storing a cookie into struct io_uring_cmd on submission.
Perform the completion using the ->uring_cmd_iopoll handler.

Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/io_uring.h |  8 ++++++--
 io_uring/io_uring.c      |  6 ++++++
 io_uring/opdef.c         |  1 +
 io_uring/rw.c            |  8 +++++++-
 io_uring/uring_cmd.c     | 11 +++++++++--
 5 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 4a2f6cc5a492..58676c0a398f 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -20,8 +20,12 @@ enum io_uring_cmd_flags {
 struct io_uring_cmd {
 	struct file	*file;
 	const void	*cmd;
-	/* callback to defer completions to task context */
-	void (*task_work_cb)(struct io_uring_cmd *cmd);
+	union {
+		/* callback to defer completions to task context */
+		void (*task_work_cb)(struct io_uring_cmd *cmd);
+		/* used for polled completion */
+		void *cookie;
+	};
 	u32		cmd_op;
 	u32		pad;
 	u8		pdu[32]; /* available inline for free use */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ebfdb2212ec2..04abcc67648e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1296,6 +1296,12 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 			    wq_list_empty(&ctx->iopoll_list))
 				break;
 		}
+
+		if (task_work_pending(current)) {
+			mutex_unlock(&ctx->uring_lock);
+			io_run_task_work();
+			mutex_lock(&ctx->uring_lock);
+		}
 		ret = io_do_iopoll(ctx, !min);
 		if (ret < 0)
 			break;
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 72dd2b2d8a9d..9a0df19306fe 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -466,6 +466,7 @@ const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.plug			= 1,
 		.name			= "URING_CMD",
+		.iopoll			= 1,
 		.async_size		= uring_cmd_pdu_size(1),
 		.prep			= io_uring_cmd_prep,
 		.issue			= io_uring_cmd,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1babd77da79c..9698a789b3d5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1005,7 +1005,13 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		ret = rw->kiocb.ki_filp->f_op->iopoll(&rw->kiocb, &iob, poll_flags);
+		if (req->opcode == IORING_OP_URING_CMD) {
+			struct io_uring_cmd *ioucmd = (struct io_uring_cmd *)rw;
+
+			ret = req->file->f_op->uring_cmd_iopoll(ioucmd);
+		} else
+			ret = rw->kiocb.ki_filp->f_op->iopoll(&rw->kiocb, &iob,
+							poll_flags);
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8e0cc2d9205e..b0e7feeed365 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -49,7 +49,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 	io_req_set_res(req, ret, 0);
 	if (req->ctx->flags & IORING_SETUP_CQE32)
 		io_req_set_cqe32_extra(req, res2, 0);
-	__io_req_complete(req, 0);
+	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
+		smp_store_release(&req->iopoll_completed, 1);
+	else
+		__io_req_complete(req, 0);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
@@ -92,8 +96,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
 		issue_flags |= IO_URING_F_CQE32;
-	if (ctx->flags & IORING_SETUP_IOPOLL)
+	if (ctx->flags & IORING_SETUP_IOPOLL) {
 		issue_flags |= IO_URING_F_IOPOLL;
+		req->iopoll_completed = 0;
+		WRITE_ONCE(ioucmd->cookie, NULL);
+	}
 
 	if (req_has_async_data(req))
 		ioucmd->cmd = req->async_data;
-- 
2.25.1

