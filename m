Return-Path: <io-uring+bounces-13562-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OIBOMEWdGWq7xwgAu9opvQ
	(envelope-from <io-uring+bounces-13562-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 16:05:57 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 208E860341E
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 16:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 387D93058BA2
	for <lists+io-uring@lfdr.de>; Fri, 29 May 2026 13:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DF8F3451A6;
	Fri, 29 May 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t4lUbtZl"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225932D5C83;
	Fri, 29 May 2026 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780063179; cv=none; b=Dp5lHu8aW/IXqdMD37O87er8Kk4zoCdqbwxChTzicGl/WjDkcPb1APOYB7MZTse+0gqrJ9+XXo4kezh/p8IwRCLz3XG/9aaczqeqc3eTA3ncmRQO8afCTATqXHQKe53s6Gbv54/8/gZVORE4W1iaHfqKFeo4qZoe8E1zl6L0RrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780063179; c=relaxed/simple;
	bh=OIfcxw6L7juAJ+MhhKySY0equp2hvB1yaaAjhl0zNjc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R7fmsVGQS0clIL3BOeuMcyYebiiwKpeJOgZdYaukSWiHRmZhT9eElVPmy7C8swlwpUKJY1MEQ9T9v/wUiRyB18/h0rAuv1xa035qC4xabVjZbBDDgNW1FataNgSmtmhvdH1fwG+TZ22r9msSEDGPsOL+rYUJBHK0SycPxETb0pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t4lUbtZl; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=krC21NLD30nrg01fSvUce7Fe+FnXVEhQr9QoYVMHRHI=; b=t4lUbtZlab0axYF0lmbW0CYbZ3
	/JMaNPB4pXiSA68du4121/lvny2qQTj6r0QLLa3lvEiRGZzzI6ujKm+v/rgLwKfJXpGVb92BYVDp5
	1+LI2tB7gw/1/qjbqSRu/o7jBzPpGIHStF7XhGfgk7wgr6mWl1Iy7z6ClDLlVrqU/fciiDY5cB+Dl
	ov41tGJ1yiWyQKSwoA8Vxgobs13MaHEc3/wDb3MBrW8ouEjIj0p+kEAFHPvp17HszODSNJoclwbos
	/LHuaQP/5EWbw3fTftd57ASuqWeQfloci3OE6ljXro3cxHW3c8F9WmYxDjA/J56FG/IhARBULEi+o
	zutNVb1g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSxk9-00000007TtN-0ATY;
	Fri, 29 May 2026 13:59:21 +0000
Date: Fri, 29 May 2026 06:59:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, demiobenour@gmail.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
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
	linux-api@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/3] net: Remove support for AIO on sockets
Message-ID: <ahmbucsrd-W4BVhz@infradead.org>
References: <20260523-af-alg-harden-v1-0-c76755c3a5c5@gmail.com>
 <20260523-af-alg-harden-v1-1-c76755c3a5c5@gmail.com>
 <ahQCZQNoyO8GQt3H@infradead.org>
 <92db3ff0-8f0b-4b61-a167-5004ffcf9025@kernel.dk>
 <ahanjVfIDlCmeCUE@infradead.org>
 <2cfd6455-7b5b-4974-b8a1-4a0abca69768@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cfd6455-7b5b-4974-b8a1-4a0abca69768@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13562-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,gondor.apana.org.au,davemloft.net,google.com,redhat.com,kernel.org,arm.com,linux.intel.com,intel.com,linaro.org,lwn.net,linuxfoundation.org,vger.kernel.org,toke.dk];
	RCPT_COUNT_TWELVE(0.00)[34];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 208E860341E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, May 28, 2026 at 10:56:06AM -0600, Jens Axboe wrote:
> > Where?  And how do make that available to in-kernel users like
> > storage protocols and network file system, which really suffer from
> > the current MSG_SPLICE_PAGES semantics.
> 
> For zero copy, on both the receive and send side. Since we have a proper
> notification channel, that's what we use rather than the hack that is
> the error queue.

Can you point me to that notification channel? 

> >> , and without needing msg_kiocb or the
> > 
> > What do you think is the downside of using a kiocb here like for
> > everything else with async notifications?
> 
> Where would the notifications go?

For userspace: io_uring or the error queue for the synchronous calls.
For in-kernel APIs whatever the callers wants to do by doing it from
ki_complete.

> You'd end up inventing something new
> to propagate them to userspace then.

The main aim here is to have a way to get these completions from
kernelspace to get rid of the current horrors around MSG_SPLICE_PAGES.

> The io_uring side does not rely on
> using msg_kiocb, and iirc that part was only ever used for the crypto
> stuff and largely broken. Which is why I do agree with just yanking it
> out.

I'm not arguing for how msg_kiocb as that is a mess.  But having an
explicit kiocb API like all the other async file operations would
make things a lot simpler.


