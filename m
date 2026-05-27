Return-Path: <io-uring+bounces-13521-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qOHwDNLiFmpIvAcAu9opvQ
	(envelope-from <io-uring+bounces-13521-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 14:25:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE3F5E4252
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 14:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AE7AD308B7EB
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 12:21:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC8433E7BB4;
	Wed, 27 May 2026 12:21:52 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D00C3E5596;
	Wed, 27 May 2026 12:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779884512; cv=none; b=DhbiWV7hRNPOQI+iI5jZUPbb6txFVXcW85a+pQ68NpwILuWDQdwKPom2BQpJD6bexg0FFF1w6UwH79A++j5jHMOkYgLntczhnoHThpBVPelvVShdN+LRcu4UIkWnS/dCEYss4Xy2vwUVAFhFj1UEsAvqTQMelUYRKCHgb0bZIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779884512; c=relaxed/simple;
	bh=J+ZnLy/9G+pJ8wHavzj3Dl55mP+QyCB7v2erG5OZu6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dRS0rzIzwRpy4UJDrAXbx4XuZXtp37yeIJQX0roNXZRFMhbNBqdmIfDWEebtkeUh+ri1T6wPgHrRR6Ax+8wdr0iuCLLgDTFcocnrPlJ9s8tcL4+r+RHJKHHWEVACzMfNB4zKAofHwKzHvnPgBUOpFo8S9CNQbIfGLSKiFmAMPa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id EDFD668BEB; Wed, 27 May 2026 14:21:48 +0200 (CEST)
Date: Wed, 27 May 2026 14:21:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: improve the kmem_cache_alloc_bulk API
Message-ID: <20260527122148.GA6838@lst.de>
References: <20260527070239.2252948-1-hch@lst.de> <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-0.997];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13521-lists,io-uring=lfdr.de];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: DEE3F5E4252
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 27, 2026 at 11:11:31AM +0200, Vlastimil Babka (SUSE) wrote:
> > value convention.  Fix that and add documentation.
> > 
> > Note that the few comments explaining it mention that the gfp flags
> > must allow "spinning".  That's not really a term used in the memory
> > allocator, is this supposed to mean "block" or "sleep"?
> 
> Page allocator now has alloc_pages_nolock() for when no spinning is
> possible, and it uses ALLOC_TRYLOCK internally.
> 
> Slab has kmalloc_nolock() relying on that when it needs new pages.

The comment long predates that, and it isn't expressed using gfp flags,
but by requiring separate functions so I somehow doubt that was meant.
But I could also not see why it would not support GFP_ATOMIC /
GFP_NOWAIT allocation, so I might just be confused.

