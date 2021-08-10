Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD87C3E7E0F
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 19:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbhHJROf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 13:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbhHJROb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 13:14:31 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08559C06179B
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 10:14:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso83237pjy.5
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 10:14:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=a/OD2NSiEOdIvZBI5bLpVOJ0yE/mRsB7x+DePFaO96s=;
        b=rO/qHPV/SABeeKFcVdMFNzxQq8aMEWL1tlbhJZpggTbUwHneQmt0a72zNjmal/Wu5O
         W5Cn6GHGGtD+ysSlQvKDKIQf/i4LTd+F6HDU07cEoculDYx250XiMY6Lr7gEsgkoGCyP
         UvXyiomqv6rB68GpNVv+VJIkGieFIwwDqHDoTlUGD6Gg5n32R9TdaUtfACuveQz3d5hs
         ZlbUZ5kBmGRm6+t7Nr0dBR7jSZzTd8QPYmyPkZZs7JNcB9DruwQzHGF8FABYTkS/S02T
         UIj4OTPfzdsVe3unZP9zRl9b+Kmd/am4BbFslInFQyLwSnkFfZ2/nZQMOEzCL0WexOD3
         IXfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=a/OD2NSiEOdIvZBI5bLpVOJ0yE/mRsB7x+DePFaO96s=;
        b=QQpfzkjds2XfC93rPOYTisq+g7aRx5pkMCveImDQxH4JbFmZbRHilw0MI8LyhC5o+g
         zhaZZuaewnSIhkLMBRKyZhbAUnOUuXbkV2S1+rMxcI/E6aw0VNmlwcT2bbNtmR/y4Dda
         IqyXzEF2c6AH+Sh5BIMRxkfdO8XuvC1o1j7p+mAbP6I/RKyFmG9+cuKvzraQHIiN08Ko
         3cGyjr+XbTBm9lupDdZIqFGch0ZS8OhZcUOLYUGE5A+ufIqEgzqnwMErzz3urWaPD0Fi
         ODFcdi6hUTlgB0ZCV3qjomcE3sostOdeDe7wFErO7ydzKFLQ9EZgnu04SEPVZ4B6pKJy
         pNrQ==
X-Gm-Message-State: AOAM531MNuZ4UouMtrMz+V3JLLPwTInUMIKhxmv8XtS8CMO9T4aI47DH
        tEN5Lvb9ZTl0qaubbyiv1HX0Sky2kWaSiNg1
X-Google-Smtp-Source: ABdhPJzZrpOejypQTOvwfLy4qrKfMo5R6nIbzYYaTDOWppd9BBuJucbVmT+0f/pS6SVzMMa6b/crxg==
X-Received: by 2002:a63:5344:: with SMTP id t4mr459134pgl.372.1628615648327;
        Tue, 10 Aug 2021 10:14:08 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id i1sm3874077pjs.31.2021.08.10.10.14.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 10:14:07 -0700 (PDT)
Subject: Re: [RFC] io_uring: remove file batch-get optimisation
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <afe7a11e30f64e18785627aa5f49f7ce40cb5311.1628603451.git.asml.silence@gmail.com>
 <be049d43-4774-c79a-8564-82d43fb87766@kernel.dk>
 <623fc711-5c20-71dd-df90-5b94ce22ca96@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7ed1a597-2034-e446-36a0-8f11e26c5437@kernel.dk>
Date:   Tue, 10 Aug 2021 11:14:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <623fc711-5c20-71dd-df90-5b94ce22ca96@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 11:11 AM, Pavel Begunkov wrote:
> On 8/10/21 6:04 PM, Jens Axboe wrote:
>> On 8/10/21 7:52 AM, Pavel Begunkov wrote:
>>> For requests with non-fixed files, instead of grabbing just one
>>> reference, we get by the number of left requests, so the following
>>> requests using the same file can take it without atomics.
>>>
>>> However, it's not all win. If there is one request in the middle
>>> not using files or having a fixed file, we'll need to put back the left
>>> references. Even worse if an application submits requests dealing with
>>> different files, it will do a put for each new request, so doubling the
>>> number of atomics needed. Also, even if not used, it's still takes some
>>> cycles in the submission path.
>>>
>>> If a file used many times, it rather makes sense to pre-register it, if
>>> not, we may fall in the described pitfall. So, this optimisation is a
>>> matter of use case. Go with the simpliest code-wise way, remove it.
>>
>> I ran this through the peak testing, not using registered files. Doesn't
>> seem to make a real difference here, at least in the quick testing.
>> Which would seem to indicate we could safely kill it. But that's also
>> the best case for non-registered files, would be curious to see if it
>> makes a real difference now for workloads where the file is being
>> shared.
> 
> Do you mean shared between cores so there is contention? Or the worst
> case for non-reg with multiple files as described in the patch? 

The former. The latter is also a concern, but less so to me. That
said, I do think we should just do this. It's less code, and that's
always good. To justify it, numbers would have to back it up.

-- 
Jens Axboe

