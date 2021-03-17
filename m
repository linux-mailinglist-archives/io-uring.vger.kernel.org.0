Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE5033F89E
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 20:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbhCQTAX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 15:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhCQTAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 15:00:01 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0B1C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 12:00:01 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id v3so2544168ilj.12
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 12:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=24epm+HLwoWEEH5mLWqlHEJ7HnczD4429RGvWkKWVyk=;
        b=Ybh7rru3SgKj/NlvUpPhRNJuVh3sqSr08l9YAuKoT4GsSdX3Uy3x0yhH+z4YTqvZ94
         lt0WDS4plq0fzWSQlpkMRx6VHeLGpMv5raM0ObfugRRpKahUTlAljN9mWy4HwVRMnD69
         7lSMtq63k7OyWbhGyjnb0C0wh4UxlHIytQbmYk0bIfbC8URDrgSyEF6Lq+s1J8HFtcjZ
         SUU0RwEXeNun0BrRHcleU266YUuiS+f1NruLe6vJ1PrZaNFaBR576qMqPhtlY+f3g0g0
         Ph8ldT0rJaGBoq0RZnSCiesgm50SjheFfy2rUfsXOlC93TqGH4Xq8jTGYT0yVb/2GQ2n
         IFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=24epm+HLwoWEEH5mLWqlHEJ7HnczD4429RGvWkKWVyk=;
        b=mMXu3iPOJAgQ20+eZMd2YW1KZVMDTu6AMskhE7PUXuJvQnkmoJvN9HewQ1N2XMQIon
         qbRn4/manpAdM+kgaP5rf5yYqSHs4XdWcxL53EOrz7kWQY5twB6/HGmpAar3uQwfle/1
         /5wLubnLQdaQZza3wqI1myMOa+/XeUW911HNMUBLCE1atU7twqfHJN0d6sYWP8Smenmz
         7i6fzVk2hAtsw5HVqCwjsan8mFOGQpWWcfEnqdH7ImXB39iteoTpC8ikzVocTdFMlU6Q
         JK2xpOlNsbN/tMMx3as9ZfNKPRIWIiDCPy6ygajAmUxRapK6GxeUmI60+XPKCNm9nKVU
         LcTg==
X-Gm-Message-State: AOAM530wn/xKFz70TMRDRB8B+g8pH/x5OpxDKZafUhuYGdMG7EG7LVvB
        NSxGP1DA0pMtx4YKvGg5dr7LQQ==
X-Google-Smtp-Source: ABdhPJyaMfuu7Q/FfalIzvc9n1/4D+00TyuDpDLhuUZvfSBAnK8XP1a3xlNZgyi6Z7BtuiyndZjUcw==
X-Received: by 2002:a05:6e02:190a:: with SMTP id w10mr2732777ilu.39.1616007600092;
        Wed, 17 Mar 2021 12:00:00 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v17sm10623728ios.46.2021.03.17.11.59.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 11:59:59 -0700 (PDT)
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, kbusch@kernel.org,
        chaitanya.kulkarni@wdc.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com>
 <20210316140126.24900-4-joshi.k@samsung.com> <20210317085258.GA19580@lst.de>
 <149d2bc7-ec80-2e51-7db1-15765f35a27f@kernel.dk>
 <20210317165959.GA25097@lst.de>
 <3b383e8e-b248-b8c4-2eea-6f5708845604@kernel.dk>
Message-ID: <acf7cbd4-3db1-2c53-2ba4-67a396f39053@kernel.dk>
Date:   Wed, 17 Mar 2021 12:59:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3b383e8e-b248-b8c4-2eea-6f5708845604@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/21 11:21 AM, Jens Axboe wrote:
> On 3/17/21 10:59 AM, Christoph Hellwig wrote:
>> On Wed, Mar 17, 2021 at 10:49:28AM -0600, Jens Axboe wrote:
>>> I will post it soon, only reason I haven't reposted is that I'm not that
>>> happy with how the sqe split is done (and that it's done in the first
>>> place). But I'll probably just post the current version for comments,
>>> and hopefully we can get it to where it needs to be soon.
>>
>> Yes, I don't like that at all either.  I almost wonder if we should
>> use an entirely different format after opcode and flags, although
>> I suspect fd would be nice to have in the same spot as well.
> 
> Exactly - trying to think of how best to do this. It's somewhat a shame
> that I didn't place user_data right after fd, or even at the end of the
> struct. But oh well.
> 
> One idea would be to have io_uring_sqe_hdr and have that be
> op/flags/prio/fd as we should have those for anything, and just embed
> that at the top of both io_uring_sqe (our general command), and
> io_uring_whatever which is what the passthrough stuff would use.
> 
> Not sure, I need to dabble in the code a bit and see how we can make it
> the cleanest.

How about something like the top two patches here to kick it off, then
build on top?

https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v4

-- 
Jens Axboe

