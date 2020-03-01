Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58EDC174FE9
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 22:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgCAVcL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 16:32:11 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42356 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgCAVcL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 16:32:11 -0500
Received: by mail-wr1-f66.google.com with SMTP id z11so1286539wro.9;
        Sun, 01 Mar 2020 13:32:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Kp4R6mhpQhx7AvlCGwxnG2FPxNzv0GqxY9q7H0wp4f4=;
        b=vNJF20kaf80tRa73/dmdUBvwXgZ7q9T4+WNceacQk7JVVOhZ9nevA2zdu3wQyQE3YJ
         HIQJuxMTA3rGvBK8qBdwNqArFBivhuj3C0hxYQ86kmO0EBiLfapOcOK+Uc3o/CAyFdo2
         lUEfFzq/s3+NdNPGPa401G55iRRAOs28N+9zd33rpntK+GXEjuxkPiLSNxDQcPaPL5ug
         SHNtF8/5GMlphIEi/jkHvHMTufpPCvjIziE1ax7+AThwCsbRTaTuDU9R8BtagKqxz/J9
         IAD+Ry0DLD2ocAW18n9KJdvRgybuy2grXlBWwkHvD+pEWUZ5c5C5MYM8zGmw4o2Ju+xD
         /h0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Kp4R6mhpQhx7AvlCGwxnG2FPxNzv0GqxY9q7H0wp4f4=;
        b=qbj6Unvn/Yv6iAT11s2gWoznRuVyQlPtxDGTXw+yQIqb1nx0PITnapQj3lytdJHmrT
         NEgScQLggjI2xOX9++foTuYJYuFJ7LFpFUQ3SyQpkfRcSgyz6ord4gHZOMXe7KwxypmA
         ZgBZguw49Q4/wCP0ZE37y4MHCvXmrXVOBqZ/+nP3LLDxf+3E9ACs/DZXC3czTdMXH+if
         j0aYey5rXKWTd7QsBluxGNjnwhBc1bHFwgW31mXhA5WvVWUf0OQdwS7s2NHkfnngh0kN
         m4qi0Miihxo0kwplhvV/E8II92sjRbrKJBIsO22BnTYpqAj+y+uR8xwgMk5d4E0VgdWV
         Ry7w==
X-Gm-Message-State: APjAAAUdhxdoyWEtu8VN+zz8vku6ceaecicbmbyIIsv6/Fpa+3rAllWn
        xdIeCbVt3C5VMjVGRBemo+2iFKc6
X-Google-Smtp-Source: APXvYqzd6K0JxsGe7Nh8jGK+WVCC0k43VSO3rxwZeCozwvHddnf0LT08JoXvidnu3BlUutQqFxXi7Q==
X-Received: by 2002:a5d:528e:: with SMTP id c14mr18278512wrv.308.1583098327700;
        Sun, 01 Mar 2020 13:32:07 -0800 (PST)
Received: from [192.168.43.139] ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id r5sm23328975wrt.43.2020.03.01.13.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Mar 2020 13:32:07 -0800 (PST)
Subject: Re: [PATCH 5/9] io_uring: get next req on subm ref drop
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1583078091.git.asml.silence@gmail.com>
 <d5e0c69a5b0fdf7e72a8137949818dc59465d40f.1583078091.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <8285a4ee-c2cc-a194-7cfd-9108729f3e3b@gmail.com>
