Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441A858BC80
	for <lists+io-uring@lfdr.de>; Sun,  7 Aug 2022 20:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbiHGSpz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 14:45:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235549AbiHGSpx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 14:45:53 -0400
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894139583
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 11:45:52 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20220807184550epoutp01b2d39380aef0a295a4ea0212787e9abf~JJGRNuzn10485904859epoutp01R
        for <io-uring@vger.kernel.org>; Sun,  7 Aug 2022 18:45:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20220807184550epoutp01b2d39380aef0a295a4ea0212787e9abf~JJGRNuzn10485904859epoutp01R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1659897950;
        bh=rdPsAxxvz7Zcyw0iMWU8XUYENn+3wN4ROlvI+GUBGXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5OF2pEM38hQGpCorhvSl4ZX/mO15mMOBlITyZJ8SiHrsFtYPefdlOXbGNZkbF3Zt
         a0Mqw24vRWPt+wZhCLdcguPhnPl5BbbBJHnr9wlZwPdMzgRvVpfj/hvPHy6iD8K5P/
         xyhrRedrxOIB9e6UAdnvosfQ5c8UFcAvVkrIJswA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20220807184550epcas5p4d540192b1a2f33bcbadff32fb5ffee6c~JJGQzjwWU2500925009epcas5p4B;
        Sun,  7 Aug 2022 18:45:50 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.182]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4M17ZN0HLTz4x9Pr; Sun,  7 Aug
        2022 18:45:48 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        70.5F.09662.B5800F26; Mon,  8 Aug 2022 03:45:47 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20220807184547epcas5p23b4ef30467d65d1b81632e7c514fc192~JJGONytug2712827128epcas5p2F;
        Sun,  7 Aug 2022 18:45:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20220807184547epsmtrp277cfcbfc92f490e7349f90ccdf4e0506~JJGOM8vrX0248002480epsmtrp2p;
        Sun,  7 Aug 2022 18:45:47 +0000 (GMT)
X-AuditID: b6c32a49-86fff700000025be-d0-62f0085bdc63
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        AE.79.08802.B5800F26; Mon,  8 Aug 2022 03:45:47 +0900 (KST)
Received: from localhost.localdomain (unknown [107.110.206.5]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220807184546epsmtip23141023eab4008b1a5913e80bc88c964~JJGM56XMp2084620846epsmtip2h;
        Sun,  7 Aug 2022 18:45:46 +0000 (GMT)
From:   Kanchan Joshi <joshi.k@samsung.com>
To:     axboe@kernel.dk, hch@lst.de
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        gost.dev@samsung.com, Kanchan Joshi <joshi.k@samsung.com>,
        Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH for-next v2 2/4] io_uring: add iopoll infrastructure for
 io_uring_cmd
