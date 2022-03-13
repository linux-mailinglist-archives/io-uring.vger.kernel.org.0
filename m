Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04AEC4D7286
	for <lists+io-uring@lfdr.de>; Sun, 13 Mar 2022 06:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbiCMFJ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Mar 2022 00:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiCMFJ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Mar 2022 00:09:28 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0968C3B3C7;
        Sat, 12 Mar 2022 21:08:20 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id 3so21718762lfr.7;
        Sat, 12 Mar 2022 21:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BiP1OUgw5aMNucxm0wSc1yXQNpiaVLQclFLothq1kwU=;
        b=Ss1L0ikV9i0k+OZf4hcnVQONh5gAxa9mCIbxgzbbvHs6gZpJePfUoB4Vp0odXC9Kgd
         ckCJ2uL8jEU4HY2qfePYe0rpC9/kYhvDEjKKSKFw2Y9hnzoowl/xJ3GAgzj1WqhfjH0t
         2QRN0zgyFpKGRdnJHwT2lRkKdAXJW5ZmxujnpdYV5FZ3GQWmWFKbjo/J2hWSCrsKKRpp
         PrLr+4tlIs2nt/6BT5ucOK5djhwTgQCjySrRrLCVcoenR6m/apY7Z8cCIfAvfFZ5Oqbi
         KbKrjDLF9MpKuED+E2GjcxsQSixg2ut+2QJT3ef9UCLYWPQ/4ZU/70bgKqoo2dCwCXLs
         OIwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BiP1OUgw5aMNucxm0wSc1yXQNpiaVLQclFLothq1kwU=;
        b=7kEd8md1x5ZaMhaCAtdX3H4OTJFpssEXmwCV9GZHM92QhHqDfcjqPjpTEstlgy2wqP
         BlLz0/ApEDjAWcY/9iwFmZmcWXt9vldsDWvCA8BBzawdt8Nu4QV9qXIuyIHDSSVu06yl
         g+PC7wcehAgR2xdJAdQ2JsBReHIypRJ3B7AJoIuYSGiZrOzoZD3HyhTV9nBDw0zfx2oq
         IHvSdJVBD7N4mECgjyto9j25TRf6OUBQuIE9+vc6ZjwFQ9tC0QEPF1OhBH1D/JtFfl/R
         5pbVZHHAaUOhnenW11rJ4KBcFvoxADod2jPBDs98iEPL2imBQYptD31LP40i5qFmmUxK
         Fd2A==
X-Gm-Message-State: AOAM530kHqGpOHfhHi207fPyCXjKLmm+4guBeUS1fmQIZRdZGH9SvQjZ
        IaQeRmwp8CvHtmhuvSI7CNoz4f70TxTF0pIjMIcFvw4d9HgCGw==
X-Google-Smtp-Source: ABdhPJwrUwptvnntJjKKmQAoOAj6ki9tc0LvmQ/gWmmAjOyI57JWLkVTze+Hnv9ASkKQtPTKp4s13NpRiD3hNW3SDvU=
X-Received: by 2002:ac2:5e2f:0:b0:443:671b:cead with SMTP id
 o15-20020ac25e2f000000b00443671bceadmr9896398lfg.306.1647148099036; Sat, 12
 Mar 2022 21:08:19 -0800 (PST)
MIME-Version: 1.0
References: <CGME20220308152651epcas5p1ebd2dc7fa01db43dd587c228a3695696@epcas5p1.samsung.com>
 <20220308152105.309618-1-joshi.k@samsung.com> <20220310082926.GA26614@lst.de>
 <CA+1E3rJ17F0Rz5UKUnW-LPkWDfPHXG5aeq-ocgNxHfGrxYtAuw@mail.gmail.com>
 <Yit8LFAMK3t0nY/q@bombadil.infradead.org> <20220311233501.GA6435@bgt-140510-bm01>
 <20220312022732.GA10120@bgt-140510-bm01>
In-Reply-To: <20220312022732.GA10120@bgt-140510-bm01>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Sun, 13 Mar 2022 10:37:53 +0530
Message-ID: <CA+1E3rJNcqFT58eg1O+wDFyAkhCjHjnN6Hntms6jQxhLt1gtaQ@mail.gmail.com>
Subject: Re: [PATCH 00/17] io_uring passthru over nvme
To:     Adam Manzanares <a.manzanares@samsung.com>
Cc:     Luis Chamberlain <mcgrof@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "sbates@raithlin.com" <sbates@raithlin.com>,
        "logang@deltatee.com" <logang@deltatee.com>,
        Pankaj Raghav <pankydev8@gmail.com>,
        =?UTF-8?Q?Javier_Gonz=C3=A1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>,
        "j.granados@samsung.com" <j.granados@samsung.com>,
        "j.devantier@samsung.com" <j.devantier@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Mar 12, 2022 at 7:57 AM Adam Manzanares
