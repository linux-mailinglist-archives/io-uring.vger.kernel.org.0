Return-Path: <io-uring+bounces-9239-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B42AB30AB4
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 03:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1392C5E8382
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 01:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B29E393DE0;
	Fri, 22 Aug 2025 01:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZmXDNzPw"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A373F18E25
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 01:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755825515; cv=none; b=IXw0lNLCf8hPgT5sTpT3PsZGhxHPH/UVN1LWz9oVFZFZUuAOa4DxC7rT03S7+aN5A/7osVz3AK4rvLFqFPa1LYwvREnC9zGrYtBniI+sRW1h7uQfq/e1/FHOD/On4DLDV6HxCC4GHo2vlnIafG0bq+YSe6MVDEXafugflVts9Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755825515; c=relaxed/simple;
	bh=ECpG9wWDi+4/kQS3O+66urbK62At5JgLsE6Ib7IPnQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eruQOFEe698Di/t6h77EldsFCV6bdFXQX7WdNElUJPcijMPqFdkXm4mnnQfIjpVugpSfaL/06bdKzhCTjw+p8mrjt52QV6sPqoDbvQvckf8pUcfXUCphR+3s6ZhUmR7GxvVdndzVe/Pg4AdWaiY+J1OLFE0wFTjye4DKWd5RWqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZmXDNzPw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755825512;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7jycSKafi5uLOLCXqEsqJkqb037kQPCVkxOobogUuO4=;
	b=ZmXDNzPwy7sYuHfIDNS2iXsJDVsJItXG9t9+Pi+Wm5NrqtAEi2bEN7thCYkrAd3tcvZMQQ
	7b0GtgRArhE/rCfgPJ8w1T82nUhkEKbJGod8LPGVcdV3hvC18r2AcjkUVteexptphj2b3Q
	qnYbGt5pBD69o1X1xE1AZMQVnVSP6HQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-677-JVRIeySYOy2Uk9Ud0-4Hjg-1; Thu,
 21 Aug 2025 21:18:26 -0400
X-MC-Unique: JVRIeySYOy2Uk9Ud0-4Hjg-1
X-Mimecast-MFC-AGG-ID: JVRIeySYOy2Uk9Ud0-4Hjg_1755825505
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CA30180ACFC;
	Fri, 22 Aug 2025 01:18:18 +0000 (UTC)
Received: from fedora (unknown [10.72.116.34])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E40BE1800282;
	Fri, 22 Aug 2025 01:18:12 +0000 (UTC)
Date: Fri, 22 Aug 2025 09:18:03 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: [PATCH 3/3] io_uring/cmd: consolidate REQ_F_BUFFER_SELECT checks
Message-ID: <aKfFS9kcSuP0_aeV@fedora>
References: <20250821163308.977915-1-csander@purestorage.com>
 <20250821163308.977915-4-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821163308.977915-4-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Thu, Aug 21, 2025 at 10:33:08AM -0600, Caleb Sander Mateos wrote:
> io_uring_cmd_prep() checks that REQ_F_BUFFER_SELECT is set in the
> io_kiocb's flags iff IORING_URING_CMD_MULTISHOT is set in the SQE's
> uring_cmd_flags. Consolidate the IORING_URING_CMD_MULTISHOT and
> !IORING_URING_CMD_MULTISHOT branches into a single check that the
> IORING_URING_CMD_MULTISHOT flag matches the REQ_F_BUFFER_SELECT flag.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>  io_uring/uring_cmd.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index c8fd204f6892..482cc5be1f8d 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -199,17 +199,13 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		if (ioucmd->flags & IORING_URING_CMD_MULTISHOT)
>  			return -EINVAL;
>  		req->buf_index = READ_ONCE(sqe->buf_index);
>  	}
>  
> -	if (ioucmd->flags & IORING_URING_CMD_MULTISHOT) {
> -		if (!(req->flags & REQ_F_BUFFER_SELECT))
> -			return -EINVAL;
> -	} else {
> -		if (req->flags & REQ_F_BUFFER_SELECT)
> -			return -EINVAL;
> -	}
> +	if (!!(ioucmd->flags & IORING_URING_CMD_MULTISHOT) !=
> +	    !!(req->flags & REQ_F_BUFFER_SELECT))
> +		return -EINVAL;

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


