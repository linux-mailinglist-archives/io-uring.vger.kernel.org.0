Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7022F531904
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231933AbiEWT7T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 15:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiEWT7S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 15:59:18 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF0479830
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 12:59:16 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id j6so14578915pfe.13
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 12:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=rX4IiCNid2HeUSQHi+fLuxHYFKgICAtdWuid37aWMsM=;
        b=OwVuoJnVGGp8CHIBxbaKF2wDvnC1VRQgX7FqyKaVgo42Ayu2qXouYEobpaAgf7LtK6
         afVE/APRNd999vCii0N6vd1o2VYwlouvjHlHjvqmI+Vq4f+an6GDXreWy8wVceSPRtgy
         xFWVpFx63QcKl97UHBmW2//d783lRXiZqXQZIKWx8leNOwMReWd1iPZiYCYO+4lWAlYg
         YJTRTR5FFt2IoCdvss6CxclqItuizgd9PaOG8rGOveTPtrWFa6Rq2DRFlOD05KZCoYGL
         da5Hqy8IATSc13B2XmumjVkEaoLjfO0tukrsnwBqB+pTJ/vD9KEh58MyRVHfQ6/CS/mG
         KKyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rX4IiCNid2HeUSQHi+fLuxHYFKgICAtdWuid37aWMsM=;
        b=RvOnSCNnPPoARdy9l+mhq3TlenG4DnAeddgxNHHs5cq2cGNkj4fIbsbJqn7x4eO4bA
         /vFRJbxL1SeORTFhUcaxx7a+/ZH4EXgsoKfeL2XY4eNd/pYNsDi/1rH92jEvicr1TemZ
         h8DMhw6L+JwMSSNoJQa9Kx4yGeiuDBMdzN8i8DK8rrOWzBHCVyufrYNRDRS2zHS3huxf
         W7uDS+ceO65bH1giF6eNuJ8NjU9xyqOXOtd1/SccnF9DktR7CEwqRxkGAyRmljOZDAje
         95ABjlZjwG0wsBzw9GuMhprarUebwGS7YpAR920FM/WkPCOhIrwwMZHCQO82/KkDAF3y
         pI/g==
X-Gm-Message-State: AOAM531nAXkE7DUzCAdxwomqxHMfJvnnLotZiTeUAmtMWd6sAFhhzCZP
        lqSo6NUul3eASYgDQx3qA22m/Q==
X-Google-Smtp-Source: ABdhPJwYsqzCh77kq63IWp/7Ve18+MbVu94/wALJNksAiWMakr2h64pGW/KKpV+6FsP7iiyluY5A9A==
X-Received: by 2002:a63:f407:0:b0:3fa:91cf:270 with SMTP id g7-20020a63f407000000b003fa91cf0270mr2278519pgi.428.1653335955992;
        Mon, 23 May 2022 12:59:15 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020aa78b57000000b005187ed76a78sm5683918pfd.174.2022.05.23.12.59.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:59:15 -0700 (PDT)
Message-ID: <d9b44d03-2060-86ef-2864-be263fbcba84@kernel.dk>
Date:   Mon, 23 May 2022 13:59:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] io_uring xattr support
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
 <CAHk-=wg54n0DONm_2Fqtpq63ZgfQUef0WLNhW_KaJX4HTh19YQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wg54n0DONm_2Fqtpq63ZgfQUef0WLNhW_KaJX4HTh19YQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/22 1:41 PM, Linus Torvalds wrote:
> On Sun, May 22, 2022 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On top of the core io_uring changes, this pull request includes support
>> for the xattr variants.
> 
> So I don't mind the code (having seen the earlier versions), but
> looking at this all I *do* end up reacting to this part:
> 
>     [torvalds@ryzen linux]$ wc -l fs/io_uring.c
>     12744 fs/io_uring.c
> 
> and no, this is not due to this xattr pull, but the xattr code did add
> another few hundred lines of "io_uring command boilerplate for another
> command" to this file that is a nasty file from hell.

I know, it really is a monster file at this point...

> I really think that it might be time to start thinking about splitting
> that io_uring.c file up. Make it a directory, and have the core
> command engine in io_uring/core.c, and then have the different actual
> IO_URING_OP_xyz handling in separate files.

I've been pondering that for a while actually, and yes I agree it's time
to organize this a bit differently. When you are in this code all the
time you notice less as you know where everything is, but it would be
nice to take the time to split it into some manageable and separately
readable/maintainable pieces.

> And yes, that would probably necessitate making the OP handling use
> more of a dispatch table approach, but wouldn't that be good anyway?
> That io_uring.c file is starting to have a lot of *big* switch
> statements for the different cases.
> 
> Wouldn't it be nice to have a "op descriptor array" instead of the
> 
>         switch (req->opcode) {
>         ...
>         case IORING_OP_WRITE:
>                 return io_prep_rw(req, sqe);
>         ...
> 
> kind of tables?
> 
> Yes, the compiler may end up generating a binary-tree
> compare-and-branch thing for a switch like that, and it might be
> better than an indirect branch in these days of spectre costs for
> branch prediction safety, but if we're talking a few tens of cycles
> per op, that's probably not really a big deal.

I was resistant to the indirect function call initially because of the
spectre overhead, but that was when the table was a lot smaller. The
tides may indeed have shifted on this now that the table has grown to
the size that it has. Plus we have both a prep handler and issue handler
for each, so you end up with two massive switches to deal with that.

> And from a maintenenace standpoint, I really think it would be good to
> try to try to walk away from those "case IORING_OP_xyz" things, and
> try to split things up into more manageable pieces.
> 
> Hmm?

As mentioned, it's something that I have myself been thinking about for
the past few releases. It's not difficult work and can be done in a
sequential kind of manner, but it will add some pain in terms of
backports. Nothing _really_ major, but... Longer term it'll be nicer for
sure, which is the most important bit.

I've got some ideas on how to split the core bits, and the
related-op-per file kind of idea for the rest makes sense. Eg net
related bits can go in one, or maybe we can even go finer grained and
(almost) do per-op.

I'll spend some time after the merge window to try and get this sorted
out.

-- 
Jens Axboe