<a.manzanares@samsung.com> wrote:
>
> On Fri, Mar 11, 2022 at 03:35:04PM -0800, Adam Manzanares wrote:
> > On Fri, Mar 11, 2022 at 08:43:24AM -0800, Luis Chamberlain wrote:
> > > On Thu, Mar 10, 2022 at 03:35:02PM +0530, Kanchan Joshi wrote:
> > > > On Thu, Mar 10, 2022 at 1:59 PM Christoph Hellwig <hch@lst.de> wrot=
e:
> > > > >
> > > > > What branch is this against?
> > > > Sorry I missed that in the cover.
> > > > Two options -
> > > > (a) https://urldefense.com/v3/__https://protect2.fireeye.com/v1/url=
?k=3D03500d22-5ccb341f-0351866d-0cc47a31309a-6f95e6932e414a1d&q=3D1&e=3D4ca=
7b05e-2fe6-40d9-bbcf-a4ed687eca9f&u=3Dhttps*3A*2F*2Fgit.kernel.dk*2Fcgit*2F=
linux-block*2Flog*2F*3Fh*3Dio_uring-big-sqe__;JSUlJSUlJSUl!!EwVzqGoTKBqv-0D=
WAJBm!FujuZ927K3fuIklgYjkWtodmdQnQyBqOw4Ge4M08DU_0oD5tPm0-wS2SZg0MDh8_2-U9$
> > > > first patch ("128 byte sqe support") is already there.
> > > > (b) for-next (linux-block), series will fit on top of commit 9e9d83=
faa
> > > > ("io_uring: Remove unneeded test in io_run_task_work_sig")
> > > >
> > > > > Do you have a git tree available?
> > > > Not at the moment.
> > > >
> > > > @Jens: Please see if it is possible to move patches to your
> > > > io_uring-big-sqe branch (and maybe rename that to big-sqe-pt.v1).
> > >
> > > Since Jens might be busy, I've put up a tree with all this stuff:
> > >
> > > https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kern=
el/git/mcgrof/linux-next.git/log/?h=3D20220311-io-uring-cmd__;!!EwVzqGoTKBq=
v-0DWAJBm!FujuZ927K3fuIklgYjkWtodmdQnQyBqOw4Ge4M08DU_0oD5tPm0-wS2SZg0MDiTF0=
Q7F$
> > >
> > > It is based on option (b) mentioned above, I took linux-block for-nex=
t
> > > and reset the tree to commit "io_uring: Remove unneeded test in
> > > io_run_task_work_sig" before applying the series.
> >
> > FYI I can be involved in testing this and have added some colleagues th=
at can
> > help in this regard. We have been using some form of this work for seve=
ral
> > months now and haven't had any issues. That being said some simple test=
s I have
> > are not currently working with the above git tree :). I will work to ge=
t this
> > resolved and post an update here.
>
> Sorry for the noise, I jumped up the stack too quickly with my tests. The
> "simple test" actually depends on several pieces of SW not related to the
> kernel.

Did you read the cover letter? It's not the same *user-interface* as
the previous series.
If you did not modify those out-of-kernel layers for the new
interface, you're bound to see what you saw.
If you did, please specify what the simple test was. I'll fix that in v2.

Otherwise, the throwaway remark "simple tests not working" - only
infers this series is untested. Nothing could be further from the
truth.
Rather this series is more robust than the previous one.

Let me expand bit more on testing part that's already there in cover:

fio -iodepth=3D256 -rw=3Drandread -ioengine=3Dio_uring -bs=3D512 -numjobs=
=3D1
-runtime=3D60 -group_reporting -iodepth_batch_submit=3D64
-iodepth_batch_complete_min=3D1 -iodepth_batch_complete_max=3D64
-fixedbufs=3D1 -hipri=3D1 -sqthread_poll=3D0 -filename=3D/dev/ng0n1
-name=3Dio_uring_256 -uring_cmd=3D1

When I reduce the above command-line to do single IO, I call that a simple =
test.
Simple test that touches almost *everything* that patches build (i.e
async, fixed-buffer, plugging, fixed-buffer, bio-cache, polling).
And larger tests combine these knobs in various ways, QD ranging from
1, 2, 4...upto 256; on general and perf-optimized kernel config; with
big-sqe and normal-sqe (pointer one). And all this is repeated on the
block interface (regular io) too, which covers the regression part.
Sure, I can add more tests for checking regression. But no, I don't
expect any simple test to fail. And that applies to Luis' tree as
well. Tried that too again.


--=20
Joshi
