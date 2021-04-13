Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8D935D519
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 04:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241547AbhDMCD0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Apr 2021 22:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241515AbhDMCD0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 12 Apr 2021 22:03:26 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B040C061574
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:07 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id w7-20020a1cdf070000b0290125f388fb34so7233660wmg.0
        for <io-uring@vger.kernel.org>; Mon, 12 Apr 2021 19:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tEVCg4ybGNNIH9IeQQvksiWm4r8oRf+iULnBmFxmVW0=;
        b=Gs0YojdmBqskuD/AjqU0XRQ05BhOzrwbciYxGyk4R/l+grwO4WVlBEo2Q5kZQzlnTa
         6ECf93pxhe1k8Dh1XeSdPspdYkKXIuL3tVuN3cOOPnTaaZ2i4x0hOfyfM9hYyVbucXR5
         FQqEcUIv9BVirgu42eICGVxL5XVdPjFoiFl5Dea1//vYeVTjKUrrILy052MG0NguhS3E
         SxNA+CGaziYxJnHdWW3AowjJSXNnOQ6kvC6din1+MjfAmz09O6D2l1qWQgp4Trmwoqrh
         cWKNRXImHdQbZyXf3A4c/PMve0CCqKXTaYBs4bO8lki20g8Qa6jazr2wyvgEzyiv/nWI
         OyCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tEVCg4ybGNNIH9IeQQvksiWm4r8oRf+iULnBmFxmVW0=;
        b=Ze8J2/fcD1K5UzjtVY1JqB1Vx4SzS7JtfhO4TGjPPHXDI+bzY3B3a+q9mR8YYIR4an
         g9ncCxBzax83KA8JfdCTriuMQToQTQ4DuPHR3RCTqT7EQRitk1+5GGZGKNeX5QAeGvF9
         UHIlYX5Fe7P/PJr5/Cl4aM541AG8eCSRW1WCrrxmaiCw6VTPahaS+OLky+7ntIn/guT3
         YWcEvEuakul2mtbCNutSXS6My969td3T3AF3+atXoAn9u7s6URWsAGjHMH21exgFbM4v
         ZyE8KS16kcR9ORK7j/t73J7zv2q61iX2bfsI1K4SEh44ZdZPT4jPOH77dbR4FjhIHv7p
         yG6A==
X-Gm-Message-State: AOAM531f8xsaA2TDT66MUge3nk/jqXlIOLP7JdwtC+8eO22nOqvewPCD
        8n/crt9MiFH+MDa7h22UbFrVH+/1wOY=
X-Google-Smtp-Source: ABdhPJwoph4keMYYeFE8A0kk34OAzyZ/EdxZ55P0/LOB5T6Pu7GzTVbgD28H8HRGl4E3PhUzZpjsOA==
X-Received: by 2002:a7b:c770:: with SMTP id x16mr1676648wmk.78.1618279386349;
        Mon, 12 Apr 2021 19:03:06 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.208])
        by smtp.gmail.com with ESMTPSA id k7sm18771331wrw.64.2021.04.12.19.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 19:03:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/9] io_uring: add timeout completion_lock annotation
Date:   Tue, 13 Apr 2021 02:58:41 +0100
Message-Id: <bdbb22026024eac29203c1aa0045c4954a2488d1.1618278933.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618278933.git.asml.silence@gmail.com>
References: <cover.1618278933.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add one more sparse locking annotation for readability in
io_kill_timeout().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a0f207e62e32..eaa8f1af29cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1269,6 +1269,7 @@ static void io_queue_async_work(struct io_kiocb *req)
 }
 
 static void io_kill_timeout(struct io_kiocb *req, int status)
+	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_timeout_data *io = req->async_data;
 	int ret;
-- 
2.24.0

