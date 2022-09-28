Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3FE5EE2EC
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbiI1RTo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233426AbiI1RTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:19:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AE92AE8;
        Wed, 28 Sep 2022 10:19:35 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4630F68BEB; Wed, 28 Sep 2022 19:19:32 +0200 (CEST)
Date:   Wed, 28 Sep 2022 19:19:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 4/7] nvme: refactor nvme_alloc_request
Message-ID: <20220928171932.GB17153@lst.de>
References: <20220927173610.7794-1-joshi.k@samsung.com> <CGME20220927174633epcas5p4d492bdebde981e2c019e30c47cf00869@epcas5p4.samsung.com> <20220927173610.7794-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927173610.7794-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> +	if (!vec)
> +		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
> +			GFP_KERNEL);
> +	else {
> +		struct iovec fast_iov[UIO_FASTIOV];
> +		struct iovec *iov = fast_iov;
> +		struct iov_iter iter;
> +
> +		ret = import_iovec(rq_data_dir(req), ubuffer, bufflen,
> +				UIO_FASTIOV, &iov, &iter);
> +		if (ret < 0)
>  			goto out;
> +
> +		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
> +		kfree(iov);
> +	}

As mentioned before this is something that should got into blk-map.c
as a separate helper, and scsi_ioctl.c and sg.c should be switched to
use it as well.

Otherwise this looks good.
