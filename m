Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD551B5802
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 11:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgDWJU5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 05:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgDWJU4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 05:20:56 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90303C08E934
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 02:20:56 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g16so3799565eds.1
        for <io-uring@vger.kernel.org>; Thu, 23 Apr 2020 02:20:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1fKzs9UovWQeHKCRqMzU4+gFyi6CVq0FjzMI1lp7abI=;
        b=hQ4vhmxQJllZqxQWqkQO6ueXNo7O1v78FH6wjfGEUHMuvcTK6wA2vUqEz3C1aI/LZp
         aZ/huAfGHLDW01pGzo7FdC9w7bjL2pWg3ZiDRaK0k2Y1gaOTjuaTS0x1FXq7LwBiLaGQ
         VuG0FvPZjwVmpjBFBtzUrZ5hL1SjFlYUkoES8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1fKzs9UovWQeHKCRqMzU4+gFyi6CVq0FjzMI1lp7abI=;
        b=H4fSmKs59ZeCFVavgZcxI13bXH4rjyJHq/2sTu2LUc3vaFy3ne56v8i/qakmAsqYqW
         CtSy1EWES68i2O4ARKKJzZekgg16LvdkslIem7admHAIY/SRVsPd89yvq8WkEdfhLo7y
         yU6KqoFnIafMMeBx3klJ+Lz/XTUKUlGB0Yt57QBsvQpZuQyE5ugbGEax+2PuKOEr/AeU
         Ecmk5IqIjTGvdMhTo9qmn2ADpYrw2025PSonwJFw3UCG+4QEnvZyMQXVUaIqhS5eXGhj
         QPgTDgWIT5NGCIf5yzXBea+2ktZzv6PVc+adJ2p15eLv/Pb2GVzVanV08bzixMvHFWBr
         1g4A==
X-Gm-Message-State: AGi0PuYVMkoFTjfjE5GSp8S9wKun/4HJ0sqUBEUfYdPWpx0mAZ0yzGUL
        V7O10Ut2k9TBjYP0I6GPt+BV3llPC2p1PXgoTHvYjw==
X-Google-Smtp-Source: APiQypKj8oyn+h2f8mFaqR1z5vXEJOTxs3DjEG09L+s26Xc24OxlpRRS4PicH0nhHTpmokC33ka7dheyN/a3p12sp/I=
X-Received: by 2002:aa7:c312:: with SMTP id l18mr1973720edq.161.1587633655321;
 Thu, 23 Apr 2020 02:20:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1587531463.git.josh@joshtriplett.org> <9873b8bd7d14ff8cd2a5782b434b39f076679eeb.1587531463.git.josh@joshtriplett.org>
 <CAKgNAkjo3AeA78XqK-RRGqJHNy1H8SbcjQQQs7+jDwuFgq4YSg@mail.gmail.com>
 <CAJfpegt=xe-8AayW2i3AYrk3q-=Pp_A+Hctsk+=sXoMed5hFQA@mail.gmail.com>
 <20200423004807.GC161058@localhost> <CAJfpegtSYKsApx2Dc6VGmc5Fm4SsxtAWAP-Zs052umwK1CjJmQ@mail.gmail.com>
 <20200423044226.GH161058@localhost> <CAJfpeguaVYo-Lf-5Bi=EYJYWdmCfo3BqZA=kj9E5UmDb0mBc1w@mail.gmail.com>
 <20200423073310.GA169998@localhost> <CAJfpegtXj4bSbhpx+=z=R0_ZT8uPEJAAev0O+DVg3AX242e=-g@mail.gmail.com>
 <CAJfpegtgrUACZpYR8wWoTE=Hh4Xi+4rRfrZTxRtaFVpT9GMPjw@mail.gmail.com>
In-Reply-To: <CAJfpegtgrUACZpYR8wWoTE=Hh4Xi+4rRfrZTxRtaFVpT9GMPjw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 23 Apr 2020 11:20:44 +0200
Message-ID: <CAJfpegvcW9Sic8ZXgWfFQ3d8JTr53XABfP8rZzsVhCDBKCgMBw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>, io-uring@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 23, 2020 at 9:57 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Thu, Apr 23, 2020 at 9:45 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> > > I would prefer to not introduce that limitation in the first place, and
> > > instead open normal file descriptors.
> > >
> > > > The point of O_SPECIFIC_FD is to be able to perform short
> > > > sequences of open/dosomething/close without having to block and having
> > > > to issue separate syscalls.
> > >
> > > "close" is not a required component. It's entirely possible to use
> > > io_uring to open a file descriptor, do various things with it, and then
> > > leave it open for subsequent usage via either other io_uring chains or
> > > standalone syscalls.
> >
> > If this use case arraises, we could add an op to dup/move a private
> > descriptor to a public one.  io_uring can return values, right?
> >
> > Still not convinced...
>
> Oh, and we haven't even touched on the biggest advantage of a private
> fd table: not having to dirty a cacheline on fdget/fdput due to the
> possibility of concurrent close() in a MT application.
>
> I believe this is a sticking point in some big enterprise apps and it
> may even be a driving force for io_uring.

https://lwn.net/Articles/787473/

And an interesting (very old) article referenced from above, that
gives yet a new angle on fd allocation issues:

https://lwn.net/Articles/236843/

A private fd space would be perfect for libraries such as glibc.

Thanks,
Miklos
