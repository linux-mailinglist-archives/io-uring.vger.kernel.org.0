Return-Path: <io-uring+bounces-13020-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YKChA+jz2GlJkAgAu9opvQ
	(envelope-from <io-uring+bounces-13020-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 14:58:16 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A6CF3D7C92
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 14:58:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 33462301E226
	for <lists+io-uring@lfdr.de>; Fri, 10 Apr 2026 12:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A611E224B1E;
	Fri, 10 Apr 2026 12:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="qKtFLnER"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2C919CD1D;
	Fri, 10 Apr 2026 12:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775825596; cv=none; b=eO9+IWyvmhDt1SdhC4xA7zjV2dGAKhM+1pLNl8XE6ncL5NKPpHYHFsrnsfMq8naWvkEU9BMIbDb/YxDW1b8F1ZKN24ryZcOOyPsIMOs22FF1RwOPnfyX7r92Vy28MadPx/X37GzfSVSZh8GEJmK0CWOrC7vh7XgsElkiEHkxPyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775825596; c=relaxed/simple;
	bh=78eO/RhEGzQ7R+UACmqqoYhNnqZ+OTIjMLHiGzmZez4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uEA4hbggTOI3ELkplXQj2bssj3ifFwBn7Q+6ZltBp16V4dJJTHv3heDPKeZId4Xk6sZI+u2kGQEGs+xGCrD5I/NwXTWhv2FWvArl6PKsq57cpFg3EP9Bv0WgbubGVczAD7Sc2qX9UHASlPPZbqZv7W1imZgNoeOtaM3wMSyu+Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=qKtFLnER; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pjl+6brdGuCJE8FILPe3GaAjxEZMhkcWUKGm+oI58gg=; b=qKtFLnERmT1d15r7x1DF3Gqjmu
	U4sXEw52jSln3OqBiudR8SK6+/CsPdksjxEbsrd3z28jkxN3q+Q4ByNKB7j8tLyuJFqJfQOIou8XF
	VR4apM88VPV6AsFQY6DFCEu4OF3y3pdYixvsgEtqpNu9YUCvegOnU1QcD+szIgsbaDwpEst8fLW67
	tQQCciOSEPn8+dJ7/khhbVzMQWyGRbtITDoWfkhDgPrY0XxSLFu+f3+BMwcUPMOoEgVj6YKVOKoNw
	eMsIGJhFs8cgxRwZOBWdD//zPWFEvMnRLvhbeU7X/Ag8v2SIGriC9l/e//XnG4t/pEBVH2Nr+hLUR
	NkUkBxFQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wBBM4-009zVc-2F;
	Fri, 10 Apr 2026 12:53:01 +0000
Date: Fri, 10 Apr 2026 05:52:54 -0700
From: Breno Leitao <leitao@debian.org>
To: Stanislav Fomichev <sdf.kernel@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>, metze@samba.org, 
	axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>, io-uring@vger.kernel.org, 
	bpf@vger.kernel.org, netdev@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
Message-ID: <adjvoD9f7QaQMu5K@gmail.com>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
 <adaJqy6Q4L7c-eTs@devvm17672.vll0.facebook.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaJqy6Q4L7c-eTs@devvm17672.vll0.facebook.com>
X-Debian-User: leitao
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_MATCH_TO(1.00)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13020-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[17];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 6A6CF3D7C92
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello Stanislav,

On Wed, Apr 08, 2026 at 10:02:36AM -0700, Stanislav Fomichev wrote:
> On 04/08, Breno Leitao wrote:
>
> LGTM! Not sure what's your plan for the selftest? You wanna keep it
> outside or maybe repost v4 with it?

I'd be glad to include a selftest. I've already developed one covering both
protocols in this series and can respin with it if you'd like.

Test available at:
https://github.com/leitao/linux/commit/2d9311947061f1baa43858f597dd6c54d7ccc5d2

> Acked-by: Stanislav Fomichev <sdf@fomichev.me>

Thanks for the review and guidance.

> I'm also not sure your unconditional 'copy-optlen-back' will work for every
> proto, but I think we can put something into sockopt_t to make it avoid
> the copy if needed in the future.

Good point. I'd prefer not to over-engineer this now, but keep it
straightforward to add later if needed. This could be easily achieved with
something like:

  typedef struct sockopt {
        struct iov_iter iter_in;
        struct iov_iter iter_out;
        int optlen;
+       bool optlen_dirty;      /* set by callback when optlen should be written back */
  } sockopt_t;

Wrapper becomes:

  if (opt.optlen_dirty &&
      copy_to_sockptr(optlen, &opt.optlen, sizeof(int)))
        return -EFAULT;

and the protocol callback would need to set

   opt->optlen_dirty = true;

I don't think this is needed yet, and if we do need it, it would be better
to review and commit them together, making the rationale clearer for
future developers/LLM agents.

What do you think?

Thanks,
--breno

