Return-Path: <io-uring+bounces-12927-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFXyJ9VgzWlncgYAu9opvQ
	(envelope-from <io-uring+bounces-12927-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 20:15:49 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A807B37F193
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 20:15:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 61157300B8D5
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 18:10:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BC2730FC26;
	Wed,  1 Apr 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ja4faTNp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B03C230F819
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775067025; cv=none; b=sFCoGUy1+MpPWZpFHyHH7hXqt9er7AnD4+J/x2ZM3ura8Umlx4mUx+l0iHuY2Tq9bTpkDE94x2j3TuSqE5Pc/aUt8IE6mEhTTrUACixGfHag3Fz/VnSyskdFqSMnQYhNs42BZerO2aGgAUKCsPzZI4NAB2lGNeZAnVy7ltaW5/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775067025; c=relaxed/simple;
	bh=q2w9fllxftn/Dn+aeDVhMcD9IFD7B4W6SKpJ1EFB9cY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WFMQ99WZxOx9BYUfpzahVEBAwYpa6K1ZH3Gj9mciythid7wr1XxtfHJG/+Zfu/ftkqx2VsWtTNj21t0zcHUFfYKuYlhBpGXsfivLWCnBc7GqgalD7RDYqcN4Sn72B0LhDiap2DUuWdtkT1WVyBS0/d5/zE+lg/UJL1ibKtbO7aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ja4faTNp; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2c18af885c0so173369eec.0
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 11:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775067024; x=1775671824; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=edxQkpAdo8vyFtjzZGynRbyOAKQskd0O43XW005wTrM=;
        b=ja4faTNpP/RkUFTLnBN1NmrCQ9NcnkKJrqpLj8t4mS3pc50E/ChL+NgRxtL/sCM9CA
         t6ITnBZz82f0TXvE+SZv4fycmC4BaSrcCO81QHFnooSvuARbY/c8QlW4Gpdft4oh2ker
         TaLViFLTVWXukMq+xFW1toKJUcQEsyMo+0QBZA0ZzXfxp7c0iQIAWwbkWlHkcTfQ09eR
         ajZWVBoG4VkSpAupXlGMfFiwTPekZwOIj2oUCQXXAl3XBu/HQ7bhRgJt/p3wdyne9Ood
         WmBJOZLtQWyoQB4NOIjznwlDmCE1QA2RjvNd2h+eDwQF2f+qfIBvfePdJ1xbc7GO1FRJ
         2FUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775067024; x=1775671824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=edxQkpAdo8vyFtjzZGynRbyOAKQskd0O43XW005wTrM=;
        b=W6AwVBmvo4Co2Ut50OtxNhLWIoXJIljuRd2J8M+JgJJZ4+VJx8PEWfols/avGC5CTw
         s/uIQcaD2jJPIyeg+0aHxwqPwOzSmg+SuA0uLoGS8f77WNYf10gzKjOzu153WoDvdi3L
         oCmBjHHRBN94cqL/zGhAQKmk4sM++IZI4f80Aj6CYsbxuMbv+QvH19VHERhV5JpIUxM3
         z9+NsSEm7KOdtGedcUh7gp3Aqmrej/ijs0V3xl0HY06+KqqUqgdkeDICJfzruWrMplrT
         D+a6dl4wIy9/+pi1kLtLZ1swdIhrIOXP6LGXcVt2mHiRu7c3r0db1UB4TwL5xK356l5F
         ypIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWqj0ZNNUeKMDTQiDRFZR5vUfieAnu8qqm9xtfhS8SL5DvjZViY3oVlxYO57qWJJrydfiLxnWOH5A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5wHkOhW+P2gvle0gz8ffJWujS2TmjmTjqRIO2bsc4qG8iH7qI
	OnWmYw+HyTZG06qHPH2ZLCPrGq5Gd30TaEP3bfkLjz9lPW6SjFTRqA8=
X-Gm-Gg: ATEYQzxln0nszk5Ta5uSTk6fzmpOnBfHFO5dOlGDoDH8moHmefO/dZgHcB2AS1Talx6
	S8AEsLHVvQot4RXUiZ7n2oTarMVyKVx6HqVCiBiq5/B2RMLbehweH9E2GS04quhQbroTB2i1Htk
	V5hPsShJhXddKYfP9Oya8CRq1158bK74SjrRnct9Di5/ec5/AQNBmfzxGkJBN5WT7JgIf+5fTvd
	w3H6gIxSwUwy+61X8P3+tCZFZxpLtWT32HW7ABkeiAE/I9CDCJN5tOtxyM9PBGotWJ4YCsXB9VZ
	XyIlzOCda2LtTQZ6um9xlpWtZb4M0IcVBQzAD3bfEUOpWsF5EQ5VZb0Wkc3H5O/gBzR2dLlt8Vy
	cMBcgB671Wt+01QZhEgfjLKXUsZf+ybsTAW5uxJZ9t7tzvw6064bT9QUPB/wdi0/kcsfZXUVKUq
	AA8NUovcx7+8+yEL/Orh7mQld83UpsrAYQdhtCS8/sSgepkVE7xI5rRUmyZ+1HRy/wZzZirExCL
	eQGFC9PjQjVqR5Bdg==
X-Received: by 2002:a05:7300:c89:b0:2c7:ea98:d94 with SMTP id 5a478bee46e88-2c930798501mr2349509eec.2.1775067023492;
        Wed, 01 Apr 2026 11:10:23 -0700 (PDT)
Received: from localhost (c-76-102-12-149.hsd1.ca.comcast.net. [76.102.12.149])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca78dfd323sm404829eec.1.2026.04.01.11.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 11:10:23 -0700 (PDT)
Date: Wed, 1 Apr 2026 11:10:22 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Willem de Bruijn <willemb@google.com>, metze@samba.org,
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>,
	io-uring@vger.kernel.org, bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v2 2/4] net: call getsockopt_iter if available
