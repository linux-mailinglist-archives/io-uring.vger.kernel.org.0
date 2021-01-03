Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4974C2E8C0D
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 13:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbhACMCQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 07:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbhACMCP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 07:02:15 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52672C061573
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 04:01:35 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id v14so14646281wml.1
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 04:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Br+zxVZIqU0O21m0uwGAnH5XAr2CDPKBJplfF3L+y1U=;
        b=KzqduyfDRl5anv8oJh8/bdS1ccx71BbHEVF1zfsF704lexohtr8PIqISrGL7/dJ+RP
         Q8wl0vOp8A1Sgtw1RAzKR7v7pAkcutn5w5RQdC5XXjwyiU1DM3kW/fy3x5WRclaz/S+m
         1KwIm3PfLmq6h0ROVUM+RzRVPydQnLN3LY0po3DKwl77rhv7Oig+QK/OQbAdA+xfIOP5
         bGCsTiMETJ6hwVM6fGZqY5VJtuiD9Xr14xSPDRsaQFwXebuLR2060zq1V7G3+fX9vQCS
         W+zOY02mPRzzoHTpzOlrX7gOkPP5MVmobRtValK3CUvsA8BXkvVujm5jjS8XjCP6C0L8
         o6tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Br+zxVZIqU0O21m0uwGAnH5XAr2CDPKBJplfF3L+y1U=;
        b=YNmH2t32jwffZ0YXNkgrC6OucKSM0ErBK9x/DoWm0L5c7J4ssARwyjigksLc6NHbLj
         g1Ng8f+oHPzs6MvyYlJguq+1V1TnitTi0GGwkkjYW4fK8lAPm2v83qiUCIW/XI2mh+lw
         F9AvAcKNvUkwbSs+PaMQbKDfOPdG+AQ8MSSDCT6Z64rBKPEb3GAZjLawzXabkS0v1YLT
         HOXkHDqayBAkJGzhcHidIEVJ8t+rjVdqgvfUA9u6zvrVdhhxFkuCx0KCPWonbd5qpL6G
         ARUajYCO0tS8CZF9hYpgplKGRvzXGwOGd9PzWw1VeEIeFJOiVFM4W3cjtJAw72PrS/bS
         +N6Q==
X-Gm-Message-State: AOAM531pCRJ/tZJsON85S3s4bvaMbNxrnWqZeYx6NgDNqjHM488KMpyd
        89Q4IMr5oyztvYbXslAag0MJIZGYtCM=
X-Google-Smtp-Source: ABdhPJx5MFMFqo0tpScUKQr6qB9ve7xoqCyliiHeh6/yx4rVfsJJsS2eAqaOWVavzcWVwld3CY0fsw==
X-Received: by 2002:a1c:6a0e:: with SMTP id f14mr22244202wmc.102.1609675294098;
        Sun, 03 Jan 2021 04:01:34 -0800 (PST)
Received: from [192.168.8.179] ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id o125sm29635355wmo.30.2021.01.03.04.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jan 2021 04:01:33 -0800 (PST)
Subject: Re: [PATCH 1/4] io_uring: dont kill fasync under completion_lock
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+91ca3f25bd7f795f019c@syzkaller.appspotmail.com
References: <cover.1609600704.git.asml.silence@gmail.com>
 <e51028690f7415a018403d3607739693188b5f7b.1609600704.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <ad12bf45-d63c-d636-108c-5656b9a61def@gmail.com>
Date:   Sun, 3 Jan 2021 11:58:03 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <e51028690f7415a018403d3607739693188b5f7b.1609600704.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/01/2021 16:06, Pavel Begunkov wrote:
>       CPU0                    CPU1
>        ----                    ----
>   lock(&new->fa_lock);
>                                local_irq_disable();
>                                lock(&ctx->completion_lock);
>                                lock(&new->fa_lock);
>   <Interrupt>
>     lock(&ctx->completion_lock);
> 
>  *** DEADLOCK ***
> 
> Move kill_fasync() out of io_commit_cqring() to io_cqring_ev_posted(),
> so it doesn't hold completion_lock while doing it. That saves from the
> reported deadlock, and it's just nice to shorten the locking time and
> untangle nested locks (compl_lock -> wq_head::lock).

Need to resend this one

-- 
Pavel Begunkov
