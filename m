Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5342A28C7
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 12:10:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgKBLKj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 06:10:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgKBLKj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 06:10:39 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8ACC0617A6;
        Mon,  2 Nov 2020 03:10:38 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id k18so9082378wmj.5;
        Mon, 02 Nov 2020 03:10:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sxjcCP6si6Tl9h62sUyxPBfkzd5l3RzDnZNrpaInHVU=;
        b=I+iDSdKE7GBoS8mnD3WM/L5lBFqGcpYi5dttlTqFs9EpW6KppgD/jMiSe5SH6/oSeK
         9cdqZ/4XBXKWbETyMpp1gNy7LbjWk+GuCzARE7gieEDH1KsROOGhwk95ghNu3a//BQVP
         N9Jv0x5EgGDcqZDagnqwOoVvBgiNUF5TURqykJe6I7a/EtLgVd4wZ2krNv/ldMZBfnPr
         TrH+jefo7BtT4gP8VZSk6eHuVq24lF3lxn8K/5nZA6LC0HIN5/IMCxE+bwD3Y2REWz7M
         BaqY5p/LDpkHuWe7vtPYw866yW4hVPjXcPa47ZL0/IfHBGAShJeK4s8FFxPaFa0wtxSR
         6ixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=sxjcCP6si6Tl9h62sUyxPBfkzd5l3RzDnZNrpaInHVU=;
        b=HjAEicQf3hFFjhlQ1AXnXMy5AdiL2yN7MRSY4y6pbZXOhKLKeLfEQQfm4RpnYahZp5
         RmUOVQAnNYt+4hQECWxGixh1fMRn8fmPkTnCYAsee7UhHagRzqptg/SPFE4eL4wCEvuJ
         j4zmVf20U8i/N4m+j2t6lyZnIvmY3U4a4YAbldALb3SU88JSlHRJEa6xtFiLLeP37YTg
         ICwaELHnpCJYHky7wTioEP0kWjwxc06G3RsM6qMmzGag6OY/A15GWZAMVrckHx8zjkhe
         nkJr136ZKo3tsRsg5CZmdkolNZMZ8liyTr3IoVxEpJl3fmf3WKrRGA55FoqMmO8df2EM
         IUzw==
X-Gm-Message-State: AOAM533bfCBusEUdxKNiFk6b2yyXuG5rgH1vs+8zzqJU4VJOXapg/XFo
        rS6mPNNn28V3jGjrKDLlp3pMvevHgA0=
X-Google-Smtp-Source: ABdhPJxGq6upZESzs4tu8Ca1DZIfP+RHgRUq/HREdloRIM9x6gW9FLEz1kumV3F61pFJ3AZcxUBO5w==
X-Received: by 2002:a1c:e087:: with SMTP id x129mr16744444wmg.2.1604315437439;
        Mon, 02 Nov 2020 03:10:37 -0800 (PST)
