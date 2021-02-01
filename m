Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C62430AF8F
	for <lists+io-uring@lfdr.de>; Mon,  1 Feb 2021 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232967AbhBASin (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 13:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhBASia (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 13:38:30 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79576C061756;
        Mon,  1 Feb 2021 10:37:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 190so210507wmz.0;
        Mon, 01 Feb 2021 10:37:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AaOtEeHuaSFZ2GkBHVMVepHP95DL8NVdazqKLO7HNr4=;
        b=HfcsYPUB0n4AyFeX1kubvaQqLsElYwTM/1O0irEPJaGaC4UWxvNp0nh9pJcipSryu6
         DKH/RpKFrs15ILcu8FrYqRc8kZr/5Gns3Y+vNZ6xqslUA0LVeZM5Ne3WXA2a/N0kTGRh
         +IZuCm9KFX892IETdVJYgE/V+WtVHmt6yq89WvyNOoX1ddbKM4ayHrjBwkFaAo/lt1AT
         l/38XEmle4ZjLVrGYQAsBtXyLQg/mSUWJqZJMshhALov4RE827JwbTvUC1P8Y5ui0yC+
         NuCJRww3npoH/8TGCLW+ORJZhovi0QOTRlbQr7Yx9LiwPIBQhAm+3loamyJi6mrR5Qxb
         627g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AaOtEeHuaSFZ2GkBHVMVepHP95DL8NVdazqKLO7HNr4=;
        b=Qgf7LTYLwgR7wL142pbeIlcC0ze2s53D8uhCmcQcsoVThvx9Ckm5IFc5yxW4E8kptf
         9PDVxF66BZOnqG5+3wPFCxupWrGqBEiISm/t2UTUrj5CU7G0FmtqmxzQvQ+oWez4Nx5c
         5tPEUn6w8b5AXy+X+v8bjifdcpjf5Te7ccUq2svRklMEww6bzCouxS4ptaeBmVXinpfR
         rkAjwR4+s9VCt9oElGR7ON0JN+Q6yMbTGJUow8yBGNFjhnx1lMY+egdlyjQqD5yjcf81
         2IMos0Zia76gEdzg9xqloqm/76aRCN9v22w4TtowW5xEQ4XwKD0peavH5yO/vadhGQOK
         meOw==
X-Gm-Message-State: AOAM532QJFrJ3bH/NPd6CdSwC8NOQsgCif7XqW1P+dxEcaae75QNZhuW
        77hVjLjMR5K3N8z9GgkVEWId5YK/YK4=
X-Google-Smtp-Source: ABdhPJwG8erx72RdncYg1nep9BYyexNWGUpyK23jD8ohfmckaxbgKIHQxElkrH2+EGOXqXpSv7LSzA==
X-Received: by 2002:a05:600c:1457:: with SMTP id h23mr236546wmi.30.1612204667510;
        Mon, 01 Feb 2021 10:37:47 -0800 (PST)
Received: from [192.168.8.167] ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id h23sm149653wmi.26.2021.02.01.10.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 10:37:46 -0800 (PST)
Subject: Re: [PATCH] io_uring: Fix NULL dereference in error in
 io_sqe_files_register()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <YBfyzmcP1N6jpDjo@mwanda>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <71e8a8a4-5189-4ac1-b885-1b1a60403452@gmail.com>
Date:   Mon, 1 Feb 2021 18:34:04 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <YBfyzmcP1N6jpDjo@mwanda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 01/02/2021 12:23, Dan Carpenter wrote:
> If we hit a "goto out_free;" before the "ctx->file_data" pointer has
> been assigned then it leads to a NULL derefence when we call:
> 
> 	free_fixed_rsrc_data(ctx->file_data);
> 
> We can fix this by moving the assignment earlier.

looks good, thanks

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

> 
> Fixes: 3cfb739c561e ("io_uring: create common fixed_rsrc_data allocation routines")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 03748faa5295..8e8b74dd7d9b 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7869,6 +7869,7 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  	file_data = alloc_fixed_rsrc_data(ctx);
>  	if (!file_data)
>  		return -ENOMEM;
> +	ctx->file_data = file_data;
>  
>  	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_FILES_TABLE);
>  	file_data->table = kcalloc(nr_tables, sizeof(*file_data->table),
> @@ -7878,7 +7879,6 @@ static int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
>  
>  	if (io_sqe_alloc_file_tables(file_data, nr_tables, nr_args))
>  		goto out_free;
> -	ctx->file_data = file_data;
>  
>  	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
>  		struct fixed_rsrc_table *table;
> 

-- 
Pavel Begunkov
