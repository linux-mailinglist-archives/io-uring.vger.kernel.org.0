Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D681F0977
	for <lists+io-uring@lfdr.de>; Sun,  7 Jun 2020 05:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726035AbgFGDz5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Jun 2020 23:55:57 -0400
Received: from lavender.maple.relay.mailchannels.net ([23.83.214.99]:3284 "EHLO
        lavender.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725818AbgFGDz4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Jun 2020 23:55:56 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id A4BBA541124
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 03:55:55 +0000 (UTC)
Received: from pdx1-sub0-mail-a55.g.dreamhost.com (100-96-137-11.trex.outbound.svc.cluster.local [100.96.137.11])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 1B7C454110A
        for <io-uring@vger.kernel.org>; Sun,  7 Jun 2020 03:55:55 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a55.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Sun, 07 Jun 2020 03:55:55 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Whistle-Hook: 42f23df46f847e2c_1591502155325_1939362845
X-MC-Loop-Signature: 1591502155324:3271733420
X-MC-Ingress-Time: 1591502155324
Received: from pdx1-sub0-mail-a55.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a55.g.dreamhost.com (Postfix) with ESMTP id D2D6495B6B
        for <io-uring@vger.kernel.org>; Sat,  6 Jun 2020 20:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:subject:message-id:mime-version:content-type; s=claycon.org;
         bh=Nl0c42P13IhzxA9INFqA5H8ad0k=; b=CsXseoxveeBoh6yGakKn3zQRruw1
        NWyiTA0Y2gMuWrQWU4rOke/JLgU75y4x+s734UgSMdclxeLOv5OoCWQHfp5Io82v
        +MAq4ZFeonQgjxxOQfxJCXaW6Ah14spId5v17u5y8LCOLuq5DOE/wbk0nxbbyH0P
        YgxI8c7pRcvi9BE=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a55.g.dreamhost.com (Postfix) with ESMTPSA id A2B7B95B9C
        for <io-uring@vger.kernel.org>; Sat,  6 Jun 2020 20:55:54 -0700 (PDT)
Date:   Sat, 6 Jun 2020 22:55:55 -0500
X-DH-BACKEND: pdx1-sub0-mail-a55
From:   Clay Harris <bugs@claycon.org>
To:     io-uring@vger.kernel.org
Subject: io_uring_queue_exit is REALLY slow
Message-ID: <20200607035555.tusxvwejhnb5lz2m@ps29521.dreamhostps.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: 0
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudegjedggeekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkgggtuggfsehttdertddtredvnecuhfhrohhmpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqeenucggtffrrghtthgvrhhnpeeufedvieejudekveekgeekffdtvedufedtkeffffduudeitdduleefudegffdujeenucfkphepieelrdduieefrddukeeirdejgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehpshdvleehvddurdgurhgvrghmhhhoshhtphhsrdgtohhmpdhinhgvthepieelrdduieefrddukeeirdejgedprhgvthhurhhnqdhprghthhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqpdhmrghilhhfrhhomhepsghughhssegtlhgrhigtohhnrdhorhhgpdhnrhgtphhtthhopehiohdquhhrihhnghesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

So, I realize that this probably isn't something that you've looked
at yet.  But, I was interested in a different criteria looking at
io_uring.  That is how efficient it is for small numbers of requests
which don't transfer much data.  In other words, what is the minimum
amount of io_uring work for which a program speed-up can be obtained.
I realize that this is highly dependent on how much overlap can be
gained with async processing.

In order to get a baseline, I wrote a test program which performs
4 opens, followed by 4 read + closes.  For the baseline I
intentionally used files in /proc so that there would be minimum
async and I could set IOSQE_ASYNC later.  I was quite surprised
by the result:  Almost the entire program wall time was used in
the io_uring_queue_exit() call.

I wrote another test program which does just inits followed by exits.
There are clock_gettime()s around the io_uring_queue_init(8, &ring, 0)
and io_uring_queue_exit() calls and I printed the ratio of the
io_uring_queue_exit() elapsed time and the sum of elapsed time of
both calls.

The result varied between 0.94 and 0.99.  In other words, exit is
between 16 and 100 times slower than init.  Average ratio was
around 0.97.  Looking at the liburing code, exit does just what
I'd expect (unmap pages and close io_uring fd).

I would have bet the ratio would be less than 0.50.  No
operations were ever performed by the ring, so there should be
minimal cleanup.  Even if the kernel needed to do a bunch of
cleanup, it shouldn't need the pages mapped into user space to work;
same thing for the fd being open in the user process.

Seems like there is some room for optimization here.
