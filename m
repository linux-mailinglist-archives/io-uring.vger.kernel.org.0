Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9983FF302
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 20:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346845AbhIBSJc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 14:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbhIBSJa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 14:09:30 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C9AC061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 11:08:32 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id i13so2745352ilm.4
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 11:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=x7jwCA8rEq3TQFHNfyjnc6P344Yd5+fJjNlnwzbD1eA=;
        b=BnlJX/zGnD5tvFprdNm83CPsYg0uyfhIF/bhA0DNfz7/it6Rs8GynwrLJOysDRLmxk
         6Pvf+ncdWucOGRzkmdMNbCOSnYhQEEWntcZrL15owFBZQ6ZLfltF4G25qC5BJ8sZWw/4
         GEaXLT+rKAHXI128Ixa31j44CRU8FxU8ScfGL195MFe4CmKBUMTjLtKk+OtEovOkNS0B
         UJWQVo/HScbkpGXzDuOepxYoEt5uJPlG5oLPIjWVfqW/ubxpcpNJdAcKOn2P37LelwqU
         hgSwLHwc6XAU3zcgISu9b+dAxnSrbm0oLPBv1qO24ZpP0cFddvbd02yWPQLVKTQfseUG
         fiGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x7jwCA8rEq3TQFHNfyjnc6P344Yd5+fJjNlnwzbD1eA=;
        b=fo3P80jAdvnyebiIes+3dka1PsDkRsiwMo7MnnUpKChoS7Hbn3fseg3umEzeaE1NnT
         NTDwpcz3HiGkZKEeFOzhlnvUUGmY7TwhkEniI+WQhlcNNol65Tu6SJb1+F8ZoOS/Ar82
         m7NNoieW/PxD+S6wTJRk09fxdNCcRn2dK4snTGs5GStMHfV+LNpkc3ZCRWEDcHcPkzpa
         8LfiJJdsC2npoIQ6gIh98CdBZcmXgvs/bKY92022rAGWfY9AAIsHkWmb2D2F7UxpyX2o
         B2yg7QUEWV4B3eHvHxw59SHAY5Jn/EoCbW6Jgc22FThZCVlU49pWmAK1Y8B7WiVPVi9J
         MzQA==
X-Gm-Message-State: AOAM533AR4NG053SixIKomMXk1iLEJ9YuAnFXMvihNaJ5cISE05o4nDB
        uKFtUVK7v/ZPmPkwlDQz/4CpYfyjpGjoTw==
X-Google-Smtp-Source: ABdhPJzzKzzLHIT8pmsZFIrpePPFeL0G/0RZTxQATqDyCcUBJofMkY+KOy2QNdvN2H/46HX0kPVoAw==
X-Received: by 2002:a92:c841:: with SMTP id b1mr3342145ilq.300.1630606111513;
        Thu, 02 Sep 2021 11:08:31 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id t15sm1361742ioi.7.2021.09.02.11.08.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 11:08:31 -0700 (PDT)
Subject: Re: [PATCH] io_uring: trigger worker exit when ring is exiting
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <045c35f3-fb30-8016-5a7e-fc0c26f2c400@kernel.dk>
 <0a7dbae3-e48e-bf8c-1959-59195cad4bcf@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0d9cf759-98fc-334a-e6ab-c9605dc3a8af@kernel.dk>
Date:   Thu, 2 Sep 2021 12:08:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0a7dbae3-e48e-bf8c-1959-59195cad4bcf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/2/21 12:04 PM, Pavel Begunkov wrote:
> On 9/2/21 6:56 PM, Jens Axboe wrote:
>> If a task exits normally, then the teardown of async workers happens
>> quickly. But if it simply closes the ring fd, then the async teardown
>> ends up waiting for workers to timeout if they are sleeping, which can
>> then take up to 5 seconds (by default). This isn't a big issue as this
>> happens off the workqueue path, but let's be nicer and ensure that we
>> exit as quick as possible.
> 
> ring = io_uring_init();
> ...
> io_uring_close(&ring); // triggers io_ring_ctx_wait_and_kill()
> rint2 = io_uring_init();
> ...
> 
> It looks IO_WQ_BIT_EXIT there will be troublesome.

I wonder if we can get by with just a wakeup. Let me test...

-- 
Jens Axboe

