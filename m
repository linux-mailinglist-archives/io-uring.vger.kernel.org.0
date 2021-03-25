Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138EF3492DA
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbhCYNNC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbhCYNMb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:31 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB07C06175F
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:30 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id x7so2213618wrw.10
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9vqq4uywbF9FCj7Zki3TyfoqkzMVI73uF8HqBvaANCA=;
        b=iKxxrpLNihapdJ74Ter96Ptd8pkYHGyQ1VSBQITv8aTTo6MJR/+eDUlS0LjAnOg2H/
         AFyFuuxgoQAMSM8zmM4FPPl3pMF3djfAnckhIHfUQSXuFKhakr/o8C1W8TZb+/hivxO5
         arc2JhP+SPUDPFLR8LE0nPfUFr0g55wiYv76kINrO9KgrQlAGGmn7TlTLu5KF7ll/Me4
         KR9nTi98m+Racv5OGoer3/RJQkgLewDt80wKK9RuDJB6WFQWHoX9ZiKRmFAWkZ9B2tA9
         04WN5T9BB9DTq2IIhVvhed1nTqg4uJOsSwJZU30Du9UEld9w/3n+u03Opy38j+t23iRY
         eqOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9vqq4uywbF9FCj7Zki3TyfoqkzMVI73uF8HqBvaANCA=;
        b=BxvsyC95Dcb3PexGUEVyUl+EJ3MPi7Yd/2DUDeKvo4yKpNy1KoKaKG7RkhsX6SrRK9
         nXMp4SCCMP5z5nnUlrDh0uDyN+iybCJ3FU3dAQdcE2DDen7E3gHgksSDdxV+8sojldXB
         1pw/tpNCFsxjEAk99QQbW6yf5Pj8+ST/FSiUWn+gcRwB/BwcF00XPADsbnhEEIujeHfg
         cXdRrmURFod6A2zv/4yvrHy/O9jUPMf9zPI231+Dc/uQkgeAA5GjexoqoakOzKWTdymL
         2cS8xyHAzTxkrTklZkWQO8bduq34KZeQJVARbpxJGcp5ffh0UDMhx2qysX8UkQj5SNwJ
         Y35Q==
X-Gm-Message-State: AOAM532HiQ0WIJZCmYWAGd3a+Vt7DSJiUovbAEQgtYU7gjm9ZNr2Bhzy
        G/VG+HGnHCmyPt+pQGwgStv3UXLoghhblQ==
X-Google-Smtp-Source: ABdhPJzXKgNzeDKQhmF7V7vfKdgr8uGMXyE/n0KIkhtGtXGHdyvOpzEgl92nYg2x60OkKPbbUi+rrg==
X-Received: by 2002:a5d:534b:: with SMTP id t11mr8823024wrv.186.1616677949432;
        Thu, 25 Mar 2021 06:12:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 15/17] io_uring: improve import_fixed overflow checks
Date:   Thu, 25 Mar 2021 13:08:04 +0000
Message-Id: <0f77ac393ba75e384c57b5f8150f4e8b27c59b2a.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace a hand-coded overflow check with a specialised function. Even
though compilers are smart enough to generate identical binary (i.e.
check carry bit), but it's more foolproof and conveys the intention
better.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b324f7c7a5cc..f30580f59070 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2802,8 +2802,8 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	size_t len = req->rw.len;
 	struct io_mapped_ubuf *imu;
 	u16 index, buf_index = req->buf_index;
+	u64 buf_end, buf_addr = req->rw.addr;
 	size_t offset;
-	u64 buf_addr;
 
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
@@ -2811,11 +2811,10 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	imu = &ctx->user_bufs[index];
 	buf_addr = req->rw.addr;
 
-	/* overflow */
-	if (buf_addr + len < buf_addr)
+	if (unlikely(check_add_overflow(buf_addr, (u64)len, &buf_end)))
 		return -EFAULT;
 	/* not inside the mapped region */
-	if (buf_addr < imu->ubuf || buf_addr + len > imu->ubuf + imu->len)
+	if (buf_addr < imu->ubuf || buf_end > imu->ubuf + imu->len)
 		return -EFAULT;
 
 	/*
-- 
2.24.0

