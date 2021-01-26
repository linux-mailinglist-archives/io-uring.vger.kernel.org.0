Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2868305835
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 11:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S314274AbhAZXC5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 18:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393932AbhAZSoG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jan 2021 13:44:06 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CBAC061573;
        Tue, 26 Jan 2021 10:43:26 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id u4so2762377pjn.4;
        Tue, 26 Jan 2021 10:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U3RPz+yz5AMp3COYBrptJ7ltjHtzj0/cdcpauOw8WBU=;
        b=X9aY9/+Zz6rhHUHSCZi31LIkXY402OPSNF3bjd6GPjxm8bY4WDKzggONJr69N4Ix4L
         Nw05q4kEsfsEsKecwQFLcm/cWozvVyRgoOUk+RmDk+SS9UdPE8/VkxMkr4YemvykFzhn
         V++o1omImUL9IBmeNUXQiWL0QpbIUR1m5g+aBGI7qdyCK2BFQ5NuQ4cfrd/Vp5/Rb3g5
         7L3OosH1bkTXY+Z1GyobTc6ag2rF+3FS7tf9gi8OEPZvMjhxjYWmVnKuOs8CPx1Fg37I
         nHGaWfVRVZrgD0qABG2SByGBi9iTMPRViI25LYaHCAWuHNyRMAEPBAbd/bzDGglCFYib
         8buw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U3RPz+yz5AMp3COYBrptJ7ltjHtzj0/cdcpauOw8WBU=;
        b=QZOoKaDOLjsMHc0kakWYcUMlU0saYRzAO8ztke9/eVRnRGjYiUDG4/lYUdqUyzGjXb
         BinCkJ/fV6QOSg6a8yNdD9cCzgzNC68BS0kv/X5oohQSCuCI0FhhBvZcnB6Z4I7bRwXW
         1onkHEfdYpi6hShIw00qz2zTFDo1wdnDX8Z7p92FxsV5V1h496cVfsYE9ltLBR90itgP
         qwp35yI994ADTafGPp2ZSj8A1v+1NR3YeYOYpLkgLqUuxhHfon/4N8qFD7NfeezSvrxO
         giAvyWx3jlrjTQuIKoMS5R3p8n79N6I64sK6rfB3H05B+iNPiC0MxzFmtJHwTqbrF7UD
         IOTw==
X-Gm-Message-State: AOAM531LKOUpdAb+6G4t8pj71pWFxLo8w7R5qSHLQ7CsUHfUuFmocHnJ
        cKDSkTJCXxxUH/nDaJiSV+DaXYP/3F7wRIM1n5M=
X-Google-Smtp-Source: ABdhPJz0urdgQobV9Pm2eFglcydn6H6KKBed1DlnJTCPTUYjCfBAxGqjD4LQfmC85lP4UALqC0O4vD4il/DeUkg3UrI=
X-Received: by 2002:a17:90b:716:: with SMTP id s22mr1156878pjz.223.1611686606310;
 Tue, 26 Jan 2021 10:43:26 -0800 (PST)
MIME-Version: 1.0
References: <20201220065025.116516-1-goldstein.w.n@gmail.com>
 <0cdf2aac-6364-742d-debb-cfd58b4c6f2b@gmail.com> <20201222021043.GA139782@gmail.com>
 <32c9ce7e-569d-3f94-535e-00e072de772e@gmail.com> <CAFUsyf+m8SseZ1NzZoYJe4KSH30v-XJeP5P9FvtxQT_5bvsK9Q@mail.gmail.com>
 <792d56e4-b258-65b4-d0b5-dbfd728d5a02@gmail.com>
In-Reply-To: <792d56e4-b258-65b4-d0b5-dbfd728d5a02@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Tue, 26 Jan 2021 13:43:15 -0500
Message-ID: <CAFUsyfK8OSDzfNCCwVPD8O=Fp0XSHWQ+HRCiC36BA-rH+c9D7g@mail.gmail.com>
Subject: Re: [PATCH] fs: io_uring.c: Add skip option for __io_sqe_files_update
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     noah <goldstein.n@wustl.edu>, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>,
        "open list:FILESYSTEMS (VFS and infrastructure)" 
        <linux-fsdevel@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jan 26, 2021 at 12:24 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 26/01/2021 17:14, Noah Goldstein wrote:
> > On Tue, Jan 26, 2021 at 7:29 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >>
> >> On 22/12/2020 02:10, Noah Goldstein wrote:
> >>> On Sun, Dec 20, 2020 at 03:18:05PM +0000, Pavel Begunkov wrote:
> >>>> On 20/12/2020 06:50, noah wrote:> From: noah <goldstein.n@wustl.edu>
> >>>>>
> >>>>> This patch makes it so that specify a file descriptor value of -2 will
> >>>>> skip updating the corresponding fixed file index.
> >>>>>
> >>>>> This will allow for users to reduce the number of syscalls necessary
> >>>>> to update a sparse file range when using the fixed file option.
> >>>>
> >>>> Answering the github thread -- it's indeed a simple change, I had it the
> >>>> same day you posted the issue. See below it's a bit cleaner. However, I
> >>>> want to first review "io_uring: buffer registration enhancements", and
> >>>> if it's good, for easier merging/etc I'd rather prefer to let it go
> >>>> first (even if partially).
> >>
> >> Noah, want to give it a try? I've just sent a prep patch, with it you
> >> can implement it cleaner with one continue.
> >
> >  Absolutely. Will get on it ASAP.
>
> Perfect. Even better if you add a liburing test
>
> --
> Pavel Begunkov

Do you think the return value should not include files skipped?

i.e register fds[1, 2, 3, -1] with no errors returns 4. should fds[1,
2, -2, -1] return 3 or 4 do you think?

Personally think the latter makes more sense. Thoughts?
