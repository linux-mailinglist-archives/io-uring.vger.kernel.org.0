Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C928744AED0
	for <lists+io-uring@lfdr.de>; Tue,  9 Nov 2021 14:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhKINgX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Nov 2021 08:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233278AbhKINgX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Nov 2021 08:36:23 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33472C061764
        for <io-uring@vger.kernel.org>; Tue,  9 Nov 2021 05:33:37 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id b12so33038371wrh.4
        for <io-uring@vger.kernel.org>; Tue, 09 Nov 2021 05:33:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bfv0l7FWkFDVcKyTNF0SnkvmNgddE7YPRhqbJ1JQ27I=;
        b=wEsnpdihdcmU+2j+84YX+DyOsyXiadaAUppczK+LvCvTX0LQ+dQ46MJi9ZyGMenu1V
         f6MiD2qk6XNZ0eMGF/eaGPvyeJsOB9TaFDzqs954QJRMUSEJcoXvHDI5oha7JPsBhdWR
         j0xNOPoU8GMOYcR9WG8Wv0mpjJ0YItg5cTXejDuf4NZ209FdEXBdIKeIOernpbXsgCiN
         VZygCoK0jMhWUQci+lEGrNE+edBTAI6J7ko1x8QtYUMPvfhoK3DMTsCLwKtAesMb1h35
         +bDnW1jDIqz3+xDhKtoGEklEp+kGT8ySKQS91udQWd61Lz3EOehgKfmcPDzk1hM49xjl
         LWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bfv0l7FWkFDVcKyTNF0SnkvmNgddE7YPRhqbJ1JQ27I=;
        b=jBneUd4rxYSJuK2njnUhVBcDQ8xw2+ct+JbrICG5+pNt6FPZsoX3JjDE4pYott1qKq
         Ej6BKSjv0o6L61zrzQRWpm+/sYhejvdYg+jqQhUg5IEwgShfKdgPSyKG0VJbu8nU38pY
         t6jbuG4yV3A+HKzdAozL4s26xOmGWsIp67J0jDTtR5TKXNwHDaMrgZL0xfmJ6cTbOwt4
         qxnXo/PnrkLjVcHsgOuwDIQ0x5fso3fM/XF3R6LqqW16c5hzzaj/fGouzdV39d7wYNbs
         4rEnzukr7zzPQeAgFWbHiUUYpGl47uJ97/zSkinLGWP1SpEEKBvPrRfLHcuMCvDqYiDc
         gTIw==
X-Gm-Message-State: AOAM533jTwAfq6HkqMZdd+w87WaYijQo92dM04V2CoikNH9l3yTT6CM8
        BEGlzmVVQOYT30OfQ2GwqDIm5A==
X-Google-Smtp-Source: ABdhPJxfMJqc0N9Q4dvk+pW2zMs9nSK03WZm+mhy5u+2SXUky61qdBJh+bEArR763ESNnMeK1jYlRg==
X-Received: by 2002:adf:8293:: with SMTP id 19mr9800709wrc.167.1636464815660;
        Tue, 09 Nov 2021 05:33:35 -0800 (PST)
Received: from google.com ([95.148.6.174])
        by smtp.gmail.com with ESMTPSA id a9sm19752270wrt.66.2021.11.09.05.33.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 05:33:34 -0800 (PST)
Date:   Tue, 9 Nov 2021 13:33:32 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        syzbot <syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [syzbot] KASAN: stack-out-of-bounds Read in iov_iter_revert
Message-ID: <YYp4rC4M/oh8fgr7@google.com>
References: <6f7d4c1d-f923-3ab1-c525-45316b973c72@gmail.com>
 <00000000000047f3b805c962affb@google.com>
 <YYLAYvFU+9cnu+4H@google.com>
 <0b4a5ff8-12e5-3cc7-8971-49e576444c9a@gmail.com>
 <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <dd122760-5f87-10b1-e50d-388c2631c01a@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 08 Nov 2021, Jens Axboe wrote:
