Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D35417C48
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 22:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbhIXUUy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 16:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344583AbhIXUUx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 16:20:53 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91264C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:19:20 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y5so4810378pll.3
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 13:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+ZT6M9kvNFqGoFME2/kp1A+5qG3+AKBFQ4fri8I0vx0=;
        b=far3kJ+9MkqCubQ3YpWo8ttT5RiasRkEF6xNpG3wnLirUr+GoKvhpxhfVdKJFgIB5q
         2ZtxUZn/ZvgDN7Q1qUE/LuYSy32ShiEkpLGBjVlGndw/MxCUasef0Vxhui7cy83SxXaq
         jDwRs7X/rlHqN96hUeT269jfpPWUtwSt0pw7L+3IS8QImv8QhVynSmHB0Eby7//dIfyk
         b2f45lZdV9ZhIDzdzXQ/nlrsuNN6ucly/XnI7FotUc602R+s3KmIgcjJ+Vhgrv2EILAq
         NtDl62b52opmUYWA7MvjPEXrTpGQHYnoMCi58LjM9zG6XpOXFKKmupxNt5qeXBYgdjXB
         KiIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+ZT6M9kvNFqGoFME2/kp1A+5qG3+AKBFQ4fri8I0vx0=;
        b=C4eqzHK+AXiF7o9sg7RClBdp7syu2rXahq4/oWwJ03aKb7Z+G+a+/1JQcLKW+ZcQ80
         /sksZtfMmo0JpBT7QjFwiFQveF8YtLTKoCZbcQ9MlqIQKaEcuFTcy2OU0JePIBrRocfp
         tEI4j6I6y9DRrPrOtGfZwxyb8J1jEU1i75fOiu+eTapyQfUFRRqv05TqvH73d7kE8IJp
         TbhYzisNLz2X3CIfBC9mSaHp3buF8pHS8v9uasmPiiArgaPJGJ9HbM8O46pRMXzgNtO2
         RoE8AodSbOPgQHj7q/Bnl0s86jdVzcNHGvn7955ZAa/ubXhlPW/JqP34r2K0DUVjdjG7
         lTpw==
X-Gm-Message-State: AOAM532pDt/0nAb2ZI8OTdhquXk6VRXexCvXtxtCdzar8NqVd0hOOnit
        xm7PlfAAEYAufXxcA7b4TsbXDtQpsDWyWQ==
X-Google-Smtp-Source: ABdhPJzO8ol1wKFXbWHcR6Wb8b4Emqgk5B8BefvVad/QtDSVz2GX2zHNW22maZ6Si1zc80KOhrE73A==
X-Received: by 2002:a17:90b:3e8d:: with SMTP id rj13mr4457763pjb.138.1632514759549;
        Fri, 24 Sep 2021 13:19:19 -0700 (PDT)
Received: from ?IPv6:2620:10d:c085:21e8::1691? ([2620:10d:c090:400::5:217e])
        by smtp.gmail.com with ESMTPSA id h3sm1206787pju.33.2021.09.24.13.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 13:19:19 -0700 (PDT)
Subject: Re: [PATCH] io_uring: make OP_CLOSE consistent direct open
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <2b8a74c47ef43bfe03fba1973630f7704851dbdc.1632510251.git.asml.silence@gmail.com>
 <30d37840-1e3d-3f68-2311-68bd7cac4320@kernel.dk>
 <923961d5-28f6-c3d0-680b-035560c9e52a@kernel.dk>
 <0dc9a628-19f9-1861-e948-056f1f48c7ed@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0ec019a4-397d-7253-cb9c-35b62279a835@kernel.dk>
Date:   Fri, 24 Sep 2021 14:19:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0dc9a628-19f9-1861-e948-056f1f48c7ed@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/24/21 2:11 PM, Pavel Begunkov wrote:
> On 9/24/21 9:06 PM, Jens Axboe wrote:
>> On 9/24/21 1:57 PM, Jens Axboe wrote:
>>> On 9/24/21 1:04 PM, Pavel Begunkov wrote:
>>>> From recently open/accept are now able to manipulate fixed file table,
>>>> but it's inconsistent that close can't. Close the gap, keep API same as
>>>> with open/accept, i.e. via sqe->file_slot.
>>>
>>> I really think we should do this for 5.15 to make the API a bit more
>>> sane from the user point of view, folks definitely expect being able
>>> to use IORING_OP_CLOSE with a fixed file that they got with IORING_OP_OPEN,
>>> for example.
>>>
>>> How about this small tweak, basically making it follow the same rules
>>> as other commands that do fixed files:
>>>
>>> 1) Require IOSQE_FIXED_FILE to be set for a direct close. sqe->file_index
>>>    will be the descriptor to close in that case. If sqe->fd is set, we
>>>    -EINVAL the request.
>>>
>>> 2) If IOSQE_FIXED_FILE isn't set, it's a normal close. As before, if
>>>    sqe->file_index is set and IOSQE_FIXED_FILE isn't, then we -EINVAL
>>>    the request.
>>>
>>> Basically this incremental on top of yours.
>>
>> Hmm, we don't require that for open or accept. Why not? Seems a bit
>> counter intuitive. But maybe it's better we do this one as-is, and then
> 
> Accept takes a fd as an argument and so IOSQE_FIXED_FILE already applies
> to it and can't be used as described. Close is just made consistent with
> the rest.

What I'm saying is why don't we make IOSQE_FIXED_FILE for open/accept
consistent as well?

-- 
Jens Axboe

