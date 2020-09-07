Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F61B25F7F2
	for <lists+io-uring@lfdr.de>; Mon,  7 Sep 2020 12:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgIGKXr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Sep 2020 06:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728622AbgIGKX2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Sep 2020 06:23:28 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D0CC061574
        for <io-uring@vger.kernel.org>; Mon,  7 Sep 2020 03:23:25 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id k25so8533901qtu.4
        for <io-uring@vger.kernel.org>; Mon, 07 Sep 2020 03:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4k7Kd5t2jkZqtgPrZqT2wGNI1NeWf/er5rtXTr+n42Q=;
        b=Lb0VPa7/eFsOFAoCOwGUkhIBukIwV0U8OLyGrMGfzP9Yc9ryBmDeB2pKqrXoj8hL0C
         vFBSJ7HMtTdwRpAL8Tz1hL/wT7OusQlWyj0AXi09PNY06BcJDc2g95guuw29xbwF6PLz
         7so+WVP4RB1tqciFapLLyt7c0u+mA+itnsKUlBkT5QhayZ6X9BdsnDBWMTcaIfKHs2f+
         7t7Iag00mHuqDAn3qnJi/2I+qPMTPN9kuvi7vnGUTFFHSkPeifFq8uBx7v91qh8jzsBn
         PqdR5ydY7WhXVajcwzqm4/vsvzN37tt56l0juKUF5HjT/ADt5B9V60dXpFa6qE7fd+H8
         PWGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4k7Kd5t2jkZqtgPrZqT2wGNI1NeWf/er5rtXTr+n42Q=;
        b=igcI7auwNYr08ZvkvmKV2BIQiqvrv0ihKchMsIeXZ5S3GZB7gUAQSdaup5Ro/85IjQ
         pUKGKVybzzV2n96WGN+fMm9UlafJHN4DFIWR0DI5KI6SPdCmUzCySck5+EFH+ACQxkTZ
         0CJaFadVsQ8NcmW5Xrw2rWxIuD8tTog9VimIAEIi/hz/hzeXrlws/clF0F/SS1Lwa397
         ZYlUONbpAWCrJBZ/q2LabCKWqgJUkduz64YMDoNCCQVXtJeM+ibfJNAICRfTlAC0tLUJ
         KBn/CFCKA1fxlZeUi2dY+JhSJM815NyfahT9M+h+A6dhDauz03wxT0+xNbLBWQaLedGS
         7+nw==
X-Gm-Message-State: AOAM530RTArjM1tDSDhrysrzpsivK9bfmK3pCDISSLB7YjSCcpZnXzrw
        ks757f9ycRkxURyNvmQ7AbJ1p1EnKTejUUnFlumx0PQw/LWB8d1s
X-Google-Smtp-Source: ABdhPJwlGI2L+FHeDvJPII/R1jSSpAYzDd3BSFzrhU2v23lPAlftwJSy+Br8PkmLM6QRHaxidUm16KgLuo6Y/CDIzZI=
X-Received: by 2002:ac8:7c90:: with SMTP id y16mr19492287qtv.45.1599474202522;
 Mon, 07 Sep 2020 03:23:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+p8iVOsP8Z7Yn2691-NU-OGrsvYd6VY9UM6qOgNwNF_1Q@mail.gmail.com>
 <68c62a2d-e110-94cc-f659-e8b34a244218@kernel.dk> <CAAss7+qjPqGMMLQAtdRDDpp_4s1RFexXtn7-5Sxo7SAdxHX3Zg@mail.gmail.com>
 <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
In-Reply-To: <711545e2-4c07-9a16-3a1d-7704c901dd12@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Mon, 7 Sep 2020 12:23:11 +0200
Message-ID: <CAAss7+rgZ+9GsMq8rRN11FerWjMRosBgAv=Dokw+5QfBsUE4Uw@mail.gmail.com>
Subject: Re: SQPOLL question
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> On top of that, capabilities will also be reduced from root to
> CAP_SYS_NICE instead, and sharing across rings for the SQPOLL thread
> will be supported. So it'll be a lot more useful/flexible in general.

oha that's nice, I'm pretty excited :)

I'm just wondering if all op are supported when the SQPOLL flag is
set? the accept op seems to fail with -EINVAL, when I enable SQPOLL

to reproduce it:
https://gist.github.com/1Jo1/accb91b737abb55d07487799739ad70a
(just want to test a non blocking accept op in SQPOLL mode)

---
Josef




On Sun, 6 Sep 2020 at 18:25, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/6/20 10:24 AM, Josef wrote:
> >> You're using the 'fd' as the file descriptor, for registered files
> >> you want to use the index instead. Since it's the only fd you
> >> registered, the index would be 0 and that's what you should use.
> >
> > oh..yeah it works, thanks :)
>
> Great!
>
> >> It's worth mentioning that for 5.10 and on, SQPOLL will no longer
> >> require registered files.
> >
> > that's awesome, it would be really handy as I just implemented a kind
> > of workaround in netty :)
>
> On top of that, capabilities will also be reduced from root to
> CAP_SYS_NICE instead, and sharing across rings for the SQPOLL thread
> will be supported. So it'll be a lot more useful/flexible in general.
>
> --
> Jens Axboe
>
