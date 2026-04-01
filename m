Return-Path: <io-uring+bounces-12923-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ULWpAOhJzWn4bQYAu9opvQ
	(envelope-from <io-uring+bounces-12923-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 18:38:00 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F42B37E032
	for <lists+io-uring@lfdr.de>; Wed, 01 Apr 2026 18:37:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 163DF3006467
	for <lists+io-uring@lfdr.de>; Wed,  1 Apr 2026 16:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D025B3CCFD8;
	Wed,  1 Apr 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bVZAsx50"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD83A6F19
	for <io-uring@vger.kernel.org>; Wed,  1 Apr 2026 16:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775061247; cv=none; b=OrqCZ8A5eV7K4bFIByB8VYo8a8H+xRo7NZ03cQKJJHULdam0HGh7UFw98EUNeITDo8r00zNDA2GHqfDFa+ZYu//833XpF8F51nZWAat0SjBwDreJg1Soq4RsEwKE4yHnAPFznURsCNIBQz6poSj+ntBtswK15/ehFlgUOcxqSfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775061247; c=relaxed/simple;
	bh=+OcjdzbsVS5n2WpHiH5AzE1B2okZQS9quvYX7YODvQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LiX1QcmRrDespPkMcMs4g5pbQiIzdtVhiM/8xTf5EbpNH+AbjqN3rN3U3rVJgDsH7TI+UvPUcY1AEWl2/qcobTTRooNFCXgcMrThoUGBR4IKI89G51i4Ea/gT1Ff/YUYyPTAH+6aJD8yVR2ziNBQNfoqsAcLk7nk2JNs/oSII58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bVZAsx50; arc=none smtp.client-ip=74.125.82.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-2b6b0500e06so9643935eec.1
        for <io-uring@vger.kernel.org>; Wed, 01 Apr 2026 09:34:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775061245; x=1775666045; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zdMpVTZuf6oWX3f0mlEuicX/hJ4K7vnvO6vekEBOAm0=;
        b=bVZAsx50sgRISknFsJkBzeV0zBAw/Td1rUgrckv4kS0tndO45oAUoyNzfq0iBHX56b
         mIRSSOaoVvcM2Xjb1jUm0o34D03dY7xyaRhiXKeBujDJ3C6FaoMMs9S7JQExVOqcBD4E
         sqgTRR8Bih3BuCjEACOhVzJ072pPZHP85/4XcBNSYdCkWtJ57r6OApIIIsukNcSaNeeU
         mN/qjEcNOHCCJAZZcrAuS0Jk/gtTlUhyDWp4VWXv2ySh0XEUJ4NWN1EEbK9fyvG8aJq0
         D6IQ3QWq2U5rqWk0ZpMmG+bNt8OF8lQfz9TxygSC4gcOlXxAOHsl9/teDY6dS8d4Yf3/
         NuhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775061245; x=1775666045;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdMpVTZuf6oWX3f0mlEuicX/hJ4K7vnvO6vekEBOAm0=;
        b=b4capUwQvNKIb2PTxOR64Wj5RYSQU7uHJjwJ0GUKWZb0//PUiU3qz5DCYUHdtNaOue
         kqmLCCsPQIjU/p7zu7lmcoqiOds6EZ9yrJlGDnqI7NNuD8hOyBV0hPtN4zi7v6lySBpI
         wr6Avv6dVjKWQ8u8vBwvJgrFFtfPhAqJG7EkQuR8cUG9FodzjXSHSPWJvBVAR0knqUPj
         KoBdWokTHJpRYsIrMcJiInTyhbNoEJzCS8EFB6A1GaxjQJlhnd6XHe/QuIiYt62lp4Nx
         6SRaMsIduPIO4fO+U0BK+o8IdZjwG40fZliafA8ZKQpH+sLbvJvEmaCWl78pcsbN732/
         hpuw==
X-Forwarded-Encrypted: i=1; AJvYcCWfpj3JX5pqgN/aKo2SkIEiINmvB1y78u6p9Erfq+jKH1V1B0nWvLEIb+fg0ri3WC/r9lHmSbKl1w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwWcy0FrQJEWIIb3UPWzUYeQtQn31VgcU1kJpi99xTC2Mxbx1Dq
	S8iq+MuTlYpR0Pejt/JPXLNfCL3FuozUcCfuOl7h2YKHXBwJCwZnTIg=
X-Gm-Gg: ATEYQzw2w6d9tQeXuffYq3MnrCZ6EiZhCtMPhBx82LRNutgun/2U8IjkfFFkvjbuF42
	SQqjyCHbkaY/WXAZ4eZIDcEfN+23ascCtljYiKqJ4iL6/lcm+cf7mkPpAoKtvg/wLtaNEtpbg8L
	DtOY3rAE8GQKyIenmAkL7vGUxZTxpjt8y0d05qWrE7k4w6kGuVccpAdho7BYmqvCctsxyw207vY
	gbU77bCRCdGxWVMapvRSzXns5sFIevUUiQZnpLKFzooG1B2SoXnf8lJwxE5Lsz5U6QoWUt8ovnR
	1xkbVrMs1cP3Me2auMb1vyblipjlhC6OQkhuumEAkU5EWPmXpoBiqz5XHwk4BauSROy6EcpngdN
	55mN6wk260FbHVFIYb6TrfF81fQHzWO6VFRreZur5KeFEhRziBgqY2rw3FVPIJ6h0v9Ebkwl+/v
	u8v8ZnFL+tTppEwblk+6CCIAIoeoA84SCvTJGUGkkR45yZqXKStdpuV69k8pIBsAh+9Y075BCua
	BzPsomIi8embfIi83kRV2Exz5Um
X-Received: by 2002:a05:7300:fd13:b0:2c1:161f:ac39 with SMTP id 5a478bee46e88-2c9325b1fddmr2057364eec.26.1775061244975;
        Wed, 01 Apr 2026 09:34:04 -0700 (PDT)
Received: from localhost (c-76-102-12-149.hsd1.ca.comcast.net. [76.102.12.149])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca7c3010e9sm237887eec.14.2026.04.01.09.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 09:34:04 -0700 (PDT)
Date: Wed, 1 Apr 2026 09:34:04 -0700
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
Message-ID: <ac1I_CMr43XTpvHj@mini-arch>
References: <20260401-getsockopt-v2-0-611df6771aff@debian.org>
 <20260401-getsockopt-v2-2-611df6771aff@debian.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260401-getsockopt-v2-2-611df6771aff@debian.org>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12923-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_TRACE(0.00)[gmail.com:+];
	MISSING_XM_UA(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[stfomichev@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: 9F42B37E032
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On 04/01, Breno Leitao wrote:
> Update do_sock_getsockopt() to use the new getsockopt_iter callback
> when available. Add do_sock_getsockopt_iter() helper that:
> 
> 1. Reads optlen from user/kernel space
> 2. Initializes a sockopt_t with the appropriate iov_iter (kvec for
>    kernel, ubuf for user buffers) and sets opt.optlen
> 3. Calls the protocol's getsockopt_iter callback
> 4. Writes opt.optlen back to user/kernel space
> 
> The optlen is always written back, even on failure. Some protocols
> (e.g. CAN raw) return -ERANGE and set optlen to the required buffer
> size so userspace knows how much to allocate.
> 
> The callback is responsible for setting opt.optlen to indicate the
> returned data size.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  net/socket.c | 48 +++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 45 insertions(+), 3 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index ade2ff5845a0..4a74a4aa1bb4 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -77,6 +77,7 @@
>  #include <linux/mount.h>
>  #include <linux/pseudo_fs.h>
>  #include <linux/security.h>
> +#include <linux/uio.h>
>  #include <linux/syscalls.h>
>  #include <linux/compat.h>
>  #include <linux/kmod.h>
> @@ -2349,6 +2350,44 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
>  INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
>  							 int optname));
>  
> +static int do_sock_getsockopt_iter(struct socket *sock,
> +				   const struct proto_ops *ops, int level,
> +				   int optname, sockptr_t optval,
> +				   sockptr_t optlen)

If we want to eventually remove sockptr_t, why not make this new handler
work with iov_iters from the beginning? The callers can have some new temporary
sockptr_to_iter() or something?

> +{
> +	struct kvec kvec;
> +	sockopt_t opt;
> +	int koptlen;
> +	int err;
> +
> +	if (copy_from_sockptr(&koptlen, optlen, sizeof(int)))
> +		return -EFAULT;
> +
> +	if (optval.is_kernel) {
> +		kvec.iov_base = optval.kernel;
> +		kvec.iov_len = koptlen;
> +		iov_iter_kvec(&opt.iter, ITER_DEST, &kvec, 1, koptlen);
> +	} else {
> +		iov_iter_ubuf(&opt.iter, ITER_DEST, optval.user, koptlen);
> +	}
> +	opt.optlen = koptlen;
> +
> +	/* iter is initialized as ITER_DEST. Callbacks that need to read
> +	 * from optval (e.g. PACKET_HDRLEN) must flip data_source to
> +	 * ITER_SOURCE, then restore ITER_DEST before writing back.
> +	 */

Have you considered creating two iters? opt.iter_in and opt.iter_out.
That way you don't have to flip the source back and forth in the
handlers.

