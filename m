Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947322DCDBB
	for <lists+io-uring@lfdr.de>; Thu, 17 Dec 2020 09:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLQIk4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Dec 2020 03:40:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgLQIk4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Dec 2020 03:40:56 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511CCC061794
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:40:16 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 81so26673225ioc.13
        for <io-uring@vger.kernel.org>; Thu, 17 Dec 2020 00:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BIO+8LV5NbpYy+cFLjThnoDNTlnxp3H+AEmMIQYBOd4=;
        b=B6Md7a0fZMyz22CjMdzQfsDNk2Fedu7DuJeHHToOhQvbaC1ZxJhpj8qwOdDvFUJEYf
         BbP3KOribhHpYRM6HMiS7dV3lGpo5yUsNRd5SQpvevs2+5sYDUe0VIgy4HAoR2exbA1W
         SfFwYY+189Uy9RQqDrdUg2rVb6wxpDaYiDrHjhCd3zW+ISUXaj4P6AscnKVR/KZLzcqm
         dUgijHe82Xg2xdc/RdnjNDDZrUFKDyL6prVZy1CYu58d2DAENL4RPHl8p+bYwK13wy5Z
         l+NYaVqhZy+yXKbUjR7vPZS8Ds6ijAuHvkHvJqcHau6oBxrZl2n7QMv5KNFpKpaiUhQN
         1lOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BIO+8LV5NbpYy+cFLjThnoDNTlnxp3H+AEmMIQYBOd4=;
        b=Vtt5YKRgHoJ5nsQViNPqg4zoak8qo19OXMuMGWw4bgvBzbGtL9zXQkoUrHh7cc6Cwz
         Ez1wxCovow1wj4hbVjMsJj36K5nMsPTdYtEEVz1TPSBV/CIDBCLlAZuj9x2KyynjwQvy
         NYBAST10xSFVBsNSwZZxBkYAErshsOPpzwxWeY1+37dn7f9yxH8fRNIEFSrA+kKsV9qa
         BBRyOhE4kWwODswTwvdopvNyORI4G250POW5/NMdoVMtn42ovTY1PU76bux22TbAzHKC
         6fAc9E/YF7UfZ0z5nuRoBR1H7bvXtdp+VoJuQ9s2E6pwak2TQ/qt8MST1FFFHUn6MvvG
         Hv8w==
X-Gm-Message-State: AOAM5319uQr6uOG9024Z5yGzKHCkm09xEvij1lSu19yDDT+6/TMUNPPa
        PlnEEV+gXbszhzRGPoLxOSZvAtv4NA5Mo3ua7LEaB3XqhbF/5w==
X-Google-Smtp-Source: ABdhPJzan6MpPb9C9HKgd33aZiGkXtAJKBv04TP+ciU0+K2YgpkS/mqXRlPaINXe3n60nTsXRHC054DKGq6JNM7Ezoc=
X-Received: by 2002:a05:6602:29cf:: with SMTP id z15mr45728679ioq.39.1608194415618;
 Thu, 17 Dec 2020 00:40:15 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <8910B0D3-6C84-448E-8295-3F87CFFB2E77@googlemail.com> <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
In-Reply-To: <CAOKbgA4V5aGLbotXz4Zn-7z8yOP5Jy_gTkpwk3jDSNyVTRCtkg@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Thu, 17 Dec 2020 15:40:04 +0700
Message-ID: <CAOKbgA5X7WWQ4LWN4hXt8Rc5qQOOG24tTyxsKos7KO1ybOeC1w@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Norman Maurer <norman.maurer@googlemail.com>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Dec 17, 2020 at 3:36 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Thu, Dec 17, 2020 at 3:27 PM Norman Maurer
> <norman.maurer@googlemail.com> wrote:
> >
> > I wonder if this is also related to one of the bug-reports we received:
> >
> > https://github.com/netty/netty-incubator-transport-io_uring/issues/14
>
> That is curious. This ticket mentions Shmem though, and in our case it does
> not look suspicious at all. E.g. on a box that has the problem at the moment:
> Shmem:  41856 kB. The box has 256GB of RAM.
>
> But I'd (given my lack of knowledge) expect the issues to be related anyway.

One common thing here is the ticket OP mentions kill -9, and we do use that as
well at least in some circumstances.

-- 
Dmitry Kadashev
