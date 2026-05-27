Return-Path: <io-uring+bounces-13509-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KN4eHI9LFmrZkQcAu9opvQ
	(envelope-from <io-uring+bounces-13509-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 03:40:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 136535DE4C2
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 03:40:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id D30903014252
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 01:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8D603254B2;
	Wed, 27 May 2026 01:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HaSlg+qi"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FCF23535E;
	Wed, 27 May 2026 01:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779846028; cv=none; b=B/aDKZZnfJIL6m+FAlcKVflVfALEsbiJIXcvzf9eXt1OPHX6ykxOJmUsWzzwxFtCnaI4nHS2COjCVX3tdotewGedIYJgSyjHSvDmtDWXoCxtH1Sa97fn6wy3odddoitFF7KnxifXa0pgvOtoJBLflKJLLpV/jZ6gu9eayuck5bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779846028; c=relaxed/simple;
	bh=3MUBBPppyO0fH/F3MIaALrwek2Q97thIaEAQ5B+cKYA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qL2ffsEjF+i931W/1UCvsLm4LlkLrARE0y33YKBvI/P2CJMMENJm5p1MFyR4T3APKINSpc3Td4s0IMIevbUPkhNf1jHdVJAAAOqUdvDNMTGp3cex6VdD3jV6rHoS+sEyVcN4LpTyHF9Trx2EPIHrgp6IjYzweR/8vPFH8+baWxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HaSlg+qi; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604B71F000E9;
	Wed, 27 May 2026 01:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779846027;
	bh=k7APhuaYn+BJj+G8pdfSIyx/xH1eGaLzG4YtD0OwtPg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HaSlg+qimU8q1kQ7AE/GGxz+RGhvpNsO+GUGBwXE4Z5UEtAT6JlyIacLBE7BVuo1x
	 g5rrWFWLHmLoirH/+CQ5Vnh5xJvINDkydgK14Bqd4WItdRLWEMVeJ1MiSRn2RMACjf
	 AMyOMHuJcNM+XDaSIdIPHWN9H/pY4bJ0NBshse3V3XmTPyI6usqvRp2cBfwFIBSZ+G
	 NLWiUE8CcyyOhxhIyUbL6i/OT9T+X8nN8P7LxeE/HQlqGkeny4uXidwpe14ndoKsNb
	 fdTB73jSvTpG1EvEXr2DIGSbyaN09e2cUSJa37FoJB5j5FzKd+gKbeYjWPPY9JipHQ
	 ko85lM5WD4T4A==
Date: Tue, 26 May 2026 18:40:25 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Demi Marie Obenour via B4 Relay
 <devnull+demiobenour.gmail.com@kernel.org>
Cc: demiobenour@gmail.com, Herbert Xu <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>, Simon
 Horman <horms@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo
 Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa
 <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, Adrian Hunter
 <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Jonathan
 Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, Eric
 Biggers <ebiggers@google.com>, Ard Biesheuvel <ardb@kernel.org>,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 linux-perf-users@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
Message-ID: <20260526184025.0ca0e979@kernel.org>
In-Reply-To: <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
	<20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13509-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,gondor.apana.org.au,davemloft.net,google.com,redhat.com,kernel.dk,kernel.org,infradead.org,arm.com,linux.intel.com,intel.com,linaro.org,lwn.net,linuxfoundation.org,vger.kernel.org];
	RCPT_COUNT_TWELVE(0.00)[30];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kuba@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring,demiobenour.gmail.com];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 136535DE4C2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, 23 May 2026 15:43:02 -0400 Demi Marie Obenour via B4 Relay
wrote:
> The only user of msg->msg_iocb was AF_ALG, but that's deprecated.
> It can be removed entirely at the cost of only supporting synchronous
> operations.  This doesn't break userspace, which will silently block
> (for a bounded amount of time) in io_submit instead of operating
> asynchronously.
> 
> This also makes struct msghdr smaller, helping every other caller of
> sendmsg().

Acked-by: Jakub Kicinski <kuba@kernel.org>

