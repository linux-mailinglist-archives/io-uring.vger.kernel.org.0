Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30628269028
	for <lists+io-uring@lfdr.de>; Mon, 14 Sep 2020 17:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgINPil (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Sep 2020 11:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726331AbgINPij (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Sep 2020 11:38:39 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF7E4C06174A
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 08:38:27 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id j2so532254ioj.7
        for <io-uring@vger.kernel.org>; Mon, 14 Sep 2020 08:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ehciV16R0PLZncUz8yW56qMCE2FjEMwn4smZK9F3bfA=;
        b=riVnXmCee0hy+YxZgq06u26aBLOXvd1911UCmp26gRTYP4s8JH/Rkq3u70HyhVGyBS
         jzgr9Pqs1JSQaoTrGTBGoYocHJ3Bo6JZogdqyKTwEPERvQ+QV8y9XGHS6FPHYTCeCQdV
         BhE/TNoBT2shkOCXHucG7h7eusMuIyQdAxvYezkEj5cxk/hij/6mi2hSdHPzVy1AAN5O
         NHD3qz3MdqmMO8ZOwVsx0UbSPBSHqrLHfuDddR7gH5VZIO7+78D4c4ZONhuPKASGx8q2
         LcfIrdg8m0Q2KDWeC5Lw5SyTZA7TYMBfKFLH5vfuvaLeonygCHgUKYo1enOKS+EO0tz8
         6k3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ehciV16R0PLZncUz8yW56qMCE2FjEMwn4smZK9F3bfA=;
        b=o7R8zx8+md8tnQK8mNFNjISnKfHAIIEkN1uRnOTEJhajltTzVfyQ3vJ0a6gbykCXMG
         UjiXFdA/dLyBFzspRmj4CN6zEy4RoD445H30waPPa2obyZRH8F8+4t3TJL3vchOvOd9z
         ZN3in0SHrD3+n9h0e2U4Qzxnr/m0vgLtQLsgEH5rQ4ilY7kXlPIGKjuU4A2kEyY7fpbU
         Lbh+3cyQ0TBlKa+ErqCyR8E7yb5GF9tTdYvWywUqFU6rACs2hlbSWMg21cEhTXRoJyw3
         9Ym3ZMF0FdkWx4XX1La5PBxsuhQioGXs1ne7P+ir9OtCCaiG9iuDeUJkS7wk8m50TSYd
         /MSA==
X-Gm-Message-State: AOAM530M3FNvECj8n70hB/EojV/7nVpHw1puVbkWOaUl6lRCtGvALlVd
        K5mLSyfZQiz8HJ42N7iT3fnePLknZ8NNdorR
X-Google-Smtp-Source: ABdhPJzhyHpUFE+5v1Eq1JhVd4SDn2ECe9+72b3abkQtDiBzsb2XddZlV2OlKIKj3kRLVRhtyBkVww==
X-Received: by 2002:a6b:7717:: with SMTP id n23mr11853457iom.151.1600097907051;
        Mon, 14 Sep 2020 08:38:27 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k16sm6050385ioc.15.2020.09.14.08.38.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2020 08:38:26 -0700 (PDT)
Subject: Re: [PATCH liburing 3/3] man/io_uring_enter.2: add EACCES and EBADFD
 errors
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20200911133408.62506-1-sgarzare@redhat.com>
 <20200911133408.62506-4-sgarzare@redhat.com>
 <d38ae8b4-cb3e-3ebf-63e3-08a1f24ddcbb@kernel.dk>
 <20200914080537.2ybouuxtjvckorc2@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dc01a74f-db66-0da9-20b7-b6c6e6cb1640@kernel.dk>
Date:   Mon, 14 Sep 2020 09:38:25 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200914080537.2ybouuxtjvckorc2@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/14/20 2:05 AM, Stefano Garzarella wrote:
> On Fri, Sep 11, 2020 at 09:36:02AM -0600, Jens Axboe wrote:
>> On 9/11/20 7:34 AM, Stefano Garzarella wrote:
>>> These new errors are added with the restriction series recently
>>> merged in io_uring (Linux 5.10).
>>>
>>> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>>> ---
>>>  man/io_uring_enter.2 | 18 ++++++++++++++++++
>>>  1 file changed, 18 insertions(+)
>>>
>>> diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
>>> index 5443d5f..4773dfd 100644
>>> --- a/man/io_uring_enter.2
>>> +++ b/man/io_uring_enter.2
>>> @@ -842,6 +842,16 @@ is set appropriately.
>>>  .PP
>>>  .SH ERRORS
>>>  .TP
>>> +.B EACCES
>>> +The
>>> +.I flags
>>> +field or
>>> +.I opcode
>>> +in a submission queue entry is not allowed due to registered restrictions.
>>> +See
>>> +.BR io_uring_register (2)
>>> +for details on how restrictions work.
>>> +.TP
>>>  .B EAGAIN
>>>  The kernel was unable to allocate memory for the request, or otherwise ran out
>>>  of resources to handle it. The application should wait for some completions and
>>> @@ -861,6 +871,14 @@ field in the submission queue entry is invalid, or the
>>>  flag was set in the submission queue entry, but no files were registered
>>>  with the io_uring instance.
>>>  .TP
>>> +.B EBADFD
>>> +The
>>> +.I fd
>>> +field in the submission queue entry is valid, but the io_uring ring is not
>>> +in the right state (enabled). See
>>> +.BR io_uring_register (2)
>>> +for details on how to enable the ring.
>>> +.TP
>>
>> I actually think some of this needs general updating. io_uring_enter()
>> will not return an error on behalf of an sqe, it'll only return an error
>> if one happened outside the context of a specific sqe. Any error
>> specific to an sqe will generate a cqe with the result.
> 
> Mmm, right.
> 
> For example in this case, EACCES is returned by a cqe and EBADFD is
> returned by io_uring_enter().
> 
> Should we create 2 error sections?

Yep, I think we should. One that describes that io_uring_enter() would
return in terms of errors, and one that describes cqe->res returns.

Are you up for this? Would be a great change, making it a lot more
accurate.

-- 
Jens Axboe

