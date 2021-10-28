Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D48643E8C7
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 21:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230041AbhJ1TJL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 15:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1TJK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 15:09:10 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AE0EC061570
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 12:06:43 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id z200so5870678wmc.1
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 12:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=4P7/VfO7cwHqleSoLzgpL5aLpfAz7FLz8i9rZ+jyodc=;
        b=mMwGuG0kF/mORn0NkNJBbxRdggsl2ejLiSnfP2r1DFpeZtMG520D8rebFTSZqL4skH
         6OyCfKYW96xw46kuTQPQ0n9AIB/pDs399J/nIGSWkYBZ7IveFngH5Uq8+mJNaD3kB19s
         CqXmoQcTHh7JOutMUOAsFvGgLW/YCpZlcxOouIAMLkLiaVJOlcnHsaEYmzcong872xQ+
         av5Nuk8W+9c6HHpwRYVLOMzBC0x6D2frWh+eOtSn7ASzFSbMpwg1onsyyKDgARbrHVUn
         dSBaT00bYOKnoSsmaLVH1kaYRjhGE8qF3wo3/2Gts+ey5bVih2C9ZPrNTTHcAewkZaj2
         NQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=4P7/VfO7cwHqleSoLzgpL5aLpfAz7FLz8i9rZ+jyodc=;
        b=2UMNM/ac1SXSW9ZjcvLmH0wyP/q//WhKwcaGk37W5hn/QM0DCpRGhbkjKTw5e8rnRj
         wZ94ohbKMXohXqKsXSOwTsyOyVOWzkPGThSR+UhVATnoERrqbCkK4g03sS3cemb1SEHj
         IpbQ3vPRkx/IlJjIZoVBix1CT0e8af2Lq3zOdGyBOaCOCBCGR4I5hi59hQtm33TU6Nr9
         ME+N21JD17sFP1/CvPyiisZ6knwnCttNPrEt9fMONagyCuw6j3FJbdXUVupwgiT82dox
         vyJMnvb3JNKyFXVrm7vlS0pK23S0ICMXMlCeWTCXwyHiOPJq/4hqaZmTA6Yd1+S0Bd1a
         kdng==
X-Gm-Message-State: AOAM533qJ6dtadeh3CMFGX4oOCYxaML8fns1QJjb+QFcOp1NliPx9VjP
        q02pr1H2xHWPe4Awkmjd4cyF69RX8/E=
X-Google-Smtp-Source: ABdhPJwdafnniJRhpAwWQCV42x/XxhHq79IXuAOhylMEzUhZiZ/qWVzL52cN/2LppJd6ZRniuDF7pA==
X-Received: by 2002:a1c:d1:: with SMTP id 200mr14478474wma.86.1635448001945;
        Thu, 28 Oct 2021 12:06:41 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id g10sm3822897wmq.13.2021.10.28.12.06.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Oct 2021 12:06:41 -0700 (PDT)
Message-ID: <9f27045b-7b1f-28a6-ed28-6b5e11723714@gmail.com>
Date:   Thu, 28 Oct 2021 20:04:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v3 0/3] improvements for multi-shot poll requests
Content-Language: en-US
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
 <163544517302.151024.5113520590406591053.b4-ty@kernel.dk>
 <09e0b364-f0ef-2f81-79b5-84ccf4939e5b@gmail.com>
In-Reply-To: <09e0b364-f0ef-2f81-79b5-84ccf4939e5b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/28/21 20:01, Pavel Begunkov wrote:
> On 10/28/21 19:19, Jens Axboe wrote:
>> On Mon, 25 Oct 2021 13:38:46 +0800, Xiaoguang Wang wrote:
>>> Echo_server codes can be clone from:
>>> https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git
>>> branch is xiaoguangwang/io_uring_multishot. There is a simple HOWTO
>>> in this repository.
>>>
>>> Usage:
>>> In server: port 10016, 1000 connections, packet size 16 bytes, and
>>> enable fixed files.
>>>    taskset -c 10 io_uring_echo_server_multi_shot  -f -p 10016 -n 1000 -l 16
>>>
>>> [...]
>>
>> Applied, thanks!
>>
>> [1/3] io_uring: refactor event check out of __io_async_wake()
>>        commit: db3191671f970164d0074039d262d3f402a417eb
>> [2/3] io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request
>>        commit: 34ced75ca1f63fac6148497971212583aa0f7a87
>> [3/3] io_uring: don't get completion_lock in io_poll_rewait()
>>        commit: 57d9cc0f0dfe7453327c4c71ea22074419e2e800
> 
> Jens, give me time to take a look first. There might be enough of bugs
> just because of sheer amount of new code. I also don't like the amount
> of overhead it adds to generic paths, hopefully unnecessary

Hmm, I mixed them up. This one is simpler, I was looking at the other one

-- 
Pavel Begunkov
