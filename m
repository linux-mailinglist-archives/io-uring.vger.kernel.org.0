Return-Path: <io-uring+bounces-13799-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id egDRCM0wNmrP8QYAu9opvQ
	(envelope-from <io-uring+bounces-13799-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 08:18:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 766096A8672
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 08:18:52 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=FeuMnn0+;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13799-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13799-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2FB103017F89
	for <lists+io-uring@lfdr.de>; Sat, 20 Jun 2026 06:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F932D837C;
	Sat, 20 Jun 2026 06:18:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0EA1FD4;
	Sat, 20 Jun 2026 06:18:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781936330; cv=none; b=XiwMgtt9YiPqIEhLQcm2t1YcLM4DZK7v0SFwrrFe7lJHLkPlZRV30K4FMXHf5c16n75IZ7MeRjAuvyHrPtaILKjCTeTdofr6aNoeajEXsEmweFsfnKcnpxNdxgZsVs9QZCCqw5pB5u/2hdNI/0oJyQ+rasCctuhGkC4XiOTFmfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781936330; c=relaxed/simple;
	bh=kylUD85bOB3AytvtTIgoRmK+DXXegBLV4oF2wi1Gvps=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LImz+/FyqbmYlvZtlPrcL/xcmPZpmBWNlercXFbXDX/zmRoE+dK5zxVVyWuYyeU+vQxFhTl3xJnuw2JJL6gLjrgoq8fNDeCULixtmWxoKaV4RFh7mHDaCgBcY1MSpkSMleu8UGLXnLjn0jcYRwPgWWtCw+zJ0dfFm5eGT62EzK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FeuMnn0+; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0F61F000E9;
	Sat, 20 Jun 2026 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781936328;
	bh=XEVEwJ77VrkaAd7fWqJ7+Adkr7k+4XILTOZZf13gnuQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FeuMnn0+C9MQtp63XBqUFiUG3owRKnA3HDsuON7KiS5H2MAFqCjkX2OXhc9BSCqOe
	 cTwbcQ4DoSoVNsDkYUrP54sohsuoas/GLiwn8i75dXyJ4TH6+iok7DoC5SmkeYfwZt
	 fMDklnYsuF9ErV5iW+jc2gNZZUnGcyJqVhSgkpRk=
Date: Sat, 20 Jun 2026 08:17:41 +0200
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Cyber_black <Cyberblackk@proton.me>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"gabriel@krisman.be" <gabriel@krisman.be>
Subject: Re: [BUG] io_uring: possible CQE32 overflow flush inconsistency in
 __io_cqring_overflow_flush()
Message-ID: <2026062012-iphone-chasing-61e7@gregkh>
References: <Zurr63tEcYPbtU0ltI3-1KdtzFeys4ybMi-njjblykGD6LnMs7gYFwRzZNw3AbjYglMSO8LESxjUPHLnV2-AXHNa_17pDLHe9eCKTXBozLE=@proton.me>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zurr63tEcYPbtU0ltI3-1KdtzFeys4ybMi-njjblykGD6LnMs7gYFwRzZNw3AbjYglMSO8LESxjUPHLnV2-AXHNa_17pDLHe9eCKTXBozLE=@proton.me>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [3.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	FROM_DN_EQ_ADDR(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:Cyberblackk@proton.me,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,m:gabriel@krisman.be,s:lists@lfdr.de];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-13799-lists,io-uring=lfdr.de];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,gregkh:mid,linuxfoundation.org:dkim,linuxfoundation.org:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 766096A8672

On Sat, Jun 20, 2026 at 06:13:50AM +0000, Cyber_black wrote:
> 
> 
> Hi Gabriel,
> 
> Thank you for your response.
> 
> I found this bug while doing independent research. I was reading the Linux kernel code from Linus Torvalds' main repository (git.kernel.org) and the io_uring subsystem caught my attention. In particular, the use of shared memory for optimization purposes stood out – especially since this very feature has been exploited in the past to develop rootkits targeting io_uring.
> 
> So I first studied its architecture and then read the code in depth. The bug emerged during that review.
> 
> Regarding a trigger scenario (PoC – Proof of Concept): unfortunately, I don't have one. My system does not support io_uring (it returns ENOSYS, likely due to enterprise compatibility settings), so I couldn't run the liburing test suite. However, the fix itself is straightforward and the logic is clear.

That's not how any of this works, please always test your changes.  If
you can't even build/boot them, don't expect others to do it for you.

thanks,

greg k-h

