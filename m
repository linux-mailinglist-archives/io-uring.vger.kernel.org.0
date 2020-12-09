Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E24C2D38C5
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 03:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbgLICYF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 21:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLICYE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 21:24:04 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591BFC0613D6;
        Tue,  8 Dec 2020 18:23:24 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id t16so61105wra.3;
        Tue, 08 Dec 2020 18:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kEk2mz5l7WecWhgbMMZZSjIALYbOuSd6wBX0z9f5zlg=;
        b=el+Ia+dPnlOkLmTSpK7fA3ZFd71Z12DD7TXIqNy9i3WkLpb1bqXOxd7Nm/nwbIO2YG
         k8Yuy3f91BWVy4rlXD3vyZq8hJd3IR01DjOpNWqFsqtIYPTfAAB2tDeGDiM0sWffWlS2
         LdqcSjuPDXENlRU130Yz+/1mjILgYKH3QUEOmMondSWpNHbIVk2wrVxdaqqCRIIVdNAl
         o7ExEYoBCfMkS3QRWy8fazz7zsHuYdxogYyXecZ98eLiJhImVR9/E8pKrmch6sqWoyVT
         XutPu4MuiCQspHh+puGzFHOGg9avtQg8aoyCu/wzPXqQvUkSZ7Q3mq8a3qeggIjIyM4s
         CHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kEk2mz5l7WecWhgbMMZZSjIALYbOuSd6wBX0z9f5zlg=;
        b=fns6Bm98+Oi1sGiZ8qHnX/onYHLV4bjoNPXvYBGvXSspZoxo+SmwTdkjZ9M+CRaZLp
         blF3PlfqgEGLcWd9Niz9HX/8Mh9Vv1v7u7SXBrDFYvxVNQ8QKBE7PcF4+/yPIQeeDjN/
         N9mHhpPqZcRyTErg7t4T+lzZVScEIJVZlO6q3lrxocULq3IuFD8aqbF3Q415NQ8Qz6za
         /vmH3qEaO33rGbfh2XNVBG5/qPPIcrOB4IoYH4I/T9+dORWb1GeiT8DPCp9Q3A1a3jfQ
         GRssZ4Z2C5WxnMs5kvy4F0o9khxTWGuOcoYDCjkYUos7FbR7u2tG6BQyV2gbjWgu7ya8
         3bSA==
X-Gm-Message-State: AOAM531vRRAAAaz2KVJC+mwACK4pBrOlP70oD8GkGJCDT4+8lxgHYBCK
        At13GSaMskMF8AB12iirRhY=
X-Google-Smtp-Source: ABdhPJxWrrjCcSS+xhUK643SB6maMOz8JksdzmJmtBzLyHa0WrLlvDru8TaL0VthNeK+uog0GMINug==
X-Received: by 2002:a5d:5710:: with SMTP id a16mr46975wrv.229.1607480603120;
        Tue, 08 Dec 2020 18:23:23 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id k64sm330606wmb.11.2020.12.08.18.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 18:23:22 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] iov: introduce ITER_BVEC_FLAG_FIXED
Date:   Wed,  9 Dec 2020 02:19:51 +0000
Message-Id: <de27dbca08f8005a303e5efd81612c9a5cdcf196.1607477897.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607477897.git.asml.silence@gmail.com>
References: <cover.1607477897.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add ITER_BVEC_FLAG_FIXED iov iter flag, which will allow us to reuse
passed in bvec instead of copying it. In particular it means that
iter->bvec won't be freed and page references are taken remain so
until callees don't need them, including asynchronous execution.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c       |  1 +
 include/linux/uio.h | 14 +++++++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c536462920a3..9ff2805d0075 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2920,6 +2920,7 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 		}
 	}
 
+	iter->type |= ITER_BVEC_FLAG_FIXED;
 	return len;
 }
 
diff --git a/include/linux/uio.h b/include/linux/uio.h
index 72d88566694e..af626eb970cf 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -18,6 +18,8 @@ struct kvec {
 };
 
 enum iter_type {
+	ITER_BVEC_FLAG_FIXED = 2,
+
 	/* iter types */
 	ITER_IOVEC = 4,
 	ITER_KVEC = 8,
@@ -29,8 +31,9 @@ enum iter_type {
 struct iov_iter {
 	/*
 	 * Bit 0 is the read/write bit, set if we're writing.
-	 * Bit 1 is the BVEC_FLAG_NO_REF bit, set if type is a bvec and
-	 * the caller isn't expecting to drop a page reference when done.
+	 * Bit 1 is the BVEC_FLAG_FIXED bit, set if type is a bvec and the
+	 * caller ensures that page references and memory baking bvec won't
+	 * go away until callees finish with them.
 	 */
 	unsigned int type;
 	size_t iov_offset;
@@ -52,7 +55,7 @@ struct iov_iter {
 
 static inline enum iter_type iov_iter_type(const struct iov_iter *i)
 {
-	return i->type & ~(READ | WRITE);
+	return i->type & ~(READ | WRITE | ITER_BVEC_FLAG_FIXED);
 }
 
 static inline bool iter_is_iovec(const struct iov_iter *i)
@@ -85,6 +88,11 @@ static inline unsigned char iov_iter_rw(const struct iov_iter *i)
 	return i->type & (READ | WRITE);
 }
 
+static inline unsigned char iov_iter_bvec_fixed(const struct iov_iter *i)
+{
+	return i->type & ITER_BVEC_FLAG_FIXED;
+}
+
 /*
  * Total number of bytes covered by an iovec.
  *
-- 
2.24.0

