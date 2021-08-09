Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7333E4540
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbhHIMFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235345AbhHIMFj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:39 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C787C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:19 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id c9so21051406wri.8
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=We/N7rq0mPGKKbsHqBU553wy6NC/54D2i3K+GAo0kqo=;
        b=A8W9lJDDZUC55xoppHhsaTyvml1EYdPhiR8MIIsdy4SMES1TFMyW+MXAYXJDB0qIxX
         kPa4EA3hpUFpOaUq2lszabepZvPGFcJXXOPH+A50PKGO+13ftgK9EkA0/IexMFERzN3r
         kKjPTQwiqyAM7OAk9MLXNhwUb2jXRt2IKqTvI6THgXiq65haj6WgE/Yi0WCdNrNdnXJQ
         PiH42SEOil4hfqUf3gmfqUF28BkpltuG4xH0/XeLd3MP4ZThqlPWDFFcOz917539KANr
         ydo5wpqI19gS/B5xHshx+DrCQjFgbncm8o96c+sogQduqECtwxL29VlGDxVVWcdD2cOn
         KMFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=We/N7rq0mPGKKbsHqBU553wy6NC/54D2i3K+GAo0kqo=;
        b=QveBIJuzDJdVdB6R6ytxFlvA+nIeja2EXVGphbcCU9BrhlWEZf1YdJWckk7/isoVrN
         13VoSND+HvmFJbTlXHBSJCEOH03wktEDXokz7FEeG0IziDQUOPArbfr40dpZv5Y+i56G
         +z8QCtb90atyzhhlmvxo6zcPF3Aa1mmEW+i9Rrc92geO7l3v3aDVxx7VPyC5LC1okXEj
         ATYmvo+bse13tigqhsx+l6ZDxfBhilorXHmpnpLaAESnlUxlJVdd/zellu9GQyFTbSYP
         OLIBkvL5WtIyF2vlm9Er4cR2c2jt/EHgzzLtWRcYsC9P6s+7uTwtRxlgKxAazc28K9+M
         Kshg==
X-Gm-Message-State: AOAM531+1tU/x1n82pZDl9scCJQNu1YEasO0EQje2VkIWFhkQ/Rs6osu
        unTdfRSAAnIeIuq85NmlHEM=
X-Google-Smtp-Source: ABdhPJxXo5uRJdHPzHQ+oCam5HPEc6mbONDj0S9dujHMTWDajN1qdA/JJ7oiqkrPYoGxgyQ3rz5cHw==
X-Received: by 2002:adf:cd92:: with SMTP id q18mr25033742wrj.18.1628510717827;
        Mon, 09 Aug 2021 05:05:17 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 16/28] io_uring: deduplicate open iopoll check
Date:   Mon,  9 Aug 2021 13:04:16 +0100
Message-Id: <9a73ce83e4ee60d011180ef177eecef8e87ff2a2.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move IORING_SETUP_IOPOLL check into __io_openat_prep(), so both openat
and openat2 reuse it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 17ead2a7e899..cbd39ac2e92b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3790,6 +3790,8 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	const char __user *fname;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
 	if (unlikely(sqe->ioprio || sqe->buf_index))
 		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
@@ -3814,12 +3816,9 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 static int io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	u64 flags, mode;
+	u64 mode = READ_ONCE(sqe->len);
+	u64 flags = READ_ONCE(sqe->open_flags);
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	mode = READ_ONCE(sqe->len);
-	flags = READ_ONCE(sqe->open_flags);
 	req->open.how = build_open_how(flags, mode);
 	return __io_openat_prep(req, sqe);
 }
@@ -3830,8 +3829,6 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	size_t len;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
 	how = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	len = READ_ONCE(sqe->len);
 	if (len < OPEN_HOW_SIZE_VER0)
-- 
2.32.0

