Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F0B52375E
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 17:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343740AbiEKPdd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 11:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240224AbiEKPdc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 11:33:32 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F200E606D5
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 08:33:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s15so2234016wrb.7
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 08:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Cc3KEWaK+AgyxqFvCwjWit63f2zExzc7zFfdAOwvbuM=;
        b=XQxQGpZDWKvXQkNaG8A8unIhe9Tvr56+jJ6wM5qyqRG3ce2j2DFAfmdv5Pxc5MvGNM
         qHTTZCbGRMJLseAcYOoAyoXW3EaO0/uU5X174YsYxX1wrWLHThdA28uyEp6MewQ9Ebv9
         bboU4uOdicl3ZYklCwnblI7NFUwqcOjcIbQUrEjoEwgb9dDGeb8tw5QMUqdvf4CwBYvl
         sEeqUNmrgFzZywgofKskpxob+gll/wpcb9vL63+LFSzGUbSk9u7Z4KfFdpEIQhuJIs9O
         Ur/ijWdWnUrREPT2mRXexJcGzjlXq3PBKzsrpVV6MV58u0avyqFV0lDM+rlBdq1xF284
         x2Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Cc3KEWaK+AgyxqFvCwjWit63f2zExzc7zFfdAOwvbuM=;
        b=agS3+mwLNK8e5FmIdw0H+X+R1vZ43VseGLtDRi4zWhLKkKg0hebWs37ODHs9SpO028
         gyunT8x+BNgXU0WKudOMPROZFLG+85kisFboVNZySWTDWHGJKveQOLNmMKzKOm49UXQD
         oTP383RyKw7UI7+ubPz/7Tq8CwBJsoxFJyhv9p4I6ch/rO07RqwjvEv5x8rjVq8KTPp4
         Vxg8O4/e4UZsfT3iaLA8nNwXibxlysdwxSLJ2AtXlxeSYCxWlGS3NtT82RvyCrGefhLG
         NxX1uVmsoKe22EsfVRe2ymGrOtKOwcwHjs3jbrRoWxJQq/ErZTeqlHVFnq3ojT7tidM3
         bk9Q==
X-Gm-Message-State: AOAM531FojIDAVrCva/LM9Q8LteANGKIe4AhtygVTC68rfe3+gP4AtCx
        dhKRjSrhiUGGir+/NaCbhluWZ328y01zB3JtNXhkyezn
X-Google-Smtp-Source: ABdhPJyaZaUm9eG7hYvOCfHIy3bfkzL0ibJQl73B9oTN6IPN3dFEmVmccnLK/xv9CVhXboR2qtLdxA2/0VnPjTE5Lv4=
X-Received: by 2002:a5d:44cf:0:b0:20a:c5d2:b6c3 with SMTP id
 z15-20020a5d44cf000000b0020ac5d2b6c3mr23355321wrr.177.1652283209516; Wed, 11
 May 2022 08:33:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAAL3td0UD3Ht-rCpR5xUfmOLzeEzRSedCVXH4nTQKLR1b16+vA@mail.gmail.com>
 <6fc53990-1814-a45d-7c05-a4385246406c@kernel.dk> <CAAL3td3Em=MBPa9iJitYTAkndymzuj2DbSnbQRf=0Emsr5qHVw@mail.gmail.com>
 <744d4b58-e7df-a5fb-dfba-77fe952fe1f8@kernel.dk> <71956172-5406-0636-060d-a7c123a2bfab@kernel.dk>
 <CAAL3td2X4a9RESdSt_xFxNN3mYHBUn88cjbUH9O5wAfL86iB1Q@mail.gmail.com> <CAAL3td2c=pD3v9PypQYAm1FaUuK_mFNVx1z7Z+JKuCGDhnVA2g@mail.gmail.com>
In-Reply-To: <CAAL3td2c=pD3v9PypQYAm1FaUuK_mFNVx1z7Z+JKuCGDhnVA2g@mail.gmail.com>
From:   Constantine Gavrilov <constantine.gavrilov@gmail.com>
Date:   Wed, 11 May 2022 18:33:18 +0300
Message-ID: <CAAL3td2TwrQft6hsFa_dMae=6wwRTK+4W3pt5JwhtC8zUbvxCg@mail.gmail.com>
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

