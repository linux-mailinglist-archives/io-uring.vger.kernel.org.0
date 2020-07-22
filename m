Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FB462290DB
	for <lists+io-uring@lfdr.de>; Wed, 22 Jul 2020 08:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728696AbgGVGay (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jul 2020 02:30:54 -0400
Received: from verein.lst.de ([213.95.11.211]:54974 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgGVGay (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 22 Jul 2020 02:30:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4624868AFE; Wed, 22 Jul 2020 08:30:51 +0200 (CEST)
Date:   Wed, 22 Jul 2020 08:30:50 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org
Subject: Re: io_uring vs in_compat_syscall()
Message-ID: <20200722063050.GA24968@lst.de>
References: <b754dad5-ee85-8a2f-f41a-8bdc56de42e8@kernel.dk> <8987E376-6B13-4798-BDBA-616A457447CF@amacapital.net> <20200721070709.GB11432@lst.de> <CALCETrXWZBXZuCeRYvYY8AWG51e_P3bOeNeqc8zXPLOTDTHY0g@mail.gmail.com> <20200721143412.GA8099@lst.de> <CALCETrWMQpKe7jqw2t39yn4HgGhGTSEFGK6MPR4wPs=tBBhjbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWMQpKe7jqw2t39yn4HgGhGTSEFGK6MPR4wPs=tBBhjbg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 21, 2020 at 10:25:24AM -0700, Andy Lutomirski wrote:
> On Tue, Jul 21, 2020 at 7:34 AM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Tue, Jul 21, 2020 at 07:31:02AM -0700, Andy Lutomirski wrote:
> > > > What do you mean with "properly wired up".  Do you really want to spread
> > > > ->compat_foo methods everywhere, including read and write?  I found
> > > > in_compat_syscall() a lot small and easier to maintain than all the
> > > > separate compat cruft.
> > >
> > > I was imagining using a flag.  Some of the net code uses
> > > MSG_CMSG_COMPAT for this purpose.
> >
> > Killing that nightmarish monster is what actually got me into looking
> > io_uring and starting this thread.
> 
> I agree that MSG_CMSG_COMPAT is nasty, but I think the concept is
> sound -- rather than tracking whether we're compat by using a
> different function or a per-thread variable, actually explicitly
> tracking the mode seems sensible.

I very strongly disagree.  Two recent projects I did was to remove
the compat_exec mess, and the compat get/setsockopt mess, and each
time it removed hundreds of lines of code duplicating native
functionality, often in slightly broken ways.  We need a generic
out of band way to transfer the information down and just check in
in a few strategic places, and in_compat_syscall() does the right
thing for that.

> If we're going to play in_compat_syscall() games, let's please make
> io_uring_enter() return -EINVAL if in_compat_syscall() != ctx->compat.

That sounds like a plan, but still doesn't help with submissions from
the offload WQ or the sqpoll thread.
