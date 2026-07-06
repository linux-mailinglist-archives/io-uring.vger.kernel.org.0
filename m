Return-Path: <io-uring+bounces-13890-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id tusgBYZgS2qeQQEAu9opvQ
	(envelope-from <io-uring+bounces-13890-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 10:00:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A28D270DD9F
	for <lists+io-uring@lfdr.de>; Mon, 06 Jul 2026 10:00:05 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="feFpZYt/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13890-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13890-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0D01B31A5D06
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2026 07:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FD8B34CFC7;
	Mon,  6 Jul 2026 07:05:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0927A30D3EA;
	Mon,  6 Jul 2026 07:05:08 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783321521; cv=none; b=cSjOWWRxu+W5X6gXftUjeD1bw+YFLIwWPxtTgyyWBow/fn4Fp0kdb2fxaq/fZxQJXuyUc68w0jiPU7QC5gSoWld9aBR1sbkZxHv72mIQZVXKlOnULAuvlyLeVnOBAABxEwWEo6RFd6U4uOkRYQIehtSeizawTZJjGIkI2ihAFCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783321521; c=relaxed/simple;
	bh=ifp4jrTbWm892emhrD2Jct5nLbBFcW3SW8Hx2KR8+QU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kx5e57ZjRyMiW0EQuDvVbnmzRIXO3hotpcgrShD5kS0ciBi4MGRymyarfGjexXVzogdfTSB/d7Wp+CalvCjV+F2jb8Dqi6c/otVvA721vuubkPXqE6LotPivtxi3joUl25d+2JR6Ao032eCoVlOWKsRwMYzSkbou3aqI3cVIbQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=feFpZYt/; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF3F1F000E9;
	Mon,  6 Jul 2026 07:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783321501;
	bh=pNbrr+7vMT7d+YXsU70gpKCnA0Dr+Mk7HOfp5wCYwZo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=feFpZYt/26Zu6oQDe8KTR4CsOLq8nbovv5veYlAR8oXbRmknryTnI6dTL06QDz2Km
	 4L6h0rGzbcCThuUWIGOgQuketk1b7E8jST5IYWRijP63cHmE20eeT4UbQlbzNyLqaa
	 UeKQac7FEP1jMX+JvUdMlhMBLPaObSXgf5poOROmGxLqeMlOSSHhgzWda0QALdh4Vc
	 xpRJmLCShiOArPmQULLXXNc9bieFXDIpHt691bECXrwOGqFrYZjo5NMrYOFggIxP6P
	 CTaO1Os/viUA2cwscR359cgFmNjbTJ8RMwPqMzDgUzcDaX5qV3cRc1QgSLwdoUew8/
	 94dRKMzW9DAAg==
Message-ID: <f389a101-2af1-4b18-a74b-031e6c1899bd@kernel.org>
Date: Mon, 6 Jul 2026 16:04:48 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: split out a new blk_plug.h helper
To: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-aio@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
 linux-mm@kvack.org
References: <20260706041125.642097-1-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260706041125.642097-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:hch@lst.de,m:axboe@kernel.dk,m:linux-block@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-aio@kvack.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:linux-mm@kvack.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-13890-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A28D270DD9F

On 7/6/26 1:11 PM, Christoph Hellwig wrote:
> blkdev.h gets included in various places outside the block layer just
> for struct blk_plug and related plugging functions.
> 
> Split blk_plug into a separate helper to reduce the amount of code
> that needs to get rebuilt when blkdev.h changes and to slightly
> reduce compile times.
> 
> In io_uring this requires pulling in a few other headers explicitly that
> previously were implicitly included through blkdev.h.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

A couple of nits below (not entirely sure if they make sense).
But otherwise looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

> diff --git a/include/linux/blk_plug.h b/include/linux/blk_plug.h
> new file mode 100644
> index 000000000000..2ac1265662ad
> --- /dev/null
> +++ b/include/linux/blk_plug.h
> @@ -0,0 +1,95 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_BLK_PLUG_H
> +#define _LINUX_BLK_PLUG_H
> +
> +#include <linux/sched.h>

struct blk_plug_cb has a list_head. So maybe also add

#include <linux/types.h>

?

> +
> +struct blk_plug_cb;

Maybe add "struct request;" here too ?

> +typedef void (*blk_plug_cb_fn)(struct blk_plug_cb *cb, bool from_schedule);
> +
> +struct rq_list {
> +	struct request *head;
> +	struct request *tail;
> +};


-- 
Damien Le Moal
Western Digital Research

