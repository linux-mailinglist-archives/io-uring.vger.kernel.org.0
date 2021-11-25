Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F9945DC60
	for <lists+io-uring@lfdr.de>; Thu, 25 Nov 2021 15:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355767AbhKYOf6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Nov 2021 09:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352509AbhKYOd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Nov 2021 09:33:58 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C2C061574
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:30:46 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o13so12029236wrs.12
        for <io-uring@vger.kernel.org>; Thu, 25 Nov 2021 06:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0B2DYVrcD8mTEcay/F91+JUidrUiogDIe3cNUDkK8ZE=;
        b=oVBOCNIOLDsnEpYIwhWYsoHsFpKLOSO/V3RfSzDkRmwvwdLiSg5wi/lAOBNA9ddEQo
         aiCo5A1WfWwanxx1SZrNoXz4HtGwYKijQIXOQ13J3KJdXs9DeZ/UNJyIXvC9KTemiDfq
         Q3otNXd7jFbYAglFo4KRWcj42OljAbG80rpgpTNd4uX912XVK34IdQm0FZdk94OZNKyw
         D3gwjbpyGMrReNtZzYqyAUP3m3H2naOcTSxTCD403n7o0h/zjTTK/VWIljfQzu3ZNhef
         A3ltCko+eSI3U8UfKWxTxApsyrE7rKoknXF9rbnD5KOuFQJ6F86fERgXBTDTRG3u1zZE
         aNRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0B2DYVrcD8mTEcay/F91+JUidrUiogDIe3cNUDkK8ZE=;
        b=HZAyE4vk/BWeZz/+wgNmf7dz3IHqNyaVH2JfDEU1TpNtkM3xf+G1DmB5ZY95EjAfdV
         UWUO0fzSzI7cytamjPlQ2b6q5VMlCISNub/Swy7tEI3dLZU/u/D6iBL2yT+UOobzfSrX
         SGNqRXWJqChsJG6kceEzLWOPvEoBbnI8xZl5T5AB49yPStndSfstw00fsT/6VL7u/j+h
         AHE8gEaRKSAP7ELgnAc+LxQoX0Vi3D8RErNfB1482Fxea2UZL3DdVpgj70LBtHUffyWk
         TQ7FIaZfwa1P1hB7fbJ6uKj8b6g4hW6wwDXMAdnR86pndl9F2ww34AshGHM1o+JQlyAi
         DutQ==
X-Gm-Message-State: AOAM532TgPW1L2PLqfNMtsUnD2MkZ44Zr8mCEvbrpA6N0OUXfmlCIac/
        Q8DvXQTUrYqymRoa/zVILjbeVcN0m3Q=
X-Google-Smtp-Source: ABdhPJxZSeh6eeV8h7Z0Ojp4mCKTUsyM3TTkDR0QdfoBkR+of9CNBwcSpNqPStQVIU85CgtrlPV47w==
X-Received: by 2002:a5d:64cd:: with SMTP id f13mr6771445wri.382.1637850645534;
        Thu, 25 Nov 2021 06:30:45 -0800 (PST)
Received: from [192.168.43.77] (82-132-229-54.dab.02.net. [82.132.229.54])
        by smtp.gmail.com with ESMTPSA id l21sm2970832wrb.38.2021.11.25.06.30.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 06:30:45 -0800 (PST)
Message-ID: <a8d30a0a-c623-67b8-e8a8-29cfaeca7975@gmail.com>
Date:   Thu, 25 Nov 2021 14:30:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/2] io_uring: fix no lock protection for ctx->cq_extra
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211125092103.224502-1-haoxu@linux.alibaba.com>
 <20211125092103.224502-2-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211125092103.224502-2-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/25/21 09:21, Hao Xu wrote:
> ctx->cq_extra should be protected by completion lock so that the
> req_need_defer() does the right check.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
> ---
>   fs/io_uring.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index f666a0e7f5e8..ae9534382b26 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -6537,12 +6537,15 @@ static __cold void io_drain_req(struct io_kiocb *req)
>   	u32 seq = io_get_sequence(req);
>   
>   	/* Still need defer if there is pending req in defer list. */
> +	spin_lock(&ctx->completion_lock);
>   	if (!req_need_defer(req, seq) && list_empty_careful(&ctx->defer_list)) {
> +		spin_unlock(&ctx->completion_lock);

I haven't checked the sync assumptions, but it was as this since
the very beginning, so curious if you see any hangs or other
problems?

In any case, as drain is pushed to slow path, I'm all for
simplifying synchronisation here.

>   queue:
>   		ctx->drain_active = false;
>   		io_req_task_queue(req);
>   		return;
>   	}
> +	spin_unlock(&ctx->completion_lock);
>   
>   	ret = io_req_prep_async(req);
>   	if (ret) {
> 

-- 
Pavel Begunkov
