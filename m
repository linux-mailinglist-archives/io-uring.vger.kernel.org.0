Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBB9430D17
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 02:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234749AbhJRAbf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 Oct 2021 20:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344845AbhJRAbe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 Oct 2021 20:31:34 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3BC7C061768
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id d9so63643834edh.5
        for <io-uring@vger.kernel.org>; Sun, 17 Oct 2021 17:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GevMDOJGYJbt58ceNDY8mEqvGAjyPqbT0MxyaYugBMU=;
        b=K9wuLJN7wMad6hQ7GUJSth15am1FnnoxhVUPbW/Fnu2DwRRjUl4eRxy0NfP43tDrS5
         MMkUUW8MGENPtO3gpmUv3euYBUMwJeM/RJdgeuGjJWkPuJDifMkKaZ2JYRh0hcY8AhAq
         dPSkYrDPa364p6EQoflqX1iz/XJUPpHanRcCyePk5fA2KMlACsExou/6l/cw6KpkqJRl
         bNZNMnA7WDp/X6U4+ivgdts2YszkgTAGKQpxdnxDtEFxjU/ITqhvP/kfPZ0axN/QRZ2u
         GpnA9K4DGw1ZpfybBIkGc507BfTom5xBfQQ+YHC9fxCPuXt3UExwopBi82mPrqBuxWmV
         o6MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GevMDOJGYJbt58ceNDY8mEqvGAjyPqbT0MxyaYugBMU=;
        b=e2BegISOHQ3NeF3EUbjFNA9gI5VkKsxUC87Rs0jBEzxEnvsl8w/hZi/7RsRGdroTWI
         DK+a7noPWTle05Y03Nv45TYH8DY+6A87Bzdy/8O+nAKv6GEnPmRwqlVNNpNhTcdy73Ae
         96RyRcqwFVyLUXBC35fgFcVriQyJeXRmnwt/rhhpCYWznLt9N+P45i793/hzXM/rI90v
         GHpXSzh8Tz64qLVIvPwXP5c5Zfm576MSMlxwju1pyFevpntM/uBwRlIG99ic+MW/PmAA
         yf8x4y6jwnLVODzaMhNdsZoInaMxdXikTKsnKfPs7ZaWdrIujRZmv2W+cTSiyv515/0j
         DdZA==
X-Gm-Message-State: AOAM533wBOh7lSiBxg0tnOJqIKlodkOZh216GU8zLu3z7ShTQbOmurWw
        8jYbcsX1eCrpi3h5ZrtDtjL/pzwowzO+tA==
X-Google-Smtp-Source: ABdhPJyMS7UNGSy3Rqx/ydCDboudOE/f/nWGHb4Nf+NhWvcOSD0aZStyXHJmgL4mz9auRwvik3kwfw==
X-Received: by 2002:a50:da0a:: with SMTP id z10mr38519029edj.298.1634516962138;
        Sun, 17 Oct 2021 17:29:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([185.69.145.195])
        by smtp.gmail.com with ESMTPSA id q11sm8881489edv.80.2021.10.17.17.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 17:29:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/4] io_uring: kill unused param from io_file_supports_nowait
Date:   Mon, 18 Oct 2021 00:29:34 +0000
Message-Id: <823d5d0b507ee19aebabb6871791a931d408117b.1634516914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1634516914.git.asml.silence@gmail.com>
References: <cover.1634516914.git.asml.silence@gmail.com>
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
index acda36166a9a..d7f38074211b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2814,8 +2814,7 @@ static inline bool io_file_supports_nowait(struct io_kiocb *req)
 	return req->flags & REQ_F_SUPPORT_NOWAIT;
 }
 
-static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-		      int rw)
+static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -3357,7 +3356,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-	return io_prep_rw(req, sqe, READ);
+	return io_prep_rw(req, sqe);
 }
 
 /*
@@ -3573,7 +3572,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-	return io_prep_rw(req, sqe, WRITE);
+	return io_prep_rw(req, sqe);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.33.1

