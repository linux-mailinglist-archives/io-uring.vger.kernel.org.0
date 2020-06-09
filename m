Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684171F320C
	for <lists+io-uring@lfdr.de>; Tue,  9 Jun 2020 03:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgFIBkR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 21:40:17 -0400
Received: from egyptian.birch.relay.mailchannels.net ([23.83.209.56]:7682 "EHLO
        egyptian.birch.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726013AbgFIBkR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 21:40:17 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id A3CB71E1018;
        Tue,  9 Jun 2020 01:40:15 +0000 (UTC)
Received: from pdx1-sub0-mail-a67.g.dreamhost.com (100-97-66-8.trex.outbound.svc.cluster.local [100.97.66.8])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 03B0D1E0F5D;
        Tue,  9 Jun 2020 01:40:15 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a67.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 09 Jun 2020 01:40:15 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Shelf-Eyes: 558b70ec1f99a425_1591666815469_3831082671
X-MC-Loop-Signature: 1591666815468:2559724499
X-MC-Ingress-Time: 1591666815468
Received: from pdx1-sub0-mail-a67.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a67.g.dreamhost.com (Postfix) with ESMTP id 8009AB37D4;
        Mon,  8 Jun 2020 18:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=N8ozjO+JLm0ZmC5W98EF5rQkmAM=; b=
        O/+pMLIrDeAV9bo5A9EbT+iVzCB/WellnQOaLyD7GdSMvyOd9GqfqZyW09L10gzj
        qCgmwwRCOFOGApMcT2x7l7Bjw/+2RcIWl3OgwRHWNhoiB3pEwzYrcSk+XltZFPlY
        kTEJR0EXfU9PlXBdyAmOy9dz4StyTjY8oQuguhZvwnY=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a67.g.dreamhost.com (Postfix) with ESMTPSA id 55257B37CD;
        Mon,  8 Jun 2020 18:40:14 -0700 (PDT)
Date:   Mon, 8 Jun 2020 20:40:14 -0500
X-DH-BACKEND: pdx1-sub0-mail-a67
From:   Clay Harris <bugs@claycon.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
Message-ID: <20200609014014.6njp6fkjrcwrdqbt@ps29521.dreamhostps.com>
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
 <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
 <4e72f006-418d-91bc-1d6f-c15bce360575@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e72f006-418d-91bc-1d6f-c15bce360575@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudehfedggeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuggftrfgrthhtvghrnhepveetgeefudeuuefgveffgefhteeuveelkefggeeitdfgledvudelgeetvdfhudehnecuffhomhgrihhnpegtlhgrhigtohhnrdhorhhgnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 08 2020 at 14:19:56 -0600, Jens Axboe quoth thus:

> On 6/8/20 5:21 AM, Clay Harris wrote:
> > On Sun, May 31 2020 at 08:46:03 -0600, Jens Axboe quoth thus:
> > 
> >> On 5/31/20 6:47 AM, Clay Harris wrote:
> >>> Tested on kernel 5.6.14
> >>>
> >>> $ ./closetest closetest.c
> >>>
> >>> path closetest.c open on fd 3 with O_RDONLY
> >>>  ---- io_uring close(3)
> >>>  ---- ordinary close(3)
> >>> ordinary close(3) failed, errno 9: Bad file descriptor
> >>>
> >>>
> >>> $ ./closetest closetest.c opath
> >>>
> >>> path closetest.c open on fd 3 with O_PATH
> >>>  ---- io_uring close(3)
> >>> io_uring close() failed, errno 9: Bad file descriptor
> >>>  ---- ordinary close(3)
> >>> ordinary close(3) returned 0
> >>
> >> Can you include the test case, please? Should be an easy fix, but no
> >> point rewriting a test case if I can avoid it...
> > 
> > Sure.  Here's a cleaned-up test program.
> > https://claycon.org/software/io_uring/tests/close_opath.c
> 
> Thanks for sending this - but it's GPL v3, I can't take that. I'll
> probably just add an O_PATH test case to the existing open-close test
> cases.

I didn't realize that would be an issue.
I'll change it.  Would you prefer GPL 2, or should I just delete the
license line altogether?

> -- 
> Jens Axboe
