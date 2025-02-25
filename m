Return-Path: <io-uring+bounces-6737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A325A43C95
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 12:02:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 219CB188746F
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 11:02:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A35C1268C5C;
	Tue, 25 Feb 2025 11:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LwzxCSpn"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DB9267F7E
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 11:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740481229; cv=none; b=RdngvAs3dpWhCH/v7gywOv1PlYVXKI3SssvVF4Y3/Ze3UIi5GrsWL0NqmozPYrp/NRFni/VsKQPhqOWAxH9vBi4N1k37byzOOu3K4xbCickzfBzlDjiZeyHJILyt2Uquou8obuTWSNoVxBn/bbkQdZcETmA75XL+ajxjwcu0z54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740481229; c=relaxed/simple;
	bh=/9V1fxk2dEGCKZKFBlBO1UY7GGQ4gf7rz3pfp5JbqHs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YJEHAoOkRbiSuKCqv9YTslkITsSsohtOPGP2voAGUv8xlD7boTYybQnFVGTDx162zhFXJy9mi8HspaynnFdMEXsn9XIMSphZX/IwoVlAchMAK4IjJKkQ2zrYJtaqGlb9NsYWQcrxRjMqSodUFWfll71FNNh2tcHvlEWB93IwP6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LwzxCSpn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740481225;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uWOJcVI2y4VAoTGOX/WAROLgGbME7ad1Bieg4/4sn9I=;
	b=LwzxCSpnAlLczGJqr3kfjKG1fWYzDaksVsP/IoePfeNovYzzkzFBZi2RgMC6qn15sPdVHh
	6tj11NE5yTDgE/A0X5N1Q4gIrVFYe+ViMo3XvKzYZajgdACQqY5muw3nJVp0Wi+R2PqpOk
	fB5vHooD8mZ+yFI9aLNNGALWu7Mirtc=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-155-2TxgdbmoMQOJ19HkzQlaZg-1; Tue,
 25 Feb 2025 06:00:23 -0500
X-MC-Unique: 2TxgdbmoMQOJ19HkzQlaZg-1
X-Mimecast-MFC-AGG-ID: 2TxgdbmoMQOJ19HkzQlaZg_1740481219
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 429D51800998;
	Tue, 25 Feb 2025 11:00:19 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 51F183000197;
	Tue, 25 Feb 2025 11:00:12 +0000 (UTC)
Date: Tue, 25 Feb 2025 19:00:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 09/11] ublk: zc register/unregister bvec
Message-ID: <Z72itckfQq5p6xC2@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-10-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-10-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Feb 24, 2025 at 01:31:14PM -0800, Keith Busch wrote:
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
>  drivers/block/ublk_drv.c      | 117 +++++++++++++++++++++++-----------
>  include/uapi/linux/ublk_cmd.h |   4 ++
>  2 files changed, 85 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..a719d873e3882 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -51,6 +51,9 @@
>  /* private ioctl command mirror */
>  #define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
>  
> +#define UBLK_IO_REGISTER_IO_BUF		_IOC_NR(UBLK_U_IO_REGISTER_IO_BUF)
> +#define UBLK_IO_UNREGISTER_IO_BUF	_IOC_NR(UBLK_U_IO_UNREGISTER_IO_BUF)
> +
>  /* All UBLK_F_* have to be included into UBLK_F_ALL */
>  #define UBLK_F_ALL (UBLK_F_SUPPORT_ZERO_COPY \
>  		| UBLK_F_URING_CMD_COMP_IN_TASK \
> @@ -201,7 +204,7 @@ static inline struct ublksrv_io_desc *ublk_get_iod(struct ublk_queue *ubq,
>  						   int tag);
>  static inline bool ublk_dev_is_user_copy(const struct ublk_device *ub)
>  {
> -	return ub->dev_info.flags & UBLK_F_USER_COPY;
> +	return ub->dev_info.flags & (UBLK_F_USER_COPY | UBLK_F_SUPPORT_ZERO_COPY);
>  }

I'd suggest to set UBLK_F_USER_COPY explicitly either from userspace or
kernel side.

One reason is that UBLK_F_UNPRIVILEGED_DEV mode can't work for both.



Thanks,
Ming


