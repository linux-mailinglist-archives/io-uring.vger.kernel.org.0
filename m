Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF884E846B
	for <lists+io-uring@lfdr.de>; Sat, 26 Mar 2022 22:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235458AbiCZVcb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 26 Mar 2022 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiCZVca (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 26 Mar 2022 17:32:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B32608
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 14:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FD3660E88
        for <io-uring@vger.kernel.org>; Sat, 26 Mar 2022 21:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2873C2BBE4;
        Sat, 26 Mar 2022 21:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648330250;
        bh=sxJV6txc2UZIWQDVJdcaQ053Net9CcBE+RvtRs5vOgM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aQtdE5tXSN79YA9n6tMoN4UReAKxjAVm94T4/ndi8eyuMGOmichOirfbi8aopAhGz
         pOoB1rmwAoZuuI+AXYCdkOfu/bckl2AVJKN2O5PB4Lartqwpd8JIf1wLZtA7JriWco
         x7W3ujEm+l2zlKzVND2IEyZS5FK62xFb54pHtDxukSUz4+MIoAGzi3rrsji+n2bEdg
         4PAE8uXY9p5NPmTOTBWbA6NTGjxP98dBhZ9trjvMH2X9iE8pjnMSiUo8g+gBEuPkKC
         x/MPxULinRqyAHHIMrN/SJW4kBWSd5KfLQK+NotiODIlqgbxcSwxTEw0kXHJmTsAar
         x/3XVPw1BLlLA==
Date:   Sat, 26 Mar 2022 14:30:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
Message-ID: <20220326143049.671b463c@kernel.org>
In-Reply-To: <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
        <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
        <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
        <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 26 Mar 2022 15:06:40 -0600 Jens Axboe wrote:
> On 3/26/22 2:57 PM, Jens Axboe wrote:
> >> I'd also like to have a conversation about continuing to use
> >> the socket as a proxy for NAPI_ID, NAPI_ID is exposed to user
> >> space now. io_uring being a new interface I wonder if it's not 
> >> better to let the user specify the request parameters directly.  
> > 
> > Definitely open to something that makes more sense, given we don't
> > have to shoehorn things through the regular API for NAPI with
> > io_uring.  
> 
> The most appropriate is probably to add a way to get/set NAPI settings
> on a per-io_uring basis, eg through io_uring_register(2). It's a bit
> more difficult if they have to be per-socket, as the polling happens off
> what would normally be the event wait path.
> 
> What did you have in mind?

Not sure I fully comprehend what the current code does. IIUC it uses
the socket and the caches its napi_id, presumably because it doesn't
want to hold a reference on the socket?

This may give the user a false impression that the polling follows 
the socket. NAPIs may get reshuffled underneath on pretty random
reconfiguration / recovery events (random == driver dependent).

I'm not entirely clear how the thing is supposed to be used with TCP
socket, as from a quick grep it appears that listening sockets don't
get napi_id marked at all.

The commit mentions a UDP benchmark, Olivier can you point me to more
info on the use case? I'm mostly familiar with NAPI busy poll with XDP
sockets, where it's pretty obvious.

My immediate reaction is that we should either explicitly call out NAPI
instances by id in uAPI, or make sure we follow the socket in every
case. Also we can probably figure out an easy way of avoiding the hash
table lookups and cache a pointer to the NAPI struct.

In any case, let's look in detail on Monday :)
