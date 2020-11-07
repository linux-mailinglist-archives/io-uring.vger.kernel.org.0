Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77BEB2AA54E
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 14:19:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgKGNTk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 08:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727084AbgKGNTk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 08:19:40 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B32C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 05:19:39 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id k2so714732wrx.2
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 05:19:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GGLNgE0r8XTm8FotwjOuVcb3j6ORuNnMMAmC3nsSBl0=;
        b=vIhmTj/kTpHIEzMgHr6g/AcL1eXQq15DG2JoPrpMe6TpzKxvjY21S65w6Am4RUsivb
         thFu+bJnfBf7ytoelSWNJzFO/JX3bsnnFG0S5iJfVwCTPnEI59m4quJjouEm4YIUzS5h
         XI4JT7sjCUYOlLVML9ALwa2f8yk4lUe/ntyzaMd4sAI3EUy2xLBe3SNOpPbzHaxJDZsO
         kHDFuDksMAMMtbkXgzmVxmzd0HAAmj5BtFVxCbtccwml73eo9rPVTfnjpmqQ0EQYKiiI
         ZL8+6nfLLKQfK6/bBsgG/EIx/DKRIcx4rR2HyZJJeAsccR0ASHxYKH7uUjuk48TAhaIi
         ehnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGLNgE0r8XTm8FotwjOuVcb3j6ORuNnMMAmC3nsSBl0=;
        b=DBOa+DsQANQtj75A3MioK1uEPyM+O6D2QSSeBLhpixKogzz/51EH4VRFf8aGFepaIQ
         7ZuPkLWtUS7UTlo9xnNHSZ/VZnoZ6J1EkZxL27JzbN3F/ze8cL0PLUKERL5ufULxR+8c
         H2NEV3LFEijZCMNwIDMZBfiro8Gg5wOcbvwUnEXcwl8E8kG2p0xIigbitmt1xb8kHftH
         +5R6s5AOfgtl7y+BZrSno0eiECnwre38MV3b2BUkFciDjNhExgOICPmX3F1i5OzdNogV
         8zC1a+WO1cHeNJqVdJAFhKPgfjiNYsfnHxXYddXt+OlA+oa36S6IgPJqbrMKPun0VsRQ
         8hxQ==
X-Gm-Message-State: AOAM530bN/YF9Gl6b57ZiEn9U4au4fZTIufSD8bzNno8uRqt+bSQ9Mk/
        E7n4C2mPbXB6fKwkxj9zCxc=
X-Google-Smtp-Source: ABdhPJxMW9uLmmHGONe1SAeX8x2ItuKRnYc1bgSlp0ok2ihFh3U6JDVey9GCIHrWNcib7YDNYZQEBA==
X-Received: by 2002:a05:6000:1088:: with SMTP id y8mr3721653wrw.207.1604755178694;
        Sat, 07 Nov 2020 05:19:38 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id f1sm6411810wmj.3.2020.11.07.05.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 05:19:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        David Laight <David.Laight@ACULAB.COM>
Subject: [PATCH 2/3] io_uring: remove duplicated io_size from rw
Date:   Sat,  7 Nov 2020 13:16:26 +0000
Message-Id: <70c69bcbe693c678cf0036f6d70342736c0064e0.1604754823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604754823.git.asml.silence@gmail.com>
References: <cover.1604754823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_size and iov_count in io_read() and io_write() hold the same value,
kill the last one.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e72f9a3fd8b5..f3033e3929c1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3449,7 +3449,6 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
 	ssize_t io_size, ret, ret2;
-	size_t iov_count;
 	bool no_async;
 
 	if (rw)
@@ -3458,8 +3457,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
-	iov_count = iov_iter_count(iter);
-	io_size = iov_count;
+	io_size = iov_iter_count(iter);
 	req->result = io_size;
 	ret = 0;
 
@@ -3475,7 +3473,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	if (no_async)
 		goto copy_iov;
 
-	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), iov_count);
+	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3494,7 +3492,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		if (req->file->f_flags & O_NONBLOCK)
 			goto done;
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
+		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = 0;
 		goto copy_iov;
 	} else if (ret < 0) {
@@ -3577,7 +3575,6 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	struct kiocb *kiocb = &req->rw.kiocb;
 	struct iov_iter __iter, *iter = &__iter;
 	struct io_async_rw *rw = req->async_data;
-	size_t iov_count;
 	ssize_t ret, ret2, io_size;
 
 	if (rw)
@@ -3586,8 +3583,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
-	iov_count = iov_iter_count(iter);
-	io_size = iov_count;
+	io_size = iov_iter_count(iter);
 	req->result = io_size;
 
 	/* Ensure we clear previously set non-block flag */
@@ -3605,7 +3601,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	    (req->flags & REQ_F_ISREG))
 		goto copy_iov;
 
-	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), iov_count);
+	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), io_size);
 	if (unlikely(ret))
 		goto out_free;
 
@@ -3649,7 +3645,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
-		iov_iter_revert(iter, iov_count - iov_iter_count(iter));
+		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 		if (!ret)
 			return -EAGAIN;
-- 
2.24.0

