Return-Path: <io-uring+bounces-12926-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +FbqOW9dzWkRcQYAu9opvQ
	(envelope-from <io-uring+bounces-12926-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 20:01:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1826A37EF57
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 20:01:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0698530CE721
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 17:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6415A478E2C;
	Wed,  1 Apr 2026 17:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="oDuLf1ZQ"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0F71D7E41;
	Wed,  1 Apr 2026 17:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775065426; cv=none; b=bPT4FZvrtarqmbPGi0zVbZ6cOE+PKrxhX97Jf9/wtMLy7EQTDn8iFXkw0rWO0K2OdoqktndvKrKYkuLpibguNkuKVvTVovS0Ut+9tuNXYVCXDYS0qrTdd9Cw7XF0Y1AAnJbDfm3etD9gV9YMhIzs3knQ8pWF/0us9blAnq/YAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775065426; c=relaxed/simple;
	bh=jf/+fqzmXNiUBaLm7xRsAlJNstHg9Cqyf+RSomUr0h0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=upvwUjEod+fieV078i0fRro9qspm0UxwGS9fAKVqifOrTwXYTlXFA1UMEXccWM/968XvifbPp01zq78PFW0FbSRgGbv4lkI5+q5gfO89NijF2ninezLhAHfw88mK+Xvc06Z2fIx5deUhpZAGSlDqUeOF++UEVqc+SkE7ksg/7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=oDuLf1ZQ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gDvOqA3KegP64c2/sDFkov6sRayaEdrePMAGlwCEHm8=; b=oDuLf1ZQtZDyyybFJbzqYety9Z
	9/ya58lJZKD2xLRf9HfIz5Y6bRXU2tEmPrBaGgZBnq/CKfP6VjEXokgKwQqA16MPZvRXZC6V9D69x
	vIOhE2PvvF2+FGKMOJA3Iv4oZdnenA6Op8CuyPj5vHiC6VdO+Uz1690aDjC1q3tIBdakZRztojkwP
	70vMqbI498ud0HOvzJlzR4WOqO4iCasWfRr0QSP+NcKla81pYffBSqrY+UrwMfJ06LHHkYzYsJ1dA
	7te7o3LaeaTdrH++RxN0c6pCVf/MXWHi/ggnDS1p8ca7kYK2i9oXCuC0hlUHuI/6iFuMzN9jVmy6X
	eTrYm98w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7zbI-0039mm-2z;
	Wed, 01 Apr 2026 17:43:31 +0000
Date: Wed, 1 Apr 2026 10:43:26 -0700
From: Breno Leitao <leitao@debian.org>
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, metze@samba.org, 
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org, 
	bpf@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v2 2/4] net: call getsockopt_iter if available
Message-ID: <ac1Pzt4tpt73SkC6@gmail.com>
References: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
 <20260401-getsockopt-v2-2-611df6771aff@debian.org>
 <ac1I_CMr43XTpvHj@mini-arch>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac1I_CMr43XTpvHj@mini-arch>
X-Debian-User: leitao
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_RHS_MATCH_TO(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_NA(0.00)[debian.org];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12926-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1826A37EF57
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Apr 01, 2026 at 09:34:04AM -0700, Stanislav Fomichev wrote:
> > +static int do_sock_getsockopt_iter(struct socket *sock,
> > +				   const struct proto_ops *ops, int level,
> > +				   int optname, sockptr_t optval,
> > +				   sockptr_t optlen)
>
> If we want to eventually remove sockptr_t, why not make this new handler
> work with iov_iters from the beginning? The callers can have some new temporary
> sockptr_to_iter() or something?

The goal is to eliminate __user memory from the callbacks entirely, which
would make sockptr_t unnecessary. This series removes the callbacks that
originally necessitated sockptr_t's existence.

Therefore, working from the callbacks back to userspace seem to be a more
logical approach than replacing the middle layers of the implementation,
and then touching the callbacks.

So, yes, the sockptr_t() is used here as temporary glue to be able to
get rid of the elephant in the room.

> > +	/* iter is initialized as ITER_DEST. Callbacks that need to read
> > +	 * from optval (e.g. PACKET_HDRLEN) must flip data_source to
> > +	 * ITER_SOURCE, then restore ITER_DEST before writing back.
> > +	 */
>
> Have you considered creating two iters? opt.iter_in and opt.iter_out.
> That way you don't have to flip the source back and forth in the
> handlers.

That's a good suggestion I hadn't considered. My initial thought was to
create a helper like sockopt_read_val() to handle the flip-read-flip
dance.

Would opt.iter_in and opt.iter_out be clearer than the helper approach?

Thanks for the review,
--breno

