Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A24C6F3086
	for <lists+io-uring@lfdr.de>; Mon,  1 May 2023 13:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbjEALg4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 May 2023 07:36:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjEALgz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 May 2023 07:36:55 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205B39C;
        Mon,  1 May 2023 04:36:50 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f192c23fffso13056705e9.3;
        Mon, 01 May 2023 04:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682941008; x=1685533008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vjlw7ZIPO5BHNu1EUtvol8aUBJhxAExd/+yf0BW2Rjg=;
        b=iMWx4trNR6AYTXhXDKvyM54jBSXWB2aOKpDY2s6D+Oa+17D5tMPqfT/LGBSlpHyJdv
         ESRx8AQqBjLvH3IZNIvie9OhrZ6KrEdPpJ2kDtFlDshQN3eO11Q+T/4imDbagVt5JERs
         Q2cEpyHZkePAyEP3e8C5lUPP3y7BQyX0sKMZhf+JmJ7cskenA7cNVC7bTPLtXoglCFrb
         bNAUh6latUHR9aumpur6yHepLw7H4mdhjx6iSYyoSfPY/cmQSaRM1ewyUsm9OifPSr63
         o737gbCZ0+1w066hxj00OyMnu3uj2MgbnkLt14O7wt1NoRR2hX8aczoRfkgTh15dvcMK
         Q3Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682941008; x=1685533008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vjlw7ZIPO5BHNu1EUtvol8aUBJhxAExd/+yf0BW2Rjg=;
        b=dXPk43n3LjePfeBM85Kp/Od7ruWVkm4lwob61ce7XtJN2UhHlC7f0qj8XHGWXaowBQ
         2j5VNWq19BWvghy2BBskS6Znm7RQMSZ0y7v3nzES14Yx8DaP8Rdds08J05mo9LnuJo3e
         n3nbXB/tKfyeCalSMIlwVxn/RkUTVK0Lu3CSVur+hizi5G1cxYAAGqw3IDU49Wc+FDOr
         EdhPMQaUSZCCJ/uw3oGHljDkFE0teTcdtvu0EZimX5sqeaY2MtliFdOCWSAdQuWHyH9n
         +FqRmMSVqqmRdec3K9s1Y7Equm/EvUZLnjkPQ7qNW0V77aH0QwOeCDFQoFfOJQCGXEdx
         nclA==
X-Gm-Message-State: AC+VfDzAWjmjjc9I0eF2PxCgK1pJjUJII435m6snrqXniJsjJebfHXhJ
        ILWVCsztchY2hPLsXLYWoEb3QbYE5M4xc/+ZyH0=
X-Google-Smtp-Source: ACHHUZ7A/S7sJNr6YsfCAgmiMeExl6VXG2ORa76JLyYaLdDYdkrM/oOD6xttWsVNCbRmeMmboSyNIIknMV7D5UhJ0QA=
X-Received: by 2002:a5d:5691:0:b0:306:2c47:9736 with SMTP id
 f17-20020a5d5691000000b003062c479736mr2613621wrv.15.1682941007855; Mon, 01
 May 2023 04:36:47 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230429094228epcas5p4a80d8ed77433989fa804ecf449f83b0b@epcas5p4.samsung.com>
 <20230429093925.133327-1-joshi.k@samsung.com> <d7e9e68d-64b2-ab30-3c93-13dbeda27bce@kernel.dk>
In-Reply-To: <d7e9e68d-64b2-ab30-3c93-13dbeda27bce@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 1 May 2023 17:06:24 +0530
Message-ID: <CA+1E3r+J5pAywR8p9h=seJ+b=ckY27qsnrG0O_9iU2F+LwDnqA@mail.gmail.com>
Subject: Re: [RFC PATCH 00/12] io_uring attached nvme queue
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, sagi@grimberg.me,
        kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, anuj1072538@gmail.com,
        xiaoguang.wang@linux.alibaba.com
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

