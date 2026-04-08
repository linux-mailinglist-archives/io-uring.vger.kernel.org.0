Return-Path: <io-uring+bounces-12987-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yCCoI4U71mlZBwgAu9opvQ
	(envelope-from <io-uring+bounces-12987-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 13:27:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 32FA03BB36D
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 13:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 934633007522
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 11:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361193B3898;
	Wed,  8 Apr 2026 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CsKD0Hkp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2D2F3B2FF4
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 11:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775647619; cv=none; b=iudjcFDZSPwy7K6YlLg86m6eTV8PKvNxGl7Ts17AHcqZp7Xj8/OVhk7M8uG+N2EvleCg9Tu3GAOpmjLki6i7ehk/Hx9YvhTmhdfUK3E1xAvbWnzJg8fkucbzHcENYBhSXdsO6KTlzRIAF7JgaY92wSdaYr7tJkQkJjaFQyFZz5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775647619; c=relaxed/simple;
	bh=AzehQ18alrzr2B4IsDUBovXNCXWu6SlHUOMWZ0pewVw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u+XIQoFoedOf9v5tZnS6nd+LsZFCB86cKv26tAN0cy+XEfL2G0eYzMNsWXsc1e66Krez/odE/jCeZkl+npZ0zrrF/pcwtGVAiCkZ0yv9UabHGCZlrl4xONgflvenc+LqzZ4Vl+V9zhUJcF3WE4sVrnEJOErYUxtQECRM5DOkjd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CsKD0Hkp; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so49459455e9.2
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 04:26:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775647616; x=1776252416; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Ge0u9kdZKFhKwQUuXKTE2s3xbjDUvzv/MSs18Mhdv0=;
        b=CsKD0HkpgqXsNjJgnvcv1ObDqF2sJmD5u1ayZeItzhEm0pRTwzxeUt0DKfNcEkHsgG
         HFZQXixnRkBfI0onpORV800pN0LBi/bS9OSNqtTkPOgv3rbybTu1DgQEpB4uhZVNi1AK
         QWypWUqmF2oeu4Zou+cgRBX33kyRPAo7Yu0Yye/j9RqGoh6PXhmqQlaS3H3fmg5o5XGM
         GVTYJ8Tv4ChS7F8aIKwcrN6XXp8pCMRrlMd/Iv32DLR3r2NNzAhySOKo89fdq6nTAagf
         cXMaORSDxcyLD6igT7iMJFVyVOgafM2DgDiEVjgkMlmLXB3j7lBjG7IbTdUM13TRJMsr
         vhTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775647616; x=1776252416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Ge0u9kdZKFhKwQUuXKTE2s3xbjDUvzv/MSs18Mhdv0=;
        b=pmzkZrR7JK0DQKAaC2owW8FWNOcOUMAX/MeMmqj5yEsDHQm1DEeq0P5gXkR+SykBTC
         1Sufl0y1ps3sxwfQgCnNZFSiGegJLoTJmef0qO5pXUXz4CtqEy+doyqM+0BEjmH8RvBR
         b8LTNcEcU5crGRgCW/f6DuzmAZwrTYoGqi7meWk0JNK4g/mhEvDa+qK5LkD6YI0S2NR7
         r2z/XVJCLWSrgBDWWY79MDFXcuuG+FNIyvVsMImd8gn/kf00mECPcveBAXF65nWOA+cd
         1Iowr7UEW1/S+f++CPYrwwiNP4txdogU4oe/9/12B3PJmPbowTwC1TXN9nMjAUw+N8QM
         5kVw==
X-Forwarded-Encrypted: i=1; AJvYcCUOb2Y4NV3apY2Gqaflf7GZrPfoKCl29YFTAr55OXqn5idD4BQyqmPg0s3LwxPe0FKflAF56DuRTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3WHapl8Bq0kcE2oSsBbz+/N7CQBNOfQ6lFlXdE2SQavIEyxaj
	QZQy1k1tNRPaWoyc5l3cF5fYqzGc5cOjb+YtHJNozNLkBn0cMixdBhEC
X-Gm-Gg: AeBDieszcXU2Rxjz9kHezTX+hRw0TGrbMbRssA3ToscYy4FMQTa3p3rfyYmhb6+Lo8+
	Caje0B+X4D65ohnvBZ/n6GBwphpUIIyYYyU9gAU6ileQp2Y6oLPUHCxmo0vF7gXn5BUnVJpqy+6
	b0vHLr7vE3tc7hHd1e3UP+BxLnXCz/bFwmuzhu/SKFAOoFiQbEguNmcDVR/0/xvMdxP7BFTl8js
	r+Eq7O+7y/sO3VAkIGneEoeK9wFTvqqxqnxfrKIT+BuC0P5YohDWgACI/M/uArJl9PGiWXzWOSL
	zBCia26QVQU09Kuf1A7gTR0hhpO3HQ3LuHruPfrfLNYDCGjrWzYkCcwQ9As7MRx51BkPm8Hr3Gq
	Xytfa2yBRH2CCzQGgD41m9AuGctRxI+a1WkJR82/JXNLIwUUx1JmibvvjExF6bwTjahq8Fwy89L
	UThIRDXNv9kGjrtjXzIyJ5DOK3lBkHMqwxacF1MWXb/+fCoN/a+03FZfUOS0LaRv7w
X-Received: by 2002:a05:600c:3544:b0:485:303b:c50a with SMTP id 5b1f17b1804b1-488997352d3mr282797795e9.13.1775647616063;
        Wed, 08 Apr 2026 04:26:56 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488c5d85452sm16295135e9.15.2026.04.08.04.26.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 04:26:55 -0700 (PDT)
Date: Wed, 8 Apr 2026 12:26:53 +0100
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
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
Message-ID: <20260408122653.295953dd@pumpkin>
In-Reply-To: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-12987-lists,io-uring=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[17];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 32FA03BB36D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, 08 Apr 2026 03:30:28 -0700
Breno Leitao <leitao@debian.org> wrote:

> Currently, the .getsockopt callback requires __user pointers:
> 
>   int (*getsockopt)(struct socket *sock, int level,
>                     int optname, char __user *optval, int __user *optlen);
> 
> This prevents kernel callers (io_uring, BPF) from using getsockopt on
> levels other than SOL_SOCKET, since they pass kernel pointers.
> 
> Following Linus' suggestion [0], this series introduces sockopt_t, a
> type-safe wrapper around iov_iter, and a getsockopt_iter callback that
> works with both user and kernel buffers. AF_PACKET and CAN raw are
> converted as initial users, with selftests covering the trickiest
> conversion patterns.

What are you doing about the cases where 'optlen' is a complete lie?
IIRC there is one related to some form of async io where it is just
the length of the header, the actual buffer length depends on
data in the header.
This doesn't matter with the existing code for applications, when they
get it wrong they just crash.
But kernel users will need to pass the actual buffer length separately
from optlen.
It also affects any code that tries to cache the actual data and copy
it back to userspace in the syscall wrapper - which makes sense for
most short getsockopt.

(This is different from historic code where the length might be
assumed to be 4 regardless of what was passed.)

	David

