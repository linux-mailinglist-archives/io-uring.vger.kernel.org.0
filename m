Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146226F9A54
	for <lists+io-uring@lfdr.de>; Sun,  7 May 2023 18:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjEGQ7o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 May 2023 12:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjEGQ7o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 May 2023 12:59:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F01556A6B
        for <io-uring@vger.kernel.org>; Sun,  7 May 2023 09:59:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so42179622a12.1
        for <io-uring@vger.kernel.org>; Sun, 07 May 2023 09:59:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1683478781; x=1686070781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrU99Wzlx5pDLqVoQ5ze9VZNnGrzSg3dBG+jNGs1DYc=;
        b=PztxMZtAly3hdu6MNG6v79DMEHEKjUea57/cilU5fLJg94NXDuHrdZm+CaXwhZLoJX
         iJLvG6XQ//qOUl1FQG1Gp9ZzfsDkZ/8wEgIkldvQVlSR1P5xIqIpLJfdN4u/eYIdkoss
         9MUDwj0OWg+xyurdoC0AH19bpx1mCr4fBSmq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683478781; x=1686070781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrU99Wzlx5pDLqVoQ5ze9VZNnGrzSg3dBG+jNGs1DYc=;
        b=Wfl3I7xDnvC1C4bKR0ERXGFJsU5t5tLhpBoaxTMLh7TxL3OZnaZjwHZLw7BTj2owzu
         1rGNP3xnn5oVQ9nLkB5tXlMpfAVy1Q+sMojDcFmoiMQY9DixiNBvtixLQfkwEmelk9Tf
         pisQnkbUCS02UM5ALv8b1sXEvA+bluqvPunw9N1uycFyCIhqxLmXwDh6TanQ452lo6nk
         z3FoQRuAJIxvdqwabDqIJYg3d/bLzsJqBGjo/U4Oc+nHL5TLZrAPvW6XW9yKamwHW6Vq
         z90eIVm+eFWTqogYiLCquskDCx7vEtXsiTlTc6i7kF1qLglFaew8QuLcKynl/EYrorMd
         AIBw==
X-Gm-Message-State: AC+VfDxB3m16iyuQ2s9w33IV2jkG3ylkVrLUSr08Zf1xwbGWFkdeKht0
        xARo0khT0QRUNAWAs21nJvcWWGOvi1KaDpoZW5BP4A==
X-Google-Smtp-Source: ACHHUZ5ZBCblIsmFCzXta9uXIM/G/+bBGsqaGF0J0a9gbHu2GXWllmqa2YfwZUTZ/YqdnG1favIShg==
X-Received: by 2002:a17:907:720b:b0:94e:ec0f:5f70 with SMTP id dr11-20020a170907720b00b0094eec0f5f70mr7815911ejc.10.1683478781069;
        Sun, 07 May 2023 09:59:41 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id d1-20020a170907272100b00967004187b8sm69024ejl.36.2023.05.07.09.59.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 May 2023 09:59:40 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-50bd2d7ba74so42179527a12.1
        for <io-uring@vger.kernel.org>; Sun, 07 May 2023 09:59:40 -0700 (PDT)
X-Received: by 2002:a17:907:3e2a:b0:966:4973:b35 with SMTP id
 hp42-20020a1709073e2a00b0096649730b35mr1738079ejc.22.1683478780212; Sun, 07
 May 2023 09:59:40 -0700 (PDT)
MIME-Version: 1.0
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
In-Reply-To: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 7 May 2023 09:59:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjvZQeXHUDUJZKJnej+cLvq8OdkFifg1McWLmrHo=Y_0w@mail.gmail.com>
Message-ID: <CAHk-=wjvZQeXHUDUJZKJnej+cLvq8OdkFifg1McWLmrHo=Y_0w@mail.gmail.com>
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 7, 2023 at 5:00=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Note that this will throw a merge conflict in the ublk_drv code, due
> to this branch still being based off the original for-6.4/io_uring
> branch. Resolution is pretty straight forward, I'm including it below
> for reference.

Mine is somewhat different - I think the "ub_cmd" argument to
__ublk_ch_uring_cmd() should also have been made a 'const' pointer.

And then using an actual initializer allows us to do the same thing
for the copy in ublk_ch_uring_cmd() (and also makes it clear that it
initializes the whole struct - which it did, but still...)

So my conflict resolution looks a bit more complicated, but I think
it's the RightThing(tm) to do, and is consistent with the
constification in commit fd9b8547bc5c ("io_uring: Pass whole sqe to
commands").

                Linus
