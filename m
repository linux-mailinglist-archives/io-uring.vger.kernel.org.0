Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7685E7EAB
	for <lists+io-uring@lfdr.de>; Fri, 23 Sep 2022 17:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232746AbiIWPmC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Sep 2022 11:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbiIWPlm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Sep 2022 11:41:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8A8915E8;
        Fri, 23 Sep 2022 08:40:46 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4425467373; Fri, 23 Sep 2022 17:40:42 +0200 (CEST)
Date:   Fri, 23 Sep 2022 17:40:41 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v8 5/5] nvme: wire up fixed buffer support for
 nvme passthrough
Message-ID: <20220923154041.GD21275@lst.de>
References: <20220923092854.5116-1-joshi.k@samsung.com> <CGME20220923093924epcas5p1e1723a3937cb3331c77e55bd1a785e57@epcas5p1.samsung.com> <20220923092854.5116-6-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923092854.5116-6-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 23, 2022 at 02:58:54PM +0530, Kanchan Joshi wrote:
>  	if (!vec)
> +		if (!fixedbufs)
> +			ret = blk_rq_map_user(q, req, NULL,
> +					nvme_to_user_ptr(ubuffer), bufflen,
> +					GFP_KERNEL);
> +		else {
> +			struct iov_iter iter;
> +
> +			ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
> +					rq_data_dir(req), &iter, ioucmd);
> +			if (ret < 0)
> +				goto out;
> +			ret = blk_rq_map_user_bvec(req, &iter);
> +		}

Given that the fixedufs case doesn't handle the vec case we can
do with some untangling and a single level of indentation here.

Even with that a WARN_ON_ONCE() for that impossible case would be good
to have, though.
