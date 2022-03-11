Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8755A4D5BC0
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 07:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346855AbiCKGty (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 01:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346862AbiCKGtx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 01:49:53 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87545157214;
        Thu, 10 Mar 2022 22:48:51 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8B72F68AFE; Fri, 11 Mar 2022 07:48:47 +0100 (CET)
Date:   Fri, 11 Mar 2022 07:48:47 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 12/17] nvme: enable bio-cache for fixed-buffer passthru
Message-ID: <20220311064847.GA17728@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d@epcas5p3.samsung.com> <20220308152105.309618-13-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-13-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:51:00PM +0530, Kanchan Joshi wrote:
> Since we do submission/completion in task, we can have this up.
> Add a bio-set for nvme as we need that for bio-cache.

Well, passthrough I/O should just use kmalloced bios anyway, as there
is no need for the mempool to start with.  Take a look at the existing
code in blk-map.c.
