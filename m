Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32B1567FA7
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 09:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiGFHR4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jul 2022 03:17:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiGFHR4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jul 2022 03:17:56 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA41222AE
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 00:17:54 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-31c8a1e9e33so78813147b3.5
        for <io-uring@vger.kernel.org>; Wed, 06 Jul 2022 00:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zDHTdM4H5Ec/fs1JKO+lzsSXVN2A2uCcsN1/QQB/f8A=;
        b=Tiv0usmVgwJsGsdC53WYWI/67yyTEDgZzIUS62504w/Z7akuDBys7lNPuyyNO57r+a
         I0Ar54m1eN7cgq6ZdGXoepjthh6Va/8k8pE2HiZlvBSrdtbXdJJ3205Jxs/ZYSRObcxc
         hXyBWerPlyI7KmCZ3Q3nxQHH35nfxUfeNgm6yXada/6V+aPQMeOle74I4gIzwmUuqkpH
         gsQZcmy5Hr3/izifPRK11eBiLfrtIcWBjOWhkE9yDvHgcjWE80wPyeKXA/T3SB++Kbck
         CyY6z3mKUOvuoboyK2j3Mq4tq8bSrbQeviZAnfGWwbXRqVyyDbb7ZjNEXnqTvdsW3hun
         InVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zDHTdM4H5Ec/fs1JKO+lzsSXVN2A2uCcsN1/QQB/f8A=;
        b=Neu7VQa979ZtFUqfIscHW/N5fRBCpuwYXPH9eEBzyC4D6wfdF+X+gFHrZrsyyovkwt
         m/7yT544+xnbh5wWAbn1GUJMWDlsNj95QkwZx0V5H19nZbP+/68SdcEILkWvRvPrn102
         gpmDB3w4xhx4DForNtJUixP0XmAvPWDQdOisEJVRHjdYsJGsKyImR1M1m0ZxCQHifRYa
         Glu5B60c70KBNaLJk2vDJF/zQ+Qak6QeQ/spUHcbzpf2v5tLCVlHAwnNcepgTqUWxWyU
         swhP0bqyp+Qf7fQnohj5LiE5xxhcD0RTrI2+OZ7p1rhiop4Z5xbnviZv2KGf+fXlPmKM
         KtHw==
X-Gm-Message-State: AJIora8mFu/s/3yMneasT2splEHNUXcKYm7zHRUHSvN+3jPkuQ31ne2N
        hcYreZf+ifovBiLWPnYftFHEVLAco3x8HqbYu3Y=
X-Google-Smtp-Source: AGRyM1uHIYYTBwWG0GBYC6oLCOnAUYcu74NeU1Y9GYD0TT4aukgOP7RdblGANfnPOIwhFDMxV4Kc4L/iHmBnzhHlCqA=
X-Received: by 2002:a0d:d993:0:b0:31c:b46e:ee9c with SMTP id
 b141-20020a0dd993000000b0031cb46eee9cmr11939100ywe.296.1657091874010; Wed, 06
 Jul 2022 00:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat> <Yr4pLwz5vQJhmvki@atmark-techno.com>
 <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain> <YsTAxtvpvIIi8q7M@atmark-techno.com>
In-Reply-To: <YsTAxtvpvIIi8q7M@atmark-techno.com>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 6 Jul 2022 08:17:42 +0100
Message-ID: <CAJSP0QUg5g6SDCy52carWRbVUFBhrAoiezinPdfhEOAKNwrN3g@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: fix short read slow path
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Julia Suvorova <jusual@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        qemu block <qemu-block@nongnu.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        Filipe Manana <fdmanana@kernel.org>, io-uring@vger.kernel.org
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

On Tue, 5 Jul 2022 at 23:53, Dominique Martinet
<dominique.martinet@atmark-techno.com> wrote:
>
> Stefan Hajnoczi wrote on Tue, Jul 05, 2022 at 02:28:08PM +0100:
> > > The older kernel I have installed right now is 5.16 and that can
> > > reproduce it --  I'll give my laptop some work over the weekend to test
> > > still maintained stable branches if that's useful.
> >
> > Linux 5.16 contains commit 9d93a3f5a0c ("io_uring: punt short reads to
> > async context"). The comment above QEMU's luring_resubmit_short_read()
> > claims that short reads are a bug that was fixed by Linux commit
> > 9d93a3f5a0c.
> >
> > If the comment is inaccurate it needs to be fixed. Maybe short writes
> > need to be handled too.
> >
> > I have CCed Jens and the io_uring mailing list to clarify:
> > 1. Are short IORING_OP_READV reads possible on files/block devices?
> > 2. Are short IORING_OP_WRITEV writes possible on files/block devices?
>
> Jens replied before me, so I won't be adding much (I agree with his
> reply -- linux tries hard to avoid short reads but we should assume they
> can happen)
>
> In this particular case it was another btrfs bug with O_DIRECT and mixed
> compression in a file, that's been fixed by this patch:
> https://lore.kernel.org/all/20220630151038.GA459423@falcondesktop/
>
> queued here:
> https://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git/commit/?h=dio_fixes&id=b3864441547e49a69d45c7771aa8cc5e595d18fc
>
> It should be backported to 5.10, but the problem will likely persist in
> 5.4 kernels if anyone runs on that as the code changed enough to make
> backporting non-trivial.
>
>
> So, WRT that comment, we probably should remove the reference to that
> commit and leave in that they should be very rare but we need to handle
> them anyway.
>
>
> For writes in particular, I haven't seen any and looking at the code
> qemu would blow up that storage (IO treated as ENOSPC would likely mark
> disk read-only?)
> It might make sense to add some warning message that it's what happened
> so it'll be obvious what needs doing in case anyone falls on that but I
> think the status-quo is good enough here.

Great! I've already queued your fix.

Do you want to send a follow-up that updates the comment?

Thanks,
Stefan
