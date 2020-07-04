Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0E0A2145B7
	for <lists+io-uring@lfdr.de>; Sat,  4 Jul 2020 14:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGDMA3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jul 2020 08:00:29 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36851 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726766AbgGDMA3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jul 2020 08:00:29 -0400
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id D4B915C00CB;
        Sat,  4 Jul 2020 08:00:27 -0400 (EDT)
Received: from imap21 ([10.202.2.71])
  by compute7.internal (MEProxy); Sat, 04 Jul 2020 08:00:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm3; bh=Opp5dblxLmd6FX01xBHX4h+wRxi9sIf
        7URGYwLXo9so=; b=hOPfBQ6pSoy3nitCCBBrh0tBD4npcZlJpedZSyiJCIRFCNA
        vCJKtHO2VHZRBQMXFb6O6a/SGP8njAN8DNAgRjF6jMwuvC4wZuNQB7BmS49Mk3T2
        xxYr4wrodhWxNRO4dAvoFiRzCtUkruEFL1BEahWrhiWfiY2V5dGGPbVwsBUE/Y9C
        RulSiZrdrYcU7l31ytgKZ44x9MJUamiWXCJdjnwZxLYHnxtjXUVzXra7hTGGEXHp
        d4lpxDIkoWUZLPvpTRYQsat12IF/fc/hUK34Hr1vQRcchmgfiwmUPHEEIgR359uW
        xxdnjOq+mfHy2ni1GYQtLzRdk1fHIXedlCld2Qg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Opp5db
        lxLmd6FX01xBHX4h+wRxi9sIf7URGYwLXo9so=; b=OcWLqcKE4D3wnX9xRCaXkM
        aPpHClnaZ2kSUPdqivuJyKKnwmCpCT15nbZw8dUq+9adco+A+vuKWPTdvbdbwBMX
        89eIZuMAf+KbrugCbSM3Lf8+5CNNGH0xm4TOUDhN93FL/hPB3WpCfD6sW7DZd5WE
        hZAw66/VDblA5en3Pg7VUiYsqTCSrwnKwsHHFh0Qns5GEPyZbHs4n+2mPfviQfk4
        KbPnKkqNuReqIl/HM8YFc3EmEcyN3isyDf7tVohIzuLplDmXcG8+h59p7CZFwP9h
        XMKqJQnihZQECs6WkkjO0Pgua+06tMtRP2Ycl6t+Cyp+xqsIsvvhHNeYAaN3vOlg
        ==
X-ME-Sender: <xms:W28AX9lkaweCVAKigb1pXPZj4ODywnnlWNoG6BtHbmVOcnpjrrR4fA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderreejnecuhfhrohhmpedfjfhivghk
    vgcuuggvucggrhhivghsfdcuoehhuggvvhhrihgvshesfhgrshhtmhgrihhlrdgtohhmqe
    enucggtffrrghtthgvrhhnpeejgfeihfevvdegvdefheetheegudekkedtfedtheduieff
    ieffleeffeehheelffenucffohhmrghinhepghhithhhuhgsrdgtohhmnecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhguvghvrhhivghssehf
    rghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:W28AX40CVxMBYdTCcGnMZQuUm8CNSmiXiVPJJR2nZKcl-e_5MQ6-yA>
    <xmx:W28AXzocs_-z2IAExKkB6r3ppDt-pHRqB9n15-OWkt1_Auy6HIbopw>
    <xmx:W28AX9mM-mBElBjcjYTiGSepqaZykr2W0OhHk7O-ik8yFSdOtYBm0w>
    <xmx:W28AXwga8ulbczmLPHOh1aIt5EpBwK_ZKnXtZQbBkabtF5wQXQxEyA>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 68C2A660069; Sat,  4 Jul 2020 08:00:27 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.3.0-dev0-576-gfe2cd66-fm-20200629.001-gfe2cd668
Mime-Version: 1.0
Message-Id: <e8b0f7e4-066b-4218-9c36-682939a9c461@www.fastmail.com>
In-Reply-To: <CAKq9yRjBUuTPAp7xuRhZ8X+OugiD0gm6LCbr6ZGzwKyG8hmvkw@mail.gmail.com>
References: <CAKq9yRg1NkEOei-G8JKMMo-cTCp128aPPONeLCGPFLqD5w+fkA@mail.gmail.com>
 <193a1dc9-6b88-bb23-3cb5-cc72e109f41b@kernel.dk>
 <CAKq9yRjSewr5z2r8G7dt68RBX4VA9phGpFumKCipNgLzXMdcdQ@mail.gmail.com>
 <e68f971b-8b4a-0cdf-8688-288d6f6da56e@kernel.dk>
 <CAKq9yRjBUuTPAp7xuRhZ8X+OugiD0gm6LCbr6ZGzwKyG8hmvkw@mail.gmail.com>
Date:   Sat, 04 Jul 2020 14:00:07 +0200
From:   "Hieke de Vries" <hdevries@fastmail.com>
To:     "Daniele Salvatore Albano" <d.albano@gmail.com>,
        "Jens Axboe" <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Subject: =?UTF-8?Q?Re:_Keep_getting_the_same_buffer_ID_when_RECV_with_IOSQE=5FBUF?=
 =?UTF-8?Q?FER=5FSELECT?=
