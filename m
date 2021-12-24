Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41A947EFA6
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 15:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhLXOfV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Dec 2021 09:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241680AbhLXOfU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Dec 2021 09:35:20 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299A0C06175A
        for <io-uring@vger.kernel.org>; Fri, 24 Dec 2021 06:35:20 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id v10so6706392ilj.3
        for <io-uring@vger.kernel.org>; Fri, 24 Dec 2021 06:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=uo9s+NeBGlBQ0TTD4NMAn6hmrLiEXKBG/R0qIRwZ7oI=;
        b=iNIYRcxgaLYTukuC2rErO9J+7OasWrrzp2cy8oUG3WhqqWCQcyMQSuN6t3nZ+Z51Ae
         w+PuAqhyDW3sxTfKTXewpaOtDcavZ+G0cuftdTXBx5rUUczfxqq6laGHw/IWx+m/cEds
         M5Ti8HKZwHVfOa9yCf208tiv0U6r9EuyhXvclr4/A1T2yx9Yhx5yVAl8QKfwKk93rKwC
         rit+7fs0X5yoYixOvw29l35w4QYqx/qz7/BQ5mjAEtE5Z2IiijPCISkITTI6TZGJg9Nh
         2Fl35efaO7E9CjM0LGXs0dFCQe0oV/0KnQBwfmI9b7GFlaAlSuPQR9UGHvAMbA9TwIzf
         Miow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=uo9s+NeBGlBQ0TTD4NMAn6hmrLiEXKBG/R0qIRwZ7oI=;
        b=ZA+7woA5TPq+PLRc0CEKzVoGzZSyQRAmwWZ4ZmWPy1+q2dXLmxu0ZeK2nsORq9ze84
         iQXuRnSjKlal2ddu3wLqlRJEuTj/1U0EECgx6fr7xTxEWNgr3plXA5+b+IPHup5Wm5Ba
         5a8rvJKFBVrCIbbPNlwla9reSHs2H0cGi5xeUgN1+LjvU6+Vf4sQ+8rLhOAnS/G3Nwe4
         oIyPNhpn9lEVUgRdmy5IgIdfAD+h6CwrEMs7N9Y4iqLDlekuBcUXudpuruagsamXN5si
         8IQcu6AK3zVFf92hoHy1+WmbPzbkIG2UFgpqDXS+O1jfx/wcHlJ1+QLeTicGIs+tLQG3
         bQ9g==
X-Gm-Message-State: AOAM530If3E8c/IWztQMeg/dczVMdv/VURY76rE0D+JDfZoNRNEBP8Ss
        X8TiHK8nhnjT/IhzUbekbEWIwAQgT6y9Sg==
X-Google-Smtp-Source: ABdhPJwut/kxJkokNK2si7EY0BLLCiXAZG2wHIPgvFCS6X4rlwkeXauxWL6uIyN4lTcLQbtiibLRIQ==
X-Received: by 2002:a05:6e02:1541:: with SMTP id j1mr3248404ilu.7.1640356519235;
        Fri, 24 Dec 2021 06:35:19 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o7sm4619702ilo.15.2021.12.24.06.35.18
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Dec 2021 06:35:18 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC] io_uring: improve current file position IO
Message-ID: <8a9e55bf-3195-5282-2907-41b2f2b23cc8@kernel.dk>
Date:   Fri, 24 Dec 2021 07:35:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring should be protecting the current file position with the
file position lock, ->f_pos_lock. Grab and track the lock state when
the request is being issued, and make the unlock part of request
cleaning.

Fixes: ba04291eb66e ("io_uring: allow use of offset == -1 to mean file position")
Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Main thing I don't like here:

- We're holding the f_pos_lock across the kernel/user boundary, as
  it's held for the duration of the IO. Alternatively we could
  keep it local to io_read() and io_write() and lose REQ_F_CUR_POS_LOCK,
  but will messy up those functions more and add more items to the
  fast path (which current position read/write definitely is not).

