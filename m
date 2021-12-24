Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3775147E9EF
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 01:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350452AbhLXAzP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Dec 2021 19:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350445AbhLXAzO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Dec 2021 19:55:14 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F89EC061401
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 16:55:14 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id w1so5460870ilh.9
        for <io-uring@vger.kernel.org>; Thu, 23 Dec 2021 16:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JRdiFXxlO37+HSR8bAH7ezyVjs5l9d/xX7ighrPdA64=;
        b=WRD/nlw74SSdfRVBbZyN0sb05Ae5smbOPbzQmVniF+UbP34SEW+emvdHvDuKM2o/n8
         /oKksVosnjoSiWAVjmG/RLnWWYYbn/5UsP2H3Hw2bwHUtN0ybwTwC9ZruNHD3ZG2I6WZ
         hUgrV4Sn4dvt4XQgvwFA6oq7HzyOCJV50TR3lYvx5ztVHVgLvDGV+lALnLwcCtM/Krr7
         5o+9b4Pft7oFN34IdOGZdNvKXSkJV+UQrazizCpYcQpID0q4uMXLtXPpI6HR9c/bW3m9
         uFWJrzi3nYOZLqjhNZAzvJrJ23Y0LCSNKYS8XPkHVq5smAm0ZU9gK+XOGbJ2ABL11Sgo
         XcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JRdiFXxlO37+HSR8bAH7ezyVjs5l9d/xX7ighrPdA64=;
        b=v0QuNzUdol/wNTBUY8Hr1tTAzdmN39cj/1XuOGWhLrXZCFGhiyWBnbu96Ud5ND+0B1
         SoWN/eXNhQuUuXv0VEctQhTVnTBtUjEcsGCu26oBA1daX0y7FZ4PEgbdSXFjvcuhABoH
         rhBsxEaCUJBZnJvp2IndAeRELCgSZi02bD/T30t49OklmBEnyCytVH0yDDnzGXEiZ+lf
         qtuu961GoN5AH1T9OVL0UWYSq8w7MbrD7sW5sm4vGckJV/XJv6eTeXvq0+Jwa9woPjbY
         mw7LeRe0+52s7vLzbi5tumrfKIucpkMS1JbHigMZiLJCGmlK2ebqKylBsS6V/4MzNAGj
         U1uw==
X-Gm-Message-State: AOAM531M7JwvD0pzzgeTkARzqRZdQbloV1c9+/6cuLurn+K3gLATOy36
        3c0nrW/1xh1R5QrpVehKze/pF6YHWwTpjw==
X-Google-Smtp-Source: ABdhPJxH5e6mJA+EdLpPDWkR8Tm6toj/NsXYhMEUGramq+GYhTnrIIP2UWGPfW8Q6HpoELNmwpxjig==
X-Received: by 2002:a05:6e02:1d8c:: with SMTP id h12mr2197910ila.138.1640307313426;
        Thu, 23 Dec 2021 16:55:13 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id c19sm4066220ioa.30.2021.12.23.16.55.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Dec 2021 16:55:13 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fix for 5.16-rc7
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <b004710b-1c16-3d90-b990-7a1faf1e5fd0@kernel.dk>
 <CAHk-=wj-fA6Sp+dNaSkadCg0sgB2fKW7Wi=f8DoG+GmiM2_shA@mail.gmail.com>
 <CAHk-=wgDGpBVOEH+JJS-byQE3adrZEpC9Sn8VCLr7ZhzDQv01w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eec82c07-3730-436e-bd7e-e813f7edafbd@kernel.dk>
Date:   Thu, 23 Dec 2021 17:55:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgDGpBVOEH+JJS-byQE3adrZEpC9Sn8VCLr7ZhzDQv01w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/23/21 4:43 PM, Linus Torvalds wrote:
> On Thu, Dec 23, 2021 at 3:39 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I don't think any of this is right.
>>
>> You can't use f_pos without using fdget_pos() to actually get the lock to it.
>>
>> Which you don't do in io_uring.
> 
> I've pulled it because it's still an improvement on what it used to
> be, but f_pos use in io_uring does seem very broken.

Totally untested, but something like this should make it saner. This
grabs the lock (if needed) and position at issue time, rather than at
prep time. We could potentially handle the unlock in the handler
themselves too, but store the state in a flag and make it part of the
slower path cleanup instead. That ensures we always end up performing
it, even if the request is errored.

Might be straight forward enough for 5.16 in fact, but considering it's
not a new regression, deferring for 5.17 will be saner imho.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb2a0cb4aaf8..a80f9f8f2cd0 100644
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
@@ -2892,12 +2895,15 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
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
@@ -3515,6 +3521,25 @@ static bool need_read_all(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static bool io_file_pos_lock(struct io_kiocb *req, bool force_nonblock)
+{
+	struct file *file = req->file;
+
+	if (!(req->flags & REQ_F_CUR_POS))
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
@@ -3543,7 +3568,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req))) {
+		if (unlikely(!io_file_supports_nowait(req) ||
+			     io_file_pos_lock(req, true))) {
 			ret = io_setup_async_rw(req, iovec, s, true);
 			return ret ?: -EAGAIN;
 		}
@@ -3551,6 +3577,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+		io_file_pos_lock(req, false);
 	}
 
 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
@@ -3668,7 +3695,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
-		if (unlikely(!io_file_supports_nowait(req)))
+		if (unlikely(!io_file_supports_nowait(req) ||
+			     io_file_pos_lock(req, true)))
 			goto copy_iov;
 
 		/* file path doesn't support NOWAIT for non-direct_IO */
@@ -3680,6 +3708,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	} else {
 		/* Ensure we clear previously set non-block flag */
 		kiocb->ki_flags &= ~IOCB_NOWAIT;
+		io_file_pos_lock(req, false);
 	}
 
 	ret = rw_verify_area(WRITE, req->file, io_kiocb_ppos(kiocb), req->result);
@@ -6584,6 +6613,8 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->kbuf);
 		req->kbuf = NULL;
 	}
+	if (req->flags & REQ_F_CUR_POS_LOCK)
+		__f_unlock_pos(req->file);
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		switch (req->opcode) {

-- 
Jens Axboe

