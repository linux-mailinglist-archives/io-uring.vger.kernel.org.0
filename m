Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05769567F9E
	for <lists+io-uring@lfdr.de>; Wed,  6 Jul 2022 09:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiGFHQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jul 2022 03:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiGFHQR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jul 2022 03:16:17 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF402229E
        for <io-uring@vger.kernel.org>; Wed,  6 Jul 2022 00:16:16 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l11so25830480ybu.13
        for <io-uring@vger.kernel.org>; Wed, 06 Jul 2022 00:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKqBn4LHqHQz+7eiTYx6Guo+XYS+/p+1Z90N9l9lsqc=;
        b=Xa8Xs+3KIfbAIuZ5qKrFg7h2ojPkVj4b0IbDW9UrgjzSQsGtCG/5Cq4UaOBwma6Ha4
         rwg6TtdtYujxjq9RCK2o4vC9Oz2pmRSAMqhqLJNSGodlYWKIQM1nQl6kT4LkdEkTsPQt
         ZYhFcyh0TX4fH6LearuPYG/u+u//9+cZLgo8WOA0S0f9ri7Pk1syR4gxXMghVGYwsPxk
         DjRf65Pc5rpUJKIG4/qznihl8VBCn77obuPS7S0hWUAhSEchgSUEAcf3AQccNR9lsFHT
         06P2LU4DI7zJDmBiEmC23fFwfgBEzy9VTwxTRwOZ2T1Co+mxrhWhzupm7xLxvNuUJ87D
         oQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XKqBn4LHqHQz+7eiTYx6Guo+XYS+/p+1Z90N9l9lsqc=;
        b=3LryOODNH1mgwTZLCkf+pjch3nn2cE1MZRCnstj0XSMFDT9jHBwWEiW0424WiB9cxi
         r1M/vP2xm2K2C+r4nuwcu7KnX3sEZvltKj7QDaNrUs260+Bf1SolQwW8anVzShhFhPmI
         y9GEqxvJ9iYKSDLy1xkq2StM48+bOIwdMgrNy+LL7yW3F1IhvYqHTec+ayLWGwxPbzGA
         MyEP+ILew2msFnCcG9+wmyAcofAUUhbl9GAecac0fl+N5cVc3zIaFS1oZbWLg8/8t1Bk
         FCHEp0qakvM3CYYTnZFPcrtkzzMmlmxaZ9adom/gPXgBzLxYomY9mb7W3OoXK221m9r5
         qkjA==
X-Gm-Message-State: AJIora+ua58VfezvhY57NnFsyMzPGFfJonrV0jp9fZIo1t55lCeqKiYs
        RQ3/c5KYmyQTPmDebhV163/eLkC8i0AvrSHoNdg=
X-Google-Smtp-Source: AGRyM1uwinWDvG9yfzq/egIWqu32fFebRZsYA+tc+QZIO1OuEQtJlGxGvKZyYrLwZJQB4NWIyi3FVnfjB5Gcy1L09ss=
X-Received: by 2002:a25:f81e:0:b0:66e:30d4:a31 with SMTP id
 u30-20020a25f81e000000b0066e30d40a31mr21467901ybd.209.1657091775336; Wed, 06
 Jul 2022 00:16:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220629044957.1998430-1-dominique.martinet@atmark-techno.com>
 <20220630010137.2518851-1-dominique.martinet@atmark-techno.com>
 <20220630154921.ekl45dzer6x4mkvi@sgarzare-redhat> <Yr4pLwz5vQJhmvki@atmark-techno.com>
 <YsQ8aM3/ZT+Bs7nC@stefanha-x1.localdomain> <e9bbbeb5-c6b9-8d19-9593-b2c9187a5d98@kernel.dk>
In-Reply-To: <e9bbbeb5-c6b9-8d19-9593-b2c9187a5d98@kernel.dk>
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Wed, 6 Jul 2022 08:16:02 +0100
Message-ID: <CAJSP0QWnw7q_TScW+3g+jwYpjRX922cL4KafUit5oFNWtqRvfA@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: fix short read slow path
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>,
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

On Tue, 5 Jul 2022 at 20:26, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/5/22 7:28 AM, Stefan Hajnoczi wrote:
> > On Fri, Jul 01, 2022 at 07:52:31AM +0900, Dominique Martinet wrote:
> >> Stefano Garzarella wrote on Thu, Jun 30, 2022 at 05:49:21PM +0200:
> >>>> so when we ask for more we issue an extra short reads, making sure we go
> >>>> through the two short reads path.
> >>>> (Unfortunately I wasn't quite sure what to fiddle with to issue short
> >>>> reads in the first place, I tried cutting one of the iovs short in
> >>>> luring_do_submit() but I must not have been doing it properly as I ended
> >>>> up with 0 return values which are handled by filling in with 0 (reads
> >>>> after eof) and that didn't work well)
> >>>
> >>> Do you remember the kernel version where you first saw these problems?
> >>
> >> Since you're quoting my paragraph about testing two short reads, I've
> >> never seen any that I know of; but there's also no reason these couldn't
> >> happen.
> >>
> >> Single short reads have been happening for me with O_DIRECT (cache=none)
> >> on btrfs for a while, but unfortunately I cannot remember which was the
> >> first kernel I've seen this on -- I think rather than a kernel update it
> >> was due to file manipulations that made the file eligible for short
> >> reads in the first place (I started running deduplication on the backing
> >> file)
> >>
> >> The older kernel I have installed right now is 5.16 and that can
> >> reproduce it --  I'll give my laptop some work over the weekend to test
> >> still maintained stable branches if that's useful.
> >
> > Hi Dominique,
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
> In general we try very hard to avoid them, but if eg we get a short read
> or write from blocking context (eg io-wq), then io_uring does return
> that. There's really not much we can do here, it seems futile to retry
> IO which was issued just like it would've been from a normal blocking
> syscall yet it is still short.

Thanks! QEMU's short I/O handling is spotty - some code paths handle
it while others don't. For the io_uring QEMU block driver we'll try to
handle short all I/Os.

Stefan
