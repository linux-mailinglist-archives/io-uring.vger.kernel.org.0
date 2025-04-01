Return-Path: <io-uring+bounces-7339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D2DA77AC3
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 14:23:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F1991886FFD
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 12:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DBF2202F7B;
	Tue,  1 Apr 2025 12:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="NNx7X1Kg"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237C51EC01F;
	Tue,  1 Apr 2025 12:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743510186; cv=none; b=kFtQzMQ4KIb/2CD3NkC8rES50yDZ7LNE4ldukAh9cnzVlrf5IRpJH3EiIiF+90B1htTg2kOlbCI1bR4E66YYI3jsotM88fvC7GaKwbxS/MoNpjzmcgtHF/RAOqCruWExcp1JnQ3UTq6sPP85fGVJQg74e29oMbMiXfrZyYQ9Xsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743510186; c=relaxed/simple;
	bh=nuFVkx1gSbh4qc7RrSJfuZzmwSyBRBVnMv6MbRTUtVo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M+3CGc25SHpXV1eiiC/ujzSosyAZRhsFgPnqfapoSDb5nubHKQemvyLGzGmNIvRYsm/FFxC6LDLgYNQqFCBf9Hs22CYP54pjb0AofitVcdsCQm20kvF3J0o7PosJ1Y5FkpVWO0t0jNLDcEX11RapvoDkqbifa7JdU+F5dI6Jtc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=NNx7X1Kg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=fXdP5m0ZfPSz1DCg8m7bHCvssJrloz5WEMURjzb5wGU=; b=NNx7X1KgxaoNizApKT4nEGh0VL
	TGXirsgcIpnzdque+dVehm+1Tms3SXSsd7iM+6q4mUCrukCWCzPb/kRCv/sWx7yfj1mHD9NU7X6oo
	epSzGFjQ4i5pCNGDZ8QPQgJ2B6Re9BC6Ic1yBAfMTuxRJRIzF8JRwzrmeFYIpXjJOlTA4ZYCL5do8
	ZXZfYvn8pBVK6gXe68FC77o8qpqw3oTmlW5HTc62MArhedoCnqSIkZItfNurjAp5ZL7aQ3vcj1isa
	cpWbEDYpECNC8BStyIHEbTHmr+MyjMxWa/mLIsm5UpwuJKQZ9Oy6QjDb2MPF0QJFHSQyp46vgkHts
	vSV/eLKzGqGbmWRDHFg2h9Gp/NLJlQ1p55u0hN8SVsl/TkKI6+b3vm5ZUkb0CeiPnAYUdAw0kygT+
	g70lflOMXItrRQip5T+0JvwyCbtEkovTQg7l4G1+ZAUuzdVHJgcZf0MkUOq6EkXxnsRniPEgSIL2e
	pp2AWQE9Cjwn43SOh2NEtikk;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzadp-007fH3-2j;
	Tue, 01 Apr 2025 12:22:53 +0000
Message-ID: <90334e83-618b-41e0-a35c-9ce8b0d1d990@samba.org>
Date: Tue, 1 Apr 2025 14:22:50 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] net: introduce get_optlen() and put_optlen()
 helpers
To: Breno Leitao <leitao@debian.org>
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
 <156e83128747b2cf7c755bffa68f2519bd255f78.1743449872.git.metze@samba.org>
 <Z+vZRcbvh6r1fnZL@gmail.com>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Z+vZRcbvh6r1fnZL@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Breno,

> On Mon, Mar 31, 2025 at 10:10:53PM +0200, Stefan Metzmacher wrote:
>> --- a/include/linux/sockptr.h
>> +++ b/include/linux/sockptr.h
>> @@ -169,4 +169,26 @@ static inline int check_zeroed_sockptr(sockptr_t src, size_t offset,
>>   	return memchr_inv(src.kernel + offset, 0, size) == NULL;
>>   }
>>   
>> +#define __check_optlen_t(__optlen)				\
>> +({								\
>> +	int __user *__ptr __maybe_unused = __optlen; 		\
>> +	BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(int));		\
>> +})
> 
> I am a bit confused about this macro. I understand that this macro's
> goal is to check that __optlen is a pointer to an integer, otherwise
> failed to build.
> 
> It is unclear to me if that is what it does. Let's suppose that __optlen
> is not an integer pointer. Then:
> 
>> int __user *__ptr __maybe_unused = __optlen;
> 
> This will generate a compile failure/warning due invalid casting,
> depending on -Wincompatible-pointer-types.
> 
>> BUILD_BUG_ON(sizeof(*(__ptr)) != sizeof(int));
> 
> Then this comparison will always false, since __ptr is a pointer to int,
> and you are comparing the size of its content with the sizeof(int).

Yes, it redundant in the first patch, it gets little more useful in
the 2nd and 3rd patch.

metze

