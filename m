Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308C51F1777
	for <lists+io-uring@lfdr.de>; Mon,  8 Jun 2020 13:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729505AbgFHLVk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Jun 2020 07:21:40 -0400
Received: from blue.elm.relay.mailchannels.net ([23.83.212.20]:19819 "EHLO
        blue.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729437AbgFHLVi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Jun 2020 07:21:38 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 07C1A700812;
        Mon,  8 Jun 2020 11:21:37 +0000 (UTC)
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (100-97-66-8.trex.outbound.svc.cluster.local [100.97.66.8])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id C92F8700266;
        Mon,  8 Jun 2020 11:21:35 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Mon, 08 Jun 2020 11:21:36 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-White-Shade: 7eb0e82f026a6bbc_1591615296238_1528239706
X-MC-Loop-Signature: 1591615296238:730914349
X-MC-Ingress-Time: 1591615296237
Received: from pdx1-sub0-mail-a66.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a66.g.dreamhost.com (Postfix) with ESMTP id 75F077FE5D;
        Mon,  8 Jun 2020 04:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=ddNAsiNNL40sUz0LdUt9t0W1BUQ=; b=
        LiJ0Ivreu1w0WNeIBJQM0pOzbGhA0yzT/GJDms9o5vDWnk/X+iu1cWy3iLtvKgR2
        f6Sh4hwVB+kaXCvreoNfxwsJCS2K/jy3eTcsybSIKwRsuTN51BGUiTx10Amr9zEO
        XZSqE7oVKaZ0R79DnZbBKjzGiVuuBdDkwOrf61JSpGc=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a66.g.dreamhost.com (Postfix) with ESMTPSA id 2EDC47FE62;
        Mon,  8 Jun 2020 04:21:34 -0700 (PDT)
Date:   Mon, 8 Jun 2020 06:21:35 -0500
X-DH-BACKEND: pdx1-sub0-mail-a66
From:   Clay Harris <bugs@claycon.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: IORING_OP_CLOSE fails on fd opened with O_PATH
Message-ID: <20200608112135.itxseus73zgqspys@ps29521.dreamhostps.com>
References: <20200531124740.vbvc6ms7kzw447t2@ps29521.dreamhostps.com>
 <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d8c06cb-7505-e0c5-a7f4-507e7105ce5e@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudehuddggeduucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuggftrfgrthhtvghrnhepveetgeefudeuuefgveffgefhteeuveelkefggeeitdfgledvudelgeetvdfhudehnecuffhomhgrihhnpegtlhgrhigtohhnrdhorhhgnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, May 31 2020 at 08:46:03 -0600, Jens Axboe quoth thus:

> On 5/31/20 6:47 AM, Clay Harris wrote:
> > Tested on kernel 5.6.14
> > 
> > $ ./closetest closetest.c
> > 
> > path closetest.c open on fd 3 with O_RDONLY
> >  ---- io_uring close(3)
> >  ---- ordinary close(3)
> > ordinary close(3) failed, errno 9: Bad file descriptor
> > 
> > 
> > $ ./closetest closetest.c opath
> > 
> > path closetest.c open on fd 3 with O_PATH
> >  ---- io_uring close(3)
> > io_uring close() failed, errno 9: Bad file descriptor
> >  ---- ordinary close(3)
> > ordinary close(3) returned 0
> 
> Can you include the test case, please? Should be an easy fix, but no
> point rewriting a test case if I can avoid it...

Sure.  Here's a cleaned-up test program.
https://claycon.org/software/io_uring/tests/close_opath.c

> -- 
> Jens Axboe
