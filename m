Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2EE5236BE
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 17:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243834AbiEKPLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 11:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245619AbiEKPLb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 11:11:31 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB8F5C757
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 08:11:28 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v12so3410291wrv.10
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 08:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ynra/fwZ57AqLb2foGK1nUvHu8nGsV1n1grQhysZz74=;
        b=d+t8B6V9/rDivnEKZQmbIZAm2Ytm2FgRr6A4Tpk7jT7JgeKUz5A+OHiXd8QgdWlF5h
         iddCePbq7jl+rn4DTcfaIhagWdSTrl04nq95GQstz/7Jk0kXgjVUc5M+Js80ZcKMtndk
         vl3xxEB1HsaFDXunrClsmprmNfS/yA39/LM+L26Fwl9fhshz482gJUa/On2Y5OwbvcPn
         8MO6ZsQc3/Cl/AMHCSFGlOksT29nfnhHmMd3gZT6WYrbdsp447512fJI3Q2LZu0+CAzt
         S+PaTmDRPVhP/OpnQqh3pr2+mWd5efkhnMhkhh858g0/uuvTGvb7dzj1JNEk7+/+l9/w
         SqMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ynra/fwZ57AqLb2foGK1nUvHu8nGsV1n1grQhysZz74=;
        b=I1Aoqka8x+xztICOgWcwc1WZf8WOfYt8kYC7xOXI/3ztQZBKglx/P1XQLGqPeBZqzW
         Kzg/MxWXpm5Ikk7HwEHOob9nM52aiXumjrs5rHKrDIbz+oz/KyWGSWdb44hUuEBSESuP
         fShOOmkwDEiAen7gZfP/rUSCGRt/ALeiYfWgOUsEsuB5+g/VPIPBu29RaWgp145Rk6kx
         Sco9UIRSYxCdHE/S7Tgks4damjYYja2J6URPjVV7JpjLRdyTLWVIynGz02Zp8n+EnB9f
         mWCP1/JySSeF1ioU20X7HRKP5b824sCdLbrlQslNkJGPENkadSW925Mg70j3S50eEfct
         HtaA==
X-Gm-Message-State: AOAM530TfJXsoBcVLoSzQf398GxBgtFHwpVf8j2Q0tvUJt4uzAuHdUh/
        GiTzL+YZTnXrLI31ahKJ0s89FTo+ranj2uOVE58=
X-Google-Smtp-Source: ABdhPJzdJaTalOfhP3Dxx75HMAkGgf8LWk4vbC6GXAvBnbFmWvYnH7gCivtOXTff0T7v87NarBMWIhVsbAXo3x3142A=
X-Received: by 2002:adf:fa42:0:b0:20a:e8d6:58b8 with SMTP id
 y2-20020adffa42000000b0020ae8d658b8mr23678372wrr.64.1652281887309; Wed, 11
 May 2022 08:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk> <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
 <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk> <71956172-5406-0636-060d-a7c123a2bfab@kernel.dk>
 <CAAL3td2X4a9RESdSt_xFxNN3mYHBUn88cjbUH9O5wAfL86iB1Q@mail.gmail.com>
