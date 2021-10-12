Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5585B42A2E2
	for <lists+io-uring@lfdr.de>; Tue, 12 Oct 2021 13:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236032AbhJLLNO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Oct 2021 07:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232791AbhJLLNO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Oct 2021 07:13:14 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5797C061570
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 04:11:12 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id w14so27889676edv.11
        for <io-uring@vger.kernel.org>; Tue, 12 Oct 2021 04:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=ciJzhb+gMxAAgMv1Dp13IpRMfJWsxqffTvnUmaGvL5w=;
        b=iuAxn2PBEogCjBZfY7kiEWthJwh/odvBVO3r8P3ejNRKANV8DrQ77NFW38Jfm0kepq
         yre5yF6CKeDHLl3ceOkL2SjOETuZOuUS1jD04OsZ0dow5gqiFUlgZVWh0DJId12XZIEu
         INbgNdhYV7jPA/pSQVNpTrTGiTlqW+cUatJ1Rwa4/h2iHoLqjZN49Tw0gyd9U0eLBu+h
         uXpVSmk2vDOxi+4XtXaHrU7TjvC2TfVs+KhWGbS71QJevGyT2bxi8+D3Vxrf4s9ppLVR
         du4JHf06EC2BpeO+1Uh1u2R74f3n/BTi3iPFpG8e8hTJhJj14lJb1bSNsvWVwJd2lqfB
         BQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=ciJzhb+gMxAAgMv1Dp13IpRMfJWsxqffTvnUmaGvL5w=;
        b=EoZfG/aoL0oRqHTwvXF/RP4d+yjHMb2ONHnNIaZrRDGqz3SyMhj7tBMvhp/HwTHliQ
         LXDJ7b3dEksiKFdiD4cTPGqIcJgFKYmqz3Kxh/A4hrazt4sgaKkLXlZ7Exe3J1nDnymA
         nbrG84o+mqvUz5E8VnivPsS4mVQLnE/h2xK1PBI7tKx9FMSy9qLmqNtadrvAiwh1MSTw
         6JE2RrJzs0KshJOflrSlCWpMG52quf6CtjAQ819+aIHBa6jEB20W5n3iSOz0mdKO29gq
         IRmOWSH96yo1sWiPf+HRwIkB74ug8VLOknNP0WDwgJQ1PCseCxsHehUqqG+FVJXmL51A
         UmWQ==
X-Gm-Message-State: AOAM530Vli5ZuJofQooFzd1a1amjIj4LVU8ddbDkEKGBngvNrTgc9tY6
        J8Sc9PSVlF4aAp+HDI58Ijo8MQpN6/A=
X-Google-Smtp-Source: ABdhPJzPm6VXLjoEKHPt3ZGC5zVK5OB5FECuwJhbg8Bg1Y4HEE2YEIRPNQaaBcZ1ctl8kha/rPzz+Q==
X-Received: by 2002:a05:6402:4250:: with SMTP id g16mr10360863edb.26.1634037071394;
        Tue, 12 Oct 2021 04:11:11 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.129.215])
        by smtp.gmail.com with ESMTPSA id jt24sm4830158ejb.59.2021.10.12.04.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 04:11:11 -0700 (PDT)
Message-ID: <7899b071-16cf-154d-3354-2211309c2949@gmail.com>
Date:   Tue, 12 Oct 2021 12:10:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-US
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk
References: <20211012084811.29714-1-xiaoguang.wang@linux.alibaba.com>
 <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 1/1] io_uring: improve register file feature's usability
In-Reply-To: <20211012084811.29714-2-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/21 09:48, Xiaoguang Wang wrote:
> The idea behind register file feature is good and straightforward, but
> there is a very big issue that it's hard to use for user apps. User apps
> need to bind slot info to file descriptor. For example, user app wants
> to register a file, then it first needs to find a free slot in register
> file infrastructure, that means user app needs to maintain slot info in
> userspace, which is a obvious burden for userspace developers.

Slot allocation is specifically entirely given away to the userspace,
the userspace has more info and can use it more efficiently, e.g.
if there is only a small managed set of registered files they can
always have O(1) slot "lookup", and a couple of more use cases.

If userspace wants to mimic a fdtable into io_uring's registered table,
it's possible to do as is and without extra fdtable tracking

fd = open();
io_uring_update_slot(off=fd, fd=fd);

For the dual wanting an fd both in the normal fdtable and fixed table
with same indexes, not sure how viable that is but "direct open" can
be extended if needed.


