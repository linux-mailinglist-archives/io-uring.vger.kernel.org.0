Return-Path: <io-uring+bounces-12014-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oFWgFIOZgGnL/gIAu9opvQ
	(envelope-from <io-uring+bounces-12014-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 13:33:07 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EE79ACC60C
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 13:33:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3C45B300A33E
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 12:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E701C199D8;
	Mon,  2 Feb 2026 12:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="sbwfSc+2"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779331367;
	Mon,  2 Feb 2026 12:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770035583; cv=none; b=EWvgoLTJeqLSelVxOpkiw0YqINw172tRJZB8XVlMA3VAQLi7E+kbiUqOAgvAsZvoChFOLUYhPxWfa6WH6fLbn7nW1dG5zBOXIxnbZI2UtWZSn05AHexMr3X+ufTr0HFazSPwcV4bNTQ6on2bkNv5FdVYcpFam0wGVFoA6gN2Y14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770035583; c=relaxed/simple;
	bh=KWMLL4urm0ns7PlLWzi7EH+Kwm8E3jgn2wdXT8ZT+aE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ts0yYA80/76dS6SVrcLhh+UC4WGYRJ439y66GlmDmfqxWRQMEMVgrvmI/m29mhf0U5AqU1NFFDwnTzLu8OSXYMzNePkeg7JhYc1IHLyjhyuAkg6eneI3h0mhEIFADh8EmpZjkCAsUaFFUTmqKMQ18dklCfqqJCkxYgthoAkJYVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=sbwfSc+2; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5QJ8PMPVO3aKqXzbgvTxH4Gi/SFovno4AsyKG2b11qI=; b=sbwfSc+2WugGxMUaPDsl5vb11l
	kCOuSzf3HfFbfJAlHS2M6YKAlt4kAC+vZl+X7+8dziJiMDvNvDh9vQIFWe/V/1bFJiJQPwluIIr+z
	/8f63Ca7d/wMw2IiQ/bqcIR+coEyjKBzhA04mBYm/baL439o27utMUBGirFvnlqCS8cjYt5zcYou/
	c1oFINNUrv8Rj+Dy1wyPXou2PavGPzJqiOMtmB2jPL4ft4We+RLEt8QeJWhNxwVIZbdlv052gmqgY
	KrqabnPPeDRr5P2AvhCZv+4/yFRo68kEh/xIi9pxkjafuGu7QzA4rQTQ999YjgJV0fTWyMKX1ZXOh
	UzCQtFLg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vmt6l-0042gj-Iy; Mon, 02 Feb 2026 12:32:47 +0000
Date: Mon, 2 Feb 2026 04:32:42 -0800
From: Breno Leitao <leitao@debian.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, metze@samba.org, 
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org, 
	bpf@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next RFC 0/3] net: move .getsockopt away from __user
 buffers
Message-ID: <aYCUpNyNihhR7no0@gmail.com>
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
 <20260130205227.6fb1d9ad@pumpkin>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130205227.6fb1d9ad@pumpkin>
X-Debian-User: leitao
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_MATCH_TO(1.00)[];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[debian.org];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12014-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EE79ACC60C
X-Rspamd-Action: no action

Hello David,

On Fri, Jan 30, 2026 at 08:52:27PM +0000, David Laight wrote:

> The system call wrapper can do the user copies, it can also suppress
> the write if the value is unchanged (which matters with clac/slac).

This aligns with my proposal: using an in-kernel optlen that protocol
functions can operate on directly:

	typedef struct sockopt {
		struct iov_iter iter;
		int optlen;
	} sockopt_t;

> The obvious change would be to pass the length itself and make the
> return value -ERRNO or the size.

I explored this approach to avoid embedding optlen in sockopt (which was
Linus' original suggestion). I attempted returning the length both via
iov_iter and as a return value, but neither proved ideal.

> #define GETSOCKOPT_RVAL(errval, size) (1 << 31 | (errval) << 20 | (size))
> which would get picked in the rval < 0 path.
> It would also let 'return 0' mean 'don't change the size' requiring
> a special return for the one (or two?) places that want to set the
> size to zero and return success.

My conclusion is that encoding both optlen and error in the return value
requires pointer manipulation that isn't justified for this slow path.
While technically feasible, the resulting "mixed pointer abomination"
won't be worth it.

> There is not much point making the 'optval' parameter more than
> a structure of a user and kernel address - one of which will be NULL.
> (This is safer than sockptr_t's discriminant union.)

This approach forces every protocol to distinguish between userspace and
kernelspace, then perform the appropriate copy:

  static inline int mgetsockopt(void *kernel_optlen, void *user_optlen, ..)
  {
	....
	if (kernel_optlen)
		memcpy(kernel_optlen, newoptlen, ...
	else
		copy_to_user(user_optlen, newoptlen, ...
  }

Additionally, you'd need safeguards ensuring callers never pass both user
and kernel pointers simultaneously. This seems significantly worse than
using sockptr.

--breno

