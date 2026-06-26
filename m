Return-Path: <io-uring+bounces-13848-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id V1BvOHiuPmq6KAkAu9opvQ
	(envelope-from <io-uring+bounces-13848-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:53:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 682BB6CF47B
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:53:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYowIE3z;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13848-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13848-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF0E330DAF87
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 16:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644C23FDC0E;
	Fri, 26 Jun 2026 16:48:17 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBF13FD97F;
	Fri, 26 Jun 2026 16:48:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782492497; cv=none; b=uar6rG1nT1YeHU9xEFEtoXMRtvAsDirmZuBX7Pbum9pdBIvKkX7227DbcqyVuKg9a0jap1PLc6VRrKlk51ZE+l/ZqLezaCpp02i+YryDixdkmeqBvcNyeYNYKA63SkUbB+TkXxAVGynbYDUt9L2jJ5pMw4j4HJCDcxiBHLNwGiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782492497; c=relaxed/simple;
	bh=kqQMX6p3gJpYDPPFZfaz8dPPveqaEbDjfZXNWLRlQcY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g5mbvyS77EIUcHQQ1rbz1dsd30S5kbQax4esCHMvdLs2PhWlc9QzVltuiE8ip+iQaJFEKo6Sx7UAS8BhFxelA2NBdgF1Te86uesnwugcZ9wQBxgx0Q0YOOHkqBfwlzhQXGOK9ZRj/bLZKc12sAettjNCvQ3O9ccLt95hJaP4tDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYowIE3z; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A641F00A3A;
	Fri, 26 Jun 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782492496;
	bh=EIOfnmKRgcg6/WVpNErw/tAuPn49TBDB0Zgm+aiIDZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LYowIE3zHT65L3yx3Wg2Pc7tsrzHl7od8rIs8P9cvnyDXkw4WhgZZ8YhcZtapHXGY
	 4JLhh5/0WJRN5DtO/UKN5a2+adfmba/2ZJkpRkwrBOSNmywdWOrC7W+k/xq/xZk0L5
	 iRRHpYSROQbbdVdgOyGIV1TVvr45ULmRZXNIK/CYR2D5+4S1rljN7gm3XSHH3+qNTY
	 Ov8Vlg/Zb11GgadP/u2OYKz1ZzrLytcMh6AVihJCijIRFyOe6W624F4sibuA/kJWYQ
	 enJWj8qXdBBGaUUTIXA+qZMoZPflRq07uM37TkBGAJa02M/JNM5Ob82l113r3UaHkk
	 CJaqKm75Z18RQ==
Date: Fri, 26 Jun 2026 10:48:14 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Carey <benjamin.james.carey3@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <aj6tTiAB2NIol9Tf@kbusch-mbp>
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
 <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13848-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:benjamin.james.carey3@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kbusch-mbp:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 682BB6CF47B

On Fri, Jun 26, 2026 at 10:35:56AM -0600, Jens Axboe wrote:
> Yes, it's a bad configuration. I bet it's as simple as:
> 
> https://lore.kernel.org/linux-block/20260617155051.1266079-1-anuj20.g@samsung.com/

Yep, that's definitely the same problem. Thanks, I hadn't seen that
thread yet.

