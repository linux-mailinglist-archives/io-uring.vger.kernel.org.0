Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0705698597
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 21:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbjBOUdM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 15:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjBOUdM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 15:33:12 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553E4367E5;
        Wed, 15 Feb 2023 12:33:11 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 893453200900;
        Wed, 15 Feb 2023 15:33:10 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 15 Feb 2023 15:33:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        joshtriplett.org; h=cc:cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1676493190; x=1676579590; bh=BUDNZ68uRUNtVZa35o8Wuor6C
        LvW1YtTpOzM6OuHyl4=; b=Yd+xtUGf6EcrVy5GyRv988NQK2dNattCbY3Dp9mUl
        kkitD8Pw4/L5Q08c0PCtkV454bF16PkcV5XybKbOd1/xq8fZU31etMvj8FnlJBMn
        d1UXPmwBOkUXD/m58UYovDNk0KdjjR4T8HLVDWFCMAa9bqh7bfhf01v2CJZy+Qhx
        Qmkm/tkQMhZTyHfi7iAtqKeYNVQdi2tHRgRR9f8yj0HN6s3mHieHlpV2J8H5cf/2
        i3cQ519Hz1eczH9/whol7V11AvAFkXLkxdMHXFfoQxHkUieJeczOXqKTNDxEYOTE
        HNresvFBU2swzRWz2mQmCs6g8IdAuur76tDP3CZvumAUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1676493190; x=
        1676579590; bh=BUDNZ68uRUNtVZa35o8Wuor6CLvW1YtTpOzM6OuHyl4=; b=M
        WHPKvAu2rXAyeSQ+biaijKHxHObyyQ4HK/6DwpA49wZsQhY+khj9vYbARIX+/hj8
        5MT45xD4CCyqUanF5/OIQq3HQfD5mcBhs7pMLikcqjLupt0CwhjJOEhoM7FGw2g1
        CRHp+Mm3ER1f11VzmAHbkrsBdR3FA94t+ziRaiSu3WOwCFzZ3CdRqMK4DFPvoRjF
        a1Mq7Bd9i820ArFNamvRHZhX9+IvmjI5g1raMp5yitxjUzpGoP1tRUMH4OcWXq1N
        1EbC+PzLCWS89AuyPxSDAWCJW+F8sm+ijSFoOiRxsc5F4iaEICpIERcUcryA+8kY
        Qn7suqGkO8pO3IQ+Hk5HA==
X-ME-Sender: <xms:hUHtY_eYO87S7d7auzBxsbVhMDFBj0Je4pNEbEo8h2HlL1ZmGiu8hQ>
    <xme:hUHtY1MneNhXxj3kbBtQa4W7zdOTKk9KMVBav6faslrHHFgtuEclxsQ4GhfIQM2Ts
    3HyApwE3ThmVXnz6EU>
X-ME-Received: <xmr:hUHtY4ioYVCNpthIiyfw5fhqoeQAp8SsuKRoC5uGnaxtCYZHgNTIdRRVlMc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeihedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtugfgjgesthekredttddtjeenucfhrhhomheplfho
    shhhucfvrhhiphhlvghtthcuoehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhgqe
    enucggtffrrghtthgvrhhnpeegiefhvedvkeelgffgjeejuefguddugefghfejheekgeeh
    ledtudejffejkeehfeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehjohhshhesjhhoshhhthhrihhplhgvthhtrdhorhhg
X-ME-Proxy: <xmx:hUHtYw9eQonGh6iDlCj-4EclZqaVzYgq0FAaHZhjY4kbrC73gHnHkg>
    <xmx:hUHtY7tK2wWTCQFRSA83rOoyPSCVC115IwJytvo6DNjSV4hRUj3GkQ>
    <xmx:hUHtY_FvzRLwSZhTGKN-YMY5aNgqRQzolMAMR2DzkNZ6fkMlhlULtQ>
    <xmx:hkHtY07UgKMgToKw9KUHoaAPNy6im0mDDleVUgT2fXksKqQP87lEQw>
Feedback-ID: i83e94755:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 15 Feb 2023 15:33:09 -0500 (EST)
Date:   Wed, 15 Feb 2023 12:33:08 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Message-ID: <Y+1BhMgNJVoqYlYf@localhost>
References: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
 <03895f24-3540-dae9-1cdd-e3f6d901dec6@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <03895f24-3540-dae9-1cdd-e3f6d901dec6@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 15, 2023 at 10:44:38AM -0700, Jens Axboe wrote:
> On 2/14/23 5:42 PM, Josh Triplett wrote:
> > Add a new flag IORING_REGISTER_USE_REGISTERED_RING (set via the high bit
> > of the opcode) to treat the fd as a registered index rather than a file
> > descriptor.
> > 
> > This makes it possible for a library to open an io_uring, register the
> > ring fd, close the ring fd, and subsequently use the ring entirely via
> > registered index.
> 
> This looks pretty straight forward to me, only real question I had
> was whether using the top bit of the register opcode for this is the
> best choice. But I can't think of better ways to do it, and the space
> is definitely big enough to do that, so looks fine to me.

It seemed like the cleanest way available given the ABI of
io_uring_register, yeah.

> One more comment below:
> 
> > +	if (use_registered_ring) {
> > +		/*
> > +		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
> > +		 * need only dereference our task private array to find it.
> > +		 */
> > +		struct io_uring_task *tctx = current->io_uring;
> 
> I need to double check if it's guaranteed we always have current->io_uring
> assigned here. If the ring is registered we certainly will have it, but
> what if someone calls io_uring_register(2) without having a ring setup
> upfront?
> 
> IOW, I think we need a NULL check here and failing the request at that
> point.

The next line is:

+               if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))

The first part of that condition is the NULL check you're looking for,
right?

- Josh Triplett
