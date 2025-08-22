Return-Path: <io-uring+bounces-9238-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B843AB30AB6
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 03:19:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9434C3AA3A0
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 01:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1629918E25;
	Fri, 22 Aug 2025 01:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EM3A1yTK"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B0E19D06B
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 01:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755825433; cv=none; b=Vg9zz0H/2zOP12Q42EkWrRj4IqL4MhLR808rfqjH1f++E8fJxyJniB05BUqEPAW3O7poQCLRkYogesV+Cjr3wJkH94F2Ah7G5mQu3VCzFBCedZNoggSMHPzFCXtgS5+k7hc/a5ktFNt9aRX+c7lZ3OXFdVjbT6hJbGd/AAeQv5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755825433; c=relaxed/simple;
	bh=nIh+agPpN5EGhEGnZq1LgKseDWd2mle8sA/felsKkdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XR064zEHHFOgwR3bkDLSVk3ZNnvA7NFss1/wKLmfETI4ODCpc7FE07PjKxpDdQSK7nLYDfBHaYpJsmk0K090jk3FMj79CI0UmOQq7uXL64E+IP9A9RjrWLmgOmQxZvvxEGbl0pDBU0T3FNvPStoAgeaWjj2w2RKIJ7KccHY0nx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EM3A1yTK; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755825430;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fPzLB7pBjuUuKfqWj0ASBxP+XYVK4K1zs8RiU1+QTFw=;
	b=EM3A1yTKlIM6g8fHm7+U8yiqmDwROCFx2Gl1l0C5P3L1KKNYYqK3+mKAoTp0MXeRFN9CPQ
	7UxCjHsYytYMG7wkG2/CorWuJowoFKHgj7tlf5jrRRZv3Qi1OBAfE5YDVHYLc1Y53Hrhz9
	OlnvWxFR9PEM8SxQJNCUKoSz7IAbwQY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-245-DzVCdXZvO-SBMDrJrXYJgw-1; Thu,
 21 Aug 2025 21:17:07 -0400
X-MC-Unique: DzVCdXZvO-SBMDrJrXYJgw-1
X-Mimecast-MFC-AGG-ID: DzVCdXZvO-SBMDrJrXYJgw_1755825426
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C2911800347;
	Fri, 22 Aug 2025 01:17:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.34])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 76A8D3001453;
	Fri, 22 Aug 2025 01:17:03 +0000 (UTC)
Date: Fri, 22 Aug 2025 09:16:53 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/3] io_uring/cmd: deduplicate uring_cmd_flags checks
Message-ID: <aKfFBe_nNskOLwvx@fedora>
References: <20250821163308.977915-1-csander@purestorage.com>
 <20250821163308.977915-3-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821163308.977915-3-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Aug 21, 2025 at 10:33:07AM -0600, Caleb Sander Mateos wrote:
> io_uring_cmd_prep() currently has two checks for whether
> IORING_URING_CMD_FIXED and IORING_URING_CMD_MULTISHOT are both set in
> uring_cmd_flags. Remove the second check.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/uring_cmd.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 3cfb5d51b88a..c8fd204f6892 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -200,12 +200,10 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  			return -EINVAL;
>  		req->buf_index = READ_ONCE(sqe->buf_index);
>  	}
>  
>  	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> -		if (ioucmd->flags & IORING_URING_CMD_FIXED)
> -			return -EINVAL;
>  		if (!(req->flags & REQ_F_BUFFER_SELECT))
>  			return -EINVAL;
>  	} else {
>  		if (req->flags & REQ_F_BUFFER_SELECT)
>  			return -EINVAL;

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


