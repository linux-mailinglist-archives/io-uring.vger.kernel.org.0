Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21E11BCC43
	for <lists+io-uring@lfdr.de>; Tue, 28 Apr 2020 21:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgD1TUM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Apr 2020 15:20:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729146AbgD1TUI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Apr 2020 15:20:08 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C03C03C1AB
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 12:20:08 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 18so9996507pfv.8
        for <io-uring@vger.kernel.org>; Tue, 28 Apr 2020 12:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hL437pdK23+7sqf4RIIBprIrlTKowwEXkaE0IX50ixY=;
        b=yChNQteSml+BGR3M1V0u6/eGl8KOfJBQ2Pd9+VOAxtL0eOIvWhZ4DwoKX8rfboS2Zm
         T5D84d326oo94Edd0vKZoVsf/CfBYUh6TQpFeN1i/STIU8d3rnJNba7B+3QRUauopMMO
         oZMTq3BhQ4JezCwCXLLgsOo4MrueblIu/LgYd3nL3q3MFdX9trmaCreEhbwPlBJCLdcT
         ++oJkErhRnETZWQl+yKnVdfDeDVx90jE5WaRyJOFzJLO9JRycNlxzY3Y7bHdwm80qxOC
         7JjT7uTC9YYzyrW8svOkzmMgMp/G5Ozw2CHs6y6O5zck0HEE5MpetaQUWB3DFZmj4z0n
         QJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hL437pdK23+7sqf4RIIBprIrlTKowwEXkaE0IX50ixY=;
        b=YTUgi5SFgFvju1FMtC1DNNtzMBe4SIKWJI6H6WYRtUmuwvfhq5Dh2lcOxvdUcwSEkm
         5EkDMEg8DpUgtwRbDdRHqYMaarTZ1+1qNSVpFsFFJMrPPbrj6c+6fLoVrva5g+8F4tlN
         XLNugBxMBGmgQk/NDqPAbyyxwym4Ch64JsqwG/Ad2p3YQKKr/JvDWwq36w+FGyfvOTbj
         x7WbQY1jyFQvi8rpWsn1g9VKQCjsPKvBqwJ26z1Hw8LNYLt5G15IHf6y4ljJuupBPBoh
         8r9DsFVfRPK9AeWYn5KZhN15c23ZRvrVwCU6H3Emhi0WNyVOLzH+d38wwQaKZ7d5WTHS
         ho5A==
X-Gm-Message-State: AGi0PuatlPyqr+N9ZDPy6G9UEvEuj4EDRgQxOo8XZbe4Dx5K+Tmo0IFh
        01d/lIVJcE4eZX9OgSqldQ80pv9LLdGu0g==
X-Google-Smtp-Source: APiQypLg1kkb/jgi6ditj+wiTUAX8dY3HrfzzErXYdTkebmgIw273A1zNtYbJT/hzA6CT8ddCZxyeQ==
X-Received: by 2002:aa7:819a:: with SMTP id g26mr31866450pfi.193.1588101607446;
        Tue, 28 Apr 2020 12:20:07 -0700 (PDT)
Received: from x1.thefacebook.com ([2620:10d:c090:400::5:7a1a])
        by smtp.gmail.com with ESMTPSA id u188sm15851946pfu.33.2020.04.28.12.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 12:20:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: enable poll retry for any file with ->read_iter / ->write_iter
Date:   Tue, 28 Apr 2020 13:20:02 -0600
Message-Id: <20200428192003.12106-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428192003.12106-1-axboe@kernel.dk>
References: <20200428192003.12106-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can have files like eventfd where it's perfectly fine to do poll
based retry on them, right now io_file_supports_async() doesn't take
that into account.

Pass in data direction and check the f_op instead of just always needing
an async worker.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 084dfade5cda..53cadadc7f89 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2038,7 +2038,7 @@ static struct file *__io_file_get(struct io_submit_state *state, int fd)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-static bool io_file_supports_async(struct file *file)
+static bool io_file_supports_async(struct file *file, int rw)
 {
 	umode_t mode = file_inode(file)->i_mode;
 
@@ -2047,7 +2047,10 @@ static bool io_file_supports_async(struct file *file)
 	if (S_ISREG(mode) && file->f_op != &io_uring_fops)
 		return true;
 
-	return false;
+	if (rw == READ)
+		return file->f_op->read_iter != NULL;
+
+	return file->f_op->write_iter != NULL;
 }
 
 static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
@@ -2575,7 +2578,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock)
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
 	 */
-	if (force_nonblock && !io_file_supports_async(req->file))
+	if (force_nonblock && !io_file_supports_async(req->file, READ))
 		goto copy_iov;
 
 	iov_count = iov_iter_count(&iter);
@@ -2666,7 +2669,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock)
 	 * If the file doesn't support async, mark it as REQ_F_MUST_PUNT so
 	 * we know to async punt it even if it was opened O_NONBLOCK
 	 */
-	if (force_nonblock && !io_file_supports_async(req->file))
+	if (force_nonblock && !io_file_supports_async(req->file, WRITE))
 		goto copy_iov;
 
 	/* file path doesn't support NOWAIT for non-direct_IO */
@@ -2760,11 +2763,11 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static bool io_splice_punt(struct file *file)
+static bool io_splice_punt(struct file *file, int rw)
 {
 	if (get_pipe_info(file))
 		return false;
-	if (!io_file_supports_async(file))
+	if (!io_file_supports_async(file, rw))
 		return true;
 	return !(file->f_flags & O_NONBLOCK);
 }
@@ -2779,7 +2782,7 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	long ret;
 
 	if (force_nonblock) {
-		if (io_splice_punt(in) || io_splice_punt(out))
+		if (io_splice_punt(in, READ) || io_splice_punt(out, WRITE))
 			return -EAGAIN;
 		flags |= SPLICE_F_NONBLOCK;
 	}
-- 
2.26.2