Date:   Mon, 2 Mar 2020 00:31:15 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <d5e0c69a5b0fdf7e72a8137949818dc59465d40f.1583078091.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/03/2020 19:18, Pavel Begunkov wrote:
> Get next request when dropping the submission reference. However, if
> there is an asynchronous counterpart (i.e. read/write, timeout, etc),
> that would be dangerous to do, so ignore them using new
> REQ_F_DONT_STEAL_NEXT flag.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 121 ++++++++++++++++++++++++++------------------------
>  1 file changed, 62 insertions(+), 59 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index daf7c2095523..d456b0ff6835 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -488,6 +488,7 @@ enum {
>  	REQ_F_NEED_CLEANUP_BIT,
>  	REQ_F_OVERFLOW_BIT,
>  	REQ_F_POLLED_BIT,
> +	REQ_F_DONT_STEAL_NEXT_BIT,
>  };
>  
>  enum {
> @@ -532,6 +533,8 @@ enum {
>  	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
>  	/* already went through poll handler */
>  	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
> +	/* don't try to get next req, it's async and racy */
> +	REQ_F_DONT_STEAL_NEXT	= BIT(REQ_F_DONT_STEAL_NEXT_BIT),
>  };
>  
>  struct async_poll {
> @@ -1218,6 +1221,27 @@ static void io_cqring_add_event(struct io_kiocb *req, long res)
>  	io_cqring_ev_posted(ctx);
>  }
>  
> +static void io_link_work_cb(struct io_wq_work **workptr)
> +{
> +	struct io_wq_work *work = *workptr;
> +	struct io_kiocb *link = work->data;
> +
> +	io_queue_linked_timeout(link);
> +	io_wq_submit_work(workptr);
> +}
> +
> +static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
> +{
> +	struct io_kiocb *link;
> +
> +	*workptr = &nxt->work;
> +	link = io_prep_linked_timeout(nxt);
> +	if (link) {
> +		nxt->work.func = io_link_work_cb;
> +		nxt->work.data = link;
> +	}
> +}
> +
>  static inline bool io_is_fallback_req(struct io_kiocb *req)
>  {
>  	return req == (struct io_kiocb *)
> @@ -1518,17 +1542,28 @@ static void io_free_req(struct io_kiocb *req)
>  		io_queue_async_work(nxt);
>  }
>  
> -/*
> - * Drop reference to request, return next in chain (if there is one) if this
> - * was the last reference to this request.
> - */
> -__attribute__((nonnull))
> -static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
> +__attribute__((warn_unused_result))
> +static struct io_kiocb *io_put_req_submission(struct io_kiocb *req)
>  {
> -	if (refcount_dec_and_test(&req->refs)) {
> -		io_req_find_next(req, nxtptr);
> +	bool last_ref = refcount_dec_and_test(&req->refs);
> +	struct io_kiocb *nxt = NULL;
> +
> +	if (!(req->flags & REQ_F_DONT_STEAL_NEXT) || last_ref)

This is a bit racy, need to take @nxt first and then do atomic.
The fix is trivial, so makes sense to review the rest.

> +		io_req_find_next(req, &nxt);
> +	if (last_ref)
>  		__io_free_req(req);
> -	}
> +
> +	return nxt;
> +}
> +
> +static void io_put_req_async_submission(struct io_kiocb *req,
> +					struct io_wq_work **workptr)
> +{
> +	static struct io_kiocb *nxt;
> +
> +	nxt = io_put_req_submission(req);
> +	if (nxt)
> +		io_wq_assign_next(workptr, nxt);
>  }
>  
>  static void io_put_req(struct io_kiocb *req)
> @@ -1979,8 +2014,11 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  
>  static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
>  {
> +	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
> +
>  	switch (ret) {
>  	case -EIOCBQUEUED:
> +		req->flags |= REQ_F_DONT_STEAL_NEXT;
>  		break;
>  	case -ERESTARTSYS:
>  	case -ERESTARTNOINTR:
> @@ -2526,6 +2564,7 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	if (unlikely(req->sync.flags & ~IORING_FSYNC_DATASYNC))
>  		return -EINVAL;
>  
> +	req->flags |= REQ_F_DONT_STEAL_NEXT;
>  	req->sync.off = READ_ONCE(sqe->off);
>  	req->sync.len = READ_ONCE(sqe->len);
>  	return 0;
> @@ -2543,27 +2582,6 @@ static bool io_req_cancelled(struct io_kiocb *req)
>  	return false;
>  }
>  
> -static void io_link_work_cb(struct io_wq_work **workptr)
> -{
> -	struct io_wq_work *work = *workptr;
> -	struct io_kiocb *link = work->data;
> -
> -	io_queue_linked_timeout(link);
> -	io_wq_submit_work(workptr);
> -}
> -
> -static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
> -{
> -	struct io_kiocb *link;
> -
> -	*workptr = &nxt->work;
> -	link = io_prep_linked_timeout(nxt);
> -	if (link) {
> -		nxt->work.func = io_link_work_cb;
> -		nxt->work.data = link;
> -	}
> -}
> -
>  static void __io_fsync(struct io_kiocb *req)
>  {
>  	loff_t end = req->sync.off + req->sync.len;
> @@ -2581,14 +2599,11 @@ static void __io_fsync(struct io_kiocb *req)
>  static void io_fsync_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_fsync(req);
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  
>  static int io_fsync(struct io_kiocb *req, bool force_nonblock)
> @@ -2617,14 +2632,11 @@ static void __io_fallocate(struct io_kiocb *req)
>  static void io_fallocate_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_fallocate(req);
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  
>  static int io_fallocate_prep(struct io_kiocb *req,
> @@ -2988,13 +3000,10 @@ static void __io_close_finish(struct io_kiocb *req)
>  static void io_close_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	/* not cancellable, don't do io_req_cancelled() */
>  	__io_close_finish(req);
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  
>  static int io_close(struct io_kiocb *req, bool force_nonblock)
> @@ -3016,6 +3025,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
>  		 */
>  		io_queue_async_work(req);
>  		/* submission ref will be dropped, take it for async */
> +		req->flags |= REQ_F_DONT_STEAL_NEXT;
>  		refcount_inc_not_zero(&req->refs);
>  		return 0;
>  	}
> @@ -3062,14 +3072,11 @@ static void __io_sync_file_range(struct io_kiocb *req)
>  static void io_sync_file_range_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_sync_file_range(req);
> -	io_put_req(req); /* put submission ref */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  
>  static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
> @@ -3435,14 +3442,11 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
>  static void io_accept_finish(struct io_wq_work **workptr)
>  {
>  	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  
>  	if (io_req_cancelled(req))
>  		return;
>  	__io_accept(req, false);
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  #endif
>  
> @@ -3859,9 +3863,10 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
>  	hash_del(&req->hash_node);
>  	io_poll_complete(req, req->result, 0);
>  	req->flags |= REQ_F_COMP_LOCKED;
> -	io_put_req_find_next(req, nxt);
>  	spin_unlock_irq(&ctx->completion_lock);
>  
> +	req->flags &= ~REQ_F_DONT_STEAL_NEXT;
> +	*nxt = io_put_req_submission(req);
>  	io_cqring_ev_posted(ctx);
>  }
>  
> @@ -3944,6 +3949,8 @@ static int io_poll_add(struct io_kiocb *req)
>  		io_cqring_ev_posted(ctx);
>  		io_put_req(req);
>  	}
> +
> +	req->flags |= REQ_F_DONT_STEAL_NEXT;
>  	return ipt.error;
>  }
>  
> @@ -4066,6 +4073,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>  	if (flags & ~IORING_TIMEOUT_ABS)
>  		return -EINVAL;
>  
> +	req->flags |= REQ_F_DONT_STEAL_NEXT;
>  	req->timeout.count = READ_ONCE(sqe->off);
>  
>  	if (!req->io && io_alloc_async_ctx(req))
> @@ -4680,7 +4688,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>  {
>  	struct io_wq_work *work = *workptr;
>  	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
> -	struct io_kiocb *nxt = NULL;
>  	int ret = 0;
>  
>  	/* if NO_CANCEL is set, we must still run the work */
> @@ -4709,9 +4716,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
>  		io_put_req(req);
>  	}
>  
> -	io_put_req(req); /* drop submission reference */
> -	if (nxt)
> -		io_wq_assign_next(workptr, nxt);
> +	io_put_req_async_submission(req, workptr);
>  }
>  
>  static int io_req_needs_file(struct io_kiocb *req, int fd)
> @@ -4935,10 +4940,6 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  	}
>  
>  err:
> -	nxt = NULL;
> -	/* drop submission reference */
> -	io_put_req_find_next(req, &nxt);
> -
>  	if (linked_timeout) {
>  		if (!ret)
>  			io_queue_linked_timeout(linked_timeout);
> @@ -4952,6 +4953,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		req_set_fail_links(req);
>  		io_put_req(req);
>  	}
> +
> +	nxt = io_put_req_submission(req);
>  	if (nxt) {
>  		req = nxt;
>  
> 

-- 
Pavel Begunkov
