Return-Path: <io-uring+bounces-13789-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ahz4C6b1NGpJlQYAu9opvQ
	(envelope-from <io-uring+bounces-13789-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:54:14 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8066A476B
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 09:54:13 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=TQ4S5mHc;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13789-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13789-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 18CF430258A7
	for <lists+io-uring@lfdr.de>; Fri, 19 Jun 2026 07:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316CE34BA5B;
	Fri, 19 Jun 2026 07:54:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C38F31D72E;
	Fri, 19 Jun 2026 07:54:07 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781855649; cv=none; b=E+Ejx8wcekV4qbsidWhD9oSvbgIG3xaChX9P9Fsc0KmMoHcZdad5zFSGeYrGL703px6L0gYHEZLgEKvMy7UspJk6h5S9CHpzHO0wuUJ04Li6i5KMoM8I7Cd+b8GXOQs5zi6KcGK0SdWmYSHwtIkCwz+wtBV8lCIFqHR/uoEMKWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781855649; c=relaxed/simple;
	bh=cic008nchqfePkKs+9HGfH+Kq2FejY0fk6t9N1Aq1mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C5PXq6A0mI1e6HnVhXw5JTidTRAzc3uCXd3opbipGThSGrkZTLrS+4qS54te4jiW+ShOaUBPVPypktEuujYbyyAErSuvLeuLVGdQTihCoRKX93owb0MXKCdavFXUX0Jl9NPeUFfXHzZWPUaTy49O49RfHcydyoTq0VQuvhpIyGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQ4S5mHc; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDDE1F000E9;
	Fri, 19 Jun 2026 07:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781855647;
	bh=4birVxbL6Yq9uQlayRAbpjhzQsCGT4XJlcHlr9qxOqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TQ4S5mHcKx8jKmUEgtgTvRs/1lAXK+LY9oMoZurn8t7Z/L5bj5zQtbEBUAh1uM162
	 URhP1b2gdmrF8QWV/+qboFTHuyqXxP0xSj5FHhRSI7deX/OoUn/m8F4Ithu1yJ5kE+
	 E98OAgnZnbQw5LUKMUoGQqf92P92759G97TvQdj8=
Date: Fri, 19 Jun 2026 09:54:23 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: harshal24-chavan <harshal24.chavan@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, krisman@kernel.org,
	kees@kernel.org, gustavoars@kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v3] io_uring/register: add IORING_REGISTER_CLONE_FILES
 opcode
Message-ID: <2026061902-clerk-common-4c84@gregkh>
References: <20260619065700.12465-1-harshal24.chavan@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619065700.12465-1-harshal24.chavan@gmail.com>
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linuxfoundation.org,none];
	R_DKIM_ALLOW(-0.20)[linuxfoundation.org:s=korg];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:harshal24.chavan@gmail.com,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:krisman@kernel.org,m:kees@kernel.org,m:gustavoars@kernel.org,m:linux-kernel@vger.kernel.org,m:linux-hardening@vger.kernel.org,m:harshal24chavan@gmail.com,s:lists@lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-13789-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gregkh@linuxfoundation.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linuxfoundation.org:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,linuxfoundation.org:dkim,linuxfoundation.org:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0F8066A476B

On Fri, Jun 19, 2026 at 12:27:00PM +0530, harshal24-chavan wrote:
> Currently, if an application wants to duplicate registered file
> descriptors from one io_uring instance to another, it must manually
> unregister and re-register them, incurring unnecessary overhead.
> 
> Add IORING_REGISTER_CLONE_FILES to allow direct cloning of the file
> table from a source ring to a destination ring. This implementation
> strictly mirrors the io_clone_buffers UAPI, supporting partial offsets
> and the IORING_REGISTER_DST_REPLACE flag.
> 
> To ensure lock synchronization safety, destination nodes are strictly
> allocated as new, private io_rsrc_nodes rather than sharing references
> across rings.
> 
> ---
> v3:
>   - Rewrote the cloning loop to allocate private destination nodes via io_rsrc_node_alloc to fix non-atomic ref lock synchronization (Jens).
>   - Maintained partial offset/copy support to mirror io_clone_buffers UAPI (Jens).
>   - Gated the replacement free check on ctx->file_table.data.nr (Gabriel).
>   - Prevented self-cloning by checking ctx == src_ctx (Gabriel).
>   - Removed submitter_task check to allow cross-thread pooling setups (Gabriel).
> v2: Dropped unrelated whitespace formatting changes from v1
> 
> Signed-off-by: harshal24-chavan <harshal24.chavan@gmail.com>

Needs to be a name, not an email alias, and above the --- line.

thanks,

greg k-h

