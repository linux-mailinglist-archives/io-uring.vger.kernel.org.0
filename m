Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82773235FA
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 04:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhBXDTe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 22:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbhBXDTe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 22:19:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CED5C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 19:18:48 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id w18so325150plc.12
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 19:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=hh9IATp/DDOYwxGml/h+lxGT8Y8XN8qLxrt4S8OIiZ0=;
        b=0wOiVeRkiGD5TDqebVyHeWKNc4uxroVPG27uhw8D7PwIVr2ngY23K6NXyUK+sIE+f9
         fz9F2ukTGhNV71VtedwnqnxmxNQGQnqAqFowA3OpkxrDrIU/IxVlfgojcs2oY9TKFL9T
         LZ5rLsrBGuoCGhZ71RgqGKnU7Miu/ydqzrTnBTY4iFQaDtP52JfyRD1Dwnt3JlrZpuUe
         Uqnq9ARiT2Mt7wrDGD98li6pCDcS9O+Wy9IttHnpI7fLLUG0xhk+nj6djKRQSqtxss9B
         frg/nTS40+MbzEjgi0BNPsLgWGmZIXnB4rFbQhFLKl5FPKAGX0Ye+QmJUDGGnQVIQyri
         3AZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hh9IATp/DDOYwxGml/h+lxGT8Y8XN8qLxrt4S8OIiZ0=;
        b=iPwQ2CoNXUgYuWgCvcr3OTAd3xkV/dxolIbevZ0koetv8MVeN5MjqpQhdJ8Wk8mQPE
         Rzujrs6ld+gxQbqY0duT4am8Lm7WPbXpv6mKHkr0OSJdhz0D6zvuijQcoO4nMtDoXorL
         6G3JOHMBM9eaWDTRcFLOt3STnXio3vgzPKxppURw83YCtdq2i9rCYLSn3GK2Ktpj/nwK
         mvXvbIkzvLgmFOki+Qv7EKSHNZuIiGraR1q8WhQu3tsKvoMJs636+ploZjg1/vvM2EjN
         6Dj6ZUT4r9uFF0nzMrd8gc3HY4CtHfrardi/tX050zjgz14PT2WXDFkrdieYsSE84twk
         OXPw==
X-Gm-Message-State: AOAM532DW8DBJ0hmW6Z3HjkKCTFJ8zBEeymGGJYJu77m96Kuaeij8lYp
        Z2x5x/Ndo4/He2NmU5TWgb3jxGJ3M1QLag==
X-Google-Smtp-Source: ABdhPJyn1zBBziVe1sSE3RITjInRla6otTys++FJoMPKeTOU+Nwo9hdcup667AzooCsBsJvFQ6WYkA==
X-Received: by 2002:a17:90a:650b:: with SMTP id i11mr2018793pjj.130.1614136727475;
        Tue, 23 Feb 2021 19:18:47 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z137sm542568pfc.172.2021.02.23.19.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 19:18:47 -0800 (PST)
Subject: Re: [PATCH v2 1/1] io_uring: allocate memory for overflowed CQEs
To:     Hao Xu <haoxu@linux.alibaba.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
References: <a5e833abf8f7a55a38337e5c099f7d0f0aa8746d.1614083504.git.asml.silence@gmail.com>
 <f57545fb-a109-0881-ff14-f371d1a9d811@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <fda005e8-d16d-6563-d526-440deb7737f6@kernel.dk>
Date:   Tue, 23 Feb 2021 20:18:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f57545fb-a109-0881-ff14-f371d1a9d811@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/23/21 8:06 PM, Hao Xu wrote:
> ÔÚ 2021/2/23 ÏÂÎç8:40, Pavel Begunkov Ð´µÀ:
>> Instead of using a request itself for overflowed CQE stashing, allocate
>> a separate entry. The disadvantage is that the allocation may fail and
>> it will be accounted as lost (see rings->cq_overflow), so we lose
>> reliability in case of memory pressure. However, it opens a way for for
>> multiple CQEs per an SQE and even generating SQE-less CQEs >
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
> Hi Pavel,
> Allow me to ask a stupid question, why do we need to support multiple 
> CQEs per SQE or even SQE-less CQEs in the future?

Not a stupid question at all, since it's not something we've done
before. There's been discussion about this in the past, in the presence
of the zero copy IO where we ideally want to post two CQEs for an SQE.
Most recently I've been playing with multishot poll support, where a
POLL_ADD will stay active after triggering. Hence you could be posting
many CQEs for that SQE, over the life time of the request.

-- 
Jens Axboe

