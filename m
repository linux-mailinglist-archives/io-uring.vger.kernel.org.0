Return-Path: <io-uring+bounces-11360-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CB97CF07DA
	for <lists+io-uring@lfdr.de>; Sun, 04 Jan 2026 02:47:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EF7D3300E477
	for <lists+io-uring@lfdr.de>; Sun,  4 Jan 2026 01:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD41622B8B0;
	Sun,  4 Jan 2026 01:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcJhe5HW"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C0122B8A6
	for <io-uring@vger.kernel.org>; Sun,  4 Jan 2026 01:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767491238; cv=none; b=qLDXIuhrfOOptPZMnTGMDVb/NhOCWY23sKfGPjyHzgJ9BQFvpAMyBw3dIBOS5wUJP2OHf6cK2SZzidmdAPHFL8paKMNHvUv7Duvwop6QwWfBJCUgfMIE5iEt+ypGvjxyrV4NjNrClBEG9LxrTOnGX7HiYt7t1e0OkbUm6gReZ5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767491238; c=relaxed/simple;
	bh=GqhbTzu1zMTPhcv4atimbUKw9BxlYFoIaHQ+58SuoKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M7SOe8fXDl+EkASv7ppDiHQL4OSMyj9AYUjgDuTYrDviCqXITQ00hxwLk2l7HXjE3+S8NnpoH7jxs/9XI01z9k9P46gJ1jFr5CNvMawQbYP6/g2hn2tV0Yy2p2v8wvvTNxn5rL/gYyRjP5iFAOdYWEZNA/xUcv+S9zzinwI5ULQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcJhe5HW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767491235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tbz55QAFngKi4vXyXWBDlHF0TrS8hK19/MLRgIcCIBc=;
	b=RcJhe5HWUksloK90wyZhCZ+Oj3RUHfie+wjlKeQL1LC+0UwxxZuy9ousdm3LQ8VQS53CvN
	6A7qYdhb6qXuql6tLG3puG6KNbjfcIwAP25e0DTHKtaG2Be8Lw3IfD4ohM1UnFl4nxxMro
	t24pAJrrw16imhBImsTF1pO+98igeDA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-319-X6YxGNlRMfOWQGdJqXN29Q-1; Sat,
 03 Jan 2026 20:47:12 -0500
X-MC-Unique: X6YxGNlRMfOWQGdJqXN29Q-1
X-Mimecast-MFC-AGG-ID: X6YxGNlRMfOWQGdJqXN29Q_1767491230
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7290E1800654;
	Sun,  4 Jan 2026 01:47:09 +0000 (UTC)
Received: from fedora (unknown [10.72.116.132])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5984B30001A2;
	Sun,  4 Jan 2026 01:46:57 +0000 (UTC)
Date: Sun, 4 Jan 2026 09:46:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org, io-uring@vger.kernel.org,
	Vishal Verma <vishal1.verma@intel.com>, tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	David Wei <dw@davidwei.uk>
Subject: Re: [RFC v2 10/11] io_uring/rsrc: add dmabuf-backed buffer
 registeration
Message-ID: <aVnGja6w4e_tgZjK@fedora>
References: <cover.1763725387.git.asml.silence@gmail.com>
 <b38f2c3af8c03ee4fc5f67f97b4412ecd8588924.1763725388.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b38f2c3af8c03ee4fc5f67f97b4412ecd8588924.1763725388.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Sun, Nov 23, 2025 at 10:51:30PM +0000, Pavel Begunkov wrote:
> Add an ability to register a dmabuf backed io_uring buffer. It also
> needs know which device to use for attachment, for that it takes
> target_fd and extracts the device through the new file op. Unlike normal
> buffers, it also retains the target file so that any imports from
> ineligible requests can be rejected in next patches.
> 
> Suggested-by: Vishal Verma <vishal1.verma@intel.com>
> Suggested-by: David Wei <dw@davidwei.uk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/rsrc.c | 106 +++++++++++++++++++++++++++++++++++++++++++++++-
>  io_uring/rsrc.h |   1 +
>  2 files changed, 106 insertions(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 691f9645d04c..7dfebf459dd0 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -10,6 +10,8 @@
>  #include <linux/compat.h>
>  #include <linux/io_uring.h>
>  #include <linux/io_uring/cmd.h>
> +#include <linux/dma-buf.h>
> +#include <linux/dma_token.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -802,6 +804,106 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
>  	return true;
>  }
>  
> +struct io_regbuf_dma {
> +	struct dma_token		*token;
> +	struct file			*target_file;
> +	struct dma_buf			*dmabuf;
> +};
> +
> +static void io_release_reg_dmabuf(void *priv)
> +{
> +	struct io_regbuf_dma *db = priv;
> +
> +	dma_token_release(db->token);
> +	dma_buf_put(db->dmabuf);
> +	fput(db->target_file);
> +	kfree(db);
> +}
> +
> +static struct io_rsrc_node *io_register_dmabuf(struct io_ring_ctx *ctx,
> +						struct io_uring_reg_buffer *rb,
> +						struct iovec *iov)
> +{
> +	struct dma_token_params params = {};
> +	struct io_rsrc_node *node = NULL;
> +	struct io_mapped_ubuf *imu = NULL;
> +	struct io_regbuf_dma *regbuf = NULL;
> +	struct file *target_file = NULL;
> +	struct dma_buf *dmabuf = NULL;
> +	struct dma_token *token;
> +	int ret;
> +
> +	if (iov->iov_base || iov->iov_len)
> +		return ERR_PTR(-EFAULT);
> +
> +	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> +	if (!node) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	imu = io_alloc_imu(ctx, 0);
> +	if (!imu) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	regbuf = kzalloc(sizeof(*regbuf), GFP_KERNEL);
> +	if (!regbuf) {
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	target_file = fget(rb->target_fd);
> +	if (!target_file) {
> +		ret = -EBADF;
> +		goto err;
> +	}
> +
> +	dmabuf = dma_buf_get(rb->dmabuf_fd);
> +	if (IS_ERR(dmabuf)) {
> +		ret = PTR_ERR(dmabuf);
> +		dmabuf = NULL;
> +		goto err;
> +	}
> +
> +	params.dmabuf = dmabuf;
> +	params.dir = DMA_BIDIRECTIONAL;
> +	token = dma_token_create(target_file, &params);
> +	if (IS_ERR(token)) {
> +		ret = PTR_ERR(token);
> +		goto err;
> +	}
> +

This way looks less flexible, for example, the same dma-buf may be used
on IOs to multiple disks, then it needs to be registered for each target
file.



Thanks,
Ming


