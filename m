Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A501B517E
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 02:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDWAsR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 20:48:17 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:2817 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbgDWAsR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 20:48:17 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 9A5F1240008;
        Thu, 23 Apr 2020 00:48:10 +0000 (UTC)
Date:   Wed, 22 Apr 2020 17:48:07 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>, io-uring@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Message-ID: <20200423004807.GC161058@localhost>
References: <cover.1587531463.git.josh@joshtriplett.org>
 <9873b8bd7d14ff8cd2a5782b434b39f076679eeb.1587531463.git.josh@joshtriplett.org>
 <CAKgNAkjo3AeA78XqK-RRGqJHNy1H8SbcjQQQs7+jDwuFgq4YSg@mail.gmail.com>
 <CAJfpegt=xe-8AayW2i3AYrk3q-=Pp_A+Hctsk+=sXoMed5hFQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegt=xe-8AayW2i3AYrk3q-=Pp_A+Hctsk+=sXoMed5hFQA@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 22, 2020 at 09:55:56AM +0200, Miklos Szeredi wrote:
> On Wed, Apr 22, 2020 at 8:06 AM Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
> >
> > [CC += linux-api]
> >
> > On Wed, 22 Apr 2020 at 07:20, Josh Triplett <josh@joshtriplett.org> wrote:
> > >
> > > Inspired by the X protocol's handling of XIDs, allow userspace to select
> > > the file descriptor opened by openat2, so that it can use the resulting
> > > file descriptor in subsequent system calls without waiting for the
> > > response to openat2.
> > >
> > > In io_uring, this allows sequences like openat2/read/close without
> > > waiting for the openat2 to complete. Multiple such sequences can
> > > overlap, as long as each uses a distinct file descriptor.
> 
> If this is primarily an io_uring feature, then why burden the normal
> openat2 API with this?

This feature was inspired by io_uring; it isn't exclusively of value
with io_uring. (And io_uring doesn't normally change the semantics of
syscalls.)

> This would also allow Implementing a private fd table for io_uring.
> I.e. add a flag interpreted by file ops (IORING_PRIVATE_FD), including
> openat2 and freely use the private fd space without having to worry
> about interactions with other parts of the system.

I definitely don't want to add a special kind of file descriptor that
doesn't work in normal syscalls taking file descriptors. A file
descriptor allocated via O_SPECIFIC_FD is an entirely normal file
descriptor, and works anywhere a file descriptor normally works.
