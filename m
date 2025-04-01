Return-Path: <io-uring+bounces-7358-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E0515A783EB
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 23:21:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B12487A31F0
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 21:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54CD6214221;
	Tue,  1 Apr 2025 21:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="H6bnOli4"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE982139C8;
	Tue,  1 Apr 2025 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743542466; cv=none; b=q+sqvYxm5XzadPgLToHoWhECbeDY/amKXhEtlVtu+SZ7ElwBZxwUdCWMVB5BHDW7utdjkCogXYwlr2WKzzoERj/5WPhXsIBitZ8E26VPZO8Wb86mraumrRwAXt4hFNsOZNI9cmEWcWAtsNd3nH+GPjSscgIl7GKQpfbsOrEGnqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743542466; c=relaxed/simple;
	bh=F9wF1QnxVdxcZV0NtM7/S0HBgG7JEsJGsc2w1q1ogfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g6JfnntUtQXe7MY7ublbz+gQAFpkFQTZV/GRKYLcNMPGk09CGtQ0VweBUKaIXa7q2uy//pJFPdsZDKBMlKaB4ZbgH5/N6dY5b8GinhszyjDX4uXPI+1MWgc4gPwGhPbWrmpYN7KK7Tl+TCYCGW0yua8ZCPnK5Otv97E9bTz2EV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=H6bnOli4; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=fq3gSUtVhiS/zzN+K6mPhfJRjJePyrQnqiWr9fuZXoQ=; b=H6bnOli4uKQSEF7G+EasR2oWrg
	nDW/zsOuCuhzpKjaQdpnF3Xvanx9vcNDkcJHCPoGBe+npvO106RU5JK+4eSBYG338T5GMr8/L5ZL2
	NgXh6Ki7TvpmgPUKkuJJmNusp+GeClFbZXJxSgoncczn2poup4nx/lb+jiqS4Pn5Cy5idCpeZlonA
	U0ORhl2WCUYJQ1iOaYESJjtkiQTxLGLeM78iKOjjM4cjtb6/OsNgy+6f7iJWag1rTBRFHVzysrQ+A
	QvIYgyX6v/J+a6QnEM+Zupa+VSwkDH8YavAeAeVkubNPDGlMK0+QcPFZhEY3kAdO9wSyKhbwJOoNY
	1ZdjkGgPahubaaz7GEVlkbw7ZEQiA+Uu8NYlIp1QnW6n6B80WtHvVBgKGBf7JzVoZr8j+5YBDmOA2
	6GZYMiKTCP6Q5EXcOOBV98pZh2Ju5oRLeYIotRi7IENQ/i9xm+ipTyrnzSIvMoB2osueiuiv3RaDp
	pLvHNk+SX0/9QvD13a3x0aiU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzj2N-007irZ-2v;
	Tue, 01 Apr 2025 21:20:48 +0000
Message-ID: <0f0f9cfd-77be-4988-8043-0d1bd0d157e7@samba.org>
Date: Tue, 1 Apr 2025 23:20:45 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via optlen_t
 to proto[_ops].getsockopt()
To: Stanislav Fomichev <stfomichev@gmail.com>,
 Breno Leitao <leitao@debian.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Karsten Keil <isdn@linux-pingi.de>, Ayush Sawal <ayush.sawal@chelsio.com>,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
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
 <Z-sDc-0qyfPZz9lv@mini-arch> <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
 <407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
 <ed2038b1-0331-43d6-ac15-fd7e004ab27e@samba.org> <Z+wH1oYOr1dlKeyN@gmail.com>
 <Z-wKI1rQGSgrsjbl@mini-arch>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Z-wKI1rQGSgrsjbl@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 01.04.25 um 17:45 schrieb Stanislav Fomichev:
