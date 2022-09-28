Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58FB55EDE1D
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 15:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233688AbiI1NuD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 09:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiI1NuC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 09:50:02 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FDC61DA74
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 06:49:58 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g1-20020a17090a708100b00203c1c66ae3so1758284pjk.2
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 06:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=XaZ9l5+JQAjS+1i23sQhZijdNJNA1u7/9uBDcpqr0B4=;
        b=z3it592yGFbroMYJXqDUmgBr1UgJ9kMDwDove2ODnZDqkWsKZP5Q1XYgx/ojyH/9iL
         pLLmnHrSyOTlgDg8kYVpHkqOfNum0Yk6HzYZbd3qxnjGp8wLEZ6BMp8Ca+OMB7vWwUlu
         DbUq5OXhEHIkhaDMvwrXbsnqJlrk1ZTZrsItc71ZBRsP2mOl+62+6j8+HpkGaBG5aRbm
         JbQahZcWHllLGXmNO4UzWptm2MUr67vmVWydaYBQXqI8sHPlczTq5sGRfOO0yfgwGHQ5
         hmeFMyEFOYmXwJxeiRflRx+ExibnwOJnRhYEUG/Z2YulHwJGYQB/4qoZr4uDhEeybNq7
         tamA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=XaZ9l5+JQAjS+1i23sQhZijdNJNA1u7/9uBDcpqr0B4=;
        b=PAA/Urjko7zfQow9CJjBjW1a+hA3nphq6XI2u3h+exDMu4283YERsEkmRy3EgClyuo
         twtihwdUuZfutRpA/wydDZ9pRRMbkWad9fuBhiCEvGURzkIVMCIlUqdCVWWrlGKdnBjB
         mLggrCibHDZcmVmTuCnfx9g1ogCV4TBdHcLh/yXITnutjkarMvs4bDvCsWViDCrdikU9
         BdWH2+D8JIxnfegrB6h4Xd56lpF1+MHNmNgsRQ7SRB2CyZIUbGXV2iUdyTDebDDhl5ki
         kiBbqkV5/Yt3x9U6IA6D368ZHaNv/fwOC7E6kMFmVpkIN/Dgo6n+jW6m+DminbkUJ++5
         ge8A==
X-Gm-Message-State: ACrzQf1KrBwqMem0VjpTGKRiGhPkLGRbrjwR/+1V7qo6qCQikjvagUiI
        911QV1HjokDFq5MH8nV4wrIKyC15AquUOQ==
X-Google-Smtp-Source: AMsMyM4VpMzsTWAvWSWDuUVdlafNHYmVHNyX4U8m2Dtpcg4h1FbKn0UzulWYo28S6UBOZ9Vv27+oYw==
X-Received: by 2002:a17:903:41cb:b0:178:36c2:a98 with SMTP id u11-20020a17090341cb00b0017836c20a98mr31942904ple.47.1664372997673;
        Wed, 28 Sep 2022 06:49:57 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k185-20020a6284c2000000b00541196bd2d9sm4077080pfd.68.2022.09.28.06.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 06:49:57 -0700 (PDT)
Message-ID: <176940f4-c819-86f9-03ee-dc456c3099d8@kernel.dk>
Date:   Wed, 28 Sep 2022 07:49:56 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: Chaining accept+read
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Ben Noordhuis <info@bnoordhuis.nl>
Cc:     io-uring@vger.kernel.org
References: <CAHQurc-0iK9zawpc_k_-wSUVMp_+v14K+t-EJEDXL0pYkzD80A@mail.gmail.com>
 <ff41b5f7-93a5-26ee-bae5-80fc828e1a45@gmail.com>
 <CAHQurc9e=BU3gXbc=brb1b+vLb7nmeyeVaGwqkgRoqnSyHT2AQ@mail.gmail.com>
 <8059c7e2-c3e7-c3c1-6994-2fdb75d5d5dd@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8059c7e2-c3e7-c3c1-6994-2fdb75d5d5dd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/22 5:59 AM, Pavel Begunkov wrote:
> On 9/28/22 11:55, Ben Noordhuis wrote:
>> On Wed, Sep 28, 2022 at 12:02 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> On 9/28/22 10:50, Ben Noordhuis wrote:
>>>> I'm trying to chain accept+read but it's not working.
>>>>
>>>> My code looks like this:
>>>>
>>>>       *sqe1 = (struct io_uring_sqe){
>>>>         .opcode     = IORING_OP_ACCEPT,
>>>>         .flags      = IOSQE_IO_LINK,
>>>>         .fd         = listenfd,
>>>>         .file_index = 42, // or 42+1
>>>>       };
>>>>       *sqe2 = (struct io_uring_sqe){
>>>>         .opcode     = IORING_OP_READ,
>>>>         .flags      = IOSQE_FIXED_FILE,
>>>>         .addr       = (u64) buf,
>>>>         .len        = len,
>>>>         .fd         = 42,
>>>>       };
>>>>       submit();
>>>>
>>>> Both ops fail immediately; accept with -ECANCELED, read with -EBADF,
>>>> presumably because fixed fd 42 doesn't exist at the time of submission.
>>>>
>>>> Would it be possible to support this pattern in io_uring or are there
>>>> reasons for why things are the way they are?
>>>
>>> It should already be supported. And errors look a bit odd, I'd rather
>>> expect -EBADF or some other for accept and -ECANCELED for the read.
>>> Do you have a test program / reporoducer? Hopefully in C.
>>
>> Of course, please see below. Error handling elided for brevity. Hope
>> I'm not doing anything stupid.
> 
> Perfect thanks
> 
>> For me it immediately prints this:
>>
>> 0 res=-125
>> 1 res=-9
> 
> The reason is that in older kernels we're resolving the read's
> file not after accept but when assembling the link, which was
> specifically fixed a bit later.

Right, IORING_FEAT_LINKED_FILE can be checked to see if this is
properly supported or not on the host.

> Jens, are there any plans to backport it?

If I recall I briefly looked at it, but it was a bit more involved
that I would've liked. But then it got simplified a bit after the
fact, so should probably be doable to get into 5.15-stable at least.
Anything earlier than that stable wise is too old anyway.

-- 
Jens Axboe