> On 11/8/21 8:29 AM, Pavel Begunkov wrote:
> > On 11/3/21 17:01, Lee Jones wrote:
> >> Good afternoon Pavel,
> >>
> >>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
> >>>
> >>> Reported-and-tested-by: syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
> >>>
> >>> Tested on:
> >>>
> >>> commit:         bff2c168 io_uring: don't retry with truncated iter
> >>> git tree:       https://github.com/isilence/linux.git truncate
> >>> kernel config:  https://syzkaller.appspot.com/x/.config?x=730106bfb5bf8ace
> >>> dashboard link: https://syzkaller.appspot.com/bug?extid=9671693590ef5aad8953
> >>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
> >>>
> >>> Note: testing is done by a robot and is best-effort only.
> >>
> >> As you can see in the 'dashboard link' above this bug also affects
> >> android-5-10 which is currently based on v5.10.75.
> >>
> >> I see that the back-port of this patch failed in v5.10.y:
> >>
> >>    https://lore.kernel.org/stable/163152589512611@kroah.com/
> >>
> >> And after solving the build-error by back-porting both:
> >>
> >>    2112ff5ce0c11 iov_iter: track truncated size
> >>    89c2b3b749182 io_uring: reexpand under-reexpanded iters
> >>
> >> I now see execution tripping the WARN() in iov_iter_revert():
> >>
> >>    if (WARN_ON(unroll > MAX_RW_COUNT))
> >>        return
> >>
> >> Am I missing any additional patches required to fix stable/v5.10.y?
> > 
> > Is it the same syz test? There was a couple more patches for
> > IORING_SETUP_IOPOLL, but strange if that's not the case.
> > 
> > 
> > fwiw, Jens decided to replace it with another mechanism shortly
> > after, so it may be a better idea to backport those. Jens,
> > what do you think?
> > 
> > 
> > commit 8fb0f47a9d7acf620d0fd97831b69da9bc5e22ed
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Fri Sep 10 11:18:36 2021 -0600
> > 
> >      iov_iter: add helper to save iov_iter state
> > 
> > commit cd65869512ab5668a5d16f789bc4da1319c435c4
> > Author: Jens Axboe <axboe@kernel.dk>
> > Date:   Fri Sep 10 11:19:14 2021 -0600
> > 
> >      io_uring: use iov_iter state save/restore helpers
> 
> Yes, I think backporting based on the save/restore setup is the
> sanest way by far.

Would you be kind enough to attempt to send these patches to Stable?

When I tried to back-port them, the second one gave me trouble.  And
without the in depth knowledge of the driver/subsystem that you guys
have, I found it almost impossible to resolve all of the conflicts:

