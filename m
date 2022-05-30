Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 091C5537AD6
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 14:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiE3Mys (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 08:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236208AbiE3Myr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 08:54:47 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1239814AC
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 05:54:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEq6flO_1653915281;
Received: from 30.82.254.106(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEq6flO_1653915281)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 30 May 2022 20:54:42 +0800
Message-ID: <ce0427aa-291a-c42a-02c8-7e80ec978f1a@linux.alibaba.com>
Date:   Mon, 30 May 2022 20:54:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH] io_uring: let IORING_OP_FILES_UPDATE support to choose
 fixed file slots
Content-Language: en-US
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
References: <20220530124654.22349-1-xiaoguang.wang@linux.alibaba.com>
In-Reply-To: <20220530124654.22349-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.4 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

hi,

Forgot to add "Suggested-by: Hao Xu <howeyxu@tencent.com>". If this
patch can be merged directly, please kindly add this, thanks.

Regards,
Xiaoguang Wang
> One big issue with file registration feature is that it needs user
> space apps to maintain free slot info about io_uring's fixed file
> table, which really is a burden for development. Now since io_uring
> starts to choose free file slot for user space apps by using
> IORING_FILE_INDEX_ALLOC flag in accept or open operations, but they
> need app to uses direct accept or direct open, which as far as I know,
> some apps are not prepared to use direct accept or open yet.
>
> To support apps, who still need real fds, use registration feature
> easier, let IORING_OP_FILES_UPDATE support to choose fixed file slots,
> which will store picked fixed files slots in fd array and let cqe return
> the number of slots allocated.
>
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>  fs/io_uring.c                 | 85 +++++++++++++++++++++++++++++++++++--------
>  include/uapi/linux/io_uring.h |  1 +
>  2 files changed, 70 insertions(+), 16 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 6d91148e9679..58514b8048da 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -574,6 +574,7 @@ struct io_close {
>  	struct file			*file;
>  	int				fd;
>  	u32				file_slot;
> +	u32				flags;
>  };
>  
>  struct io_timeout_data {
> @@ -1366,7 +1367,9 @@ static int io_req_prep_async(struct io_kiocb *req);
>  
>  static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>  				 unsigned int issue_flags, u32 slot_index);
> -static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
> +static int __io_close_fixed(struct io_kiocb *req, unsigned int issue_flags,
> +			    unsigned int offset);
> +static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
>  
>  static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
>  static void io_eventfd_signal(struct io_ring_ctx *ctx);
> @@ -5945,16 +5948,20 @@ static int io_statx(struct io_kiocb *req, unsigned int issue_flags)
>  	return 0;
>  }
>  
> +#define IORING_CLOSE_FD_AND_FILE_SLOT 1
> +
>  static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  {
> -	if (sqe->off || sqe->addr || sqe->len || sqe->rw_flags || sqe->buf_index)
> +	if (sqe->off || sqe->addr || sqe->len || sqe->buf_index)
>  		return -EINVAL;
>  	if (req->flags & REQ_F_FIXED_FILE)
>  		return -EBADF;
>  
>  	req->close.fd = READ_ONCE(sqe->fd);
>  	req->close.file_slot = READ_ONCE(sqe->file_index);
> -	if (req->close.file_slot && req->close.fd)
> +	req->close.flags = READ_ONCE(sqe->close_flags);
> +	if (!(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT) &&
> +	    req->close.file_slot && req->close.fd)
>  		return -EINVAL;
>  
>  	return 0;
> @@ -5970,7 +5977,8 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags)
>  
>  	if (req->close.file_slot) {
>  		ret = io_close_fixed(req, issue_flags);
> -		goto err;
> +		if (ret || !(req->close.flags & IORING_CLOSE_FD_AND_FILE_SLOT))
> +			goto err;
>  	}
>  
>  	spin_lock(&files->file_lock);
> @@ -8003,23 +8011,63 @@ static int io_files_update_prep(struct io_kiocb *req,
>  	return 0;
>  }
>  
> +static int io_files_update_with_index_alloc(struct io_kiocb *req,
> +					    unsigned int issue_flags)
> +{
> +	__s32 __user *fds = u64_to_user_ptr(req->rsrc_update.arg);
> +	struct file *file;
> +	unsigned int done, nr_fds = req->rsrc_update.nr_args;
> +	int ret, fd;
> +
> +	for (done = 0; done < nr_fds; done++) {
> +		if (copy_from_user(&fd, &fds[done], sizeof(fd))) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		file = fget(fd);
> +		if (!file) {
> +			ret = -EBADF;
> +			goto out;
> +		}
> +		ret = io_fixed_fd_install(req, issue_flags, file,
> +					  IORING_FILE_INDEX_ALLOC);
> +		if (ret < 0)
> +			goto out;
> +		if (copy_to_user(&fds[done], &ret, sizeof(ret))) {
> +			ret = -EFAULT;
> +			__io_close_fixed(req, issue_flags, ret);
> +			break;
> +		}
> +	}
> +
> +out:
> +	if (done)
> +		return done;
> +	return ret;
> +}
> +
>  static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
>  {
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_uring_rsrc_update2 up;
>  	int ret;
>  
> -	up.offset = req->rsrc_update.offset;
> -	up.data = req->rsrc_update.arg;
> -	up.nr = 0;
> -	up.tags = 0;
> -	up.resv = 0;
> -	up.resv2 = 0;
> +	if (req->rsrc_update.offset == IORING_FILE_INDEX_ALLOC) {
> +		ret = io_files_update_with_index_alloc(req, issue_flags);
> +	} else {
> +		up.offset = req->rsrc_update.offset;
> +		up.data = req->rsrc_update.arg;
> +		up.nr = 0;
> +		up.tags = 0;
> +		up.resv = 0;
> +		up.resv2 = 0;
>  
> -	io_ring_submit_lock(ctx, issue_flags);
> -	ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
> -					&up, req->rsrc_update.nr_args);
> -	io_ring_submit_unlock(ctx, issue_flags);
> +		io_ring_submit_lock(ctx, issue_flags);
> +		ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
> +				&up, req->rsrc_update.nr_args);
> +		io_ring_submit_unlock(ctx, issue_flags);
> +	}
>  
>  	if (ret < 0)
>  		req_set_fail(req);
> @@ -10183,9 +10231,9 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>  	return ret;
>  }
>  
> -static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
> +static int __io_close_fixed(struct io_kiocb *req, unsigned int issue_flags,
> +			    unsigned int offset)
>  {
> -	unsigned int offset = req->close.file_slot - 1;
>  	struct io_ring_ctx *ctx = req->ctx;
>  	struct io_fixed_file *file_slot;
>  	struct file *file;
> @@ -10222,6 +10270,11 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
>  	return ret;
>  }
>  
> +static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	return __io_close_fixed(req, issue_flags, req->close.file_slot - 1);
> +}
> +
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>  				 struct io_uring_rsrc_update2 *up,
>  				 unsigned nr_args)
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 53e7dae92e42..e347b3fea4e4 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -47,6 +47,7 @@ struct io_uring_sqe {
>  		__u32		unlink_flags;
>  		__u32		hardlink_flags;
>  		__u32		xattr_flags;
> +		__u32		close_flags;
>  	};
>  	__u64	user_data;	/* data to be passed back at completion time */
>  	/* pack this to avoid bogus arm OABI complaints */

