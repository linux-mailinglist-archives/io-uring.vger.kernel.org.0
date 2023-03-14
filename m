Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201266B8EA4
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 10:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCNJ0Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 05:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCNJ0O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 05:26:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32A81A94E;
        Tue, 14 Mar 2023 02:26:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D855B8169E;
        Tue, 14 Mar 2023 09:26:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58679C433D2;
        Tue, 14 Mar 2023 09:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678785970;
        bh=wTDeNn+6aK6eHACD8Gd4/qEwlypFOHn6sZjJmY6WCqs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V6q5+IyaKh/t8LF59irhOnhn2f5ejLq6ZjF+9RBDgUPBAPJufLT6JZUeqGKpxR6oM
         yPsZQ94e2TZCkCyfjWYV0teNc+R6LxXdvjqPIqc8YJNNf/7WOJ32kgcFmm2ewtIbOd
         0bV8om7B86HjF/mL1Q2r8bOEYeNwAKjO2ZyaCVyJpZw+PqSy+OmirS/o9844j3K4or
         M3GfWvXkivm7z53plsqVzHevLplxT27HN9ZsuPjMMw1p8D2MfPDUh7MBBLD6ii9sjU
         P5SdpApPJr7mQwSaMnhZvxzOm4XoqycYm7Ul+q9Ulg7bwuJNmNHcy4aMx1v1kyVAMv
         eOHPLsPjEUgqQ==
Date:   Tue, 14 Mar 2023 10:26:05 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] pipe: enable handling of IOCB_NOWAIT
Message-ID: <20230314092605.odhpxvlalqgb27gv@wittgenstein>
References: <20230308031033.155717-1-axboe@kernel.dk>
 <20230308031033.155717-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230308031033.155717-3-axboe@kernel.dk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 07, 2023 at 08:10:32PM -0700, Jens Axboe wrote:
> In preparation for enabling FMODE_NOWAIT for pipes, ensure that the read
> and write path handle it correctly. This includes the pipe locking,
> page allocation for writes, and confirming pipe buffers.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  fs/pipe.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/pipe.c b/fs/pipe.c
> index 340f253913a2..10366a6cb5b6 100644
> --- a/fs/pipe.c
> +++ b/fs/pipe.c
> @@ -108,6 +108,16 @@ static inline void __pipe_unlock(struct pipe_inode_info *pipe)
>  	mutex_unlock(&pipe->mutex);
>  }
>  
> +static inline bool __pipe_trylock(struct pipe_inode_info *pipe, bool nonblock)
> +{
> +	if (!nonblock) {
> +		__pipe_lock(pipe);
> +		return true;
> +	}
> +
> +	return mutex_trylock(&pipe->mutex);
> +}
> +
>  void pipe_double_lock(struct pipe_inode_info *pipe1,
>  		      struct pipe_inode_info *pipe2)
>  {
> @@ -234,6 +244,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>  	struct file *filp = iocb->ki_filp;
>  	struct pipe_inode_info *pipe = filp->private_data;
>  	bool was_full, wake_next_reader = false;
> +	const bool nonblock = iocb->ki_flags & IOCB_NOWAIT;
>  	ssize_t ret;
>  
>  	/* Null read succeeds. */
> @@ -241,7 +252,8 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>  		return 0;
>  
>  	ret = 0;
> -	__pipe_lock(pipe);
> +	if (!__pipe_trylock(pipe, nonblock))
> +		return -EAGAIN;
>  
>  	/*
>  	 * We only wake up writers if the pipe was full when we started
> @@ -297,7 +309,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>  				chars = total_len;
>  			}
>  
> -			error = pipe_buf_confirm(pipe, buf, false);
> +			error = pipe_buf_confirm(pipe, buf, nonblock);
>  			if (error) {
>  				if (!ret)
>  					ret = error;
> @@ -342,7 +354,7 @@ pipe_read(struct kiocb *iocb, struct iov_iter *to)
>  			break;
>  		if (ret)
>  			break;
> -		if (filp->f_flags & O_NONBLOCK) {
> +		if (filp->f_flags & O_NONBLOCK || nonblock) {
>  			ret = -EAGAIN;
>  			break;
>  		}
> @@ -423,12 +435,14 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>  	ssize_t chars;
>  	bool was_empty = false;
>  	bool wake_next_writer = false;
> +	const bool nonblock = iocb->ki_flags & IOCB_NOWAIT;
>  
>  	/* Null write succeeds. */
>  	if (unlikely(total_len == 0))
>  		return 0;
>  
> -	__pipe_lock(pipe);
> +	if (!__pipe_trylock(pipe, nonblock))
> +		return -EAGAIN;
>  
>  	if (!pipe->readers) {
>  		send_sig(SIGPIPE, current, 0);
> @@ -461,7 +475,7 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>  
>  		if ((buf->flags & PIPE_BUF_FLAG_CAN_MERGE) &&
>  		    offset + chars <= PAGE_SIZE) {
> -			ret = pipe_buf_confirm(pipe, buf, false);
> +			ret = pipe_buf_confirm(pipe, buf, nonblock);
>  			if (ret)
>  				goto out;
>  
> @@ -493,9 +507,13 @@ pipe_write(struct kiocb *iocb, struct iov_iter *from)
>  			int copied;
>  
>  			if (!page) {
> -				page = alloc_page(GFP_HIGHUSER | __GFP_ACCOUNT);
> +				gfp_t gfp = __GFP_HIGHMEM | __GFP_ACCOUNT;
> +
> +				if (!nonblock)
> +					gfp |= GFP_USER;

Just for my education: Does this encode the assumpation that the
non-blocking code can only be reached from io_uring and thus GFP_USER
can be dropped for that case? IOW, if there's other code that could in
the future reach the non blocking condition would this still be correct?

> +				page = alloc_page(gfp);
>  				if (unlikely(!page)) {
> -					ret = ret ? : -ENOMEM;
> +					ret = ret ? : nonblock ? -EAGAIN : -ENOMEM;

Hm, could we try and avoid the nested "?:?:" please. Imho, that's easy
to misparse. Idk, doesn't need to be exactly that code but sm like:

   				if (!nonblock) {
   					gfp |= GFP_USER;
					ret = -EAGAIN;
				} else {
					ret = -ENOMEM;
				}

   				page = alloc_page(gfp);
   				if (unlikely(!page))
					break;
				else
					ret = 0;
   				pipe->tmp_page = page;

or sm else.
