Return-Path: <io-uring+bounces-13919-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /BbdH0lTTmoEKwIAu9opvQ
	(envelope-from <io-uring+bounces-13919-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 15:40:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 960BE726E1B
	for <lists+io-uring@lfdr.de>; Wed, 08 Jul 2026 15:40:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpDPSxtX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13919-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13919-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DDB36305A5F5
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2026 13:35:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91C5237D100;
	Wed,  8 Jul 2026 13:35:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183837BE8A;
	Wed,  8 Jul 2026 13:35:03 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783517705; cv=none; b=asNu0KMfx8Sv070M4iqkYh1utS9jUUhoKCu+zRS9chiDAp75DKbjFJ8t3PVycgrBppKFVwhEnuU9ybJg3KlK649cRg7yWtktewvNRFhln+H5u8jrs31oEDme6haP2m6hTqz3K+aBTtdCedE2Ey5C4Tntk4oUx6kPAXYpiklXQww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783517705; c=relaxed/simple;
	bh=TWNID/pAUI28h+lJfkz81BmjBgoYqq3Sueuw1+zXfok=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LJaPf0H1CIbtWplag4uxa0KWwB4pryUOlCdoc2VBKu63ZrYXm19oN1PqDhy0sTp9kZMRqf8GQZ6U9dsyvv0FFWQkgIcnnPlQplu1nR1UN3fzz+iKF68Vjs+V0wierf04HpqknSBvJjN59iSbUu0TViaRNm/pG+If/ARHUlpJ+NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YpDPSxtX; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41561F000E9;
	Wed,  8 Jul 2026 13:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783517702;
	bh=TWNID/pAUI28h+lJfkz81BmjBgoYqq3Sueuw1+zXfok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YpDPSxtXbaYcgl0wx8l/vdYvVWGs8eXfTpCO1uV7EbOuEygouyQ+w7xA5N+xuaPwt
	 CEQNepACypCpDFJL5LN48DfQqFpgSe/D++3awZ3Wnszlz5DLle8/mh69t4FaY8bR8F
	 CMZDR6qqARd4HWN7mYzkKLOMUzsgKGwFb8hYnrK9R6JSdnMdRpSL9fzRfJJMCJr7Wa
	 Pr1GCs0SOphhdrLwcoffICSGh/llbuiZzOjC2fHWRWulzTzXCQDIMz+EnCSKjecFZ/
	 gYytgvYqRdPzCCdEDSZy2YVjWVq7VKvJl0q+6V7gCybrFjKVxVB5YRn9FIl9pWzPpe
	 JP+6pijzbwgZg==
Date: Wed, 8 Jul 2026 07:35:00 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ben Carey <benjamin.james.carey3@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <ak5SBF1kDsgrGJiS@kbusch-mbp>
References: <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
 <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <94614dd9-9351-4a64-83dc-4fc87e377e59@kernel.dk>
 <aj6tTiAB2NIol9Tf@kbusch-mbp>
 <CA+KFGSoyCSRzgamm-38oyAtEsqd7wZZ8awL79P40x7a819EK4w@mail.gmail.com>
 <CA+KFGSoZXejMvA5WNBSy=TVxiEiJs1-bxHXkewk8HtCR5m8sEw@mail.gmail.com>
 <akk8Xhyntk9_weMp@kbusch-mbp>
 <CA+KFGSoGVBzsnhht5Opo2PCf33M0uiLjK7BNQ-t2DjTDudwXrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+KFGSoGVBzsnhht5Opo2PCf33M0uiLjK7BNQ-t2DjTDudwXrw@mail.gmail.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13919-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:benjamin.james.carey3@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 960BE726E1B

On Sat, Jul 04, 2026 at 03:35:14PM -0400, Ben Carey wrote:
> I'm most definitely not qualified to suggest this as a passable alternative,
> but when polling a tagset, is there a way to check if the tagset's been
> completed by another thread? Maybe break out if, for each polled request,
> request->state == MQ_RQ_COMPLETE? I'm unsure how to translate the parameters in
> blk_hctx_poll into the set of requests being waited on.

The overhead to track individual requests this way would largely negate
any benefit to polling. A request could be reallocated and dispatched
before the polling loop sees that it's complete, so at the very least
you'd have to hold an extra reference on every request you are polling
for to prevent that before you can check their status.

