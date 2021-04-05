Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 483733540F8
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 12:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbhDEJwf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 05:52:35 -0400
Received: from bee.birch.relay.mailchannels.net ([23.83.209.14]:4346 "EHLO
        bee.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232447AbhDEJwe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 05:52:34 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 85712641932;
        Mon,  5 Apr 2021 09:52:28 +0000 (UTC)
Received: from pdx1-sub0-mail-a4.g.dreamhost.com (100-101-162-27.trex.outbound.svc.cluster.local [100.101.162.27])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 38DA3641974;
        Mon,  5 Apr 2021 09:52:26 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a4.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384)
        by 100.101.162.27 (trex/6.1.1);
        Mon, 05 Apr 2021 09:52:28 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Zesty-Scare: 730e00893b76dd73_1617616348360_199990610
X-MC-Loop-Signature: 1617616348360:1019506863
X-MC-Ingress-Time: 1617616348360
Received: from pdx1-sub0-mail-a4.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a4.g.dreamhost.com (Postfix) with ESMTP id ED5CB8AA00;
        Mon,  5 Apr 2021 09:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=Vrhal5cCI5tV7jWaoj77626dDsQ=; b=
        sWhJkzCSxHXJahvTBlaLdYq9bKDXYuIWyi6g9s7nLwY3fVhOUKc+ndqw98lfW0cs
        5DxSBp+rx2bSdwvyHqivE5bUc4Mc1HYB6NHwy/jGZhGtUVRWnIbJ63NPcRxWvNpP
        gzX/8GK71i8RGWDRAqhrq1zHrVMIa75iAzyuYU3BycA=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a4.g.dreamhost.com (Postfix) with ESMTPSA id 05A1788AE4;
        Mon,  5 Apr 2021 09:52:24 +0000 (UTC)
Date:   Mon, 5 Apr 2021 04:52:23 -0500
X-DH-BACKEND: pdx1-sub0-mail-a4
From:   Clay Harris <bugs@claycon.org>
To:     Tavian Barnes <tavianator@tavianator.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        io-uring@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>
Subject: Re: [PATCH v5 0/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210405095223.dulkil23btvxagg7@ps29521.dreamhostps.com>
References: <YGMIwcxAIJPAWGLu@wantstofly.org>
 <20210404044216.w7dqrioahqvbg4dz@ps29521.dreamhostps.com>
 <CABg4E-keAb4b4BMQDbdyj16p8GTBQgc2ribSzJCGpY-SMnn9TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABg4E-keAb4b4BMQDbdyj16p8GTBQgc2ribSzJCGpY-SMnn9TA@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Apr 04 2021 at 13:25:00 -0400, Tavian Barnes quoth thus:

> On Sun, 4 Apr 2021 at 00:42, Clay Harris <bugs@claycon.org> wrote:
> > On Tue, Mar 30 2021 at 14:17:21 +0300, Lennert Buytenhek quoth thus:
> >
> > > ...
> > >
> > > - Make IORING_OP_GETDENTS read from the directory's current position
> > >   if the specified offset value is -1 (IORING_FEAT_RW_CUR_POS).
> > >   (Requested / pointed out by Tavian Barnes.)
> >
> > This seems like a good feature.  As I understand it, this would
> > allow submitting pairs of IORING_OP_GETDENTS with IOSQE_IO_HARDLINK
> > wherein the first specifies the current offset and the second specifies
> > offset -1, thereby halfing the number of kernel round trips for N getdents64.
> 
> Yep, that was my main motivation for this suggestion.
> 
> > If the entire directory fits into the first buffer, the second would
> > indicate EOF.  This would certainly seem like a win, but note there
> > are diminishing returns as the directory size increases, versus just
> > doubling the buffer size.
> 
> True, but most directories are small, so I expect it would be a
> benefit most of the time.  Even for big directories you still get two
> buffers filled with one syscall, same as if you did a conventional
> getdents64() with twice as big a buffer.
> 
> > An alternate / additional idea you may wish to consider is changing
> > getdents64 itself.
> >
> > Ordinary read functions must return 0 length to indicate EOF, because
> > they can return arbitrary data.  This is not the case for getdents64.
> >
> > 1) Define a struct linux_dirent of minimum size containing an abnormal
> > value as a sentinel.  d_off = 0 or -1 should work.
> >
> > 2) Implement a flag for getdents64.
> 
> Sadly getdents64() doesn't take a flags argument.  We'd probably need
> a new syscall.
> 
> > IF
> >         the flag is set AND
> >         we are returning a non-zero length buffer AND
> >         there is room in the buffer for the sentinel structure AND
> >         a getdents64 call using the d_off of the last struct in the
> >                 buffer would return EOF
> > THEN
> >         append the sentinel struct to the buffer.
> >
> >
> > Using the arrangement, we would still handle a 0 length return as an
> > EOF, but if we see the sentinel struct, we can skip the additional call
> > altogether.  The saves all of the pairing of buffers and extra logic,
> > and unless we're unlucky and the sentinel structure did not fit in
> > the buffer at EOF, would always reduce the number of getdents64
> > calls by one.
> >
> > Moreover, if the flag was available outside of io_uring, for smaller
> > directories, this feature would cut the number of directory reads
> > of readdir(3) by up to half.
> 
> If we need a new syscall anyway, the calling convention could be
> adjusted to indicate EOF more easily than that, e.g.
> 
> int getdents2(int fd, void *buf, size_t *size, unsigned long flags);
> 
> With 0 being EOF, 1 being not-EOF, and -1 for error, or something.

Good point!  I was hedging the idea above with "if the flag was
available outside of io_uring" to allow an internal-only flag.
A new syscall would certainly be more useful as it would improve
every readdir(3) call, and of course could be called from inside
io_uring more efficiently than the current getdents64.

Alas, adding a new syscall like this is a little beyond my level of
expertise.  Would you (or anyone else reading this) have any interest in
implementing a getdents2?

> -- 
> Tavian Barnes
