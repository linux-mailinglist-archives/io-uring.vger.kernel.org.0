Return-Path: <io-uring+bounces-7335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CA92EA77631
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 10:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26410188A1C4
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 08:19:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2408D1E98F8;
	Tue,  1 Apr 2025 08:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RV7b9Dch"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2781E261F;
	Tue,  1 Apr 2025 08:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743495560; cv=none; b=n+nNNrhEm/i30t4yqDoBPP8TVg4t84feV/cgPmcOdnJCaxYwgPnDF5aVbaFyPcD+ik26JA/vDNmnSieQhQ629qTfwvgvSnKX8V6HBnXWFple3x2SPkywFWjObvg4s5j8GVgA8rJoc70lNk5qPU6pSguAON/Auddyw2k44cfRpEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743495560; c=relaxed/simple;
	bh=qlsGP9nYpg9ECwWOf+7L3C+s5nRg0js3AhgwMO+0GnI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WYKJJuzxEtWepFLwZN/Q37B3sKEBndoZLi2DNj37vrhJ3R7/q8L7Z8+b97YfGewB2ro8JpzZTvWIPnriDMjMPFlA99w1L4AKoSXmPXvHFN+Xu7DtRANP0Lo4Sf5HqbCz9xkcqvH+nuyZBU/P7nbbAunoEwCbp96hgBugHTud0ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=RV7b9Dch; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=vJej1gym8PffvPJkpcAVY4oHxH7PtcR6PiojZNvFt9M=; b=RV7b9DchSX6L/1eGwqFQrmPoMe
	hf0+MvUSe77ZEvXnOMKdaDfI72KNjrnBHp4+fOyw74E/OKn4qz/xPPhyS7jysMN32ED0nZFh+bSWt
	qNTdeC9sUxWNSlUy3fPjumM8AyZcbA0ZmlEpLcU9V+2QwUoXZ7eQfcl2nXK+BF86z5eiOUe5W+1UA
	0QlMB9Ew/iDDfZQz1e7CZjakP0NXtY+bs+HEsN/fv3tTiQvAZhGTsamRKtNDHQAO89fEIE3KeBJf8
	xcd8vRDXXIUCf417uDpOhlMncOdHNgBrwgFPS3pKv66oe2Gxh7inZx1qK9sSIbFAyQV3hRiMvLECg
	thVcgrdmcYk8AM8eIrag2xACAnicTWSHEjTexxvojrRysCeGDc29D6smjQ2phM7X9otv3Fm5Phnsk
	JXkUjKNwFhUfQWuhXXq7lO+xH6aXarbwoeT3Oz7x9XbnXQJv7YBaLBY2zEYjoaVXXS037eARPx8fj
	gfrHfFqPkn/4/n7sGmBOfAQs;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzWpu-007dNX-35;
	Tue, 01 Apr 2025 08:19:07 +0000
Message-ID: <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
Date: Tue, 1 Apr 2025 10:19:05 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via optlen_t
 to proto[_ops].getsockopt()
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Breno Leitao <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Karsten Keil <isdn@linux-pingi.de>,
 Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn
 <willemb@google.com>, David Ahern <dsahern@kernel.org>,
 Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
 Xin Long <lucien.xin@gmail.com>, Neal Cardwell <ncardwell@google.com>,
 Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>,
 Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Oliver Hartkopp <socketcan@hartkopp.net>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 Robin van der Gracht <robin@protonic.nl>,
 Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
 Alexander Aring <alex.aring@gmail.com>,
 Stefan Schmidt <stefan@datenfreihafen.org>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Alexandra Winter <wintera@linux.ibm.com>,
 Thorsten Winkler <twinkler@linux.ibm.com>,
 James Chapman <jchapman@katalix.com>, Jeremy Kerr <jk@codeconstruct.com.au>,
 Matt Johnston <matt@codeconstruct.com.au>,
 Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>,
 Geliang Tang <geliang@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>,
 Remi Denis-Courmont <courmisch@gmail.com>,
 Allison Henderson <allison.henderson@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Wenjia Zhang <wenjia@linux.ibm.com>, Jan Karcher <jaka@linux.ibm.com>,
 "D. Wythe" <alibuda@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>,
 Wen Gu <guwen@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>,
 Boris Pismenny <borisp@nvidia.com>, John Fastabend
 <john.fastabend@gmail.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Martin Schiller <ms@dev.tdt.de>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>,
 Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
 Jonathan Lemon <jonathan.lemon@gmail.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
 linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org,
 linux-can@vger.kernel.org, dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
 linux-s390@vger.kernel.org, mptcp@lists.linux.dev,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net,
 virtualization@lists.linux.dev, linux-x25@vger.kernel.org,
 bpf@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
 io-uring@vger.kernel.org
References: <cover.1743449872.git.metze@samba.org>
 <Z-sDc-0qyfPZz9lv@mini-arch>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Z-sDc-0qyfPZz9lv@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:
> On 03/31, Stefan Metzmacher wrote:
>> The motivation for this is to remove the SOL_SOCKET limitation
>> from io_uring_cmd_getsockopt().
>>
>> The reason for this limitation is that io_uring_cmd_getsockopt()
>> passes a kernel pointer as optlen to do_sock_getsockopt()
>> and can't reach the ops->getsockopt() path.
>>
>> The first idea would be to change the optval and optlen arguments
>> to the protocol specific hooks also to sockptr_t, as that
>> is already used for setsockopt() and also by do_sock_getsockopt()
>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
>>
>> But as Linus don't like 'sockptr_t' I used a different approach.
>>
>> @Linus, would that optlen_t approach fit better for you?
> 
> [..]
> 
>> Instead of passing the optlen as user or kernel pointer,
>> we only ever pass a kernel pointer and do the
>> translation from/to userspace in do_sock_getsockopt().
> 
> At this point why not just fully embrace iov_iter? You have the size
> now + the user (or kernel) pointer. Might as well do
> s/sockptr_t/iov_iter/ conversion?

I think that would only be possible if we introduce
proto[_ops].getsockopt_iter() and then convert the implementations
step by step. Doing it all in one go has a lot of potential to break
the uapi. I could try to convert things like socket, ip and tcp myself, but
the rest needs to be converted by the maintainer of the specific protocol,
as it needs to be tested. As there are crazy things happening in the existing
implementations, e.g. some getsockopt() implementations use optval as in and out
buffer.

I first tried to convert both optval and optlen of getsockopt to sockptr_t,
and that showed that touching the optval part starts to get complex very soon,
see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
(note it didn't converted everything, I gave up after hitting
sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
more are the ones also doing both copy_from_user and copy_to_user on optval)

I come also across one implementation that returned -ERANGE because *optlen was
too short and put the required length into *optlen, which means the returned
*optlen is larger than the optval buffer given from userspace.

Because of all these strange things I tried to do a minimal change
in order to get rid of the io_uring limitation and only converted
optlen and leave optval as is.

In order to have a patchset that has a low risk to cause regressions.

But as alternative introducing a prototype like this:

         int (*getsockopt_iter)(struct socket *sock, int level, int optname,
                                struct iov_iter *optval_iter);

That returns a non-negative value which can be placed into *optlen
or negative value as error and *optlen will not be changed on error.
optval_iter will get direction ITER_DEST, so it can only be written to.

Implementations could then opt in for the new interface and
allow do_sock_getsockopt() work also for the io_uring case,
while all others would still get -EOPNOTSUPP.

So what should be the way to go?

metze

