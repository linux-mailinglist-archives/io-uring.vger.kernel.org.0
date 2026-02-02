Return-Path: <io-uring+bounces-12026-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GJLCGjorgWlgEgMAu9opvQ
	(envelope-from <io-uring+bounces-12026-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 23:54:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AB51D2852
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 23:54:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8984830CDFBB
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 22:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39C64385ED7;
	Mon,  2 Feb 2026 22:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hLTnF6Cv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7025C360742
	for <io-uring@vger.kernel.org>; Mon,  2 Feb 2026 22:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770071497; cv=none; b=eRdZb4XPC23nu0eyl8ewItfD4CTC8FV8en6ORNWtjgVJjbkKwLsNMSPQCieseD0MEuoMNcRX3SRf1kpMb9fJFJvjK/hc+xUmKqdkD9SQua/xNEh9pXymCUq/6eY+jxBdcHA5Bo5KCMholItig5czZDpjZQIeoAFlodNh/o4nXlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770071497; c=relaxed/simple;
	bh=FKtoDRTtb+4i7v/qjEwG2Xg2B/SIBUBqdJA1PVVs8mU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aHapJeDvkQZHbqExLpFt+Rn/duPS9kUrMeSXAAdljtyCNWel4EfCYNm4NsNqEtIZIk1IKYZdQoe1RJnkUXS+nvGmZnYwmYeMLXxVpfv+nHoPMXkuMJNPTCVWWkElzfnl4r1e5TLbLNF0tFy9DkXV/3+kozR35D0NyW/3z5zqYOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hLTnF6Cv; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4801c2fae63so37870035e9.2
        for <io-uring@vger.kernel.org>; Mon, 02 Feb 2026 14:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770071494; x=1770676294; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NIZUSELiXp+s9+KpMxQDKTA6DmNxb624EHaq2wV6J20=;
        b=hLTnF6CvvwEYLHacUBpRKRDcOFKxz+c5YDRbqFyQJHGxjggfEdXhb5HALhEHITN1/q
         oa8y1n1bv4B4xe1Nd3xjxZQueIRnpJRqYnsONW6RasHTvjPqHYiQRwrF3k7MQ4MCRFiF
         fPpO0pptW3T098QMQM9upnZMloxQtgbpstpwET/j0QOdU+QrNJ2goleiHYMCcPGKIU0X
         5z52JGEgkSpmlzxXl82dgyGM/F1PSiFtS8eFb7mzZmpe9k2lEpdZ9yeK8EFd5NvxT/Wj
         o/v7Av4DO4wwrKc+O+ebSZR09VJSkNBPJGCYCl0MjRwAoSRP6O/PIP6LoitWN/QI3kir
         HxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770071494; x=1770676294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NIZUSELiXp+s9+KpMxQDKTA6DmNxb624EHaq2wV6J20=;
        b=q4F5wfLeIjaeJbpMiwRMm+S4252TKGcYDPiRPHlvxu9e68rtGQVV52Uu6xEowoFiaH
         SvB2Mj7OF3QsEbhKGi57xNhiskvFMLMfo1/X26mxK6XRVv92UUoC3iTg+RstKqcP6iPL
         995cdveKHK02wds9PoaFfnb3vQaLjGyGqpP6iQj2V/vhcxXgdjcWuBmEXsve/w4NIY8s
         YRQYHstobC+gCg/R0F2No6daYxct51i4WM6ZiR0m5vkHgavpC8tfE6zmtv2MZSQzNu47
         x0nNq1/mS88f7Ls1msrNi07pPD124dyixHXV4EWtOdPs0fblQuugng4mwLYYpsUYY6Pg
         lN/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWs4gTsQSW1XKcXFaPSprF6176mrzBaihVQVo/8JpcSXY0oOqPtLByuX+6c58rOQJV+zaTXKpogyg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwK/u2hKwOHgVZu371e0Qn6xZ1zLQ80yrMiDY1Y96Zx/glAJSlc
	S9rdrIjvoxnpmKxVmTOywM2TfSBceX3DsvbMzZpPRzWn7NWGI/N6PFZU
X-Gm-Gg: AZuq6aKzFa3drl2c8AdIjZqhYoWND2EWaNWwYMNzmjNRJJas0cQ1dPFN0CwF5txhf9F
	4bRFWrNPUBt5IidW6f0cg9f/JEVScnb0eNS11V2UJ7lCFKS4DBddks6Nj9KOuye0FHN5mUWmi9F
	hkSbAFKTdsVUCoeMisbXznCkTcroDdaxMK7Z2rU+BveNiKDMUGuaYc8CcwJz2VwgjR0wjcPm4Xv
	h9BXpT0IJeud7nkRDEEFK0n90enxkccNcBSJ3/JM7lD3UYO4zXkdfaOaj+X9fJqLO0GTrnV3zRH
	fF4lWAfAqAEA+vmgKWcrVckTo0QJ/8dZJcCzqgG/6SCQHQxngfzi7jmH6htdXdeFafMZVX13U4k
	O+irfmJUtjvi3b16fkUmg5MtRJoMd8jOJ40w6z+N7gC5InF5l0gY0GY1LxRA6NdbZZeAxmDFCvj
	AL0nWjxPwxDV3STNQBhuxDGj8tpuafsaBsLcrWcJELHjAOGSQB+9VJ
X-Received: by 2002:a05:600c:c16b:b0:477:9dc1:b706 with SMTP id 5b1f17b1804b1-482db47d849mr161092965e9.19.1770071493556;
        Mon, 02 Feb 2026 14:31:33 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483051539ddsm17861575e9.9.2026.02.02.14.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 14:31:33 -0800 (PST)
Date: Mon, 2 Feb 2026 22:31:31 +0000
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
Message-ID: <20260202223131.44e81ba1@pumpkin>
In-Reply-To: <aYCUpNyNihhR7no0@gmail.com>
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
	<20260130205227.6fb1d9ad@pumpkin>
	<aYCUpNyNihhR7no0@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12026-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
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
X-Rspamd-Queue-Id: 9AB51D2852
X-Rspamd-Action: no action

On Mon, 2 Feb 2026 04:32:42 -0800
Breno Leitao <leitao@debian.org> wrote:

> Hello David,
> 
> On Fri, Jan 30, 2026 at 08:52:27PM +0000, David Laight wrote:
> 
> > The system call wrapper can do the user copies, it can also suppress
> > the write if the value is unchanged (which matters with clac/slac).  
> 
> This aligns with my proposal: using an in-kernel optlen that protocol
> functions can operate on directly:
> 
> 	typedef struct sockopt {
> 		struct iov_iter iter;
> 		int optlen;
> 	} sockopt_t;
> 
> > The obvious change would be to pass the length itself and make the
> > return value -ERRNO or the size.  
> 
> I explored this approach to avoid embedding optlen in sockopt (which was
> Linus' original suggestion). I attempted returning the length both via
> iov_iter and as a return value, but neither proved ideal.
> 
> > #define GETSOCKOPT_RVAL(errval, size) (1 << 31 | (errval) << 20 | (size))
> > which would get picked in the rval < 0 path.
> > It would also let 'return 0' mean 'don't change the size' requiring
> > a special return for the one (or two?) places that want to set the
> > size to zero and return success.  
> 
> My conclusion is that encoding both optlen and error in the return value
> requires pointer manipulation that isn't justified for this slow path.
> While technically feasible, the resulting "mixed pointer abomination"
> won't be worth it.

Not really, they are both just numbers.
99% of the protocol code can just do 'return -Exxxx' or 'return size'.
That is all simple and foolproof.
The calling code (not many copies) does:
	rval = foo->getsockopt(..., size_in);
	size_out = size_in;
	if (rval >= 0) {
		if (rval > 0)
			size_out = rval;
		rval = 0;
	} else {
		/* abnormal path */
		if ((rval & (1 << 30))) {
			size_out = rval & 0xffffff;
			rval = -((rval & ~(1 << 31)) >> 20);
		}
	}
	if (size_out != size_in)
		put_user(size_out);
	return rval;
(Or something similar depending on exactly how the values are merged.)

> 
> > There is not much point making the 'optval' parameter more than
> > a structure of a user and kernel address - one of which will be NULL.
> > (This is safer than sockptr_t's discriminant union.)  
> 
> This approach forces every protocol to distinguish between userspace and
> kernelspace, then perform the appropriate copy:
> 
>   static inline int mgetsockopt(void *kernel_optlen, void *user_optlen, ..)
>   {
> 	....
> 	if (kernel_optlen)
> 		memcpy(kernel_optlen, newoptlen, ...
> 	else
> 		copy_to_user(user_optlen, newoptlen, ...
>   }

That is a function provided by the implementation.
It is no different from using the ones that act on iov_iter.
The real difficultly is stopping the usual culprits (bpf an io_uring)
from cheating and looking inside the structures.

> Additionally, you'd need safeguards ensuring callers never pass both user
> and kernel pointers simultaneously. This seems significantly worse than
> using sockptr.

Sockptr has the real disadvantage that it is very easy to mix up the
kernel and user pointers (there is some horrid code that looks inside).
If you have separate pointers that can't happen.
You might access NULL, but you are never going to use the wrong address.
Remember some systems (s390?) use the same numbers for user and kernel
addresses - you have to get it right.
In any case, if both addresses are set you can just have a rule that
one is used by preference - it isn't a problem.

There might be legitimate reasons for setting both pointers.
Consider setsockopt, the wrapper could copy small user structures
into an on-stack buffer.
The structure would then need to contain the address/length of the
kernel buffer as well as the actual user address in case the code
wants to read more that the expected data length.
For a kernel caller you also want the actual length of the buffer
as a separate field from the length of the [sg]etsockopt().

I'm not sure what fields you need for the address buffer.
Probably 'user address', 'kernel address' and 'kernel length',
what you don't need is support for scatter-gather, page list,
pipes etc.


> 
> --breno
> 


