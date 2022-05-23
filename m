Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28B2531B2C
	for <lists+io-uring@lfdr.de>; Mon, 23 May 2022 22:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231613AbiEWTnY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 May 2022 15:43:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiEWTmw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 May 2022 15:42:52 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3030C265
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 12:41:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id gi33so22479740ejc.3
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 12:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HnMg9PaJ6KDavvSY7bvDnr4e+cLVAv92In4gmvI8qTo=;
        b=HCaV3MV+Wk0Z923y3RiL9cz3mSUV0XeHVnP4FDh3NRxQZA+nm0aJ/Epv8MQnI8vcSc
         7zBAZSQ5t7wRZ8+gtBpm/ooAo0kdVyNyfRYoOO+JacEkD/OOyTn1L5NpMsVymQAbAwZu
         uYpqxRnwshqaGtIGG+BQ7pA8+4kShZx1czvPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HnMg9PaJ6KDavvSY7bvDnr4e+cLVAv92In4gmvI8qTo=;
        b=36gkMQ33nQjNOkTgKtMljK7f5aKB2tg1kCblCuM4NyZA/RPaDKEZ7kFNV1RJ0sRTcV
         aeCvplNXq2qU7k0+ypXrnU3k37BTdYKZ0dkomMolo6dqpiFLaFCoouifheR242CIwt7T
         DflTQ83s6r5RLCz5+ARdM3rlVQ5lHHBu6/r+sT/OKv0NWyMNYq5lGTS82TtA9qg9ykPm
         3rSX73+vhAAXEqezXz9xDv6jBmAMJ7tpc55Lz5TpJ6/qPeYYEtlxTLTUltelEMdSE31e
         y5nVHAj9uo49Dy8edGHaShJAcRYV57reususpWReab1H4V8wlLVj2y19XFjb5U3sEriy
         7YTg==
X-Gm-Message-State: AOAM532RlNeRAkBoTbwhBNO+y3HMpvMuKj7z/ZN42PlAf/quS+0WMtAR
        C83KBUQBiGDai+XRoyCVH75Hfi1b+3n2wnM/jBM=
X-Google-Smtp-Source: ABdhPJxTNwclXPQxjXJRlBFXtTAlb1kweI8OOFahVus4OrZ7LkEzpq6HFuGSdAsRT4HlEiUA2FQaTg==
X-Received: by 2002:a17:907:3e99:b0:6fe:f823:ab96 with SMTP id hs25-20020a1709073e9900b006fef823ab96mr3493734ejc.428.1653334899450;
        Mon, 23 May 2022 12:41:39 -0700 (PDT)
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com. [209.85.128.41])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090602cb00b006f3ef214e59sm6453874ejk.191.2022.05.23.12.41.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 12:41:39 -0700 (PDT)
Received: by mail-wm1-f41.google.com with SMTP id y24so1667756wmq.5
        for <io-uring@vger.kernel.org>; Mon, 23 May 2022 12:41:38 -0700 (PDT)
X-Received: by 2002:a05:600c:4f06:b0:394:836b:1552 with SMTP id
 l6-20020a05600c4f0600b00394836b1552mr518911wmq.145.1653334898506; Mon, 23 May
 2022 12:41:38 -0700 (PDT)
MIME-Version: 1.0
References: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
In-Reply-To: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 23 May 2022 12:41:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg54n0DONm_2Fqtpq63ZgfQUef0WLNhW_KaJX4HTh19YQ@mail.gmail.com>
Message-ID: <CAHk-=wg54n0DONm_2Fqtpq63ZgfQUef0WLNhW_KaJX4HTh19YQ@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring xattr support
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 22, 2022 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On top of the core io_uring changes, this pull request includes support
> for the xattr variants.

So I don't mind the code (having seen the earlier versions), but
looking at this all I *do* end up reacting to this part:

    [torvalds@ryzen linux]$ wc -l fs/io_uring.c
    12744 fs/io_uring.c

and no, this is not due to this xattr pull, but the xattr code did add
another few hundred lines of "io_uring command boilerplate for another
command" to this file that is a nasty file from hell.

I really think that it might be time to start thinking about splitting
that io_uring.c file up. Make it a directory, and have the core
command engine in io_uring/core.c, and then have the different actual
IO_URING_OP_xyz handling in separate files.

And yes, that would probably necessitate making the OP handling use
more of a dispatch table approach, but wouldn't that be good anyway?
That io_uring.c file is starting to have a lot of *big* switch
statements for the different cases.

Wouldn't it be nice to have a "op descriptor array" instead of the

        switch (req->opcode) {
        ...
        case IORING_OP_WRITE:
                return io_prep_rw(req, sqe);
        ...

kind of tables?

Yes, the compiler may end up generating a binary-tree
compare-and-branch thing for a switch like that, and it might be
better than an indirect branch in these days of spectre costs for
branch prediction safety, but if we're talking a few tens of cycles
per op, that's probably not really a big deal.

And from a maintenenace standpoint, I really think it would be good to
try to try to walk away from those "case IORING_OP_xyz" things, and
try to split things up into more manageable pieces.

Hmm?

               Linus
