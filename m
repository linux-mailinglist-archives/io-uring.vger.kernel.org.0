Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 208EF1BAF27
	for <lists+io-uring@lfdr.de>; Mon, 27 Apr 2020 22:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgD0URh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Apr 2020 16:17:37 -0400
Received: from crocodile.birch.relay.mailchannels.net ([23.83.209.45]:48670
        "EHLO crocodile.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726285AbgD0URh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Apr 2020 16:17:37 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id E0D74480DBA;
        Mon, 27 Apr 2020 20:17:35 +0000 (UTC)
Received: from pdx1-sub0-mail-a11.g.dreamhost.com (100-96-7-17.trex.outbound.svc.cluster.local [100.96.7.17])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 345F94811D0;
        Mon, 27 Apr 2020 20:17:35 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a11.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.6);
        Mon, 27 Apr 2020 20:17:35 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Company-Slimy: 38c2caa533483d86_1588018655703_3059198603
X-MC-Loop-Signature: 1588018655703:1560640273
X-MC-Ingress-Time: 1588018655702
Received: from pdx1-sub0-mail-a11.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a11.g.dreamhost.com (Postfix) with ESMTP id E7AE395D8A;
        Mon, 27 Apr 2020 13:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :content-transfer-encoding:in-reply-to; s=claycon.org; bh=IY0jFA
        U7bv1Pu7ZOPm5JviOxICY=; b=syQJJT/x6VRMSZ38TdrDxTAiHa/LvQNReu/sRt
        jb8OM28OWCaJU5pSe8TsNFtXboEvaBLGmHbv9jSzWnL1ETYPcyJY9ts9RJKaPw0h
        5XnctO6BBdfpuwA4BACNqCCGF8G2Zyua2OvvoHPeJ8yrYZRQ+S33qnWOZw8NJoHa
        IjYB0=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a11.g.dreamhost.com (Postfix) with ESMTPSA id A319C95D94;
        Mon, 27 Apr 2020 13:17:33 -0700 (PDT)
Date:   Mon, 27 Apr 2020 15:17:33 -0500
X-DH-BACKEND: pdx1-sub0-mail-a11
From:   Clay Harris <bugs@claycon.org>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: Feature request: Please implement IORING_OP_TEE
Message-ID: <20200427201733.jqcg232zrvoaituh@ps29521.dreamhostps.com>
References: <20200427154031.n354uscqosf76p5z@ps29521.dreamhostps.com>
 <c76b09f0-3437-842e-7106-efb2cac38284@kernel.dk>
 <CAG48ez1fc1_U7AtWAM+Jh6QjV-oAtAW2sQ2XSz9s+53SN_wSFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAG48ez1fc1_U7AtWAM+Jh6QjV-oAtAW2sQ2XSz9s+53SN_wSFg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgddugeehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtugfgjggfsehtqhertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopegrshhmlhdrshhilhgvnhgtvgesghhmrghilhdrtghomh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 27 2020 at 20:22:18 +0200, Jann Horn quoth thus:

> On Mon, Apr 27, 2020 at 5:56 PM Jens Axboe <axboe@kernel.dk> wrote:
> > On 4/27/20 9:40 AM, Clay Harris wrote:
> > > I was excited to see IORING_OP_SPLICE go in, but disappointed that tee
> > > didn't go in at the same time.  It would be very useful to copy pipe
> > > buffers in an async program.
> >
> > Pavel, care to wire up tee? From a quick look, looks like just exposing
> > do_tee() and calling that, so should be trivial.
>=20
> Just out of curiosity:
>=20
> What's the purpose of doing that via io_uring? Non-blocking sys_tee()
> just shoves around some metadata, it doesn't do any I/O, right? Is
> this purely for syscall-batching reasons? (And does that mean that you
> would also add syscalls like epoll_wait() and futex() to io_uring?) Or
> is this because you're worried about blocking on the pipe mutex?

=46rom my perspective -- syscall-batching.

But, if you're going to be working with a very large number of file
descriptors, you'll need to have epoll().  You could do this by building
epoll_wait into io_uring and/or having a separate uring only for IO and
never waiting for completions there, but instead calling epoll() when
there are no ready cqe's.  I'd had assumed that this was already being
looked at because of the definition of IORING_OP_EPOLL_CTL.

----

So, I'd like to take this opportunity to bounce a related thought off
of all of you.  Even with the advent of io_uring, I think the approach
of handling a bunch of IO by marking all of the fds non-blocking and
using epoll() in edge-triggered mode is still valuable.

But, there is an impedance mismatch between splice() / tee() and using
epoll() this way.  (In fact, this applies to all requests that take
both an input and output fd.)  That is the request is working on two
fds, but returning only one status.  In the IO loop, we want to do
IO until we receive an EAGAIN and mark the fd as blocked.  We then
unblock it when epoll() says we can do IO again.  This doesn't work
well when we don't know which fd the EAGAIN was for.  So, we have
to issue a seperate poll() request on the involved fds to find out.

Logically, we'd like to get the status of both fds back from the
initial request, but that's not practical because once an error is
detected on one, the other is not further examined.

So, the idea is to introduce a new flag which could be passed to
any request that takes both an input and output fd.

If the flag is clear, errors are returned exactly as they are now.
If the flag is set, and the error occured with the output fd,
add 1 << 30 to the error number.

As it would be very rare for errors to concurrently be on both fds,
this would be practically as good as simultaneously getting the
status of both fds back.
