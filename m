Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33175BE525
	for <lists+io-uring@lfdr.de>; Tue, 20 Sep 2022 14:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbiITMCd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Sep 2022 08:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiITMCc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Sep 2022 08:02:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D624A614E;
        Tue, 20 Sep 2022 05:02:30 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 213FE68AA6; Tue, 20 Sep 2022 14:02:27 +0200 (CEST)
Date:   Tue, 20 Sep 2022 14:02:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com
Subject: Re: [PATCH for-next v7 3/5] nvme: refactor nvme_alloc_user_request
Message-ID: <20220920120226.GB2809@lst.de>
References: <20220909102136.3020-1-joshi.k@samsung.com> <CGME20220909103143epcas5p2eda60190cd23b79fb8f48596af3e1524@epcas5p2.samsung.com> <20220909102136.3020-4-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220909102136.3020-4-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 09, 2022 at 03:51:34PM +0530, Kanchan Joshi wrote:
> Separate this out to two functions with reduced number of arguments.
> _
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  drivers/nvme/host/ioctl.c | 116 ++++++++++++++++++++++----------------
>  1 file changed, 66 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index 548aca8b5b9f..cb2fa4db50dd 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -65,18 +65,10 @@ static int nvme_finish_user_metadata(struct request *req, void __user *ubuf,
>  }
>  
>  static struct request *nvme_alloc_user_request(struct request_queue *q,
> +		struct nvme_command *cmd, unsigned timeout,
>  		blk_opf_t rq_flags, blk_mq_req_flags_t blk_flags)

I think we can also drop the timeout flag here, which seems like it
can be handled cleaner in the callers.
to set it can just do that.

> +static int nvme_map_user_request(struct request *req, void __user *ubuffer,
> +		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
> +		u32 meta_seed, void **metap, bool vec)
> +{
> +	struct request_queue *q = req->q;
> +	struct nvme_ns *ns = q->queuedata;
> +	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
> +	struct bio *bio = NULL;
> +	void *meta = NULL;
> +	int ret;
> +
> +	if (!ubuffer || !bufflen)
> +		return 0;

I'd leave these in the callers and not call the helper if there is
no data to transfer.

> +
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
> +		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
> +		kfree(iov);

To me some of this almost screams like lifting the vectored vs
not to the block layer into a separate helper.

> +	}
> +	bio = req->bio;
> +	if (ret)
> +		goto out_unmap;

This seems incorrect, we don't need to unmap if blk_rq_map_user*
failed.

> +	if (bdev)
> +		bio_set_dev(bio, bdev);

I think we can actually drop this now - bi_bdev should only be used
by the non-passthrough path these days.

> +	if (bdev && meta_buffer && meta_len) {
> +		meta = nvme_add_user_metadata(bio, meta_buffer, meta_len,
> +				meta_seed, req_op(req) == REQ_OP_DRV_OUT);
> +		if (IS_ERR(meta)) {
> +			ret = PTR_ERR(meta);
> +			goto out_unmap;
>  		}
> +		req->cmd_flags |= REQ_INTEGRITY;
> +		*metap = meta;

And if we pass the request to nvme_add_user_metadata, that can set
REQ_INTEGRITY.  And we don't need this second helper at all.
