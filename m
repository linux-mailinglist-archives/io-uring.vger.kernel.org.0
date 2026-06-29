Return-Path: <io-uring+bounces-13851-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id DOHIHWvmQmrIHQoAu9opvQ
	(envelope-from <io-uring+bounces-13851-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 23:40:59 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D24086DEECD
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 23:40:58 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SLv7/826";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13851-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13851-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D889D30082A5
	for <lists+io-uring@lfdr.de>; Mon, 29 Jun 2026 21:40:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF9E3C9EF1;
	Mon, 29 Jun 2026 21:40:55 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0933AE1A9;
	Mon, 29 Jun 2026 21:40:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782769255; cv=none; b=VkNhDk5lkDAHMihZLWtzquQX/pyDHdX0MHCePvErXoTeZFWzL5fM+YZIpgka5drGoywMS+3Xw0hLNE/yLNhsEhwTWzXJzrB0Z1xFCCDNUFWtw49anZTxDreyxY6vqiZQhsRoN5I5bV0+VDUGv1m0C7vInWqpS0nKosZlVPNeTmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782769255; c=relaxed/simple;
	bh=vzicXXrJSPXiS4D/WKDlK/lA9JwEZUNzDa1U2k4ni0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GtYml3gBX4PK0HXdRxDRgts7lQR3Pq3gvRpRib0yMtrl9+lQzeE0WV7bm3/KXD+qpzLrVGcUrnczhn/4BR3EPL5NONVG6OVrPKOZUITiBxbKDNwvnyzf2dy0UbtRSCWn/iqgvAYqcrO5uhn1VkrZZIAJVKYMCs/u7kmVcWDpLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLv7/826; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 823931F000E9;
	Mon, 29 Jun 2026 21:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782769253;
	bh=B98D87J1HBCiSWxlBRkpaMN6R2sp4yJTzba5LwiqO2U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SLv7/826+gBlk4n/lNgYrqfcNJiFqH3LDVeXLRcLcose4Gfr/o6/8y9fVagCCBvwD
	 t3EDZGE+C/UaE56XBT7BEErsRU4GgKn6th/u2NXFlZcHQva92u+igMUWhNrGrRCMVS
	 zvk0bGmdFOOKEaRCKUBhkKUfLcmJm3YWS+BZbnqe592GlsYPUYvjg1oRASC4TqDOqk
	 uq2G9pe9bvgMxZDbwbUJcnmO478tn6s2tUM643TvOxz0b1nCq4lyUCcaNZZ165eevO
	 SaDEq7Pu94YgHRkcc8SCkVU8U9V+btsJcHxm1KUfbw/b8KNN5dtJjUvvuAnF0lIH3O
	 RSUFX1gpp4tmw==
Date: Mon, 29 Jun 2026 15:40:52 -0600
From: Keith Busch <kbusch@kernel.org>
To: Ben Carey <benjamin.james.carey3@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] RCU hang with io_uring nvme polling
Message-ID: <akLmZDexipAtsex_@kbusch-mbp>
References: <20260626150946.287781-1-benjamin.james.carey3@gmail.com>
 <85d1f999-7778-4c74-9d72-b8ac8500de31@kernel.dk>
 <aj6jQyJd3zmZFcwx@kbusch-mbp>
 <1932a509-4e27-485e-8e09-1da67e0082c8@kernel.dk>
 <aj6p3kZy1a8Mf68S@kbusch-mbp>
 <CA+KFGSpgN7DChCfMK4itc39MB9ubxacbY3sWTByOkG58umvPkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+KFGSpgN7DChCfMK4itc39MB9ubxacbY3sWTByOkG58umvPkQ@mail.gmail.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-4.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:benjamin.james.carey3@gmail.com,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:benjaminjamescarey3@gmail.com,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13851-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kbusch@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D24086DEECD

On Mon, Jun 29, 2026 at 04:47:00PM -0400, Ben Carey wrote:
> On Fri, Jun 26, 2026 at 12:33 PM Keith Busch <kbusch@kernel.org> wrote:
> > The test has 1 polling queue with 2 jobs dispatching. One of the job's
> > polled the completions for both. The other job is polling for no reason
> > at all with nothing outstanding. The only thing that can break us out of
> > that loop now is need_resched(), but that appears to never return true.
> 
> Inspired by this I tried to find a place where one thread polls on a job that's
> already finished. I found that a race to io_check_iopoll causes one thread to
> enter the polling loop when another has already finished on it. Putting
> io_check_iopoll behind a spinlock seems to fix it, though I imagine a more
> elegant fix is out there (reusing a different lock, not using expensive locks,
> a smarter place to check for racing, etc.)

I can see why that resolves your observation, but I don't think we can
do this. We're ultimately polling for a hardware event, and this layer
is too high a level for serializing these things. This could be a
multi-device or multi-queue backing storage where the completion
pollings should occur concurrently.