On Wed, May 11, 2022 at 6:11 PM Constantine Gavrilov
<constantine.gavrilov@gmail.com> wrote:
>
> On Wed, May 11, 2022 at 5:56 PM Constantine Gavrilov
> <constantine.gavrilov@gmail.com> wrote:
> >
> > On Wed, May 4, 2022 at 6:55 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >
> > > On 5/4/22 9:28 AM, Jens Axboe wrote:
> > > > On 5/4/22 9:21 AM, Constantine Gavrilov wrote:
> > > >> On Wed, May 4, 2022 at 4:54 PM Jens Axboe <axboe@kernel.dk> wrote:
> > > >>>
> > > >>> On 5/3/22 5:05 PM, Constantine Gavrilov wrote:
> > > >>>> Jens:
> > > >>>>
> > > >>>> This is related to the previous thread "Fix MSG_WAITALL for
> > > >>>> IORING_OP_RECV/RECVMSG".
> > > >>>>
> > > >>>> We have a similar issue with TCP socket sends. I see short sends
> > > >>>> regarding of the method (I tried write, writev, send, and sendmsg
> > > >>>> opcodes, while using MSG_WAITALL for send and sendmsg). It does not
> > > >>>> make a difference.
> > > >>>>
> > > >>>> Most of the time, sends are not short, and I never saw short sends
> > > >>>> with loopback and my app. But on real network media, I see short
> > > >>>> sends.
> > > >>>>
> > > >>>> This is a real problem, since because of this it is not possible to
> > > >>>> implement queue size of > 1 on a TCP socket, which limits the benefit
> > > >>>> of IORING. When we have a short send, the next send in queue will
> > > >>>> "corrupt" the stream.
> > > >>>>
> > > >>>> Can we have complete send before it completes, unless the socket is
> > > >>>> disconnected?
> > > >>>
> > > >>> I'm guessing that this happens because we get a task_work item queued
> > > >>> after we've processed some of the send, but not all. What kernel are you
> > > >>> using?
> > > >>>
> > > >>> This:
> > > >>>
> > > >>> https://git.kernel.dk/cgit/linux-block/commit/?h=for-5.19/io_uring&id=4c3c09439c08b03d9503df0ca4c7619c5842892e
> > > >>>
> > > >>> is queued up for 5.19, would be worth trying.
> > > >>>
> > > >>> --
> > > >>> Jens Axboe
> > > >>>
> > > >>
> > > >> Jens:
> > > >>
> > > >> Thank you for your reply.
> > > >>
> > > >> The kernel is 5.17.4-200.fc35.x86_64. I have looked at the patch. With
> > > >> the solution in place, I am wondering whether it will be possible to
> > > >> use multiple uring send IOs on the same socket. I expect that Linux
> > > >> TCP will serialize multiple send operations on the same socket. I am
> > > >> not sure it happens with uring (meaning that socket is blocked for
> > > >> processing a new IO until the pending IO completes). Do I need
> > > >> IOSQE_IO_DRAIN / IOSQE_IO_LINK for this to work? Would not be optimal
> > > >> because of multiple different sockets in the same uring. While I
> > > >> already have a workaround in the form of a "software" queue for
> > > >> streaming data on TCP sockets, I would rather have kernel to do
> > > >> "native" queueing in sockets layer, and have exrtra CPU cycles
> > > >> available to the  application.
> > > >
> > > > The patch above will mess with ordering potentially. If the cause is as
> > > > I suspect, task_work causing it to think it's signaled, then the better
> > > > approach may indeed be to just flush that work and retry without
> > > > re-queueing the current one. I can try a patch against 5.18 if you are
> > > > willing and able to test?
> > >
> > > You can try something like this, if you run my for-5.19/io_uring branch.
> > > I'd be curious to know if this solves the short send issue for you.
> > >
> > >
> > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > index f6b6db216478..b835e80be1fa 100644
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -5684,6 +5684,7 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> > >         if (flags & MSG_WAITALL)
> > >                 min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> > >
> > > +retry:
> > >         ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
> > >
> > >         if (ret < min_ret) {
> > > @@ -5694,6 +5695,8 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
> > >                 if (ret > 0 && io_net_retry(sock, flags)) {
> > >                         sr->done_io += ret;
> > >                         req->flags |= REQ_F_PARTIAL_IO;
> > > +                       if (io_run_task_work())
> > > +                               goto retry;
> > >                         return io_setup_async_msg(req, kmsg);
> > >                 }
> > >                 req_set_fail(req);
> > > @@ -5744,6 +5747,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
> > >                 min_ret = iov_iter_count(&msg.msg_iter);
> > >
> > >         msg.msg_flags = flags;
> > > +retry:
> > >         ret = sock_sendmsg(sock, &msg);
> > >         if (ret < min_ret) {
> > >                 if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
> > > @@ -5755,6 +5759,8 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
> > >                         sr->buf += ret;
> > >                         sr->done_io += ret;
> > >                         req->flags |= REQ_F_PARTIAL_IO;
> > > +                       if (io_run_task_work())
> > > +                               goto retry;
> > >                         return -EAGAIN;
> > >                 }
> > >                 req_set_fail(req);
> > >
> > > --
> > > Jens Axboe
> > >
> >
> > Jens:
> >
> > I was able to test the first change on the top of Linus kernel git (5.18.0-rc6).
> >
> > I do not get short sends anymore, but I get corruption in  sent
> > packets (corruption is detected by the receiver). It looks like short
> > sends handled by the patch intermix data from multiple send SQEs in
> > the stream, so ordering of multiple SQEs in URING becomes broken.
> >
> > To test it, I had two implementations of the send functions:
> > 1. Uses SEND opcode, asserts on short sends. No asserts but data corruption.
> > 2. Uses TCP send queue implementation (internally uses SEND and
> > SENDMSG opcodes in URING, only one pending send at a time, and tail of
> > the short sends is resent until all data is sent). This always works.
> >
> > I would like to test the second patch now. Is it on the top of the
> > first patch or by itself? Do I really need your tree for that? If yes,
> > can you send me the git pull info, please?
> >
> > --
> > ----------------------------------------
> > Constantine Gavrilov
> > Storage Architect
> > Master Inventor
> > Tel-Aviv IBM Storage Lab
> > 1 Azrieli Center, Tel-Aviv
> > ----------------------------------------
>
> Jens: for git branch, is it under
> git://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git?
>
> --
> ----------------------------------------
> Constantine Gavrilov
> Storage Architect
> Master Inventor
> Tel-Aviv IBM Storage Lab
> 1 Azrieli Center, Tel-Aviv
> ----------------------------------------

Jens: checked out yout branch, the first patch is already in, applied
the second. Will build and test now.

-- 
----------------------------------------
Constantine Gavrilov
Storage Architect
Master Inventor
Tel-Aviv IBM Storage Lab
1 Azrieli Center, Tel-Aviv
----------------------------------------
