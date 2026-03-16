Return-Path: <io-uring+bounces-12690-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sL91AYP8t2mXXwEAu9opvQ
	(envelope-from <io-uring+bounces-12690-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 13:50:11 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD3A299AA3
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 13:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5CDE8301AA9D
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 12:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BD96396B63;
	Mon, 16 Mar 2026 12:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="g6+HKUxH";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="biVxfPx9"
X-Original-To: io-uring@vger.kernel.org
Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21806396B78;
	Mon, 16 Mar 2026 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773665369; cv=none; b=WbNn4JTTvHEePqLA4knZ7n6s6+G1BRGUTgOkSA3bulRHviN79FXBQZvQvVhwPs7YpXxdVMhJJAp9wn5ukxtfdRwud0pUhtVVuV8LeM3uq6wa94UTmy8Ukd9GJ87Kwyj2+hoUJQLJ91KLgGuJu7G+7zNAoIjFJ+eLfE+hybDmzEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773665369; c=relaxed/simple;
	bh=tyUFcjzHUCVhc5Dh5hcBtNv6ap69gOToe4IcDLBOzFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AiBK0eirxW2Tb3peUax+35+bZK/A5PZ+xt7uy8g3V5YrsUP1DJ8aZZH5R/P0NQBP1xrmGsHs4xfQbL09cNX5/loMMm0lC5KXNemLuNLWr/l3sopFqnXuslld3wdsQwBrwaGDXhAiBR10wq159nYyl4d/A4l8OBzKwNgLaxbuZQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=g6+HKUxH; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=biVxfPx9; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1773665358; bh=XJDwzgR8WccmQYkquJVjQCT
	Yev3o0mXwy1u0lOL2lSs=; b=g6+HKUxH/voT7dPSM3ExkxxQGuhhS9pSgL548XK26xR7g4HP3Z
	qqZQoh7c9e4nuoOepLgjqPyZ0yPOnCVDy5rZaF75tpzqnIaYOzu8/+4fdBfZZiBwPKnSj0ZdDcc
	wH1aWI20CxapB4lU40G85aE5j4/9zosGpaHnqycdTnIciyglV3y1jJvCd+bx/+xSoPbJX+XqPqk
	ycb5U2gdctTMdR/km2EfO8Md5n12laJaAsk+TbgtbXD1Ym7glH8fF8Zx0gIgTnzAD+JS2bPp99R
	jizM6/PWnnzxIudIgbmYG4GS+xVmDMCMO/+dQtlXX4BzTq395Lr1roiJNCUX5jNbyvQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1773665358; bh=XJDwzgR8WccmQYkquJVjQCT
	Yev3o0mXwy1u0lOL2lSs=; b=biVxfPx9wlkhk3BgzVQNCQL0XLLYjiesIrRdw2dxd4ruGnWzQG
	Q8zt/M6/g6z7VKziSg/wX6TeiDrbfOcV0sAA==;
Date: Mon, 16 Mar 2026 08:49:18 -0400
From: Daniel Hodges <daniel@danielhodges.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Hodges <git@danielhodges.dev>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] io_uring: add IPC channel infrastructure
Message-ID: <wmy46klrmmxuspo4xttbz2kqzbtopavlsvxutjqxioqsihp7x2@n3uiq6hr6gjr>
References: <20260313130739.23265-1-git@danielhodges.dev>
 <20260314135053.3334-1-git@danielhodges.dev>
 <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[danielhodges.dev,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[danielhodges.dev:s=202510r,danielhodges.dev:s=202510e];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12690-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[danielhodges.dev:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[daniel@danielhodges.dev,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,danielhodges.dev:dkim]
X-Rspamd-Queue-Id: 7FD3A299AA3
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Mar 14, 2026 at 10:54:15AM -0600, Jens Axboe wrote:
> On 3/14/26 7:50 AM, Daniel Hodges wrote:
> > On Thu, Mar 13, 2026 at 01:07:37PM +0000, Daniel Hodges wrote:
> >> Performance (virtme-ng VM, single-socket, msg_size sweep 64B-32KB):
> >>
> >>   Point-to-point latency (64B-32KB messages):
> >>     io_uring unicast: 597-3,185 ns/msg (within 1.5-2.5x of pipe for small msgs)
> > 
> > Benchmark sources used to generate the numbers in the cover letter:
> > 
> >   io_uring IPC modes (broadcast, multicast, unicast):
> >     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-io_uring_ipc_bench-c
> > 
> >   IPC comparison (pipes, unix sockets, shm+eventfd):
> >     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-ipc_comparison_bench-c
> 
> Thanks for sending these, was going to ask you about them. I'll take a
> look at your patches Monday.
> 
> -- 
> Jens Axboe

No rush, thanks for taking the time!

-Daniel

