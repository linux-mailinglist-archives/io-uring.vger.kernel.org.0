Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFAE5EE2E7
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:18:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiI1RSO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:18:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiI1RSK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:18:10 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC683BC16;
        Wed, 28 Sep 2022 10:18:08 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id AE88868BEB; Wed, 28 Sep 2022 19:18:05 +0200 (CEST)
Date:   Wed, 28 Sep 2022 19:18:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 3/7] nvme: refactor nvme_add_user_metadata
Message-ID: <20220928171805.GA17153@lst.de>
References: <20220927173610.7794-1-joshi.k@samsung.com> <CGME20220927174631epcas5p12cd6ffbd7dad819b0af75733ce6cdd2c@epcas5p1.samsung.com> <20220927173610.7794-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927173610.7794-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Sep 27, 2022 at 11:06:06PM +0530, Kanchan Joshi wrote:
>  		if (bdev && meta_buffer && meta_len) {
> -			meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
> -					meta_seed, write);
> +			meta = nvme_add_user_metadata(req, meta_buffer, meta_len,

Pleae avoid the overly long line here.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
