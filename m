Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D449B22025A
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2020 04:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbgGOCcq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 22:32:46 -0400
Received: from lavender.maple.relay.mailchannels.net ([23.83.214.99]:30972
        "EHLO lavender.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726928AbgGOCcq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 22:32:46 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id B84804807EB;
        Wed, 15 Jul 2020 02:32:44 +0000 (UTC)
Received: from pdx1-sub0-mail-a3.g.dreamhost.com (100-96-19-29.trex.outbound.svc.cluster.local [100.96.19.29])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id E52B1480728;
        Wed, 15 Jul 2020 02:32:43 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a3.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Wed, 15 Jul 2020 02:32:44 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Obese-Exultant: 03f3d88478c806fd_1594780364181_2084006027
X-MC-Loop-Signature: 1594780364181:2887457248
X-MC-Ingress-Time: 1594780364181
Received: from pdx1-sub0-mail-a3.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a3.g.dreamhost.com (Postfix) with ESMTP id 6A9067F7C7;
        Tue, 14 Jul 2020 19:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=viBoyj8OCx2ih5yLNFpLKLTUS2s=; b=
        c1DcIHsJjY0AYy8THZU4Ks/e59AgOh7oU0xM541ko/ebPIHFqw0fXsbQFnX8nIoy
        dhKbdJt8laaSnGTKQRs9gKYbn66L4ugwbnRJWZDpK1cpJ7qvEAHfjoQFNTAWNJhD
        HPYGTCmvWxa3cCVuFhtvYsPcombKGRrME8lKRYt6Tn0=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a3.g.dreamhost.com (Postfix) with ESMTPSA id 9EE697F7C0;
        Tue, 14 Jul 2020 19:32:41 -0700 (PDT)
Date:   Tue, 14 Jul 2020 21:32:40 -0500
X-DH-BACKEND: pdx1-sub0-mail-a3
From:   Clay Harris <bugs@claycon.org>
To:     Josh Triplett <josh@joshtriplett.org>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
Message-ID: <20200715023240.r6wyekihzc2jadpm@ps29521.dreamhostps.com>
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
 <20200714225905.jqlvdvxx564rykxu@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200714225905.jqlvdvxx564rykxu@ps29521.dreamhostps.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduiedrfedugdeitdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucggtffrrghtthgvrhhnpefgtdekjeehffefvdfhhedttdehkeejgfegiedtjedthfeuvdfgieevkeekvdfhvdenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 14 2020 at 17:59:05 -0500, Clay Harris quoth thus:

> On Tue, Jul 14 2020 at 14:08:26 -0700, Josh Triplett quoth thus:
> 
> > The other next step would be to add an IORING_OP_CLOSE_FIXED_FILE
> > (separate from the existing CLOSE op) that removes an entry currently in
> > the fixed file table and calls fput on it. (With some care, that
> > *should* be possible even for an entry that was originally registered
> > from a file descriptor.)

I'm curious why you wouldn't use IOSQE_FIXED_FILE here.  I understand
your reasoning for OPEN_FIXED_FILE, but using the flag with the existing
CLOSE OP seems like a perfect fit.  To me, this looks like a suboptimal
precedent that would result in defining a new opcode for every request
which could accept either a fixed file or process descriptor.
