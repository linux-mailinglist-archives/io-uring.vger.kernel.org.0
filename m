Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8226514FA4
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 17:37:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359740AbiD2Pk2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 11:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343710AbiD2Pk1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 11:40:27 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438B1D5EB3;
        Fri, 29 Apr 2022 08:37:09 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2ebf4b91212so89224067b3.8;
        Fri, 29 Apr 2022 08:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/qAuxqoXysKENNiIlItnlrcQMTT0GxzNNHI80GK7T7M=;
        b=iUWQVjnBqeSdZ3g8BrUg+9CAJm4xwvaWfVce3WbZzUm2jaVKxg6PNrMIUdpn2GU77a
         Tag3k25kmMQSJGFOOtg8PovwYoC1gopbSiGub2seyqZQzq5KukgWtJpEYrJBxdRr7eYf
         RvuWdZZV0M63NKMnBT4UF8AjpLN8yC38T35k5YtmrCMPGzmG/q3pbwvR8p074V5n5EEw
         ll9o65trUcwa4wJBO38p7Q4FUC6uaatPSU+Gg+CwNcpr49SBKWaahHuvYr66/pC3S8Mk
         6mY9FphCt+ABjElkcW084lGSL2TbZWgRD8X4TLhfw4y9j2bZNN+YMsWadu3dAQkVYdoZ
         tcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/qAuxqoXysKENNiIlItnlrcQMTT0GxzNNHI80GK7T7M=;
        b=FP8Ox4dUcBfcDjGKmcEpBaiMluYd1L406PCHBS1LLMOuDyW6otNX4ew4q1dJxDx/0D
         3tcx2x33QG2Em9wWNI1sir/6eDh1dOAyTfUPzaMcfGMDxqADWApbpOTx1tPStHSH49h2
         tBVz6T5PiBNi/6P0SYu+1cF4FT90IdIzlfrEOkrmukYiTFBGemGbJuyeNWFbkz1lPyTy
         jL4ixj6YZrljJgBl/zY5b8hLPjaVaO6j2ZqwRtpODpOWt7qCDvaLYAFiINdROmla51/J
         JoH+MLWXpMJrz7zeNAWSAqvWCD7TbEds+nUUqXJoF319wYFpKypxFkrwrJ71oRxoacqN
         kKSw==
X-Gm-Message-State: AOAM530LdVSf9grD/Sfmf/wJ31HX3PfUNc1u7qdCSwBat0lulzl5fb0b
        pGLqSMO58UpXpamgkw5/SAWyMjPXxab+HScLWV0=
X-Google-Smtp-Source: ABdhPJxgTV2qY+1DwOHYvXXKa8HcDK6E1iCbcMFAqey13vx3FiEB+fpA1t0IyhXskVPsyTzLd+UNJwlo4eMN/JnEEcM=
X-Received: by 2002:a81:9213:0:b0:2f6:eaae:d22f with SMTP id
 j19-20020a819213000000b002f6eaaed22fmr36558385ywg.249.1651246628512; Fri, 29
 Apr 2022 08:37:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220429004244.3557063-1-goldstein.w.n@gmail.com> <8f8d07c1-9276-df86-f1dc-3d272d4ab91d@kernel.dk>
In-Reply-To: <8f8d07c1-9276-df86-f1dc-3d272d4ab91d@kernel.dk>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Fri, 29 Apr 2022 10:36:57 -0500
Message-ID: <CAFUsyfK-Mo76PNBHmvUnavHgemgb92g2muqWJjPKv5T7TE-rhA@mail.gmail.com>
Subject: Re: [PATCH v1] io_uring: Fix memory leak if file setup fails.
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 29, 2022 at 7:47 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/28/22 6:42 PM, Noah Goldstein wrote:
> > If `get_unused_fd_flags` files fails (either in setting up `ctx` as
> > `tctx->last` or `get_unused_fd_flags`) `ctx` will never be freed.
>
> There's a comment there telling you why, the fput will end up
> releasing it just like it would when an application closes it.

I see. Thought the 'it' refered to in the comment was the file, not
ctx.

>
> > I very well may be missing something (or there may be a double
> > free if the failure is after `get_unused_fd_flags`) but looks
> > to me to be a memory leak.
>
> Have you tried synthetically reproducing the two failures you're
> thinking of and tracing cleanup?
>
> --
> Jens Axboe
>
