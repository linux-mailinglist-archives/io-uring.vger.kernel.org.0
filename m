Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5596A417C5C
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 22:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345221AbhIXU1Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344335AbhIXU1W (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:27:22 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C461C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:25:49 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id h9so11759628ile.6
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=T1NUlRupS4gv/dmNW3wGe0K1QvBkMsh8Gk2Cw5kzNG8=;
        b=RfO0/yw51o06oDfhC1FbO2Bk05Pk8rYtQucEN1cJo7cskneEM8qQaKmxNg136D1bPO
         Vd0m/zl6zsmgC4ZKEsliNIdWKjZW8M30CS8noo8Q2tUi/GmRPR/6lhRRsqr89wme7emH
         rzb4NaaSp0c3POX3yVWShYKUcF9vmvCVf/xCJ909Q6bIjC57kjR80e4YPhpbQQfSR9Dn
         GxZoUy5VoFcWWFNAaAmBXZ2hZC9tNB25RWvAMOZBT6ymLw6nfAOxoA3Ea4FuP9whW0S2
         GV8UofnWEI2X9licXRDUKRjQcYkNnkas48vcYUYxjpV0WQOqtFvh97FOzkFjSzEoUU58
         k5Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T1NUlRupS4gv/dmNW3wGe0K1QvBkMsh8Gk2Cw5kzNG8=;
        b=nxZUr36UtDmZVaHWMwJ3nOSKdDxPxRwItDSYhl1Yarshj46+vQf8RzD31rgZkHLc/M
         xHjEdEi++7HNjXqEewfQETTHRNN5C5QTCaWayAbEEIGgKQimqCbYfuRWjvFvF8Zh3S9y
         70Orp7wztjRnXLJUL6lE9O53A7cQLrXsmPCwFvgZjzCMcrf+ow4lrJ74GEOp1k0lo2Ms
         dkCMCs1IR87aPLxZ9yJ/ZeC/cSnQv3uuj8To/5UZ5ZJelvr13VdMk0ii8TkhIZYPe0pQ
         4KAqVbyRSnaEO4ICipn0QB+0ztGKXvQMF2pCZWB8EO/qCFeD0YeoQ8sgU7YQX9BpQ5hh
         OF7Q==
X-Gm-Message-State: AOAM533KqaCsfwdTyGfmQINBa/Kr+LNbspRv2VhS4hitoxn41dKTyzcn
        bWJC7vDjmFR2Qr7z/O2MGYB3WkccfQ1ENYjeJos=
X-Google-Smtp-Source: ABdhPJyUh9xVZT2FnXtgMvhrrd56HNG+qPLwvESCqi03pUrrbCoWVmYn277pRWUlydR8Ugvzptxc4g==
X-Received: by 2002:a92:d382:: with SMTP id o2mr9999715ilo.67.1632515147894;
        Fri, 24 Sep 2021 13:25:47 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m1sm528886ilc.75.2021.09.24.13.25.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 13:25:47 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
 <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
 <923961d5-28f6-c3d0-680b-035560c9e52a@kernel.dk>
 <0dc9a628-19f9-1861-e948-056f1f48c7ed@gmail.com>
 <0ec019a4-397d-7253-cb9c-35b62279a835@kernel.dk>
 <84ff7fe9-1d8f-5d25-4459-7417b4729103@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <55170147-e749-a86c-ba18-6d619c6b1878@kernel.dk>
Date:   Fri, 24 Sep 2021 14:25:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <84ff7fe9-1d8f-5d25-4459-7417b4729103@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 2:21 PM, Pavel Begunkov wrote:
> On 9/24/21 9:19 PM, Jens Axboe wrote:
>> On 9/24/21 2:11 PM, Pavel Begunkov wrote:
>>> On 9/24/21 9:06 PM, Jens Axboe wrote:
>>>> On 9/24/21 1:57 PM, Jens Axboe wrote:
>>>>> On 9/24/21 1:04 PM, Pavel Begunkov wrote:
>>>>>> From recently open/accept are now able to manipulate fixed file table,
>>>>>> but it's inconsistent that close can't. Close the gap, keep API same as
>>>>>> with open/accept, i.e. via sqe->file_slot.
>>>>>
>>>>> I really think we should do this for 5.15 to make the API a bit more
>>>>> sane from the user point of view, folks definitely expect being able
>>>>> to use IORING_OP_CLOSE with a fixed file that they got with IORING_OP_OPEN,
>>>>> for example.
>>>>>
>>>>> How about this small tweak, basically making it follow the same rules
>>>>> as other commands that do fixed files:
>>>>>
>>>>> 1) Require IOSQE_FIXED_FILE to be set for a direct close. sqe->file_index
>>>>>    will be the descriptor to close in that case. If sqe->fd is set, we
>>>>>    -EINVAL the request.
>>>>>
>>>>> 2) If IOSQE_FIXED_FILE isn't set, it's a normal close. As before, if
>>>>>    sqe->file_index is set and IOSQE_FIXED_FILE isn't, then we -EINVAL
>>>>>    the request.
>>>>>
>>>>> Basically this incremental on top of yours.
>>>>
>>>> Hmm, we don't require that for open or accept. Why not? Seems a bit
>>>> counter intuitive. But maybe it's better we do this one as-is, and then
>>>
>>> Accept takes a fd as an argument and so IOSQE_FIXED_FILE already applies
>>> to it and can't be used as described. Close is just made consistent with
>>> the rest.
>>
>> What I'm saying is why don't we make IOSQE_FIXED_FILE for open/accept
>> consistent as well?
> 
> The flag is already used for accept but for a different purpose 
> 
> 
> [IORING_OP_ACCEPT] = {
> 	.needs_file		= 1,
> 
> if (io_op_defs[req->opcode].needs_file) {
> 	req->file = io_file_get(ctx, req, READ_ONCE(sqe->fd),
> 				(sqe_flags & IOSQE_FIXED_FILE));

Oh yeah, I guess that won't fly then. Let's just go with this one then,
at least there's an explanation for it and they are consistent in using
->file_index to gate it.

-- 
Jens Axboe

