Return-Path: <io-uring+bounces-12002-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EJONJBU2fWkuQwIAu9opvQ
	(envelope-from <io-uring+bounces-12002-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 23:52:05 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FCDBF399
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 23:52:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5755C3001F90
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 22:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33B6A359FA4;
	Fri, 30 Jan 2026 22:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UBuum1Km"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5213358D38
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 22:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769813521; cv=none; b=pFrRQC33rNQ4A5LWdD6ReVvDO1Oummo4eb/cHgVNOtkzdDN3UDV6zJ1cyTInF/v95CKVHLNiRbaNfcbNsAmRyxDE0f3bqD5zRzN8O+4gS/wsslOAQ3G/fFFy37C12rP9zhbn8eGDN6DOTvoM2TfY+g8X9K3haxnyjUrnvEBWhEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769813521; c=relaxed/simple;
	bh=KcUQ1q2ALIp6GQbsuyiFX7GWULQTAiWrMXNKUDp6gDA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kkdMtmPgyuYBqKgKUSBNlgUun/vtTqps+eCZk3fh6xY2/aYXLnqiNKZrgl5OzjnxP3ajXUd4TZX7T+20+ToYofK2Gk3P9HsihwvvwEiBK+V9lIjhNlHwR4/PFVQIODCoB2j7M8AFFzCGa6bbz4WnZjY2vw0ez1PEB77fMRDjPF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UBuum1Km; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-385c6c727fcso25116241fa.3
        for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 14:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769813518; x=1770418318; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZkVCe2Fm0X1zwm2m79SvkIhPjHfte2ufPAVZoEONEas=;
        b=UBuum1KmS9tiL6vqWLWPTjVlobULd3p9mqcch58HHMBuzMbU7j52fZ/IErxZl/oZmv
         O86P8LYvk8F6s9MHUO9h3UyaYe7orrxMTvNopn4CqxS/Ox3faV0AIGYPhKdrHRmL5jse
         YStpseRYpnGx4sSPVfU/n24mXW/tz/g737go6xx9KSGMGgS8jBCWwui222CfbaMz/5Ch
         h1HrrFwR7m4p+mltEeUOAml+z1khtZlGArtyI4hzH5ZZYws4qIXnbfMTC5086bWsGdvF
         nbl83qdcdO1Q60QRY42xerVxVhGMx6pDTKwlEiG3kThxYMZNr2P9yr+EyZKKfDjucZd9
         ts2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769813518; x=1770418318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZkVCe2Fm0X1zwm2m79SvkIhPjHfte2ufPAVZoEONEas=;
        b=PKQZ527i6O5ZykfUU5b4DsVwDnUa1CHVMo1+2+CIf/04NNexT7wBQS4SZJXG6MBHXO
         YqfUk8yqszofEJTUnrvl+BamOPRGYZOgJSqMS7R8JWwFD5MFxkgGSTwG+WCmyjV+c8dc
         gxzey17oc9G/D7dQwXxYgV/uftqMbr0gJsa9m9itc8eqKm6GOc1joamkoH7OfD5stgIG
         PebBByFJFzRvcBY+JHgYm5No7+Da5cMqrc/b/dx6+/lxKBUSQkVw/86zmeWiKtDuuJKr
         yciGmHqcMrtFvWl+qzJxIf7KoFb0+d2sXK0YHvbu9WtfMynWxyyHt9V3EP9Ki4QbPIP4
         bJ7A==
X-Forwarded-Encrypted: i=1; AJvYcCVnfAa0uxr1kMKa3Tz7iU+6conomE3nPztmBh9o/c5D1Y2HWjtJGxzhFb/BDAo0wdS2WHktoLTBcw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbVldd/4UF5iTSMApRuLtDdiq8pmeyop3K0B9GF4gZNqBlWEz5
	2yt+IOr96/qEv7Clhy6vFfW+d2s4MCQpNgL8rUfH+RXazt2DcgMgOZu1n35+HQ==
X-Gm-Gg: AZuq6aK/Sg+Zg3GPmbrL8h4Lqb0z+rD+OLaixM7Z7VAPDhVMbI0neAifUNEXjWDReUG
	FmzVDG0ph28If0rUG7+xBGaC7hk7WcfGikTdB4JPiCyGCQhCTIz6xlY7FTZ1c9UcurbTUwNr+67
	zaQoU7yLOu7v08h97wxWYQuK9//iEv5I7/+r+9hqwYiY56k7WxpHGYzEpXIwLoj9lF1ATYR5w2E
	A9lKR40Ui8o6NKFVGZJUof0mmo89qBIXgOEUVhr3hcpt5Zxx1g0bqApXuLKbg7XOgLzx+f1yrRg
	MiPdCViPM1V8ydLHfrb7jEA9lcGt6ZqCRpTO5gWF1H/zwR4SgCct+s0UCbTopdPpmiKFKRGoo+A
	z9KVd3wGL0Owv7r2WDnwtV9diIAC5pTTI6EnFFNREvzmn21WEcTf6UmKvDSyk4jA2ne015fv944
	KnwX4xjQgAq5RxkjjGaAjkvebYCtEqDUkUAjyjV1+jyJj7dQfZ3BXe
X-Received: by 2002:a05:6000:2004:b0:42f:b690:6788 with SMTP id ffacd0b85a97d-435f3a6baa6mr6239935f8f.10.1769806350269;
        Fri, 30 Jan 2026 12:52:30 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-482e267aad1sm21831845e9.15.2026.01.30.12.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jan 2026 12:52:29 -0800 (PST)
Date: Fri, 30 Jan 2026 20:52:27 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Kuniyuki Iwashima
 <kuniyu@google.com>, Willem de Bruijn <willemb@google.com>,
 metze@samba.org, axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>,
 io-uring@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next RFC 0/3] net: move .getsockopt away from __user
 buffers