On Sat, Apr 29, 2023 at 10:55=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 4/29/23 3:39?AM, Kanchan Joshi wrote:
> > This series shows one way to do what the title says.
> > This puts up a more direct/lean path that enables
> >  - submission from io_uring SQE to NVMe SQE
> >  - completion from NVMe CQE to io_uring CQE
> > Essentially cutting the hoops (involving request/bio) for nvme io path.
> >
> > Also, io_uring ring is not to be shared among application threads.
> > Application is responsible for building the sharing (if it feels the
> > need). This means ring-associated exclusive queue can do away with some
> > synchronization costs that occur for shared queue.
> >
> > Primary objective is to amp up of efficiency of kernel io path further
> > (towards PCIe gen N, N+1 hardware).
> > And we are seeing some asks too [1].
> >
> > Building-blocks
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > At high level, series can be divided into following parts -
> >
> > 1. nvme driver starts exposing some queue-pairs (SQ+CQ) that can
> > be attached to other in-kernel user (not just to block-layer, which is
> > the case at the moment) on demand.
> >
> > Example:
> > insmod nvme.ko poll_queus=3D1 raw_queues=3D2
> >
> > nvme0: 24/0/1/2 default/read/poll queues/raw queues
> >
> > While driver registers other queues with block-layer, raw-queues are
> > rather reserved for exclusive attachment with other in-kernel users.
> > At this point, each raw-queue is interrupt-disabled (similar to
> > poll_queues). Maybe we need a better name for these (e.g. app/user queu=
es).
> > [Refer: patch 2]
> >
> > 2. register/unregister queue interface
> > (a) one for io_uring application to ask for device-queue and register
> > with the ring. [Refer: patch 4]
> > (b) another at nvme so that other in-kernel users (io_uring for now) ca=
n
> > ask for a raw-queue. [Refer: patch 3, 5, 6]
> >
> > The latter returns a qid, that io_uring stores internally (not exposed
> > to user-space) in the ring ctx. At max one queue per ring is enabled.
> > Ring has no other special properties except the fact that it stores a
> > qid that it can use exclusively. So application can very well use the
> > ring to do other things than nvme io.
> >
> > 3. user-interface to send commands down this way
> > (a) uring-cmd is extended to support a new flag "IORING_URING_CMD_DIREC=
T"
> > that application passes in the SQE. That is all.
> > (b) the flag goes down to provider of ->uring_cmd which may choose to d=
o
> >   things differently based on it (or ignore it).
> > [Refer: patch 7]
> >
> > 4. nvme uring-cmd understands the above flag. It submits the command
> > into the known pre-registered queue, and completes (polled-completion)
> > from it. Transformation from "struct io_uring_cmd" to "nvme command" is
> > done directly without building other intermediate constructs.
> > [Refer: patch 8, 10, 12]
> >
> > Testing and Performance
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > fio and t/io_uring is modified to exercise this path.
> > - fio: new "registerqueues" option
> > - t/io_uring: new "k" option
> >
> > Good part:
> > 2.96M -> 5.02M
> >
> > nvme io (without this):
> > # t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k0 /dev/ng=
0n1
> > submitter=3D0, tid=3D2922, file=3D/dev/ng0n1, node=3D-1
> > polled=3D1, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, register=
_queues=3D0 QD=3D64
> > Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
> > IOPS=3D2.89M, BW=3D1412MiB/s, IOS/call=3D2/1
> > IOPS=3D2.92M, BW=3D1426MiB/s, IOS/call=3D2/2
> > IOPS=3D2.96M, BW=3D1444MiB/s, IOS/call=3D2/1
> > Exiting on timeout
> > Maximum IOPS=3D2.96M
> >
> > nvme io (with this):
> > # t/io_uring -b512 -d64 -c2 -s2 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/ng=
0n1
> > submitter=3D0, tid=3D2927, file=3D/dev/ng0n1, node=3D-1
> > polled=3D1, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, register=
_queues=3D1 QD=3D64
> > Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
> > IOPS=3D4.99M, BW=3D2.43GiB/s, IOS/call=3D2/1
> > IOPS=3D5.02M, BW=3D2.45GiB/s, IOS/call=3D2/1
> > IOPS=3D5.02M, BW=3D2.45GiB/s, IOS/call=3D2/1
> > Exiting on timeout
> > Maximum IOPS=3D5.02M
> >
> > Not so good part:
> > While single IO is fast this way, we do not have batching abilities for
> > multi-io scenario. Plugging, submission and completion batching are tie=
d to
> > block-layer constructs. Things should look better if we could do someth=
ing
> > about that.
> > Particularly something is off with the completion-batching.
> >
> > With -s32 and -c32, the numbers decline:
> >
> > # t/io_uring -b512 -d64 -c32 -s32 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/=
ng0n1
> > submitter=3D0, tid=3D3674, file=3D/dev/ng0n1, node=3D-1
> > polled=3D1, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, register=
_queues=3D1 QD=3D64
> > Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
> > IOPS=3D3.70M, BW=3D1806MiB/s, IOS/call=3D32/31
> > IOPS=3D3.71M, BW=3D1812MiB/s, IOS/call=3D32/31
> > IOPS=3D3.71M, BW=3D1812MiB/s, IOS/call=3D32/32
> > Exiting on timeout
> > Maximum IOPS=3D3.71M
> >
> > And perf gets restored if we go back to -c2
> >
> > # t/io_uring -b512 -d64 -c2 -s32 -p1 -F1 -B1 -O0 -n1 -u1 -r4 -k1 /dev/n=
g0n1
> > submitter=3D0, tid=3D3677, file=3D/dev/ng0n1, node=3D-1
> > polled=3D1, fixedbufs=3D1/0, register_files=3D1, buffered=3D1, register=
_queues=3D1 QD=3D64
> > Engine=3Dio_uring, sq_ring=3D64, cq_ring=3D64
> > IOPS=3D4.99M, BW=3D2.44GiB/s, IOS/call=3D5/5
> > IOPS=3D5.02M, BW=3D2.45GiB/s, IOS/call=3D5/5
> > IOPS=3D5.02M, BW=3D2.45GiB/s, IOS/call=3D5/5
> > Exiting on timeout
> > Maximum IOPS=3D5.02M
> >
> > Source
> > =3D=3D=3D=3D=3D=3D
> > Kernel: https://github.com/OpenMPDK/linux/tree/feat/directq-v1
> > fio: https://github.com/OpenMPDK/fio/commits/feat/rawq-v2
> >
> > Please take a look.
>
> This looks like a great starting point! Unfortunately I won't be at
> LSFMM this year to discuss it in person, but I'll be taking a closer
> look at this.

