Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E573147C503
	for <lists+io-uring@lfdr.de>; Tue, 21 Dec 2021 18:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbhLUR1S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Dec 2021 12:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbhLUR1S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 21 Dec 2021 12:27:18 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003D4C061574;
        Tue, 21 Dec 2021 09:27:17 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r17so28039159wrc.3;
        Tue, 21 Dec 2021 09:27:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oyvUCfdobGml0EEFEHDlLQAVdTsHOTqZdq5eX1pl9Cc=;
        b=CFqfVV8J2NDsUKcYoGHtx5HEi1lReGSHHmPQxcpzsS+KUinEvgIYCncCYjKUwRmzZw
         6W4+wR145jRwIvdETSlDdqLGvogrRlbECGeP1i/OPlukd/lHz/NuQIBM11neeLGiYGSC
         jzWgdg1lH3yi409N5qUnGhezq0GhhT2pko71DroXiTuVCj6YUVZycCyxxWSmrNknAv3X
         mc1r9ITZJJJL5XbuJ8u3B8b5Uhf/D6IMNBX5CO5kXYDqxzWsJu1PliCP/f12bwJFBcFE
         5w3shd7zLPwAtSlxWePaUDlEVMsR6leyiLO+BHNzH8o7YSIRsUxBf+FHWvIBbjr0u7VO
         DJKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oyvUCfdobGml0EEFEHDlLQAVdTsHOTqZdq5eX1pl9Cc=;
        b=kWHXp/pA7uYIU0gbiY0qof/A296eIKtYymDQoszskkX5N3823vCzeO7jdyABzugjKw
         NHKROdeADRrLupSkERmAYuqg91lwVFWX5ElYY/ZYS29Vy5u/AIICfHZYzX6PP++AvP/R
         ekkd9MejY+bptQ2uRUu0h5lqoXky44nR4k+q13tINDpRf7aO1HBN/RH59eJQIFQU9bUI
         ji1Cs2Zf7S/n/TTaDYRXuKsOgzxXsxDSsAndQAybV+kWyszpBc8CegeMM5wCNLmZQ05q
         E1yzYpVvJy/i94zp5SX4auoF6OnU4Ymw6cyJ6kV8AqPNahyLdYPhenDat4xvNgHuDBse
         CZ5w==
X-Gm-Message-State: AOAM530JHrdf+JKMOvw3LdYlGPoaoaN3HzOAsoQOPk5Q3ApLwWtStfna
        4+44ieaJY5nZQUTS3g38AJjDzi0DD5k=
X-Google-Smtp-Source: ABdhPJxtbhhhtm4UAZ/ptxfo6P1c25OXx/LSR/HFA4iERmYvqoElD7wBKqnU0wMnPqJJY1pCE8egog==
X-Received: by 2002:a05:6000:178c:: with SMTP id e12mr966323wrg.563.1640107636589;
        Tue, 21 Dec 2021 09:27:16 -0800 (PST)
Received: from [192.168.8.198] ([148.252.128.24])
        by smtp.gmail.com with ESMTPSA id i4sm2843223wmd.34.2021.12.21.09.27.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 09:27:16 -0800 (PST)
Message-ID: <6ce7133b-802f-74cf-7610-a7b0bbbb45fd@gmail.com>
Date:   Tue, 21 Dec 2021 17:27:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 4/5] io_uring: add fsetxattr and setxattr support
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kernel-team@fb.com
Cc:     viro@zeniv.linux.org.uk
References: <20211215221702.3695098-1-shr@fb.com>
 <20211215221702.3695098-5-shr@fb.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211215221702.3695098-5-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/15/21 22:17, Stefan Roesch wrote:
> This adds support to io_uring for the fsetxattr and setxattr API.

Apart from potentially putname comment,

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   fs/io_uring.c                 | 171 ++++++++++++++++++++++++++++++++++
>   include/uapi/linux/io_uring.h |   6 +-
>   2 files changed, 176 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 5092dfe56da6..fc2239635342 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
[...]> +static int __io_setxattr_prep(struct io_kiocb *req,
> +			const struct io_uring_sqe *sqe,
> +			struct user_namespace *user_ns)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	const char __user *name;
> +	void *ret;
> +
> +	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
> +		return -EINVAL;
> +	if (unlikely(sqe->ioprio))
> +		return -EINVAL;
> +	if (unlikely(req->flags & REQ_F_FIXED_FILE))
> +		return -EBADF;
> +
> +	ix->filename = NULL;
> +	name = u64_to_user_ptr(READ_ONCE(sqe->addr));
> +	ix->ctx.value = u64_to_user_ptr(READ_ONCE(sqe->addr2));
> +	ix->ctx.size = READ_ONCE(sqe->len);
> +	ix->ctx.flags = READ_ONCE(sqe->xattr_flags);
> +
> +	ix->ctx.kname = kmalloc(XATTR_NAME_MAX + 1, GFP_KERNEL);
> +	if (!ix->ctx.kname)
> +		return -ENOMEM;> +	ix->ctx.kname_sz = XATTR_NAME_MAX + 1;

Might make sense to let the userspace specify kname size, but
depends what is the average name length and how much of free
space we have in io_xattr

[...]
> +static int io_setxattr(struct io_kiocb *req, unsigned int issue_flags)
> +{
> +	struct io_xattr *ix = &req->xattr;
> +	unsigned int lookup_flags = LOOKUP_FOLLOW;
> +	struct path path;
> +	int ret;
> +
> +	if (issue_flags & IO_URING_F_NONBLOCK)
> +		return -EAGAIN;
> +
> +retry:
> +	ret = do_user_path_at_empty(AT_FDCWD, ix->filename, lookup_flags, &path);
> +	putname(ix->filename);

It putname() multiple times on retry, how does it work?


> +	if (!ret) {
> +		ret = __io_setxattr(req, issue_flags, &path);
> +		path_put(&path);
> +		if (retry_estale(ret, lookup_flags)) {
> +			lookup_flags |= LOOKUP_REVAL;
> +			goto retry;
> +		}
> +	}
> +
> +	req->flags &= ~REQ_F_NEED_CLEANUP;
> +	kfree(ix->ctx.kname);
> +
> +	if (ix->value)
> +		kvfree(ix->value);
> +	if (ret < 0)
> +		req_set_fail(req);
> +
> +	io_req_complete(req, ret);
> +	return 0;
> +}
> +
[...]
>   
>   	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
> @@ -6715,6 +6870,15 @@ static void io_clean_op(struct io_kiocb *req)
>   			putname(req->hardlink.oldpath);
>   			putname(req->hardlink.newpath);
>   			break;
> +		case IORING_OP_SETXATTR:
> +			if (req->xattr.filename)
> +				putname(req->xattr.filename);
> +			fallthrough;
> +		case IORING_OP_FSETXATTR:
> +			kfree(req->xattr.ctx.kname);
> +			if (req->xattr.value)
> +				kvfree(req->xattr.value);

nit: it's slow path and kvfree() handles NULLs, so we don't
really need NULL checks here.

-- 
Pavel Begunkov