> Actually, file descriptor can be a good candidate slot info. If app wants
> to register a file, it can use this file's fd as valid slot, there'll
> definitely be no conflicts and very easy for user apps.
> 
> To support to pass fd as slot info, we'll need to automatically resize
> io_file_table if passed fd is greater than current io_file_table size,
> just like how fd table extends.
> 
> Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
> ---
>   fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 53 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 73135c5c6168..be7abd89c0b0 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7768,6 +7768,21 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
>   	return !!table->files;
>   }
>   
> +static int io_resize_file_tables(struct io_ring_ctx *ctx, unsigned old_files,
> +				 unsigned new_files)
> +{
> +	size_t oldsize = sizeof(ctx->file_table.files[0]) * old_files;
> +	size_t newsize = sizeof(ctx->file_table.files[0]) * new_files;
> +
> +	ctx->file_table.files = kvrealloc(ctx->file_table.files, oldsize, newsize,
> +					   GFP_KERNEL_ACCOUNT);
> +	if (!ctx->file_table.files)
> +		return -ENOMEM;
> +
> +	ctx->nr_user_files = new_files;
> +	return 0;
> +}
> +
>   static void io_free_file_tables(struct io_file_table *table)
>   {
>   	kvfree(table->files);
> @@ -8147,6 +8162,25 @@ static void io_rsrc_put_work(struct work_struct *work)
>   	}
>   }
>   
> +static inline int io_calc_file_tables_size(__s32 __user *fds, unsigned nr_files)
> +{
> +	int i, fd, max_fd = 0;
> +
> +	for (i = 0; i < nr_files; i++) {
> +		if (copy_from_user(&fd, &fds[i], sizeof(fd)))
> +			return -EFAULT;
> +		if (fd == -1)
> +			continue;
> +		if (fd > max_fd)
> +			max_fd = fd;
> +	}
> +
> +	max_fd++;
> +	if (max_fd < nr_files)
> +		max_fd = nr_files;
> +	return max_fd;
> +}
> +
>   static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   				 unsigned nr_args, u64 __user *tags)
>   {
> @@ -8154,6 +8188,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   	struct file *file;
>   	int fd, ret;
>   	unsigned i;
> +	int num_files;
>   
>   	if (ctx->file_data)
>   		return -EBUSY;
> @@ -8171,8 +8206,12 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   	if (ret)
>   		return ret;
>   
> +	num_files = io_calc_file_tables_size(fds, nr_args);
> +	if (num_files < 0)
> +		goto out_free;
> +
>   	ret = -ENOMEM;
> -	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
> +	if (!io_alloc_file_tables(&ctx->file_table, num_files))
>   		goto out_free;
>   
>   	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
> @@ -8204,7 +8243,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   			fput(file);
>   			goto out_fput;
>   		}
> -		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, i), file);
> +		io_fixed_file_set(io_fixed_file_slot(&ctx->file_table, fd), file);
>   	}
>   
>   	ret = io_sqe_files_scm(ctx);
> @@ -8390,15 +8429,22 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>   	struct io_rsrc_data *data = ctx->file_data;
>   	struct io_fixed_file *file_slot;
>   	struct file *file;
> -	int fd, i, err = 0;
> +	int fd, err = 0;
>   	unsigned int done;
>   	bool needs_switch = false;
> +	int num_files;
>   
>   	if (!ctx->file_data)
>   		return -ENXIO;
>   	if (up->offset + nr_args > ctx->nr_user_files)
>   		return -EINVAL;
>   
> +	num_files = io_calc_file_tables_size(fds, nr_args);
> +	if (num_files < 0)
> +		return -EFAULT;
> +	if (io_resize_file_tables(ctx, ctx->nr_user_files, num_files) < 0)
> +		return -ENOMEM;
> +
>   	for (done = 0; done < nr_args; done++) {
>   		u64 tag = 0;
>   
> @@ -8414,12 +8460,11 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>   		if (fd == IORING_REGISTER_FILES_SKIP)
>   			continue;
>   
> -		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
> -		file_slot = io_fixed_file_slot(&ctx->file_table, i);
> +		file_slot = io_fixed_file_slot(&ctx->file_table, fd);
>   
>   		if (file_slot->file_ptr) {
>   			file = (struct file *)(file_slot->file_ptr & FFS_MASK);
> -			err = io_queue_rsrc_removal(data, up->offset + done,
> +			err = io_queue_rsrc_removal(data, fd,
>   						    ctx->rsrc_node, file);
>   			if (err)
>   				break;
> @@ -8445,9 +8490,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>   				err = -EBADF;
>   				break;
>   			}
> -			*io_get_tag_slot(data, up->offset + done) = tag;
> +			*io_get_tag_slot(data, fd) = tag;
>   			io_fixed_file_set(file_slot, file);
> -			err = io_sqe_file_register(ctx, file, i);
> +			err = io_sqe_file_register(ctx, file, fd);
>   			if (err) {
>   				file_slot->file_ptr = 0;
>   				fput(file);
> 

-- 
Pavel Begunkov
