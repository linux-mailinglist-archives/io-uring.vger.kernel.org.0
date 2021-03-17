Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA48633FB6D
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:44:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhCQWnz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbhCQWnb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:43:31 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61602C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:43:31 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b10so268419iot.4
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=60nc2S0amEreD0YFbytIa+5wStMxmK6YRFcjuT/NdsA=;
        b=P1Bf+nxr2qbJmHFJccNB2xnesk6Vfu0LA1kncx+mLW/UZXMZM98pvzf6S/Hd5BMQj9
         hUCp0sLznCK8vxh1R0oPCWmDvMI6H4RLa1CtvBHuTHEfqvRcAL/LlEEWp92BIn3KxCmu
         qsENQoWlfMBcHDQ7ZGy/ZXAs8rD8IqsoIwNpglHlI9L6c4+3plLngT/KJNlkZGF9HH2n
         jr4Gl6xZHw8k+lhlO4680hifazGhzsCfqFWHUQau7XMFLBmH6mSqF0RZZFSRE6obmgo5
         LCVj8BjnTkRG9K6IbxCgaF0zi+BX4M5gb3HmGDBRFV02zkbgnHGbWv5z2+5YM2rWr4NP
         QOHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=60nc2S0amEreD0YFbytIa+5wStMxmK6YRFcjuT/NdsA=;
        b=KX9G+WDOryTdoycFhoK3ubURYHkts+XxP5A9IzOU3LYPtOzDq5lcgIBnIDPDvNU8sU
         hCVJ12JqXcXOlC5oPidNXdkzdwFsFDN9I4zBKaV1lewJU7Bm1iT7pDE7pFL+4AGBNccA
         PIral4Aq9Dl/4KN0uRsrT/bfpggk3HUS87uxH9WDDHIlXDQ3K56ag57IjyaQRG+nkgVr
         gSfeyBTqBkVj/vkX+RW6j9HWaEXGh4x2hTqSyM2Ewo0g3H//bZUQmC88weTcZHNkh5Z0
         Q0GdFw4gnIFZhuQq3hcKYjlgyWKgS+nKa45Cm39J7bgKJbQ8XHQEXIAFkbKWdbYeL+EQ
         7sHA==
X-Gm-Message-State: AOAM532Y0ryT4mIGe6Rf2iQiodfT6kTNLAAO0eyLiNxX2c00RKeV42bW
        Oh3/jZTxA7ZYLVG60uQj65zO3ghCREaSzw==
X-Google-Smtp-Source: ABdhPJxQ6A8bLOMtH8bObNAccWpH1jyhPaDsTvMGRqI0O+w1WM7kyp7124O23NGWyRUrR1sQvPIP7g==
X-Received: by 2002:a05:6638:635:: with SMTP id h21mr4508464jar.97.1616021010583;
        Wed, 17 Mar 2021 15:43:30 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i67sm183350ioa.3.2021.03.17.15.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:43:30 -0700 (PDT)
Subject: Re: [PATCH 5.12 0/5] fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1615754923.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d4a4bbab-e3bf-1a0d-1e71-e1332fe3d51f@kernel.dk>
Date:   Wed, 17 Mar 2021 16:43:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615754923.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/14/21 2:57 PM, Pavel Begunkov wrote:
> Fresh fixes, 3-5 are SQPOLL related 
> 
> Pavel Begunkov (5):
>   io_uring: fix ->flags races by linked timeouts
>   io_uring: fix complete_post use ctx after free
>   io_uring: replace sqd rw_semaphore with mutex
>   io_uring: halt SQO submission on ctx exit
>   io_uring: fix concurrent parking
> 
>  fs/io_uring.c | 72 +++++++++++++++++++++++++++++----------------------
>  1 file changed, 41 insertions(+), 31 deletions(-)

These were applied a while back, forgot to reply. Thanks!

-- 
Jens Axboe

