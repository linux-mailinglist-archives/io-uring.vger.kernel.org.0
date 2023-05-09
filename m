Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60B706FBD54
	for <lists+io-uring@lfdr.de>; Tue,  9 May 2023 04:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjEICfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 May 2023 22:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjEICfO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 May 2023 22:35:14 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54DA18D
        for <io-uring@vger.kernel.org>; Mon,  8 May 2023 19:35:12 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id ada2fe7eead31-43479152cd0so1318526137.1
        for <io-uring@vger.kernel.org>; Mon, 08 May 2023 19:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1683599712; x=1686191712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yritB4z6Kqy8r2lo349eyuC/ueDu/IfImR1iz6M8Adk=;
        b=Za9xxhlzJALA12W2xTNNfS4Ws39Ff0F9agUXnb9JqmK21argGiU7ikCEmspRw6uCMk
         G3WnuKbcXJ7bFZQhwA4XO/xzU5NaARhaioTva2PrYd9qurMKJTNq67MHmpphBo8MUBK/
         LPrp9SUp5c0svKgp0GpsyBba/ARFEZkjRsjX4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683599712; x=1686191712;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yritB4z6Kqy8r2lo349eyuC/ueDu/IfImR1iz6M8Adk=;
        b=JDLCdTyUgHttWafhDtGp0gCFU0Sim1IIdraI/aYyPpLK7tULs/cpmobMDjhs2O2C3y
         qQglEZhaltKGfyTyq913VD8hXOGM1tqxtDPu9TkWDoNRphoyGeZRNBVnWF00RbntM5O3
         I2Ai4X4ZAE9ykGu2V5P9ecZZKPYtzHbVVBdLnUy33E+bT8XLb9+qVctA8RjfEV/xnrsO
         h6lPvMkQctrq3cBUjs4CeVJwCzUnk1Q+lCYICqfjdJcVCU+kK1t30ePVgWYN9sue2aOL
         kFltxxSk8g0HYMxZLEsrPv+4zNouZ4kckZTwVNX1q4C5eGzDShH6oMkBvBrOWuwunF/u
         iaKg==
X-Gm-Message-State: AC+VfDye6Ux/9bBffOvc2/ZNQvyJM6wDquWVHzGHhWDGdwuPqBRlukQX
        lpgBvv2FeyZ0Y1iU3Jt5UZvCGnMLDz5n0LuZ/xBcqQ==
X-Google-Smtp-Source: ACHHUZ43QicLmkfhH+oYvAXYrxdNOv42T+rZkBbCVZnxjLF94cGhsyXNXvAbH/yolD5ycizlZzmGm5mX2sje4ri8X/Y=
X-Received: by 2002:a67:ce13:0:b0:42c:7df3:ca0a with SMTP id
 s19-20020a67ce13000000b0042c7df3ca0amr4149891vsl.17.1683599711858; Mon, 08
 May 2023 19:35:11 -0700 (PDT)
MIME-Version: 1.0
References: <9b2e791d-aeba-a2c7-1877-797ff5c680a3@kernel.dk>
 <20230508031852.GA4029098@google.com> <fb84f054-517c-77d4-eb11-d3df61f53701@kernel.dk>
In-Reply-To: <fb84f054-517c-77d4-eb11-d3df61f53701@kernel.dk>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Tue, 9 May 2023 10:35:00 +0800
Message-ID: <CAGXv+5GpeJ8hWt2Sc6L+4GB-ghA4vESobEaFGpo1_ZyPhOvW0g@mail.gmail.com>
Subject: Re: [GIT PULL] Final io_uring updates for 6.4-rc1
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,URIBL_CSS_A
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 9, 2023 at 2:42=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/7/23 9:18?PM, Chen-Yu Tsai wrote:
> > Hi,
> >
> > On Sun, May 07, 2023 at 06:00:48AM -0600, Jens Axboe wrote:
> >> Hi Linus,
> >>
> >> Nothing major in here, just two different parts:
> >>
> >> - Small series from Breno that enables passing the full SQE down
> >>   for ->uring_cmd(). This is a prerequisite for enabling full network
> >>   socket operations. Queued up a bit late because of some stylistic
> >>   concerns that got resolved, would be nice to have this in 6.4-rc1
> >>   so the dependent work will be easier to handle for 6.5.
> >>
> >> - Fix for the huge page coalescing, which was a regression introduced
> >>   in the 6.3 kernel release (Tobias).
> >>
> >> Note that this will throw a merge conflict in the ublk_drv code, due
> >> to this branch still being based off the original for-6.4/io_uring
> >> branch. Resolution is pretty straight forward, I'm including it below
> >> for reference.
> >>
> >> Please pull!
> >>
> >>
> >> The following changes since commit 3c85cc43c8e7855d202da184baf00c7b8ee=
acf71:
> >>
> >>   Revert "io_uring/rsrc: disallow multi-source reg buffers" (2023-04-2=
0 06:51:48 -0600)
> >>
> >> are available in the Git repository at:
> >>
> >>   git://git.kernel.dk/linux.git tags/for-6.4/io_uring-2023-05-07
> >>
> >> for you to fetch changes up to d2b7fa6174bc4260e496cbf84375c7363691464=
1:
> >>
> >>   io_uring: Remove unnecessary BUILD_BUG_ON (2023-05-04 08:19:05 -0600=
)
> >>
> >> ----------------------------------------------------------------
> >> for-6.4/io_uring-2023-05-07
> >>
> >> ----------------------------------------------------------------
> >> Breno Leitao (3):
> >>       io_uring: Create a helper to return the SQE size
> >>       io_uring: Pass whole sqe to commands
> >
> > This commit causes broken builds when IO_URING=3Dn and NVME_CORE=3Dy, a=
s
> > io_uring_sqe_cmd(), called in drivers/nvme/host/ioctl.c, ends up being
> > undefined. This was also reported [1] by 0-day bot on your branch
> > yesterday, but it's worse now that Linus merged the pull request.
> >
> > Not sure what the better fix would be. Move io_uring_sqe_cmd() outside
> > of the "#if defined(CONFIG_IO_URING)" block?
>
> Queued up a patch for this:
>
> https://git.kernel.dk/cgit/linux/commit/?h=3Dio_uring-6.4&id=3D5d371b2f2b=
0d1a047582563ee36af8ffb5022847

Thanks! Looks like the Reported-by line for the test bot is missing a right
angle bracket?

Also, consider it

Tested-by: Chen-Yu Tsai <wenst@chromium.org>