In-Reply-To: <CAAL3td2X4a9RESdSt_xFxNN3mYHBUn88cjbUH9O5wAfL86iB1Q@mail.gmail.com>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 11 May 2022 18:11:16 +0300
Message-ID: <CAAL3td2c=pD3v9PypQYAm1FaUuK_mFNVx1z7Z+JKuCGDhnVA2g@mail.gmail.com>
Subject: Re: Short sends returned in IORING
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 11, 2022 at 5:56 PM Constantine Gavrilov
<constantine.gavrilov@gmail.com> wrote:
>
> On Wed, May 4, 2022 at 6:55 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 5/4/22 9:28 AM, Jens Axboe wrote:
> > > On 5/4/22 9:21 AM, Constantine Gavrilov wrote:
> > >> On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >>>
> > >>> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
> > >>>> Jens:
> > >>>>
> > >>>> This is related to the previous thread "Fix MSG_WAITALL for
> > >>>> IORING_OP_RECV/RECVMSG".
> > >>>>
> > >>>> We have a similar issue with TCP socket sends. I see short sends
> > >>>> regarding of the method (I tried write, writev, send, and sendmsg
> > >>>> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
> > >>>> make a difference.
> > >>>>
> > >>>> Most of the time, sends are not short, and I never saw short sends
> > >>>> with loopback and my app. But on real network media, I see short
> > >>>> sends.
> > >>>>
> > >>>> This is a real problem, since because of this it is not possible to
> > >>>> implement queue size of > 1 on a TCP socket, which limits the benefit
> > >>>> of IORING. When we have a short send, the next send in queue will
> > >>>> "corrupt" the stream.
> > >>>>
> > >>>> Can we have complete send before it completes, unless the socket is
> > >>>> disconnected?
> > >>>
> > >>> I'm guessing that this happens because we get a task_work item queued
> > >>> after we've processed some of the send, but not all. What kernel are you
> > >>> using?
> > >>>
> > >>> This:
> > >>>
> > >>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
> > >>>
> > >>> is queued up for 5.19, would be worth trying.
> > >>>
> > >>> --
> > >>> Jens Axboe
> > >>>
> > >>
> > >> Jens:
> > >>
> > >> Thank you for your reply.
> > >>
> > >> The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
> > >> the solution in place, I am wondering whether it will be possible to
> > >> use multiple uring send IOs on the same socket. I expect that Linux
> > >> TCP will serialize multiple send operations on the same socket. I am
> > >> not sure it happens with uring (meaning that socket is blocked for
> > >> processing a new IO until the pending IO completes). Do I need
> > >> IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
> > >> because of multiple different sockets in the same uring. While I
> > >> already have a workaround in the form of a "software" queue for
> > >> streaming data on TCP sockets, I would rather have kernel to do
> > >> "native" queueing in sockets layer, and have exrtra CPU cycles
> > >> available to the  application.
> > >
> > > The patch above will mess with ordering potentially. If the cause is as
> > > I suspect, task_work causing it to think it's signaled, then the better
> > > approach may indeed be to just flush that work and retry without
> > > re-queueing the current one. I can try a patch against 5.18 if you are
> > > willing and able to test?
> >
> > You can try something like this, if you run my for-5.19/io_uring branch.
> > I'd be curious to know if this solves the short send issue for you.
> >
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index f6b6db216478..b835e80be1fa 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -5684,6 +5684,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> >         if (flags & MSG_WAITALL)
> >                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> >
> > +retry:
> >         ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
> >
> >         if (ret < min_ret) {
> > @@ -5694,6 +5695,8 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> >                 if (ret > 0 && io_net_retry(sock, flags)) {
> >                         sr->done_io += ret;
> >                         req->flags |= REQ_F_PARTIAL_IO;
> > +                       if (io_run_task_work())
> > +                               goto retry;
> >                         return io_setup_async_msg(req, kmsg);
> >                 }
> >                 req_set_fail(req);
> > @@ -5744,6 +5747,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
> >                 min_ret = iov_iter_count(&msg.msg_iter);
> >
> >         msg.msg_flags = flags;
> > +retry:
> >         ret = sock_sendmsg(sock, &msg);
> >         if (ret < min_ret) {
> >                 if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
> > @@ -5755,6 +5759,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
> >                         sr->buf += ret;
> >                         sr->done_io += ret;
> >                         req->flags |= REQ_F_PARTIAL_IO;
> > +                       if (io_run_task_work())
> > +                               goto retry;
> >                         return -EAGAIN;
> >                 }
> >                 req_set_fail(req);
> >
> > --
> > Jens Axboe
> >
>
> Jens:
>
> I was able to test the first change on the top of Linus kernel git (5.18.0-rc6).
>
> I do not get short sends anymore, but I get corruption in  sent
> packets (corruption is detected by the receiver). It looks like short
> sends handled by the patch intermix data from multiple send SQEs in
> the stream, so ordering of multiple SQEs in URING becomes broken.
>
> To test it, I had two implementations of the send functions:
> 1. Uses SEND opcode, asserts on short sends. No asserts but data corruption.
> 2. Uses TCP send queue implementation (internally uses SEND and
> SENDMSG opcodes in URING, only one pending send at a time, and tail of
> the short sends is resent until all data is sent). This always works.
>
> I would like to test the second patch now. Is it on the top of the
> first patch or by itself? Do I really need your tree for that? If yes,
> can you send me the git pull info, please?
>
> --
> ----------------------------------------
> Constantine Gavrilov
> Storage Architect
> Master Inventor
> Tel-Aviv IBM Storage Lab
> 1 Azrieli Center, Tel-Aviv
> ----------------------------------------

Jens: for git branch, is it under
git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git?

-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
