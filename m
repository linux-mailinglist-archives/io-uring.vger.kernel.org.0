Return-Path: <io-uring+bounces-5721-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B072BA03728
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 05:53:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2C7523A1AA2
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 04:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584DE1917F1;
	Tue,  7 Jan 2025 04:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="fwOXCU3k"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D073118EAB;
	Tue,  7 Jan 2025 04:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736225615; cv=none; b=Jn4OzhjYfPQRqlRk3VpapdZSinNP42rThyuAL32CArv7fvOLbU5c0QKpHrpDYX2BVw8oWHpL+QeXucECqOKwozlykS8n6j6IW7ppGrirt5IGQJKHjw3U/UHUTIVGOWTOirdQJrdh0CBJAFmWQNfC75bDojUQaoPt7vmKR5HjjpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736225615; c=relaxed/simple;
	bh=oYD9+tGli0JwTiANlFmqv6JMsXiEOGfdypqFG0eF2FY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A20ZtXC+2aDSoU73xywwK1fBLSbN8fxCowetE9MWBYF/nLO2hz4lVlqN3AYRMBJc6xqshAWub3QFOMIdgyXGHdyAAHUhhSHQHp3anCCkKnx3Xmfy+2OrrR5+wdhFqHsRHKdeUbKV8KqNYc4CjdpvKqlFv055lkAONw3h5PQF1LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=fwOXCU3k; arc=none smtp.client-ip=115.124.30.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1736225608; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=brHbyiQNDtXvTcA14HMpe/Lz0MiwJyGs8jKrXYwOn7g=;
	b=fwOXCU3kNd3uhhmQr+cA+qqGMynk3eDmRqkZc9/kA+DFAseN4RD6YIvTLZ6j7an2CZH8aXfzzuj+3iFrAEfBkqf2ovYgf8SX+vdD6jD36Du9E3CCncfLd+pigpW9rhEZIdfzdIr01enPc7NVGZ05VSJXtmSVvhrUIoQvXKl9gFg=
Received: from 30.221.144.252(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0WN9QZxp_1736225606 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Jan 2025 12:53:28 +0800
Message-ID: <1356e5b9-44f0-4ccb-9e82-48c924495b93@linux.alibaba.com>
Date: Tue, 7 Jan 2025 12:53:24 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] virtio-blk: add virtio-blk chardev support.
To: Ferry Meng <mengferry@linux.alibaba.com>,
 "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
 linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 virtualization@lists.linux.dev
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 Stefan Hajnoczi <stefanha@redhat.com>, Christoph Hellwig
 <hch@infradead.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20241218092435.21671-1-mengferry@linux.alibaba.com>
 <20241218092435.21671-2-mengferry@linux.alibaba.com>
Content-Language: en-US
From: Jingbo Xu <jefflexu@linux.alibaba.com>
In-Reply-To: <20241218092435.21671-2-mengferry@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 12/18/24 5:24 PM, Ferry Meng wrote:

> +static int virtblk_cdev_add(struct virtio_blk *vblk,
> +		const struct file_operations *fops)

@fops argument is not necessary, as currently virtblk_chr_fops is the
only valid value.


> @@ -1690,7 +1770,9 @@ static void __exit virtio_blk_fini(void)
>  {
>  	unregister_virtio_driver(&virtio_blk);
>  	unregister_blkdev(major, "virtblk");
> +	unregister_chrdev_region(vd_chr_devt, VIRTBLK_MINORS);

Better to call "unregister_chrdev_region(vd_chr_devt, VIRTBLK_MINORS)"
before "unregister_blkdev(major, "virtblk")" to follow the convention
that the order of the cleanup routine is exactly the reverse of that of
the init routine.

>  	destroy_workqueue(virtblk_wq);
> +	ida_destroy(&vd_chr_minor_ida);
>  }
>  module_init(virtio_blk_init);
>  module_exit(virtio_blk_fini);

-- 
Thanks,
Jingbo

