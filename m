Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52F344EB349
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237003AbiC2SXs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 14:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240507AbiC2SXr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 14:23:47 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E1E1F519B
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:22:03 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id u26so21639375eda.12
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 11:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/uR9RGFomWngZsPsJ7WuSW6pd7/fBtzRdp5+Fi4Cv4s=;
        b=HwgYSU+4OSpvZxX2waCk8b8h0Iy3z2bKo78LH3twL8hMFiS29yUZm0ngCwVmeWeQo4
         6QrGKAvvkTZ0s42fE15vadPYcly3b/W0CTg2lo3YKVe85STGMZfRzHeH+hjFO1M1KTBQ
         4CjOIMnqMsecABN4zxD2mj8kW/x4MUT4hRg08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/uR9RGFomWngZsPsJ7WuSW6pd7/fBtzRdp5+Fi4Cv4s=;
        b=jQrEn8pDAi1SqAUb3tEz4uPK3iMcfZDPx8trqQs+OcQ9xqtCWqv1jL3SXzmQMVnF6p
         TdHSnYFIvVF6XKsJEFkWif//sK5LsYxSRrWBqKbp+buAMh16P5AhMxakGQE0+URLrV7U
         cTpTXUk2zFzMQJwOmPrwRGBJuJ35XbtsJW/qOK5sO7SKolFTO8hyqRxGKKlFuNf5e2gg
         jCG3o9LoFkc+ETLwvRNUNndMqfX8qsqsTr0nvqwdcqnaE7ybD8HSxq4DJJ1eMTHPA8k6
         fDV+IZc2h9Kb1pSxSGn6wpTHVhI393nne8ijp16x2eix64nCkS0oEXop3KJDeb8jw9hS
         BSFA==
X-Gm-Message-State: AOAM533Hr/NtDdnDrr0bMAFiWxFiTES2Dh5E9Myzct5I/QaL4d0HG7wU
        MeaT78wuLUKPSXzXuM3Rg1Ro5ZrwrzxgVDP094hGKQ==
X-Google-Smtp-Source: ABdhPJxJO3gCtuu9oHOni541L/Q8byjGB0Rt8I2XfFozQyYVRocs12y+sfOusMEOdG3qpEY4a6bLBew6ooD0sl8dkfo=
X-Received: by 2002:a05:6402:50cf:b0:418:ee57:ed9 with SMTP id
 h15-20020a05640250cf00b00418ee570ed9mr6212262edb.37.1648578121564; Tue, 29
 Mar 2022 11:22:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegvVpFbDX5so8EVaHxubZLNQ4bo=myAYopWeRtMs0wa6nA@mail.gmail.com>
 <8145e724-d960-dd85-531e-16e564a02f05@kernel.dk> <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
In-Reply-To: <c8872b69-f042-dc35-fa3d-6862f09a5385@kernel.dk>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 20:21:50 +0200
Message-ID: <CAJfpegs1o3HNkpxPa85LmNCoVVk-T2rt3vJXBvRf_M93P+6ouA@mail.gmail.com>
Subject: Re: io_uring_prep_openat_direct() and link/drain
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 29 Mar 2022 at 19:04, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/29/22 10:08 AM, Jens Axboe wrote:
> > On 3/29/22 7:20 AM, Miklos Szeredi wrote:
> >> Hi,
> >>
> >> I'm trying to read multiple files with io_uring and getting stuck,
> >> because the link and drain flags don't seem to do what they are
> >> documented to do.
> >>
> >> Kernel is v5.17 and liburing is compiled from the git tree at
> >> 7a3a27b6a384 ("add tests for nonblocking accept sockets").
> >>
> >> Without those flags the attached example works some of the time, but
> >> that's probably accidental since ordering is not ensured.
> >>
> >> Adding the drain or link flags make it even worse (fail in casese that
> >> the unordered one didn't).
> >>
> >> What am I missing?
> >
> > I don't think you're missing anything, it looks like a bug. What you
> > want here is:
> >
> > prep_open_direct(sqe);
> > sqe->flags |= IOSQE_IO_LINK;
> > ...
> > prep_read(sqe);

So with the below merge this works.   But if instead I do

prep_open_direct(sqe);
 ...
prep_read(sqe);
sqe->flags |= IOSQE_IO_DRAIN;

than it doesn't.  Shouldn't drain have a stronger ordering guarantee than link?

Thanks,
Miklos
