Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390C276B857
	for <lists+io-uring@lfdr.de>; Tue,  1 Aug 2023 17:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbjHAPSD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Aug 2023 11:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233357AbjHAPR5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Aug 2023 11:17:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CE21BFD;
        Tue,  1 Aug 2023 08:17:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21563615F0;
        Tue,  1 Aug 2023 15:17:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28E8EC433C8;
        Tue,  1 Aug 2023 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690903073;
        bh=hfRGaV6yboPnBO9pA1IpwxJNT51RUxnuhdss519eHV8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LvpLGlED5UHnlbdTkSFYnGnIuSguBVZxACXAL7nnZXkvZ2P1iow2oO5fVYncJ8dbM
         kNAszJfLNu9XAEwyEDUTRw7NCJBw0Jj6s4Pa9mpCBl/t9BgbJE3F8YNH/NDuSbNPRG
         XPVhn18LxrzKeI0lKgskl6LmIEus4TH6kgyXsp+yLMfOAQgN2oJp/NXjPWILQuTkFM
         Vd1sxYfjw0eIvjY8C8AN6Djj5dZTOM22o6EFzJHpFeWeq+bLGDhwTWCwKXFI4dFzro
         MlpT/6MwjYLQW2hAARIc2i0cNEWLAaV4usj5jsiw/BV4Cc67JpUjwIbffcKoNvmLY1
         E7s3dfdUYrv3A==
Date:   Tue, 1 Aug 2023 09:17:50 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@meta.com>,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 1/3] io_uring: split req init from submit
Message-ID: <ZMkiHoVbdBoUSxLy@kbusch-mbp.dhcp.thefacebook.com>
References: <20230728201449.3350962-1-kbusch@meta.com>
 <9a360c1f-dc9a-e8b4-dbb0-39c99509bb8d@gmail.com>
 <22d99997-8626-024d-fae2-791bb0a094c3@kernel.dk>
 <ce3e1cf4-40a0-adde-e66b-487048b3871d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce3e1cf4-40a0-adde-e66b-487048b3871d@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 01, 2023 at 03:13:59PM +0100, Pavel Begunkov wrote:
> On 7/31/23 22:00, Jens Axboe wrote:
> > On 7/31/23 6:53?AM, Pavel Begunkov wrote:
> > > On 7/28/23 21:14, Keith Busch wrote:
> > > > From: Keith Busch <kbusch@kernel.org>
> > > > 
> > > > Split the req initialization and link handling from the submit. This
> > > > simplifies the submit path since everything that can fail is separate
> > > > from it, and makes it easier to create batched submissions later.
> > > 
> > > Keith, I don't think this prep patch does us any good, I'd rather
> > > shove the link assembling code further out of the common path. I like
> > > the first version more (see [1]). I'd suggest to merge it, and do
> > > cleaning up after.
> > > 
> > > I'll also say that IMHO the overhead is well justified. It's not only
> > > about having multiple nvmes, the problem slows down cases mixing storage
> > > with net and the rest of IO in a single ring.
> > > 
> > > [1] https://lore.kernel.org/io-uring/20230504162427.1099469-1-kbusch@meta.com/
> > 
> > The downside of that one, to me, is that it just serializes all of it
> > and we end up looping over the submission list twice.
> 
> Right, and there is nothing can be done if we want to know about all
> requests in advance, at least without changing uapi and/or adding
> userspace hints.
> 
> > With alloc+init
> > split, at least we get some locality wins by grouping the setup side of
> > the requests.
> 
> I don't think I follow, what grouping do you mean? As far as I see, v1
> and v2 are essentially same with the difference of whether you have a
> helper for setting up links or not, see io_setup_link() from v2. In both
> cases it's executed in the same sequence:
> 
> 1) init (generic init + opcode init + link setup) each request and put
>    into a temporary list.
> 2) go go over the list and submit them one by one
> 
> And after inlining they should look pretty close.

The main difference in this one compared to the original version is that
everything in the 2nd loop is just for the final dispatch. Anything that
can fail, fallback, or defer to async happens in the first loop. I'm not
sure that makes a difference in runtime, but having the 2nd loop handle
only fast-path requests was what I set out to do for this version.