Message-ID: <ac1fjvVDfatpXwPY@mini-arch>
References: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
 <20260401-getsockopt-v2-2-611df6771aff@debian.org>
 <ac1I_CMr43XTpvHj@mini-arch>
 <ac1Pzt4tpt73SkC6@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ac1Pzt4tpt73SkC6@gmail.com>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12927-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stfomichev@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: A807B37F193
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 04/01, Breno Leitao wrote:
> On Wed, Apr 01, 2026 at 09:34:04AM -0700, Stanislav Fomichev wrote:
> > > +static int do_sock_getsockopt_iter(struct socket *sock,
> > > +				   const struct proto_ops *ops, int level,
> > > +				   int optname, sockptr_t optval,
> > > +				   sockptr_t optlen)
> >
> > If we want to eventually remove sockptr_t, why not make this new handler
> > work with iov_iters from the beginning? The callers can have some new temporary
> > sockptr_to_iter() or something?
> 
> The goal is to eliminate __user memory from the callbacks entirely, which
> would make sockptr_t unnecessary. This series removes the callbacks that
> originally necessitated sockptr_t's existence.
> 
> Therefore, working from the callbacks back to userspace seem to be a more
> logical approach than replacing the middle layers of the implementation,
> and then touching the callbacks.
> 
> So, yes, the sockptr_t() is used here as temporary glue to be able to
> get rid of the elephant in the room.

So maybe something like this is better to communicate your long term intent?

	} else if (ops->getsockopt_iter) {
		optval = sockptr_to_iter(optval)
		optlen = sockptr_to_iter(optlen)
		do_sock_getsockopt_iter(...) /* does not know what sockpt_t is */
	}

?

Then your new do_sock_getsockopt_iter is sockptr-free from the beginning
and at some point we'll just drop/move those sockptr_to_iter calls?
 
> > > +	/* iter is initialized as ITER_DEST. Callbacks that need to read
> > > +	 * from optval (e.g. PACKET_HDRLEN) must flip data_source to
> > > +	 * ITER_SOURCE, then restore ITER_DEST before writing back.
> > > +	 */
> >
> > Have you considered creating two iters? opt.iter_in and opt.iter_out.
> > That way you don't have to flip the source back and forth in the
> > handlers.
> 
> That's a good suggestion I hadn't considered. My initial thought was to
> create a helper like sockopt_read_val() to handle the flip-read-flip
> dance.
> 
> Would opt.iter_in and opt.iter_out be clearer than the helper approach?
> 
> Thanks for the review,
> --breno

I hope this way it will be easier to review protocol handler changes.

For example, looking at your AF_PACKET patch, you won't have to care
about flipping the source and doing the revert. Most/all of the changes will
be simple:
- s/get_user(len, optlen)/len = opt->optlen/
- s/put_user(len, optlen)/opt->optlen = len/
- s/copy_from_user(xxx, optval, len)/copy_from_iter(xxx, len, &opt->iter_in)/
- s/copy_to_user(optval, xxx, len)/copy_to_iter(xxx, len, &opt->iter_out)/

Might be even possible to express these with coccinelle?

