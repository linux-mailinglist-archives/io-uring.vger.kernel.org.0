Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2552835F1A3
	for <lists+io-uring@lfdr.de>; Wed, 14 Apr 2021 12:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbhDNKsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Apr 2021 06:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233860AbhDNKsf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Apr 2021 06:48:35 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54887C06175F
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:14 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id y204so8962480wmg.2
        for <io-uring@vger.kernel.org>; Wed, 14 Apr 2021 03:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=MeRZd9fCmyo2Y5BHxS9e5RivFoQ1GpfxgtLjpH3dpgo=;
        b=HKL+epBeW1dcB/fDXiuju/Xe1U+Gf8w+NeFbSLyj+pxBEjU+vPbwoT7P230fCt8UIv
         2wpp30EsiEVRAEK7oVU433Q7xtU3uFZASZBaX8CN6GJ/8RmPW8evu33kdjtfUAjeKJFc
         E9RAaaqWr5UIyixwhZxI1Nq8Jk2H93g9Y2cyO4gPUf9w8TTRz5hzArKdIPLgXqrZQueL
         jZhPmGEJLt15eQG9I+JQHYDYjki8su3IGovtu7afP9eZroo9vvYxpP5xVU0iZliYc9Xb
         jhsyC2TWhLomGQh9p7LsgLMusP/ItYZtL/jkv8p5akxhF4vToNT2UepLN2eOS9t2A0YE
         4TBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MeRZd9fCmyo2Y5BHxS9e5RivFoQ1GpfxgtLjpH3dpgo=;
        b=qow0CEoyRkndoQNsl17n1z6KXwqGwnAANaEw07xqBqUs04o4I1h48fRRKCSbUyo4UI
         ixMNLEuZaMDmjFgdlmkvT644Ja+IkL+yRLsRFFQjZgYrlvC2YPLXPQ4ph8I0UEUiTHoW
         8o+tuhU+BlfDcwBg7WCnab2gSdMOW5wcLdDzZjsOk/2Fc2SAbpLnzLL8LHInJFqhL/5D
         rNl1sf0LetKg/wlSIBcuJNqWCa1Si/SBQo/AUcVtgp5RITjgACE4VCVFgtlGLlqBOCR7
         gy38XYG/ps/CoPwooHrFvyUHpJjNrSf64uVP/6fopwil2Aa3VrU+5II7+lePr5SdwOLV
         Sr/Q==
X-Gm-Message-State: AOAM531gzJlqrH+pQPr8UDGoHCoMsHVYRWXeN+jK0U+TKh/PPBBHpdxb
        51lkuRlrmRVqioo35IaTKDXjuZj19/Lnxg==
X-Google-Smtp-Source: ABdhPJwC8d/0Ltx1Btw4Bv65ZPiMmTT8CF9zKIVgdcTYdMzUnyS9zBr9Rm6ftbZzHMR1Xsj7LsyzuA==
X-Received: by 2002:a7b:cb42:: with SMTP id v2mr2366584wmj.120.1618397293069;
        Wed, 14 Apr 2021 03:48:13 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.163])
        by smtp.gmail.com with ESMTPSA id n14sm5003002wmk.5.2021.04.14.03.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 03:48:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: add helper for parsing poll events
Date:   Wed, 14 Apr 2021 11:43:53 +0100
Message-Id: <7392feca972fe44975f4bcb787d3c2f1a8ff6223.1618396839.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618396838.git.asml.silence@gmail.com>
References: <cover.1618396838.git.asml.silence@gmail.com>
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

