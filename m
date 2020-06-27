Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33BFA20C2D5
	for <lists+io-uring@lfdr.de>; Sat, 27 Jun 2020 17:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725882AbgF0Pjw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Jun 2020 11:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725864AbgF0Pjw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Jun 2020 11:39:52 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6413C061794
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 08:39:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id c4so12892020iot.4
        for <io-uring@vger.kernel.org>; Sat, 27 Jun 2020 08:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KzYOQk32aMBSnUMNZrbsAt304k4F4/lr09tt6MftDnA=;
        b=JB5WliBpGEfFQysnuA09/xC40bj++bX22gBwfX15/mUjInVE+FPThH8MDU57KV3Kgk
         v4NEFL6MpXVe2xjw8rGdrhEjMbeHBWQv66Veh/qLRvrf8zWfrTLQNPyk/2W3rNN1creh
         nyznALirqiS3kDnRkukc3uyuJ1XO4gTG8gpxUGvfMw4/fP5k2F3mhgX9ezGsb7z2hd9D
         2NIDnmqD5MHcigwbKpf6xhrk2Ax9UetkP58aJQIJEs1atdyGVihGSLfFEDeONoRYr8Vv
         mzjwvBvCR5qePz0sR1IRG0YSWAjV/Vp8PaHW21ZsqrPyYVpeYcAt4UYN0EVXljbSmWMA
         qMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KzYOQk32aMBSnUMNZrbsAt304k4F4/lr09tt6MftDnA=;
        b=SJqVcdeLyqE1hY6MjwBbaAlqHSETvVgfediUwy/P0skP1VUsUDOHvbbMQ0xh0mAE6f
         kUwCfSV69OfWrb1ERh+nHrewwgZ62gxRqBG4m3l1TfydAvy/o4wjx0cDlTllwMoZSQCi
         pQlEgLyMnviLMrCm5BsJ8ZIY4vSXyrvEKaJanWfaeVBEgjvPOoC/oYQMcGANFiBTI/or
         3RJCohasEk3qX33j+tR4CEJR3HV/hJQ2G36x9otSgbOyHPCGVJYsx39rK75j/PS2JA9q
         ifAPwi7gRyHqc63lBCmi9sS2aYP0i6ncx9oD2R5Y8PVdWggvvWEqWkWe+yroBUnDuxsg
         e8Og==
X-Gm-Message-State: AOAM533YdhClRk3rtUiF02I+IHIkcx9hW1ZL6E5jETsFFr0IPns67Jpu
        /XFciO6CtRi3m9KIldPwLwR/Qqps3xqE/fZmWqo=
X-Google-Smtp-Source: ABdhPJywGTUo8cYiV5Dz2XGsLiNimikK+yaMed4Kmeq1h4SaBq4NZRtK706+uql0q+atL7IVm1c/LWUhHG+Uc5DsIjo=
X-Received: by 2002:a6b:bec7:: with SMTP id o190mr9016969iof.44.1593272391146;
 Sat, 27 Jun 2020 08:39:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200627055515.764165-1-zeba.hrvoje@gmail.com> <b83a2cc5-31ea-9782-1eeb-70b8537f92c3@acm.org>
In-Reply-To: <b83a2cc5-31ea-9782-1eeb-70b8537f92c3@acm.org>
From:   Hrvoje Zeba <zeba.hrvoje@gmail.com>
Date:   Sat, 27 Jun 2020 11:39:40 -0400
Message-ID: <CAEsUgYj6NDoHPHN+i7tsR5P0tj1Dj47ixJFhFf8UVpm7kagfhg@mail.gmail.com>
Subject: Re: [RFC PATCH] Fix usage of stdatomic.h for C++ compilers
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Jun 27, 2020 at 11:27 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> On 2020-06-26 22:55, Hrvoje Zeba wrote:
> > Since b9c0bf79aa8, liburing.h doesn't compile with C++ compilers. C++
> > provides it's own <atomic> interface and <stdatomic.h> can't be used. This
> > is a minimal change to use <atomic> variants where needed.
>
> I was not aware that liburing supports C++ compilers?
>

Why is this there then?
https://git.kernel.dk/cgit/liburing/tree/src/include/liburing.h#n6

> >  struct io_uring_cq {
> > -     unsigned *khead;
> > -     unsigned *ktail;
> > +     atomic_uint *khead;
> > +     atomic_uint *ktail;
>
> I think this is the wrong way to make liburing again compatible with
> C++ compilers. Changing these data types causes all dereferences of
> these pointers to be translated by the compiler into sequentially
> consistent atomic instructions. I expect this patch to have a
> negative impact on the performance of liburing.
>

Any suggestions?
