Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7053F7DD
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 10:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238036AbiFGIHB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 04:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238042AbiFGIGy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 04:06:54 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3049BCC141;
        Tue,  7 Jun 2022 01:06:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654589212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O6d18kqa76uQ9DQcaTL4/EHavGPVwU9mmGhKMcUClL4=;
        b=DSEGDP+E4vMVlhWhQ2oUGgB1EBRPniZCVMalbLMIN857ihdTm4xLTNj4rNUs+VYRdEbAnY
        OPuwwQL5FFhBBEU0ZriWqnoISi23kKOONof7hfoj3XUeZuFSRmaEEsqOqXcMGra+9qA9vd
        Pq9JRErpUjNT5rNFAEk8TtQSKBeXsmc=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH 5/5] io_uring: add file_in in io_splice{} to avoid duplicate calculation
Date:   Tue,  7 Jun 2022 16:06:19 +0800
Message-Id: <20220607080619.513187-6-hao.xu@linux.dev>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
References: <20220607080619.513187-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a member file_in in io_splice{} to avoid duplicate calculation of
input file for splice. This is for the case where we do splice from
pipe to pipe and get -EAGAIN for the inline submission.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/splice.c | 33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/io_uring/splice.c b/io_uring/splice.c
index 650c70e3dde1..c97f2971fe7e 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -21,6 +21,7 @@ struct io_splice {
 	loff_t				off_in;
 	u64				len;
 	int				splice_fd_in;
+	struct file			*file_in;
 	unsigned int			flags;
 };
 
@@ -35,6 +36,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
+	sp->file_in = NULL;
 	return 0;
 }
 
@@ -108,34 +110,37 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sp->len))
 		goto done;
 
-	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
-	else
-		in = io_file_get_normal(req, sp->splice_fd_in);
-	if (!in) {
-		ret = -EBADF;
-		goto done;
+	if (!sp->file_in) {
+		if (sp->flags & SPLICE_F_FD_IN_FIXED)
+			in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
+		else
+			in = io_file_get_normal(req, sp->splice_fd_in);
+
+		if (!in) {
+			ret = -EBADF;
+			goto done;
+		}
+		sp->file_in = in;
+	} else {
+		in = sp->file_in;
 	}
 
 	if (issue_flags & IO_URING_F_NONBLOCK) {
-		if (io_splice_support_nowait(in, out)) {
+		if (io_splice_support_nowait(in, out))
 			flags |= SPLICE_F_NONBLOCK;
-		} else {
-			if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
-				io_put_file(in);
+		else
 			return -EAGAIN;
-		}
 	}
 
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
 	ret = do_splice(in, poff_in, out, poff_out, sp->len, flags);
+	if (ret == -EAGAIN)
+		return ret;
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	if (ret == -EAGAIN)
-		return ret;
 
 done:
 	if (ret != sp->len)
-- 
2.25.1

