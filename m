Return-Path: <io-uring+bounces-13019-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAv1Morw2GkDkAgAu9opvQ
	(envelope-from <io-uring+bounces-13019-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 14:43:54 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 50FDF3D78E0
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 14:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8716C3121BC5
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 12:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 648F33C4565;
	Fri, 10 Apr 2026 12:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="c+ByTDIu"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD4B3C13FD;
	Fri, 10 Apr 2026 12:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775824201; cv=none; b=UsA6S/u+/scqriHSXgSXm05Cn5wnJ3Ba4hD5NHHo7IXoVPHnHOZtWJ+gba9AlnA4BaKzVUmpLgPX6CZI0mD2yTsG30ji14u53cj5AqKeSQtnBKJ6TPAWEeHSKjOSqSLkoCbyot1r6BsuydpCFbOEXOsK/yRX0H1fUHPzQmh5nkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775824201; c=relaxed/simple;
	bh=WPubJfES7p4gvWPDzr4zZPy0LuQA5OuWC1+cg1hyJtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ik0BH+HyxXp4T5zUwl8eDZzXIG0m9xqCZHlau5f3s64l0c4TxJhyHwZEQb4bDIWV2iUdsSkNMV9HVYXNrG2+7PeO/fAmBhBEjJWVw1M8AWjf8EeYqrv6h6E5TZIyeztJ1C7lVP9FGanAwLqdjSxOZeJFlD8Y1IuavzIcJ9F3R0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=c+ByTDIu; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=wmoBkrzxhzQLQSgXC9e4/Z5v1th8/1neJXocPsENlU8=; b=c+ByTDIukWwFz+5S4k5nnLaLVY
	Vw2NDoLq+dLe6QfQqzYg/QdVJVHjYQBB0svul21f4GLpRjqDcbpIHDCZDZFU3j4YWniJQbR1xA2Z+
	0sfibxpTrB0H3t76q/qItnKluGTGS9lLw1dqNhHGNjxmQFeVRuHTDrqlds3n2xhLOaDmQjyr48bwt
	0UrS1wc9qhRN+Vbyq6CILEnC1fbcUexI6yZvTg4d8okZIiayjjlSBkYDriXKwqNWFF4nt+iR12QuW
	5yNJYr/PZ/UnqQ24TovrO5tlOk5SvWtDeV9Tfbu+I6Z7CkSVdwuER/INmPOlBCxZfjEZQXAeOBjKs
	LLpLUdaQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wBAzX-009yhN-03;
	Fri, 10 Apr 2026 12:29:43 +0000
Date: Fri, 10 Apr 2026 05:29:37 -0700
From: Breno Leitao <leitao@debian.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, metze@samba.org, 
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org, 
	bpf@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
Message-ID: <adjkn7p4U13WBs2o@gmail.com>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
 <20260408122653.295953dd@pumpkin>
 <adZcnNgxhsUjAgZW@gmail.com>
 <20260408195640.324ee932@pumpkin>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260408195640.324ee932@pumpkin>
X-Debian-User: leitao
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_MATCH_TO(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13019-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[debian.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 50FDF3D78E0
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 08, 2026 at 07:56:40PM +0100, David Laight wrote:
> On Wed, 8 Apr 2026 06:52:54 -0700
> Breno Leitao <leitao@debian.org> wrote:
>
> > Hello David,
> >
> > On Wed, Apr 08, 2026 at 12:26:53PM +0100, David Laight wrote:
> > > On Wed, 08 Apr 2026 03:30:28 -0700
> > > Breno Leitao <leitao@debian.org> wrote:
> > >
> > > > Currently, the .getsockopt callback requires __user pointers:
> > > >
> > > >   int (*getsockopt)(struct socket *sock, int level,
> > > >                     int optname, char __user *optval, int __user *optlen);
> > > >
> > > > This prevents kernel callers (io_uring, BPF) from using getsockopt on
> > > > levels other than SOL_SOCKET, since they pass kernel pointers.
> > > >
> > > > Following Linus' suggestion [0], this series introduces sockopt_t, a
> > > > type-safe wrapper around iov_iter, and a getsockopt_iter callback that
> > > > works with both user and kernel buffers. AF_PACKET and CAN raw are
> > > > converted as initial users, with selftests covering the trickiest
> > > > conversion patterns.
> > >
> > > What are you doing about the cases where 'optlen' is a complete lie?
> >
> > Is this incorrect optlen originating from userspace, and getting into
> > the .getsockopt callbacks?
>
> Look at tcp_ao_copy_mptks_to_user() in net/ipv4/tcp_ao.c
> This isn't 'old code' it was added in 2023.
>
> Basically what is being transferred is an array and 'optlen' is the
> size of one element.
> The number of elements is in the first one.

Thank you for pointing this out. I now understand the issue you're raising.

The problem is that optlen doesn't represent the full buffer length. Instead:
	optlen = per-element struct size (stride)
	actual buffer length = optlen * nkeys (where nkeys comes from optval[0])

For handling these cases, I can think of several approaches:

1) Dynamically resize the iter once the actual buffer size is discovered:

  int sockopt_set_buflen(sockopt_t *opt, size_t new_len)
  {
      if (!opt->legacy)   /* Following Stefan's suggestion */
	return -EINVAL;

      /* Re-initialize iter with the actual buffer size.
       * For ubuf: same base pointer, updated count.
       * For kvec: same iov_base, updated iov_len + re-init.
       */
  }

This allows legacy protocols to adjust the iov_iter later, mirroring
current behavior. Note that this doesn't worsen the existing
situation—currently, the current code is like having iov_iter length is
set to INT_MAX, given the callback can read/write to any location based
on that __user pointer.

2) Use a special legacy callback path, as proposed by Stefan.

3) Store base pointers in sockopt_t and defer iter initialization for
   legacy callbacks:

  static int tcp_ao_copy_mkts_to_user(const struct sock *sk,
                                    struct tcp_ao_info *ao_info,
                                    sockopt_t *opt)
  {
        struct tcp_ao_getsockopt opt_in;
        int user_len = opt->optlen;
        struct kvec kvec;

        /* First, initialize a small iter to read the first element */
        sockopt_init_iter(opt, user_len, &kvec);

        if (copy_from_iter(&opt_in, user_len, &opt->iter_in) != user_len)
                return -EFAULT;

        /* Now we know the actual buffer size */
        sockopt_init_iter(opt, user_len * opt_in.nkeys, &kvec);

        /* ... write the full array via copy_to_iter() ... */
  }

4) Maintain two separate callbacks: ->getsockopt_iter (to be renamed to ->getsockopt
   after the transition) and ->getsockopt_unsafe for legacy cases.


Regardless of which approach we take for these legacy implementations, I don't
believe any of them invalidate the current patchset from a design standpoint.

Since these legacy protocols represent less than 1% of the cases, I'd prefer to
optimize for the common path and handle the exceptional cases as exceptions.

