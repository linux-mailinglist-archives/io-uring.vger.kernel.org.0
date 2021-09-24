Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0574D417C4F
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 22:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346992AbhIXUXZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345900AbhIXUXY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:23:24 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200F8C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:21:51 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id bx4so40641402edb.4
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:21:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1XUclBDz1UxLQaeMSsk3oJspa/7btjnIQvdFnmOI7Mw=;
        b=AHf+RdsWQYJajwc1Sh6X+sVJY/hLVKePdSlJnS771OgZsA0rban7Y+eh2TGetvjoH4
         fdttM71s0Oix/VUnbyXT7l6i5szY5jnavA2He3rfb08PLdwhOQqRmAFxs8RnRhjan+CA
         a93jnrp0zGI2kE4zDXuV+ibLpIwybnMZT6regPDeDju2bf1I9zfCM3EPXdAbFuqCYNDi
         +/bcz+XPOcS+7QhZnx6f5fOnrI3AasDl4wlM1tkzIf+5lHdUllIDcrgmAdEXOFZ0I3eJ
         fLpy/lnpPT7J9+3C1SOyQ+9jPk8vfsh+nIQ1phSyegxkf6+36a/l1xD0ztpBl/4/G/vd
         WsDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1XUclBDz1UxLQaeMSsk3oJspa/7btjnIQvdFnmOI7Mw=;
        b=JTGOX0fUaLwUVXO2yqYVezUIEcmGfMGjpSnNHXoRIhhwGGINzq3Kj3jWrHLJALoxfv
         8217eKUfY+w7Dd7cRuDPoQJ/hS22QfaqzpX0IVMYb5teRg5vraO3vWeb+5nFj4ktM6mO
         QqkpWXGWKGnEb53H92Egj7bcTKamWVNMTvRXAXa7z6DED5Pdqd782aOW4AM5fMxkLADo
         z6ppVh7hDg0O1JiywmHGO8KDab7Kkzj9HETU7Hov4jYg7n5TrkZrsiK8+7Nf7cqx6qBB
         v0LZLV9HJdWVvToCVn+WwyH39OLvrcRi6b96UIqbOhlnOHvEzKUHskCl1rkhDe6sUEcz
         X6Iw==
X-Gm-Message-State: AOAM531aO9+hz8ZfYImgSaxdKVLVRFuhvcbKvlLiFJwvIRuKFmGC1kut
        lUvYPYt4BHTqScyAMUqj86p/jUh0y20=
X-Google-Smtp-Source: ABdhPJxip93V35C2AP8bSXKM8X/Ia8euWuRDxM5oomJHMrKkeQcSYlW+8ByPV/4eo9GrFwupncr5pA==
X-Received: by 2002:a17:907:2717:: with SMTP id w23mr13324824ejk.283.1632514909459;
        Fri, 24 Sep 2021 13:21:49 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id u4sm5448953ejc.19.2021.09.24.13.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 13:21:49 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
 <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
 <923961d5-28f6-c3d0-680b-035560c9e52a@kernel.dk>
 <0dc9a628-19f9-1861-e948-056f1f48c7ed@gmail.com>
 <0ec019a4-397d-7253-cb9c-35b62279a835@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <84ff7fe9-1d8f-5d25-4459-7417b4729103@gmail.com>
Date:   Fri, 24 Sep 2021 21:21:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <0ec019a4-397d-7253-cb9c-35b62279a835@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 9:19 PM, Jens Axboe wrote:
> On 9/24/21 2:11 PM, Pavel Begunkov wrote:
>> On 9/24/21 9:06 PM, Jens Axboe wrote:
>>> On 9/24/21 1:57 PM, Jens Axboe wrote:
>>>> On 9/24/21 1:04 PM, Pavel Begunkov wrote:
>>>>> From recently open/accept are now able to manipulate fixed file table,
>>>>> but it's inconsistent that close can't. Close the gap, keep API same as
>>>>> with open/accept, i.e. via sqe->file_slot.
>>>>
>>>> I really think we should do this for 5.15 to make the API a bit more
>>>> sane from the user point of view, folks definitely expect being able
>>>> to use IORING_OP_CLOSE with a fixed file that they got with IORING_OP_OPEN,
>>>> for example.
>>>>
>>>> How about this small tweak, basically making it follow the same rules
>>>> as other commands that do fixed files:
>>>>
>>>> 1) Require IOSQE_FIXED_FILE to be set for a direct close. sqe->file_index
>>>>    will be the descriptor to close in that case. If sqe->fd is set, we
>>>>    -EINVAL the request.
>>>>
>>>> 2) If IOSQE_FIXED_FILE isn't set, it's a normal close. As before, if
>>>>    sqe->file_index is set and IOSQE_FIXED_FILE isn't, then we -EINVAL
>>>>    the request.
>>>>
>>>> Basically this incremental on top of yours.
>>>
>>> Hmm, we don't require that for open or accept. Why not? Seems a bit
>>> counter intuitive. But maybe it's better we do this one as-is, and then
>>
>> Accept takes a fd as an argument and so IOSQE_FIXED_FILE already applies
>> to it and can't be used as described. Close is just made consistent with
>> the rest.
> 
> What I'm saying is why don't we make IOSQE_FIXED_FILE for open/accept
> consistent as well?

The flag is already used for accept but for a different purpose 


[IORING_OP_ACCEPT] = {
	.needs_file		= 1,

if (io_op_defs[req->opcode].needs_file) {
	req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
				(sqe_flags & IOSQE_FIXED_FILE));

-- 
Pavel Begunkov
