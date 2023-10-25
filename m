Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971C47D74E8
	for <lists+io-uring@lfdr.de>; Wed, 25 Oct 2023 21:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbjJYT4H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 Oct 2023 15:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjJYT4H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 Oct 2023 15:56:07 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D841418A
        for <io-uring@vger.kernel.org>; Wed, 25 Oct 2023 12:56:03 -0700 (PDT)
Received: from cwcc.thunk.org (pool-173-48-111-143.bstnma.fios.verizon.net [173.48.111.143])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 39PJtesp008031
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 25 Oct 2023 15:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1698263743; bh=egWKI6Iz0QgLqS+y6Zn0Qw6hj+csHebk5he/tWaHlZY=;
        h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
        b=T0JQ2xzbsDgpLjFepBG8GSkJWwi7gpQ0KTulZWVXkqq2URX4iOSfjCl2PRROaSo/N
         vGddlVrqKXhqaxMat6EIb74sZc6l0EExVttcMjgATngbb6/b4ZwrM8L5v+I0beLO6P
         ZwwZFw2W2b94ZhESEN2XttKmNmLCwfMgJJMlZvxpGJB7s0OYV/KVEMRkl3gMLWJZE6
         aFNukrswNMBxijO5JafhpFVncZTgn046BTw/6Fitt44oI3VTwSMxgzehTjufokRw0z
         aTtn2cLB0LIP/F5bwRq5lv+wE2mj0Srsird2Z7SvUeHOywwOTlcUhbmFaqnZjIaL3z
         SLY1GbWxIfdLg==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id AB7A015C0247; Wed, 25 Oct 2023 15:55:39 -0400 (EDT)
Date:   Wed, 25 Oct 2023 15:55:39 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andres Freund <andres@anarazel.de>,
        Dave Chinner <david@fromorbit.com>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        Shreeya Patel <shreeya.patel@collabora.com>,
        linux-ext4@vger.kernel.org,
        Ricardo =?iso-8859-1?Q?Ca=F1uelo?= 
        <ricardo.canuelo@collabora.com>, gustavo.padovan@collabora.com,
        zsm@google.com, garrick@google.com,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        io-uring@vger.kernel.org
Subject: Re: task hung in ext4_fallocate #2
Message-ID: <20231025195539.GA2897448@mit.edu>
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 25, 2023 at 09:36:01AM -0600, Jens Axboe wrote:
> 
> FWIW, I wrote a small test case which does seem to trigger it very fast,
> as expected:

Great!  I was about to ask if we had an easy reproducer.  Any chance
you can package this up as an test in xfstests?  Or would you like
some help with that?

Thanks,

					- Ted
