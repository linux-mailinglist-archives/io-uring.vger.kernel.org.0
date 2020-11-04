Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0BC2A6DF8
	for <lists+io-uring@lfdr.de>; Wed,  4 Nov 2020 20:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgKDTeD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Nov 2020 14:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgKDTeD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Nov 2020 14:34:03 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FD98C0613D3
        for <io-uring@vger.kernel.org>; Wed,  4 Nov 2020 11:34:02 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id u19so23449715ion.3
        for <io-uring@vger.kernel.org>; Wed, 04 Nov 2020 11:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MRoxL+CSebNXIAaTNfL2606b5jELQ2qgxVLURuZJ9yY=;
        b=dxdTmvkYVLw3pm9r95pUr3soj0kCsGt7Bo9JXrKzhnS5plEDtBhMSzXi3nSHeMmixC
         +dGySzs4NVns+EvjAVvCp+DHzjDfvDbgBSKbpOnpkyQ1sfDwEyXEtzYEc4SizVYfRRvd
         zMDme8/jNSJapd8MbFdIpKq1i0mrN3yqXsqb1uElyWeXuORR1mcXqsH2wwExm2jYeH41
         b4S6WZiMu/2c/G379t48zUhASNZqry+y/5yIV/YNv/89iAB9Pw+fCzGEhXkyUTW4Jz9w
         QLBwj8KkplUQm6E/godAWe6fDvEjFM36ktuZIHH6jfoTrZL46MjykEs7CPieXrmM3aRR
         XVZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MRoxL+CSebNXIAaTNfL2606b5jELQ2qgxVLURuZJ9yY=;
        b=PjXSCzjke3oRB0H74A9Lu2Rd6aH8EQlSeMzzCErytS4sBZK68jmvLb/k5hxHl6glT2
         S7urF391ZEdBieb9j7wnraWmKqrcUgUZ8LOPBGWobAQtrS0Z0XKiMZ/pw88R7j7HJJa3
         cQYhX/otu+zrlKyWPP0B+0tWY3xDGDkPvFMmUAmzfgohGey+2mxWyP4xLvo5PF3LMoPT
         vKnUwATtjuz+Ps+mG17gg/7IUSDVrQIqeQyKeYHmnCofnsbSTbcGnE3Z/mYK0jP3uwiy
         o+rwEHtS/UHUYX1e/LqnJ0m9Muy7JjwW1jMbA1j4S6GWI9FhyV3uxcj0qh4WGhCV+Mpv
         ih3Q==
X-Gm-Message-State: AOAM531gJJS0TASO4KcOJz5CAiFoMdNGJQe3n2ScjRBtIMZ0v9NvC/c9
        qrSer99dgn7T+ZfiK0JW25FslA==
X-Google-Smtp-Source: ABdhPJxgZHBAd3XtxbbbqT2jvfVIzcjp7lJZgqB+S5hioudZAPnfJ0lVecGbejD9n7r/IDeLG6gZ3Q==
X-Received: by 2002:a02:ce30:: with SMTP id v16mr12066020jar.33.1604518442002;
        Wed, 04 Nov 2020 11:34:02 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l18sm1560436ioc.31.2020.11.04.11.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 11:34:01 -0800 (PST)
Subject: Re: [PATCH v3 RESEND] io_uring: add timeout support for
 io_uring_enter()
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Hao Xu <haoxu@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
References: <1604307047-50980-1-git-send-email-haoxu@linux.alibaba.com>
 <1604372077-179941-1-git-send-email-haoxu@linux.alibaba.com>
 <c2ae5254-d558-a48f-fca2-0759781bf3e1@kernel.dk>
 <052a2b54-017f-8617-5d1a-074408d164fd@kernel.dk>
 <fa632df8-28c8-a63f-e79a-5996344b8226@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b6db7a64-aa37-cdfc-dae3-d8d1d8fa6a7f@kernel.dk>
Date:   Wed, 4 Nov 2020 12:34:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fa632df8-28c8-a63f-e79a-5996344b8226@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/4/20 12:27 PM, Pavel Begunkov wrote:
> On 04/11/2020 18:32, Jens Axboe wrote:
>> On 11/4/20 10:50 AM, Jens Axboe wrote:
>>> +struct io_uring_getevents_arg {
>>> +	sigset_t *sigmask;
>>> +	struct __kernel_timespec *ts;
>>> +};
>>> +
>>
>> I missed that this is still not right, I did bring it up in your last
>> posting though - you can't have pointers as a user API, since the size
>> of the pointer will vary depending on whether this is a 32-bit or 64-bit
>> arch (or 32-bit app running on 64-bit kernel).
> 
> Maybe it would be better 
> 
> 1) to kill this extra indirection?
> 
> struct io_uring_getevents_arg {
> -	sigset_t *sigmask;
> -	struct __kernel_timespec *ts;
> +	sigset_t sigmask;
> +	struct __kernel_timespec ts;
> };
> 
> then,
> 
> sigset_t *sig = (...)arg;
> __kernel_timespec* ts = (...)(arg + offset);

But then it's kind of hard to know which, if any, of them are set... I
did think about this, and any solution seemed worse than just having the
extra indirection.

Yeah, not doing the extra indirection would save a copy, but don't think
it's worth it for this path.

-- 
Jens Axboe

