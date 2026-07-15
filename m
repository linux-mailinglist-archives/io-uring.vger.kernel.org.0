Return-Path: <io-uring+bounces-14024-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Wp5LChJHV2oNIgEAu9opvQ
	(envelope-from <io-uring+bounces-14024-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:38:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C4D475BF49
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 10:38:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ccvd/hKS";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14024-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14024-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2D58E301E5A0
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:36:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E1935F5F7;
	Wed, 15 Jul 2026 08:36:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42FF2E7365
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 08:36:01 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784104562; cv=none; b=Yxy653zxo1fSwXr4v/ezSVy+EptIAKEtogfqKe010vk5kx5X5/V7mBqJnCK9GSN0BZItGURgnZPc0LMM5TGJYjkCT9pcDkYU+GBKDnlHR6VyS3EGtRPZ8dB0Pk1uSbxDgYgMn/Ttlzxbag1sGWbjbiVzLl5GZAnT6wP3ZXuFATg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784104562; c=relaxed/simple;
	bh=X0bdRifszlb1SQOcJyoKRKcVsSZSgo+mLpRxApm/P0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IqILD9ahDMsBj7jsd2wkPWc9skrvl6RFtzO8ErK5gPlCooqupg95RuvTO3RML7VPhtJlD+8E+A3/F2qulfNhr7RJutQq11Ot8TjNmk8AsOfrW7sBEsUKqVRc2TyVib7g4E49PDbqdG3bf6zo1zuVWH3cxwHL5BreEB3Oi5Lt9Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ccvd/hKS; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C36A11F000E9;
	Wed, 15 Jul 2026 08:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784104561;
	bh=qieoT50Kw+1a5v8h+kvCJyp6ZYWVaJc9zHU4wIkUXyk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ccvd/hKS/ZIdyn0/AEUo14Iw4zC+c2BThNWXpTf5/IgRjPgD07pvj+gcIwQ3Yz81Y
	 Q7lx/FxbNXtdGRKu919tW8koTobcgmzfTTe/hRcJc2G2h7QDZ+IAVTKUoRcTHA7Kbl
	 w4rcupjMcDR+qSQynS9Fi5RgSr5mIVyEqfxByep8TiKxsbwV18Koa8Vp8s5kGB4mfq
	 /UU5BEZHcaXkUCSXwnr5XyUfxN6zUAf9oAKrf1mQ7dH4lCDjtFN+aPYgylxjlBnS4R
	 OwQYclgyofxOAlzNUmwaCoHnhU1asCamDn0oRW0fY5XmC52Fg36L37B/h6NM1WrI+I
	 B+TjgENBoy76g==
Message-ID: <c365a2a0-a438-4660-9a98-ad011d8e1226@kernel.org>
Date: Wed, 15 Jul 2026 17:35:49 +0900
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] test: add zone_reset_all command test
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
References: <20260715063947.2933606-1-hch@lst.de>
 <20260715063947.2933606-6-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260715063947.2933606-6-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14024-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:hch@lst.de,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:email,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9C4D475BF49

On 7/15/26 15:39, Christoph Hellwig wrote:
> Basic sanity checking for the simply zone_reset_all command, mostly

s/simply/simple

> taken from the discard test.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

