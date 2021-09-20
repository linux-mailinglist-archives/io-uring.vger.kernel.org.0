Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0CBD4114E6
	for <lists+io-uring@lfdr.de>; Mon, 20 Sep 2021 14:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhITMwt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Sep 2021 08:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232821AbhITMwt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Sep 2021 08:52:49 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A41DFC061574
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 05:51:22 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id g8so61067919edt.7
        for <io-uring@vger.kernel.org>; Mon, 20 Sep 2021 05:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vfsYUztbcekVP8Ceh5K8p/2eLYwD3FRYyGCbAqm1nUA=;
        b=BKREpegpsIXinn2WuzVwOo18H5Q465j1MnFnkXJK4gv9k+uRY95hxkOZIzd1An0JG1
         jeHYLpL9t6CE+T0yIvGwRMe39X04WsWdPa0P3T5SUh/Fxht2fFdT2YtbytVvrDuVW4uF
         ZG/VHb1AG7O9c2f/xlRq9qq5+BYEtcjzB3D6ZQYpe5J5O0KIbv1ROPI1tlNoafMphHVn
         /fEU/aDA7MEpfCM22RSSpfjIyRsfDqFLnUAjMFkIMFPHPAPqVSkRzCtLCUNu/3FXJC4C
         nuYHOn0xopaNI0wj4Ude41RRM0YCS7C1u0GsZXyTaPJHf804RZvjk7NsYOz1aZvJyJBw
         Sf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vfsYUztbcekVP8Ceh5K8p/2eLYwD3FRYyGCbAqm1nUA=;
        b=qDEtx/Usp37Kt/nXGYOpGzg2ZCQcsh7k/FJQenHrn3b49/gxrtpp+ChNn5f84VKKjh
         HGWo+sKCO+gRB3Ej2sQzWTr59mVomLal+wqeyOTQLNmvtA3hmiImYZJWULmZZ/DHpzFo
         eXn6vn4h/hUyxr63Mtj7kfBr9bsEx+zD4Hfu8cNxUeMzmLBRBqBiRabRmYC2Tp618J6H
         Gk/Wbw+9YO5S12Xtf92ZxvnR2JGyJYHX8Bb+u5BtIfMl2z2rtA/MyosVTVRrrB6BE7km
         +x6LORVOQMXfyn67+3h0ONjqgE6/O6dzw83E/Qt+CBKxeiyAcbP1sHIKv+CZcPtFpyRU
         9MmA==
X-Gm-Message-State: AOAM531jNBa1f2PbfyMS/8yVoT+Y1TMve1R6kGx16vSce3Mpc5uQEykV
        GBuNQRw5i7KTbUMLyKtX6x5NKUH1PobUtdgRIQRu2A==
X-Google-Smtp-Source: ABdhPJzY1mGNJPahTbWXHOPO2+3xWJpBWz+9e9Bk3RA3E1e499g/QoNGRErmoeiDnm4njKHo2+rxWeU/77HWRmXh7nU=
X-Received: by 2002:a17:906:9811:: with SMTP id lm17mr19529380ejb.334.1632142281223;
 Mon, 20 Sep 2021 05:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAM1kxwjCjo9u5AwAn0UANCWkahkUYz8PwHkWgF0U83ue=KbfTA@mail.gmail.com>
 <a1010b67-d636-9672-7a21-44f7c4376916@kernel.dk> <CAM1kxwj2Chak===QoOzNBAUMhymyXM3T6o_zwPdwqN7MzQ25zw@mail.gmail.com>
 <c0de93f7-abf4-d2f9-f64d-376a9c987ac0@kernel.dk> <7bfd2fdd-15ba-98e3-7acc-cecf2a42e157@kernel.dk>
 <CAM1kxwi6EMGZeNW_imNZq4jMkJ3NeuDdkeGBkRMKpwJPQ8Rxmw@mail.gmail.com>
 <36866fef-a38f-9d7d-0c85-b4c37a8279ce@kernel.dk> <CAM1kxwgA7BtaPYhkeHFnqrgLHs31LrOCiXcMEiO9Y8GU22KNfQ@mail.gmail.com>
 <d0cbd186-b721-c7ca-f304-430e272a78f4@kernel.dk> <3df95a9f-7a5a-14bd-13e4-cef8a3f58dbd@kernel.dk>
In-Reply-To: <3df95a9f-7a5a-14bd-13e4-cef8a3f58dbd@kernel.dk>
From:   Victor Stewart <v@nametag.social>
Date:   Mon, 20 Sep 2021 13:51:10 +0100
Message-ID: <CAM1kxwgayosM7YgPo=OWOG=+RcuYZ7xksUQcd03uOw-RKhxTwQ@mail.gmail.com>
Subject: Re: [BUG? liburing] io_uring_register_files_update with liburing 2.0
 on 5.13.17
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Sep 19, 2021 at 12:40 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/18/21 5:37 PM, Jens Axboe wrote:
> >> and it failed with the same as before...
> >>
> >> io_uring_register(13, IORING_REGISTER_FILES, [-1, -1, -1, 3, 4, 5, 6, 7, 8,
> >> 9, 10, 11, 12, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
> >> -1, -1, -1, -1,
> >> -1, ...], 32768) = -1 EMFILE (Too many open files)
> >>
> >> if you want i can debug it for you tomorrow? (in london)
> >
> > Nah that's fine, I think it's just because you have other files opened
> > too. We bump the cur limit _to_ 'nr', but that leaves no room for anyone
> > else. Would be my guess. It works fine for the test case I ran here, but
> > your case may be different. Does it work if you just make it:
> >
> > rlim.rlim_cur += nr;
> >
> > instead?
>
> Specifically, just something like the below incremental. If rlim_cur
> _seems_ big enough, leave it alone. If not, add the amount we need to
> cur. And don't do any error checking here, let's leave failure to the
> kernel.
>
> diff --git a/src/register.c b/src/register.c
> index bab42d0..7597ec1 100644
> --- a/src/register.c
> +++ b/src/register.c
> @@ -126,9 +126,7 @@ static int bump_rlimit_nofile(unsigned nr)
>         if (getrlimit(RLIMIT_NOFILE, &rlim) < 0)
>                 return -errno;
>         if (rlim.rlim_cur < nr) {
> -               if (nr > rlim.rlim_max)
> -                       return -EMFILE;
> -               rlim.rlim_cur = nr;
> +               rlim.rlim_cur += nr;
>                 setrlimit(RLIMIT_NOFILE, &rlim);
>         }
>

i just tried this patch and same failure. if you intend for this to remain
in the code i can debug what's going on?

>
> --
> Jens Axboe
>
