Return-Path: <io-uring+bounces-13888-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id zLaDEK1dS2rOQAEAu9opvQ
	(envelope-from <io-uring+bounces-13888-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 09:47:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 03B1C70DC2A
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 09:47:57 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=lst.de (policy=none);
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13888-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.232.135.74 as permitted sender) smtp.mailfrom="io-uring+bounces-13888-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E23A430DEDA5
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 07:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D139A426432;
	Mon,  6 Jul 2026 06:46:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E58C3F4834;
	Mon,  6 Jul 2026 06:45:56 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783320363; cv=none; b=BlzLzU/otww6TmNZ+ILY1+JUDAvvvVQyixeSL5eMOvultYR84DvBSob9cE55DmIbnWdVQ914DUk/a+UZZKhdTj57f+0cPegCslzNDEqCitNEbgRrsE1jVsRnYWP2HVR8u1FgMetr6QSoUsE0lNqVirJU6PiHM3UqBPD50CVoenw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783320363; c=relaxed/simple;
	bh=OC+vDGhtn+Wq2xL2Syf5viqRKOwuyUc9jj8EkZPRHro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oj9NfsR+D0sb+oIDJrh9HAcUqDB9OmfNQS99c8L+eAJThX76X+Lw8tct2cPxtRFk+/hHfr08S39WBeCQt19eAVUcDp3ipVAzwNdE0Q0UwYcLVqvJkZRPamSayleC9IkaOtw6rWlAjcO0/w648xV4cXoJqYGNKBeaDAf6FMdFGIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Received: by verein.lst.de (Postfix, from userid 2407)
	id AF04068B05; Mon,  6 Jul 2026 08:45:47 +0200 (CEST)
Date: Mon, 6 Jul 2026 08:45:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-aio@kvack.org, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
Message-ID: <20260706064547.GA25268@lst.de>
References: <20260706041125.642097-1-hch@lst.de> <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8583b332-0d24-4f6f-8831-69e3aad936fd@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13888-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:johannes.thumshirn@wdc.com,m:hch@lst.de,m:axboe@kernel.dk,m:linux-block@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-aio@kvack.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-mm@kvack.org,s:lists@lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	R_DKIM_NA(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:mid,lst.de:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 03B1C70DC2A

On Mon, Jul 06, 2026 at 08:38:12AM +0200, Johannes Thumshirn wrote:
> On 7/6/26 6:11 AM, Christoph Hellwig wrote:
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 9213a5716f95..20cb8ed7d987 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -7,6 +7,7 @@
>>     #include <linux/types.h>
>>   #include <linux/blk_types.h>
>> +#include <linux/blk_plug.h>
>>   #include <linux/device.h>
>>   #include <linux/list.h>
>>   #include <linux/llist.h>
>>
> I know it's a lot of cross subsystem churn, but wouldn't it be cleaner to 
> not include blk_plug.h in blkdev.h, but patch the update the consumers? A 
> quick grep shows 68 files that would need updating and some you already  
> have updated.

Right now blkdev.h needs the rq_list from it.  So we'd need to move
that to linux/types.h or something first, which feels a bit iffy.

And no, including blk_types.h in blk_plug.h is not a solution,
as that is still touched far too often.

