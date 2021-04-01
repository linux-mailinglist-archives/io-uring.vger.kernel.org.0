Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 880E735183E
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbhDARoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234715AbhDARjV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:21 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0B6C004588
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:33 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id d191so1188209wmd.2
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=f6enTfDgE1Ub3GuNSHJdD5qzKJ/7F2mD/sn3XoTZxIQ=;
        b=P3sTTys1JmI+ESNCrX0vAmHmXasG18FrFLz6SpxwYIkt13qbxB2wZvhxvXgiLsuKK1
         X+AFcQUE3gSFBjR4XRc3W0j/FMr1WmUidXUcbsC1sgK9uwss0TnkjNri9tfvsjTZNczO
         MvxM6hk2rxTNUZxx1dw8j6kjq+O0Tw5aRlTBs+CLpmPuVtQ2KaJCnHFcWcpLXkrL47w1
         3D1Kh+67RygRVmY02CnT8oFrAB6ukney87d2BJW29S4vXHXoffitZi1fkZoiqsB4e0Ri
         +z4atN2QZeeONILpYO3zEPAy0Lpe3XPPGwovt4tiWq57mqhy994XgzLd18QI+W99TOUh
         7KKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6enTfDgE1Ub3GuNSHJdD5qzKJ/7F2mD/sn3XoTZxIQ=;
        b=pzEeCPa6rG+q2uL6mX4i65yU5cXAvpXGFZ+RslccSZnU3d/o4I3Ly8/8K4J+iiSb2M
         Qb7gWqSxfA8wm2X0clBdlVFwgxuSre1SZTkb7UfS5V5ic659HQyXPey9C7D1i5yOkjQI
         KSXIeEx45jvlV96zbas5Cuv5COIKR1bNnqya1XShV/IJ9Nl0Ml9JlB0MduXxCVzlbXok
         5rUqJvnaHlnTMLYb8R1E4eHY+UuEt8D6dZv72nf1DPneJnqV97rA0cDEdRIPd533JcLZ
         10d0lcuBFLgZQwHC4TKmb0eROlK8Q5Q2B/6el+BNwbBzzlK3r102LU2HymrxOCpbzJYB
         4VGA==
X-Gm-Message-State: AOAM530HPfI6ujBAktIXfhq95Az/7ZvNNFGkM5cErOskePnOYH/rBPoR
        RNYafLdFcW8a2Ez1KtzIsNtgyBnFEpFANA==
X-Google-Smtp-Source: ABdhPJwwyeYvAUbRLBF/FC517jDiRf/UccO5Auj+0BGqLD3lHHtdDW0P7zXK5t1eBvxnnhkxir6PFg==
X-Received: by 2002:a1c:6543:: with SMTP id z64mr8503032wmb.50.1617288512466;
        Thu, 01 Apr 2021 07:48:32 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 15/26] io_uring: improve import_fixed overflow checks
Date:   Thu,  1 Apr 2021 15:43:54 +0100
Message-Id: <e437dcdc929bacbb6f11a4824ecbbf17225cb82a.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
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
index c3cbc3dfa7f3..053baa4ca02e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2771,8 +2771,8 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 	size_t len = req->rw.len;
 	struct io_mapped_ubuf *imu;
 	u16 index, buf_index = req->buf_index;
+	u64 buf_end, buf_addr = req->rw.addr;
 	size_t offset;
-	u64 buf_addr;
 
 	if (unlikely(buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
@@ -2780,11 +2780,10 @@ static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
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

