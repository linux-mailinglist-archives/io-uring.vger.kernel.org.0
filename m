Return-Path: <io-uring+bounces-4312-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C7AAD9B95AA
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:42:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AD7D281273
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 16:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2438E1C9ECC;
	Fri,  1 Nov 2024 16:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VPN6z4Bf"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72A633F7
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 16:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730479345; cv=none; b=XYPKDjFbGM4Xdo71oPX5xoqgFFozAylJ2qbey1KxLgGpQHJsXWq8cotSayx1xKNtenqhF4d7UqggChEJqjvUgRiZ+Nj/h6AayfVx/2NQ0aT+JO2GjwGAmh6nwrNs/NKIWJ+4YUqoBEP3ivvU42GzI6obdTuIFkMs5nvY6YV6xvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730479345; c=relaxed/simple;
	bh=41jsXj9HiPye9EZEX8FCZGoCUwb1iIM1188UAzwmzck=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gExBYjTX3U00J5AeQ4MSKxvfcFbft3WsxhksEbLYKViY8vbDpkOuBrXao+GD2OXRqz+H0dTsoOEyFErSMYy1ccM7aYM6esGO2Zivk7/j2rmHMorD2l1mSAeXS/dcsbh0qiwllXgkFdFapKdP/svY9BZubODWFk5jKpOeOC2QCus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VPN6z4Bf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730479341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hNnZeBds2WpKx0IIBFYY8TK2aXlxnjxfhiCcGBuVzxA=;
	b=VPN6z4Bf7zZPBiPnVqm4gE3tanW2aCrWNjhHeGSsurFc3dE3eLnJgb+YTjuo7NR4PFsFb+
	JOTwaVW2qAdzJ5u0cKp0BZwHr2cU0VjjDJMr43KQpoptgdx1/wqpsWV4wW0o50Fm5cgSm0
	WoBCGl5MBszryXJEGRhRjRzKdv3467w=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-509-IYRgYiU-MzSlhR7Xhb4b9w-1; Fri,
 01 Nov 2024 12:42:16 -0400
X-MC-Unique: IYRgYiU-MzSlhR7Xhb4b9w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 05FA71955F41;
	Fri,  1 Nov 2024 16:42:14 +0000 (UTC)
Received: from fedora (unknown [10.72.116.17])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C05191956086;
	Fri,  1 Nov 2024 16:42:09 +0000 (UTC)
Date: Sat, 2 Nov 2024 00:42:04 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH v2] io_uring: extend io_uring_sqe flags bits
Message-ID: <ZyUE3A2nGiIBLDGx@fedora>
References: <d86e060f-be37-4efe-8d58-95cf8a22d37e@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d86e060f-be37-4efe-8d58-95cf8a22d37e@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Nov 01, 2024 at 09:15:28AM -0600, Jens Axboe wrote:
> In hindsight everything is clearer, but it probably should've been known
> that 8 bits of ->flags would run out sooner than later. Rather than
> gobble up the last bit for a random use case, add a bit that controls
> whether or not ->personality is used as a flags2 argument. If that is
> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
> which personality field to read.
> 
> While this isn't the prettiest, it does allow extending with 15 extra
> flags, and retains being able to use personality with any kind of
> command. The exception is uring cmd, where personality2 will overlap
> with the space set aside for SQE128. If they really need that, then that
> would have to be done via a uring cmd flag.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming


