Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1D6417C35
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 22:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345634AbhIXUN3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348376AbhIXUNZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:13:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C18C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:11:52 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id y12so4275839edo.9
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uVG40F/G1YIiLsWg+ody9B/lg1CRAVlbiKfdax6oSO0=;
        b=oYg3rdJYvqzMGQ3PQj1kjwvSQy6VpXlDDMm8cTCTr6zLHmSUAvnuKf+a4xmF5icmkS
         uel1sIYEU3ZGL7UV2QCLjsMsjuS18S4/YwS8wksCLl7dVhVt7SbATrzuZEhUdw4MGOzA
         ELg/tyfuF8dcAs146YfvY+8X+H5zMsy1cSCsHhNUdwskh/XxqOMm2oPorBTLRnkoA5OS
         gyr69w8h6y10qan87xOMTwNeoRKXir+BRecQaK/XmVxA1c3YOws8T9tBCRcic5xvJYbs
         jYj12T4Tj0+YTFgHl4xSph7f0TatGLOBGKwPkONGFZA/9uTdREp1kn28l2XCIZlBWh4t
         CwJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uVG40F/G1YIiLsWg+ody9B/lg1CRAVlbiKfdax6oSO0=;
        b=P7oDtMQas7IQnkBx3aTs25oesNJPF6c740zWS7XOeMDwY0Y+hxeVNaBA7cjvyzUbKP
         G2VW8km0kVGozdPoHm7mO6i6uH1QH1Pu93OL/RJGQDajuc8n01BJKsGzjTcbWR5IjkeS
         jLBKjIeC4L1+wkqV1lnfmf31IzyNpWTEZuy4gd31F6qrCQXKAvf4PIlnMigRo+PoqLl3
         Je2xGXthLfVIna56o6rpOGuAkVN/USg+Yozdr4vrOrWMxMtvd+Gg3OGJTTDbYWNlWVXz
         YIg32Xlf/6KzgMLNg8Plyq41ex2V3rBKHExkU67gkcFpjl94bn0BrkP2Bixm9pwrKa2w
         6n5A==
X-Gm-Message-State: AOAM531Q2XB9pqCCPTgB+KkyqWeZ9bUFWhOhbccxZBwGgYTryvDDXO/v
        ZV1dki+7sEBbybtSAO2Cmre1UOkR13U=
X-Google-Smtp-Source: ABdhPJzwDgrf1c6R6HpG5c58ZsT4KlR8HrdZiqk7/GOrmc+Ye0XRON1WpbwXNGe9mw9+vfEItG0Sfg==
X-Received: by 2002:a17:906:6d9a:: with SMTP id h26mr3217986ejt.96.1632514310668;
        Fri, 24 Sep 2021 13:11:50 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id a4sm6651863edb.79.2021.09.24.13.11.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 13:11:50 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
 <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
 <923961d5-28f6-c3d0-680b-035560c9e52a@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <0dc9a628-19f9-1861-e948-056f1f48c7ed@gmail.com>
Date:   Fri, 24 Sep 2021 21:11:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <923961d5-28f6-c3d0-680b-035560c9e52a@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 9:06 PM, Jens Axboe wrote:
> On 9/24/21 1:57 PM, Jens Axboe wrote:
>> On 9/24/21 1:04 PM, Pavel Begunkov wrote:
>>> From recently open/accept are now able to manipulate fixed file table,
>>> but it's inconsistent that close can't. Close the gap, keep API same as
>>> with open/accept, i.e. via sqe->file_slot.
>>
>> I really think we should do this for 5.15 to make the API a bit more
>> sane from the user point of view, folks definitely expect being able
>> to use IORING_OP_CLOSE with a fixed file that they got with IORING_OP_OPEN,
>> for example.
>>
>> How about this small tweak, basically making it follow the same rules
>> as other commands that do fixed files:
>>
>> 1) Require IOSQE_FIXED_FILE to be set for a direct close. sqe->file_index
>>    will be the descriptor to close in that case. If sqe->fd is set, we
>>    -EINVAL the request.
>>
>> 2) If IOSQE_FIXED_FILE isn't set, it's a normal close. As before, if
>>    sqe->file_index is set and IOSQE_FIXED_FILE isn't, then we -EINVAL
>>    the request.
>>
>> Basically this incremental on top of yours.
> 
> Hmm, we don't require that for open or accept. Why not? Seems a bit
> counter intuitive. But maybe it's better we do this one as-is, and then

Accept takes a fd as an argument and so IOSQE_FIXED_FILE already applies
to it and can't be used as described. Close is just made consistent with
the rest.


> do a followup patch that solidifies the fact that IOSQE_FIXED_FILE
> should be set for direct open/accept/close.
> 

-- 
Pavel Begunkov
