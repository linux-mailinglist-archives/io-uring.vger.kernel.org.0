Return-Path: <io-uring+bounces-13501-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eMp6JIQCFGquIQcAu9opvQ
	(envelope-from <io-uring+bounces-13501-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 10:04:20 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E86B5C7686
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 10:04:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6C6CA300ECB7
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2026 08:04:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B9B43D812A;
	Mon, 25 May 2026 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FW65Xy4+"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9735639A05E;
	Mon, 25 May 2026 08:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779696254; cv=none; b=M9ecfzriVRwS9SNQJdB8NFZQDKvfr3Kf0BiF0tzbaA7QN3+oqkMSgmW+3QjNooO4dT/GEZakLASrdCNUJslhGjLk7AJIDo9n37jR4XfYqUC8gzJW8PRcYsm790hwB+M4WrgZOCxHQismEXtf+Pe8tAfRIjG53fFr8OgMUljcQiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779696254; c=relaxed/simple;
	bh=73vrApxNrpCy4XDyoCbJ2fXnIkf1Vpko4vO94TZdns8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cN1VoO4DQwfUfX/j5vZksq7ZjpfjonYFabSeppCKF92dt54ypmEvY37essWO1xFAd6UPdwoDYG/cfvofO86LVn/xFRQVYY9RpVCudkk80A/UbVdlIwtXWKTJaVeEusSfFrsjE7o9CpZgw4+k4nCylYAYP9LO+i04LYQ3qTSjJXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FW65Xy4+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GfaKXox8b6tZQOz6rQuRsRCazGocmiCFA5bwNHls9ME=; b=FW65Xy4+/qqB/Y4d5VUshtof0n
	B1qpRzV3dT6ABeoVvQLisbxpMvMaLmHHgGUuotvM13Oq8y+yYLeQUSVwda+11TXZK3v0fokYftvXJ
	cyWpf4mLpjcN7aUkfNHq+sYYEb/nm/olSXmzzlszTr6RS+YrGR5SbSFBiuylLbHU2l7PiwKaxINv9
	zqxKyu3Wj4flIUFqFwr3fZR9CFduLqMY65OMTt+ohC5o+j4imP0wqxfk44LoJSsz7r+/EsHjXAsCV
	JIjPnzXn4055g+A/20FRnLo3CteESpuvFsQL6/iYeYE3DODc1ZSpv4PLAZGgxPgQc3C1wwAp+US+/
	R7/FwfoA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRQHt-0000000GaTu-1YS9;
	Mon, 25 May 2026 08:03:49 +0000
Date: Mon, 25 May 2026 01:03:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: demiobenour@gmail.com
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
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
	linux-doc@vger.kernel.org,
	Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
	linux-api@vger.kernel.org
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
Message-ID: <ahQCZQNoyO8GQt3H@infradead.org>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
 <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13501-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[32];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.995];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 0E86B5C7686
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, May 23, 2026 at 03:43:02PM -0400, Demi Marie Obenour via B4 Relay wrote:
> From: Demi Marie Obenour <demiobenour@gmail.com>
> 
> The only user of msg->msg_iocb was AF_ALG, but that's deprecated.
> It can be removed entirely at the cost of only supporting synchronous
> operations.  This doesn't break userspace, which will silently block
> (for a bounded amount of time) in io_submit instead of operating
> asynchronously.
> 
> This also makes struct msghdr smaller, helping every other caller of
> sendmsg().

So we just had a discussion at LLC about how networking needs to support
AIO better for zero copy.

The current TCP zerocopy implementation provides completion notification
through the socket error code, which is freaking weird and doesn't
integrate well with either io_uring or in-kernel callers.

So we really want to pass the iocb down into networking and have it
call ki_complete on completion, with something higher up in the stack
adding that to the error queue for the legacy user interface.

Now I'm not sure if we wouldn't be better off passing that iocb
explicitly instead of in a weird hidden way, but this seemed like
a good place to bring this up.


