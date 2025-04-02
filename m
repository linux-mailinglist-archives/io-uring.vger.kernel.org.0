Return-Path: <io-uring+bounces-7361-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87616A785D8
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 02:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 112E87A139C
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 00:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 776962E3365;
	Wed,  2 Apr 2025 00:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VshFKHa9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6509FB674
	for <io-uring@vger.kernel.org>; Wed,  2 Apr 2025 00:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743554915; cv=none; b=b82Y7JsDNPCtvzDtS3Go4ENEjOSjD6u32QU+5r8IpkjLKL1XPeK6JPg3PiLFMDv2zwyfb+0kNalx+9K0HNt74mpPuv2ZPo/eZZNx2Dsn/U076cMgIhv/odvk52FqfO75Bo8Gce7u07eucSGS3lnQ4uxAT1SsvyDh4b3RMSSSHo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743554915; c=relaxed/simple;
	bh=gKvtz1iMes15Dk29gHgnGLSQ0AzIDyIu+TI574Yzf08=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxB3xBabs6uoygcTod22HBNYCHN1tCrGsM+EYSHBnra1vNph9rZ1U7TjhF0S3mV3xVJmjh7cRi3EkX4wBBDlU8adMI4rWz2TBRXBb/szOkLEHvi6GVoA0hK/9BcEuLbrJ0J6LZOmXZxN+STCOJyWcpxG8MZb8ecIIDY3iQa24kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VshFKHa9; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac2aeada833so72235966b.0
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 17:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1743554911; x=1744159711; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vu/Ham6OvzEjp0kQLpwOmOKgb686vhg9IiykSVIyewU=;
        b=VshFKHa9ofOS2x4BxQn0QPR7i9HnqgL2/8FD58vTVzr3KA1jeG7Q+Q8bQR8xhjtEWb
         HRmVJgOY1t1f8o20b8fG6PBUsGsk7YPEZJYgKHoY2U1YfhotWS/x0Cnqt4+6MPaOCRkW
         X1CZKf2R1fTbFlMMHDWZlwJ8TZcXq5JLN4Sjs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743554911; x=1744159711;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vu/Ham6OvzEjp0kQLpwOmOKgb686vhg9IiykSVIyewU=;
        b=Pgoj+Ki500A2j81AxlKzcFXQgPwlSYbsYMM9ZVP7tw3Yfk4n20PLLZPhshQg7QdgDK
         TGDcLstJMf4tpljSABjzPUCe+riNIwLFQ+mwTOSrogVJprx1JBg/vFsIcIMFoKRu5vyb
         oW1BUx+cpw6S8YG6cg4Wk3xKTF2ZN7uwYvBLC39F1hMXMzMXoFqn76WhqUanrZOU8wBb
         t8ZPjmEMIKSOWg+0uYrPdF02+6EOjWvNU8cQbTftp9g8LTB5gbVI7lK2dhHwLfgfx3vg
         gi8KGtqZKgEqLNUMVbt9l73yw2nMY3QCKtvaHuL+/pFNeyJyis3uE/ly5VWGVAKPXbt5
         iy2A==
X-Forwarded-Encrypted: i=1; AJvYcCUD6DqgypZiTj6pJEPWf4neTel+896EZDjrl3tFuxAadcuM5K2kMuOrO7VyZhqK5zFoHHYpnZXsMA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzKxrgMDMBXFqWqpOo6EB96JHkrAWutPEHo4U968u5QqDYTryVk
	EY59EJwpXTMiZlChlQar1O7ahUFs8t1p2vWbEOCkkmFp410b8aOPznsqhGIq+Ys4YQEA+2RdLrD
	Yf0V/Ew==
X-Gm-Gg: ASbGncuoIuAMpx1AzPcLIYQKMhFpErhRHK6TfRtGiAgBETQtEEDAl9zh6gjArnw4bn4
	to2VTeBYamErkk+KDeIGjsjI8bc7rqmFRaz5GyikE9joT4UyNcq4EcIFVYf6HuIUDhnuKJ7qL3e
	Ba7DfUVDBPIRO2CRQ2lyDKYT1Zyobg1hcGFAjLENswEvd0LDWAUaCy6lvNHvMyOXrhfpo9SRrJC
	NAmCsB/Yy30EmthZRNYWVfnzL52LjavsiRBMvYBzBYqLyJKo2duA8ZQkkfHykW5R3AsisfKVaYo
	Z5an13AMZ4otTjTFsrA51a7HYec7KuwWScHjtIYbIwqjMOgg7lajo6Vo5WfCl55B2/7HgD3Jt6M
	fMvlAQeUaAn9Cb7iAVGo=
X-Google-Smtp-Source: AGHT+IGXSFeTnydDYtwVYrbmK/K6Bjm7HZSJLhqI+WuLUIldKWknnciND98yLup2ckda2Vkh5zIo8Q==
X-Received: by 2002:a17:907:c10:b0:ac4:3d0:8bca with SMTP id a640c23a62f3a-ac7a5dcec8amr3659066b.29.1743554911461;
        Tue, 01 Apr 2025 17:48:31 -0700 (PDT)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f0cfsm831988866b.116.2025.04.01.17.48.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 17:48:31 -0700 (PDT)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e614da8615so693306a12.1
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 17:48:31 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXwVo394xZbWWsDofdh5BOtrYGSqDS5GG0+rxcdSwsN39veBWzMWYEcFY6ay3wDQGlE3q69jjNMhA==@vger.kernel.org
X-Received: by 2002:a17:906:5a58:b0:ac6:b80b:2331 with SMTP id
 a640c23a62f3a-ac7a5a6a7femr5394166b.4.1743554436373; Tue, 01 Apr 2025
 17:40:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1743449872.git.metze@samba.org>
