Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFEA5638D7
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 20:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbiGASFd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 14:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbiGASFd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 14:05:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D543F331;
        Fri,  1 Jul 2022 11:05:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 404E4B83104;
        Fri,  1 Jul 2022 18:05:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E55ECC3411E;
        Fri,  1 Jul 2022 18:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656698729;
        bh=JrDwbgQPLqBXU0x6iQM3zo0gvaj26BoUCXm4R3iZmiM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OsPTJ2917NohU9KpEgqY1i6QhhISWg1eVdIegQBURR9rO4rrz2FxnAyzpbY//WvGK
         ZSWPHnFtFqtDEuKnIJr6D54cCgHOaI3beIXdpXY59yI8zxtoi+UCanjd8Cx/iI38GN
         wboEqRGyk1/VDqndiY4BthRC1rfBczyGVmA8MuDV5mV0sQAu3T0xLA3mTDYDsHckhG
         lJjtOXs/yK2FqfZOX7GRLAVstJSFVj4QOVWRRMcBr83ZF1KvWat24bmGA2NrZy4fXn
         UEGm3ZqsdZbGdZm5w19l9HsZD8WArLJSZVnJmJVWQA2hMt6B5XSv0uVsVuZK9WCHBm
         YvTB76bOKK6PA==
Date:   Fri, 1 Jul 2022 11:05:28 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 15/15] xfs: Add async buffered write support
Message-ID: <Yr83aD0yuEwvJ7tL@magnolia>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-16-shr@fb.com>
 <Yr56ci/IZmN0S9J6@ZenIV>
 <0a75a0c4-e2e5-b403-27bc-e43872fecdc1@kernel.dk>
 <ef7c1154-b5ba-4017-f9fd-dea936a837fc@kernel.dk>
 <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca60a7dc-b16d-d8ce-f56c-547b449da8c9@kernel.dk>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 01, 2022 at 08:38:07AM -0600, Jens Axboe wrote:
> On 7/1/22 8:30 AM, Jens Axboe wrote:
> > On 7/1/22 8:19 AM, Jens Axboe wrote:
> >> On 6/30/22 10:39 PM, Al Viro wrote:
> >>> On Wed, Jun 01, 2022 at 02:01:41PM -0700, Stefan Roesch wrote:
> >>>> This adds the async buffered write support to XFS. For async buffered
> >>>> write requests, the request will return -EAGAIN if the ilock cannot be
> >>>> obtained immediately.
> >>>
> >>> breaks generic/471...
> >>
> >> That test case is odd, because it makes some weird assumptions about
> >> what RWF_NOWAIT means. Most notably that it makes it mean if we should
> >> instantiate blocks or not. Where did those assumed semantics come from?
> >> On the read side, we have clearly documented that it should "not wait
> >> for data which is not immediately available".
> >>
> >> Now it is possible that we're returning a spurious -EAGAIN here when we
> >> should not be. And that would be a bug imho. I'll dig in and see what's
> >> going on.
> > 
> > This is the timestamp update that needs doing which will now return
> > -EAGAIN if IOCB_NOWAIT is set as it may block.
> > 
> > I do wonder if we should just allow inode time updates with IOCB_NOWAIT,
> > even on the io_uring side. Either that, or passed in RWF_NOWAIT
> > semantics don't map completely to internal IOCB_NOWAIT semantics. At
> > least in terms of what generic/471 is doing, but I'm not sure who came
> > up with that and if it's established semantics or just some made up ones
> > from whomever wrote that test. I don't think they make any sense, to be
> > honest.
> 
> Further support that generic/471 is just randomly made up semantics,
> it needs to special case btrfs with nocow or you'd get -EAGAIN anyway
> for that test.
> 
> And it's relying on some random timing to see if this works. I really
> think that test case is just hot garbage, and doesn't test anything
> meaningful.

<shrug> I had thought that NOWAIT means "don't wait for *any*thing",
which would include timestamp updates... but then I've never been all
that clear on what specifically NOWAIT will and won't wait for. :/

--D

> -- 
> Jens Axboe
> 
