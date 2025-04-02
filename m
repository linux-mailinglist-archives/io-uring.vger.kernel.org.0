Return-Path: <io-uring+bounces-7365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FEACA78E88
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 14:34:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C71903B6271
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 12:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4120E238175;
	Wed,  2 Apr 2025 12:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E7gie9r3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CD71F2BBB;
	Wed,  2 Apr 2025 12:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743596957; cv=none; b=CNa8wvN5SdN576/yNs35GDf6FOZ6I0WDDo6SG12AjUP/0eFgqrp6J7Kwr5RqRvFvHboD4HS75Y3gnZduKGEmEgRhKpSGCvzD4w8QBePrhR4VHQhMfHh+YJ+lngoe2pgOzuYKYa7RqR3qZfovwmHhrnIOa6g/iJDHWCrHzC0gJP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743596957; c=relaxed/simple;
	bh=lp+YA/fs6Gmn5OE5Jny0VBAJxUFaGSyweqtyP+gBfCM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qXOteIYSoJJxWfqKXuDXoyGUkBSyV6AwIqx+ws6tRiaWhy5JgPsXvAgUGJl44CG4PZGegR7SnTgUsYIdIDmTMPXS7Zs7rlniCd7CtRMBqp30+qLX4JHBjuyzCFTNx9OWRDtCPcKRegpW/rzmrV/60gkyoGbXFhMg0u5iDBs6EfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E7gie9r3; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so5057125e9.1;
        Wed, 02 Apr 2025 05:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743596950; x=1744201750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Il534IhkejCI4Ayn2bikfVS/0bKncvWcHsPlCVwOuNc=;
        b=E7gie9r3h0HARzFgpvodC3nVK2idZnpG4Xjn1DSptMB/UkZuj+eUJPV6a29r4QejmP
         aOVggc5o1NPxcfkd73RBPHjK3MBCVRTzjp3kE6qhGS/lO4pzoFlvoNjZtSQ6j/0CTpE3
         84O1cy59Rp1ryiMJtxWCo6QrJ8HCXHWw4fa0zhMK4yPYUJwbg0IITfaSRlrAd+4qmmoQ
         3jai/kHl6Mtvk1WSt5zXTCh5yTB8cIUcn6YJIajwvjacHq8qZOHb/ImLsotnbMOVEy+t
         DZ0Z5W9zAkT9BxnFtiv3HSHjU66Up31tCSd0vl4c1pUDDhiLRxgXrfMZjXydgSpMriV8
         aKcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743596950; x=1744201750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Il534IhkejCI4Ayn2bikfVS/0bKncvWcHsPlCVwOuNc=;
        b=EvRZY19NyUfK1+ursu+4J+BCnKAw2rhCxiTXtl8ln1jvxZWhFlbTnDe9k6Ncn2qi6M
         iU4gXvpFJ6M/sUYoqmCNusjtFDNl+SH43gyglVbEDPHAWVH11NWMDqouv5bt5zq7oxkx
         EcWNQsJsex2JFYjDvZNOTcgAmlvvERiFK/yKtAKHIyYhLJrF41ZIz+V/MRqVchA/YAbm
         CeTIZ7Y9XNpSATad+3p89Vkzu90zhXT3R5LwOhXnydUQIOczlxXS+7ONR7rDT0XVmMxf
         ou6/poO6BCPzjrkwIY9nUZnGzEo8ES/GKtIJ+mS/QpfEAxI6lI4iHAUe5EAknTivmM1G
         1L3A==
