Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5BE170FE79
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 21:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbjEXTWM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 May 2023 15:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235379AbjEXTWK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 May 2023 15:22:10 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D51186
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 12:22:07 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-397f10f861eso145919b6e.0
        for <io-uring@vger.kernel.org>; Wed, 24 May 2023 12:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684956127; x=1687548127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pRvKumsgKnRJAclrmU2+tTVN4pj3A+uBDQKTwG8wqao=;
        b=VWKyjNlO1eqym9Nb4dLRcbgb7JXcnKinh7hggCLOlGY1MlOQdrs8AMgCbjT/Kpe9S3
         ft1LV+xSFPCf6nKAOC7jl/WaAQ4uWsOmaVLG/peR2tE9nC7y2/HKMHa8xFXB1wvnaN/S
         r186QneGM3/oYqJiHvMg3VlRheT/HYZaOqpxs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684956127; x=1687548127;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pRvKumsgKnRJAclrmU2+tTVN4pj3A+uBDQKTwG8wqao=;
        b=ksNRV+AxtaaUQQk3HDi4TBv6B1NNcRZKhfckEjNJiumgiF/ObAAxmF8ZWHjxNv80jR
         tBHcXprWeX7u5OFSrF55G2HQif1uQM95F4C8i+QY8fDvX/jzFg3CSF89gEnFyzG3ktAd
         NA68Nl9V+GoqWE8mPb1CHkPERvKBpU68DcrsfV4gdiCi14lfWst3SbNTivq0FPw71bUF
         YV6apf/wi9F7WE4sD10/Vl4mxryjUEevmv/pG1iVycfRaBp9wG08+X7PVHHPif8XRDTy
         KbQ1pPxdAy78Nxz7ovOqkfy1r8PmAxIsXGljE4qz/J3mLprN0DU+4nYeh7tRSIo73e05
         GZrA==
X-Gm-Message-State: AC+VfDwFAMPN6djsJZ3viVEhm7ET4n8kxx6Za2gM0a7mfDzc7PWfnJec
        QLcZZpbhRFiCRyei7T2Enlfb+VzfhoMVwrkZt1g/9O9zAavaEJ0c
X-Google-Smtp-Source: ACHHUZ71zuyZpXJ1sjycQV82Fm6WomXHZMyYd9pAkpm8zIGNAa/yCj7KyGBZXYyaAsQT7EFq0vR/lN+IrwKI0jiqx80=
X-Received: by 2002:aca:a943:0:b0:397:fb38:ec74 with SMTP id
 s64-20020acaa943000000b00397fb38ec74mr204908oie.12.1684956126814; Wed, 24 May
 2023 12:22:06 -0700 (PDT)
MIME-Version: 1.0
References: <CABi2SkUp45HEt7eQ6a47Z7b3LzW=4m3xAakG35os7puCO2dkng@mail.gmail.com>
 <d8af0d2b-127c-03ef-0fe6-36a633fb8b49@kernel.dk> <CABi2SkXyMcYEKSwtg7Acg7_j6WCYFmrOeJOLrKTMXCm4FL2fcQ@mail.gmail.com>
 <6724470e-99dd-d111-053c-5b8458730576@kernel.dk>
In-Reply-To: <6724470e-99dd-d111-053c-5b8458730576@kernel.dk>
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Wed, 24 May 2023 12:21:56 -0700
Message-ID: <CABi2SkVLGw+H+X=vCnBc6fp=8TxtLKm+KsnTNwNLOV5tULGd4Q@mail.gmail.com>
Subject: Re: Protection key in io uring kthread
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> >>>
> >>> I wonder what is the case for io_uring, since read is now async, will
> >>> kthread have the user thread's PKUR ?
> >>
> >> There is no kthread. What can happen is that some operation may be
> >> punted to the io-wq workers, but these act exactly like a thread created
> >> by the original task. IOW, if normal threads retain the protection key,
> >> so will any io-wq io_uring thread. If they don't, they do not.
> >>
> > Does this also apply to when the IORING_SETUP_SQPOLL [1] flag is used
> > ? it mentions a kernel thread is created to perform submission queue
> > polling.
>
> It doesn't matter if it's SQPOLL or one of the io-wq workers, they are
> created in the same way. For all intents and purposes, they are
> userspace threads, identical to one you'd get with pthread_create().
> Only difference is that they never return to userspace.
>
Great! Thanks for clarifying.

> >>> In theory, it is possible, i.e. from io_uring_enter syscall. But I
> >>> don't know the implementation details of io_uring, hence asking the
> >>> expert in this list.
> >>
> >> Right, if the IO is done inline, then it won't make a difference if eg
> >> read(2) is used or IORING_OP_READ (or similar) with io_uring.
> >>
> > Can you please clarify what "IO is done inline" means ? i.e. are there
> > cases that are not inline ?
>
> I mean if the execution of it ends up being app -> io_uring_enter() ->
> do io. For some operations, you could end up with:
>
> io_uring_enter() -> punt to io_wq
>         io_wq -> do io
>
> either implicitly because the "do io" operation doesn't support
> nonblocking issue (or ran out of resrouces), or explicitly if you set
> IOSQE_ASYNC in the SQE you submitted.
>
Perfect.

Thanks!
-Jeff Xu