Received: from [192.168.1.203] (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id r18sm23873953wrj.50.2020.11.02.03.10.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 03:10:36 -0800 (PST)
Subject: Re: [PATCH RFC] io_uring: support ioctl
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604303041-184595-1-git-send-email-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <a328aab5-4005-8fe9-9cea-0913f5bab269@gmail.com>
Date:   Mon, 2 Nov 2020 11:07:36 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1604303041-184595-1-git-send-email-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/11/2020 07:44, Hao Xu wrote:
> Async ioctl is necessary for some scenarios like nonblocking
> single-threaded model

Once I fell for it myself, see Jann explained why that's a bad idea.
https://lore.kernel.org/io-uring/CAG48ez0N_b+kjbddhHe+BUvSnOSvpm1vdfQ9cv+cgTLuCMXqug@mail.gmail.com/

> 
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
> I've written corresponding liburing tests for this feature. Currently
> just a simple test for BLKGETSIZE operation. I'll release it later soon
> when it gets better.
> 
>  fs/io_uring.c                 | 56 +++++++++++++++++++++++++++++++++++++++++++
>  fs/ioctl.c                    |  4 ++--
>  include/linux/fs.h            |  3 ++-
>  include/uapi/linux/io_uring.h |  1 +
>  4 files changed, 61 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b42dfa0243bf..c8ab6b6d2d70 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -539,6 +539,13 @@ struct io_statx {
>  	struct statx __user		*buffer;
>  };
>  
> +struct io_ioctl {
> +	struct file			*file;
> +	unsigned int                    fd;
> +	unsigned int                    cmd;
> +	unsigned long                   arg;
> +};
> +
>  struct io_completion {
>  	struct file			*file;
>  	struct list_head		list;
> @@ -665,6 +672,7 @@ struct io_kiocb {
>  		struct io_splice	splice;
>  		struct io_provide_buf	pbuf;
>  		struct io_statx		statx;
> +		struct io_ioctl         ioctl;
>  		/* use only after cleaning per-op data, see io_clean_op() */
>  		struct io_completion	compl;
>  	};
> @@ -932,6 +940,10 @@ struct io_op_def {
>  		.hash_reg_file		= 1,
>  		.unbound_nonreg_file	= 1,
>  	},
> +	[IORING_OP_IOCTL] = {
> +		.needs_file             = 1,
> +		.work_flags             = IO_WQ_WORK_MM | IO_WQ_WORK_FILES
> +	},
>  };
>  
>  enum io_mem_account {
> @@ -4819,6 +4831,45 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock,
>  }
>  #endif /* CONFIG_NET */
>  
> +static int io_ioctl_prep(struct io_kiocb *req,
> +			 const struct io_uring_sqe *sqe)
> +{
> +	if (sqe->ioprio || sqe->buf_index || sqe->rw_flags)
> +		return -EINVAL;
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +
> +	req->ioctl.fd = READ_ONCE(sqe->fd);
> +	req->ioctl.cmd = READ_ONCE(sqe->len);
> +	req->ioctl.arg = READ_ONCE(sqe->addr);
> +	return 0;
> +}
> +
> +static int io_ioctl(struct io_kiocb *req, bool force_nonblock)
> +{
> +	int ret;
> +
> +	if (force_nonblock)
> +		return -EAGAIN;
> +
> +	if (!req->file)
> +		return -EBADF;
> +
> +	ret = security_file_ioctl(req->file, req->ioctl.cmd, req->ioctl.arg);
> +	if (ret)
> +		goto out;
> +
> +	ret = do_vfs_ioctl(req->file, req->ioctl.fd, req->ioctl.cmd, req->ioctl.arg);
> +	if (ret == -ENOIOCTLCMD)
> +		ret = vfs_ioctl(req->file, req->ioctl.cmd, req->ioctl.arg);
> +
> +out:
> +	if (ret)
> +		req_set_fail_links(req);
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
>  struct io_poll_table {
>  	struct poll_table_struct pt;
>  	struct io_kiocb *req;
> @@ -5742,6 +5793,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		return io_remove_buffers_prep(req, sqe);
>  	case IORING_OP_TEE:
>  		return io_tee_prep(req, sqe);
> +	case IORING_OP_IOCTL:
> +		return io_ioctl_prep(req, sqe);
>  	}
>  
>  	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -5985,6 +6038,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
>  	case IORING_OP_TEE:
>  		ret = io_tee(req, force_nonblock);
>  		break;
> +	case IORING_OP_IOCTL:
> +		ret = io_ioctl(req, force_nonblock);
> +		break;
>  	default:
>  		ret = -EINVAL;
>  		break;
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 4e6cc0a7d69c..4ff2eb0d8ee0 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -664,8 +664,8 @@ static int ioctl_file_dedupe_range(struct file *file,
>   * When you add any new common ioctls to the switches above and below,
>   * please ensure they have compatible arguments in compat mode.
>   */
> -static int do_vfs_ioctl(struct file *filp, unsigned int fd,
> -			unsigned int cmd, unsigned long arg)
> +int do_vfs_ioctl(struct file *filp, unsigned int fd,
> +		unsigned int cmd, unsigned long arg)
>  {
>  	void __user *argp = (void __user *)arg;
>  	struct inode *inode = file_inode(filp);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0bd126418bb6..ad62aa6f6136 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1732,7 +1732,8 @@ int vfs_mkobj(struct dentry *, umode_t,
>  int vfs_utimes(const struct path *path, struct timespec64 *times);
>  
>  extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
> -
> +extern int do_vfs_ioctl(struct file *filp, unsigned int fd,
> +			unsigned int cmd, unsigned long arg);
>  #ifdef CONFIG_COMPAT
>  extern long compat_ptr_ioctl(struct file *file, unsigned int cmd,
>  					unsigned long arg);
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 98d8e06dea22..4919b4e94c12 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -132,6 +132,7 @@ enum {
>  	IORING_OP_PROVIDE_BUFFERS,
>  	IORING_OP_REMOVE_BUFFERS,
>  	IORING_OP_TEE,
> +	IORING_OP_IOCTL,
>  
>  	/* this goes last, obviously */
>  	IORING_OP_LAST,
> 

-- 
Pavel Begunkov
