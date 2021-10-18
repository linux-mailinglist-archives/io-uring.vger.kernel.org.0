Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42E7431026
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 08:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhJRGJD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 02:09:03 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:44596 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhJRGJD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 02:09:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UsXHN3K_1634537210;
Received: from B-25KNML85-0107.local(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsXHN3K_1634537210)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 14:06:51 +0800
Subject: Re: [PATCH 4/8] io_uring: encapsulate rw state
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1634144845.git.asml.silence@gmail.com>
 <e8245ffcb568b228a009ec1eb79c993c813679f1.1634144845.git.asml.silence@gmail.com>
From:   Hao Xu <haoxu@linux.alibaba.com>
Message-ID: <16b49917-5251-8abb-e26a-6b06c54a9a47@linux.alibaba.com>
Date:   Mon, 18 Oct 2021 14:06:50 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <e8245ffcb568b228a009ec1eb79c993c813679f1.1634144845.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2021/10/14 下午11:10, Pavel Begunkov 写道:
> Add a new struct io_rw_state storing all iov related bits: fast iov,
> iterator and iterator state. Not much changes here, simply convert
> struct io_async_rw to use it.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   fs/io_uring.c | 42 +++++++++++++++++++++++-------------------
>   1 file changed, 23 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 2f193893cf1b..3447243805d9 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -693,11 +693,15 @@ struct io_async_msghdr {
>   	struct sockaddr_storage		addr;
>   };
>   
> -struct io_async_rw {
> +struct io_rw_state {
>   	struct iovec			fast_iov[UIO_FASTIOV];
> -	const struct iovec		*free_iovec;
>   	struct iov_iter			iter;
>   	struct iov_iter_state		iter_state;
> +};
> +
> +struct io_async_rw {
> +	struct io_rw_state		s;
This name seems a little bit too simple, when a reader reads the code, 
they may be confused until they see this definition.
> +	const struct iovec		*free_iovec;
>   	size_t				bytes_done;
>   	struct wait_page_queue		wpq;
>   };
> @@ -2550,7 +2554,7 @@ static bool io_resubmit_prep(struct io_kiocb *req)
>   
>   	if (!req_has_async_data(req))
>   		return !io_req_prep_async(req);
> -	iov_iter_restore(&rw->iter, &rw->iter_state);
> +	iov_iter_restore(&rw->s.iter, &rw->s.iter_state);
>   	return true;
>   }
>   
> @@ -3221,7 +3225,7 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
>   {
>   	struct io_async_rw *rw = req->async_data;
>   
> -	memcpy(&rw->iter, iter, sizeof(*iter));
> +	memcpy(&rw->s.iter, iter, sizeof(*iter));
>   	rw->free_iovec = iovec;
>   	rw->bytes_done = 0;
>   	/* can only be fixed buffers, no need to do anything */
> @@ -3230,13 +3234,13 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
>   	if (!iovec) {
>   		unsigned iov_off = 0;
>   
> -		rw->iter.iov = rw->fast_iov;
> +		rw->s.iter.iov = rw->s.fast_iov;
>   		if (iter->iov != fast_iov) {
>   			iov_off = iter->iov - fast_iov;
> -			rw->iter.iov += iov_off;
> +			rw->s.iter.iov += iov_off;
>   		}
> -		if (rw->fast_iov != fast_iov)
> -			memcpy(rw->fast_iov + iov_off, fast_iov + iov_off,
> +		if (rw->s.fast_iov != fast_iov)
> +			memcpy(rw->s.fast_iov + iov_off, fast_iov + iov_off,
>   			       sizeof(struct iovec) * iter->nr_segs);
>   	} else {
>   		req->flags |= REQ_F_NEED_CLEANUP;
> @@ -3271,7 +3275,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
>   		io_req_map_rw(req, iovec, fast_iov, iter);
>   		iorw = req->async_data;
>   		/* we've copied and mapped the iter, ensure state is saved */
> -		iov_iter_save_state(&iorw->iter, &iorw->iter_state);
> +		iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
>   	}
>   	return 0;
>   }
> @@ -3279,10 +3283,10 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
>   static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
>   {
>   	struct io_async_rw *iorw = req->async_data;
> -	struct iovec *iov = iorw->fast_iov;
> +	struct iovec *iov = iorw->s.fast_iov;
>   	int ret;
>   
> -	ret = io_import_iovec(rw, req, &iov, &iorw->iter, false);
> +	ret = io_import_iovec(rw, req, &iov, &iorw->s.iter, false);
>   	if (unlikely(ret < 0))
>   		return ret;
>   
> @@ -3290,7 +3294,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
>   	iorw->free_iovec = iov;
>   	if (iov)
>   		req->flags |= REQ_F_NEED_CLEANUP;
> -	iov_iter_save_state(&iorw->iter, &iorw->iter_state);
> +	iov_iter_save_state(&iorw->s.iter, &iorw->s.iter_state);
>   	return 0;
>   }
>   
> @@ -3400,8 +3404,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   
>   	if (req_has_async_data(req)) {
>   		rw = req->async_data;
> -		iter = &rw->iter;
> -		state = &rw->iter_state;
> +		iter = &rw->s.iter;
> +		state = &rw->s.iter_state;
>   		/*
>   		 * We come here from an earlier attempt, restore our state to
>   		 * match in case it doesn't. It's cheap enough that we don't
> @@ -3472,9 +3476,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
>   	 * Now use our persistent iterator and state, if we aren't already.
>   	 * We've restored and mapped the iter to match.
>   	 */
> -	if (iter != &rw->iter) {
> -		iter = &rw->iter;
> -		state = &rw->iter_state;
> +	if (iter != &rw->s.iter) {
> +		iter = &rw->s.iter;
> +		state = &rw->s.iter_state;
>   	}
>   
>   	do {
> @@ -3536,8 +3540,8 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
>   
>   	if (req_has_async_data(req)) {
>   		rw = req->async_data;
> -		iter = &rw->iter;
> -		state = &rw->iter_state;
> +		iter = &rw->s.iter;
> +		state = &rw->s.iter_state;
>   		iov_iter_restore(iter, state);
>   		iovec = NULL;
>   	} else {
> 

