Return-Path: <io-uring+bounces-7331-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DFF7EA76F26
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 22:27:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 957FA168B2D
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 20:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1744C219A86;
	Mon, 31 Mar 2025 20:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1xyxNhXA"
X-Original-To: io-uring@vger.kernel.org
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1731CAA90;
	Mon, 31 Mar 2025 20:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743452850; cv=none; b=Lhg80K6y8Dzrx91Bb2sFMP+edgB7vyicOTFxAuss6umDBAokQ8mNwM7Rj1fFLAq8+CSgbfugbicd8Q/0RuCOCiyUWe1Uu2wfZWdXzZCN07BkadYATqW7T4s4+BXipxLyMugG6kh3Na8kIRQG54Z6tBbOQiLDkpXGrIoVsCVuRqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743452850; c=relaxed/simple;
	bh=vYhCw4nnQmvtyifVwDW6bFGacU6nCINp4M+2BQ1vpis=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TV9/ltKq0hSU4b99KrjQw53lKSGHTMpeiJAoGPsq/FLoPDvE/yACVUTteLELLmwvA5MBKTWocw6dlfwwWK5Dvqhy/h57zEhoF/cf9jX1npvvM50x0JZt6+AmxiVAZ3diYqleCL2wdI0vmhOZonOO2AeCw9nMEnQU9165Fs9Uezw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1xyxNhXA; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=vYhCw4nnQmvtyifVwDW6bFGacU6nCINp4M+2BQ1vpis=; b=1xyxNhXAAZkumfn+rj9gjbDgJq
	Cac07i2SbLbMyd3WejpqlYAZVYYUr44gazhhYrd4YT8aNL7InIJUa8HDHDKrH39rL+yAODAtOH/7W
	O4j8vi/2JqQUU3hGyXW+acp0G6EuYTesgDP9t4I9fOHGiXRet9y7HD+n8rGRvNAOznCzq5roEUY1m
	7BoGjfNMB6lVKOw406lFzYc91MyD8ADG8uM9jOeXlxWWzT+NqbO0Sr5tRTkGP8ry5YaR6uzAZQ3rt
	ykbUgPvgPMRkNTbX7AqOM/i8CQiNgBDue667YAS2zuEXYboBuiyDbB0DNmEUv/4KIaGtzEw0IHpur
	YBO6gx7cElsGJEN1IsJxDEiAO4N3dhfj+icUDr4RWA6qGmhE/J1uSHf0gocR9WXKmoZDAvdVBjjMC
	T5H55JVmt3id6TXT5t3Q0YgS8tKzB4WMMNOB4EQYHjzySVUlsBn/xb34lZ6+LVMKIgkQ6MV+AO7RS
	d1XvbBcwupfsWYYJr0+8JKjv;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1tzLj6-007YEh-3D;
	Mon, 31 Mar 2025 20:27:21 +0000
Message-ID: <62ef4f1e-a726-423a-a765-ee584ee681c0@samba.org>
Date: Mon, 31 Mar 2025 22:27:17 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] net: pass 'optlen_t' to proto[ops].getsockopt()
 hooks
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Breno Leitao
 <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>,
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
 <76db80040bdeeb4a0221b5b6583fda4988afa64e.1743449872.git.metze@samba.org>
Content-Language: en-US, de-DE
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <76db80040bdeeb4a0221b5b6583fda4988afa64e.1743449872.git.metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

PiBkaWZmIC0tZ2l0IGEvbmV0L3NvY2tldC5jIGIvbmV0L3NvY2tldC5jDQo+IGluZGV4IDlh
MGU3MjBmMDg1OS4uZmEyZGUxMmMxMGU2IDEwMDY0NA0KPiAtLS0gYS9uZXQvc29ja2V0LmMN
Cj4gKysrIGIvbmV0L3NvY2tldC5jDQo+IEBAIC0yMzUwLDEyICsyMzUwLDE1IEBAIGludCBk
b19zb2NrX2dldHNvY2tvcHQoc3RydWN0IHNvY2tldCAqc29jaywgYm9vbCBjb21wYXQsIGlu
dCBsZXZlbCwNCj4gICAJfSBlbHNlIGlmICh1bmxpa2VseSghb3BzLT5nZXRzb2Nrb3B0KSkg
ew0KPiAgIAkJZXJyID0gLUVPUE5PVFNVUFA7DQo+ICAgCX0gZWxzZSB7DQo+IC0JCWlmIChX
QVJOX09OQ0Uob3B0dmFsLmlzX2tlcm5lbCB8fCBvcHRsZW4uaXNfa2VybmVsLA0KPiArCQlv
cHRsZW5fdCBfb3B0bGVuID0geyAudXAgPSBOVUxMLCB9Ow0KPiArDQo+ICsJCWlmIChXQVJO
X09OQ0Uob3B0dmFsLmlzX2tlcm5lbCwNCg0KU29ycnksIHRoZSByZW1vdmFsIG9mICd8fCBv
cHRsZW4uaXNfa2VybmVsJyBzaG91bGQgYmUgaW4gdGhlIG5leHQgY29tbWl0Li4uDQoNCj4g
ICAJCQkgICAgICAiSW52YWxpZCBhcmd1bWVudCB0eXBlIikpDQo+ICAgCQkJcmV0dXJuIC1F
T1BOT1RTVVBQOw0KDQoNCg==

