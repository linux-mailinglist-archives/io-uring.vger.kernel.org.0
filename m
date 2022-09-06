Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A7A5ADFBB
	for <lists+io-uring@lfdr.de>; Tue,  6 Sep 2022 08:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231901AbiIFGZc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Sep 2022 02:25:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiIFGZ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Sep 2022 02:25:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F147C52448;
        Mon,  5 Sep 2022 23:25:26 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 096F468AA6; Tue,  6 Sep 2022 08:25:22 +0200 (CEST)
Date:   Tue, 6 Sep 2022 08:25:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH for-next v4 3/4] block: add helper to map bvec iterator
 for passthrough
Message-ID: <20220906062522.GA1566@lst.de>
References: <20220905134833.6387-1-joshi.k@samsung.com> <CGME20220905135851epcas5p3d107b140fd6cba1feb338c1a31c4feb1@epcas5p3.samsung.com> <20220905134833.6387-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905134833.6387-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Sep 05, 2022 at 07:18:32PM +0530, Kanchan Joshi wrote:
> +static struct bio *bio_map_get(struct request *rq, unsigned int nr_vecs,
>  		gfp_t gfp_mask)
>  {
> @@ -259,13 +252,31 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
>  		bio = bio_alloc_bioset(NULL, nr_vecs, opf, gfp_mask,
>  					&fs_bio_set);
>  		if (!bio)
> -			return -ENOMEM;
> +			return NULL;

This context looks weird?  That bio_alloc_bioset should not be there,
as biosets are only used for file system I/O, which this is not.
