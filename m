Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F381CEF73
	for <lists+io-uring@lfdr.de>; Tue, 12 May 2020 10:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgELIru (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 May 2020 04:47:50 -0400
Received: from antelope.elm.relay.mailchannels.net ([23.83.212.4]:12884 "EHLO
        antelope.elm.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbgELIru (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 May 2020 04:47:50 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 1BD1C400B45;
        Tue, 12 May 2020 08:47:49 +0000 (UTC)
Received: from pdx1-sub0-mail-a5.g.dreamhost.com (100-96-14-72.trex.outbound.svc.cluster.local [100.96.14.72])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 6EB6C4009A7;
        Tue, 12 May 2020 08:47:48 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a5.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Tue, 12 May 2020 08:47:49 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Macabre-Obese: 0d6a13292899d13b_1589273268885_3829639682
X-MC-Loop-Signature: 1589273268885:1688547409
X-MC-Ingress-Time: 1589273268884
Received: from pdx1-sub0-mail-a5.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a5.g.dreamhost.com (Postfix) with ESMTP id 023D47F4CF;
        Tue, 12 May 2020 01:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=p3gYE403RqOs2f+mxuqrllHpHis=; b=
        A4nLXFkrwk/EBAAXWuYyTlCrdF1kdAcHx7zbyhXncdk2oQSiBddbkjdyDMVzPMUc
        9pExc/jN7Ml3oo1I/3k2CH9Xw4ZGvRljKtC97mBvN7QNSqyTekxWI+yPXxBaWnTG
        BLP9RH3X2OWv8Rxs9/s0VkGZVFOVSeAlGmChoXpkPWs=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a5.g.dreamhost.com (Postfix) with ESMTPSA id B0F477F4D0;
        Tue, 12 May 2020 01:47:46 -0700 (PDT)
Date:   Tue, 12 May 2020 03:47:46 -0500
X-DH-BACKEND: pdx1-sub0-mail-a5
From:   Clay Harris <bugs@claycon.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: io_uring statx fails with AT_EMPTY_PATH
Message-ID: <20200512084746.4hegskomd43hqebp@ps29521.dreamhostps.com>
References: <20200427152942.zhe6ncun7ijpbffq@ps29521.dreamhostps.com>
 <560ae971-fd9b-4248-cd56-367bde8f903c@kernel.dk>
 <8298f71d-b4a1-db76-dc21-24d328a2534d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8298f71d-b4a1-db76-dc21-24d328a2534d@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrledvgddtiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeelgfegueegieeugeehieevffejjeeikeetheejfffhtefhgeegtddvledtkefffeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 27 2020 at 10:52:22 -0600, Jens Axboe quoth thus:

> On 4/27/20 10:40 AM, Jens Axboe wrote:
> > On 4/27/20 9:29 AM, Clay Harris wrote:
> >> Jens Axboe recommended that I post io_uring stuff to this list.
> >> So, here goes.
> >>
> >> https://bugzilla.kernel.org/show_bug.cgi?id=207453
> > 
> > The below should fix it.
> 
> Added a test case for this to the liburing regression suite as well.
> 

I have verified that the original bug is fixed as of kernel 5.6.11.

 -- Test 0: statx:fd 3: SUCCEED, file mode 100664
 -- Test 1: statx:path uring_statx.c: SUCCEED, file mode 100664
 -- Test 2: io_uring_statx:fd 3: SUCCEED, file mode 100664
 -- Test 3: io_uring_statx:path uring_statx.c: SUCCEED, file mode 100664
 ---- fd 3 set O_NONBLOCK
 -- Test 4: statx:fd 3 O_NONBLOCK: SUCCEED, file mode 100664
 -- Test 5: io_uring_statx:fd 3 O_NONBLOCK: SUCCEED, file mode 100664

========

I want to note that there are two other issues with io_uring
statx with AT_EMPTY_PATH:

1) Tests 2 and 5 fail (EBADF) if the fd is opened with O_PATH,
   while all of the other tests continue to work fine.

2) io_uring statx returns EBADF when IOSQE_FIXED_FILE is specified,
   but IOSQE_FIXED_FILE + AT_EMPTY_PATH should be a valid combination.

> -- 
> Jens Axboe
