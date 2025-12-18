Return-Path: <io-uring+bounces-11213-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 70452CCB437
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:52:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A65830F0BD6
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:48:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDAAD2E8DEA;
	Thu, 18 Dec 2025 09:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hi2FzM0O"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A44F3314C4
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 09:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766051302; cv=none; b=iaIc7MwXM2AUnsfaRuhv98CiEGBjQ4jGejSLbWNhphrP4D+Bkp3A1j/G6y9CTd1ofuJrAVPM4cTMaQcU/fDt+kWkRpHEKHnSMkcy4dQTM1Dc5CJl8xA3prudPwue4/xLrv2EVh8w7XD6jriWeH0KLhkNVXAbmxwZzAfn/ZDNu88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766051302; c=relaxed/simple;
	bh=rP/Ofn1sN0BmK5KiKRvC3orLKLHaV0DW0GjCZtua9O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PbC/jVmT3Ioq/SJh2mwtk8LN+qellF+fhQagISzUUzGLwI03cQAx7fqbSYuFAKEGNLmKTf8tcDBbVHGBi2m/rWR5twchZq/dRpShmZHmDEQZViCs1vHo9BJAuJC6nZRCk3tRLCSzIR+4j+5hUoRnSaPzQrchb0/lKvlv1Krc+Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hi2FzM0O; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766051300;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tgn5lR7FDYBypxhGgnmczlkEtfdsuZV3CEtWkEFDsnc=;
	b=hi2FzM0OGfRFYR0fdnhDj785T5WMAHqjEeAbz7v4dH0ugB+rI7FrYrLVPOa3mrto1p270P
	LP53TQnDiVKV9DTClERBY/iAWotL34r8ZxosrGnKe/s7p9P7khaQbOW4Gd0rdkVgP4/NHy
	oEYgWwRkr/WBjMEkRiAB6NTNyB/Xf38=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-357-89Zs1v1tNFKGla9eqU8yIQ-1; Thu,
 18 Dec 2025 04:48:18 -0500
X-MC-Unique: 89Zs1v1tNFKGla9eqU8yIQ-1
X-Mimecast-MFC-AGG-ID: 89Zs1v1tNFKGla9eqU8yIQ_1766051297
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1E361956094;
	Thu, 18 Dec 2025 09:48:16 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5F82B1955F2D;
	Thu, 18 Dec 2025 09:48:09 +0000 (UTC)
Date: Thu, 18 Dec 2025 17:48:05 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH 2/3] block: don't initialize bi_vcnt for cloned bio in
 bio_iov_bvec_set()
Message-ID: <aUPN1W9PmN6Xo2sL@fedora>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
 <20251218093146.1218279-3-ming.lei@redhat.com>
 <aUPLr_cUd9nmvoI0@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUPLr_cUd9nmvoI0@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Dec 18, 2025 at 01:38:55AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 18, 2025 at 05:31:43PM +0800, Ming Lei wrote:
> > For a cloned bio, bi_vcnt should not be initialized since the bio_vec
> > array is shared and owned by the original bio.
> 
> Maybe, maybe not.  What is the rational for that "should" ?
 
->bi_vcnt is never set for bio allocated from bio_alloc_clone().

Thanks, 
Ming