Content-Type: text/plain
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There was a bug in the echo server code with re-registering the buffer: https://github.com/frevib/io_uring-echo-server/commit/aa6f2a09ca14c6aa17779a22343b9e7d4b3c7994 

Please try the latest master branch, maybe it'll help you with your own code as well. 

--
Hielke de Vries


On Fri, Jul 3, 2020, at 22:22, Daniele Salvatore Albano wrote:
> On Fri, 3 Jul 2020 at 21:12, Jens Axboe <axboe@kernel.dk> wrote:
> >
> > On 7/3/20 1:09 PM, Daniele Salvatore Albano wrote:
> > > On Fri, 3 Jul 2020, 20:57 Jens Axboe, <axboe@kernel.dk <mailto:axboe@kernel.dk>> wrote:
> > >
> > >     On 7/3/20 12:48 PM, Daniele Salvatore Albano wrote:
> > >     > Hi,
> > >     >
> > >     > I have recently started to play with io_uring and liburing but I am
> > >     > facing an odd issue, of course initially I thought it was my code but
> > >     > after further investigation and testing some other code (
> > >     > https://github.com/frevib/io_uring-echo-server/tree/io-uring-op-provide-buffers
> > >     > ) I faced the same behaviour.
> > >     >
> > >     > When using the IOSQE_BUFFER_SELECT with RECV I always get the first
> > >     > read right but all the subsequent return a buffer id different from
> > >     > what was used by the kernel.
> > >     >
> > >     > The problem starts to happen only after io_uring_prep_provide_buffers
> > >     > is invoked to put back the buffer, the bid set is the one from cflags
> > >     >>> 16.
> > >     >
> > >     > The logic is as follow:
> > >     > - io_uring_prep_provide_buffers + io_uring_submit + io_uring_wait_cqe
> > >     > initialize all the buffers at the beginning
> > >     > - within io_uring_for_each_cqe, when accepting a new connection a recv
> > >     > sqe is submitted with the IOSQE_BUFFER_SELECT flag
> > >     > - within io_uring_for_each_cqe, when recv a send sqe is submitted
> > >     > using as buffer the one specified in cflags >> 16
> > >     > - within io_uring_for_each_cqe, when send a provide buffers for the
> > >     > bid used to send the data and a recv sqes are submitted.
> > >     >
> > >     > If I drop io_uring_prep_provide_buffers both in my code and in the
> > >     > code I referenced above it just works, but of course at some point
> > >     > there are no more buffers available.
> > >     >
> > >     > To further debug the issue I reduced the amount of provided buffers
> > >     > and started to print out the entire bufferset and I noticed that after
> > >     > the first correct RECV the kernel stores the data in the first buffer
> > >     > of the group id but always returns the last buffer id.
> > >     > It is like after calling io_uring_prep_provide_buffers the information
> > >     > on the kernel side gets corrupted, I tried to follow the logic on the
> > >     > kernel side but there is nothing apparent that would make me
> > >     > understand why I am facing this behaviour.
> > >     >
> > >     > The original author of that code told me on SO that he wrote & tested
> > >     > it on the kernel 5.6 + the provide buffers branch, I am facing this
> > >     > issue with 5.7.6, 5.8-rc1 and 5.8-rc3. The liburing library is built
> > >     > out of the branch, I didn't do too much testing with different
> > >     > versions but I tried to figure out where the issue was for the last
> > >     > week and within this period I have pulled multiple times the repo.
> > >     >
> > >     > Any hint or suggestion?
> > >
> > >     Do you have a simple test case for this that can be run standalone?
> > >     I'll take a look, but I'd rather not spend time re-creating a test case
> > >     if you already have one.
> > >
> > >     --
> > >     Jens Axboe
> > >
> > >
> > > I will shrink down the code to produce a simple test case but not sure
> > > how much code I will be able to lift because it's showing this
> > > behaviour on a second recv of a connection so I will need to keep all
> > > the boilerplate code to get there.
> >
> > That's fine, I'm just looking to avoid having to write it from scratch.
> > Plus a test case is easier to deal with than trying to write a test case
> > based on your description, less room for interpretative errors.
> >
> > --
> > Jens Axboe
> >
> 
> Hi,
> 
> attached the test case, to make it as compact as possible I dropped as
> well the error code checking as well.
> 
> I have added some fprintf around the code, just connect to localhost
> port 5001 using telnet (it will send a line, it will be a bit easier
> to check the output).
> 
> On the first message you will see a like like
> [CQE][RECV] fd 5, cqe flags high: 9, cqe flags low: 1
> 
> and a number of lines to show the content of the buffers with the last
> buffer containing the message sent via telnet.
> 
> On the second message you will instead see again
> [CQE][RECV] fd 5, cqe flags high: 5, cqe flags low: 1
> 
> but the buffer actually containing the sent line will be the number 0.
> 
> On all the successive submits the used buffer will still be 0 but the
> high part of cqe->flags will still contain 9.
> 
> Or at least this is what I am experiencing.
> 
> If you comment out line 110, 111 and 112 it will work as (I think)
> expected but of course you will finish the buffers (and get an
> undefined behaviour because the code is not managing the errors at
> all).
> 
> 
> Thanks!
> Daniele
> 
> Attachments:
> * test.c