That will help, thanks.

> Some quick initial reactions:
>
> - I'd call them "user" queues rather than raw or whatever, I think that
>   more accurately describes what they are for.

Right, that is better.

> - I guess there's no way around needing to pre-allocate these user
>   queues, just like we do for polled_queues right now?

Right, we would need to allocate nvme sq/cq in the outset.
Changing the count at run-time is a bit murky. I will have another look tho=
ugh.

>In terms of user
>   API, it'd be nicer if you could just do IORING_REGISTER_QUEUE (insert
>   right name here...) and it'd allocate and return you an ID.

But this is the implemented API (new register code in io_uring) in the
patchset at the moment.
So it seems I am missing your point?

> - Need to take a look at the uring_cmd stuff again, but would be nice if
>   we did not have to add more stuff to fops for this. Maybe we can set
>   aside a range of "ioctl" type commands through uring_cmd for this
>   instead, and go that way for registering/unregistering queues.

Yes, I see your point in not having to add new fops.
But, a new uring_cmd opcode is only at the nvme-level.
It is a good way to allocate/deallocate a nvme queue, but it cannot
attach that with the io_uring's ring.
Or do you have a different view? Seems this is connected to the previous po=
int.

> We do have some users that are CPU constrained, and while my testing
> easily maxes out a gen2 optane (actually 2 or 3) with the generic IO
> path, that's also with all the fat that adds overhead removed. Most
> people don't have this luxury, necessarily, or actually need some of
> this fat for their monitoring, for example. This would provide a nice
> way to have pretty consistent and efficient performance across distro
> type configs, which would be great, while still retaining the fattier
> bits for "normal" IO.
Makes total sense.