Date:   Mon,  8 Aug 2022 00:06:05 +0530
Message-Id: <20220807183607.352351-3-joshi.k@samsung.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220807183607.352351-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42LZdlhTXTea40OSwYTj1har7/azWdw8sJPJ
        YuXqo0wW71rPsVgc/f+WzWLvLW2L+cueslscmtzMZPF5aQu7A6fH5bOlHpuX1HvsvtnA5vF+
        31U2j74tqxg9Pm+SC2CLyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xN
        tVVy8QnQdcvMATpJSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgUqBXnJhbXJqX
        rpeXWmJlaGBgZApUmJCdcfKUecE1uYq9FzawNDD+kehi5OSQEDCR+PLqMVsXIxeHkMBuRokp
        UxZAOZ8YJS4/OM4M4XxmlOhfeI4FpuXEpXfsEIldjBK3D25ngau6e/gfUxcjBwebgKbEhcml
        IA0iAvISX26vBathFrjMKNHWOYUZJCEsEC7xoLWVEcRmEVCVOLuriQnE5hWwlJhx6RUjxDZ5
        iZmXvrODzOQUsJLo2qIMUSIocXLmE7CDmIFKmrfOBrtUQuAvu0TfmxdMEL0uEk8a/7NC2MIS
        r45vYYewpSQ+v9vLBmEnS1yaeQ6qvkTi8Z6DULa9ROupfmaQvcxAv6zfpQ+xi0+i9/cTsBcl
        BHglOtqEIKoVJe5Negq1SVzi4YwlULaHxNTJq6CB2MsocWTLDLYJjPKzkLwwC8kLsxC2LWBk
        XsUomVpQnJueWmxaYJiXWg6P1+T83E2M4ISp5bmD8e6DD3qHGJk4GA8xSnAwK4nwHln7PkmI
        NyWxsiq1KD++qDQntfgQoykwiCcyS4km5wNTdl5JvKGJpYGJmZmZiaWxmaGSOK/X1U1JQgLp
        iSWp2ampBalFMH1MHJxSDUx+8381veHVq+F+srnq5cZH26Zncqz/6WZzwqX06VvNKufcDZM3
        JO2ZNVV+ot5Lo3brWz9f33r4dV387fLjh5y8ZqvYPNfJPZVf1bdJx7LlAW9tnvS7gwkrTbh9
        W47vtHuzmOEY181puqmnLhy4oZ37Pvoio8Ceyu1JffUeEzO9NCeekCxy3/PqwY6S9IjjUo2V
        snlX5lpqaDPXWjkY1hodPrg8vq5nB0slyzZXi2LVrevK5wuy/Kx51nixWFK4d3JM6M8ih7q0
        7WfbZ4QzlEtvs5W6FBd2l/Xq/9TDGxxdVkmkOCy+2sDQPtlqzspZZ5SeMAparZ2Rs7e13+Sv
        nvWtT5Uilt8T3H6ZSh9c8kuJpTgj0VCLuag4EQBBAUSDIQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWy7bCSvG40x4ckg3WflS1W3+1ns7h5YCeT
        xcrVR5ks3rWeY7E4+v8tm8XeW9oW85c9Zbc4NLmZyeLz0hZ2B06Py2dLPTYvqffYfbOBzeP9
        vqtsHn1bVjF6fN4kF8AWxWWTkpqTWZZapG+XwJVx8pR5wTW5ir0XNrA0MP6R6GLk5JAQMJE4
        cekdO4gtJLCDUeLzRiuIuLhE87Uf7BC2sMTKf8+BbC6gmo+MEnd/LWbuYuTgYBPQlLgwuRSk
        RkRAUWLjxyZGkBpmgduMEnOnn2IBSQgLhEp8uLSbFcRmEVCVOLuriQnE5hWwlJhx6RUjxAJ5
        iZmXvrODzOQUsJLo2qIMcY+lxNkLLcwQ5YISJ2c+ARvJDFTevHU28wRGgVlIUrOQpBYwMq1i
        lEwtKM5Nzy02LDDKSy3XK07MLS7NS9dLzs/dxAgOdC2tHYx7Vn3QO8TIxMF4iFGCg1lJhPfI
        2vdJQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2MFxJITyxJzU5NLUgtgskycXBKNTCxBlXM
        Xf2t8BbHl+635x/fvPDv1SX+xTv8y1g9YhV+rXjqYDWRoczO4t+hvNjrZ3k7b+mxKW6V39GZ
        nKrm57oz+GaCk5K5U9VUP23l7tjJezJLJ+X+2mKwIZRpgUXx5KQ11QEMxx24Xyj2rApOXMHx
        SmG+y/+bfmWq57teqcavPl7u/S/4U/o91rU7d0cLBQh1vzC8/Pm7EOMm15istF9qzzmPn9i+
        6c4X8/8/dHaEfWosjjzS3T/hFMtX27PHWn5XT+9az8/B9y7KQKXq6Fav9mt3eDlZzQut1jYd
        vOMZF1Mu/Wl7RcjkCK4bEez+4jPTmQPmbvm38JScNFfJlaTTLjPfpvrqdtwt3XjoiqcSS3FG
        oqEWc1FxIgBIO8Fl4wIAAA==
X-CMS-MailID: 20220807184547epcas5p23b4ef30467d65d1b81632e7c514fc192
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220807184547epcas5p23b4ef30467d65d1b81632e7c514fc192
References: <20220807183607.352351-1-joshi.k@samsung.com>
        <CGME20220807184547epcas5p23b4ef30467d65d1b81632e7c514fc192@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