diff --cc fs/io_uring.c
index 104dff9c71314,25bda8a5a4e5d..0000000000000
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@@ -2567,57 -2603,20 +2568,64 @@@ static void io_complete_rw_common(struc
  }
  
  #ifdef CONFIG_BLOCK
 -static bool io_resubmit_prep(struct io_kiocb *req)
 +static bool io_resubmit_prep(struct io_kiocb *req, int error)
  {
 -	struct io_async_rw *rw = req->async_data;
 +	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 +	ssize_t ret = -ECANCELED;
 +	struct iov_iter iter;
 +	int rw;
 +
++<<<<<<< HEAD
 +	if (error) {
 +		ret = error;
 +		goto end_req;
 +	}
 +
 +	switch (req->opcode) {
 +	case IORING_OP_READV:
 +	case IORING_OP_READ_FIXED:
 +	case IORING_OP_READ:
 +		rw = READ;
 +		break;
 +	case IORING_OP_WRITEV:
 +	case IORING_OP_WRITE_FIXED:
 +	case IORING_OP_WRITE:
 +		rw = WRITE;
 +		break;
 +	default:
 +		printk_once(KERN_WARNING "io_uring: bad opcode in resubmit %d\n",
 +				req->opcode);
 +		goto end_req;
 +	}
  
 +	if (!req->async_data) {
 +		ret = io_import_iovec(rw, req, &iovec, &iter, false);
 +		if (ret < 0)
 +			goto end_req;
 +		ret = io_setup_async_rw(req, iovec, inline_vecs, &iter, false);
 +		if (!ret)
 +			return true;
 +		kfree(iovec);
 +	} else {
 +		return true;
 +	}
 +end_req:
 +	req_set_fail_links(req);
 +	return false;
++=======
+ 	if (!rw)
+ 		return !io_req_prep_async(req);
+ 	iov_iter_restore(&rw->iter, &rw->iter_state);
+ 	return true;
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  }
 +#endif
  
 -static bool io_rw_should_reissue(struct io_kiocb *req)
 +static bool io_rw_reissue(struct io_kiocb *req, long res)
  {
 +#ifdef CONFIG_BLOCK
  	umode_t mode = file_inode(req->file)->i_mode;
 -	struct io_ring_ctx *ctx = req->ctx;
 +	int ret;
  
  	if (!S_ISBLK(mode) && !S_ISREG(mode))
  		return false;
@@@ -3268,13 -3307,20 +3276,23 @@@ static int io_setup_async_rw(struct io_
  			     const struct iovec *fast_iov,
  			     struct iov_iter *iter, bool force)
  {
 -	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 +	if (!force && !io_op_defs[req->opcode].needs_async_data)
  		return 0;
  	if (!req->async_data) {
++<<<<<<< HEAD
 +		if (__io_alloc_async_data(req))
++=======
+ 		struct io_async_rw *iorw;
+ 
+ 		if (io_alloc_async_data(req)) {
+ 			kfree(iovec);
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  			return -ENOMEM;
 -		}
  
  		io_req_map_rw(req, iovec, fast_iov, iter);
+ 		iorw = req->async_data;
+ 		/* we've copied and mapped the iter, ensure state is saved */
+ 		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
  	}
  	return 0;
  }
@@@ -3417,18 -3443,28 +3436,43 @@@ static int io_read(struct io_kiocb *req
  	struct kiocb *kiocb = &req->rw.kiocb;
  	struct iov_iter __iter, *iter = &__iter;
  	struct io_async_rw *rw = req->async_data;
++<<<<<<< HEAD
 +	ssize_t io_size, ret, ret2;
 +	bool no_async;
++=======
+ 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+ 	struct iov_iter_state __state, *state;
+ 	ssize_t ret, ret2;
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  
 -	if (rw) {
 +	if (rw)
  		iter = &rw->iter;
++<<<<<<< HEAD
 +
 +	ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
 +	if (ret < 0)
 +		return ret;
 +	io_size = iov_iter_count(iter);
 +	req->result = io_size;
 +	ret = 0;
++=======
+ 		state = &rw->iter_state;
+ 		/*
+ 		 * We come here from an earlier attempt, restore our state to
+ 		 * match in case it doesn't. It's cheap enough that we don't
+ 		 * need to make this conditional.
+ 		 */
+ 		iov_iter_restore(iter, state);
+ 		iovec = NULL;
+ 	} else {
+ 		ret = io_import_iovec(READ, req, &iovec, iter, !force_nonblock);
+ 		if (ret < 0)
+ 			return ret;
+ 		state = &__state;
+ 		iov_iter_save_state(iter, state);
+ 	}
+ 	req->result = iov_iter_count(iter);
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  
  	/* Ensure we clear previously set non-block flag */
  	if (!force_nonblock)
@@@ -3436,15 -3472,17 +3480,23 @@@
  	else
  		kiocb->ki_flags |= IOCB_NOWAIT;
  
 +
  	/* If the file doesn't support async, just async punt */
 -	if (force_nonblock && !io_file_supports_nowait(req, READ)) {
 -		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 -		return ret ?: -EAGAIN;
 -	}
 +	no_async = force_nonblock && !io_file_supports_async(req->file, READ);
 +	if (no_async)
 +		goto copy_iov;
  
++<<<<<<< HEAD
 +	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), io_size);
 +	if (unlikely(ret))
 +		goto out_free;
