Return-Path: <io-uring+bounces-13204-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mLXaNrKZ9Wm1MwIAu9opvQ
	(envelope-from <io-uring+bounces-13204-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 08:29:06 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 588C74B126B
	for <lists+io-uring@lfdr.de>; Sat, 02 May 2026 08:29:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 908593021E41
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2026 06:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D79F929B8D3;
	Sat,  2 May 2026 06:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0I8euiUW"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B561D26AA91;
	Sat,  2 May 2026 06:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777703343; cv=none; b=iJc5UQXZmFGMaFKfuPBzBn0DKpTz9ED2numpK5f5HsklLxr2CVhNeEt5rdLd+d1E8/BSwQrYxbxgit6SZmdiPH+Qn46Jt+o8H/ODf45FD38rj/I2CTxmYnS+TBgU7AwuSUNd8lwHvBVXh2XFdIO1CMdMaW0Nz0O2tUgs0Vy2EII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777703343; c=relaxed/simple;
	bh=jGpgR4Gr6eK9YuFNs2Qeifk1JrmrHDn0VAu1pt7fTzI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u35f/fOoOVL+ZLwhKJpFRUPNHYIoC6bS/bNJZrBAfKC0VuzQl7PrYmm//BCg/VTdq+W8OCwvQmK27+h1CXAindeQ5hu2CXWfmmaavGamMyPB+F/GIsUR2khpFLUHKZKTkGHWMcx3VwFXet/y95LG1keav2suNqTgvjnsEgbIBFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0I8euiUW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E441C19425;
	Sat,  2 May 2026 06:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777703343;
	bh=jGpgR4Gr6eK9YuFNs2Qeifk1JrmrHDn0VAu1pt7fTzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0I8euiUWAM+i1GvfYqwFFFIz+Gwx15ICXGI5XMPaJex05d//TpciUOOpADYjb+Y8x
	 mq+A1hGocc4lBqL51hv6g2P+l/pWCqEiChXc5/DXLITSMGnFTq1iRsiVflQ5dXeZ0T
	 mry2zX7Il9YrEdJ2wz88VoBACcSqH5LHkBCGnupA=
Date: Sat, 2 May 2026 08:29:00 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Kai Aizen <kai.aizen.dev@gmail.com>, stable@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: Re: [PATCH 6.12.y] io_uring/poll: fix multishot recv missing EOF on
 wakeup race
Message-ID: <2026050246-estimator-hurry-3df6@gregkh>
References: <20260501225250.90152-1-kai.aizen.dev@gmail.com>
 <3fcf1bf1-23fb-4e01-ac3d-6ec6fb86da08@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fcf1bf1-23fb-4e01-ac3d-6ec6fb86da08@kernel.dk>
X-Rspamd-Queue-Id: 588C74B126B
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13204-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linuxfoundation.org:dkim]

On Fri, May 01, 2026 at 04:55:54PM -0600, Jens Axboe wrote:
> First of all, I'm fine backporting these. But:
> 
> > CVE: CVE-2026-23473
> 
> How on earth is this a CVE?! That's bogus. Yes it violates application
> expectations, it'll wait on a CQE it won't get, potentially. But this is
> the only side effect. That is NOT a CVE. Greg, please retract that.

The CVE is now rejected.

thanks,

greg k-h

