Return-Path: <io-uring+bounces-12539-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMUGAcM9pmkZNAAAu9opvQ
	(envelope-from <io-uring+bounces-12539-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 02:47:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 865AD1E7D01
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 02:47:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31FC2306145D
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 01:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 874BB346ADE;
	Tue,  3 Mar 2026 01:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uD3/L+qm"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B82632AADC;
	Tue,  3 Mar 2026 01:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772502458; cv=none; b=jKrtaI9M7n7N5rpzw+SgIyMIi0WO7JXNlfBdRANoSFXRGyJC23FvBBBAzLH2/n219lK3bU88TBD2iWd7dzr+6LunN/F5oevFqyVKYlwzSqi/VqK4/4eVhTMn4WAN4T41n04LCKl9Tf5QqoL9xVoIAtTQoAJA/oWsrhpRflCZ1uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772502458; c=relaxed/simple;
	bh=rPiQldf/P55Jpx9fo5UWgVUBvUEWhrAB1IS9i7ViqGo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g9VZhZlcIhrucFaJlUdlEZQz5zEkPzkGQv9DMxB4EyfS9DswOiMQH5L2QJCCEFJda8gcafjChAbeL3nrUyzZkhbvSPv7ms4ZVq31QT14cu7MXPAN9u8d54uCtiNH7lj2oalKZ3jhceZwngu7lbcb+PNdX5oNyx5IjtXCLExoh1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uD3/L+qm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9161AC19423;
	Tue,  3 Mar 2026 01:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772502458;
	bh=rPiQldf/P55Jpx9fo5UWgVUBvUEWhrAB1IS9i7ViqGo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uD3/L+qmibpXO0s6YbUSog8kpB/dsMVz3x/f8okc2FeIVouHG0MhJp6xvoR1lBkJ6
	 75/uvRsog835BrfrrBVjCywwjCbHt9iw+zKpDFvxPC+yLISocP6jwwgigFKaqyKbmZ
	 59umsihifS+Gkf4Xi6vqFEeJJMVOl7ZY+XWGt/BI=
Date: Mon, 2 Mar 2026 20:47:26 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, netdev@vger.kernel.org,
	stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 1/1] io_uring/zcrx: fix post open error handling
Message-ID: <2026030215-appetite-drastic-5894@gregkh>
References: <ae4f2296e2c33bb65ef2a1487b120033879e493f.1772489730.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae4f2296e2c33bb65ef2a1487b120033879e493f.1772489730.git.asml.silence@gmail.com>
X-Rspamd-Queue-Id: 865AD1E7D01
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [3.84 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12539-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.149];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Action: no action

On Mon, Mar 02, 2026 at 10:15:43PM +0000, Pavel Begunkov wrote:
> [ upstream commit 5d540e4508950c674d6feef1d95463d039bbf4f5 ]
> 
> 5d540e4508950 ("io_uring/zcrx: fix post open error handling") fixes some
> post queue open problems. Instead of picking all dependencies for that
> patch just move post open error handling out of the way, so once a queue
> is open we can always report a success.
> 
> Move copy_to_user earlier before open,  and xa_store() should already
> never fail as the slot is explicitly pre-allocated.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/zcrx.c | 20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

What stable kernel(s) is this for?

thanks,

greg k-h

