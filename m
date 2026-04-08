Return-Path: <io-uring+bounces-12991-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8G+cCBFe1mkPEwgAu9opvQ
	(envelope-from <io-uring+bounces-12991-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 15:54:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 630F03BD3C1
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 15:54:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 361B3300A107
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 13:53:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD45D3ACA64;
	Wed,  8 Apr 2026 13:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="BsbwxuWZ"
X-Original-To: io-uring@vger.kernel.org
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F234335063;
	Wed,  8 Apr 2026 13:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656396; cv=none; b=A/O26ApV+zNbVCPnVDs6xzrIwpFLYZB0ILoAH/xukPjBusfCE/uxih3XNJ+3RapTdljidjE7mUCUel/hCawv71MBZkUwGtqJ8A17FI5TS15K+IM5GAuivB8dsT8ytSNDODKB+RZuho0fSBnHmz39f5DtDdcb/MyhHv6NXR6ZORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656396; c=relaxed/simple;
	bh=DTnM4htd2Jjkwqs+F8r4cTsjWbrzp3I5U6vPySVzAWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HtmvQFtUnbWiJi05E3+vcweYC6XgnH3G0S+7XOPTceraYuVFctFDYdi8gPKYClAidhqFvhzrm8uoDj5LPIBpnz/AYFy61TM9sWoR8kbUewJysuxQb7ufcxyGj4ifKAnJzWbLF1Flq/oiScgS0tZkBrfP6kDrMng7ocJ364rGZoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=BsbwxuWZ; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CesSAmwyidYzb8uUCTfS3iRACJpDJ6KIJkWaYpu5Tfc=; b=BsbwxuWZuch7f8xqe+sewtPCT/
	CuQnsrKJfqcfjZvNScSy8ZOW1W+2u5zHkiNfZTX5UVZtOkfJ4beAJ+vFqK7zpkbpSXJBNhn5pTwV0
	WWxXG3WV7msGudWrXp5hemS5xTmvnPoQmgYGit4fnw2J46zlacf+jAWTnuJl13ba+PxrabN8JOZ7p
	tssiDQ/Nj2wlTGV8Hh707kZBJwSzxRPb/FlZPeUMIDBIaQ+6WG6UiPGMeBdRjzZBNe0fYGykyW6/T
	DC5Thk2SJkxqr2aQnQ8v5TLSGe7PCwXk0TJwOsfwkQSuxqYJFMp/JDZGf2OFyc4rr53G4l8UpECYe
	okYO2v9w==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wATL1-008T07-2N;
	Wed, 08 Apr 2026 13:52:59 +0000
Date: Wed, 8 Apr 2026 06:52:54 -0700
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
Message-ID: <adZcnNgxhsUjAgZW@gmail.com>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
 <20260408122653.295953dd@pumpkin>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408122653.295953dd@pumpkin>
X-Debian-User: leitao
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_MATCH_TO(1.00)[];
	R_DKIM_ALLOW(-0.20)[debian.org:s=smtpauto.stravinsky];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
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
	TAGGED_FROM(0.00)[bounces-12991-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[leitao@debian.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[debian.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 630F03BD3C1
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hello David,

On Wed, Apr 08, 2026 at 12:26:53PM +0100, David Laight wrote:
> On Wed, 08 Apr 2026 03:30:28 -0700
> Breno Leitao <leitao@debian.org> wrote:
>
> > Currently, the .getsockopt callback requires __user pointers:
> >
> >   int (*getsockopt)(struct socket *sock, int level,
> >                     int optname, char __user *optval, int __user *optlen);
> >
> > This prevents kernel callers (io_uring, BPF) from using getsockopt on
> > levels other than SOL_SOCKET, since they pass kernel pointers.
> >
> > Following Linus' suggestion [0], this series introduces sockopt_t, a
> > type-safe wrapper around iov_iter, and a getsockopt_iter callback that
> > works with both user and kernel buffers. AF_PACKET and CAN raw are
> > converted as initial users, with selftests covering the trickiest
> > conversion patterns.
>
> What are you doing about the cases where 'optlen' is a complete lie?

Is this incorrect optlen originating from userspace, and getting into
the .getsockopt callbacks?

> IIRC there is one related to some form of async io where it is just
> the length of the header, the actual buffer length depends on
> data in the header.

Could you point me to the relevant code so I can examine this case?

> This doesn't matter with the existing code for applications, when they
> get it wrong they just crash.

Is this crash being triggered by the protocol callbacks?

I tried searching for this but couldn't find it. I'd appreciate any
hints you could provide about this case.

Thanks
--breno