X-Forwarded-Encrypted: i=1; AJvYcCU5IRlz4c9r3w5OqVeGapSt60C49r+C2SUbUBdFWxDktz2HIdZtr/n1vqB3afL9sCCC+kLrqA==@vger.kernel.org, AJvYcCUVDJHa67cEVRILPwCPayQHzUZrEznYY9oWHhnAJqXyihIkZvK9ci/L7lq5185ITrqFGSDQX3j9HKewAxZp@vger.kernel.org, AJvYcCV2yXnqY3zSVXUG8hBvIgJySUZJPiUFsw9R4jhCwUgYyWDXWqfRwWMfrCaA1RYr/mK9VnIf+IikbY2C@vger.kernel.org, AJvYcCVQGOhXS/DSgVMQKJQli1goKSnK69HgBTWvvxFs01IMCI+6P7YSRXjJoU5Sgk/Aah7Vk70f+XlT@vger.kernel.org, AJvYcCW7XR7IUxBaL03mrqY4j5JqK6j6LwkeET4bpRZp7ltCS+RqBsC6yZg1rKQxBC5sLM6PZbKIa/Mzv9r+4w==@vger.kernel.org, AJvYcCWIQiwM73lShDLATVF82st8dS39TDBIqw9A5W8GH6o/qauoKi64DGqhCY8pt6fsmQ9Pgrs+0382HyhH8g==@vger.kernel.org, AJvYcCWTlW3X5KJcqHTGx0Sbg3TO6Q0eEXiezmY3oMdgMvXWzR44oL/7CyyTFmREUKM6OmMHJ6XFJoebyvc2xg==@vger.kernel.org, AJvYcCWwGm329kYrCpt+hQDAbA2+Nsg6WwlaA7HWPXHrrshtJvcUZZXn98uvg3Mtbf/InA7deNU=@vger.kernel.org, AJvYcCWxOC3N0faC3btlcpFPCU0AreDujXXl7H8QugnDykZ6cRJGNtjzhZ18UnlvDs8B2gjxsI4r29RtZ6zEVA==@vger.kernel.org, AJvYcCX31l8aPRW7a5O6//AlemcSCFhckeSGJZn7aLSxvFXH
 TcemZDhvNvSjXArs5zQ7u0fb2YEup5O43xYE1IiSZX1A@vger.kernel.org, AJvYcCX6EJLxuXvwKcSnG6TH8QyNaKooH3ZfREYBi2NR8OfvQUvYftZ3m0pExZ25rtyEPNPdFzi3T3BPNoS2KQ==@vger.kernel.org, AJvYcCX7KbD+wHaYD5mR/mG6s4hl0N0KE1EilI1G9QbTZx8Tq4YITn/7ou4M38K1urtv5zIYdtocEfTx4NrO@vger.kernel.org, AJvYcCXxjVDJUiMhx5NiB+Kcj0EAtCNua7wqCRVAH6n+Hhl9lKGcPl16/+RNREoDDZEs9akYcO9sV+x/8bI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2aDL0LDzPveLjm++x+EVz603GP27LPpguPzJdCI7ct8cdEePv
	xrxBdf5wxYrBH2Fju34vpzAk4drBP3YvZDnIzPYccr7LK8DaSwBt
X-Gm-Gg: ASbGncvM7pXxLKfH4CCa5x/f2tSOj3L5K6Lt+lyUQri8lCJT7/S16+4j3QIFEHwzrdx
	dmQEffgqtEL8t4b57zRrsSOoXpINE7bbyaxWQqnlFkJdRsEmSJC0ye6KUFBG6/lZRGqMBEm2RXb
	VA1fp2nWSaqYFAG3NcUvuBNZBb9RSNi8HvuiUawNN7Ug+Tazqgt5YQqbuxoN/RrY2z3ZndjCuSE
	pvK9uX1FpOmWYgaeWPhOJAtWVqjC4tgrs2779/UNlYKgZGZleuGUSCWp5P4h2CYk/O+oUDH4DSB
	SycuWZT/Bi53GS1gjxmEpYjWfdVJS+Di0y27G94U8WX+iFJBlVvxPF1dGvwB/5aP9CrFMSj5h/t
	ri85zWDK8bP2Et86ZSg==
X-Google-Smtp-Source: AGHT+IEk7MA6QK3wmhaRTmYvHcjiHCHIud3xMp8o+rHoud6p5lee5Ws7y0rYVkxpRg0uiSAPvkTfhA==
X-Received: by 2002:a05:600c:22c6:b0:43b:baf7:76e4 with SMTP id 5b1f17b1804b1-43eb6fea8eemr16852415e9.1.1743596949724;
        Wed, 02 Apr 2025 05:29:09 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb60caac5sm19127485e9.17.2025.04.02.05.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 05:29:09 -0700 (PDT)
