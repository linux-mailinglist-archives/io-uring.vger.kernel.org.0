Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2251F3352
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 07:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgFIFVt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 01:21:49 -0400
Received: from bonobo.birch.relay.mailchannels.net ([23.83.209.22]:27143 "EHLO
        bonobo.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725770AbgFIFVs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 01:21:48 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 67BE8321347;
        Tue,  9 Jun 2020 05:16:19 +0000 (UTC)
Received: from pdx1-sub0-mail-a37.g.dreamhost.com (100-96-6-17.trex.outbound.svc.cluster.local [100.96.6.17])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id AA6083215DE;
        Tue,  9 Jun 2020 05:16:18 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a37.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 09 Jun 2020 05:16:19 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Share-Inform: 15a9380546a9e339_1591679779127_3133092347
X-MC-Loop-Signature: 1591679779126:2971410748
X-MC-Ingress-Time: 1591679779126
Received: from pdx1-sub0-mail-a37.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a37.g.dreamhost.com (Postfix) with ESMTP id 5E5F8B399C;
        Mon,  8 Jun 2020 22:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=K0/1Zej7C3d3qAmqF8QQlHrLxrw=; b=
        C+df2Vdv4g8irbgV8JjvmRZooaepIbEfrUeWYbT3rOyZZ/ZK7OK60lEyfcGyrHtX
        5+tGBE+gDSdAKnQ4YiqY23PiYhdy8iOOi/1sc8HUG4iXjtjvYB6OG/MXXT00nqrP
        2glmsHvpPz4QRV4oWm+9PYGGp1kJraLZRPyfr9qC36c=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a37.g.dreamhost.com (Postfix) with ESMTPSA id 1AF79B3998;
        Mon,  8 Jun 2020 22:16:17 -0700 (PDT)
Date:   Tue, 9 Jun 2020 00:16:18 -0500
X-DH-BACKEND: pdx1-sub0-mail-a37
From:   Clay Harris <bugs@claycon.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
Message-ID: <20200609051618.gh3zsgzc6gujsyer@ps29521.dreamhostps.com>
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
 <4e72f006-418d-91bc-1d6f-c15bce360575@kernel.dk>
 <20200609014014.6njp6fkjrcwrdqbt@ps29521.dreamhostps.com>
 <0cf0596b-4b5c-ddbe-75fa-7914fa995828@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0cf0596b-4b5c-ddbe-75fa-7914fa995828@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudehfedgleehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuggftrfgrthhtvghrnhepveetgeefudeuuefgveffgefhteeuveelkefggeeitdfgledvudelgeetvdfhudehnecuffhomhgrihhnpegtlhgrhigtohhnrdhorhhgnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 08 2020 at 20:14:51 -0600, Jens Axboe quoth thus:

> On 6/8/20 7:40 PM, Clay Harris wrote:
> > On Mon, Jun 08 2020 at 14:19:56 -0600, Jens Axboe quoth thus:
> > 
> >> On 6/8/20 5:21 AM, Clay Harris wrote:
> >>> On Sun, May 31 2020 at 08:46:03 -0600, Jens Axboe quoth thus:
> >>>
> >>>> On 5/31/20 6:47 AM, Clay Harris wrote:
> >>>>> Tested on kernel 5.6.14
> >>>>>
> >>>>> $ ./closetest closetest.c
> >>>>>
> >>>>> path closetest.c open on fd 3 with O_RDONLY
> >>>>>  ---- io_uring close(3)
> >>>>>  ---- ordinary close(3)
> >>>>> ordinary close(3) failed, errno 9: Bad file descriptor
> >>>>>
> >>>>>
> >>>>> $ ./closetest closetest.c opath
> >>>>>
> >>>>> path closetest.c open on fd 3 with O_PATH
> >>>>>  ---- io_uring close(3)
> >>>>> io_uring close() failed, errno 9: Bad file descriptor
> >>>>>  ---- ordinary close(3)
> >>>>> ordinary close(3) returned 0
> >>>>
> >>>> Can you include the test case, please? Should be an easy fix, but no
> >>>> point rewriting a test case if I can avoid it...
> >>>
> >>> Sure.  Here's a cleaned-up test program.
> >>> https://claycon.org/software/io_uring/tests/close_opath.c
> >>
> >> Thanks for sending this - but it's GPL v3, I can't take that. I'll
> >> probably just add an O_PATH test case to the existing open-close test
> >> cases.
> > 
> > I didn't realize that would be an issue.
> > I'll change it.  Would you prefer GPL 2, or should I just delete the
> > license line altogether?
> 
> It's not a huge deal, but at the same time I see no reason to add GPL
> v3 unless I absolutely have to (and I don't). So yeah, if you could
> just post with MIT (like the other test programs), then that'd be
> preferable.

* Change license to MIT.
Done.

> -- 
> Jens Axboe
