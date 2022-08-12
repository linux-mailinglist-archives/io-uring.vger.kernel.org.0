Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E758591761
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbiHLWff (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbiHLWfe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:35:34 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D216F140F5
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:35:32 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id tl27so4241046ejc.1
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=3dffNjg2V0ub9IqECEnMjPuejsK+v8sH/hcA92lXNTc=;
        b=hEZxHTSxBe1hplwyOwm0+i2gkHMpgTNdq52QOu5OXHE2Dnuqb0Iz8m0Vuz4T9wbOKm
         fVVsMc0VJTvjT24VEquLY6eBxrd+Lskz2l0Z684wl6ZwhbtORqNGYBLvDMAVP91HsfmM
         AMXvi4+yxzaEc+J+kxCW+6Br5sdxnDeU7Eea0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=3dffNjg2V0ub9IqECEnMjPuejsK+v8sH/hcA92lXNTc=;
        b=0U4UfSijxolqgzFfhbJFcbuHVKbGpVN/Db7AUYfInZEwxPd6d6kNctDetrPkPxlJ+V
         SxMKUlxiNuzu1gE9yUyNreofYedeVFEMC+Ebxgr8G35BOBHWLR9712j5o9PJVZJoKAbn
         uMix6zg+9CLpK/sCK/9sjARH8btZdTqz/bU3UU/gzHfv4VT5xoy8/zL+f0oWQB/jGamT
         83ozu2IGajjBudibaVirea/8AFwit4g87sVau5U+cLysKDqdufMmA80WAjC9lTV4uTRv
         8xYCBslgLgp+Bf+tpvnZBddvWHviOxDP0E9qrEjRqp4LQo1UUNG1ZL9NMsSEYhGW6o0z
         I3eA==
X-Gm-Message-State: ACgBeo0g/gGbtah9BHpY7b72sJkl8kLjKupY1N+S0Iy+czfxh25JhHff
        WhnPNpP4MihzFoGTZr4AxRzLWZOn7WikQrvs
X-Google-Smtp-Source: AA6agR4Qyg/3YZ+IOP0qQjmXAtSEdKokzpMiMuepP6mlaiWAjJUz+IwcSwYPH0P5Ce/TSsItDe5hTw==
X-Received: by 2002:a17:906:7945:b0:731:2aeb:7941 with SMTP id l5-20020a170906794500b007312aeb7941mr3834385ejo.449.1660343731138;
        Fri, 12 Aug 2022 15:35:31 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id c15-20020aa7d60f000000b0043d6ece495asm2030704edr.55.2022.08.12.15.35.30
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:35:30 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id l22so2535721wrz.7
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:35:30 -0700 (PDT)
X-Received: by 2002:a5d:6248:0:b0:222:cd3b:94c8 with SMTP id
 m8-20020a5d6248000000b00222cd3b94c8mr3196936wrv.97.1660343730228; Fri, 12 Aug
 2022 15:35:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk> <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk> <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk> <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
 <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 15:35:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg0CjDftjxVDGGwfA+rrBsg-nSOsMRS59fAw54W9N53Pw@mail.gmail.com>
Message-ID: <CAHk-=wg0CjDftjxVDGGwfA+rrBsg-nSOsMRS59fAw54W9N53Pw@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Keith Busch <kbusch@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
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

On Fri, Aug 12, 2022 at 3:24 PM Keith Busch <kbusch@kernel.org> wrote:
>
> I'd prefer if we can get away with forcing struct kiocb to not grow. The below
> should have the randomization move the smallest two fields together so we don't
> introduce more padding than necessary:

I like this concept, but I think you might hit issues on 32-bit, where
"loff_t" can be a 64-bit entity with 64-bit alignment, and then you
see the same "oops, now it grew because loff_t moved" there.

Note that you'd never see that on x86-32, because - for strange
historical reasons - even 64-bit fields only have 32-bit alignment,
but other 32-bit architectures don't act that way.

Honestly, I think maybe we should just stop randomizing kiocb.

Because it has six fields, and basically three of them we wouldn't
want to randomly move around.

At some point, randomization no longer even matters.

            Linus
