Return-Path: <io-uring+bounces-14001-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id O/OQLOlCVmqe2QAAu9opvQ
	(envelope-from <io-uring+bounces-14001-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 16:08:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C91A755897
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 16:08:41 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J5gtew63;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=25XHiCbR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jRyF6sdH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=e9S09Es3;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14001-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-14001-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id CD75B30886DE
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2026 14:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73E3924113D;
	Tue, 14 Jul 2026 14:02:23 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08A34446E0
	for <io-uring@vger.kernel.org>; Tue, 14 Jul 2026 14:02:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037743; cv=none; b=BtEjn8Rp5JQwUEf9jlj8tbyx3Yo5TlAgRcOOFYYFYRx7tsD+6jfeln+4Iwvy/x6inaTsE+2wP+ZACty7wG3adaLTkxe9SQPHZm7EAY594UgeMyoh4IPZCGBkOJCILzgMe45CdILzWpRuco+Mc88qvZDnd43K2pkyy6gD57suIuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037743; c=relaxed/simple;
	bh=kbT6buJWa9e9WTXfIqFKYYbf5BlOidukN9wkGkXW/Bk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=s28gXT19Qd6eW3HqKo+LXf32dNtIBshOHtqznYPMXAHeWfWypMXn3WSLUh3EillPPmQgPy9b5NikwiCUDGqjx0Sre36VNqCL5XztTiRgBUfgvQ3gqO2VjeQIUmfCCzVcv2jO7+EEMp9oDukcD/8kH+nnD2GU9LZ0aAsWUV5hfG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=J5gtew63; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=25XHiCbR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=jRyF6sdH; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=e9S09Es3; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 76DCE3E24;
	Tue, 14 Jul 2026 14:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784037739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f3JYNQQcEE+kA/SoFOsB6iOTDT7ayOpozzzhtd0ioNI=;
	b=J5gtew63QguoLz7zhRuDqViZxEWSh0aRpbv3u0Dm2EVNssTgHvtWTL/4gBDtksbEjeSevU
	wy2r/GQ/S+6MsKEensFbOYm3OvOfahqgF/ACcII+7h208MSd80WAs+/AL88eZuV5lr0KYD
	vW8dpnEl2cO8lqy5GEKpPhcKzfYyuzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784037739;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f3JYNQQcEE+kA/SoFOsB6iOTDT7ayOpozzzhtd0ioNI=;
	b=25XHiCbRiFf2qUsrtU2+yCw8SrUQuM0FNNVIyE9M21FcKxhd59gtmJ3Wz4ygeF/WFbTgfJ
	T5AWRhH+y5kr4oDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1784037737; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f3JYNQQcEE+kA/SoFOsB6iOTDT7ayOpozzzhtd0ioNI=;
	b=jRyF6sdHIpYcnA4tiZDemtuhmWRfpQ3ppcqQE43JTti/T3uZxzHeerg+rcy5g+ih733xHn
	R7EDsDrMYwAs7zk45OwQsVMxHNUjTmjHYMnysUiOCmujQsI1wsQTcqvRh9MhNGqXmY0YUT
	t8TPSSg/zBf4Rochcia+75drEc/L72M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1784037737;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=f3JYNQQcEE+kA/SoFOsB6iOTDT7ayOpozzzhtd0ioNI=;
	b=e9S09Es3rlXCV1HV+jVbqG7GvUK2fs255OkwB2e5uENIUfk71/2P++Tx3Knp6iRhb2kGIy
	XIYxr9fjYaOADPDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 26931779AE;
	Tue, 14 Jul 2026 14:02:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W/HBOGhBVmqDAQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 14 Jul 2026 14:02:16 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Doruk Tan Ozturk <doruk@0sec.ai>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, Doruk Tan Ozturk <doruk@0sec.ai>
Subject: Re: [PATCH] io_uring/kbuf: free the old cached iovec, not the
 returned one, on bundle grow
In-Reply-To: <20260713183124.4217-1-doruk@0sec.ai>
Organization: SUSE
References: <20260713183124.4217-1-doruk@0sec.ai>
Date: Tue, 14 Jul 2026 10:02:11 -0400
Message-ID: <87ik6h4ql8.fsf@mailhost.krisman.be>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.30
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14001-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:doruk@0sec.ai,m:axboe@kernel.dk,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	HAS_ORG_HEADER(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:from_mime,suse.de:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mailhost.krisman.be:mid,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 1C91A755897

Doruk Tan Ozturk <doruk@0sec.ai> writes:

> Commit cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer
> bundle grow failure") moved the KBUF_MODE_FREE kfree() out of the expand
> branch to after the validation loop, so the old cached iovec is only
> released once the new buffers have been validated. However, by the time
> control reaches the post-loop free, arg->iovs has already been reassigned
> in the expand branch to the freshly allocated array that is about to be
> returned to the caller:
>
> 	iov = kmalloc_objs(struct iovec, nr_avail);
> 	...
> 	arg->iovs = iov;		/* now the array we return */
> 	...
> 	if (arg->mode & KBUF_MODE_FREE)
> 		kfree(arg->iovs);	/* ... but this frees it */
>
> On a successful grow, io_ring_buffers_peek() therefore frees the very
> iovec array it returns. io_recv_buf_select() then builds an iov_iter over
> that freed array and caches it in kmsg->vec.iovec, giving a
> slab-use-after-free read during the recv copy and a later double free of
> the iovec array on request cleanup. The array is a kmalloc() whose size is
> controlled by the number of ring buffers the caller commits, so the freed
> object lands in an attacker-influenced kmalloc cache.
>
> KBUF_MODE_FREE is meant to release the *old* cached iovec once it has been
> replaced by a larger one. Free the captured org_iovs instead, and only
> when a grow actually happened (arg->iovs != org_iovs) so the no-grow case
> still returns the reused array. The -EFAULT failure path already frees the
> new array and leaves org_iovs for the caller, so it is unaffected.
>
> Reproduced on next-20260710 with KASAN by an unprivileged IORING_OP_RECV
> using IORING_RECVSEND_BUNDLE over a provided-buffer ring: a first
> (expanding) bundle caches a small iovec, and an in-request bundle retry
> grows again under KBUF_MODE_FREE, triggering both the UAF read and the
> double free. The change eliminates the KASAN splat.
>
> Fixes: cd053d788c3f ("io_uring: fix dangling iovec after provided-buffer bundle grow failure")
> Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>

Already fixed here

https://lore.kernel.org/io-uring/20260712142612.188695595-iostreampy@proton.me/T/#u

here:

https://lore.kernel.org/io-uring/OS3PR01MB8810F38D613E37FBD684DC4D83FB2@OS3PR01MB8810.jpnprd01.prod.outlook.com/T/#t

and here:

https://lore.kernel.org/io-uring/20260713-io_uring_dangling-v1-1-b9bdc0f0e776@debian.org/T/#u

Aren't LLMs fun?

-- 
Gabriel Krisman Bertazi

