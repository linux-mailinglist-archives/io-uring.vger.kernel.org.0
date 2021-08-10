Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB903E7CED
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 17:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhHJP6d (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 11:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbhHJP6d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 11:58:33 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DDEC0613C1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 08:58:11 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so4980320pjr.1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 08:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M+5EflNi15FD/Kvdqur66KYZd4k9wCMPUYuJ6mvPI6c=;
        b=yx7fuInePn6q+hS56FK+SUzk3ugRiE2IQ2+hEwWLr3J64PEG5vkWPV5eTzErQK7jKZ
         NAEPQKDcql2t7U0zhy+KeLb7rLsQg0J+2w7mQTy/ejZ5LGuRB5frsAB0esNqZlhcwyj3
         BTFXXOl5F1p24Qx3+326hzTLYzRkTk0hf6G6KT5do3vQOaJqY43J1IivT/D2pMX5Gzk8
         MSUiSfn98cC2IcTsCPCRXDiD58v3QwnE+IHFmLLlrouPRSHuz9YG9g2LB+7DJozr0iA5
         1i+erRkaXsFXYko4/+Lc1XGTE7tPgxnLbVPBFkO0g1cFwIbq0Ype8xmZkp0AjKkjT/oX
         8MHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M+5EflNi15FD/Kvdqur66KYZd4k9wCMPUYuJ6mvPI6c=;
        b=AtkxSICJXH9qTW3M1TxHQX1q49nGuh0GG/iBHVGnqM8l3CJHFTQ0Iv60iDwNj0TT9f
         4VTnHJ+KsEftF0XWUFossWVC28FVz5lEkmqHQqzflMPhTW7/DrK60N1w8hmlpFSYhQIO
         9yTKowUTskCAFbI/4yzzK/pDdIxwlu6EFJyippwnk4baDsCwMzW/s6KjNjJJIqjeKniO
         su4X0Tl6/BumWkQN4D5Map41C1qzbVwwqsoqp/izU24Av/EiJoI1bfuie7aeRHxvSXmz
         vKfmYbJpL+PiokC6aq/fcFVqHuduDTkYQ0iWvrdO1eisTIyZ6oxxsw7Le9aCyQRGp7YV
         S7GA==
X-Gm-Message-State: AOAM533sHWTP7jWF8ydqqN+vVkh9mUXIJ5WnBM2zlCEovV+MqzFfCQgw
        2mrwpmufLcvud9esqzr6SNxgdQ==
X-Google-Smtp-Source: ABdhPJxLO/IDbZd7fXXRWdhdpVP3d7Hf7z+N4m80CJA/NKPj5eOhsrSZjkCcV35t+0BCAMQK5Yo8ZQ==
X-Received: by 2002:a63:1709:: with SMTP id x9mr88177pgl.28.1628611090521;
        Tue, 10 Aug 2021 08:58:10 -0700 (PDT)
Received: from [192.168.1.116] ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id fa21sm3529815pjb.20.2021.08.10.08.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 08:58:10 -0700 (PDT)
Subject: Re: [PATCH 1/4] bio: add allocation cache abstraction
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20210809212401.19807-1-axboe@kernel.dk>
 <20210809212401.19807-2-axboe@kernel.dk> <YRJ74uUkGfXjR52l@T590>
 <79511eac-d5f2-2be3-f12c-7e296d9f1a76@kernel.dk>
 <6c06ac42-bda4-cef6-6b8e-7c96eeeeec47@kernel.dk>
 <CA+1E3r+otujBbY8E49QL_MmxA_bGRTaivFbOkCvNvZEr93q=7g@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0d437134-ce97-747a-4b49-36801dbf4824@kernel.dk>
Date:   Tue, 10 Aug 2021 09:58:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CA+1E3r+otujBbY8E49QL_MmxA_bGRTaivFbOkCvNvZEr93q=7g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/21 9:54 AM, Kanchan Joshi wrote:
> On Tue, Aug 10, 2021 at 8:18 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/10/21 7:53 AM, Jens Axboe wrote:
>>> On 8/10/21 7:15 AM, Ming Lei wrote:
>>>> Hi Jens,
>>>>
>>>> On Mon, Aug 09, 2021 at 03:23:58PM -0600, Jens Axboe wrote:
>>>>> Add a set of helpers that can encapsulate bio allocations, reusing them
>>>>> as needed. Caller must provide the necessary locking, if any is needed.
>>>>> The primary intended use case is polled IO from io_uring, which will not
>>>>> need any external locking.
>>>>>
>>>>> Very simple - keeps a count of bio's in the cache, and maintains a max
>>>>> of 512 with a slack of 64. If we get above max + slack, we drop slack
>>>>> number of bio's.
>>>>>
>>>>> The cache is intended to be per-task, and the user will need to supply
>>>>> the storage for it. As io_uring will be the only user right now, provide
>>>>> a hook that returns the cache there. Stub it out as NULL initially.
>>>>
>>>> Is it possible for user space to submit & poll IO from different io_uring
>>>> tasks?
>>>>
>>>> Then one bio may be allocated from bio cache of the submission task, and
>>>> freed to cache of the poll task?
>>>
>>> Yes that is possible, and yes that would not benefit from this cache
>>> at all. The previous version would work just fine with that, as the
>>> cache is just under the ring lock and hence you can share it between
>>> tasks.
>>>
>>> I wonder if the niftier solution here is to retain the cache in the
>>> ring still, yet have the pointer be per-task. So basically the setup
>>> that this version does, except we store the cache itself in the ring.
>>> I'll give that a whirl, should be a minor change, and it'll work per
>>> ring instead then like before.
>>
>> That won't work, as we'd have to do a ctx lookup (which would defeat the
>> purpose), and we don't even have anything to key off of at that point...
>>
>> The current approach seems like the only viable one, or adding a member
>> to kiocb so we can pass in the cache in question. The latter did work
>> just fine, but I really dislike the fact that it's growing the kiocb to
>> more than a cacheline.
>>
> Still under a cacheline seems. kiocb took 48 bytes, and adding a
> bio-cache pointer made it 56.

Huh yes, I think I'm mixing up the fact that we embed kiocb and it takes
req->rw over a cacheline, but I did put a fix on top for that one.

I guess we can ignore that then and just shove it in the kiocb, at the
end.

-- 
Jens Axboe

