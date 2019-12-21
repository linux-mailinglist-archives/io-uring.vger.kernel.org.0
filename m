Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78FEE128B6B
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2019 21:13:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfLUUNc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 21 Dec 2019 15:13:32 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:39364 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbfLUUNb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 21 Dec 2019 15:13:31 -0500
Received: by mail-wm1-f48.google.com with SMTP id 20so12378691wmj.4;
        Sat, 21 Dec 2019 12:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UipHCb83ruP90ECQEg5f6zgvM+zJSXnBrw+F0UKt9U0=;
        b=NI/MpqL5XTZJ9FFg62mmBeL3cVB0ZvhSCPPT7LkOaYDGXqEOnBNORyh5Y8oQVq+FXH
         d+s9ONsAurSDiKl3wLjuzmcLRjmd6THHOmqncoKetazwxZSylaOCij+HyhJ6dt64ZfA4
         nZ8fWp5IAVOWqbmuEqPtiCKS9NMWDM+4VPqc9THPUck7f29+o8xb6tR5AWcLJRWkLiEF
         3YjoO29GXCJtDhqQu7l2+LRW6aVSIEkEiKNTIqGJyjh0c3ajYUUPZH0isRhAnWldUL5K
         ZHWxnz6jrrA3zR8zaTEfHqSvBM4nF78ixrMWZDqVmjNx3B7Axze6AgdkdAWxZAQmpx3D
         J+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UipHCb83ruP90ECQEg5f6zgvM+zJSXnBrw+F0UKt9U0=;
        b=F89wf+GKfn4px/vE8a5qZh4uhtOGLWjm3w8sKYZEDQn6f7tC8vAlbBUYlNvOAGVMoO
         2lA3f3T0PBK1C/YeaqtATOD1V5E5InGBmkJSTDcUpMvyLL5N+DeN+FbjASfKU3EeksZB
         L/1nsUsC7T6Du4XnltOa+hABzYbSqpYFInYUSVdx+a2jYuxgK6dtJpw/kE+KRmGSJlbc
         mmUkOF85a6/xY+Kx2pjYZwHNjAv3RZa5QTWJ5AfNwTLpBAo2vjZ5RbZMDYgQZEHRss57
         hbQWeoNzNELmbAG5Y6i/HtI608sM8n2QLwFOhhrejSPp9EFA99i9Nc7A2p0nP3bJU7ST
         yaCQ==
X-Gm-Message-State: APjAAAV5OeASPzn6WX7mS57Ac/HN1TxOo5yZdYo3PBXXPxHXZ54vxXt7
        tHcwiXJlh6t1zsN5yz92y78=
X-Google-Smtp-Source: APXvYqy0OElbCHLIZqVJxJkxd8OHloWK98hEstrYI7xsYK/wmiehUbqT0GYZc+F+Ct3ApRAqgN5viQ==
X-Received: by 2002:a1c:a543:: with SMTP id o64mr22203963wme.73.1576959208605;
        Sat, 21 Dec 2019 12:13:28 -0800 (PST)
Received: from localhost.localdomain ([109.126.149.134])
        by smtp.gmail.com with ESMTPSA id l7sm14470821wrq.61.2019.12.21.12.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Dec 2019 12:13:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] io_uring: batch getting pcpu references
Date:   Sat, 21 Dec 2019 23:12:54 +0300
Message-Id: <a458f9577c254d6e0587793e317ba69703c7400e.1576958402.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1576958402.git.asml.silence@gmail.com>
References: <cover.1576958402.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

percpu_ref_tryget() has its own overhead. Instead getting a reference
for each request, grab a bunch once per io_submit_sqes().

basic benchmark with submit and wait 128 non-linked nops showed ~5%
performance gain. (7044 KIOPS vs 7423)

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

It's just becoming more bulky with ret for me, and would love to hear,
hot to make it clearer. This version removes all error handling from
hot path, though with goto.

 fs/io_uring.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 513f1922ce6a..b89a8b975c69 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1045,9 +1045,6 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;
 
-	if (!percpu_ref_tryget(&ctx->refs))
-		return NULL;
-
 	if (!state) {
 		req = kmem_cache_alloc(req_cachep, gfp);
 		if (unlikely(!req))
@@ -4400,6 +4397,9 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			return -EBUSY;
 	}
 
+	if (!percpu_ref_tryget_many(&ctx->refs, nr))
+		return -EAGAIN;
+
 	if (nr > IO_PLUG_THRESHOLD) {
 		io_submit_state_start(&state, nr);
 		statep = &state;
@@ -4408,16 +4408,22 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	for (i = 0; i < nr; i++) {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
+		unsigned int unused_refs;
 
 		req = io_get_req(ctx, statep);
 		if (unlikely(!req)) {
+			unused_refs = nr - submitted;
 			if (!submitted)
 				submitted = -EAGAIN;
+put_refs:
+			percpu_ref_put_many(&ctx->refs, unused_refs);
 			break;
 		}
 		if (!io_get_sqring(ctx, req, &sqe)) {
 			__io_free_req(req);
-			break;
+			/* __io_free_req() puts a ref */
+			unused_refs = nr - submitted - 1;
+			goto put_refs;
 		}
 
 		/* will complete beyond this point, count as submitted */
-- 
2.24.0

