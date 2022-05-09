Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29AEA51FE4F
	for <lists+io-uring@lfdr.de>; Mon,  9 May 2022 15:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235527AbiEINag (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 May 2022 09:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiEINaf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 May 2022 09:30:35 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA11185CB5
        for <io-uring@vger.kernel.org>; Mon,  9 May 2022 06:26:41 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id s14so13824442plk.8
        for <io-uring@vger.kernel.org>; Mon, 09 May 2022 06:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=VvmRF5G9HJK8r+r41z98Zh/WQeJwI+T+Tp1igar1UCw=;
        b=ELbAxmkBh6NAaLp8t960J8v02J2OoE7k+d2+xpC7RNNefrzIPoTlXWla+Su/J5wNrY
         5trImOK77+EbEre7TcA/YW/9qi0NGyvlJijYzG+bg2IgRG+eF3XQfb8BRfbZYLHZrDTx
         TN7Aaa03gYop10hDnYNDwNagHEejVxkbB3UYHG4jDKq8QpiMG+LYm49msBUvf9ods0xJ
         pTO8t73cu2ahMH99VsPPTESpQdkHZMwMtG2vG/AzY64DlveLsKnbsROa4xTzGlDe/1xb
         S4qmoX3aQOX7bWCBJ6kNE/fBn4NirC7BC8wCs0AxHMPK4JCP4D/rjZgFuJGRcD6V1rFg
         CRmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=VvmRF5G9HJK8r+r41z98Zh/WQeJwI+T+Tp1igar1UCw=;
        b=2iMeXwFpn6kXPxqRUxe4fjBncMPoqPn5QOpNjyXERkgMfMJkAmK5wUxmnEtoI2u6fC
         juMtOHrQwTy2WHGUbbhT1JV0+kJeUWufOL+kThERLUJ5rJ6QNBCQ8sdT9UvNG8dKthdM
         TPDCfxbuTdpDGegSFTQumKpSCV37CSkzcPUSeEVzp7IUz4UCbvWyYZ6Vki2WtBVVYPP7
         u55soM/nrlWAmFDbvG7FsOcfl6mS3nCRVv2NFmDWUj1VVk+WB8CW6yspLLU9eHV/CvXC
         EQpVE4s4NPXkuU48LYiMLESmL0mFpf5WJVxWVpYXmygG3NoMemO7MSg8pQpfy8IVNN5c
         C6AQ==
X-Gm-Message-State: AOAM531DP5T0UI5GTPxSsEVrZtmD09AhsLyRh0L+DoUxe9jzf9heTr6P
        +R5kvaBAND5YPue1oVk/x6bbGR4aSpjb2w==
X-Google-Smtp-Source: ABdhPJx8CVAkUQsQRyA/c0c/6SVszdEnYF0niw560h/miJIAfY5lgnVT7d3AhgBDMhyjsagoeylmsw==
X-Received: by 2002:a17:902:f1cc:b0:15e:f63f:2347 with SMTP id e12-20020a170902f1cc00b0015ef63f2347mr12288946plc.61.1652102800840;
        Mon, 09 May 2022 06:26:40 -0700 (PDT)
Received: from [192.168.255.10] ([106.53.33.166])
        by smtp.gmail.com with ESMTPSA id t3-20020aa79383000000b0050dc762817csm8661326pfe.86.2022.05.09.06.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 06:26:40 -0700 (PDT)
Message-ID: <f85a7296-54af-800b-c05d-6b526dc87b7d@gmail.com>
Date:   Mon, 9 May 2022 21:26:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 1/4] io_uring: track fixed files with a bitmap
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220508234909.224108-1-axboe@kernel.dk>
 <20220508234909.224108-2-axboe@kernel.dk>
From:   Hao Xu <haoxu.linux@gmail.com>
In-Reply-To: <20220508234909.224108-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

在 2022/5/9 上午7:49, Jens Axboe 写道:
> In preparation for adding a basic allocator for direct descriptors,
> add helpers that set/clear whether a file slot is used.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   fs/io_uring.c | 37 +++++++++++++++++++++++++++++++++++--
>   1 file changed, 35 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index b6d491c9a25f..6eac6629e7d4 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -257,6 +257,7 @@ struct io_rsrc_put {
>   
>   struct io_file_table {
>   	struct io_fixed_file *files;
> +	unsigned long *bitmap;
>   };
>   
>   struct io_rsrc_node {
> @@ -7573,6 +7574,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
>   	/* mask in overlapping REQ_F and FFS bits */
>   	req->flags |= (file_ptr << REQ_F_SUPPORT_NOWAIT_BIT);
>   	io_req_set_rsrc_node(req, ctx, 0);
> +	WARN_ON_ONCE(file && !test_bit(fd, ctx->file_table.bitmap));
>   out:
>   	io_ring_submit_unlock(ctx, issue_flags);
>   	return file;
> @@ -8639,13 +8641,35 @@ static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
>   {
>   	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
>   				GFP_KERNEL_ACCOUNT);
> -	return !!table->files;
> +	if (unlikely(!table->files))
> +		return false;
> +
> +	table->bitmap = bitmap_zalloc(nr_files, GFP_KERNEL_ACCOUNT);
> +	if (unlikely(!table->bitmap)) {
> +		kvfree(table->files);
> +		return false;
> +	}
> +
> +	return true;
>   }
>   
>   static void io_free_file_tables(struct io_file_table *table)
>   {
>   	kvfree(table->files);
> +	bitmap_free(table->bitmap);
>   	table->files = NULL;
> +	table->bitmap = NULL;
> +}
> +
> +static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
> +{
> +	WARN_ON_ONCE(test_bit(bit, table->bitmap));
> +	__set_bit(bit, table->bitmap);
> +}
> +
> +static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
> +{
> +	__clear_bit(bit, table->bitmap);
>   }
>   
>   static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
> @@ -8660,6 +8684,7 @@ static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>   			continue;
>   		if (io_fixed_file_slot(&ctx->file_table, i)->file_ptr & FFS_SCM)
>   			continue;
> +		io_file_bitmap_clear(&ctx->file_table, i);
>   		fput(file);
>   	}
>   #endif
> @@ -9063,6 +9088,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>   		}
>   		file_slot = io_fixed_file_slot(&ctx->file_table, i);
>   		io_fixed_file_set(file_slot, file);
> +		io_file_bitmap_set(&ctx->file_table, i);
>   	}
>   
>   	io_rsrc_node_switch(ctx, NULL);
> @@ -9123,6 +9149,7 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>   		if (ret)
>   			goto err;
>   		file_slot->file_ptr = 0;
> +		io_file_bitmap_clear(&ctx->file_table, slot_index);
>   		needs_switch = true;
>   	}
>   
> @@ -9130,13 +9157,16 @@ static int io_install_fixed_file(struct io_kiocb *req, struct file *file,
>   	if (!ret) {
>   		*io_get_tag_slot(ctx->file_data, slot_index) = 0;
>   		io_fixed_file_set(file_slot, file);
> +		io_file_bitmap_set(&ctx->file_table, slot_index);
[1]
>   	}
>   err:
>   	if (needs_switch)
>   		io_rsrc_node_switch(ctx, ctx->file_data);
>   	io_ring_submit_unlock(ctx, issue_flags);
> -	if (ret)
> +	if (ret) {
> +		io_file_bitmap_clear(&ctx->file_table, slot_index);
We don't need to clean it, since we get here only when we didn't
run [1], which means we haven't set it.

>   		fput(file);
> +	}
>   	return ret;
>   }
>   
