Return-Path: <io-uring+bounces-13723-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 4/HBBp/vLWoYnAQAu9opvQ
	(envelope-from <io-uring+bounces-13723-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2026 02:02:39 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 780EF68014E
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2026 02:02:38 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Q8+/FBqh";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13723-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13723-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6B2DC3011C7B
	for <lists+io-uring@lfdr.de>; Sun, 14 Jun 2026 00:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E082BEC52;
	Sun, 14 Jun 2026 00:02:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319B821CC71;
	Sun, 14 Jun 2026 00:02:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781395355; cv=none; b=mW/7ddtfHSX94cIjSai/resQkJH6kzPoYadbDn2ICwcPBNflLBu0L81YGpQoR56VNp/yFGk+gt7izv+JyenG1PFvrg5WOVMwQ/y48cKt/ccKKOUgCDOkIbyamehE324rZcRI/CLKDF2AMiLky1DiUwTxdcUJLwF+cmi7eKjiJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781395355; c=relaxed/simple;
	bh=rvVzlOQ6y6wSQB0yE2XlFDy53K5ZdAVMXYRAJlb0Kvw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oZgW439sX0ts39R084xwDuZBs4Sfk03xmD187AgAunDwBSkymMS0/n4lABb3ufieGzQemqqqjIevfXNrXgaQw/wASBtWz7Sf6PTnKkZz28jDn0g8EXa9hjjEHkGWySz6ND46hp2iOaCnU+UNCau+S9jPyEIwxcTeP1m0+iF4zmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q8+/FBqh; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28741F000E9;
	Sun, 14 Jun 2026 00:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781395353;
	bh=4Yx3FPQz4iDZ2/ZoynPnkhrf+W8Z+yA2zAeY5Q1zQ0Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Q8+/FBqhnX7OmwVOyQzDIpOHoxepynz4tqpCn2VDn2Ei2HDLsKntXF7X0tTgNotI0
	 KdxxF8J5i/4FbHl3G4T+SVZuwjwEkcguBd3QIZuENPdeGemfuairBKQxxQ+Z2Cu/Ze
	 2gvx6x3/mCEk9oVmvetWeMMb77ZGle2gzSzhTY2s40jKYU8GcX9RqOUOCr3BqVu9Pu
	 GB3jRaqEkWkBW/Hiwz4iSKXibj5Qo/u7WUhyBTkijkVt1oTife4wvsoT65vjOsZdd8
	 mwW04iZdD0/Z0pxKPBuG/t846ke2Fn2iJz7AEMblW78Ado0/lTJCm0225F/BpQ+SVm
	 +Dc83xwlRqyAQ==
Date: Sat, 13 Jun 2026 17:02:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Donald Hunter
 <donald.hunter@gmail.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe
 <axboe@kernel.dk>, Yael Chemla <ychemla@nvidia.com>, Tariq Toukan
 <tariqt@nvidia.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/2] netdev: expose io_uring rx_page_order
 order via netlink
Message-ID: <20260613170232.6f9e72ba@kernel.org>
In-Reply-To: <b581d253-135b-4c75-a50d-2049c6d6e249@nvidia.com>
References: <20260612211709.1456966-2-dtatulea@nvidia.com>
	<20260612211709.1456966-3-dtatulea@nvidia.com>
	<d0401fab-61c5-43e7-93ae-d4757433eb7a@gmail.com>
	<b581d253-135b-4c75-a50d-2049c6d6e249@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13723-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[14];
	FORGED_RECIPIENTS(0.00)[m:dtatulea@nvidia.com,m:asml.silence@gmail.com,m:donald.hunter@gmail.com,m:davem@davemloft.net,m:edumazet@google.com,m:pabeni@redhat.com,m:horms@kernel.org,m:andrew+netdev@lunn.ch,m:axboe@kernel.dk,m:ychemla@nvidia.com,m:tariqt@nvidia.com,m:netdev@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:io-uring@vger.kernel.org,m:asmlsilence@gmail.com,m:donaldhunter@gmail.com,m:andrew@lunn.ch,s:lists@lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,davemloft.net,google.com,redhat.com,kernel.org,lunn.ch,kernel.dk,nvidia.com,vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 780EF68014E

On Sat, 13 Jun 2026 16:09:03 +0200 Dragos Tatulea wrote:
> On 13.06.26 11:53, Pavel Begunkov wrote:
> > On 6/12/26 22:17, Dragos Tatulea wrote:  
> >> This adds observability for the io_uring zcrx rx-buf-len configuration.  
> > 
> > It might be nicer to look it up in the queue, e.g. rxq->mp_params,
> > and make it a queue attribute instead of zcrx specific one. In either
> > case, no objections.
>   
> In io_pp_nl_fill() or in page_pool_nl_fill() as it was done in v1 for order?

It's fine. We decided to make the "page size" a memory provider
property, now we're going back to making it a queue level param? 
Like my RFC had that everyone hated so much? Sigh.

