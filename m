Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73AE92B0965
	for <lists+io-uring@lfdr.de>; Thu, 12 Nov 2020 17:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728327AbgKLQDN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Nov 2020 11:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728293AbgKLQDM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Nov 2020 11:03:12 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96105C0613D1
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 08:03:12 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id s10so6588429ioe.1
        for <io-uring@vger.kernel.org>; Thu, 12 Nov 2020 08:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ufycLsVbI0y+03ISS9wuvFXMGdwsMjmQENMpXAypK1s=;
        b=EqsCgSroFtb3K0cShvJSqBUtgAtrH9mGnATnjwrzz5b9dixzxbLH0gVgjpJPJgsDB7
         bFvVGVvvOIrYY/6okL9kHifCvJLcP6UajX/jykcJfi5u6tYemlStbV/w/bRKjstdclU6
         rncEn0debjmvD/2c2tBCf/um33BXhSwYs/q3NeREEzUCuUcyhvWx7CVYp22blZLTI9ib
         5hHZlGuhvga5MeSYTAojD4NrDvYf7sF3vfo+N23AHNeCl/6i78XNBoDDETLbR3OCRill
         TsjfEIj5AFCnsbN4qpdf9SNk7h8kYmv4k4kzF9g/C9neSDRCkEXwIZSwp7lzmCPp6otS
         az1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ufycLsVbI0y+03ISS9wuvFXMGdwsMjmQENMpXAypK1s=;
        b=Jp6o64eLJBe2ZQzK2ZAuMX3mGhqwZIdzUcSzcDV8SdAD6chWtEU7D1yKEh+NNBff6h
         ZeUhPWDuJAK5/76ZxM1hQ9xr9h94+zV+0VN22c7lszhetuR9T3cI+kxZTHc9uRFbkuev
         WGQOpgphFWgtNYIsSqocgG/+lWjWyNXjo0fVIRLwd+CFjtMaYmZnZ7r0L8/Ypr9oQhH3
         nLapRb1pUfBTXQLMrH/3iBbcjvUz8m/dCG0qmatRDoDOdOR9mVaq42l7ws41JVOck/d0
         b1+R4Itb1A/mp33XhhjUHDuvAMmJKHmmguX7pMPRIIlQkdgPU5b5pDEz03rFs3RIldNH
         ckzQ==
X-Gm-Message-State: AOAM531KhB/tbH6pZvmq1RKuGRkrLwAHbe7cJvt6a+BKZhGmdwWLcsun
        jESbDYGKQjuMMon9MxSj0bnBQA==
X-Google-Smtp-Source: ABdhPJx582OrxwusfwmyxFsAxbhmPXg83ZHGYfxtc/7nbhz5xFiz7xEQytC3o6LQ59CD9m/iUWbLFg==
X-Received: by 2002:a6b:6610:: with SMTP id a16mr23371783ioc.193.1605196991890;
        Thu, 12 Nov 2020 08:03:11 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y6sm911013iob.48.2020.11.12.08.03.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2020 08:03:11 -0800 (PST)
Subject: Re: [PATCH 5.11 0/2] two minor cleanup and improvement for sqpoll
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph.qi@linux.alibaba.com
References: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <20f7b00e-da1b-7bd2-094d-32363c1615c6@kernel.dk>
Date:   Thu, 12 Nov 2020 09:03:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201112065600.8710-1-xiaoguang.wang@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/11/20 11:55 PM, Xiaoguang Wang wrote:
> Xiaoguang Wang (2):
>   io_uring: initialize 'timeout' properly in io_sq_thread()
>   io_uring: don't acquire uring_lock twice
> 
>  fs/io_uring.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)

Applied, thanks.

-- 
Jens Axboe