Date: Wed, 2 Apr 2025 13:29:06 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Stanislav Fomichev <stfomichev@gmail.com>, Breno Leitao
 <leitao@debian.org>, Linus Torvalds <torvalds@linux-foundation.org>, Jens
 Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Jakub
 Kicinski <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>, Karsten Keil
 <isdn@linux-pingi.de>, Ayush Sawal <ayush.sawal@chelsio.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Kuniyuki Iwashima <kuniyu@amazon.com>, Willem de
 Bruijn <willemb@google.com>, David Ahern <dsahern@kernel.org>, Marcelo
 Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long
 <lucien.xin@gmail.com>, Neal Cardwell <ncardwell@google.com>, Joerg Reuter
 <jreuter@yaina.de>, Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg
 <johan.hedberg@gmail.com>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Oliver Hartkopp <socketcan@hartkopp.net>, Marc Kleine-Budde
 <mkl@pengutronix.de>, Robin van der Gracht <robin@protonic.nl>, Oleksij
 Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de, Alexander Aring
 <alex.aring@gmail.com>, Stefan Schmidt <stefan@datenfreihafen.org>, Miquel
 Raynal <miquel.raynal@bootlin.com>, Alexandra Winter
 <wintera@linux.ibm.com>, Thorsten Winkler <twinkler@linux.ibm.com>, James
 Chapman <jchapman@katalix.com>, Jeremy Kerr <jk@codeconstruct.com.au>, Matt
 Johnston <matt@codeconstruct.com.au>, Matthieu Baerts <matttbe@kernel.org>,
 Mat Martineau <martineau@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Krzysztof Kozlowski <krzk@kernel.org>, Remi Denis-Courmont
 <courmisch@gmail.com>, Allison Henderson <allison.henderson@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne
 <marc.dionne@auristor.com>, Wenjia Zhang <wenjia@linux.ibm.com>, Jan
 Karcher <jaka@linux.ibm.com>, "D. Wythe" <alibuda@linux.alibaba.com>, Tony
 Lu <tonylu@linux.alibaba.com>, Wen Gu <guwen@linux.alibaba.com>, Jon Maloy
 <jmaloy@redhat.com>, Boris Pismenny <borisp@nvidia.com>, John Fastabend
 <john.fastabend@gmail.com>, Stefano Garzarella <sgarzare@redhat.com>,
 Martin Schiller <ms@dev.tdt.de>, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?=
 <bjorn@kernel.org>, Magnus Karlsson <magnus.karlsson@intel.com>, Maciej
 Fijalkowski <maciej.fijalkowski@intel.com>, Jonathan Lemon
 <jonathan.lemon@gmail.com>, Alexei Starovoitov <ast@kernel.org>, Daniel
 Borkmann <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-can@vger.kernel.org,
 dccp@vger.kernel.org, linux-wpan@vger.kernel.org,
 linux-s390@vger.kernel.org, mptcp@lists.linux.dev,
 linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com,
 linux-afs@lists.infradead.org, tipc-discussion@lists.sourceforge.net,
 virtualization@lists.linux.dev, linux-x25@vger.kernel.org,
 bpf@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
 io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via
 optlen_t to proto[_ops].getsockopt()
Message-ID: <20250402132906.0ceb8985@pumpkin>
In-Reply-To: <4b7ac4e9-6856-4e54-a2ba-15465e9622ac@samba.org>
References: <cover.1743449872.git.metze@samba.org>
	<Z-sDc-0qyfPZz9lv@mini-arch>
	<39515c76-310d-41af-a8b4-a814841449e3@samba.org>
	<407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
	<ed2038b1-0331-43d6-ac15-fd7e004ab27e@samba.org>
	<Z+wH1oYOr1dlKeyN@gmail.com>
	<Z-wKI1rQGSgrsjbl@mini-arch>
	<0f0f9cfd-77be-4988-8043-0d1bd0d157e7@samba.org>
	<Z-xi7TH83upf-E3q@mini-arch>
	<4b7ac4e9-6856-4e54-a2ba-15465e9622ac@samba.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Apr 2025 00:53:58 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> Am 02.04.25 um 00:04 schrieb Stanislav Fomichev:
> > On 04/01, Stefan Metzmacher wrote: =20
> >> Am 01.04.25 um 17:45 schrieb Stanislav Fomichev: =20
> >>> On 04/01, Breno Leitao wrote: =20
> >>>> On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher wrote: =
=20
> >>>>> Am 01.04.25 um 15:37 schrieb Stefan Metzmacher: =20
> >>>>>> Am 01.04.25 um 10:19 schrieb Stefan Metzmacher: =20
> >>>>>>> Am 31.03.25 um 23:04 schrieb Stanislav Fomichev: =20
> >>>>>>>> On 03/31, Stefan Metzmacher wrote: =20
> >>>>>>>>> The motivation for this is to remove the SOL_SOCKET limitation
> >>>>>>>>> from io_uring_cmd_getsockopt().
> >>>>>>>>>
> >>>>>>>>> The reason for this limitation is that io_uring_cmd_getsockopt()
> >>>>>>>>> passes a kernel pointer as optlen to do_sock_getsockopt()
> >>>>>>>>> and can't reach the ops->getsockopt() path.
> >>>>>>>>>
> >>>>>>>>> The first idea would be to change the optval and optlen argumen=
ts
> >>>>>>>>> to the protocol specific hooks also to sockptr_t, as that
> >>>>>>>>> is already used for setsockopt() and also by do_sock_getsockopt=
()
> >>>>>>>>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> >>>>>>>>>
> >>>>>>>>> But as Linus don't like 'sockptr_t' I used a different approach.
> >>>>>>>>>
> >>>>>>>>> @Linus, would that optlen_t approach fit better for you? =20
> >>>>>>>>
> >>>>>>>> [..]
> >>>>>>>> =20
> >>>>>>>>> Instead of passing the optlen as user or kernel pointer,
> >>>>>>>>> we only ever pass a kernel pointer and do the
> >>>>>>>>> translation from/to userspace in do_sock_getsockopt(). =20
> >>>>>>>>
> >>>>>>>> At this point why not just fully embrace iov_iter? You have the =
size
> >>>>>>>> now + the user (or kernel) pointer. Might as well do
> >>>>>>>> s/sockptr_t/iov_iter/ conversion? =20
> >>>>>>>
> >>>>>>> I think that would only be possible if we introduce
> >>>>>>> proto[_ops].getsockopt_iter() and then convert the implementations
> >>>>>>> step by step. Doing it all in one go has a lot of potential to br=
eak
> >>>>>>> the uapi. I could try to convert things like socket, ip and tcp m=
yself, but
> >>>>>>> the rest needs to be converted by the maintainer of the specific =
protocol,
> >>>>>>> as it needs to be tested. As there are crazy things happening in =
the existing
> >>>>>>> implementations, e.g. some getsockopt() implementations use optva=
l as in and out
> >>>>>>> buffer.
> >>>>>>>
> >>>>>>> I first tried to convert both optval and optlen of getsockopt to =
sockptr_t,
> >>>>>>> and that showed that touching the optval part starts to get compl=
ex very soon,
> >>>>>>> see https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dcommitdiff=
;h=3D141912166473bf8843ec6ace76dc9c6945adafd1
> >>>>>>> (note it didn't converted everything, I gave up after hitting
> >>>>>>> sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
> >>>>>>> sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_=
associnfo and maybe
> >>>>>>> more are the ones also doing both copy_from_user and copy_to_user=
 on optval)
