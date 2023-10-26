Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 135437D7B09
	for <lists+io-uring@lfdr.de>; Thu, 26 Oct 2023 04:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjJZCsj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 22:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjJZCsi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 22:48:38 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AB7A4;
        Wed, 25 Oct 2023 19:48:35 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 165815C025C;
        Wed, 25 Oct 2023 22:48:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 25 Oct 2023 22:48:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1698288512; x=1698374912; bh=p4
        mm4cDQKu961WJfXf5ZKxas8+Y9WvFVFAtM+Ijwt/o=; b=k4S+qME+vDCFI/L+OE
        XhNh0TqTdiBzriTPN5QsC9VvK6NV7nRTgPgoflUo/Y15/p+SOYJChzCnnvvmUd8I
        Do6TnS/l2w1DNQaC1iOX9X8HTIlUta5vP7HmYBwLJSCAyQr+1VBpMN9eSDi+6/8L
        JQl2cfx+sQgmzrCPVBdJlCylt+iDrEgThoMNL3aVmpXtym84z87A2m/YSJ4HwRJ2
        LbXnBcuvlbkAw7wz1IMdPq51p0hlKNQkBSuyGp1vRvhu5RXI+tDtXJzXo1LqPX9R
        DA8BX+MzBEn+95d0qWPlS6QGorvS6X6G4WaetdVSWe7Kcq9ORkxmp47o8Ze9LaJm
        cdPA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698288512; x=1698374912; bh=p4mm4cDQKu961
        WJfXf5ZKxas8+Y9WvFVFAtM+Ijwt/o=; b=m37B8FGmXPiLCc/wixUuL3tx5MeWN
        WEV60oXL8y0gVVM6KpZp5O6HuLZSV0rjWdQqW8EyyFds3CHZ3FbJxXbgOpmv4fif
        9t7bFiqNtfu6+UYovL/Z7wtCNAXOIjpAPiaKpcmS6CVZ+XFrFJq4e9fHwrTMMUbs
        ViqWd0t4nd5ERoVmkgQCvl/nQouQwRrvhkphcaeeA7IZoGQOBLIE9xNaQgM+DHqy
        0+M6o3X0Izp66zzVTXcoJA3mEfEGBCEnlZJP74bJ9gXYG0jA1/QiZSSLktlxKV+S
        0eG856i7RlL8AoCCq8kMZX9zkhBjF6iu2UgpgrN8A1VwEOFm1tJM2rE8g==
X-ME-Sender: <xms:f9M5ZeU1dIt9cfQJ7qS3wBOpMIQGjnlwQESweSSCRl7kZg90RsB1kg>
    <xme:f9M5ZanM-FUf5OmTE2tJj68dUdw6ulCKBBDQkYNeVUCOuhieHn1gwYR3VWcPv8QFC
    ug2EGuusn1xnGS2fA>
X-ME-Received: <xmr:f9M5ZSZS-1MWjXlshEB1KHVR4G3ge99u8NPsxT6c2V1HGI3N-rkzhF7ry-1obz9O1W9OedCYI6UJEKhNrskS485jvq3ZOELYlOMvrqmqcy0V5RNdirYpxNIyasjB>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrledugdeivdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:f9M5ZVWKu4F5X-DEJrWOUPifnOs31R0_UQbFRqLMaVqXVq8QpKEYIQ>
    <xmx:f9M5ZYkIwjOWSJdlvQK6OTpGPmHv3W1VbW_UKaP_SDHxfQAWCaUWQg>
    <xmx:f9M5ZadUe4qrbz4oamXvJv7LqT7MyNns6TimcIUCzqxeyTaUdyf78w>
    <xmx:gNM5ZRfPz3Z-EL5qoeIfU84DQ-FTiFEcdK-pab72Trhe8Slka9CEgQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Oct 2023 22:48:31 -0400 (EDT)
Date:   Wed, 25 Oct 2023 19:48:29 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        Ricardo =?utf-8?Q?Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
        gustavo.padovan@collabora.com, zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
Subject: Re: task hung in ext4_fallocate #2
Message-ID: <20231026024829.vcnlmdmwi5hjjquz@awork3.anarazel.de>
References: <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
 <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
 <20231025153135.kfnldzle3rglmfvp@awork3.anarazel.de>
 <b5578447-81f6-4207-b83d-812da7c981a5@kernel.dk>
 <20231025161405.eroaskwdauj57wz6@awork3.anarazel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231025161405.eroaskwdauj57wz6@awork3.anarazel.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-10-25 09:14:05 -0700, Andres Freund wrote:
> On 2023-10-25 09:36:01 -0600, Jens Axboe wrote:
> > On 10/25/23 9:31 AM, Andres Freund wrote:
> > > Hi,
> > >
> > > On 2023-10-24 18:34:05 -0600, Jens Axboe wrote:
> > >> Yeah I'm going to do a revert of the io_uring side, which effectively
> > >> disables it. Then a revised series can be done, and when done, we could
> > >> bring it back.
> > >
> > > I'm queueing a test to confirm that the revert actually fixes things.
> > > Is there still benefit in testing your other patch in addition
> > > upstream?
> >
> > Don't think there's much point to testing the quick hack, I believe it
> > should work. So testing the most recent revert is useful, though I also
> > fully expect that to work.
>
> I'll leave it running for a few hours, just to be sure.

Quite a few hours and > 15TBW written later, no hang....

Greetings,

Andres Freund
