Return-Path: <io-uring+bounces-13891-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 5IuQIkaaS2pXWQEAu9opvQ
	(envelope-from <io-uring+bounces-13891-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 14:06:30 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id F1F8F7103E1
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 14:06:29 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=lst.de (policy=none);
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13891-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13891-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C63538F1A01
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 10:05:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6167542465D;
	Mon,  6 Jul 2026 09:54:16 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4742D0C63;
	Mon,  6 Jul 2026 09:54:11 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783331655; cv=none; b=Q6yXQ0lfj3TNaD3TX5cALPqe6cmdcIZO2pdROfYX/gjXKPe3U6NbKrOx7NcdysrWUOidKbxEnr3tYIibddmxLIZgt6IaoMUlLD3WWR+6aB10+gE9dCtPsR3xQ18DOkx8YdwPz4PLBYxsQ3vOLnnhFHS60tGNxot5h7bixcqK9KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783331655; c=relaxed/simple;
	bh=88rZNE8H62mx4kkv9q3eZ1/Dp5y2P4DyFwj7L+eNNvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBsymRhFMU8MoSndrYCtYnCVEJV6EsA4GORd/2IvAil1wGI5NF+vFgHvHzrWkFp5p7cIrwvAoaOQ0rT+fw5VZ2x/oTcxYGNKOZMDqA2jyCyShSiMbAfTletuAQo+ZVKmbM+4/+W+Az8SABOSUwWOMTXHfIYtOlZGwI+IyLISfMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7114168B05; Mon,  6 Jul 2026 11:54:07 +0200 (CEST)
Date: Mon, 6 Jul 2026 11:54:07 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
Message-ID: <20260706095407.GA4420@lst.de>
References: <20260706041125.642097-1-hch@lst.de> <f389a101-2af1-4b18-a74b-031e6c1899bd@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f389a101-2af1-4b18-a74b-031e6c1899bd@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13891-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:dlemoal@kernel.org,m:hch@lst.de,m:axboe@kernel.dk,m:linux-block@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-aio@kvack.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-mm@kvack.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F1F8F7103E1

On Mon, Jul 06, 2026 at 04:04:48PM +0900, Damien Le Moal wrote:
> > +#include <linux/sched.h>
> 
> struct blk_plug_cb has a list_head. So maybe also add
> 
> #include <linux/types.h>
> 
> ?

That already gets pulled in.

> > +
> > +struct blk_plug_cb;
> 
> Maybe add "struct request;" here too ?

No need for type forward declarations when the types are only used
for pointers in structs (or as pointer variables).  They are needed
only when pointers to the type are used in prototypes.


