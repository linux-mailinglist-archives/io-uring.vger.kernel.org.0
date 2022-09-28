Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0E65EE3B9
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbiI1R72 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234719AbiI1R7N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:59:13 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D599FFA44;
        Wed, 28 Sep 2022 10:59:08 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6A3E768BEB; Wed, 28 Sep 2022 19:59:04 +0200 (CEST)
Date:   Wed, 28 Sep 2022 19:59:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 7/7] nvme: wire up fixed buffer support
 for nvme passthrough
Message-ID: <20220928175904.GA17899@lst.de>
References: <20220927173610.7794-1-joshi.k@samsung.com> <CGME20220927174642epcas5p1dafa31776d4eb8180e18f149ed25640c@epcas5p1.samsung.com> <20220927173610.7794-8-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927173610.7794-8-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> -static int nvme_map_user_request(struct request *req, void __user *ubuffer,
> +static int nvme_map_user_request(struct request *req, u64 ubuffer,

The changes to pass ubuffer as an integer trip me up every time.
They are obviously fine as we do the pointer conversion less often,
but maybe they'd be easier to follow if split into a prep patch.

> +	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
>  
> -	if (!vec)
> -		ret = blk_rq_map_user(q, req, NULL, ubuffer, bufflen,
> -			GFP_KERNEL);
> -	else {
> +	if (vec) {

If we check IORING_URING_CMD_FIXED first this becomes a bit simpler,
and also works better with the block helper suggested earlier:

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 1a45246f0d7a8..f46142dcb8f1e 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -94,34 +94,33 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 	struct bio *bio = NULL;
 	void *meta = NULL;
 	int ret;
-	bool fixedbufs = ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED);
 
-	if (vec) {
-		struct iovec fast_iov[UIO_FASTIOV];
-		struct iovec *iov = fast_iov;
+	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
 		struct iov_iter iter;
 
 		/* fixedbufs is only for non-vectored io */
-		WARN_ON_ONCE(fixedbufs);
-		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
-				bufflen, UIO_FASTIOV, &iov, &iter);
+		if (WARN_ON_ONCE(vec))
+			return -EINVAL;
+		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
+				rq_data_dir(req), &iter, ioucmd);
 		if (ret < 0)
 			goto out;
-
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
-		kfree(iov);
-	} else if (fixedbufs) {
+	} else if (vec) {
+		struct iovec fast_iov[UIO_FASTIOV];
+		struct iovec *iov = fast_iov;
 		struct iov_iter iter;
 
-		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
-				rq_data_dir(req), &iter, ioucmd);
+		ret = import_iovec(rq_data_dir(req), nvme_to_user_ptr(ubuffer),
+				bufflen, UIO_FASTIOV, &iov, &iter);
 		if (ret < 0)
 			goto out;
 		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
-	} else
+		kfree(iov);
+	} else {
 		ret = blk_rq_map_user(q, req, NULL,
-					nvme_to_user_ptr(ubuffer), bufflen,
-					GFP_KERNEL);
+				nvme_to_user_ptr(ubuffer), bufflen, GFP_KERNEL);
+	}
 	if (ret)
 		goto out;
 	bio = req->bio;