> On 04/01, Breno Leitao wrote:
>> On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher wrote:
>>> Am 01.04.25 um 15:37 schrieb Stefan Metzmacher:
>>>> Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:
>>>>> Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:
>>>>>> On 03/31, Stefan Metzmacher wrote:
>>>>>>> The motivation for this is to remove the SOL_SOCKET limitation
>>>>>>> from io_uring_cmd_getsockopt().
>>>>>>>
>>>>>>> The reason for this limitation is that io_uring_cmd_getsockopt()
>>>>>>> passes a kernel pointer as optlen to do_sock_getsockopt()
>>>>>>> and can't reach the ops->getsockopt() path.
>>>>>>>
>>>>>>> The first idea would be to change the optval and optlen arguments
>>>>>>> to the protocol specific hooks also to sockptr_t, as that
>>>>>>> is already used for setsockopt() and also by do_sock_getsockopt()
>>>>>>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
>>>>>>>
>>>>>>> But as Linus don't like 'sockptr_t' I used a different approach.
>>>>>>>
>>>>>>> @Linus, would that optlen_t approach fit better for you?
>>>>>>
>>>>>> [..]
>>>>>>
>>>>>>> Instead of passing the optlen as user or kernel pointer,
>>>>>>> we only ever pass a kernel pointer and do the
>>>>>>> translation from/to userspace in do_sock_getsockopt().
>>>>>>
>>>>>> At this point why not just fully embrace iov_iter? You have the size
>>>>>> now + the user (or kernel) pointer. Might as well do
>>>>>> s/sockptr_t/iov_iter/ conversion?
>>>>>
>>>>> I think that would only be possible if we introduce
>>>>> proto[_ops].getsockopt_iter() and then convert the implementations
>>>>> step by step. Doing it all in one go has a lot of potential to break
>>>>> the uapi. I could try to convert things like socket, ip and tcp myself, but
>>>>> the rest needs to be converted by the maintainer of the specific protocol,
>>>>> as it needs to be tested. As there are crazy things happening in the existing
>>>>> implementations, e.g. some getsockopt() implementations use optval as in and out
>>>>> buffer.
>>>>>
>>>>> I first tried to convert both optval and optlen of getsockopt to sockptr_t,
>>>>> and that showed that touching the optval part starts to get complex very soon,
>>>>> see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
>>>>> (note it didn't converted everything, I gave up after hitting
>>>>> sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
>>>>> sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
>>>>> more are the ones also doing both copy_from_user and copy_to_user on optval)
>>>>>
>>>>> I come also across one implementation that returned -ERANGE because *optlen was
>>>>> too short and put the required length into *optlen, which means the returned
>>>>> *optlen is larger than the optval buffer given from userspace.
>>>>>
>>>>> Because of all these strange things I tried to do a minimal change
>>>>> in order to get rid of the io_uring limitation and only converted
>>>>> optlen and leave optval as is.
>>>>>
>>>>> In order to have a patchset that has a low risk to cause regressions.
>>>>>
>>>>> But as alternative introducing a prototype like this:
>>>>>
>>>>>           int (*getsockopt_iter)(struct socket *sock, int level, int optname,
>>>>>                                  struct iov_iter *optval_iter);
>>>>>
>>>>> That returns a non-negative value which can be placed into *optlen
>>>>> or negative value as error and *optlen will not be changed on error.
>>>>> optval_iter will get direction ITER_DEST, so it can only be written to.
>>>>>
>>>>> Implementations could then opt in for the new interface and
>>>>> allow do_sock_getsockopt() work also for the io_uring case,
>>>>> while all others would still get -EOPNOTSUPP.
>>>>>
>>>>> So what should be the way to go?
>>>>
>>>> Ok, I've added the infrastructure for getsockopt_iter, see below,
>>>> but the first part I wanted to convert was
>>>> tcp_ao_copy_mkts_to_user() and that also reads from userspace before
>>>> writing.
>>>>
>>>> So we could go with the optlen_t approach, or we need
>>>> logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
>>>> with ITER_DEST...
>>>>
>>>> So who wants to decide?
>>>
>>> I just noticed that it's even possible in same cases
>>> to pass in a short buffer to optval, but have a longer value in optlen,
>>> hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores optlen.
>>>
>>> This makes it really hard to believe that trying to use iov_iter for this
>>> is a good idea :-(
>>
>> That was my finding as well a while ago, when I was planning to get the
>> __user pointers converted to iov_iter. There are some weird ways of
>> using optlen and optval, which makes them non-trivial to covert to
>> iov_iter.
> 
> Can we ignore all non-ip/tcp/udp cases for now? This should cover +90%
> of useful socket opts. See if there are any obvious problems with them
> and if not, try converting. The rest we can cover separately when/if
> needed.

That's what I tried, but it fails with
tcp_getsockopt ->
    do_tcp_getsockopt ->
      tcp_ao_get_mkts ->
         tcp_ao_copy_mkts_to_user ->
            copy_struct_from_sockptr
      tcp_ao_get_sock_info ->
         copy_struct_from_sockptr

That's not possible with a ITER_DEST iov_iter.

metze

