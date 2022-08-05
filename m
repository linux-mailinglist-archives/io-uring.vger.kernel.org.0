Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B323558ADBA
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241418AbiHEPzW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 11:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbiHEPzE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 11:55:04 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E457D7BB
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 08:53:28 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220805155311epoutp012097db5e177de01aba74d8b33f9bb1e8~Ifc8gsROe0170701707epoutp01f
        for <io-uring@vger.kernel.org>; Fri,  5 Aug 2022 15:53:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220805155311epoutp012097db5e177de01aba74d8b33f9bb1e8~Ifc8gsROe0170701707epoutp01f
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659714791;
        bh=rdPsAxxvz7Zcyw0iMWU8XUYENn+3wN4ROlvI+GUBGXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A1HjEbucBXyFdofe2M+NhuqpyC6AF8LVCaRhlxXZShIy2tSAwYTxlCEsrr8YAhP5d
         unLXcW+LlW9vpFe1UoSUhEuS0kN5of0HonIeKIMBo8naoD6n7uJ9VRdaiQ2D0HqQoO
         c3vUknUAjPE0t3gftGr1rHAXBhWL093jluAcR8Q8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p3.samsung.com (KnoxPortal) with ESMTP id
        20220805155309epcas5p384a0ee735459ccd2d8a9ce175a29962d~Ifc7NWRYn0910509105epcas5p3f;
        Fri,  5 Aug 2022 15:53:09 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.176]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4Lzqr41mS4z4x9Pq; Fri,  5 Aug
        2022 15:53:08 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        D3.4A.09662.4EC3DE26; Sat,  6 Aug 2022 00:53:08 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20220805155307epcas5p4bab3f05dc13d8fc2f03c7a26e9bd8c7c~Ifc5YwS1t2379723797epcas5p4v;
        Fri,  5 Aug 2022 15:53:07 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220805155307epsmtrp1e83fbf0cf5317a6c905583bb8c121099~Ifc5YDy1q0820308203epsmtrp1e;
        Fri,  5 Aug 2022 15:53:07 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-62-62ed3ce47304
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        84.B9.08905.3EC3DE26; Sat,  6 Aug 2022 00:53:07 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220805155306epsmtip21e150df3b053853a14b764a604e4188b~Ifc36EXdx0383703837epsmtip2f;
        Fri,  5 Aug 2022 15:53:06 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com,
        Kanchan Joshi <joshi.k@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 2/4] io_uring: add iopoll infrastructure for io_uring_cmd
