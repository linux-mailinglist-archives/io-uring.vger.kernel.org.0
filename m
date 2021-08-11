Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3623E97A7
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 20:29:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhHKS3i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 14:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHKS3i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 14:29:38 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CED6C061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:14 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id u1so2614777wmm.0
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=H+thWOWvcR3hwEQsrD/32leHKsfYFwX0iFeco0DEF4k=;
        b=t/i/9GavcewcU8sY5UJpqh9Qv3DG6CoRwZsXiIrWGbBf7xE6vHcaKvxEg6I4DpDK0z
         t9eNLal3V5Y3kuPJQwSrDCVm1yvZRt8qWecIuEOcREY/fY4z5TGi9PBaeHD52f8JBvgJ
         y/2+nuRfldq3Xff2I5I3piGUYYNsYmIhe9NKptPl/jduzOJJnmt84GR9WHQ6p7d3l7Bp
         M+7zFZDRnEzdK/0Ttim/TmPYD2IESxccRcZm4gp6rjaaknUuhH+dat8QsaoiAeak5JR4
         ++LCB0EQr7VenXdcUBn+jITW/XXW68SSZhcXmE+75e7E+ycVVWsoslavxABAdHtgo7K6
         oLfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+thWOWvcR3hwEQsrD/32leHKsfYFwX0iFeco0DEF4k=;
        b=lbeDWOQIBTsdkKgZEl6slBG64dK6KRqvYFiWZNyyHxBYZVQ+yNLYzmIgbH0p95B1Jd
         lOtmpXm5gvJMq5XVwo4B/kjBiS4UwDgmN3k6mXFXR0tCbqddFSI4FSoJtkoIYW34fEPI
         8JHq3q4UvAuY+IsEo7Jv7RzBfqpKbeo6QSjEAMo557VjF+JI6lUFXcjkuox0Ju1cWKK0
         DBQvE5Fep9kwu1mVCrQu7M6qmdcuOIqWANayAEo9i0Yyoj3Gl92swBb0gvR5zN4o98fp
         11E1XhFEPX73B5lggC4EacqLvSVQoCVi5WJlMlzLZmll/fFp7tBfxp2W8RP/c81ut798
         OsEw==
X-Gm-Message-State: AOAM530iTj6gAd+rQvl/bsPwHFIgWfFpkTlsufibELgYkVbvCcujc7be
        gks2onxHHdgTcZhL8HsunTHwAhu/OUg=
X-Google-Smtp-Source: ABdhPJyP+2AqImSmOBzEWdcsJ/vmAIsbhfL45fwyBRX+3fRM7ot0feDSRn1/LINZbljLrD9b38cTYw==
X-Received: by 2002:a7b:c94c:: with SMTP id i12mr11520504wml.148.1628706552864;
        Wed, 11 Aug 2021 11:29:12 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 129sm867wmz.26.2021.08.11.11.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5/5] io_uring: optimise hot path of ltimeout prep
Date:   Wed, 11 Aug 2021 19:28:31 +0100
Message-Id: <560636717a32e9513724f09b9ecaace942dde4d4.1628705069.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628705069.git.asml.silence@gmail.com>
References: <cover.1628705069.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_prep_linked_timeout() grew too heavy and compiler now refuse to
inline the function. Help it by splitting in two and annotating with
inline.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 374e9da26106..9780b43a503a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1046,7 +1046,6 @@ static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req);
 static void io_dismantle_req(struct io_kiocb *req);
-static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update2 *up,
@@ -1297,6 +1296,31 @@ static void io_req_track_inflight(struct io_kiocb *req)
 	}
 }
 
+static struct io_kiocb *__io_prep_linked_timeout(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = req->link;
+
+	if (req->flags & REQ_F_LINK_TIMEOUT)
+		return NULL;
+
+	/* linked timeouts should have two refs once prep'ed */
+	io_req_refcount(req);
+	io_req_refcount(nxt);
+	req_ref_get(nxt);
+
+	nxt->timeout.head = req;
+	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
+	req->flags |= REQ_F_LINK_TIMEOUT;
+	return nxt;
+}
+
+static inline struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
+{
+	if (likely(!req->link || req->link->opcode != IORING_OP_LINK_TIMEOUT))
+		return NULL;
+	return __io_prep_linked_timeout(req);
+}
+
 static void io_prep_async_work(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -6446,25 +6470,6 @@ static void io_queue_linked_timeout(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt = req->link;
-
-	if (!nxt || (req->flags & REQ_F_LINK_TIMEOUT) ||
-	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
-		return NULL;
-
-	/* linked timeouts should have two refs once prep'ed */
-	io_req_refcount(req);
-	io_req_refcount(nxt);
-	req_ref_get(nxt);
-
-	nxt->timeout.head = req;
-	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
-	req->flags |= REQ_F_LINK_TIMEOUT;
-	return nxt;
-}
-
 static void __io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-- 
2.32.0

