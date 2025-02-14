Return-Path: <io-uring+bounces-6431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35A6CA3554E
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 04:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C30F3AC5BC
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 03:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F0378F34;
	Fri, 14 Feb 2025 03:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MjU6XTVf"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF188837
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 03:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739503831; cv=none; b=hQ6NQIcfAD5gaBue0E1w6i4Q6jTrNtGK7FZfgbD/Dy5o7ymFR04VHxyzccHqJRy5s9mFLfEkFzjiH5d+a1WxyQH67X6ULY8lVXaFfMExYtq0wyxEtX4f++VKgYS3gaEI5NeiHTuoa2LKwerwTkGGyJ386PK55XndoHVxMxtgaYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739503831; c=relaxed/simple;
	bh=auQ+6JNGmxuYoySz87Iiz3UvPdmUkG1r31DfVx5Z5u4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbM0Y2HqxbsXZZG3gDlU68e4WT2O+OsxJUKb9saFhqlkD5XOiTPcWLjoNQKQdBRu//t/oFw+m1LKHIBsSsc2DXy+Z5NtE1Mci2Tv/R2XpYz5pOLpA8SyrJpHP8aQBhP6ci3EQg8wc8ur2QwMbz9BqXXn9549DeRgbOA10gF46zI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MjU6XTVf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739503828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vjUHYY/ju5RxBcfd1kJd6fuyd2cD4tYY6MBYoyzN+tI=;
	b=MjU6XTVfThEfRA0zVDnbd5TjMHboYrsmQSWnysQWVX9QvkGYoNInoWGvu+PIJ+/UrY8Wgh
	T8teu7xBzJ4m2dbUUgxahaNwx8BMIv2787JIc6ZYvNcZKBV0lTjdi+ABYGppmlB8+TppYI
	J2C+TBrkZewp3WsoZS0S3Q6ma8Pnllo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-EjTbHjz6OxmcEo8rrYBuyA-1; Thu,
 13 Feb 2025 22:30:24 -0500
X-MC-Unique: EjTbHjz6OxmcEo8rrYBuyA-1
X-Mimecast-MFC-AGG-ID: EjTbHjz6OxmcEo8rrYBuyA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 293E51801A16;
	Fri, 14 Feb 2025 03:30:23 +0000 (UTC)
Received: from fedora (unknown [10.72.120.24])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 767141800365;
	Fri, 14 Feb 2025 03:30:16 +0000 (UTC)
Date: Fri, 14 Feb 2025 11:30:11 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 3/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z664w0GrgA8LjYko@fedora>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211005646.222452-4-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Feb 10, 2025 at 04:56:43PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide an interface for the kernel to leverage the existing
> pre-registered buffers that io_uring provides. User space can reference
> these later to achieve zero-copy IO.
> 
> User space must register an empty fixed buffer table with io_uring in
> order for the kernel to make use of it.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---

...

>  
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
> +			    void (*release)(void *), unsigned int index)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct req_iterator rq_iter;
> +	struct io_mapped_ubuf *imu;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv;
> +	u16 nr_bvecs;
> +	int i = 0;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	if (!data->nr)
> +		return -EINVAL;
> +	if (index >= data->nr)
> +		return -EINVAL;
> +
> +	node = data->nodes[index];
> +	if (node)
> +		return -EBUSY;
> +
> +	node = io_rsrc_node_alloc(IORING_RSRC_KBUFFER);
> +	if (!node)
> +		return -ENOMEM;
> +
> +	node->release = release;
> +	node->priv = rq;
> +
> +	nr_bvecs = blk_rq_nr_phys_segments(rq);
> +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> +	if (!imu) {
> +		kfree(node);
> +		return -ENOMEM;
> +	}
> +
> +	imu->ubuf = 0;
> +	imu->len = blk_rq_bytes(rq);
> +	imu->acct_pages = 0;
> +	imu->nr_bvecs = nr_bvecs;
> +	refcount_set(&imu->refs, 1);
> +	node->buf = imu;

request buffer direction needs to be stored in `imu`, for READ,
the buffer is write-only, and for WRITE, the buffer is read-only,
which isn't different with user mapped buffer.

Meantime in read_fixed/write_fixed side or buffer lookup abstraction
helper, the buffer direction needs to be validated.


Thanks,
Ming


