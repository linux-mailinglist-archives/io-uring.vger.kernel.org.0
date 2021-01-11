Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727F02F0C33
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 06:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbhAKFRD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jan 2021 00:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726494AbhAKFRD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jan 2021 00:17:03 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C249C061795
        for <io-uring@vger.kernel.org>; Sun, 10 Jan 2021 21:16:22 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id v14so12761891wml.1
        for <io-uring@vger.kernel.org>; Sun, 10 Jan 2021 21:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=thgThFjPlfSSMqINwK9VxQ5BaqxSpxmt4UNvIx1uQNE=;
        b=RKHeHEropCLonTk0uVQvSljngPTKNVn8dxi96EuziSCTXX5aEgXIhayGuGP3rYkfBg
         XVM/f6KmI/OB9TO34O8x9ghzgbAROeETk5/OJLq4oeXujkEhxdbnMixvZ8N45pmQwdTp
         5wCnPADkgcSV3QViQUCMEOt0+NNKhnSG02smdKPl86Oc52v9Wd+3S8CMvtfjKDOdLI9f
         o3D23fzsM/ExfYVRTfJUh8BuWxtGn2LvrOEVi6+/9csvrh7Pjz4qpRXYSkSt8htcD9m8
         babD9Kvczzb0bRtC/wSrerMKCsXbUOy4epOjOtWjb3nJ/pguGZ2VEMfjtJXnn9qCUTqk
         IdYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=thgThFjPlfSSMqINwK9VxQ5BaqxSpxmt4UNvIx1uQNE=;
        b=jrZUFkE55FPH1f/s9c9cJYZNPL+SscP51zQwlzTeDEp8wfAI8q8iJxIy1brkjAd1oD
         G57xkbLSk4HEuuqIHUS747CksZcVQbLaSeJsruK53Se602jsThEXDNDOgTlNmqOWJyxC
         afvHmF2JqrbW9jnvzY901PybsFG6q/KkqG5JzCf+X4Dalgb8af1dK/lL+8ARNAOvNiZX
         peaZj+gSGcBzxywHWgrVYx8Xb6ByMJ3oR/hCmF3CftzvH65VOM0Xd1wDVK8sCSdTZ2Gq
         8cJDmCBmF/fZgLHE2ddCOaVruMh0P36VEeDNEhzfM6kvmd04MhXUrkAqpJbcI/YaolSm
         NPtw==
X-Gm-Message-State: AOAM531nJvmTZ3v8csT4MtK86rS2Kfds2uk6N0efs3meETAiWS1jCLFj
        ZoHjK5lJlUhK2rUQoLNohna53pBwj5E=
X-Google-Smtp-Source: ABdhPJyGurkAjEo5QC5d4m3ncu5PTc9beBaro8Yu6QodDUS0W1poOn3wCcSqb988u01GVlVxWyQnJg==
X-Received: by 2002:a1c:4489:: with SMTP id r131mr13226132wma.24.1610342181078;
        Sun, 10 Jan 2021 21:16:21 -0800 (PST)
Received: from [192.168.8.119] ([85.255.237.6])
        by smtp.gmail.com with ESMTPSA id n9sm22547008wrq.41.2021.01.10.21.16.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jan 2021 21:16:20 -0800 (PST)
Subject: Re: [PATCH v3 08/13] io_uring: implement fixed buffers registration
 similar to fixed files
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1608314848-67329-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1608314848-67329-9-git-send-email-bijan.mottahedeh@oracle.com>
 <f0bff3b0-f27e-80fe-9a58-dfeb347a7e61@gmail.com>
 <c982a4ea-e39f-d8e0-1fc7-27086395ea9a@oracle.com>
 <66fd0092-2d03-02c0-fe1c-941c761a24f8@gmail.com>
 <20b6a902-4193-22fe-2cd7-569024648a26@oracle.com>
 <5d14a511-34d2-1aa7-e902-ed4f0e6ded82@gmail.com>
 <554b54ec-f7b4-a8ed-6b74-8d209b0a0f5f@oracle.com>
 <d673405c-79bb-d326-13cf-c54ad3f36b4b@gmail.com>
 <e7e1365b-5392-5d58-959f-0cbfc0c74fef@gmail.com>
 <f1288c74-fbab-b02e-f3b4-f96953a7572d@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e658c397-31c4-d0bf-dad2-7e32d16a4575@gmail.com>
Date:   Mon, 11 Jan 2021 05:12:47 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <f1288c74-fbab-b02e-f3b4-f96953a7572d@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 08/01/2021 01:53, Bijan Mottahedeh wrote:
> 
>> Forgot to mention, I failed to find where you do
>> io_set_resource_node() in v4 for fixed reads/writes.
>> Also, it should be done during submission, io_prep_rw()
>> is the right place for that.
> 
> Would something like below be ok?  I renamed io_set_resource_node() to io_get_fixed_rsrc_ref() to make its function more clear and also distinguish it from io_sqe_rsrc_set_node().

looks good

> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index bd55d11..a9b9881 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1083,12 +1083,11 @@ static inline void io_clean_op(struct io_kiocb *req)
>                 __io_clean_op(req);
>  }
> 
> -static inline void io_set_resource_node(struct io_kiocb *req)
> +static inline void io_get_fixed_rsrc_ref(struct io_kiocb *req,
> +                                        struct fixed_rsrc_data *rsrc_data)
>  {
> -       struct io_ring_ctx *ctx = req->ctx;
> -
>         if (!req->fixed_rsrc_refs) {
> -               req->fixed_rsrc_refs = &ctx->file_data->node->refs;
> +               req->fixed_rsrc_refs = &rsrc_data->node->refs;
>                 percpu_ref_get(req->fixed_rsrc_refs);
>         }
>  }
> @@ -2928,6 +2927,9 @@ static int io_prep_rw(struct io_kiocb *req, const struct i
>         req->rw.addr = READ_ONCE(sqe->addr);
>         req->rw.len = READ_ONCE(sqe->len);
>         req->buf_index = READ_ONCE(sqe->buf_index);
> +       if (req->opcode == IORING_OP_READ_FIXED ||
> +           req->opcode == IORING_OP_WRITE_FIXED)
> +               io_get_fixed_rsrc_ref(req, ctx->buf_data);
>         return 0;
>  }
> 
> @@ -6452,7 +6454,7 @@ static struct file *io_file_get(struct io_submit_state *st
>                         return NULL;
>                 fd = array_index_nospec(fd, ctx->nr_user_files);
>                 file = io_file_from_index(ctx, fd);
> -               io_set_resource_node(req);
> +               io_get_fixed_rsrc_ref(req, ctx->file_data);
>         } else {
>                 trace_io_uring_file_get(ctx, fd);
>                 file = __io_file_get(state, fd);
> 

-- 
Pavel Begunkov
