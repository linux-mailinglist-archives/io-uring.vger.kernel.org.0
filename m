Return-Path: <io-uring+bounces-13846-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id SMO+AumqPmrzJwkAu9opvQ
	(envelope-from <io-uring+bounces-13846-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:38:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DD86CF2BA
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 18:37:59 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A/U+LTET";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13846-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c15:e001:75::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13846-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 38D003050889
	for <lists+io-uring@lfdr.de>; Fri, 26 Jun 2026 16:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DBF23FD122;
	Fri, 26 Jun 2026 16:33:37 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160D03E0090;
	Fri, 26 Jun 2026 16:33:35 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782491616; cv=none; b=NOm0kHcYqNgngUZ2iR+acT1q3C/hU5v7MvqChA6aOn09HYNGTJXYvhetktzXVh1aF58SNDyFLFdUfhPNuZgAd0X1T3c9YyT3KtvUw7A7XTJQxQAFW6OSQMH9pBw4XMaKKx2z3F/tIhehKLz908WBWD3QNB/cnJnl5GBdB3tLGUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782491616; c=relaxed/simple;
	bh=Rhk02k9ingT/8ZPe7PqoOtst9gmLDAdkIVxuJ7zYApU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=odUntyqY2CEJMJAqIRRwvV6uhayqnlS9qZBc9M9Au8dcfLMgImUWlHgF5fCFgH2iuKIUOO+2wow4pzhuzlK+KCMMdpFFIPoQU1tm0JbfImgzQBv8BeDQAn9CzVYlDGKLD6Uz/Dyigsc7TTJbMu6RTcTjILpXHwKsxhskf42xXW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/U+LTET; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 906751F000E9;
	Fri, 26 Jun 2026 16:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782491615;
	bh=Rhk02k9ingT/8ZPe7PqoOtst9gmLDAdkIVxuJ7zYApU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A/U+LTETByNZCPLI1FoWzSLxwgOEkUgaznxQcC/328OSbGGHcvSdsy5vO0PUIr/1Z
	 a8a4kP5HOcRo9Sk7Hqne3qpTRMry2Ge/s0WJpeI+adVormZqOInE/zEd+6WV4bziCD
	 7HIhWaTWzIrms3HnPnyyzwAlrrfy2iKTeIE/BMy4l95U6fYoShj+Dj9ZpFgZNu5SAr
	 l2qxWdr6xwSDnQN/YixAxavyiWyAp9xT2VrEBP2CKpxpxD6x//So7USrz76Vf2l9EN
	 EBdGo6yDbfh2ofmOaFXOr7WQYsaoKGSmvvh91nZNhoT1Xat9d9mYRPxbphAZzOFp2m
	 rYdUztwq4ZHBw==
Date: Fri, 26 Jun 2026 10:33:34 -0600
From: Keith Busch <kbusch@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ben Carey <benjamin.james.carey3@gmail.com>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <aj6p3kZy1a8Mf68S@kbusch-mbp>
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13846-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:benjamin.james.carey3@gmail.com,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: E8DD86CF2BA

On Fri, Jun 26, 2026 at 10:06:49AM -0600, Jens Axboe wrote:
> Ah good catch, I missed that. Should've grepped! In general, IO should
> either get polled, or if the device is misbehaving, then timeouts will
> catch it. That said, haven't looked at the actual report yet, will do
> so next week (unless you beat me to it...?)

I'll give it a shot!

The test has 1 polling queue with 2 jobs dispatching. One of the job's
polled the completions for both. The other job is polling for no reason
at all with nothing outstanding. The only thing that can break us out of
that loop now is need_resched(), but that appears to never return true.

