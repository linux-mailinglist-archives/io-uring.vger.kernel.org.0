Return-Path: <io-uring+bounces-13040-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8MU/I9xq3mmxDgAAu9opvQ
	(envelope-from <io-uring+bounces-13040-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 18:27:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 078A23FC8E8
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 18:27:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3962830263E4
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 16:21:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4BCA3ED5A3;
	Tue, 14 Apr 2026 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFXn9FgC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826933ED13D;
	Tue, 14 Apr 2026 16:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183683; cv=none; b=lxJdmIjsWRZIukv6u5fYuco2ruMNd6jFfRvTVDYD0lIOh2cIOJBRxjXG4lPuhMTAAcxCh1xBLO8nIlKSrk7/l9ifCtLoTBvkxVNvuebFkmjkJ3Inr3NwmelAXLIOaFEyd8qUsswxREbPUHtbOxkBFnM74rOZO+3EnYk1w5KTpog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183683; c=relaxed/simple;
	bh=2efHYGh3KXkJMimijL2p4ikWc+jQGUzH8zxjA3ZDoxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPZUXxYWw6jddD3xs9y60uvYC2PQ677vwT836iSfxb+x1ZK3RLJY+Asp4fb7bWqndPB4iKNGkvBuZx6VzdIaAMY4rtUqCYcfaPwS1tFmelBkl3+wwTbh+bXC840jU+oUVUkSHCnau/g0sVVzt0NEDaBIGRuhMdua/c+180QdR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFXn9FgC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA169C2BCB3;
	Tue, 14 Apr 2026 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776183683;
	bh=2efHYGh3KXkJMimijL2p4ikWc+jQGUzH8zxjA3ZDoxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MFXn9FgCUqzJiKtooOnPT+9GY3qulHm0bIjqvP8aclWd35vqYaD882zMvlSakPWhr
	 G8WhSrEJ2Jwgo4mcmq/6/dWFdxRN56M5K8cVswZxvHkDmnRbT3uIWtpxtwRHQEZK/n
	 8p8snxfNdZsdDRdLpHJ6PwMQXTFDScNl4nL6s7M0=
Date: Tue, 14 Apr 2026 18:20:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Rust io_uring command abstraction for miscdevice
Message-ID: <2026041407-tubular-unhealthy-2a7f@gregkh>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
 <2026040925-taunt-exit-0cb9@gregkh>
 <ado7p6jV6aapelBU@sidong>
 <2026041153-scope-five-fd24@gregkh>
 <ad5e5cAmtL8GRo-s@sidongui-MacBookPro.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad5e5cAmtL8GRo-s@sidongui-MacBookPro.local>
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13040-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linuxfoundation.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 078A23FC8E8
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 15, 2026 at 12:36:05AM +0900, Sidong Yang wrote:
> > Yes, it must use the accel subsystem as that is the correct api for it.
> 
> Thanks for the clarification.
> 
> I will proceed with this uring_cmd Rust abstraction patch as is. Moving 
> forward with our AI accelerator driver, I will look into implementing it 
> using the accel subsystem and work on creating the necessary Rust 
> abstractions for it.

Great.

> Since I am planning to adopt the accel subsystem, could you share some 
> insights on the main benefits it provides for AI accelerators, or point me 
> to any future roadmap/plans for the subsystem? This would be very helpful 
> for my design and implementation.

It is the common api for all accelerator drivers that you must use if
you wish to have a Linux driver for this type of hardware.  There should
be documentation in the kernel subsystem to read, and of course, there
are existing drivers using the api already.  If you have specific
questions about the api, please ask on that mailing list.

thanks,

greg k-h

