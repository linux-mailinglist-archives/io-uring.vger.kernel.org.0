Return-Path: <io-uring+bounces-12005-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mqMwGcchfmnnVwIAu9opvQ
	(envelope-from <io-uring+bounces-12005-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 16:37:43 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0CAC2B54
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 16:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7FD8D300AC00
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 15:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9923C2F0C45;
	Sat, 31 Jan 2026 15:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKLL/PF3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC8F21507F
	for <io-uring@vger.kernel.org>; Sat, 31 Jan 2026 15:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769873860; cv=none; b=I+G/3ISEtWB4PfzEsIRRdbOIMteV+SGxSkENhBUVokSxIcjs16rLrdKltKIZWAVdTzqFWJWW/oCu8jHOPaxqoXW2wgpNjzn1XXhJXVDotW5hBjF2ZCRYp8rGAsHH1Q6dQAlnyqX8gOvUK8VlokvCmNyzNqQkH4ebfOva73E2sMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769873860; c=relaxed/simple;
	bh=lFbN1ibUBCn+rfsJwuXg8x9jgyMUTQsXiXRrAR+KlJM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IfCameq7PkTRrViEQDd4tkBs4vWO6XF2mCumyN4ABFLGrTg8BB5FqCf2W3x1Vdizvl9MGAfAg3Fj6Oh3am0c/2OSXZaA/4abU/LlLApCt88NLh5s8WfvMhY9qsrRO+KCWkO5G5dhXF8g6f8twMZjIekFA1tbDGQg6dLoKFb62+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LKLL/PF3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42fed090e5fso2460138f8f.1
        for <io-uring@vger.kernel.org>; Sat, 31 Jan 2026 07:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769873858; x=1770478658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiS78dJ3E+O9/koHhs6/YjJ5zOTAaZI2BPhavS+ZM4w=;
        b=LKLL/PF37LNsasvQeiStabOoc4MTAqg5cxw12Z16BGRdPsZ3k8BNy1lZii6+vmer0P
         i3A9u6wqNIqmHtP6GWciy6QnpDt/n7wiQ897b71obCRHaxQPBsrLj8g++OenDLgSl0JU
         4QnwMbgPAL8JknhbNTmjiu4oRqiK90lNogDknzHfnYY6GhnCYt32gNSHkGwOsinGgwM2
         S/1uMXzRvVBhywF43Zp7BOcGsRplneaOZ5iyeUTwEzhmX/YAvlzLLiSabuBukDXL7VNg
         ydZrH+up0+QphBayWrBIY9WKsYoZDGSznlURirDIEVGX4yPGI90m4GWN2mv/fy5T2rSw
         3K9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769873858; x=1770478658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fiS78dJ3E+O9/koHhs6/YjJ5zOTAaZI2BPhavS+ZM4w=;
        b=R8GUZxyE0TmOQE61fbQtK/q/Tf9HJNMGrVdq4HXakFrwr+TUuIirQrihJQQ3aYNdZ7
         Gvh7H5EFlPqs73Fec6G+PwttmN6SMV14pA9z4sa/npKG5YEHkeMUi9rHkoal/ddhbTdx
         RMedQ6eWJ0ZKpjiJwB1LHD4elbUcUgh86/tpPvhILH3zYqQmroBkjlyl72FCHpm6UK4w
         3OZuLcHE+TKSF6N+sF5GG1wO3k6a8gJSmq665eBJ6/T08T4GAb264Q3zuyPDtsP03DMo
         VZPft4i/uCA4iPgRBgtyZj5lXn0a1ne6EKCCVUnUZyK+Rk2KltpIbWbauCkhXYBX50Mu
         ihAA==
X-Forwarded-Encrypted: i=1; AJvYcCXnj/Hn/Jt7J/05wqUPMQEell0IjhTr8N/6y8/7aYG2vwxCko6/RJ2UFD0jk7RO884LEgNQeSUkfw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZo3tXPNnrXdLhDJIrUIJLdbZs+mSOkAZB3jxuH1H8eZIZFkbl
	+n/hK7FeoCmf2lP5EQfoNRebiDIU7mfhhmMnwe1Dm1fSxPDBzu6nF9u5
X-Gm-Gg: AZuq6aJWYoewXntH635Ygoei2BzHlLRrZov5p20jgX7JnzbRhNd+7JVUlN1l62ia10D
	mDijn7grpeFLbEJZI3PVLNzj6+TewZ0kRsDxe5yNw3ykhUS04XYV/DiLFVz9h4D+Htuy+lHZiaK
	o6VRWD3msbJgeTzKCuHxCl1qs1oYcs23+nT2OI14dAcL4eJwCruNJCw8AvcWy8EfWsUag79ph8J
	9jYbMvqGIvUHV6slEP61uUnwYF7nruLrKINyTtTWjE1wfSOh6uHBeReIV3yw74fHkPQQ4VlxXX9
	YDkKZ5iFzL4nnOYLelE/bnajlNRaUT7W8xJGFFLnUueCmUhEutYETUhIObifPcmSkbfNvh2WtxX
	AO6NUUz2VSvJ1KkuB4niwHk7ubnzoVeyqAdQStd0lP5PuHzqkIqqhIKHxax8K7u+iRgfRhyO8Aw
	4h4CQuMlEJpaa87KU9XXd73+1/L8EVtZxGjCxNGxmz79wwbz+hGDOAWJNlYa/Mvw8=
X-Received: by 2002:a05:6000:4285:b0:430:f3ab:56a1 with SMTP id ffacd0b85a97d-435f3abaa14mr9728576f8f.42.1769873857412;
        Sat, 31 Jan 2026 07:37:37 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e10e48a6sm29620829f8f.8.2026.01.31.07.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jan 2026 07:37:37 -0800 (PST)
Date: Sat, 31 Jan 2026 15:37:35 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Breno Leitao <leitao@debian.org>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn
 <willemb@google.com>, metze@samba.org, axboe@kernel.dk, Stanislav Fomichev
 <sdf@fomichev.me>, io-uring@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH net-next RFC 0/3] net: move .getsockopt away from __user
 buffers
Message-ID: <20260131153735.3c9273a8@pumpkin>
In-Reply-To: <CAHk-=wiiPxGrVxFzzf1nbx7_0abjZkhmd9oPximUxUyDM7gwug@mail.gmail.com>
References: <20260130-getsockopt-v1-0-9154fcff6f95@debian.org>
	<20260130205227.6fb1d9ad@pumpkin>
	<CAHk-=wiiPxGrVxFzzf1nbx7_0abjZkhmd9oPximUxUyDM7gwug@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12005-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BC0CAC2B54
X-Rspamd-Action: no action

On Fri, 30 Jan 2026 17:19:55 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 30 Jan 2026 at 14:40, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > There is not much point making the 'optval' parameter more than
> > a structure of a user and kernel address - one of which will be NULL.  
> 
> That's exactly what we do *NOT* want. Because people will get it
> wrong, and then we're back to the bad old days where trivial bugs
> result in security issues.

It can still be a (semi-)transparent structure that code isn't allowed to change.
That is no different from using iov_iter.

> Can you point to an actual case where setsockopt / getsockopt would be
> performance-critical? Typically you do it once or twice.

IIRC a really horrid one - I think for async io.
That is also one of the few where the supplied length is a lie.

	David

> 
>               Linus
> 


