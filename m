Return-Path: <io-uring+bounces-12713-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yP8zGJGRuGkUgAEAu9opvQ
	(envelope-from <io-uring+bounces-12713-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:26:09 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AC3882A1F04
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2026 00:26:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D2BD303C2AA
	for <lists+io-uring@lfdr.de>; Mon, 16 Mar 2026 23:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CD68378D79;
	Mon, 16 Mar 2026 23:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="NLkhsBBn";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="HZRz9AVp"
X-Original-To: io-uring@vger.kernel.org
Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72E32B989;
	Mon, 16 Mar 2026 23:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773703566; cv=none; b=rfxZV0DdId+8Hpio99L2RMTVMXumWVcCxzItKdWKEVnE2wYtveaTil8q3CJSVcGU+nqksCSABQW207PHGDV2DUy6F+yLJyWzqdLTDRmEOs8TB/nJ+TAGoq9bsPu07K9dxH9aKfnQp/bt0MibpaURfKnELOArQ/zCyofEAN2Y/Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773703566; c=relaxed/simple;
	bh=cwjJxd1OJN6VutawSi56t8IVWV+t5z4EJtL0ogGOuXg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rI2UB3irbZYlXWpHyxLNqQn6ldy/LvdScC4ZE/50oq+UK3qyzj1txKLVSR8ztputueFQwdqzIU0eez5iBETbrprQ7hm0TYGkUHxzSH3/UMNvaCnBtcuRjxGYjQ/L9b8fBRrYvTmEALHoCyoOnj47M8tdnPBoYvuDSffc1kfZwfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=NLkhsBBn; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=HZRz9AVp; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1773703563; bh=OznILQI+EMK8Z+JKnLPTLMn
	NXWDRT6m8eGoULkwbM+4=; b=NLkhsBBn61BW5fluNpFsChS5PTqRKRF31ojbOz0qAWSpd5HOn/
	W+5XqTZkNWKp4ICJ1jcWs0fF1M3LZyYleqojkQOh911+fSCqXy87nu0Yj658VNkzJwjio1qw3ks
	JaXglvDC9ilHuWY9JZnxlXi4ly8h0Rlgi0wfLk6kTPO+i1o8ZZIIRqPPqM4QLpDPrPFCCqZ4qtb
	vyf4GbievKb6A06tV+5Y4ZK9k5FqwZgET1otxezlSk0qm4Kdw9Q1z0Y3jbeSQd6l0ovUfRg9aLx
	MT8hBdtV5wdcvoxVHcU/o98gnCmFMBnk7egCndw5YwE1Xt08wdCVdNTmyb5YW+wiDdw==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1773703563; bh=OznILQI+EMK8Z+JKnLPTLMn
	NXWDRT6m8eGoULkwbM+4=; b=HZRz9AVpHD86NmEvsU4f8vAQ4BIH9K+EYV7aZXIroVq3Phndwp
	ImJcguk1A6oaYwqUl2fzBhOeV66TuFffOsAg==;
Date: Mon, 16 Mar 2026 19:26:03 -0400
From: Daniel Hodges <daniel@danielhodges.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: Daniel Hodges <git@danielhodges.dev>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] io_uring: add IPC channel infrastructure
Message-ID: <2n43l6nu4qz5siju4ze42wqnbdqwbogeh2jfztlzi6a2grnqsi@z2n5qvvsazs6>
References: <20260313130739.23265-1-git@danielhodges.dev>
 <20260314135053.3334-1-git@danielhodges.dev>
 <873d56d8-6c1c-447f-ae70-870417c6de5a@kernel.dk>
 <wmy46klrmmxuspo4xttbz2kqzbtopavlsvxutjqxioqsihp7x2@n3uiq6hr6gjr>
 <d6e64251-2025-438c-92d6-71b44927b437@kernel.dk>
 <hzb3i37w6isn7gx7jqc223fmznxxjmqvlxke2rdb3lb43htifq@j45xx427nppc>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hzb3i37w6isn7gx7jqc223fmznxxjmqvlxke2rdb3lb43htifq@j45xx427nppc>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[danielhodges.dev,reject];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[danielhodges.dev:s=202510r,danielhodges.dev:s=202510e];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12713-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[danielhodges.dev:+];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[daniel@danielhodges.dev,io-uring@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: AC3882A1F04
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 16, 2026 at 07:13:42PM -0400, Daniel Hodges wrote:
> On Mon, Mar 16, 2026 at 04:17:05PM -0600, Jens Axboe wrote:
> > On 3/16/26 6:49 AM, Daniel Hodges wrote:
> > > On Sat, Mar 14, 2026 at 10:54:15AM -0600, Jens Axboe wrote:
> > >> On 3/14/26 7:50 AM, Daniel Hodges wrote:
> > >>> On Thu, Mar 13, 2026 at 01:07:37PM +0000, Daniel Hodges wrote:
> > >>>> Performance (virtme-ng VM, single-socket, msg_size sweep 64B-32KB):
> > >>>>
> > >>>>   Point-to-point latency (64B-32KB messages):
> > >>>>     io_uring unicast: 597-3,185 ns/msg (within 1.5-2.5x of pipe for small msgs)
> > >>>
> > >>> Benchmark sources used to generate the numbers in the cover letter:
> > >>>
> > >>>   io_uring IPC modes (broadcast, multicast, unicast):
> > >>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-io_uring_ipc_bench-c
> > >>>
> > >>>   IPC comparison (pipes, unix sockets, shm+eventfd):
> > >>>     https://gist.github.com/hodgesds/fbcd8bb8497bc0ec2bf1f95244a984fe#file-ipc_comparison_bench-c
> > >>
> > >> Thanks for sending these, was going to ask you about them. I'll take a
> > >> look at your patches Monday.
> > >>
> > >> -- 
> > >> Jens Axboe
> > > 
> > > No rush, thanks for taking the time!
> > 
> > I took a look - and I think it's quite apparent that it's a AI vibe
> > coded patch. Hence my first question is, do you have a specific use case
> > in mind? Or phrased differently, was this done for a specific use case
> > you have and want to pursue, or was it more of a "let's see if we can do
> > this and what it'd look like" kind of thing?
> > 
> > I have a lot of comments on the patch itself, but let's establish the
> > motivation here first.
> > 
> > -- 
> > Jens Axboe
> 
> I've been helping Alexandre prototype a D-Bus broker replacement that
> scales better on large machines. Here's some docs/benchmarks:
> https://github.com/fiorix/sbus/blob/main/sbus-broker/docs/analysis.md
> 
> The idea for this RFC by trying to come up with a design if D-Bus was to
> be built from the ground so that it could scale on large machines. D-Bus
> was built because the kernel never really had a broadcast/multicast
> solution for IPC and kdbus demonstrated that moving dbus into the kernel
> wasn't viable either. So that's where I sort of landed on the idea of
> what if io_uring could be used for this type of IPC.
> 
> There isn't a working io_uring backed D-Bus implementation yet as
> it would require features that aren't in this patch such a handling
> credentials etc. I fully acknowledge I had AI help in working on this,
> but if this idea make sense I would appreciate some human direction. If
> it seems like it could be feasible from your pespective I would like to
> try to give it a proper attempt. Thanks!
> 
> -Daniel

I just realized the link I sent is private, here's a link to the D-Bus broker
docs/benchmarks from my fork:
https://github.com/hodgesds/dbus-rust/blob/main/sbus-broker/docs/analysis.md

