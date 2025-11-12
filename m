Return-Path: <io-uring+bounces-10522-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id DC681C502A6
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 02:02:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 82E8834C24F
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 01:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089311D5CD4;
	Wed, 12 Nov 2025 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YxAQ/v1D"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB941227B94
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 01:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762909322; cv=none; b=FrAbjX74UgioVAz3sxN7L0WJZRZRo4OXqa8vyp2MBOOJy4DPD38W9DIhI53+vtrKcCFFdGK0vSZIXNUgDrLAwcqWH68n5ygfmIOA0MtlTc2uf515ut+pUbZp/IIFyUV1gMJm2z2QupuuRp6Emqzl/lsBK+Xh7FX1LrGyPJ76mgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762909322; c=relaxed/simple;
	bh=nWLtCDFyxDJXd3sDd9Z8S0ulDuiXZzc63es1RkwCMVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fo7uMg9F5BhnSsu70GSzGJGdBRH7ThYd1vEbAQgQ+D/KWcAkhI2pwYrbbqAGcu4EvK8w8RQA+5OPOAgfC9zN3st61P5BHiJb2jhYRI924OGpIlYQ6P/gsExRAphrdGcmh6uBXanGLxP8LhvlevV85JIqY1warYG83nYhscYHhfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YxAQ/v1D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762909315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QqGeUcwYfLWiIUxBOSFJgnfAAg9kUqwtogn1q9e0KTk=;
	b=YxAQ/v1DDzi725MSpz9Df+XcXS5O5uPsOrvPRgJFzfr8EQyXZVKsj2rhDg6T6eNzQS9jFD
	jGaa79dypkAQYak3h5KWEdNOXQqKebMP8iTrRZDNGEIQYIW5YO81U90azy0RLMwovo3zbX
	hXIeii5am90YeTYsu0HeCyVNOEJpYIU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-JzI5J6KIND6L0o-6_X6DkQ-1; Tue,
 11 Nov 2025 20:01:54 -0500
X-MC-Unique: JzI5J6KIND6L0o-6_X6DkQ-1
X-Mimecast-MFC-AGG-ID: JzI5J6KIND6L0o-6_X6DkQ_1762909313
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 946FD180048E;
	Wed, 12 Nov 2025 01:01:52 +0000 (UTC)
Received: from fedora (unknown [10.72.116.17])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B71661955F1A;
	Wed, 12 Nov 2025 01:01:47 +0000 (UTC)
Date: Wed, 12 Nov 2025 09:01:42 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Keith Busch <kbusch@kernel.org>, Chaitanya Kulkarni <kch@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] io_uring/rsrc: don't use blk_rq_nr_phys_segments() as
 number of bvecs
Message-ID: <aRPcdmpZoet2fwbu@fedora>
References: <20251111191530.1268875-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111191530.1268875-1-csander@purestorage.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Tue, Nov 11, 2025 at 12:15:29PM -0700, Caleb Sander Mateos wrote:
> io_buffer_register_bvec() currently uses blk_rq_nr_phys_segments() as
> the number of bvecs in the request. However, bvecs may be split into
> multiple segments depending on the queue limits. Thus, the number of
> segments may overestimate the number of bvecs. For ublk devices, the
> only current users of io_buffer_register_bvec(), virt_boundary_mask,
> seg_boundary_mask, max_segments, and max_segment_size can all be set
> arbitrarily by the ublk server process.
> Set imu->nr_bvecs based on the number of bvecs the rq_for_each_bvec()
> loop actually yields. However, continue using blk_rq_nr_phys_segments()
> as an upper bound on the number of bvecs when allocating imu to avoid
> needing to iterate the bvecs a second time.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> Fixes: 27cb27b6d5ea ("io_uring: add support for kernel registered bvecs")

Reviewed-by: Ming Lei <ming.lei@redhat.com>

BTW, this issue may not be a problem because ->nr_bvecs is only used in
iov_iter_bvec(), in which 'offset' and 'len' can control how far the
iterator can reach, so the uninitialized bvecs won't be touched basically.

Otherwise, the issue should have been triggered somewhere.

Also the bvec allocation may be avoided in case of single-bio request,
which can be one future optimization.


Thanks,
Ming


