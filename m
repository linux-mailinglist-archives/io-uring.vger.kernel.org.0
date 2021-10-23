Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A6743834F
	for <lists+io-uring@lfdr.de>; Sat, 23 Oct 2021 13:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhJWLQr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Oct 2021 07:16:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhJWLQo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Oct 2021 07:16:44 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 250FCC061348
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:16 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u18so9171404wrg.5
        for <io-uring@vger.kernel.org>; Sat, 23 Oct 2021 04:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sU3nMI2qf7u2Zh7nwQ0dYqc+2xHJnN3Yg1ACtR4+sVw=;
        b=FjPN5Fnu4WFgresSTao/OAtDkvFzGnGF8qeX/V6WZ4lExbfReYvTB6gRoIhZ5A+ITB
         37YCRuUvfJRrKIJqN44SL8CqwslI7lyygsbiZmpI5FlxecVmOkrFLK0CxIwLceDD5pB9
         dxL6Je8vLgnIF0S6KucUAKimYgDn7mOoiP1vtbarQz5W974B5cvD/JlLM02sR8vUO+QY
         zuU+/vQhHXGivxFMBjRgovY+gwnq90VPocEQ2aLHfYJQImnhDI4ixC0h1CC05VLLVYxe
         sOVoyH7LFIjEjC/P0ZStraUN41jOKPViDgbIuhO2gGnSqPFeBlq4uPNrK41WgY7awM0Z
         asww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sU3nMI2qf7u2Zh7nwQ0dYqc+2xHJnN3Yg1ACtR4+sVw=;
        b=NXg+SIkcZeK17cloLVZM4o6OMhFVCDdJNu/NXgt+6ydlULLye62J9jep3gyOnDTyiW
         7ql0jwRxhE+gexlgTontULHOxVZUW8zrJgXXsQorMUBEVQP/oVBoEb0Ijj847M6p9F4P
         1dNImpWXVF8g0oXCvfjzCvUGEx+vjdrbOXe2S7biys9qBRYMfpLtUNFAImmWO17upH8W
         FGdRP2Tm/Yk0GD7/lsOdVowXclbuahVnYbhVmg1v+8W2vguaJ65NNFZVxmSs2kXRrkxR
         JgdKkMUSqAZrkgT85kiThTMvR5s+cbZoQqG3F+2+VCZI2qaPXeIg28UA3zTSVmq5WLMi
         grQg==
X-Gm-Message-State: AOAM531e7U7eD1We0qYeWqNSSPoF/o8wjgLyBvXRtOWBvqHhycNSk28V
        YcBrFPdiZPVeUv40Z4w0M7QE9Qlj2gM=
X-Google-Smtp-Source: ABdhPJwZnkOmNh+H2OaaFCTM08DAeg7chZ7V5oTCcONsWgu8htwm1RXwCkALaWuUz0E7W5YUvg5eJQ==
X-Received: by 2002:adf:9b84:: with SMTP id d4mr5301007wrc.393.1634987655159;
        Sat, 23 Oct 2021 04:14:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id w2sm10416316wrt.31.2021.10.23.04.14.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Oct 2021 04:14:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 7/8] io_uring: kill unused param from io_file_supports_nowait
Date:   Sat, 23 Oct 2021 12:14:01 +0100
Message-Id: <4bd6709fc573d70c866ea656cb7a7dbe94be8026.1634987320.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634987320.git.asml.silence@gmail.com>
References: <cover.1634987320.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_file_supports_nowait() doesn't use rw argument anymore, remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e775529a36d8..7042ed870b52 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2809,8 +2809,7 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 	return req->flags & REQ_F_SUPPORT_NOWAIT;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      int rw)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -3352,7 +3351,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-	return io_prep_rw(req, sqe, READ);
+	return io_prep_rw(req, sqe);
 }
 
 /*
@@ -3568,7 +3567,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-	return io_prep_rw(req, sqe, WRITE);
+	return io_prep_rw(req, sqe);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.33.1

