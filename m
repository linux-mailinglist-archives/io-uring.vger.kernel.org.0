Return-Path: <io-uring+bounces-13614-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id x5vAKwzpImp7fAEAu9opvQ
	(envelope-from <io-uring+bounces-13614-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 17:19:40 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 2710564939F
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 17:19:40 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ho1GCmC7;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13614-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13614-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 41DB0305E46E
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2026 15:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09ECA3B8958;
	Fri,  5 Jun 2026 15:14:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980FA3ED5A8
	for <io-uring@vger.kernel.org>; Fri,  5 Jun 2026 15:14:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780672470; cv=none; b=DH71jIIlBBvUuKH7DkDaXDVbKxeoPT6+4h8m1NFLR6CR60HERZtxxw4ACgH9zQvkBU3+hfTNwFKwO1CEMau+zSN+1wrPu2hCMcPO7BN6nmbfrUtcJZGqy3qRYkvl1xiwZpVIoUGOGkQXzsmYBm/lw8x/AvUlQjjVZ7lbe4RfCGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780672470; c=relaxed/simple;
	bh=+iR1M9yYqzyufLOWTZWg7ajKK1GPg5ZrcC7VtQr30Mk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RaW7R56z0WRJLClzKwhtxTOWchkLhM8UZ4uBBGB0TuVZuqXiAhVmSCssoiG0I0ugyNPGfJFkhcc49nHFsFRppM86Al1uW1kgU/xSkSO1As+7gCoGQDMjCcwYm9Weehcixo+BJxNlpLhN74lbq4VnnQpzJQgLbN6eO6rGI0WXql4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ho1GCmC7; arc=none smtp.client-ip=209.85.128.51
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b09e4cccso15444525e9.0
        for <io-uring@vger.kernel.org>; Fri, 05 Jun 2026 08:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780672468; x=1781277268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AyRiQRM4moCCjTKbCSr5rYbdhGQBceKTugMVudUxfDs=;
        b=Ho1GCmC7MLe4FjtT6OG6EeAhoe70WMOZIFJBWvDmW0eKcWhOOtHGYDNWnXjzlZc0Up
         eKB8qKFQbzbAH+lGQiYAF4Yq/wZwkzWC0lf4odkQ+EKK5ht7Q0VUBhwrFbuK541GV19A
         UgxPl3MHU9VBCNgP7IFwGQYOpZjV/07g8ATC+Ogb3DHy9DRo8onqb3b/sWCcvzywGfDk
         rSexU0demSl0plhYmo1jm6SpG5FA8ds8XmOIxfIfCTgLynm/vNWRNNSagUiQpqBS4Wo2
         Itx3Tq8JH+GCKEW+lSzDkkQAIwk5+m5NkXX0O1Z2U9+rc0HmYq0QW/wEzDwCBZy+LS6J
         IIPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780672468; x=1781277268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AyRiQRM4moCCjTKbCSr5rYbdhGQBceKTugMVudUxfDs=;
        b=sWn2QKlvafrokFphQKbhF6vL1E5D4yXSx95/ojFPxgYp5jeLk4zjXRKPpGKsQXHo+p
         j5lfoWR8vj5yMq4kvtfvw3ad/g2sXddE/RRMPJMveYd7PZzWruw2yiTO5UOXLiUbJ0E3
         bPGmLVeT3ZGN92iwdZcx3/LedEZTVWxJt/YeMtJ1j6tPtCUj/7DQk5AOe09tI68j3FwV
         6lLH+78pXUL61Dx5Wm5Vi/C7XJpSi4ctUQV3jruAYRSpiwkF4Mtj/JImz4tCRJ2tqT1Y
         9/kVbdWUsYhwvVy+hekRbjhnmTZuZEmFoCTVkzQ5yfPh+mESwaJJ5kDHNvc32FOk0zlX
         4SPA==
X-Forwarded-Encrypted: i=1; AFNElJ8uMfmwprfQb1d2+aGBnQn/pi5NeUS5RozqslxAxJ31TtLwWjL9eTnsKlV8SoDRHWR10CYiKs7r5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIC+xh+GYW2xvsMvbWcWwlCJl9okNJuNUm7NVqzJn+pOQoKCt1
	g0/1MmbKP1zyVfwBEnfnv9mbPgH+PHUfPql9bQX5M80R3yLyOepx1R/h
X-Gm-Gg: Acq92OH+1GZCV0SFlbTPca3SfNzWgA7xRHxJKvdwUpNTmdETTRYWSRlxoN66+xvetiV
	4DiVQUmqg1MErBwnMc+aCfvhA1jq2TFhXeonXa/P7l51JIsFb9b96GqP8UYensiKd3eOQz16ikQ
	P8RJtVoIZ+flH7EccfFswKdfVoNId3/TLDD5V1npaiIbKQsR+gTsnUYBbBdnVaqS9kekjZDx/nC
	B8X28DSGZg9m0fAF+4x+79+FclvaPelhJuo9c1qrDynhFtgrN6KkUB8hWOAoJC+2rbF/kFNFDnH
	hv2e+SN/eHvfW1C+Htja7Vxi+HNJc5s1+6kp9KtzuZmLXUDDyavnil5wLV0jzlJjR7uEzdql1mO
	/L6cjWB00zYBZc4/tuF9Dd6tbxlwyewFqMbWb4O2w+Z/7kBxwFN6etPJwXnrrpkVq/oAbKbpzww
	sEs6tDTudZ8Ph5N0UFHpv3F6aZf1ouO6TePV9Mzd6OSvuXKTQWyt0obECIW8erFOecKIdIups=
X-Received: by 2002:a05:600c:34c5:b0:490:be9e:fd07 with SMTP id 5b1f17b1804b1-490c25ae3e8mr66631365e9.10.1780672467777;
        Fri, 05 Jun 2026 08:14:27 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2dcad5sm29110357f8f.5.2026.06.05.08.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 08:14:26 -0700 (PDT)
Date: Fri, 5 Jun 2026 16:14:24 +0100
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
 buffers (update 1)
Message-ID: <20260605161424.334a05d5@pumpkin>
In-Reply-To: <aiK94g9vphHls3x_@gmail.com>
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
	<aiK94g9vphHls3x_@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:leitao@debian.org,m:davem@davemloft.net,m:edumazet@google.com,m:kuba@kernel.org,m:pabeni@redhat.com,m:horms@kernel.org,m:kuniyu@google.com,m:willemb@google.com,m:metze@samba.org,m:axboe@kernel.dk,m:sdf@fomichev.me,m:io-uring@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:torvalds@linux-foundation.org,m:linux-kernel@vger.kernel.org,m:kernel-team@meta.com,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13614-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[davidlaightlinux@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,pumpkin:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 2710564939F

On Fri, 5 Jun 2026 05:25:21 -0700
Breno Leitao <leitao@debian.org> wrote:

> On Wed, Apr 08, 2026 at 03:30:28AM -0700, Breno Leitao wrote:
> > Currently, the .getsockopt callback requires __user pointers:
> > 
> >   int (*getsockopt)(struct socket *sock, int level,
> >                     int optname, char __user *optval, int __user *optlen);
> > 
> > This prevents kernel callers (io_uring, BPF) from using getsockopt on
> > levels other than SOL_SOCKET, since they pass kernel pointers.
> > 
> > Following Linus' suggestion [0], this series introduces sockopt_t, a
> > type-safe wrapper around iov_iter, 

I'd have thought it would also have been better to use a wrapper function
instead of direct calls to copy_from_iter().
There is no need for most of the code to know there is a iov_iter hiding
inside sockopt_t.

-- David

> > and a getsockopt_iter callback that
> > works with both user and kernel buffers. AF_PACKET and CAN raw are
> > converted as initial users, with selftests covering the trickiest
> > conversion patterns.  
> 
> Quick update on this effort.
> 
> All proto_ops users have been converted to getsockopt_iter and submitted.
> 
> Most conversions are already in linux-next. Three remain:
> 
> 1) rds: Under review
>    https://lore.kernel.org/all/20260605-getsock_more-v2-3-80f38cdb8706@debian.org/
> 
> 2) smc: Submitted today. This is only limited to UBUF right now
>    https://lore.kernel.org/all/20260605-getsockopt_smc-v1-1-65da62fa44c4@debian.org/
> 
> 3) CAN drivers: Reviewed and acked, pending Marc's merge
>    https://lore.kernel.org/all/f83e25e1-b9f5-4810-bbd6-fdb8d2a10c8e@hartkopp.net/
> 
> Once these are merged, I'll rename getsockopt_iter to getsockopt and
> remove the legacy path.
> 
> Next, I'll convert struct proto the same way to eliminate the remaining
> userspace optlen/optval pointers.
> 
> After that, io_uring getsockopt operations will be unblocked.
> 


