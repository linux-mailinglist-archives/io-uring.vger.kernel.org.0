Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3550A775042
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 03:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjHIBRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 21:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjHIBRW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 21:17:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44A01BD4
        for <io-uring@vger.kernel.org>; Tue,  8 Aug 2023 18:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691543780;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z6WQGimvpw8I3eWQzkelPA3+R/lSG2mPQ4BbdsuaY/0=;
        b=Vrlo9t8hAr87uu6KsYRgVPkNC3b4n3v6n5VmRJW+5Itx2qDrlKj2tghP7c/m4mUxIEq+mn
        biPyU3XpjpuDSwmB1JdEpIiUIpKdDCQs+O062WJGR+D8R5FqC3UflCGrBA6A8YxuB24+ul
        usUPN2bpVA2mqebzV8G1n0UKYXE/6no=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-614-otz98xfCMmO9ly3oHNFUnA-1; Tue, 08 Aug 2023 21:16:14 -0400
X-MC-Unique: otz98xfCMmO9ly3oHNFUnA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4DA178007CE;
        Wed,  9 Aug 2023 01:16:09 +0000 (UTC)
Received: from ovpn-8-17.pek2.redhat.com (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1DA2C492C13;
        Wed,  9 Aug 2023 01:16:02 +0000 (UTC)
Date:   Wed, 9 Aug 2023 09:15:57 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        gost.dev@samsung.com, Anuj Gupta <anuj20.g@samsung.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH for-next v3 4/4] nvme: wire up async polling for io
 passthrough commands
Message-ID: <ZNLozRZNPJ6CVYLO@ovpn-8-17.pek2.redhat.com>
References: <20220823161443.49436-1-joshi.k@samsung.com>
 <CGME20220823162517epcas5p2f1b808e60bae4bc1161b2d3a3a388534@epcas5p2.samsung.com>
 <20220823161443.49436-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823161443.49436-5-joshi.k@samsung.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Kanchan,

On Tue, Aug 23, 2022 at 09:44:43PM +0530, Kanchan Joshi wrote:
> Store a cookie during submission, and use that to implement
> completion-polling inside the ->uring_cmd_iopoll handler.
> This handler makes use of existing bio poll facility.
> 
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---

...

>  
> +int nvme_ns_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
> +{
> +	struct bio *bio;
> +	int ret = 0;
> +	struct nvme_ns *ns;
> +	struct request_queue *q;
> +
> +	rcu_read_lock();
> +	bio = READ_ONCE(ioucmd->cookie);
> +	ns = container_of(file_inode(ioucmd->file)->i_cdev,
> +			struct nvme_ns, cdev);
> +	q = ns->queue;
> +	if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio && bio->bi_bdev)
> +		ret = bio_poll(bio, NULL, 0);
> +	rcu_read_unlock();
> +	return ret;
> +}

It looks not good to call bio_poll() with holding rcu read lock,
since set_page_dirty_lock() may sleep from end_io code path.

blk_rq_unmap_user
	bio_release_pages
		__bio_release_pages
			set_page_dirty_lock
				lock_page

Probably you need to move dirtying pages into wq context, such as
bio_check_pages_dirty(), then I guess pt io poll perf may drop.

Maybe we need to investigate how to remove the rcu read lock here.


>  #ifdef CONFIG_NVME_MULTIPATH
>  static int nvme_ns_head_ctrl_ioctl(struct nvme_ns *ns, unsigned int cmd,
>  		void __user *argp, struct nvme_ns_head *head, int srcu_idx)
> @@ -685,6 +721,29 @@ int nvme_ns_head_chr_uring_cmd(struct io_uring_cmd *ioucmd,
>  	srcu_read_unlock(&head->srcu, srcu_idx);
>  	return ret;
>  }
> +
> +int nvme_ns_head_chr_uring_cmd_iopoll(struct io_uring_cmd *ioucmd)
> +{
> +	struct cdev *cdev = file_inode(ioucmd->file)->i_cdev;
> +	struct nvme_ns_head *head = container_of(cdev, struct nvme_ns_head, cdev);
> +	int srcu_idx = srcu_read_lock(&head->srcu);
> +	struct nvme_ns *ns = nvme_find_path(head);
> +	struct bio *bio;
> +	int ret = 0;
> +	struct request_queue *q;
> +
> +	if (ns) {
> +		rcu_read_lock();
> +		bio = READ_ONCE(ioucmd->cookie);
> +		q = ns->queue;
> +		if (test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && bio
> +				&& bio->bi_bdev)
> +			ret = bio_poll(bio, NULL, 0);
> +		rcu_read_unlock();

Same with above.


thanks,
Ming