Suggestions welcome...


diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb2a0cb4aaf8..6f7713ab2eda 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -112,7 +112,7 @@
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
-				REQ_F_ASYNC_DATA)
+				REQ_F_ASYNC_DATA | REQ_F_CUR_POS_LOCK)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -726,6 +726,7 @@ enum {
 	REQ_F_FAIL_BIT		= 8,
 	REQ_F_INFLIGHT_BIT,
 	REQ_F_CUR_POS_BIT,
+	REQ_F_CUR_POS_LOCK_BIT,
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
@@ -765,6 +766,8 @@ enum {
 	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
 	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
+	/* request is holding file position lock */
+	REQ_F_CUR_POS_LOCK	= BIT(REQ_F_CUR_POS_LOCK_BIT),
 	/* must not punt to workers */
 	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
 	/* has or had linked timeout */
@@ -2715,6 +2718,8 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 		req_set_fail(req);
 		req->result = res;
 	}
+	if (req->flags & REQ_F_CUR_POS && res > 0)
+		req->file->f_pos += res;
 	return false;
 }
 
@@ -2892,12 +2897,15 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	kiocb->ki_pos = READ_ONCE(sqe->off);
 	if (kiocb->ki_pos == -1) {
-		if (!(file->f_mode & FMODE_STREAM)) {
+		/*
+		 * If we end up using the current file position, just set the
+		 * flag and the actual file position will be read in the op
+		 * handler themselves.
+		 */
+		if (!(file->f_mode & FMODE_STREAM))
 			req->flags |= REQ_F_CUR_POS;
-			kiocb->ki_pos = file->f_pos;
-		} else {
+		else
 			kiocb->ki_pos = 0;
-		}
 	}
 	kiocb->ki_flags = iocb_flags(file);
 	ret = kiocb_set_rw_flags(kiocb, READ_ONCE(sqe->rw_flags));
@@ -2979,8 +2987,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 			ret += io->bytes_done;
 	}
 
-	if (req->flags & REQ_F_CUR_POS)
-		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && (kiocb->ki_complete == io_complete_rw))
 		__io_complete_rw(req, ret, 0, issue_flags);
 	else
@@ -3515,6 +3521,27 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static bool io_file_pos_lock(struct io_kiocb *req, bool force_nonblock)
+{
+	struct file *file = req->file;
+
+	if (!(req->flags & REQ_F_CUR_POS))
+		return false;
+	if (req->flags & REQ_F_CUR_POS_LOCK)
+		return false;
+	if (file->f_mode & FMODE_ATOMIC_POS && file_count(file) > 1) {
+		if (force_nonblock) {
+			if (!mutex_trylock(&file->f_pos_lock))
+				return true;
+		} else {
+			mutex_lock(&file->f_pos_lock);
+		}
+		req->flags |= REQ_F_CUR_POS_LOCK;
+	}
+	req->rw.kiocb.ki_pos = file->f_pos;
+	return false;
+}
+
 static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rw_state __s, *s = &__s;
@@ -3543,7 +3570,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
+		if (unlikely(!io_file_supports_nowait(req) ||
+			     io_file_pos_lock(req, true))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
@@ -3551,6 +3579,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+		io_file_pos_lock(req, false);
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
@@ -3668,7 +3697,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req)))
+		if (unlikely(!io_file_supports_nowait(req) ||
+			     io_file_pos_lock(req, true)))
 			goto copy_iov;
 
 		/* file path doesn't support NOWAIT for non-direct_IO */
@@ -3680,6 +3710,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+		io_file_pos_lock(req, false);
 	}
 
 	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
@@ -6584,6 +6615,8 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->kbuf);
 		req->kbuf = NULL;
 	}
+	if (req->flags & REQ_F_CUR_POS_LOCK)
+		__f_unlock_pos(req->file);
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		switch (req->opcode) {

-- 
Jens Axboe

