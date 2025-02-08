Return-Path: <io-uring+bounces-6321-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE92A2D430
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 06:50:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 147A31883D0D
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 05:51:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6262F16C850;
	Sat,  8 Feb 2025 05:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eBo3ZILn"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CFF2155A52
	for <io-uring@vger.kernel.org>; Sat,  8 Feb 2025 05:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738993851; cv=none; b=SqbZtO30M4pOPHCO+3TW7Z1yQaM7lPsrcmGWo4LDMor2tH1EJpnFBE/OVFu2M5QlGCOWilRgobiYBs2f7zqkDFyZUqptoZYEekV4UDqIAzwXrK9fWswn4xTWo82bB5zAkYd8Eg/HMU7YOEOS20zz6zD1QKQ929RA7X/iQpv0v48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738993851; c=relaxed/simple;
	bh=g5AsJVVTjYSMzWeyR06eH3vH9y6FqHzNYls3KvKoj1U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KTAU+Efncqx4bWqCIHz8+lMm7fnDPSLHY56jZ7pJPxoslU/8aqfWVCsH5Pvimigti2MkCniX6/8l4NUBcWAcIdN8NG3Li3At5kwYLCZL9nB6rJG2rnMQnylux2GNo4zqlkKF/WqUVNoXsCVh79cPr6TKZ3uFCQGDgdBWPDLz76E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eBo3ZILn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738993848;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZReVkBK0P5fEbkSpR2zDqLzG3OtsWAYokhIF/dbxco=;
	b=eBo3ZILn2GfdA04FkI/MDV5rbrlFlWsev4HTC3BxvfTZTh90oEf4Wq0uSCczSAWnDaX/3p
	E4x04X+ARRiLKnbohuhDcQu/w3DpGxpX/jLCzTM6pvhwxfTLqx5tV9l+rIhKa/ccCONqaV
	NKaEpSYIF2xn5YRsNuXLX8K0oDd/eKo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-a4y5X4FlPaKZiHLy0eIytw-1; Sat,
 08 Feb 2025 00:50:46 -0500
X-MC-Unique: a4y5X4FlPaKZiHLy0eIytw-1
X-Mimecast-MFC-AGG-ID: a4y5X4FlPaKZiHLy0eIytw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0949A180056F;
	Sat,  8 Feb 2025 05:50:45 +0000 (UTC)
Received: from fedora (unknown [10.72.116.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B7D81955BCB;
	Sat,  8 Feb 2025 05:50:39 +0000 (UTC)
Date: Sat, 8 Feb 2025 13:50:34 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 4/6] ublk: zc register/unregister bvec
Message-ID: <Z6bwqinHSZqWwYdu@fedora>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-5-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203154517.937623-5-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Feb 03, 2025 at 07:45:15AM -0800, Keith Busch wrote:
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
>  drivers/block/ublk_drv.c      | 139 +++++++++++++++++++++++++---------
>  include/uapi/linux/ublk_cmd.h |   4 +
>  2 files changed, 107 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 529085181f355..58f224b5687b9 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -51,6 +51,9 @@
>  /* private ioctl command mirror */
>  #define UBLK_CMD_DEL_DEV_ASYNC	_IOC_NR(UBLK_U_CMD_DEL_DEV_ASYNC)
>  
> +#define UBLK_IO_REGISTER_IO_BUF		_IOC_NR(UBLK_U_IO_REGISTER_IO_BUF)
> +#define UBLK_IO_UNREGISTER_IO_BUF	_IOC_NR(UBLK_U_IO_UNREGISTER_IO_BUF)
> +

...

> @@ -1798,6 +1894,10 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
>  
>  	ret = -EINVAL;
>  	switch (_IOC_NR(cmd_op)) {
> +	case UBLK_IO_REGISTER_IO_BUF:
> +		return ublk_register_io_buf(cmd, ubq, tag, ub_cmd);
> +	case UBLK_IO_UNREGISTER_IO_BUF:
> +		return ublk_unregister_io_buf(cmd, ubq, tag, ub_cmd);

Here IO_BUF is kernel buffer, we have to make sure that it won't be
leaked.

Such as application panic, how to un-register it?


Thanks,
Ming


