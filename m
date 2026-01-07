Return-Path: <io-uring+bounces-11428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE4CCFBEBB
	for <lists+io-uring@lfdr.de>; Wed, 07 Jan 2026 05:11:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2C6C93019BFB
	for <lists+io-uring@lfdr.de>; Wed,  7 Jan 2026 04:11:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F5F188CC9;
	Wed,  7 Jan 2026 04:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c5BpVbCR"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86D285C4A
	for <io-uring@vger.kernel.org>; Wed,  7 Jan 2026 04:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767759080; cv=none; b=XZGS+rFlLqOAKerUrolm+eFlJ2+pH2X7xpU7OL0L05e0X3mf0Hx3/mOmsHEOr28GADsbGIGFwlpl6Ufx+ZP6pIAJ2zQ44k+iGp5n9lrNOfCWM6uYiHBOmdcjG64WFoHk8sxSQpHeuW2gTY1c9vMJzAKgSWF4qAMcCni4Mwi0tYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767759080; c=relaxed/simple;
	bh=HqcGPuE5HInpGjr9ZdqPOWL8+0D6iiKhxDT8E0/yTRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TABloKQqn0TFMyAx0vBueyFHW80d07yHgWKJFht7Qdc62VYEIWOicyCQfDCjLwA/auTKcKUTnlvCnVOQ3RRTUsBC1gIoAcGSIN4MXko2id/ke4AV16A0r96vRMX2pyc+SiqPZJhrac11S7EkmP5M8fkx8YznXvWdwuj/ETn8iIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c5BpVbCR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767759077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Jin/vEZZymCL/DVlcrCtAux5SXI8ULCxtzzAdOtrPIM=;
	b=c5BpVbCRTKKKCAu+OYi8XXgRwK4tH1bFrMTYh1xvp5wFM6FMlL6m/Pw7fuugIybRasry0S
	uO6NFOOJ8HSD2ThNeG3ZtgG+LQfiDRqrbjrlUlYBil+9hH8HdI4SWS4SkfpaEJkE+l1oZZ
	hxnL+6nLJHg/X0q1DzxedjwEMkNzdgc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-440-LaAqKakxOKmbs_u_avyUkA-1; Tue,
 06 Jan 2026 23:11:16 -0500
X-MC-Unique: LaAqKakxOKmbs_u_avyUkA-1
X-Mimecast-MFC-AGG-ID: LaAqKakxOKmbs_u_avyUkA_1767759075
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6F5B195608A;
	Wed,  7 Jan 2026 04:11:14 +0000 (UTC)
Received: from fedora (unknown [10.72.116.130])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 57B64180009E;
	Wed,  7 Jan 2026 04:11:10 +0000 (UTC)
Date: Wed, 7 Jan 2026 12:11:06 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org, Caleb Sander Mateos <csander@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH V2 0/3] block: avoid to use bi_vcnt in
 bio_may_need_split()
Message-ID: <aV3c2jrL-ykptXhf@fedora>
References: <20251231030101.3093960-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251231030101.3093960-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, Dec 31, 2025 at 11:00:54AM +0800, Ming Lei wrote:
> This series cleans up bio handling to use bi_iter consistently for both
> cloned and non-cloned bios, removing the reliance on bi_vcnt which is
> only meaningful for non-cloned bios.
> 
> Currently, bio_may_need_split() uses bi_vcnt to check if a bio has a
> single segment. While this works, it's inconsistent with how cloned bios
> operate - they use bi_iter for iteration, not bi_vcnt. This inconsistency
> led to io_uring needing to recalculate iov_iter.nr_segs to ensure bi_vcnt
> gets a correct value when copied.
> 
> This series unifies the approach:
> 
> 1. Make bio_may_need_split() use bi_iter instead of bi_vcnt. This handles
>    both cloned and non-cloned bios in a consistent way. Also move bi_io_vec
>    adjacent to bi_iter in struct bio since they're commonly accessed
>    together.
> 
> 2. Stop copying iov_iter.nr_segs to bi_vcnt in bio_iov_bvec_set(), since
>    cloned bios should rely on bi_iter, not bi_vcnt.
> 
> 3. Remove the nr_segs recalculation in io_uring, which was only needed
>    to provide an accurate bi_vcnt value.
> 
> Nitesh verified no performance regression on NVMe 512-byte fio/t/io_uring
> workloads.
> 
> V2:
> 	- improve bio layout by putting bi_iter and bi_io_vec together
> 	- improve commit log

Hello Guys,

Ping...


Thanks,
Ming


