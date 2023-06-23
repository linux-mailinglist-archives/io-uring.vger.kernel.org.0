Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B7173BEE8
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 21:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjFWTel (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231742AbjFWTek (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 15:34:40 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41173270B
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 12:34:36 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A572D5C00B2;
        Fri, 23 Jun 2023 15:34:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 23 Jun 2023 15:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        cc:cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1687548875; x=1687635275; bh=CO
        Chp9i0NPTL4RUnoYWVNtj++GiOWxNhg/Xoihpks0Q=; b=ZVCTe5d8bBkczkj2DR
        yX46hhdnmWXPIsnEezG9KwjSFgtwOFbD/GF+ojDUnYywW+YWnYf9TmKMtVhKTPvh
        j1DTVwzfDnpWPiXSFzKVWMUsWlTQUvlvswwCulnS2J8c91LJU4ox0LAxHREUsiqd
        Mu/NlPO6sV545MGMoAwr5ybC//4YzYP3LC3XI0436/O9l+9M3h9O9F3LcTM9cH68
        Xa2SMgcvfV4/q/g311WWMgiq4jLsEJGIqvr3/0GuIm1dkRYw6yskZCkK8jb51SMX
        Ww3hhlYjGhOxLyJcWyeqJ2HI5ngUQoZ889HPe2hmqnBDyvaFxC0eCXneP2WsNLPS
        w64Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1687548875; x=1687635275; bh=COChp9i0NPTL4
        RUnoYWVNtj++GiOWxNhg/Xoihpks0Q=; b=p3kQL7x/G81NZhXWS15EJ8Dr9A+B5
        CyHFr6dBYci19Bpx2NMud60kQYCzsan8xrCcXWgsUhm/6y1hzhusAwXctys4TvG/
        DKsbd9kRx8bLcPJ7PpdfPweJ7xAhPRnRLrFeIiaZ1FHxAj9z8X4PLx85PPTyEXU9
        N02ZEA0dD1IiJ2KwMLgLXUXYH2ppciReA+VHc1PQ5FxvY5Z4Zs+XWw3pzRExOnEE
        McNOlLCZSbwmdYdxbmK4Vsaw1Nb57qO+9kkpfFqiIx7nGoaeFI4dZUNg+ch7xAwH
        nvAseEhz/BrYEK9/dF1iNuaEzrmKlaYVzj3uxb3ste3Au+JJhPVtXjClg==
X-ME-Sender: <xms:y_OVZEwqcmHTdX7SO3b22TK3DY5K3CbfjKQwuBG16dSsdEe_v_sv4g>
    <xme:y_OVZIRmoj2_7CwAdgays0nNby-8UWNLArIhMaCOPuOaVHSazi3an1tRQU1eMNGoG
    BDJC0LSy4kvzm7sOQ>
X-ME-Received: <xmr:y_OVZGWWUBftv6by8yeRqYJScrpmgu9GZi3tM9XF8hc6InYNE0zpaqBLMk1JxbTyAVxwywkWluVwcysAm4uGRW96VZJoz6hlGvfQH0enjofenWjdqj--KumXnadl>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgeeggedgudefjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgu
    rhgvshcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtf
    frrghtthgvrhhnpedvffefvefhteevffegieetfefhtddvffejvefhueetgeeludehteev
    udeitedtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:y_OVZCgzbtSt_E-2udGEu-cLD0P1zccku-1-4UYJ75prYPwN4_bxzA>
    <xmx:y_OVZGB8BYo1WDVuZmak65FzDAbd6FIp84MUVTEtkXwL_xkZoXtMvw>
    <xmx:y_OVZDLRehvnZ-g-tywTqPTI6mKAnac-GxlSEx-Ky5QNF-hTW49Hbg>
    <xmx:y_OVZBo7sq5wF44BXaHIuKaU2cSA8pBnDL3UJN1AboAUrfjZlYUWXQ>
Feedback-ID: id4a34324:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 23 Jun 2023 15:34:35 -0400 (EDT)
Date:   Fri, 23 Jun 2023 12:34:33 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: [PATCH 5/6] io_uring: add support for futex wake and wait
Message-ID: <20230623193433.bf5mnwfrm2x7ykep@awork3.anarazel.de>
References: <20230609183125.673140-1-axboe@kernel.dk>
 <20230609183125.673140-6-axboe@kernel.dk>
 <20230623190418.zx2x536uy7q5mtag@awork3.anarazel.de>
 <93ab1214-2415-1059-633e-b95b299287a3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93ab1214-2415-1059-633e-b95b299287a3@kernel.dk>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2023-06-23 13:07:12 -0600, Jens Axboe wrote:
> On 6/23/23 1:04?PM, Andres Freund wrote:
> > Hi,
> >
> > I'd been chatting with Jens about this, so obviously I'm interested in the
> > feature...
> >
> > On 2023-06-09 12:31:24 -0600, Jens Axboe wrote:
> >> Add support for FUTEX_WAKE/WAIT primitives.
> >>
> >> IORING_OP_FUTEX_WAKE is mix of FUTEX_WAKE and FUTEX_WAKE_BITSET, as
> >> it does support passing in a bitset.
> >>
> >> Similary, IORING_OP_FUTEX_WAIT is a mix of FUTEX_WAIT and
> >> FUTEX_WAIT_BITSET.
> >
> > One thing I was wondering about is what happens when there are multiple
> > OP_FUTEX_WAITs queued for the same futex, and that futex gets woken up. I
> > don't really have an opinion about what would be best, just that it'd be
> > helpful to specify the behaviour.
>
> Not sure I follow the question, can you elaborate?
>
> If you have N futex waits on the same futex and someone does a wait
> (with wakenum >= N), then they'd all wake and post a CQE. If less are
> woken because the caller asked for less than N, than that number should
> be woken.
>
> IOW, should have the same semantics as "normal" futex waits.

With a normal futex wait you can't wait multiple times on the same futex in
one thread. But with the proposed io_uring interface, one can.

Basically, what is the defined behaviour for:

   sqe = io_uring_get_sqe(ring);
   io_uring_prep_futex_wait(sqe, futex, 0, FUTEX_BITSET_MATCH_ANY);

   sqe = io_uring_get_sqe(ring);
   io_uring_prep_futex_wait(sqe, futex, 0, FUTEX_BITSET_MATCH_ANY);

   io_uring_submit(ring)

when someone does:
   futex(FUTEX_WAKE, futex, 1, 0, 0, 0);
   or
   futex(FUTEX_WAKE, futex, INT_MAX, 0, 0, 0);

or the equivalent io_uring operation.

Is it an error? Will there always be two cqes queued? Will it depend on the
number of wakeups specified by the waker?  I'd assume the latter, but it'd be
good to specify that.

Greetings,

Andres Freund
