Return-Path: <io-uring+bounces-13557-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C3lOtgtGWogrwgAu9opvQ
	(envelope-from <io-uring+bounces-13557-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 08:10:32 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 445A55FDC88
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 08:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 3EBFD3003BDA
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 06:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAC90360751;
	Fri, 29 May 2026 06:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hVguPhg4"
X-Original-To: io-uring@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D63E2E7389;
	Fri, 29 May 2026 06:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035019; cv=none; b=TbFQ9fLJ1qmKdaQpDDxbdbnt7JbbWcKrIvLE5Dh9C7LX3Os6zAEMaKDFGIeRtnofAA0SOLAbGL9CsVyFbN3C9N0LZ+TGKucN1wGdWc2ZlDvBCzASaOg3jg3fZSzKDHx0+D9RHYq7Oc406xzNedPa+uUxUcykygrmSzAGz/NkVSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035019; c=relaxed/simple;
	bh=osaKBTLJ0lV7a7mqYpO/cFFhkXh0WHooJI0CnQ+IbKM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y1hCrQSYeF3kuxTVSApT1mKQMJvFJ/Fu52Vb3jq8ffPf8NVEhbmsXt+yRwnWP7OGKpf11ooeX2dWIKOvzOIwrkRwdC7mVRvOdLFiq6XXpMlbQvFH0gG24X8lEOBNoXlrzfaa/IdIgXHWvp+PevNl92SNhv8shkhsLhOOlPrq/w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hVguPhg4; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=J3EhnnX3hHQdWB4TNUAD/20YRD6cojsn1uHBbo0VX2k=; 
	b=hVguPhg4DROuLmAKUFs1ljpnkC82MqXEZ8MsQtl0U7pKDDS7hG6Bfizq8yHMAWvHkJTDgmyGvP7
	PIL1z1cWNlR4a8BRTLrG40bbS/hQ+CcrHJjgEDWZMzOiU7Eepu4OnJdg3+MAAlQXkyCCWiBhdH4Gq
	j1tcryJQQPS9WhE6qhTOdwVV1eX1DG8XHQY7Wldu7umXiGouAzuqjdaWCZA/ZjoXqt4FAyChx4mDM
	lXQRShs4OuWYbtsvjYL2Rh54V/gvqRxZ1ER9RbB4bYYHqzGTizkNUj5Z69bNlCON3ENcu4T2ngKId
	dDgIeNQaNfq418mRPMZ9k7CLbAtRyF65Yvew==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wSqPc-000dKa-2D;
	Fri, 29 May 2026 14:09:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 May 2026 14:09:40 +0800
Date: Fri, 29 May 2026 14:09:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: demiobenour@gmail.com
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	netdev@vger.kernel.org, linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/3] AF_ALG: Remove support for AIO and old-style drivers
Message-ID: <ahktpDYvPV9sb9zf@gondor.apana.org.au>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[apana.org.au,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gondor.apana.org.au:s=h01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-13557-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	DKIM_TRACE(0.00)[gondor.apana.org.au:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[herbert@gondor.apana.org.au,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gondor.apana.org.au:mid,gondor.apana.org.au:dkim,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,apana.org.au:url,apana.org.au:email]
X-Rspamd-Queue-Id: 445A55FDC88
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, May 23, 2026 at 03:43:01PM -0400, Demi Marie Obenour via B4 Relay wrote:
> AF_ALG is a deprecated API only useful for compatibility with existing
> userspace.  It has had a lot of vulnerabilities, including the infamous
> CopyFail.
> 
> Rip out support for offload drivers, which tend to be buggy.  Also rip
> out support for AIO, which actually bloats the entire socket subsystem.
> 
> Only compile-tested.
> 
> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
> ---
> Demi Marie Obenour (3):
>       net: Remove support for AIO on sockets
>       AF_ALG: Drop support for off-CPU cryptography
>       AF_ALG: Document that it is *always* slower
> 
>  Documentation/crypto/userspace-if.rst          | 26 ++++++++--
>  crypto/af_alg.c                                | 35 ++------------
>  crypto/algif_aead.c                            | 43 ++++-------------
>  crypto/algif_hash.c                            |  4 +-
>  crypto/algif_rng.c                             |  4 +-
>  crypto/algif_skcipher.c                        | 66 ++++++--------------------
>  include/crypto/if_alg.h                        | 19 ++++++--
>  include/linux/socket.h                         |  1 -
>  io_uring/net.c                                 |  1 -
>  net/compat.c                                   |  1 -
>  net/socket.c                                   |  7 +--
>  tools/perf/trace/beauty/include/linux/socket.h |  1 -
>  12 files changed, 70 insertions(+), 138 deletions(-)
> ---
> base-commit: 49e05bb00f2e8168695f7af4d694c39e1423e8a2
> change-id: 20260502-af-alg-harden-900849451653

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