> >>>>>>>
> >>>>>>> I come also across one implementation that returned -ERANGE becau=
se *optlen was
> >>>>>>> too short and put the required length into *optlen, which means t=
he returned
> >>>>>>> *optlen is larger than the optval buffer given from userspace.
> >>>>>>>
> >>>>>>> Because of all these strange things I tried to do a minimal change
> >>>>>>> in order to get rid of the io_uring limitation and only converted
> >>>>>>> optlen and leave optval as is.
> >>>>>>>
> >>>>>>> In order to have a patchset that has a low risk to cause regressi=
ons.
> >>>>>>>
> >>>>>>> But as alternative introducing a prototype like this:
> >>>>>>>
> >>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int (*getsocko=
pt_iter)(struct socket *sock, int level, int optname,
> >>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct iov_iter *optval_it=
er);
> >>>>>>>
> >>>>>>> That returns a non-negative value which can be placed into *optlen
> >>>>>>> or negative value as error and *optlen will not be changed on err=
or.
> >>>>>>> optval_iter will get direction ITER_DEST, so it can only be writt=
en to.
> >>>>>>>
> >>>>>>> Implementations could then opt in for the new interface and
> >>>>>>> allow do_sock_getsockopt() work also for the io_uring case,
> >>>>>>> while all others would still get -EOPNOTSUPP.
> >>>>>>>
> >>>>>>> So what should be the way to go? =20
> >>>>>>
> >>>>>> Ok, I've added the infrastructure for getsockopt_iter, see below,
> >>>>>> but the first part I wanted to convert was
> >>>>>> tcp_ao_copy_mkts_to_user() and that also reads from userspace befo=
re
> >>>>>> writing.
> >>>>>>
> >>>>>> So we could go with the optlen_t approach, or we need
> >>>>>> logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
> >>>>>> with ITER_DEST...
> >>>>>>
> >>>>>> So who wants to decide? =20
> >>>>>
> >>>>> I just noticed that it's even possible in same cases
> >>>>> to pass in a short buffer to optval, but have a longer value in opt=
len,
> >>>>> hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores optlen.
> >>>>>
> >>>>> This makes it really hard to believe that trying to use iov_iter fo=
r this
> >>>>> is a good idea :-( =20
> >>>>
> >>>> That was my finding as well a while ago, when I was planning to get =
the
> >>>> __user pointers converted to iov_iter. There are some weird ways of
> >>>> using optlen and optval, which makes them non-trivial to covert to
> >>>> iov_iter. =20
> >>>
> >>> Can we ignore all non-ip/tcp/udp cases for now? This should cover +90%
> >>> of useful socket opts. See if there are any obvious problems with them
> >>> and if not, try converting. The rest we can cover separately when/if
> >>> needed. =20
> >>
> >> That's what I tried, but it fails with
> >> tcp_getsockopt ->
> >>     do_tcp_getsockopt ->
> >>       tcp_ao_get_mkts ->
> >>          tcp_ao_copy_mkts_to_user ->
> >>             copy_struct_from_sockptr
> >>       tcp_ao_get_sock_info ->
> >>          copy_struct_from_sockptr
> >>
> >> That's not possible with a ITER_DEST iov_iter.
> >>
> >> metze =20
> >=20
> > Can we create two iterators over the same memory? One for ITER_SOURCE a=
nd
> > another for ITER_DEST. And then make getsockopt_iter accept optval_in a=
nd
> > optval_out. We can also use optval_out position (iov_offset) as optlen =
output
> > value. Don't see why it won't work, but I agree that's gonna be a messy
> > conversion so let's see if someone else has better suggestions. =20
>=20
> Yes, that might work, but it would be good to get some feedback
> if this would be the way to go:
>=20
>            int (*getsockopt_iter)(struct socket *sock,
> 				 int level, int optname,
> 				 struct iov_iter *optval_in,
> 				 struct iov_iter *optval_out);
>=20
> And *optlen =3D optval_out->iov_offset;
>=20
> Any objection or better ideas? Linus would that be what you had in mind?

I'd worry about performance - yes I know 'iter' are used elsewhere but...
Also look at the SCTP code.

How do you handle code that wants to return an updated length (often longer
than the one provided) and an error code (eg ERRSIZE or similar).

There is also a very strange use (I think it is a sockopt rather than an io=
ctl)
where the buffer length the application provides is only that of the header.
The actual buffer length is contained in the header.
The return length is the amount written into the full buffer.

	David