Message-ID: <20260130205227.6fb1d9ad@pumpkin>
In-Reply-To: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12002-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C3FCDBF399
X-Rspamd-Action: no action

On Fri, 30 Jan 2026 10:46:16 -0800
Breno Leitao <leitao@debian.org> wrote:

> Currently, .getsockopt callback cannot be called with kernel buffers
> because it requires userspace addresses:
> 
>   int (*getsockopt)(struct socket *sock, int level,
> 		    int optname, char __user *optval, int __user *optlen);
> 
> This prevents kernel callers (io_uring, BPF, etc) from using getsockopt
> on levels other than SOL_SOCKET, since they pass kernel pointers rather
> than __user pointers.

I had thoughts about this as well.
I think using iov_iter is over the top and may have measurable performance
impact for some paths.

I think the first thing to do is sort out 'optlen'.
There is absolutely no reason for the user pointer being passed into
all the per-protocol functions.
(and the code that changes that use sockptr_t are just stupid...)
The system call wrapper can do the user copies, it can also suppress
the write if the value is unchanged (which matters with clac/slac).
The obvious change would be to pass the length itself and make the
return value -ERRNO or the size.

The annoyance is the few places that want to return an error and
change optlen.
That might be best addresses by something like:
#define GETSOCKOPT_RVAL(errval, size) (1 << 31 | (errval) << 20 | (size))
which would get picked in the rval < 0 path.
It would also let 'return 0' mean 'don't change the size' requiring
a special return for the one (or two?) places that want to set the
size to zero and return success.

The length passed should also be 'unsigned int' - with a check for
negative values in the system call wrapper.
(There are many broken drivers that treat negative lengths as 4.)

There is not much point making the 'optval' parameter more than
a structure of a user and kernel address - one of which will be NULL.
(This is safer than sockptr_t's discriminant union.)
You can't police the length because it is sometimes only the length
of a header (and in some recent code as well).

I have looked at some of this change - it is enormous.

	David


> 
> Following Linus' suggestion [0], this series introduces a wrapper
> around iov_iter (sockopt_t) and a temporary getsockopt_iter callback:
> 
>   typedef struct sockopt {
> 	  struct iov_iter iter;
> 	  int optlen;
>   } sockopt_t;
> 
> Note: optlen was not suggested by Linus' but I believe it is needed, given
> random values could be passed by protocols back to userspace.
> 
> And the callback becomes:
> 
>   int (*getsockopt_iter)(struct socket *sock, int level,
> 			 int optname, sockopt_t *opt);
> 
> The sockopt_t structure encapsulates:
> - An iov_iter for reading/writing option data (works with both user
>   and kernel buffers)
> - An optlen field for buffer size (input) and returned data size
>   (output)
> 
> The plan is to enable getsockopt to leverage kernel buffers initially,
> but then move .setsockopt from sockptr_t into this as well.
> 
> This series:
> 
>  1. Adds the sockopt_t type and getsockopt_iter callback to proto_ops
>  2. Adds do_sock_getsockopt_iter() helper that prefers getsockopt_iter
>  3. Converts one protocol (netlink) to use getsockopt_iter as a proof of
>     concept
> 
> This is what I have in mind for this work stream, to make it more
> digestible:
> 
>  * Keep the temporary getsockopt_iter callback allows protocols to
>    migrate gradually.
>  * Once all protocols have been converted, getsockopt can be removed and
>    getsockopt_iter renamed back to getsockopt with the new API.
>  * Once the protocols are converted, the SOL_SOCKET limitation in
>    io_uring_cmd_getsockopt() will be removed.
>  * Covert setsockopt() to also use a similar strategy, moving it away
>    from sockptr_t.
>  * Remove sockptr_t in the front end (do_sock_getsockopt(),
>    io_uring_cmd_getsockopt()) and start with sockopt_t (instead of
>    sockptr_t) in __sys_getsockopt() and io_uring_cmd_getsockopt()
> 
> Link: https://lore.kernel.org/all/CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com/ [0]
> ---
> Breno Leitao (3):
>       net: add getsockopt_iter callback to proto_ops
>       net: prefer getsockopt_iter in do_sock_getsockopt
>       netlink: convert to getsockopt_iter
> 
>  include/linux/net.h      | 19 +++++++++++++++++++
>  net/netlink/af_netlink.c | 22 ++++++++++++----------
>  net/socket.c             | 42 +++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 70 insertions(+), 13 deletions(-)
> ---
> base-commit: 4d310797262f0ddf129e76c2aad2b950adaf1fda
> change-id: 20260130-getsockopt-9f36625eedcb
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 
> 


