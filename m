Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B40B4D96DF
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 09:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346276AbiCOI6Y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 04:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345206AbiCOI6X (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 04:58:23 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4304D9CB;
        Tue, 15 Mar 2022 01:57:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 988FC68AA6; Tue, 15 Mar 2022 09:57:09 +0100 (CET)
Date:   Tue, 15 Mar 2022 09:57:09 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 12/17] nvme: enable bio-cache for fixed-buffer passthru
Message-ID: <20220315085709.GD4132@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152718epcas5p3afd2c8a628f4e9733572cbb39270989d@epcas5p3.samsung.com> <20220308152105.309618-13-joshi.k@samsung.com> <20220311064847.GA17728@lst.de> <CA+1E3rJshMVkLwpAQwM1L6L_xcrK9drKP+rpcrfizYuFsQOGjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rJshMVkLwpAQwM1L6L_xcrK9drKP+rpcrfizYuFsQOGjA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 14, 2022 at 11:48:43PM +0530, Kanchan Joshi wrote:
> Yes, the only reason to switch from kmalloc to bio-set was being able
> to use bio-cache.
> Towards the goal of matching peak perf of io_uring's block io path.
> Is it too bad to go down this route; Is there any different way to
> enable bio-cache for passthru.

How does this actually make a difference vs say a slab cache?  Slab/slub
seems to be very fine tuned for these kinds of patters using per-cpu
caches.
