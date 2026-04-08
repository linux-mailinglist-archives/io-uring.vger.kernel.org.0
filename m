Return-Path: <io-uring+bounces-12992-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ANHwKZxe1mkfEwgAu9opvQ
	(envelope-from <io-uring+bounces-12992-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 15:56:44 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 39AD03BD425
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 15:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 601483029C35
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 13:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 334CE3CFF71;
	Wed,  8 Apr 2026 13:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WCx6dZDm"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E5B2F3C3E;
	Wed,  8 Apr 2026 13:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775656582; cv=none; b=IhKacHyYInnATcz5uxai+Y1OU5sut428WUfoSiW+hZXXpFBTgVU8oVv08oZWm8ocOR1bZUdeL8rXp3XvGjgl3vrdUgeDC1yyTXYZSfr5G7cI8UW/kPSUcD8MkCvf4NdG8zr3nEklj6a4TbG40XPMnnJ33N7qswNk2qarvwHVsgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775656582; c=relaxed/simple;
	bh=46qFwFzC/ebZUZRyVIFb+CkAl3duNE/HoG95kggfUe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kHGX+m+WIjH7LDa9G3HE2QAP7uO8nBKilmF16bJSxz/6VCuz5HJN54G+oCDeBdzAX00dL4PIYKv/wD7OIO8h+1B6SZunDp+NKM10SKtskfcJgM5JCq65z+U/DC6iflj+MYZ13nWPxKD/8E/6/4UiFZLQHDC+0jyui8/89cs7EeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WCx6dZDm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=CViLcGuCpU+atHks/PGTdtF+G2BOuCOPXIMz2qetKH0=; b=WCx6dZDmsXGl/lrlE7Rsv+5i9Z
	BXIvX/mkWz7VTersVPNGJrUlfNVsnrFh0XFosOlVRmTdJbS7Wj7xlJxDlOOfuR20jVw0FPN7SluxP
	D0HUN9+trElKMxgKmxVjgYNxcgv9kJ4O/oIOTMH1SVpW0mYwyDlRHd7r/ijhe9/gC0G7cxj52jfqj
	kAvapSdb7KQg8iyAXItZ7RuCgt15dzAvZ/7EBS+lj+ryt5PO01OLmjIvc9TVTni9nvTkG/t/B86zj
	o5ugHT7n3uVkPdUwmwq6Ypu5lVvqscvsP7DfOMN5vBwox7EeoKr+1sgA2p0lQDmPi3h/trG+I99l+
	3Qhsx0GpUkzBj0oX+vNMAgeqC1jHPGYtyISmWgygzqW369SL3vwzVA71Yi6oVCHsxQpq66pWC++a6
	VCg/FXUwGErrRdZP/ljdoxS4+cexRXtrbpPu5ijF+aERJG/Npphm1ca7mCiIywOpIh1duGFQmkHl0
	5DeSrJINA0S+E6rlTfsy4JDV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wATO9-00000007sKk-3uEK;
	Wed, 08 Apr 2026 13:56:14 +0000
Message-ID: <3fd4bf27-344f-45fc-bca3-9e9676522972@samba.org>
Date: Wed, 8 Apr 2026 15:56:13 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
To: David Laight <david.laight.linux@gmail.com>,
 Breno Leitao <leitao@debian.org>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@google.com>, Willem de Bruijn
 <willemb@google.com>, axboe@kernel.dk, Stanislav Fomichev <sdf@fomichev.me>,
 io-uring@vger.kernel.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260408-getsockopt-v3-0-061bb9cb355d@debian.org>
 <20260408122653.295953dd@pumpkin>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20260408122653.295953dd@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samba.org,quarantine];
	R_DKIM_ALLOW(-0.20)[samba.org:s=42];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12992-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com,debian.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[metze@samba.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[samba.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,samba.org:dkim,samba.org:mid]
X-Rspamd-Queue-Id: 39AD03BD425
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Am 08.04.26 um 13:26 schrieb David Laight:
> On Wed, 08 Apr 2026 03:30:28 -0700
> Breno Leitao <leitao@debian.org> wrote:
> 
>> Currently, the .getsockopt callback requires __user pointers:
>>
>>    int (*getsockopt)(struct socket *sock, int level,
>>                      int optname, char __user *optval, int __user *optlen);
>>
>> This prevents kernel callers (io_uring, BPF) from using getsockopt on
>> levels other than SOL_SOCKET, since they pass kernel pointers.
>>
>> Following Linus' suggestion [0], this series introduces sockopt_t, a
>> type-safe wrapper around iov_iter, and a getsockopt_iter callback that
>> works with both user and kernel buffers. AF_PACKET and CAN raw are
>> converted as initial users, with selftests covering the trickiest
>> conversion patterns.
> 
> What are you doing about the cases where 'optlen' is a complete lie?
> IIRC there is one related to some form of async io where it is just
> the length of the header, the actual buffer length depends on
> data in the header.
> This doesn't matter with the existing code for applications, when they
> get it wrong they just crash.
> But kernel users will need to pass the actual buffer length separately
> from optlen.
> It also affects any code that tries to cache the actual data and copy
> it back to userspace in the syscall wrapper - which makes sense for
> most short getsockopt.
> 
> (This is different from historic code where the length might be
> assumed to be 4 regardless of what was passed.)

As the insane legacy cases can only happen for keeping
compatibility with existing userspace applications,
we could get the original optval and optlen __user pointers
out of sockopt_t again via something like:

char __user * __must_check sockopt_get_insame_legacy_optval(sockopt_t *sopt);
int __user * __must_check sockopt_get_insame_legacy_optlen(sockopt_t *sopt);

And for kernel callers they return NULL and the code should
turn that into -EINVAL or something similar.

Then legacy stuff can do what they need, but most things are
sane and able to be called via io_uring and in kernel users.

Unrelated to legacy stuff I think it should be an opt-in
(or at least opt-out) for the writeback of optlen.

metze

