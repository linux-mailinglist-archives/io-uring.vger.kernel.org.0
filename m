Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063E47D7182
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 18:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbjJYQOK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 12:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbjJYQOJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 12:14:09 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE9DE5;
        Wed, 25 Oct 2023 09:14:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5E67F5C03C5;
        Wed, 25 Oct 2023 12:14:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 25 Oct 2023 12:14:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1698250447; x=1698336847; bh=Nh
        EnZWqoZo0Kg5L43AInk7QmO23ZyI1W/a2ppKah2xI=; b=dbYwhZ7Tv74eqFulAd
        HJNvPPEoIALttHmioLz5VmWTpFzKIHQLwfBmtFialUIIGf190m8TwreQWLzSADxW
        qcTsDXI+isDz8oRt8+WmQmM1iuwwXD4HE6n/UEej5ZjmfMsilj1S+H19hDq4K27j
        vvf/gfYz62vGGr2RHN3q/9uumAM0Zf9Q4VoF6j4sQ9s5kHuN+EtvxzJR6rcZwazA
        QUfrDXe07sZ8QN1mxTd3rMckLxCK8W/o0xSbGxE/Vzyw0BHEIX8LeOpJKGOP9Atc
        fbhS0yUTMfAzXKSl1CEsdWmuq/7EYt0IHQJ0ik77KwlAH3e2mVYd5PfgTWs+xHfo
        WJ/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698250447; x=1698336847; bh=NhEnZWqoZo0Kg
        5L43AInk7QmO23ZyI1W/a2ppKah2xI=; b=hGmvOkmvpQ2QdvlXIyOJvc9vN+7In
        tge1djYHERodtqJUDbk0nr87nbxIPj1AzmPSCEkClBmYUWpkpaz1ygEbuHiatT//
        6Ke0WUCVNk+llZRFq9XMjZ4VX68HLrrZD1C0BgQVSlIr3JSKbrO2Q8lYtDWSSofY
        iG4VNkS+2bKZ0zrqpzvEUcrCJcfsp8EcW4gVJ31I9OP0eCKt3Phzkxa7WmQbIvgU
        L99Av9JK8kjKgEmUzdjR1TTQm+rh8SrVzrWAHeja8Fodlg46WllcVszz3N3Mufuf
        Asjz8liLYM2Uj3S3MXfMs1qwAhgYx9x8teCzIGLtX4of/a8nhqLuWjLIg==
X-ME-Sender: <xms:zz45ZZu72-pXflJyqWvQRNYFJUTMHcBx2QxC2EO6KY3e4x4ifHq3kA>
    <xme:zz45ZSc_9g5c-W2cA8UYS1WnwWabvIf0cVB3uigL-VCZNJgDQIggfTUNMmdKgn7rR
    SNnaINg_AZomcSqrQ>
X-ME-Received: <xmr:zz45ZcxF6pybymZ2jOIvrVeeGoG0EdBGgrlMm47mdiCPKJu2fkoVq8r4Mk6SPfgLeWjJk18lLzG_URcPzsUMQEfLUoe52MFSsrAZvNe4Dor-tJP52Jgk33GAcBfM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrledtgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:zz45ZQNsaM8xj_2jJ0pqYKPaM3qAPAFML9Bz6wbRZyV2p0W_7_gpsQ>
    <xmx:zz45ZZ9ziIlVw_IXmYsXrbj_Cqryv2eFyJjM-bgFQCGuk2j5-_ZUIQ>
    <xmx:zz45ZQWxdCBQBfP59mkvfpcCja94Wq33cd-bBq_FeMRjeJAFcO08ZA>
    <xmx:zz45Za0r_5DFZ0Rjp6SpWoJXYcKDdjfsTwLFwvDLc9yAOMgIDc1T7g>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Oct 2023 12:14:06 -0400 (EDT)
Date:   Wed, 25 Oct 2023 09:14:05 -0700
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
Message-ID: <20231025161405.eroaskwdauj57wz6@awork3.anarazel.de>
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
 <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
 <20231025153135.kfnldzle3rglmfvp@awork3.anarazel.de>
 <b5578447-81f6-4207-b83d-812da7c981a5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5578447-81f6-4207-b83d-812da7c981a5@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-10-25 09:36:01 -0600, Jens Axboe wrote:
> On 10/25/23 9:31 AM, Andres Freund wrote:
> > Hi,
> > 
> > On 2023-10-24 18:34:05 -0600, Jens Axboe wrote:
> >> Yeah I'm going to do a revert of the io_uring side, which effectively
> >> disables it. Then a revised series can be done, and when done, we could
> >> bring it back.
> > 
> > I'm queueing a test to confirm that the revert actually fixes things.
> > Is there still benefit in testing your other patch in addition
> > upstream?
> 
> Don't think there's much point to testing the quick hack, I believe it
> should work. So testing the most recent revert is useful, though I also
> fully expect that to work.

I'll leave it running for a few hours, just to be sure.


> And then we can test the re-enable once that is sent out, I did prepare a
> series. But timing is obviously unfortunate for that, as it'll miss 6.6 and
> now also 6.7 due to the report timing.

Yea, it's too bad. I'm somewhat lucky to have hit it at all, it was just due
to having procrastinated on talk preparation and having to test things on my
laptop instead of my workstation (where the same workload never triggered the
problem), while travelling.


> FWIW, I wrote a small test case which does seem to trigger it very fast,
> as expected:

Ah, nice.

It's too bad stuff like this can't be discovered by lockdep et al..

Greetings,

Andres Freund
