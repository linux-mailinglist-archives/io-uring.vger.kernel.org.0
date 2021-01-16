Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2BA2F8EAE
	for <lists+io-uring@lfdr.de>; Sat, 16 Jan 2021 19:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727725AbhAPSa0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 16 Jan 2021 13:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727407AbhAPSaW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 16 Jan 2021 13:30:22 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59186C061573
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:29:42 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id 91so12523376wrj.7
        for <io-uring@vger.kernel.org>; Sat, 16 Jan 2021 10:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g7XQJceQORn7EMNkq2/6sh4uF7ORG3ypJCLTycL7Yow=;
        b=dEHtOzQ0ZU81MBRW7TclE5vK90dGQhO22auVxtTcsfNTd+cXLOYluKFQhxv6Vytmjw
         EM1+y9m0IBU8IgUyqdQ7NQBgoUSA/L3VSkN995GFgXzExcJUWmKOmiQNrlnxVJSX6iWd
         KAzZWA4DY4+Wq9b008zhTPIXQVjkWnWEjIzL/LWnpFsK/dUi3fxCAOP55QmyGh+3R4SY
         60zJyLusOvMXYs6fYJoV2BqRMGmpHaoQFV46leOGP9giEwGcN1aW3PeRDaYiTKN4Cb1Z
         DORoJrWAB9tffoHPfM181nCJkd2edsgQJnDOWLoAHQ5UMlYIDoxOB/qsBCxdTa6+bKMx
         JHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g7XQJceQORn7EMNkq2/6sh4uF7ORG3ypJCLTycL7Yow=;
        b=gieh3d+kpic7TlPfASlNnBnTKGrpR40J4+YJXl1wN/9nLpNsj/qI0XKP38Fh8WvX1n
         qmu+iJSxJeKZQD32tCWsikqDLgnsIebFl6xiKzn2sTXGfYb1aFEpPKg9/rvmRLwA26Vy
         eGtmtEZnWZEz8/+7ope47LE49n+MdNYxOsimhisWz63lyuczQvgO1AGKsE+J/tJzBbC5
         7ePlYg5b3PDKIXzeHBStilnCEd33mKZqqjOB6Wc/ols5H2UTxYs9osgtqRV4NIj3GJPi
         2PyyNZIG74kIWF1TkB7mYV43rBe21akOAMuNFwByyGfkUWbdTEXJ/HeZs1UnqsPqX07b
         38pw==
X-Gm-Message-State: AOAM530t+0yaKA6IZf22yCxasWQpq5I1ExciU3MbLRJIO1qTSLU2xqjU
        a2SH1WKg/EOjOMdTTzARR6hXNuA0fPw=
X-Google-Smtp-Source: ABdhPJxZOTv53c6Cru9KkvFpKmKx411oCC793EHTPKDcf+O+jNVYpFj8uQnlf50Q9wjUf3DC99YE2A==
X-Received: by 2002:adf:9467:: with SMTP id 94mr19348412wrq.235.1610821780578;
        Sat, 16 Jan 2021 10:29:40 -0800 (PST)
Received: from [192.168.8.126] ([85.255.234.150])
        by smtp.gmail.com with ESMTPSA id l1sm20495894wrq.64.2021.01.16.10.29.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 10:29:39 -0800 (PST)
Subject: Re: [PATCH v5 10/13] io_uring: create common fixed_rsrc_data
 allocation routines
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1610487193-21374-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1610487193-21374-11-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <afd36c50-ec17-f420-7deb-1e4239019c43@gmail.com>
Date:   Sat, 16 Jan 2021 18:26:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1610487193-21374-11-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/01/2021 21:33, Bijan Mottahedeh wrote:
> Create common alloc/free fixed_rsrc_data routines for both files and
> buffers.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c | 75 ++++++++++++++++++++++++++++++++---------------------------
>  1 file changed, 41 insertions(+), 34 deletions(-)
> 
[...]
> @@ -8672,32 +8688,23 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
>  	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
>  		return ERR_PTR(-EINVAL);
>  
> -	buf_data = kzalloc(sizeof(*ctx->buf_data), GFP_KERNEL);
> -	if (!buf_data)
> -		return ERR_PTR(-ENOMEM);
> -	buf_data->ctx = ctx;
> -	init_completion(&buf_data->done);
> +	buf_data = alloc_fixed_rsrc_data(ctx);
> +	if (IS_ERR(buf_data))
> +		return buf_data;

As you remember it's planned to be partially merged first, so when
you'll be rebasing, please use all these helpers from the beginning
(i.e. in 8/13 or so). Just a nit

>  
>  	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
>  	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
>  				  GFP_KERNEL);
>  	if (!buf_data->table)
> -		goto out_free;
> -
> -	if (percpu_ref_init(&buf_data->refs, io_rsrc_ref_kill,
> -			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
> -		goto out_free;
> +		goto out;
>  
>  	if (io_alloc_buf_tables(buf_data, nr_tables, nr_args))
> -		goto out_ref;
> +		goto out;
>  
>  	return buf_data;
> -
> -out_ref:
> -	percpu_ref_exit(&buf_data->refs);
> -out_free:
> -	kfree(buf_data->table);
> -	kfree(buf_data);
> +out:
> +	free_fixed_rsrc_data(ctx->buf_data);
> +	ctx->buf_data = NULL;
>  	return ERR_PTR(ret);
>  }
>  
> 

-- 
Pavel Begunkov
