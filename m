Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1FCF53F7DB
	for <lists+io-uring@lfdr.de>; Tue,  7 Jun 2022 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238027AbiFGIGz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jun 2022 04:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbiFGIGt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jun 2022 04:06:49 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EFCDB82DB;
        Tue,  7 Jun 2022 01:06:48 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654589207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=85yunG6FCrDcuT7+AlR9B02vmXCSLoT2S/bCbJh6Eoo=;
        b=F2AZVzG1VGSPcnSdb/vki/pj0dFYUI9+21bomBczREqoo/DI5hF14cPAKc7MbYG21n5XSw
        BPFB26WQVzDq5Twilj0JJ4YMbQcUN3KahEB8/0TVq5PuasA7SRuFpRYcPLT9ZGosiGP+JW
        seCbtSx6tvG+Zg88r5JDOE/wR4bLLcc=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Subject: [PATCH 4/5] io_uring: support nonblock try for splicing from pipe to pipe
Date:   Tue,  7 Jun 2022 16:06:18 +0800
Message-Id: <20220607080619.513187-5-hao.xu@linux.dev>
In-Reply-To: <20220607080619.513187-1-hao.xu@linux.dev>
References: <20220607080619.513187-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

splice() in io_uring is running in a slow way since it fully depends on
io workers. While splicing from pipe to pipe is a simpler case compared
with file to pipe and pipe to file. Let's make it support nonblock
first. This way we get a fast path for splicing fom pipe to pipe.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/splice.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/io_uring/splice.c b/io_uring/splice.c
index b2cd1044c3ee..650c70e3dde1 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -88,6 +88,14 @@ int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_splice_prep(req, sqe);
 }
 
+bool io_splice_support_nowait(struct file *in, struct file *out)
+{
+	if (get_pipe_info(in, true) && get_pipe_info(out, true))
+		return true;
+
+	return false;
+}
+
 int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req);
@@ -100,9 +108,6 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sp->len))
 		goto done;
 
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
 	if (sp->flags & SPLICE_F_FD_IN_FIXED)
 		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
 	else
@@ -112,6 +117,16 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 		goto done;
 	}
 
+	if (issue_flags & IO_URING_F_NONBLOCK) {
+		if (io_splice_support_nowait(in, out)) {
+			flags |= SPLICE_F_NONBLOCK;
+		} else {
+			if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+				io_put_file(in);
+			return -EAGAIN;
+		}
+	}
+
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
@@ -119,6 +134,9 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
+	if (ret == -EAGAIN)
+		return ret;
+
 done:
 	if (ret != sp->len)
 		req_set_fail(req);
-- 
2.25.1