++=======
+ 	ret = rw_verify_area(READ, req->file, io_kiocb_ppos(kiocb), req->result);
+ 	if (unlikely(ret)) {
+ 		kfree(iovec);
+ 		return ret;
+ 	}
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  
  	ret = io_iter_do_read(req, iter);
  
@@@ -3457,68 -3491,78 +3509,133 @@@
  		/* IOPOLL retry should happen for io-wq threads */
  		if (!force_nonblock && !(req->ctx->flags & IORING_SETUP_IOPOLL))
  			goto done;
 -		/* no retry on NONBLOCK nor RWF_NOWAIT */
 -		if (req->flags & REQ_F_NOWAIT)
 +		/* no retry on NONBLOCK marked file */
 +		if (req->file->f_flags & O_NONBLOCK)
  			goto done;
++<<<<<<< HEAD
 +		/* some cases will consume bytes even on error returns */
 +		iov_iter_revert(iter, io_size - iov_iter_count(iter));
 +		ret = 0;
 +		goto copy_iov;
 +	} else if (ret < 0) {
 +		/* make sure -ERESTARTSYS -> -EINTR is done */
 +		goto done;
 +	}
 +
 +	/* read it all, or we did blocking attempt. no retry. */
 +	if (!iov_iter_count(iter) || !force_nonblock ||
 +	    (req->file->f_flags & O_NONBLOCK) || !(req->flags & REQ_F_ISREG))
 +		goto done;
++=======
+ 		ret = 0;
+ 	} else if (ret == -EIOCBQUEUED) {
+ 		goto out_free;
+ 	} else if (ret <= 0 || ret == req->result || !force_nonblock ||
+ 		   (req->flags & REQ_F_NOWAIT) || !need_read_all(req)) {
+ 		/* read all, failed, already did sync or don't want to retry */
+ 		goto done;
+ 	}
+ 
+ 	/*
+ 	 * Don't depend on the iter state matching what was consumed, or being
+ 	 * untouched in case of error. Restore it and we'll advance it
+ 	 * manually if we need to.
+ 	 */
+ 	iov_iter_restore(iter, state);
+ 
+ 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
+ 	if (ret2)
+ 		return ret2;
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  
 -	iovec = NULL;
 +	io_size -= ret;
 +copy_iov:
 +	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 +	if (ret2) {
 +		ret = ret2;
 +		goto out_free;
 +	}
 +	if (no_async)
 +		return -EAGAIN;
  	rw = req->async_data;
