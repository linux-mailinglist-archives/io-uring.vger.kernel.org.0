Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51C91E33DB
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 01:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgEZXqt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 19:46:49 -0400
Received: from lavender.maple.relay.mailchannels.net ([23.83.214.99]:50472
        "EHLO lavender.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725829AbgEZXqt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 19:46:49 -0400
X-Greylist: delayed 461 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2020 19:46:48 EDT
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id DEE21321338;
        Tue, 26 May 2020 23:39:06 +0000 (UTC)
Received: from pdx1-sub0-mail-a79.g.dreamhost.com (100-96-14-14.trex.outbound.svc.cluster.local [100.96.14.14])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 4B0D3321328;
        Tue, 26 May 2020 23:39:06 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a79.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 26 May 2020 23:39:06 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Desert-Tank: 3bef43e157adcf8a_1590536346706_2123188589
X-MC-Loop-Signature: 1590536346706:2441534636
X-MC-Ingress-Time: 1590536346705
Received: from pdx1-sub0-mail-a79.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a79.g.dreamhost.com (Postfix) with ESMTP id CCE29B2BAB;
        Tue, 26 May 2020 16:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=rMrQnqbw/K8jDLgCerFmuUbWlhY=; b=
        WcR6ssBo4jmQsfqbGuOksI4+nt9ux++iCC4PqbEIHxwrGr9g3vdVjx0V3QlEThej
        Ge0AOTsavm+ydETWFoJLyEvnquqwgW5JT6WgX0WoBc1O15BIBKfGg8ScLxSnsGOy
        Z46xOSelhxyOIhPeIy7lTApVIH4HTcBmqIO1AttMq6Y=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a79.g.dreamhost.com (Postfix) with ESMTPSA id 978AAB2BAC;
        Tue, 26 May 2020 16:39:03 -0700 (PDT)
Date:   Tue, 26 May 2020 18:39:03 -0500
X-DH-BACKEND: pdx1-sub0-mail-a79
From:   Clay Harris <bugs@claycon.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] io_uring: call statx directly
Message-ID: <20200526233903.qbzrbqgfhlhe62pr@ps29521.dreamhostps.com>
References: <1590208279-33811-1-git-send-email-bijan.mottahedeh@oracle.com>
 <f00063b9-7926-9739-f599-603cdf052161@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f00063b9-7926-9739-f599-603cdf052161@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedruddvfedgvddvucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuggftrfgrthhtvghrnhepgfdtkeejhefffedvhfehtddtheekjefggeeitdejtdfhuedvgfeiveekkedvhfdvnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26 2020 at 16:59:23 -0600, Jens Axboe quoth thus:

> On 5/22/20 10:31 PM, Bijan Mottahedeh wrote:
> > v1 -> v2
> > 
> > - Separate statx and open in io_kiocb 
> > - Remove external declarations for unused statx interfaces
> > 
> > This patch set is a fix for the liburing statx test failure.
> > 
> > The test fails with a "Miscompare between io_uring and statx" error
> > because the statx system call path has additional processing in vfs_statx():
> > 
> >         stat->result_mask |= STATX_MNT_ID;
> >         if (path.mnt->mnt_root == path.dentry)
> >                 stat->attributes |= STATX_ATTR_MOUNT_ROOT;
> >         stat->attributes_mask |= STATX_ATTR_MOUNT_ROOT;
> > 
> > which then results in different result_mask values.
> > 
> > Allowing the system call to be invoked directly simplifies the io_uring
> > interface and avoids potential future incompatibilities.  I'm not sure
> > if there was other reasoning fort not doing so initially.
> > 
> > One issue I cannot account for is the difference in "used" memory reported
> > by free(1) after running the statx a large (10000) number of times.
> > 
> > The difference is significant ~100k and doesn't really change after
> > dropping caches.
> > 
> > I enabled memory leak detection and couldn't see anything related to the test.
> > 
> > Bijan Mottahedeh (4):
> >   io_uring: add io_statx structure
> >   statx: allow system call to be invoked from io_uring
> >   io_uring: call statx directly
> >   statx: hide interfaces no longer used by io_uring
> > 
> >  fs/internal.h |  4 ++--
> >  fs/io_uring.c | 72 +++++++++++++++--------------------------------------------
> >  fs/stat.c     | 37 +++++++++++++++++-------------
> >  3 files changed, 42 insertions(+), 71 deletions(-)
> 
> Thanks, this looks better. For a bit of history, the initial attempt was
> to do the statx without async offload if we could do so without blocking.
> Without that, we may as well simplify it.

I was thinking that there may be use cases for allowing IOSQE_FIXED_FILE +
AT_EMPTY_PATH.  This sounds like it would make such a thing more difficult.

> -- 
> Jens Axboe
