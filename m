Return-Path: <io-uring+bounces-12535-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4CLRHF0wpmkrLwAAu9opvQ
	(envelope-from <io-uring+bounces-12535-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 01:50:37 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BC9891E764D
	for <lists+io-uring@lfdr.de>; Tue, 03 Mar 2026 01:50:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C99A03039EEC
	for <lists+io-uring@lfdr.de>; Tue,  3 Mar 2026 00:46:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EE93204F8B;
	Tue,  3 Mar 2026 00:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWGTnQWy"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2C71CD1E4;
	Tue,  3 Mar 2026 00:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772498804; cv=none; b=W57A1RbXMb+O7Ba4LuDp3A9VfxyeDkOR9c7XjQrv6B9oBkBtDzsBtSWbTbmBXCzNgK/RaW97hd/towpvZcqvdbyYdhkE/noryo8GrSBAaVTETzY0afayC+smaEeMvqN6YyWfYLRthLWRVxCjtwsfI4H9Nn0MTWTX4x8PyUAwYWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772498804; c=relaxed/simple;
	bh=zVa/l8Fm42yEeXCdiqomVcsJChFKyuQE2mXRBuJYV0A=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dxdVrcU4rqMGbQ5UCx57nnY6qo57B2YaE8zWjRe0ru5aVMZBZOYwD5U7SCRnJqV6f6tK4AsHQ/tHTeqdGOlQ82mPtmZDNDQk/KT/dB6kqyLp527lP2AAUfy+6/r9EaJkthSKa0BdEKf1//dmAHAuXmsZPRHj2JK8MskpZhM/Uf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWGTnQWy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D11CC19423;
	Tue,  3 Mar 2026 00:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772498804;
	bh=zVa/l8Fm42yEeXCdiqomVcsJChFKyuQE2mXRBuJYV0A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZWGTnQWyCGsQS/I5f/ABd9t+YJ0EVy1wHUUuw8/NnLoEbYwZQ3lpkZGrfxbJDYoFC
	 uoykwAsSyJvyQx1CltER7670pgqolWKCp9Z9KU7Tuf5SoaU+1CgiJzZGipYTFViS82
	 kXOoRk8xh9TUR83yUeFbYraJM4mXUGuXfCzfD1kKa3mbNr6j7Q/gDIfSrimEwhXBKF
	 ZQN5Ea2CLLrLP6N2IQjZkjck2DqkJxTgyX4wWcEy353Y2v8ReWPhmYFps3PY4sODPq
	 tUvRveJ939s74+QeET0FG5Ms1g7UPG7CGlONxV9CZSYXwKRvgx+qbJVcZnJXJco0ZT
	 XAG2qwFK9NpRA==
Date: Mon, 2 Mar 2026 16:46:42 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 jdamato@fastly.com, asml.silence@gmail.com, io-uring@vger.kernel.org,
 shuah@kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] selftests: drv-net: iou-zcrx: wait for
 memory provider cleanup
Message-ID: <20260302164642.43375391@kernel.org>
In-Reply-To: <8489fcbf-ab76-48a9-a21f-d7f6873b9a2f@davidwei.uk>
References: <20260227171305.2848240-1-kuba@kernel.org>
	<20260227171305.2848240-2-kuba@kernel.org>
	<8489fcbf-ab76-48a9-a21f-d7f6873b9a2f@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: BC9891E764D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12535-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[davemloft.net,vger.kernel.org,google.com,redhat.com,lunn.ch,kernel.org,fastly.com,gmail.com];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,netdev];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Mon, 2 Mar 2026 07:49:01 -0800 David Wei wrote:
> > +def mp_clear_wait(cfg):
> > +    """Wait for io_uring memory providers to clear from all device queues."""
> > +    deadline = time.time() + 5  
> 
> This is potentially a very long time to wait if code is buggy, as I
> found out when debugging netkit queue lease. How about reducing this to
> say 1 second?

Just to be clear -- you're saying that 5 seconds is a long time to wait?
Please note that if this wait times out we're going to fail the test,
the timeout does not impact the length of a successful run.

I picked 5 sec because with all the debugs enabled and under QEMU
scheduling latency spikes can be pretty brutal. I guess I could make it
3 seconds if it matters a lot?

