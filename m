Return-Path: <io-uring+bounces-6351-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 573AFA31C4C
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 03:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9A543A743E
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 02:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CCCF78F5D;
	Wed, 12 Feb 2025 02:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ORPNVlle"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E09225D6
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 02:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739328574; cv=none; b=X1+yUb6LrbOeke0qOlVy22ckX2+QvTdAEjEvpnBK299Kud/HKTk8fhYLPsIA8LTD8m/y2d3KUSSXfUDwhB2SqnTUzZqElKC5o6aE+gehaZGxdFNnAjENI9FthDRnHNAXwvKn+sjPoW8cCA11YlC32FH6W5W9ABIV3HYtbw/Xd28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739328574; c=relaxed/simple;
	bh=WzlY8jinKS9gY9THs13QL3iYaygsH3DRbOuRAtdSs58=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bCr4Z0d/EotPsEX5l9hdxXS9iEjzxzWbGmEYDWBsxlryi3LkGNyFgKuH+DVJ4PLEfPjIuUgAm0OeNuG5Cgpa2NRSFxWSxQgK9SoLkBOE9tKAQrWVkKpv7D5nrU74ksL961kaQj3ZCR8XB67UoDaw4zNgZw8W6HA4fA4QO6a6rZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ORPNVlle; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739328571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NdeC0wtOBQjqtkNusPIbFdjZDkozLCfg+04DlOuXyLI=;
	b=ORPNVlleUDGN1cwRri/LtCQIovnnAaDl+cpTfRt+PaWnfK0RIX70Y34ANA/czWE9w4/f0S
	PPdbixR51e8AWk08ea6RXl70fzpCPZBgW0lzC193w+p7Pzkx5ENQXqZZJrGDpe8lRy3+Hn
	yPLlZR1cnab1+gZ5EhhYZ0r3uicK/ys=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-048g6ZqrNSiY6qEZDeulEQ-1; Tue,
 11 Feb 2025 21:49:27 -0500
X-MC-Unique: 048g6ZqrNSiY6qEZDeulEQ-1
X-Mimecast-MFC-AGG-ID: 048g6ZqrNSiY6qEZDeulEQ_1739328566
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFE4F19560AE;
	Wed, 12 Feb 2025 02:49:25 +0000 (UTC)
Received: from fedora (unknown [10.72.116.142])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCB2D18008CC;
	Wed, 12 Feb 2025 02:49:20 +0000 (UTC)
Date: Wed, 12 Feb 2025 10:49:15 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 4/6] ublk: zc register/unregister bvec
Message-ID: <Z6wMK5WxvS_MzLh3@fedora>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250211005646.222452-5-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Feb 10, 2025 at 04:56:44PM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide new operations for the user to request mapping an active request
> to an io uring instance's buf_table. The user has to provide the index
> it wants to install the buffer.
> 
> A reference count is taken on the request to ensure it can't be
> completed while it is active in a ring's buf_table.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  drivers/block/ublk_drv.c      | 145 +++++++++++++++++++++++++---------
>  include/uapi/linux/ublk_cmd.h |   4 +
>  2 files changed, 113 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..ccfda7b2c24da 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -51,6 +51,9 @@
>  /* private ioctl command mirror */
>  #define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
>  
> +#define UBLK_IO_REGISTER_IO_BUF		_IOC_NR(UBLK_U_IO_REGISTER_IO_BUF)
> +#define UBLK_IO_UNREGISTER_IO_BUF	_IOC_NR(UBLK_U_IO_UNREGISTER_IO_BUF)

UBLK_IO_REGISTER_IO_BUF command may be completed, and buffer isn't used
by RW_FIXED yet in the following cases:

- application doesn't submit any RW_FIXED consumer OP

- io_uring_enter() only issued UBLK_IO_REGISTER_IO_BUF, and the other
  OPs can't be issued because of out of resource 

...

Then io_uring_enter() returns, and the application is panic or killed,
how to avoid buffer leak?

It need to deal with in io_uring cancel code for calling ->release() if
the kbuffer node isn't released.

UBLK_IO_UNREGISTER_IO_BUF still need to call ->release() if the node
buffer isn't used.

> +
>  /* All UBLK_F_* have to be included into UBLK_F_ALL */
>  #define UBLK_F_ALL (UBLK_F_SUPPORT_ZERO_COPY \
>  		| UBLK_F_URING_CMD_COMP_IN_TASK \
> @@ -76,6 +79,9 @@ struct ublk_rq_data {
>  	struct llist_node node;
>  
>  	struct kref ref;
> +
> +#define UBLK_ZC_REGISTERED 0
> +	unsigned long flags;
>  };
>  
>  struct ublk_uring_cmd_pdu {
> @@ -201,7 +207,7 @@ static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
>  						   int tag);
>  static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
>  {
> -	return ub->dev_info.flags & UBLK_F_USER_COPY;
> +	return ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY);
>  }
>  
>  static inline bool ublk_dev_is_zoned(const struct ublk_device *ub)
> @@ -581,7 +587,7 @@ static void ublk_apply_params(struct ublk_device *ub)
>  
>  static inline bool ublk_support_user_copy(const struct ublk_queue *ubq)
>  {
> -	return ubq->flags & UBLK_F_USER_COPY;
> +	return ubq->flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY);
>  }
>  
>  static inline bool ublk_need_req_ref(const struct ublk_queue *ubq)
> @@ -1747,6 +1753,102 @@ static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
>  	io_uring_cmd_mark_cancelable(cmd, issue_flags);
>  }
>  
> +static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
> +		struct ublk_queue *ubq, int tag, size_t offset)
> +{
> +	struct request *req;
> +
> +	if (!ublk_need_req_ref(ubq))
> +		return NULL;
> +
> +	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
> +	if (!req)
> +		return NULL;
> +
> +	if (!ublk_get_req_ref(ubq, req))
> +		return NULL;
> +
> +	if (unlikely(!blk_mq_request_started(req) || req->tag != tag))
> +		goto fail_put;
> +
> +	if (!ublk_rq_has_data(req))
> +		goto fail_put;
> +
> +	if (offset > blk_rq_bytes(req))
> +		goto fail_put;
> +
> +	return req;
> +fail_put:
> +	ublk_put_req_ref(ubq, req);
> +	return NULL;
> +}
> +
> +static void ublk_io_release(void *priv)
> +{
> +	struct request *rq = priv;
> +	struct ublk_queue *ubq = rq->mq_hctx->driver_data;
> +
> +	ublk_put_req_ref(ubq, rq);
> +}

It isn't enough to just get & put request reference here between registering
buffer and freeing the registered node buf, because the same reference can be
dropped from ublk_commit_completion() which is from queueing
UBLK_IO_COMMIT_AND_FETCH_REQ, and buggy app may queue this command multiple
times for freeing the request.

One solution is to not allow request completion until the ->release() is
returned.

Thanks,
Ming


