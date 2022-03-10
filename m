Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF1C4D42AD
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 09:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239406AbiCJIgK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Mar 2022 03:36:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbiCJIgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Mar 2022 03:36:09 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE27EC7D68;
        Thu, 10 Mar 2022 00:35:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 38BFF68AFE; Thu, 10 Mar 2022 09:35:04 +0100 (CET)
Date:   Thu, 10 Mar 2022 09:35:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 11/17] block: factor out helper for bio allocation from
 cache
Message-ID: <20220310083503.GE26614@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152716epcas5p3d38d2372c184259f1a10c969f7e4396f@epcas5p3.samsung.com> <20220308152105.309618-12-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-12-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:50:59PM +0530, Kanchan Joshi wrote:
> +struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
> +			    struct bio_set *bs)
> +{
> +	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE))
> +		return bio_alloc_bioset(GFP_KERNEL, nr_vecs, bs);
> +
> +	return bio_from_cache(nr_vecs, bs);
> +}
>  EXPORT_SYMBOL_GPL(bio_alloc_kiocb);

If we go down this route we might want to just kill the bio_alloc_kiocb
wrapper.
