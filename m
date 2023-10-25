Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8D47D7103
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 17:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjJYPbo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 11:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjJYPbn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 11:31:43 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA80E12A;
        Wed, 25 Oct 2023 08:31:40 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 485AD5C0256;
        Wed, 25 Oct 2023 11:31:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 25 Oct 2023 11:31:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1698247898; x=1698334298; bh=ai
        Kn5n1MmCFRtwo5nv9MUY6v3o4pix8zhxOK0UebHoU=; b=qlZiRKS1hTasqNg1V3
        6EMQ8eFcjguQKiyx51dthiJWn7PeWXjptt4ZasZPeaAfXtd+4AjNiqBz30JkSe+m
        wcfV9E8sb/udijqwx5QXCsTwzB/JpLeYFG8tHyUC6XIm6gXr+JlyZMl8EYJ/v11S
        4IbbZQN6P3qqP4+ksKOEPTT7ukFoXc22TiMXG2FLtv0uAsAKp+M0Iv0wzJWSkFrQ
        cXM2xmoYnMWrpFw+ul+phHv0BCh2XetJM0tbfLWK9f42ljNZF+LWvVquGOIJX3uT
        /G7wT6PDIol/jbH3jW6QhTbpPaejIYZnGQyFIjhwxOO8dSjSFQ6MJTewiaKbjpsz
        hfgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1698247898; x=1698334298; bh=aiKn5n1MmCFRt
        wo5nv9MUY6v3o4pix8zhxOK0UebHoU=; b=aG9JQ6VcOe1TF/z3wY+6b2jsplXNQ
        dvyUMjp8wxRK6ywjTxpq1Fje6P4fcB0nQnMMee5wHdZB+a4ucUng9pMOeABOxxml
        m+Nm391FtIFjLuZ+iIzeU2nTLpQeJV6DovlZ+iTE9ia0WZtay9sC2hgBOnnOMeUj
        bZ7dq/YSybDz4p/ZpNivfjUDAi4kKRiTMy/Du8zIcsvNs8Mwo7yhLOtC8efeDlv8
        jSvpxcr33uNq8UEXIBw/FQ0SLwU+xw8OJAIRsWLGbpZwYZvLfPPWRfctjavcjfjh
        Nsnz9NzJaSVFC2EUpkmHRkwjXOQ9fwrBcbg1h6+Y4DO6Tyik7GSf4M0Ag==
X-ME-Sender: <xms:2TQ5ZZNkE7jiyLA5sxO2KBcCBVjxDOG-6cx4NWSYf7qgUzIXhYfgKg>
    <xme:2TQ5Zb8AGEbtUuW00kjcw56S5UR9PUKppskZ8dr0q5lqTfLpcV1bX0fbSzg7MaKIY
    _rOhdKPFyX-MM0lDw>
X-ME-Received: <xmr:2TQ5ZYRDWLJnMACKezkyJtr7feL_zaHfk29WQYAYUxKkGK9TWfgQaStAg2GrpVf8jrquInXyxwCfyahw3l6l57Mlp6z4gww59p8-tkxjtt-SvI0P7bNRNe_1gVa5>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvkedrledtgdekhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteevudei
    tedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:2TQ5ZVvD0DZDpRu3VBcgin-3OVd5hv0URQYfmEEvNuiHX1-gfAELtw>
    <xmx:2TQ5ZRe0jiSIvdqTRlRm2ObbkelgGlivqFcfYgPihiaXuT7ax2IODQ>
    <xmx:2TQ5ZR30qT7waBTZvxtt_dx9vwkqKyAaa-J200x2C2ExSWrqXAOoRg>
    <xmx:2jQ5ZSV6djBNyKGJ1S8TXj4qcTlm6tPOEeaSJJ-Potq7Nezc1pSEnQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 Oct 2023 11:31:37 -0400 (EDT)
Date:   Wed, 25 Oct 2023 08:31:35 -0700
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
Message-ID: <20231025153135.kfnldzle3rglmfvp@awork3.anarazel.de>
References: <20231017033725.r6pfo5a4ayqisct7@awork3.anarazel.de>
 <20231018004335.GA593012@mit.edu>
 <20231018025009.ulkykpefwdgpfvzf@awork3.anarazel.de>
 <ZTcZ9+n+jX6UDrgd@dread.disaster.area>
 <74921cba-6237-4303-bb4c-baa22aaf497b@kernel.dk>
 <ab4f311b-9700-4d3d-8f2e-09ccbcfb3df5@kernel.dk>
 <ZThcATP9zOoxb4Ec@dread.disaster.area>
 <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ace2109-3d05-4ca0-b582-f7b8db88a0ca@kernel.dk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-10-24 18:34:05 -0600, Jens Axboe wrote:
> Yeah I'm going to do a revert of the io_uring side, which effectively
> disables it. Then a revised series can be done, and when done, we could
> bring it back.

I'm queueing a test to confirm that the revert actually fixes things. Is there
still benefit in testing your other patch in addition upstream?

Greetings,

Andres Freund
