Return-Path: <io-uring+bounces-6736-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D322AA43A14
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 10:47:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3C0F717B623
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E273266599;
	Tue, 25 Feb 2025 09:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G8J8Gs6F"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB5F266590
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 09:42:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476536; cv=none; b=W45dyyc7rpJuHSfFK+MES1euLuO9PFIRPgmAP6PnUlPMg7r7tR6YJ4oAsYcWLP5uOYif3wSbcdr/GXJmABUmK7rHD4uZNZqskdlRHg9qEF8+/pPqlfCOzw8YLi1hxtkjAtf33oSxmidQBRrQTveYO5MFbs1RAQ/h6PmI/DMKNW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476536; c=relaxed/simple;
	bh=DlMS0Wj6BALT7glSDOHo3OuVJW8+hWkASn8ha2Zauz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K2GLIp4qPziEIzxSNcoVoZ5qOU4JsvuEPqiv/qs4NU97K+gWk2b8fY9mOAyLqg1ITWG0qnRd560bp3jS47qK+BGmuMCNSOcuUrdZHu2tQxMuhz+64h+9JY9LhLiXhnxZdkWoPVQQA8tDwLrVxjwOmhtJAHgQhIkBPh/dcO7p4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G8J8Gs6F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740476533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6hCglnFAAnHz251jrwMUdMs/kU7N9ipr7lgfsukSxr0=;
	b=G8J8Gs6FPhB0/J6ZbWlvbi6qVgImnvBVIENYL4d0vp5k1vonw5s7FAZHrC/wA1QD8k48rk
	gw9KFWh/0ETOv+jOqFURvXYph5jn2irc91EhyeWwblBMlrIfFrxE7h5KynY47TvZIamX+q
	hhaRsxS56+FC7+LKBbEYMfbojDDXE/k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-08rqH9ApM0SZOMORbTBP-w-1; Tue,
 25 Feb 2025 04:42:09 -0500
X-MC-Unique: 08rqH9ApM0SZOMORbTBP-w-1
X-Mimecast-MFC-AGG-ID: 08rqH9ApM0SZOMORbTBP-w_1740476528
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39C7A18D95E0;
	Tue, 25 Feb 2025 09:42:08 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7AE21800366;
	Tue, 25 Feb 2025 09:42:01 +0000 (UTC)
Date: Tue, 25 Feb 2025 17:41:56 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Xinyu Zhang <xizhang@purestorage.com>,
	Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 08/11] nvme: map uring_cmd data even if address is 0
Message-ID: <Z72QZDMDKUDS0j6T@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-9-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-9-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Feb 24, 2025 at 01:31:13PM -0800, Keith Busch wrote:
> From: Xinyu Zhang <xizhang@purestorage.com>
> 
> When using kernel registered bvec fixed buffers, the "address" is
> actually the offset into the bvec rather than userspace address.
> Therefore it can be 0.
> We can skip checking whether the address is NULL before mapping
> uring_cmd data. Bad userspace address will be handled properly later when
> the user buffer is imported.
> With this patch, we will be able to use the kernel registered bvec fixed
> buffers in io_uring NVMe passthru with ublk zero-copy support in
> https://lore.kernel.org/io-uring/20250218224229.837848-1-kbusch@meta.com/T/#u.
> 
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> Signed-off-by: Xinyu Zhang <xizhang@purestorage.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming


