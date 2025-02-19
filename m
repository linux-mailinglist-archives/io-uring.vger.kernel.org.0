Return-Path: <io-uring+bounces-6551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B767A3B056
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 05:24:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2A8F93AE112
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 04:24:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0878714B08E;
	Wed, 19 Feb 2025 04:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CBIBy2eM"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1545A4D5
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 04:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739939048; cv=none; b=BnW1pOAKue+aphRfmXsSl7W1W0LQCBs0IswgEE8XGDNjuRakbbUOwUecpdShKCWeQCnxU9a2UUkQfKjSiutRqNLhEVYTf3huwVeOCB6uX9eAJLH6P+QrrAAsSP8y+Yq60xEa8dygMBwgLMRr3/B06LiSw3gInRpZ1LqgOLGU2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739939048; c=relaxed/simple;
	bh=3CD/ZPjsCQPmETMb5DZKcjnBwYgxhAE4QS/QVnf3sGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wjacmi2fvny2gvAQ98YS47U79bc/3CAfjCkiRku5r2srx3tQVKwMqykP4A6F4TSQabpewotxX8W6C3le8ggxw0dXChKD1a4Ktturk3ZYttopc/L4XROIO4R7rcj+yqYXSkt1IJ0txnVqlvDJ9a7SJlnFK2rGVMd2JnW7cpbiOmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CBIBy2eM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739939045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HCl7k57En+hDzI4osxx0dMsVaAr0wyGyPuMHH/iPr44=;
	b=CBIBy2eM46Ku6eHZ1vxtxcljA7oLsKF6pj+bSBlH1ksB234qmuCD5TTu+HWczmZ/5Fx+wR
	f/4ilpE309gq8CPQPWWDesuzQpipTPJNuHU0QIbmE5LzvUazviEzThCUELGHFIeL3Cvbxd
	xMKL4aNyRhjjFJEdKAZ4pL0RBBtvZz8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-NeB7cSpMNKOB4WYe2rfYbQ-1; Tue,
 18 Feb 2025 23:24:04 -0500
X-MC-Unique: NeB7cSpMNKOB4WYe2rfYbQ-1
X-Mimecast-MFC-AGG-ID: NeB7cSpMNKOB4WYe2rfYbQ_1739939040
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC12219560BC;
	Wed, 19 Feb 2025 04:23:59 +0000 (UTC)
Received: from fedora (unknown [10.72.120.21])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8EAFB1800357;
	Wed, 19 Feb 2025 04:23:52 +0000 (UTC)
Date: Wed, 19 Feb 2025 12:23:46 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv4 1/5] io_uring: move fixed buffer import to issue path
Message-ID: <Z7Vc0gWj-NNxqLME@fedora>
References: <20250218224229.837848-1-kbusch@meta.com>
 <20250218224229.837848-2-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218224229.837848-2-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Tue, Feb 18, 2025 at 02:42:25PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Similar to the fixed file path, requests may depend on a previous one
> to set up an index, so we need to allow linking them. The prep callback
> happens too soon for linked commands, so the lookup needs to be deferred
> to the issue path. Change the prep callbacks to just set the buf_index
> and let generic io_uring code handle the fixed buffer node setup, just
> like it already does for fixed files.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---

...

> diff --git a/io_uring/net.c b/io_uring/net.c
> index 000dc70d08d0d..39838e8575b53 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -1373,6 +1373,10 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  #endif
>  	if (unlikely(!io_msg_alloc_async(req)))
>  		return -ENOMEM;
> +	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
> +		req->buf_index = zc->buf_index;
> +		req->flags |= REQ_F_FIXED_BUFFER;
> +	}
>  	if (req->opcode != IORING_OP_SENDMSG_ZC)
>  		return io_send_setup(req, sqe);
>  	return io_sendmsg_setup(req, sqe);
> @@ -1434,25 +1438,10 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
>  	struct io_async_msghdr *kmsg = req->async_data;
>  	int ret;
>  
> -	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
> -		struct io_ring_ctx *ctx = req->ctx;
> -		struct io_rsrc_node *node;
> -
> -		ret = -EFAULT;
> -		io_ring_submit_lock(ctx, issue_flags);
> -		node = io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
> -		if (node) {
> -			io_req_assign_buf_node(sr->notif, node);

Here the node buffer is assigned to ->notif req, instead of the current
request, and you may have to deal with this case here.

Otherwise, this patch looks fine:

Reviewed-by: Ming Lei <ming.lei@redhat.com>



Thanks,
Ming


