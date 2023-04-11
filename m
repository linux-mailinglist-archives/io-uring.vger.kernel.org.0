Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E284D6DE806
	for <lists+io-uring@lfdr.de>; Wed, 12 Apr 2023 01:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbjDKX3K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 19:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjDKX3J (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 19:29:09 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF8230EB;
        Tue, 11 Apr 2023 16:29:07 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id l10-20020a05600c1d0a00b003f04bd3691eso16145467wms.5;
        Tue, 11 Apr 2023 16:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681255746; x=1683847746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M0CkMqYq+hUDaj5V0hhmDO1UTL5tLPTAw4HpqPGo/CI=;
        b=J3LVgwoNptw8bLlvE41uEG2j9TStrqHfFmkNM6ZeN/M4Nm7cEKyqL4PoocH7sjia4K
         pmJCOY0Fcah03z3qiU5733K/51RLO11+fXGsh6oThEdOkujyg1PJLP/Z1V/HMzVmYgMG
         yHH3baF+ux6fjywMOlkIFwK9Dd3mFTOHXXurmP+fyqJ/09BKbnqsweeDE5YPrjHccoOH
         OtJHdtkNvpGsCbm+hsQ0kA08LIDZ1iVVUiRg0cOtyl+7X29/1W2AF2RsWvo3Ba0ifrLW
         uN5naQd1ruuU6z5zDFdPdgGNWjJbvD0mTR5ol480+J+obbxotva53tnV7wMjs7q4wlfe
         rUdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681255746; x=1683847746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M0CkMqYq+hUDaj5V0hhmDO1UTL5tLPTAw4HpqPGo/CI=;
        b=vckO7eghj9ZMRFPZoA2YWmKzc3XONvuWo07szSFXz3rJtq9L5LUGMiix1p/P8D70hA
         ILUt22ZjC8wUK8OcblYVU6+aVxtzlyFtn0Bclj/XPcb1Aa9GPTEiItdm6AbOY9GzD3K4
         T7W03k0c0jmv1aK+H8fDiwBvG74NlJMfSHNOV7gXi/qo/vdOWXQti8/7rZBBFHSDFwe3
         3EQIv9lGC7Skr0+X5dKlimHIUWAdvoGysith0+3ontePWlincPeGwcfus5eE5QSAAMGV
         GQzlJctrar9EbsUi4Hf/IGcCKODm3ziMkeVENm0edaZi6ATSK3ccfT2CFqBlu+ZR1TrU
         7AZQ==
X-Gm-Message-State: AAQBX9c1V7K8baG3NnMf4cho2tD8L2EK7y0O8U5xdNBYSFhTi4iBVpHP
        tlfk5PHlssi9qWPTGOQ5L8L3Hs0eaH0Gk+BHTw8=
X-Google-Smtp-Source: AKy350a1/csCz3HEkVzqo/HDghWSl2B+ymjb4pAz7T2EVD2DK+b9INtbNQYEaj+mLr1tmIiLdpbp4f4mFehjNbzhVfw=
X-Received: by 2002:a05:600c:3797:b0:3ef:66ec:1e73 with SMTP id
 o23-20020a05600c379700b003ef66ec1e73mr2652309wmr.6.1681255745960; Tue, 11 Apr
 2023 16:29:05 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230210180226epcas5p1bd2e1150de067f8af61de2bbf571594d@epcas5p1.samsung.com>
 <20230210180033.321377-1-joshi.k@samsung.com> <39a543d7-658c-0309-7a68-f07ffe850d0e@kernel.dk>
 <CA+1E3rLLu2ZzBHp30gwXBWzkCvOA4KD7PS70mLuGE8tYFpNEmA@mail.gmail.com> <09a546bd-ec30-f2db-f63f-b7708e6d63a1@kernel.dk>
In-Reply-To: <09a546bd-ec30-f2db-f63f-b7708e6d63a1@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Wed, 12 Apr 2023 04:58:41 +0530
Message-ID: <CA+1E3rKrXOOBEaRb4pfE29wmhRP-fcUcSwQ4gobKGRxMGyS8jg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF ATTEND][LSF/MM/BPF Topic] Non-block IO
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, io-uring@vger.kernel.org,
        hch@lst.de, kbusch@kernel.org, ming.lei@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 12, 2023 at 4:23=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/11/23 4:48=E2=80=AFPM, Kanchan Joshi wrote:
> >>> 4. Direct NVMe queues - will there be interest in having io_uring
> >>> managed NVMe queues?  Sort of a new ring, for which I/O is destaged f=
rom
> >>> io_uring SQE to NVMe SQE without having to go through intermediate
> >>> constructs (i.e., bio/request). Hopefully,that can further amp up the
> >>> efficiency of IO.
> >>
> >> This is interesting, and I've pondered something like that before too.=
 I
> >> think it's worth investigating and hacking up a prototype. I recently
> >> had one user of IOPOLL assume that setting up a ring with IOPOLL would
> >> automatically create a polled queue on the driver side and that is wha=
t
> >> would be used for IO. And while that's not how it currently works, it
> >> definitely does make sense and we could make some things faster like
> >> that. It would also potentially easier enable cancelation referenced i=
n
> >> #1 above, if it's restricted to the queue(s) that the ring "owns".
> >
> > So I am looking at prototyping it, exclusively for the polled-io case.
> > And for that, is there already a way to ensure that there are no
> > concurrent submissions to this ring (set with IORING_SETUP_IOPOLL
> > flag)?
> > That will be the case generally (and submissions happen under
> > uring_lock mutex), but submission may still get punted to io-wq
> > worker(s) which do not take that mutex.
> > So the original task and worker may get into doing concurrent submissio=
ns.
>
> io-wq may indeed get in your way. But I think for something like this,
> you'd never want to punt to io-wq to begin with. If userspace is managing
> the queue, then by definition you cannot run out of tags.

Unfortunately we have lifetime differences between io_uring and NVMe.
NVMe tag remains valid/occupied until completion (we do not have a
nice sq->head to look at and decide).
For io_uring, it can be reused much earlier i.e. just after submission.
So tag shortage is possible.

>If there are
> other conditions for this kind of request that may run into out-of-memory
> conditions, then the error just needs to be returned.

I see, and IOSQE_ASYNC can also be flagged as an error/not-supported. Thank=
s.
