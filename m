Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3CE58AF99
	for <lists+io-uring@lfdr.de>; Fri,  5 Aug 2022 20:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbiHESLd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Aug 2022 14:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbiHESLb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Aug 2022 14:11:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590082A24E;
        Fri,  5 Aug 2022 11:11:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC89261957;
        Fri,  5 Aug 2022 18:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9572BC433C1;
        Fri,  5 Aug 2022 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659723089;
        bh=BUCGokpxOG2wQV9jlxZN+bojUygVjlKbkcRkNTN3qO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIhQ6EynBCo/8MHM0r0kbULBWwURnKK1X50GWTo6B8HjfA7oVXfKg2pSkXdZcBYqF
         2oyxteqora+1ctLQXuXCBuL+Ns0z0LPtwA7I1tIvz3fSfN5DwD0J2MWCFJzq7FVsQM
         fiZiJu8NiIU4SCc7eaDDisb24/uMM8lqLvE2XBpuxP0Jg9bWGy6i/17dgF4JWFKaUX
         Zkq/KQrQa3k1Rme+7VEGmwpjdEzzIUMlpossXcmVfPPZQJa155NdFylClXLE8U3rCI
         V+9kb82Jcm+0yendHcmXbqKcg/xXNn5CN7a0koOYNWtppGFe8pPIT210ZJPwyX2ovy
         7/nJ3chJ0CIpg==
Date:   Fri, 5 Aug 2022 12:11:25 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        joshiiitr@gmail.com, gost.dev@samsung.com
Subject: Re: [PATCH 0/4] iopoll support for io_uring/nvme passthrough
Message-ID: <Yu1dTRhrcOSXmYoN@kbusch-mbp.dhcp.thefacebook.com>
References: <CGME20220805155300epcas5p1b98722e20990d0095238964e2be9db34@epcas5p1.samsung.com>
 <20220805154226.155008-1-joshi.k@samsung.com>
 <78f0ac8e-cd45-d71d-4e10-e6d2f910ae45@kernel.dk>
 <a2a5184d-f3ab-0941-6cc4-87cf231d5333@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2a5184d-f3ab-0941-6cc4-87cf231d5333@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 05, 2022 at 11:18:38AM -0600, Jens Axboe wrote:
> On 8/5/22 11:04 AM, Jens Axboe wrote:
> > On 8/5/22 9:42 AM, Kanchan Joshi wrote:
> >> Hi,
> >>
> >> Series enables async polling on io_uring command, and nvme passthrough
> >> (for io-commands) is wired up to leverage that.
> >>
> >> 512b randread performance (KIOP) below:
> >>
> >> QD_batch    block    passthru    passthru-poll   block-poll
> >> 1_1          80        81          158            157
> >> 8_2         406       470          680            700
> >> 16_4        620       656          931            920
> >> 128_32      879       1056        1120            1132
> > 
> > Curious on why passthru is slower than block-poll? Are we missing
> > something here?
> 
> I took a quick peek, running it here. List of items making it slower:
> 
> - No fixedbufs support for passthru, each each request will go through
>   get_user_pages() and put_pages() on completion. This is about a 10%
>   change for me, by itself.

Enabling fixed buffer support through here looks like it will take a little bit
of work. The driver needs an opcode or flag to tell it the user address is a
fixed buffer, and io_uring needs to export its registered buffer for a driver
like nvme to get to.
 
> - nvme_uring_cmd_io() -> nvme_alloc_user_request() -> blk_rq_map_user()
>   -> blk_rq_map_user_iov() -> memset() is another ~4% for me.

Where's the memset() coming from? That should only happen if we need to bounce,
right? This type of request shouldn't need that unless you're using odd user
address alignment.
