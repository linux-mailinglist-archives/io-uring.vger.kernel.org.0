Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3A9334BDA
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbhCJWop (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233960AbhCJWoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:30 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D56C061760
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:08 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso8055848pjd.3
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dksuXgEypiZFfREPo4ZVzsAQw7R8F4EWY0Nu2gThQow=;
        b=hUvXxXrkWgbUtPfYM+zb+iSpb4nrXa0L9lz2GsC7OzpFbbHafSvLAje8Bl7MKhQuIW
         mor4Hdt0Sb8ZpKUxbn+HQVAz9Ypk1nWmUKeISBZu8TTznvhsGrxjunX7Lt8c+ZpBSxZ0
         Nc1LJOJSdgRZGvs/IvA1rr6o9bcATSI8fdafJ5a6hi9u+NsTbeZ6YqTUbqWLyaN+VoR0
         DNat6mRmwgmBL2BPnogZcl7SzamXsrBqkB2FH9v6cQ8Eqm7Bp+WNlQtUbtGriHsTZg4j
         7/f4Ilel7xtjCgQFXa+qfqH7Lfh3i9M7oTt190qFHdfXMrbtooqpynHplqffU7vAddl3
         4rjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dksuXgEypiZFfREPo4ZVzsAQw7R8F4EWY0Nu2gThQow=;
        b=UGMIaMlTdtd3eRgVPPGA0fdGyqtwDY/uKyY/mWH2iP90K6HEZShJm8AifCCJwQYrct
         MTUBzItVM8iD+pUApvUtN6AxU3rcLtQyEaaderO9xFrUx0iqFM5UuAkVhO7wsJeV3FiM
         vMiKuIceRfjXMfjk75cAFuwhErMiF2dARFf5r9jfBw58rXYe2Pw5Fy5nFAV8fQw6LkPP
         mtABqsT/yJRk8uwKGJpqgnsDPEMLN/TYcacUXeWJvb6Q9vTnWqR94tWVZUXhR9tQQ62B
         bJIHa1pDfNTSq2h+YtpH56axUTLmfPVtXyO/vlaW93x9VntJWzONWUeBFoTAoZax0/18
         4aKA==
X-Gm-Message-State: AOAM530XNx4QezYzy+UVTCRYQPaudY1wXVKuDMMUQOjUzHmFNHNLnJFG
        60dXdwcC5h9OIwES5Et3Sy4PgrlY8f+njg==
X-Google-Smtp-Source: ABdhPJwLFoaNmqs/yD8O0DDUyP2ROvt7QfkZ/k6I0X3GMgumd+PnpD6OeHZ/vgMFpVLSdyfigaMYPA==
X-Received: by 2002:a17:902:bb83:b029:e5:dacc:9035 with SMTP id m3-20020a170902bb83b02900e5dacc9035mr4993891pls.80.1615416247801;
        Wed, 10 Mar 2021 14:44:07 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/27] io_uring: make del_task_file more forgiving
Date:   Wed, 10 Mar 2021 15:43:34 -0700
Message-Id: <20210310224358.1494503-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Rework io_uring_del_task_file(), so it accepts an index to delete, and
it's not necessarily have to be in the ->xa. Infer file from xa_erase()
to maintain a single origin of truth.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d51c6ba9268b..00a736867b76 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8785,15 +8785,18 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 /*
  * Remove this io_uring_file -> task mapping.
  */
-static void io_uring_del_task_file(struct file *file)
+static void io_uring_del_task_file(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct file *file;
+
+	file = xa_erase(&tctx->xa, index);
+	if (!file)
+		return;
 
 	if (tctx->last == file)
 		tctx->last = NULL;
-	file = xa_erase(&tctx->xa, (unsigned long)file);
-	if (file)
-		fput(file);
+	fput(file);
 }
 
 static void io_uring_clean_tctx(struct io_uring_task *tctx)
@@ -8802,7 +8805,7 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	unsigned long index;
 
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_del_task_file(file);
+		io_uring_del_task_file(index);
 	if (tctx->io_wq) {
 		io_wq_put_and_exit(tctx->io_wq);
 		tctx->io_wq = NULL;
-- 
2.30.2

