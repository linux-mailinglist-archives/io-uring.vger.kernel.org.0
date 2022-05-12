Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F7E5247A5
	for <lists+io-uring@lfdr.de>; Thu, 12 May 2022 10:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240801AbiELIJS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 May 2022 04:09:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiELIJR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 May 2022 04:09:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75FE6B086
        for <io-uring@vger.kernel.org>; Thu, 12 May 2022 01:09:16 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CC0A668BEB; Thu, 12 May 2022 10:09:12 +0200 (CEST)
Date:   Thu, 12 May 2022 10:09:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, mcgrof@kernel.org, shr@fb.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com, gost.dev@samsung.com
Subject: Re: [PATCH v5 2/6] block: wire-up support for passthrough plugging
Message-ID: <20220512080912.GA26882@lst.de>
References: <20220511054750.20432-1-joshi.k@samsung.com> <CGME20220511055310epcas5p46650f5b6fe963279f686b8f50a98a286@epcas5p4.samsung.com> <20220511054750.20432-3-joshi.k@samsung.com> <YnyaRB+u1x6nIVp1@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnyaRB+u1x6nIVp1@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 12, 2022 at 01:25:24PM +0800, Ming Lei wrote:
> This way may cause nested plugging, and breaks xfstests generic/131.
> Also may cause io hang since request can't be polled before flushing
> plug in blk_execute_rq().

Looking at this again, yes blk_mq_request_bypass_insert is probably the
wrong place.

> I'd suggest to apply the plug in blk_execute_rq_nowait(), such as:

Do we really need the use_plug parameter and the extra helper?  If
someone holds a plug over passthrough command submission I think
we can assume they actually do want to use it.  Otherwise this does
indeed look like the better plan.