++<<<<<<< HEAD
 +	/* it's copied and will be cleaned with ->io */
 +	iovec = NULL;
 +	/* now use our persistent iterator, if we aren't already */
 +	iter = &rw->iter;
 +retry:
 +	rw->bytes_done += ret;
 +	/* if we can retry, do so with the callbacks armed */
 +	if (!io_rw_should_retry(req)) {
 +		kiocb->ki_flags &= ~IOCB_WAITQ;
 +		return -EAGAIN;
 +	}
 +
  	/*
 -	 * Now use our persistent iterator and state, if we aren't already.
 -	 * We've restored and mapped the iter to match.
 +	 * Now retry read with the IOCB_WAITQ parts set in the iocb. If we
 +	 * get -EIOCBQUEUED, then we'll get a notification when the desired
 +	 * page gets unlocked. We can also get a partial read here, and if we
 +	 * do, then just retry at the new offset.
  	 */
 -	if (iter != &rw->iter) {
 -		iter = &rw->iter;
 +	ret = io_iter_do_read(req, iter);
 +	if (ret == -EIOCBQUEUED) {
 +		ret = 0;
 +		goto out_free;
 +	} else if (ret > 0 && ret < io_size) {
 +		/* we got some bytes, but not all. retry. */
 +		kiocb->ki_flags &= ~IOCB_WAITQ;
 +		goto retry;
 +	}
++=======
++	/*
++	 * Now use our persistent iterator and state, if we aren't already.
++	 * We've restored and mapped the iter to match.
++	 */
++	if (iter != &rw->iter) {
++		iter = &rw->iter;
+ 		state = &rw->iter_state;
+ 	}
+ 
+ 	do {
+ 		/*
+ 		 * We end up here because of a partial read, either from
+ 		 * above or inside this loop. Advance the iter by the bytes
+ 		 * that were consumed.
+ 		 */
+ 		iov_iter_advance(iter, ret);
+ 		if (!iov_iter_count(iter))
+ 			break;
+ 		rw->bytes_done += ret;
+ 		iov_iter_save_state(iter, state);
+ 
+ 		/* if we can retry, do so with the callbacks armed */
+ 		if (!io_rw_should_retry(req)) {
+ 			kiocb->ki_flags &= ~IOCB_WAITQ;
+ 			return -EAGAIN;
+ 		}
+ 
+ 		/*
+ 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
+ 		 * we get -EIOCBQUEUED, then we'll get a notification when the
+ 		 * desired page gets unlocked. We can also get a partial read
+ 		 * here, and if we do, then just retry at the new offset.
+ 		 */
+ 		ret = io_iter_do_read(req, iter);
+ 		if (ret == -EIOCBQUEUED)
+ 			return 0;
+ 		/* we got some bytes, but not all. retry. */
+ 		kiocb->ki_flags &= ~IOCB_WAITQ;
+ 		iov_iter_restore(iter, state);
+ 	} while (ret > 0);
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  done:
 -	kiocb_done(kiocb, ret, issue_flags);
 +	kiocb_done(kiocb, ret, cs);
 +	ret = 0;
  out_free:
 -	/* it's faster to check here then delegate to kfree */
 +	/* it's reportedly faster than delegating the null check to kfree() */
  	if (iovec)
  		kfree(iovec);
 -	return 0;
 +	return ret;
  }
  
  static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@@ -3545,16 -3578,24 +3662,37 @@@ static int io_write(struct io_kiocb *re
  	struct kiocb *kiocb = &req->rw.kiocb;
  	struct iov_iter __iter, *iter = &__iter;
  	struct io_async_rw *rw = req->async_data;
++<<<<<<< HEAD
 +	ssize_t ret, ret2, io_size;
++=======
+ 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
+ 	struct iov_iter_state __state, *state;
+ 	ssize_t ret, ret2;
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  
 -	if (rw) {
 +	if (rw)
  		iter = &rw->iter;
++<<<<<<< HEAD
 +
 +	ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
 +	if (ret < 0)
 +		return ret;
 +	io_size = iov_iter_count(iter);
 +	req->result = io_size;
++=======
+ 		state = &rw->iter_state;
+ 		iov_iter_restore(iter, state);
+ 		iovec = NULL;
+ 	} else {
+ 		ret = io_import_iovec(WRITE, req, &iovec, iter, !force_nonblock);
+ 		if (ret < 0)
+ 			return ret;
+ 		state = &__state;
+ 		iov_iter_save_state(iter, state);
+ 	}
+ 	req->result = iov_iter_count(iter);
+ 	ret2 = 0;
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  
  	/* Ensure we clear previously set non-block flag */
  	if (!force_nonblock)
@@@ -3610,14 -3656,14 +3748,20 @@@
  		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
  			goto copy_iov;
  done:
 -		kiocb_done(kiocb, ret2, issue_flags);
 +		kiocb_done(kiocb, ret2, cs);
  	} else {
  copy_iov:
++<<<<<<< HEAD
 +		/* some cases will consume bytes even on error returns */
 +		iov_iter_revert(iter, io_size - iov_iter_count(iter));
++=======
+ 		iov_iter_restore(iter, state);
+ 		if (ret2 > 0)
+ 			iov_iter_advance(iter, ret2);
++>>>>>>> cd65869512ab5 (io_uring: use iov_iter state save/restore helpers)
  		ret = io_setup_async_rw(req, iovec, inline_vecs, iter, false);
 -		return ret ?: -EAGAIN;
 +		if (!ret)
 +			return -EAGAIN;
  	}
  out_free:
  	/* it's reportedly faster than delegating the null check to kfree() */

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
