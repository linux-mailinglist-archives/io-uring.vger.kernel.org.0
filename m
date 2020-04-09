Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6C1C1A2DE0
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2020 05:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgDIDT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 23:19:26 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:38009 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgDIDT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 23:19:26 -0400
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id ED5FD200002;
        Thu,  9 Apr 2020 03:19:20 +0000 (UTC)
Date:   Wed, 8 Apr 2020 20:19:18 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v3 0/3] Support userspace-selected fds
Message-ID: <20200409031918.GD6149@localhost>
References: <cover.1586321767.git.josh@joshtriplett.org>
 <20200408122601.kvrdjksjkl7ktgt4@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408122601.kvrdjksjkl7ktgt4@yavin.dot.cyphar.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 08, 2020 at 10:26:01PM +1000, Aleksa Sarai wrote:
> On 2020-04-07, Josh Triplett <josh@joshtriplett.org> wrote:
> > (Note: numbering this updated version v3, to avoid confusion with Jens'
> > v2 that built on my v1. Jens, if you like this approach, please feel
> > free to stack your additional patches from the io_uring-fd-select branch
> > atop this series. 5.8 material, not intended for the current merge window.)
> > 
> > Inspired by the X protocol's handling of XIDs, allow userspace to select
> > the file descriptor opened by a call like openat2, so that it can use
> > the resulting file descriptor in subsequent system calls without waiting
> > for the response to the initial openat2 syscall.
> > 
> > The first patch is independent of the other two; it allows reserving
> > file descriptors below a certain minimum for userspace-selected fd
> > allocation only.
> > 
> > The second patch implements userspace-selected fd allocation for
> > openat2, introducing a new O_SPECIFIC_FD flag and an fd field in struct
> > open_how. In io_uring, this allows sequences like openat2/read/close
> > without waiting for the openat2 to complete. Multiple such sequences can
> > overlap, as long as each uses a distinct file descriptor.
> > 
> > The third patch adds userspace-selected fd allocation to pipe2 as well.
> > I did this partly as a demonstration of how simple it is to wire up
> > O_SPECIFIC_FD support for any fd-allocating system call, and partly in
> > the hopes that this may make it more useful to wire up io_uring support
> > for pipe2 in the future.
> > 
> > If this gets accepted, I'm happy to also write corresponding manpage
> > patches.
> > 
> > v3:
> > This new version has an API to atomically increase the minimum fd and
> > return the previous minimum, rather than just getting and setting the
> > minimum; this makes it easier to allocate a range. (A library that might
> > initialize after the program has already opened other file descriptors
> > may need to check for existing open fds in the range after reserving it,
> > and reserve more fds if needed; this can be done entirely in userspace,
> > and we can't really do anything simpler in the kernel due to limitations
> > on file-descriptor semantics, so this patch series avoids introducing
> > any extra complexity in the kernel.)
> > 
> > This new version also supports a __get_specific_unused_fd_flags call
> > which accepts the limit for RLIMIT_NOFILE as an argument, analogous to
> > __get_unused_fd_flags, since io_uring needs that to correctly handle
> > RLIMIT_NOFILE.
> > 
> > Josh Triplett (3):
> >   fs: Support setting a minimum fd for "lowest available fd" allocation
> >   fs: openat2: Extend open_how to allow userspace-selected fds
> >   fs: pipe2: Support O_SPECIFIC_FD
> 
> Aside from my specific comments and questions, the changes to openat2
> deserve at least one or two selftests.

Agreed. I don't expect this to get merged until it has tests and
manpage patches.

- Josh Triplett
