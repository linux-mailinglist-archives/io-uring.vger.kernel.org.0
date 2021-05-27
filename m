Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B860D393316
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 18:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhE0QDD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 12:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52403 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234995AbhE0QDC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 12:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622131288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zEsO6LWIBJ8kvqkfGIuKBiC43KXVyprE6+dxw+YtbZE=;
        b=BsCFxMPRLLH4GqfEFBsgMlwFtcy7xDITfgRP5q5PvX9LqcgmUGRLlP8H1dEceVSBAEnKfe
        /01/k12ajoJERtzoQOBaKZejcBFlWvAJzUvvvH/qMgeto08QqmnFNq4cHnmMTnmwakSxfM
        VZmPgAL0gHhj6zgb6V2f13juPWOta+Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-78-atf0ovY8OqiNRJAHmN6ZTg-1; Thu, 27 May 2021 12:01:26 -0400
X-MC-Unique: atf0ovY8OqiNRJAHmN6ZTg-1
Received: by mail-wm1-f71.google.com with SMTP id f13-20020a05600c154db0290195f6af2ea9so391587wmg.1
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 09:01:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zEsO6LWIBJ8kvqkfGIuKBiC43KXVyprE6+dxw+YtbZE=;
        b=UHK2hGWMqKex47ucI4mBycG0+zSd1CXLAu08/nOVsCDSV7xYlC3866m6KQvESbQQ11
         BzpZm6Zc5QuAoUYluMvB7uLMxIVrZKuKoPbJlyO/sNGu0QV5zLbXvEJ1tRy2/9IYoKMQ
         vkYWkzbq+7y5xS2aBnviQsjeh5HHVnTGcD7cS8R3rPs6+EeH1Mkc/ww3dDGsKOsw6hlV
         le4kArEJVdj4YM6kFaEIVSyBtdJnAtrFyiE6QR0wHeNtafZd43xm3WqlkBby7FpDALIL
         WQX6Xuykme1E0cpWJb6Wi+TL+AxDNgi4vzlr5pdg5bf+qwO82Xf4Xx/OfEh1wmyRHaV2
         lhxQ==
X-Gm-Message-State: AOAM531wV800kEpmI23DVc+QP/jHx8/zEcqNvzdcbgc0bL4ku5Ll7jkA
        75TwF88is1RXZsh9mMiToWX4DzxiT7tjCCv/TPoMPxISyFvg9cMXaUCZUPvPOhluzQWCUE7EmrY
        ry4zdoQh2IkFuONt42u2gn65uUQY4b9RG6FM=
X-Received: by 2002:a7b:cbc4:: with SMTP id n4mr9624033wmi.153.1622131285353;
        Thu, 27 May 2021 09:01:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJygl1J2DS7crdUFqQq888Qjvuqv93IVrTNdFeG/mkfw0jtLppmxD1RtmHozD/bE8OPZkzC2xZ5/SGeyLyT7lfU=
X-Received: by 2002:a7b:cbc4:: with SMTP id n4mr9624012wmi.153.1622131285136;
 Thu, 27 May 2021 09:01:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210526223445.317749-1-jforbes@fedoraproject.org>
 <aa130828-03c9-b49b-ab31-1fb83a0349fb@kernel.dk> <CAFbkSA1G2ajKQg4eA947dv0Pcmyf-JQbkn8-jYnmUeMAEpfHtw@mail.gmail.com>
 <01c2a63f-23f6-2228-264d-6f3e581e647d@kernel.dk>
In-Reply-To: <01c2a63f-23f6-2228-264d-6f3e581e647d@kernel.dk>
From:   Justin Forbes <jforbes@redhat.com>
Date:   Thu, 27 May 2021 11:01:13 -0500
Message-ID: <CAFbkSA2zt5QLBH0S8pcBROCaV3zSw_M-RvaQ-2yccCKgV-_2BQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring: Remove CONFIG_EXPERT
To:     Jens Axboe <axboe@kernel.dk>
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 27, 2021 at 9:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/27/21 8:12 AM, Justin Forbes wrote:
> > On Thu, May 27, 2021 at 8:43 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 5/26/21 4:34 PM, Justin M. Forbes wrote:
> >>> While IO_URING has been in fairly heavy development, it is hidden behind
> >>> CONFIG_EXPERT with a default of on.  It has been long enough now that I
> >>> think we should remove EXPERT and allow users and distros to decide how
> >>> they want this config option set without jumping through hoops.
> >>
> >> The whole point of EXPERT is to ensure that it doesn't get turned off
> >> "by accident". It's a core feature, and something that more and more
> >> apps or libraries are relying on. It's not something I intended to ever
> >> go away, just like it would never go away for eg futex or epoll support.
> >>
> >
> > I am not arguing with that, I don't expect it will go away. I
> > certainly do not have an issue with it defaulting to on, and I didn't
> > even submit this with intention to turn it off for default Fedora. I
> > do think that there are cases where people might not wish it turned on
> > at this point in time. Hiding it behind EXPERT makes it much more
> > difficult than it needs to be.  There are plenty of config options
> > that are largely expected default and not hidden behind EXPERT.
>
> Right there are, but not really core kernel features like the ones
> I mentioned. Hence my argument for why it's correct as-is and I
> don't think it should be changed.
>

Honestly, this is fair, and I understand your concerns behind it. I
think my real issue is that there is no simple way to override one
EXPERT setting without having to set them all.  It would be nice if
expert were a "visible if" menu, setting defaults if not selected,
which allows direct override with a config file. Perhaps I will try to
fix this in kbuild.

Justin

