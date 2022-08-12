Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D19225916EC
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 23:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiHLVzA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 17:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiHLVyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 17:54:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119A9B2854
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:54:42 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i14so4098700ejg.6
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=nwmKbcBEytj9jFqQePuZtYEe1WUFGZM+0dSqkjlYfxw=;
        b=BNw3esQMYWkcldA8TF7M/KZPdj1M0QuFno0V8xosBQwbW6vmKRuhWUfPBDsj1YDDSk
         5f3dY4u9BgftNwAg+lJ7HR6qWITA2dyMOOsfeAKIdhVKOdFjmn0C/EzYqCGPpuz6UN9+
         5TR9cjLSMUVa2YbSlPhZGW3wgTO2eS+yyR/R0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=nwmKbcBEytj9jFqQePuZtYEe1WUFGZM+0dSqkjlYfxw=;
        b=YL5OyXVGCl0S4p/Ntd267I8wOD5sZUsuAXpq6x+eYacK5MwD2wbc5MWKu3L7OzJ6nk
         qUWQ82SMGTICuO3RcHk+so9bocjvnA2WCEJKy7Hl/nkkYmM0QtGDwle1xJhggrhEM1j/
         BK8xeNXBeozH5Dl/esLNne7NaYjI/r8dPH8vT7SQHl2Sw8fpID3I3AIvUTtP9G5rLses
         suHgLjS45W6A6xYjHjrAbvBkcNrbFZS2BB98NdYOg+sXTQ1imumflox1XbK+vUNQw8Cp
         7T8G4jP6oRt5LNN10RTjSJA6L4flQR+ZLS2fmtUpsWiwovd4o3S+JCkTBZSXilT1coVk
         K+aQ==
X-Gm-Message-State: ACgBeo0MESXksXqeHsJwwPYZjdwuT4E1JX+CSdThfrcT39csuBPMYlKC
        xrvmLrR3yfXd8BgWHDnwT5lsVxlJaeX2TBsH
X-Google-Smtp-Source: AA6agR7x3xWrEAt7SKszwqhsZfObq4regUhUzbtc12urHdU9e1Tao7imusABQmjF45flRI+CoKrPfw==
X-Received: by 2002:a17:907:72d1:b0:730:a0c4:2aaa with SMTP id du17-20020a17090772d100b00730a0c42aaamr3713127ejc.560.1660341280384;
        Fri, 12 Aug 2022 14:54:40 -0700 (PDT)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com. [209.85.128.53])
        by smtp.gmail.com with ESMTPSA id qx8-20020a170906fcc800b0073075451398sm1243827ejb.17.2022.08.12.14.54.39
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 14:54:39 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id v5so1146671wmj.0
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:54:39 -0700 (PDT)
X-Received: by 2002:a1c:2582:0:b0:3a5:1453:ca55 with SMTP id
 l124-20020a1c2582000000b003a51453ca55mr9703699wml.68.1660341279473; Fri, 12
 Aug 2022 14:54:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk> <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk> <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
In-Reply-To: <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Aug 2022 14:54:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
Message-ID: <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 12, 2022 at 2:43 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I think was seeing others (I got hundreds of lines or errors), but now
> that I've blown things away I can't recreate it. My allmodconfig build
> just completed with no sign of the errors I saw earlier.

Oh, and immediately after sending that email,  I got the errors back.

Because of the randstruct issue, I did another "git clean" (to make
sure the random seed was gone and recreated) and started a new
allmodconfig build.

And now I see the error again.

It does seem to be only 'struct io_cmd_data', but since this seems to
be about random layout, who knows. The "hundreds of lines" is because
each error report ends up being something like 25 lines in size, so
you don't need a lot of them to get lots and lots of lines.

The ones I see in my *current* build are all that

  496 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));

add there's apparently six of them (so the "hundreds of lines" was
apparently "only" 150 lines of errors), here's the concise "inlined
from" info:

    inlined from =E2=80=98io_prep_rw=E2=80=99 at io_uring/rw.c:38:21:
    inlined from =E2=80=98__io_import_iovec=E2=80=99 at io_uring/rw.c:353:2=
1,
    inlined from =E2=80=98io_import_iovec=E2=80=99 at io_uring/rw.c:406:11,
    inlined from =E2=80=98io_rw_prep_async=E2=80=99 at io_uring/rw.c:538:8,
    inlined from =E2=80=98io_readv_prep_async=E2=80=99 at io_uring/rw.c:551=
:9:
    inlined from =E2=80=98io_read=E2=80=99 at io_uring/rw.c:697:21:
    inlined from =E2=80=98io_write=E2=80=99 at io_uring/rw.c:842:21:
    inlined from =E2=80=98io_do_iopoll=E2=80=99 at io_uring/rw.c:997:22:

in case that helps.

Anyway, the way to recreate this is apparently

 (a) make sure you have the gcc plugins enabled

 (b) do "git clean -dqfx" between builds

 (c) do "make allmodconfig ; make -j64" until you see it.

I don't know what the chance of it happening is, but I'm starting my
fourth iteration, and I am just now seen it for the third time.

So it seems fairly easy to trigger, even if it's not 100%.

And yes, on this latest case it was once again "struct io_cmd_data".

So I think that may be the only case.

              Linus
