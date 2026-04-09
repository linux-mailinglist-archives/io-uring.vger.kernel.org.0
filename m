Return-Path: <io-uring+bounces-13011-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OKmYJtll12myNggAu9opvQ
	(envelope-from <io-uring+bounces-13011-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 10:39:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E9C9C3C7D89
	for <lists+io-uring@lfdr.de>; Thu, 09 Apr 2026 10:39:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF6C83014973
	for <lists+io-uring@lfdr.de>; Thu,  9 Apr 2026 08:39:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF4553A63E4;
	Thu,  9 Apr 2026 08:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QboQ/g4f"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E81389469;
	Thu,  9 Apr 2026 08:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775723955; cv=none; b=DIDsS6higKriHqbVUbWr4Ra7sSevbJxKVrnwzXPJ2kabwbCDR84ZuYy/scpSGQOS53BgaYPpjY5vkHa8BeIWC2CXScGxNlaJOA+Qu7kuzF5yueG4adng9Rq6km3YaMzaDjdhuC/z5oVMYHxhY0UPSLPe1cn5tfCdMED5C4wtoDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775723955; c=relaxed/simple;
	bh=0t9GmcyonzRJZf/bXkI6+pYIeVWgLTtw4V3r+KD7b3Y=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=sP8epCO+YlhaTG3A2X6h1+Bpf9bHxiQupYjdLXytKU6BPOzZwsv6k17hqYo3AQ1njksLMc5kO3oocIINMqL4FHcvAriXhZdVPjoaztbIUYYZKKuvihdnfHb6N1zesmN5WBiiMf6ol2ociyPCvgctxts3oa2Vuqi4rtWwFq1oCc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QboQ/g4f; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Cc:To:From:Date:Message-ID;
	bh=V3satatu24/OV36rdGRBdBIyxrI0A4QOnJU8uiF2h9o=; b=QboQ/g4flDH0z4kuyalyqfbNAZ
	ybWk00FTGAujWJXw5yawz3N8ywXaRYI5Zoi3pStmUqPgHC45wRhT/qJNzuD3y4WpDWt897moNYj1I
	RPZZQ8fwlYtrBw9gBQlwxj9UU26/tb+aYl9fcZGydqcCd8wyEEYyf7SxaT/eTpdWtbXnZZ6liUpDm
	1dmLmtBOhc3SArnb4wU2ApgxQrii9UqFgMLmbN+aI4hCsZQ1hnJYrOVPTlj7co/6wHTDICZVIrePR
	9cf4qOzYKRzIQ/731ikq6C+32d2jxhEF0mz/5ebvZ8RiD9qUXKrU4TjOzdbQqN7mP//4axfVJrExt
	PqNFqmcEuEWn/jlUeQoDozzq9kJslqxQBk31FkS+ij8Fi94Cd4jOyGJKU5jOxWbbTuMyxWTVLLF/h
	AavGdgmGFE5WIOXdfQMDVa9K88/vCWXZxPZaBS9kgt76Ia9vKktvlFLGTrpmxfr4Mws+2u+okVa57
	v3fMCvxUBZpckB57OQQuic7S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wAkup-000000087hC-3RTh;
	Thu, 09 Apr 2026 08:39:07 +0000
Message-ID: <9691238e-bcdd-4d0d-99e1-f77b191845f4@samba.org>
Date: Thu, 9 Apr 2026 10:39:06 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3 0/4] net: move .getsockopt away from __user
 buffers
From: Stefan Metzmacher <metze@samba.org>
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
 <3fd4bf27-344f-45fc-bca3-9e9676522972@samba.org>
Content-Language: en-US
In-Reply-To: <3fd4bf27-344f-45fc-bca3-9e9676522972@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[samba.org,quarantine];
	R_DKIM_ALLOW(-0.20)[samba.org:s=42];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13011-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[samba.org:dkim,samba.org:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E9C9C3C7D89
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Am 08.04.26 um 15:56 schrieb Stefan Metzmacher:
> Am 08.04.26 um 13:26 schrieb David Laight:
>> On Wed, 08 Apr 2026 03:30:28 -0700
>> Breno Leitao <leitao@debian.org> wrote:
>>
>>> Currently, the .getsockopt callback requires __user pointers:
>>>
>>>    int (*getsockopt)(struct socket *sock, int level,
>>>                      int optname, char __user *optval, int __user *optlen);
>>>
>>> This prevents kernel callers (io_uring, BPF) from using getsockopt on
>>> levels other than SOL_SOCKET, since they pass kernel pointers.
>>>
>>> Following Linus' suggestion [0], this series introduces sockopt_t, a
>>> type-safe wrapper around iov_iter, and a getsockopt_iter callback that
>>> works with both user and kernel buffers. AF_PACKET and CAN raw are
>>> converted as initial users, with selftests covering the trickiest
>>> conversion patterns.
>>
>> What are you doing about the cases where 'optlen' is a complete lie?
>> IIRC there is one related to some form of async io where it is just
>> the length of the header, the actual buffer length depends on
>> data in the header.
>> This doesn't matter with the existing code for applications, when they
>> get it wrong they just crash.
>> But kernel users will need to pass the actual buffer length separately
>> from optlen.
>> It also affects any code that tries to cache the actual data and copy
>> it back to userspace in the syscall wrapper - which makes sense for
>> most short getsockopt.
>>
>> (This is different from historic code where the length might be
>> assumed to be 4 regardless of what was passed.)
> 
> As the insane legacy cases can only happen for keeping
> compatibility with existing userspace applications,
> we could get the original optval and optlen __user pointers
> out of sockopt_t again via something like:
> 
> char __user * __must_check sockopt_get_insame_legacy_optval(sockopt_t *sopt);
> int __user * __must_check sockopt_get_insame_legacy_optlen(sockopt_t *sopt);
> 
> And for kernel callers they return NULL and the code should
> turn that into -EINVAL or something similar.

Or better helper macros/inline functions to call the legacy implementations.
something like this:

int sockopt_call_legacy_sock_fn(struct socket *sock, int level, int optname, sockopt_t *sopt,
                                 int kernel_errno,
                                 int (*legacy_fn)(struct socket *sock, int level,
                                                  int optname, char __user *optval, int __user *optlen))
{
      if (!sopt->legacy.optlen)
           return kernel_errno;

      return legacy_fn(sock, level, optname, sopt->legacy.optval, sopt->legacy.optlen);
}

And a similar sockopt_call_legacy_sk_fn() that takes struct sock instead of struct socket.

That way it would be relatively easy to move the calls of sockopt_call_legacy_{sock,sk}_fn
down the stack to the places where it's really needed in incremental steps.


