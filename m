Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5CE51A541
	for <lists+io-uring@lfdr.de>; Wed,  4 May 2022 18:18:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343588AbiEDQWV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 May 2022 12:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbiEDQWV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 May 2022 12:22:21 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7746427B33
        for <io-uring@vger.kernel.org>; Wed,  4 May 2022 09:18:44 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id a14-20020a7bc1ce000000b00393fb52a386so3541702wmj.1
        for <io-uring@vger.kernel.org>; Wed, 04 May 2022 09:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bYWdeMJNl79N/ZTZS13bS15tREueVYW9wdYerkt6B2g=;
        b=VMmKe2t6bu2jBxBD1fA5AAxL5QhjdGD+OixU5CaJ1FnJjGMt8NdF0tQgXlqsKdcTmx
         uBs47Rjp6ETN6Iy30pEkVNA+BiAxF5UP8t2JcPGqYGRlYm+KbsdiHWNPZ1szIEz8/6uX
         YahHzj/Hp7KJSz0t9jaGAvAtUSxQ8sblhWCl3EQrhcT8KNjLswk1+s9UjVhJyxJ8zh0l
         AlPKUd1HKV/ohI/fKN81i9fteO4k7AuQ5KbjwFrCUTCZwN+UqgK5DPNYF4CXloSOFhAa
         wwmPONvs4z6pFoFt6Ru4R4CBK7fZ5k8W1Vltqn0cE9f3ed7RMfXw3qdEcd98+cXNm5Ju
         DALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bYWdeMJNl79N/ZTZS13bS15tREueVYW9wdYerkt6B2g=;
        b=kZY7cfzenvuOLK8LyrbNY4S7KadveZACbKhGCZQm6hObHKG8bvGscV90KDnCtW9jdr
         0KJxR2BSmH6LBMs3Qswq0G3jsIfTNyJpJ/gRjj24uy2XPhuNUKUXCKItdSJqc57zJYqU
         x7Ml3pKGQhmqx3tF4Q5M2UE0iTntntyUXuHTLg+AIM3C+PiSP4RlYSb+uf7pTn6yZ56/
         r89amtH/iD3CP/XEbX+my6N5BSLnGoe37GWmdrk62Z1279Nf2xO6ftb2o4oEAFoaP3lG
         D/GcnshPoUTXU0FYafNMk/Spm/KEJCh4yJpKtFjTXLFZhoPCitIYWIRN9uxJVORiC1gW
         MS7Q==
X-Gm-Message-State: AOAM533kV8g77/yaBQGL87grwGlI5wgI72NALh1Eu2K354eIR3WcKkOt
        yg5TussgZ0nsIZjipna4ggjs6FVb8vJF64IOga1M1MhRuu4=
X-Google-Smtp-Source: ABdhPJzXj9rX4RAoac9uBjHsivIUCZ5p5CaJ8Gia8jaMGKCa3jLZGAHs3nDRyW5MN2bQ0CPUGuuhjau1hy3LuWWIbFI=
X-Received: by 2002:a05:600c:5008:b0:394:533c:54a1 with SMTP id
 n8-20020a05600c500800b00394533c54a1mr166799wmr.15.1651681122855; Wed, 04 May
 2022 09:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
In-Reply-To: <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 4 May 2022 19:18:30 +0300
Message-ID: <CAAL3td0Df0nh63E=COpjG8c31pLTMxOYhjJNqOikjcSAVu+6Qw@mail.gmail.com>
Subject: Re: Short sends returned in IORING
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
> > Jens:
> >
> > This is related to the previous thread "Fix MSG_WAITALL for
> > IORING_OP_RECV/RECVMSG".
> >
> > We have a similar issue with TCP socket sends. I see short sends
> > regarding of the method (I tried write, writev, send, and sendmsg
> > opcodes, while using MSG_WAITALL for send and sendmsg). It does not
> > make a difference.
> >
> > Most of the time, sends are not short, and I never saw short sends
> > with loopback and my app. But on real network media, I see short
> > sends.
> >
> > This is a real problem, since because of this it is not possible to
> > implement queue size of > 1 on a TCP socket, which limits the benefit
> > of IORING. When we have a short send, the next send in queue will
> > "corrupt" the stream.
> >
> > Can we have complete send before it completes, unless the socket is
> > disconnected?
>
> I'm guessing that this happens because we get a task_work item queued
> after we've processed some of the send, but not all. What kernel are you
> using?
>
> This:
>
> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
>
> is queued up for 5.19, would be worth trying.
>
> --
> Jens Axboe
>

Jens:

I am OK testing this. Any kernel is fine, the moment I need to build
it. So, whatever is closer to your branch, is probably better.

I am going on vacation for the weekend, and will be able to give it a
try next week.

-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
