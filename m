Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B741E35F429
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 14:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhDNMnW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 08:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhDNMnT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 08:43:19 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE489C06138C
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:57 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id e7so10771880wrs.11
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 05:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MeRZd9fCmyo2Y5BHxS9e5RivFoQ1GpfxgtLjpH3dpgo=;
        b=vCNQgLYNKcm1k/BlWTMJd7eq1DFEA4I5aoXyS+UwQkVmuxWlEDJHJbM0p1nOz/Ij83
         JKdKGgYRj8AfvIOLVmKZ6HEpsdW6NJelzD0GLGJLtbC79P6VJS0xU8XRvH26eQjBRxx9
         ClVAF3OpTj7JfZGL74fx10WMuaamsTULm6lOEfNcOVupATr1vV7rOgS6rACwfBTil2cc
         ZLx1PLXZwztzCUGTertttxEazBGW6J+A+r7VCEzOPWbc9mFmYKIqbe+Bk7nY4ED3hILy
         Q9CnQph3lxXqaEqAVd6zgtKKlmLgPPHscma1s1Am1j33mKRw6S6hjrg5cTCsWXY2ljch
         oXCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MeRZd9fCmyo2Y5BHxS9e5RivFoQ1GpfxgtLjpH3dpgo=;
        b=Gki/46OrPqQeZkttanDpS3w+MbCxPKBSq3hI1bRhXQlsMDzKky8PqOAmeCKK5DSrvG
         ksDzuGjUEoPA00WVBKfsmFhnNetsufazFgKdA5b1rd2d2DLlJTrbdOQRxyushhANZECj
         MHzGaoFZtutCKPiUuWwwkmiOOwFvC5JgtQD7XP0jRq9/3kR/Xe9zbWzVORM1TtUFh32N
         bpP4ucbgIaGnSIBAAvACs1G6oFtzP04a+w30G2Sxy0sDAtMN0/lhj1w1ifKaXUWARVUH
         rEgrsA6olpy1tY41oCFLA50vZ6Ds0JXerNswVAXOth+JFk9W315PAtYGjnShS3BX5Zma
         1wYg==
X-Gm-Message-State: AOAM530D2jy9ETdLAKRTsvGhXKf+bs6G6SiJjENn6b212x874UQ1He1r
        PI1b39L71aAYjXgKiTWdD4Cqrlhg+4S31Q==
X-Google-Smtp-Source: ABdhPJyRifleoQ3rOEUTNIBP3ZGPCN96Nwceb4gPMV7Z+hon8yMhpeJW9lTAonibGuVxe9b1uS3a5w==
X-Received: by 2002:a5d:4851:: with SMTP id n17mr21311917wrs.215.1618404176705;
        Wed, 14 Apr 2021 05:42:56 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.37])
        by smtp.gmail.com with ESMTPSA id f2sm5179912wmp.20.2021.04.14.05.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 05:42:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 4/5] io_uring: add helper for parsing poll events
Date:   Wed, 14 Apr 2021 13:38:36 +0100
Message-Id: <7392feca972fe44975f4bcb787d3c2f1a8ff6223.1618403742.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618403742.git.asml.silence@gmail.com>
References: <cover.1618403742.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Isolate poll mask SQE parsing and preparations into a new function,
which will be reused shortly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ce75a859a376..da5061f38fd6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5291,6 +5291,20 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
 	return -EALREADY;
 }
 
+static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
+				     unsigned int flags)
+{
+	u32 events;
+
+	events = READ_ONCE(sqe->poll32_events);
+#ifdef __BIG_ENDIAN
+	events = swahw32(events);
+#endif
+	if (!(flags & IORING_POLL_ADD_MULTI))
+		events |= EPOLLONESHOT;
+	return demangle_poll(events) | (events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
+}
+
 static int io_poll_remove_prep(struct io_kiocb *req,
 			       const struct io_uring_sqe *sqe)
 {
@@ -5352,14 +5366,8 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (flags & ~(IORING_POLL_ADD_MULTI | IORING_POLL_UPDATE_EVENTS |
 			IORING_POLL_UPDATE_USER_DATA))
 		return -EINVAL;
-	events = READ_ONCE(sqe->poll32_events);
-#ifdef __BIG_ENDIAN
-	events = swahw32(events);
-#endif
-	if (!(flags & IORING_POLL_ADD_MULTI))
-		events |= EPOLLONESHOT;
-	events = demangle_poll(events) |
-				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
+
+	events = io_poll_parse_events(sqe, flags);
 
 	if (flags & (IORING_POLL_UPDATE_EVENTS|IORING_POLL_UPDATE_USER_DATA)) {
 		struct io_poll_update *poll_upd = &req->poll_update;
-- 
2.24.0