In-Reply-To: <cover.1743449872.git.metze@samba.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 1 Apr 2025 17:40:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com>
X-Gm-Features: AQ5f1JqzSUFwvrLn7ljSUlWXdbqdVpjtPJUQgf_7X3eWbMud67Mtv15-jjUkgBs
Message-ID: <CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via optlen_t
 to proto[_ops].getsockopt()
To: Stefan Metzmacher <metze@samba.org>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Breno Leitao <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Karsten Keil <isdn@linux-pingi.de>, Ayush Sawal <ayush.sawal@chelsio.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Neal Cardwell <ncardwell@google.com>, Joerg Reuter <jreuter@yaina.de>, 
	Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp <socketcan@hartkopp.net>, 
	Marc Kleine-Budde <mkl@pengutronix.de>, Robin van der Gracht <robin@protonic.nl>, 
	Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de, 
	Alexander Aring <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Alexandra Winter <wintera@linux.ibm.com>, 
	Thorsten Winkler <twinkler@linux.ibm.com>, James Chapman <jchapman@katalix.com>, 
	Jeremy Kerr <jk@codeconstruct.com.au>, Matt Johnston <matt@codeconstruct.com.au>, 
	Matthieu Baerts <matttbe@kernel.org>, Mat Martineau <martineau@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Krzysztof Kozlowski <krzk@kernel.org>, 
	Remi Denis-Courmont <courmisch@gmail.com>, Allison Henderson <allison.henderson@oracle.com>, 
	David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>, 
	Wenjia Zhang <wenjia@linux.ibm.com>, Jan Karcher <jaka@linux.ibm.com>, 
	"D. Wythe" <alibuda@linux.alibaba.com>, Tony Lu <tonylu@linux.alibaba.com>, 
	Wen Gu <guwen@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>, 
	Boris Pismenny <borisp@nvidia.com>, John Fastabend <john.fastabend@gmail.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Martin Schiller <ms@dev.tdt.de>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, 
	Magnus Karlsson <magnus.karlsson@intel.com>, 
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>, Jonathan Lemon <jonathan.lemon@gmail.com>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org, 
	dccp@vger.kernel.org, linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org, 
	mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, 
	linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net, 
	virtualization@lists.linux.dev, linux-x25@vger.kernel.org, 
	bpf@vger.kernel.org, isdn4linux@listserv.isdn4linux.de, 
	io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

"

On Mon, 31 Mar 2025 at 13:11, Stefan Metzmacher <metze@samba.org> wrote:
>
> But as Linus don't like 'sockptr_t' I used a different approach.

So the sockptr_t thing has already happened. I hate it, and I think
it's ugly as hell, but it is what it is.

I think it's a complete hack and having that "kernel or user" pointer
flag is disgusting.

Making things worse, the naming is disgusting too, talking about some
random "socket pointer", when it has absolutely nothing to do with
socket, and isn't even a pointer. It's something else.

It's literally called "socket" not because it has anything to do with
sockets, but because it's a socket-specific hack that isn't acceptable
anywhere else in the kernel.

So that "socket" part of the name is literally shorthand for "only
sockets are disgusting enough to use this, and nobody else should ever
touch this crap".

At least so far that part has mostly worked, even if there's some
"sockptr_t" use in the crypto code. I didn't look closer, because I
didn't want to lose my lunch.

I don't understand why the networking code uses that thing.

If you have a "fat pointer", you should damn well make it have the
size of the area too, and do things *right*.

Instead of doing what sockptr_t does, which is a complete hack to just
pass a kernel/user flag, and then passes the length *separately*
because the socket code couldn't be arsed to do the right thing.

So I do still think "sockptr_t" should die.

As Stanislav says, if you actually want that "user or kernel" thing,
just use an "iov_iter".

No, an "iov_iter" isn't exactly a pretty thing either, but at least
it's the standard way to say "this pointer can have multiple different
kinds of sources".

And it keeps the size of the thing it points to around, so it's at
least a fat pointer with proper ranges, even if it isn't exactly "type
safe" (yes, it's type safe in the sense that it stays as a "iov_iter",
but it's still basically a "random pointer").

> @Linus, would that optlen_t approach fit better for you?

The optlen_t thing is slightly better mainly because it's more
type-safe. At least it's not a "random misnamed
user-or-kernel-pointer" thing where the name is about how nothing else
is so broken as to use it.

So it's better because it's more limited, and it's better in that at
least it has a type-safe pointer rather than a "void *" with no size
or type associated with it.

That said, I don't think it's exactly great.

It's just another case of "networking can't just do it right, and uses
a random hack with special flag values".

So I do think that it would be better to actually get rid of
"sockptr_t optval, unsigned int optlen" ENTIRELY, and replace that
with iov_iter and just make networking bite the bullet and do the
RightThing(tm).

In fact, to make it *really* typesafe, it might be a good idea to wrap
the iov_iter in another struct, something like

   typedef struct sockopt {
        struct iov_iter iter;
   } sockopt_t;

and make the networking functions make the typing very clear, and end
up with an interface something like

   int do_tcp_setsockopt(struct sock *sk,
                     int level, int optname,
                     sockopt_t *val);

where that "sockopt_t *val" replaces not just the "sockptr_t optval",
but also the "unsigned int optlen" thing.

And no, I didn't look at how much churn that would be. Probably a lot.
Maybe more than people are willing to do - even if I think some of it
could be automated with coccinelle or whatever.

                Linus

