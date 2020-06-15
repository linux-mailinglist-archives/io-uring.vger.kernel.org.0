Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305D21F8F7F
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728717AbgFOHZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728691AbgFOHZn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:25:43 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A74C061A0E;
        Mon, 15 Jun 2020 00:25:42 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so13524587wmh.2;
        Mon, 15 Jun 2020 00:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nrh+VH9Rpne9AeXibjb2Get1XJmLZmC1Vowuq2L/jKw=;
        b=mcRv+X7A/ZM6fqOx4VPVM1qDOj2FoAhG4CP07CLLRe0JCa7Nt0m7wOlSFBsHJt/9DH
         mT5SgSJ4XK6hleonnKFLUtEJpzsPr4U0S1+YUPy2Mg+6l2CdOyIsZcARuHE7MBs4Q4MC
         0qcCmPDkOZJQf6D6oKtLiWUCbStWJYcXSuq/ydD/gM4gy+RleyIky4GsvdNc2+PMFcI2
         7rHAez/dEc/zar8KYpl5IzZWjJsKzmuafNjHL4Xuk7DRzwDXNZIK186htsu3AO9MS49o
         c8YVW4zR2E3GL2p0CWu0w9XFMV5EAtXOJ1ecfA8YJG4EQ35UdJYKKsYrAiEpZu4PT72b
         lHlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nrh+VH9Rpne9AeXibjb2Get1XJmLZmC1Vowuq2L/jKw=;
        b=IL5ixvgLT1IEOZAC7ZvnFfev2L/oBIjykfwIaPBjn/iSLFFfJsQmnZJeWxdE4IW0Nx
         7StUTyLyfOkyY+yruEYzMtCREhuPRb/9G9K0W9G5kl1LLTAx+Kf+V40Bq77aLYzMoAbC
         QGR5HrTqNAth0/F8E/0/Fd0k0ONX/lO09Kb9CuDArhE0rG2oEQyGAsnqwJIhqbYTgqyB
         c8qZAind2GSPEzIqL9KUx7BMz9NW/YjTmlZQf3zmsMaz1Ya38wxZ7ytuq4bNTacYRL65
         SkGae/jBOONgTNTnqf0HnFoaFWEqADOaVjcmx1SlZus0Qtd97QWzkU9baqOYFLhKMqqh
         U6eA==
X-Gm-Message-State: AOAM531zke4/aGsvP73AGbYmIvYe+JNWYpZPoghOaLJ7Dj8xWcUwVwsT
        FSXJhqxAOD2lpi+NyGAmwVk=
X-Google-Smtp-Source: ABdhPJw69GmKDnkNOBDeGO8+BPsO+6KwCF1weSEWiW5UKWSop4ukcMUpDqt2J+kGKUsTqToel4vzig==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr12352924wmc.56.1592205941536;
        Mon, 15 Jun 2020 00:25:41 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id b187sm21897402wmd.26.2020.06.15.00.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:25:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] io_uring: batch cancel in io_uring_cancel_files()
Date:   Mon, 15 Jun 2020 10:24:05 +0300
Message-Id: <893d62893aab92d7a2e01e26868230621d265220.1592205754.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1592205754.git.asml.silence@gmail.com>
References: <cover.1592205754.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of waiting for each request one by one, first try to cancel all
of them in a batched manner, and then go over inflight_list/etc to reap
leftovers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bde42775693..5b5cab6691d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7370,9 +7370,22 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static bool io_wq_files_match(struct io_wq_work *work, void *data)
+{
+	struct files_struct *files = data;
+
+	return work->files == files;
+}
+
 static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
+	if (list_empty_careful(&ctx->inflight_list))
+		return;
+
+	/* cancel all at once, should be faster than doing it one by one*/
+	io_wq_cancel_cb(ctx->io_wq, io_wq_files_match, files, true);
+
 	while (!list_empty_careful(&ctx->inflight_list)) {
 		struct io_kiocb *cancel_req = NULL, *req;
 		DEFINE_WAIT(wait);
-- 
2.24.0

