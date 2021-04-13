Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8044D35D518
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240831AbhDMCDZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241515AbhDMCDZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:25 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91EA0C061756
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:06 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o20-20020a05600c4fd4b0290114265518afso7888197wmq.4
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=qIPKg6rNfbUAk2i73teHSTQ6gemwzFXb3v82vbeafJI=;
        b=ZCvvMuqDpjErJG4VG9KmnE+1V94vDTLq99mplnmedgR6J+xGJqhAK5e9BvqVGhpy+i
         ubCt+77ZWgZQXY2mpCT2lRV4CvsHYTZWGAtJDefS2CXVO+hSYmMkYtS/GtOvc+jkmQv3
         QCccxhl3i7XrvnVHs7nLtA8+9e9NPl4ReApjeFacn1Ka/laxYl6w+VjgyLcmawWipGMJ
         FOm67qI/pyyS/Fz77ENG133L7sG3pPzbH/AOKfZmY4kd9DkffPt3Lk1q6ivdzdObVlAD
         +a9/5fJMIc/O5vRRXHXPrsMMYLlgnhCZZqYMFTZvXLg36zaECyXzTwYRDvNniEaXKKVF
         fokg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qIPKg6rNfbUAk2i73teHSTQ6gemwzFXb3v82vbeafJI=;
        b=Uabdcu2l5j8XYmo+piyrosTvtLGiiIvHd3+Cx8ASx5lqKQ+Tg5poNUQKSKOkoHQsS1
         jNO0vDqhKtL1riir0rlKr0wqwJFhtDTwLPxL7PRgeDEjXyjsm+YeigeLMa0NQspv0Dt/
         kRevmJliETMrEudqRA1CselttGGwE1MwM5H0xTPjfnUlofTkYzqEOKoUWrtPLkmxSZ+4
         EUqUZX0+P/h0yn4uZbMOuRnW+QAkm+N6UNprVh6XkoWCYabvcl29LUD0aHH6LQ3hS5BQ
         cILDuavNQoYPcAiXLVxzno/AgFNQr2HansKTov/Za3bv9HR5gr1AlDNJT2uuqjWpXK4g
         DnmA==
X-Gm-Message-State: AOAM531r5gYm7BRU+8w2N8cmOUocW3xBuIdzYrT6KtEwKY8fflTkYOib
        kLsEBqka0X/Cl8RgNaQoZfA=
X-Google-Smtp-Source: ABdhPJzme+OsZHyEUHHpz3AaSdOV5dLiAo37J7uT3wvlHjYBsJD3LiccOZvm23/hMxAsyoDgEgP/Hw==
X-Received: by 2002:a1c:4d19:: with SMTP id o25mr1670498wmh.137.1618279384495;
        Mon, 12 Apr 2021 19:03:04 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/9] io_uring: fix uninit old data for poll event upd
Date:   Tue, 13 Apr 2021 02:58:39 +0100
Message-Id: <ab08fd35b7652e977f9a475f01741b04102297f1.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Both IORING_POLL_UPDATE_EVENTS and IORING_POLL_UPDATE_USER_DATA need
old_user_data to find/cancel a poll request, but it's set only for the
first one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44342ff5c4e1..429ee5fd9044 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5384,17 +5384,17 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (!(flags & IORING_POLL_ADD_MULTI))
 		events |= EPOLLONESHOT;
 	poll->update_events = poll->update_user_data = false;
-	if (flags & IORING_POLL_UPDATE_EVENTS) {
-		poll->update_events = true;
+
+	if (flags & (IORING_POLL_UPDATE_EVENTS|IORING_POLL_UPDATE_USER_DATA)) {
 		poll->old_user_data = READ_ONCE(sqe->addr);
+		poll->update_events = flags & IORING_POLL_UPDATE_EVENTS;
+		poll->update_user_data = flags & IORING_POLL_UPDATE_USER_DATA;
+		if (poll->update_user_data)
+			poll->new_user_data = READ_ONCE(sqe->off);
+	} else {
+		if (sqe->off || sqe->addr)
+			return -EINVAL;
 	}
-	if (flags & IORING_POLL_UPDATE_USER_DATA) {
-		poll->update_user_data = true;
-		poll->new_user_data = READ_ONCE(sqe->off);
-	}
-	if (!(poll->update_events || poll->update_user_data) &&
-	     (sqe->off || sqe->addr))
-		return -EINVAL;
 	poll->events = demangle_poll(events) |
 				(events & (EPOLLEXCLUSIVE|EPOLLONESHOT));
 	return 0;
-- 
2.24.0