Date:   Fri,  5 Aug 2022 21:12:24 +0530
Message-Id: <20220805154226.155008-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220805154226.155008-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJJsWRmVeSWpSXmKPExsWy7bCmuu4Tm7dJBotaOSxW3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8X5t4eZLPbe0raYv+wpu8Whyc1MFp+XtrA7cHnsnHWX3ePy2VKP
        zUvqPXbfbGDzeL/vKptH35ZVjB6fN8kFsEdl22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
        6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaekUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJ
        KTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM44ecq84Jpcxd4LG1gaGP9IdDFyckgImEgseTyP
        sYuRi0NIYDejxKJjG9ghnE+MEus2bGCBcL4xSlzs+cUE07L3zRY2iMReRonfq8+yQjifGSW+
        7XkFVMXBwSagKXFhcilIg4iAvMSX22vBJjELvGKUmH25kx0kISzgKfHp02xGEJtFQFXi1OHX
        bCA2r4ClxPRVP1khtslLzLz0HayeU8BKovXwFmaIGkGJkzOfsIDYzEA1zVtnM4MskBDo5ZCY
        OnsCVLOLxKk9vxkhbGGJV8e3sEPYUhIv+9ug7GSJSzPPQb1WIvF4z0Eo216i9VQ/M8gzzEDP
        rN+lD7GLT6L39xOwHyUEeCU62oQgqhUl7k16CrVVXOLhjCVQtofEtt6n0FDsZZQ4f/gmywRG
        +VlIXpiF5IVZCNsWMDKvYpRMLSjOTU8tNi0wzEsth0dscn7uJkZwGtXy3MF498EHvUOMTByM
        hxglOJiVRHh/7nidJMSbklhZlVqUH19UmpNafIjRFBjGE5mlRJPzgYk8ryTe0MTSwMTMzMzE
        0tjMUEmc1+vqpiQhgfTEktTs1NSC1CKYPiYOTqkGJkvzmNwDm24+Y3hsmrwry+Os5YRNf2Km
        PJzw+Q17wF2v5Xxd8xZxyl6282+ofNRzsu1NQ8fCpzvXfun4JzKhJkf/MjNbeNs5/rqJkxgF
        y5ruOKqcUb/wmXtGTInbZoFOnw1r45Z/+yF2+RnP7vjMn/t/X7+4Ml5wVpzGVLsJR777zGE5
        UqW5Ofh/k5tG1w77Q3yTZKLKxPa3Gcqxvb17dvOlF5HHJEXneUm/V/hYnv2rfMGBzdW3P92t
        UqnKDj7mkxLCNv/pp6y8wOMXMySSHwk9mdK9+cmKrzwPfmT939m9skfmmOwk4SIHo5s92+7u
        YmbbwTBpcaWggNm9+w8F8y75m589FWO2XtPkOk9ZPYMSS3FGoqEWc1FxIgAiwpkILAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSvO5jm7dJBls+61msvtvPZnHzwE4m
        i5WrjzJZvGs9x2Jx9P9bNovzbw8zWey9pW0xf9lTdotDk5uZLD4vbWF34PLYOesuu8fls6Ue
        m5fUe+y+2cDm8X7fVTaPvi2rGD0+b5ILYI/isklJzcksSy3St0vgyjh5yrzgmlzF3gsbWBoY
        /0h0MXJySAiYSOx9s4Wti5GLQ0hgN6PE5GNzmCAS4hLN136wQ9jCEiv/PWeHKPrIKHHoygWg
        Dg4ONgFNiQuTS0FqRAQUJTZ+bGIEqWEW+MQoce7SbbBmYQFPiU+fZjOC2CwCqhKnDr9mA7F5
        BSwlpq/6yQqxQF5i5qXvYPWcAlYSrYe3MIPMFwKqmX+HC6JcUOLkzCcsIDYzUHnz1tnMExgF
        ZiFJzUKSWsDItIpRMrWgODc9t9iwwDAvtVyvODG3uDQvXS85P3cTIzj8tTR3MG5f9UHvECMT
        B+MhRgkOZiUR3p87XicJ8aYkVlalFuXHF5XmpBYfYpTmYFES573QdTJeSCA9sSQ1OzW1ILUI
        JsvEwSnVwHQq6U/4Ggs55Rkr7i9/9zAomNlpavdGqVvda//OaVNzlPZg2V/50HPta0tt9vn1
        era7y9dOrBHu3MsvqOX98rld0vSbt9hWR+3+0XeMKeDQTYOUmXJlc9c9PTAxcsHPRy9OL7iy
        a2vHN6bFXy5HfDvz5xNrx0HO1FrGS2sfvnsl5f7+UeUau8n/GCdlVpSlGQmV8Nx91rVVvjnG
        aYEyZ+DTrhsba36csjW3Oy4o//oWa+tiM4sAPzbJLTndeWtkTHL797Q+2Os33SUh/oa7p7f7
        Uosv3423LJNepaei2egsffpD9Db1jrpDW5uu7cu/cdzJdmX2htx9S155X87Rnqz6ZEZ4uK7J
        /ZvffumdfP5KiaU4I9FQi7moOBEAgw4j/+4CAAA=
X-CMS-MailID: 20220805155307epcas5p4bab3f05dc13d8fc2f03c7a26e9bd8c7c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220805155307epcas5p4bab3f05dc13d8fc2f03c7a26e9bd8c7c
References: <20220805154226.155008-1-joshi.k@samsung.com>
        <CGME20220805155307epcas5p4bab3f05dc13d8fc2f03c7a26e9bd8c7c@epcas5p4.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put this up in the same way as iopoll is done for regular read/write IO.
Make place for storing a cookie into struct io_uring_cmd on its
submission. Perform the completion using the ->uring_cmd_iopoll handler.

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
index b54218da075c..48a430a86b50 100644
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
index 2b784795103c..1a4fb8a44b9a 100644
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
index 0a421ed51e7e..5cc339fba8b8 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -49,7 +49,11 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 	io_req_set_res(req, 0, ret);
 	if (req->ctx->flags & IORING_SETUP_CQE32)
 		io_req_set_cqe32_extra(req, res2, 0);
-	__io_req_complete(req, 0);
+	if (req->ctx->flags & IORING_SETUP_IOPOLL)
+		/* order with io_iopoll_req_issued() checking ->iopoll_completed */
+		smp_store_release(&req->iopoll_completed, 1);
+	else
+		__io_req_complete(req, 0);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
@@ -89,8 +93,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
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

