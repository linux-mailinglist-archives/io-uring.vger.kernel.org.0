Return-Path: <io-uring+bounces-11212-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E052ACCB3BF
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 10:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4CECB302A4FC
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:45:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BA02E8DEA;
	Thu, 18 Dec 2025 09:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UESuFAy5"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13D2219CD0A
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 09:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766051135; cv=none; b=HJqDiSRs/SP4wHkAipcjLMwaUneljEba1xj86GlEvRiaJV24pzNmGAVBIrdAru3RlR2h8WEaXlA6ROTXf5R8ERCQzbWykXwsCxpfzIJ19+5ru1lJagc+NfD86W2ttkr3yNT6+AmYk0C+JW13r/uv+pdNnvppmHaVp03hu7PdlfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766051135; c=relaxed/simple;
	bh=q1rd0BjwtXhRkpK33TpJLSX31WbVof4RvUjf4IaKg7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uy5NQG1g7VCnPBSJAG0gk4nNvNiQcLRSBiiWQlxcBpU7OZqjH+K3H2nsWniIWAbro+XFqyXvnJwOq9A++r42+4eNTsaLRyQCt1vRDjksvnn1fqZyI90kUuCZXNsU6dzbsSLuh4Y4Tu2y5kDymObx5DEeofInHPXe2ATkL+bdBUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UESuFAy5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766051133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WsrscNDNDKwUBouIdwhya0Xgx5ywCJWuXejSiWy6Ftw=;
	b=UESuFAy5n8wHVApb/HOs80eytzRMw09n8OK8+cayNxm630egA51QeIRiHeL/U4IWvkufzC
	iOuaYGkY7oS4HKQBVBlMsqWTdPWb/22n131blHLsTIURS6MGREVeUyW35Tun3/DX89PZZ5
	kB78tvsR4M60Nyj/Ts+qyjNoNoPgccU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-rX9NC6k_NFWuJq_zlZLheg-1; Thu,
 18 Dec 2025 04:45:30 -0500
X-MC-Unique: rX9NC6k_NFWuJq_zlZLheg-1
X-Mimecast-MFC-AGG-ID: rX9NC6k_NFWuJq_zlZLheg_1766051128
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23898195FCE3;
	Thu, 18 Dec 2025 09:45:28 +0000 (UTC)
Received: from fedora (unknown [10.72.116.190])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DD2D1194C65D;
	Thu, 18 Dec 2025 09:45:22 +0000 (UTC)
Date: Thu, 18 Dec 2025 17:45:16 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	huang-jl <huang-jl@deepseek.com>,
	Nitesh Shetty <nj.shetty@samsung.com>
Subject: Re: [PATCH 1/3] block: fix bio_may_need_split() by using bvec
 iterator way
Message-ID: <aUPNLNHVz2-Y-Z4C@fedora>
References: <20251218093146.1218279-1-ming.lei@redhat.com>
 <20251218093146.1218279-2-ming.lei@redhat.com>
 <aUPLYcAx2dh-DvuP@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUPLYcAx2dh-DvuP@infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Dec 18, 2025 at 01:37:37AM -0800, Christoph Hellwig wrote:
> On Thu, Dec 18, 2025 at 05:31:42PM +0800, Ming Lei wrote:
> > ->bi_vcnt doesn't make sense for cloned bio, which is perfectly fine
> > passed to bio_may_need_split().
> > 
> > So fix bio_may_need_split() by not taking ->bi_vcnt directly, instead
> > checking with help from bio size and bvec->len.
> > 
> > Meantime retrieving the 1st bvec via __bvec_iter_bvec().
> 
> That totally misses the point.  The ->bi_vcnt is a fast and lose
> check to see if we need the fairly expensive iterators to do the
> real check.

It is just __bvec_iter_bvec(), whatever it should be in cache sooner or
later.


Thanks,
Ming


