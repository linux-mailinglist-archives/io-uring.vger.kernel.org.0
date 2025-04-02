Return-Path: <io-uring+bounces-7374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B71FFA79851
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 00:38:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56C2A1893ED3
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 22:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6853B1F4C8D;
	Wed,  2 Apr 2025 22:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VH0AOJ4f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000401F4623;
	Wed,  2 Apr 2025 22:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743633494; cv=none; b=ex+6au4gsTSih7+pBgFd7bY2hGj5XRiNi0qGehC+MhpGetAqkGtdt6Xi/h60fTmjwCXFC+ZVzM2Z6RmNpIpfacTsQA9zHT29G1+nYBUNIR+BFhS+UEA/IEFpEwLsbRLuDz6KissKs6IaxzjG1idhU9Su3zbpe9RXw4OI2InzZTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743633494; c=relaxed/simple;
	bh=QyMAccHArRFUEMA0ZybJ2ZRJgcMsQGUttmrvj+2dU/g=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YYdRpL+7JMV/opg13bL9EkA45Ka0xZKCTWgRXGCgKUXPqJvwZzwA3wNMQcAVWaqQXUDDFW0G9xXuZ2LyaqXuQtHpD4cu+/nE9FAVSd3blIzSAYx+Joat6Hxr8bZoaH1wz0ffkxhaZW8j8BOQWuUnlUD8Wf0oAklFTAhPtsN5cMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VH0AOJ4f; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4394345e4d5so1615275e9.0;
        Wed, 02 Apr 2025 15:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743633489; x=1744238289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t1diHKPEGc7Id8XYuf2IxnytcV75OMWkcSNy9CRfawY=;
        b=VH0AOJ4fhB7EHRU4Oq6jGfBaLHqLiFFlNe8/60pO6j57yoG/FAO3W7jXutXXMkHgRt
         EAY527wH0Y6uuKV9U+kDdYwCvxzdrWfiamSCgvLLlTNOuZeFH7ccabT9J9l1OdiQcL87
         dNMbDxB7rKaO0MyCQyRl4cRUqh4m+DGApnm5cvfwKWiqrMX3MLOF7ZfaalqT9nuHQEDN
         NpltGAH3NQ6pW67+x7G5JdDboOC4oGcWDPPdQA2dkAHdYKqEnTTlLQMJlg43q04s1D60
         2pIz+mErj9WK6HIkW5sZwRjIlphbX6BcLAs2iVcOhysp3fTse2BuJSz6kihehpZQzQOv
         s5IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743633489; x=1744238289;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t1diHKPEGc7Id8XYuf2IxnytcV75OMWkcSNy9CRfawY=;
        b=HUFr0von/1LxF/cizEiz3gqLpF6GOFc2e1d6ubQKN+S9NUuF6XtUHi/+5QIY3x+42O
         Kt0hTw1aXbHPDi3anpUgsvCmPCnu1IeiQSHUJxLJeJizqtytzqEdtEb+vqjfNkZqkg1m
         bK5z1MioGt3AJH6IgqwRgzWzz+0nwrZBmVDtERwr2wOqO6GSjUyLvmXo8HSY2p6eT5jT
         G8gLkxSFFNdF/PpQLwkitDPKGajOdUJezKSwbfKf1pemlkZtpQkEHl/Cqm0NepCpdXq+
         tmM1G+FBvDeN/V5FlUIx0JT+sbES7LLSIu7ukHdNdA1193HM4vxNla6gMXeENGPOUxrK
         WVVw==
X-Forwarded-Encrypted: i=1; AJvYcCUBopEYAHOKFqfcnHwcr2nJke4y8Jgl/iNz615zjJoFBPC8mJ8RFT5Ni/sUt/FI/gflnN8Fm73gYUSfmg==@vger.kernel.org, AJvYcCUQGCxZvo2xtDupILqAHkTafhEfICNwtyrzx+UqqEHpQipcfnWt9RUcXii897LEtfOHkiCjLCpaP9RHct4XtXM6@vger.kernel.org, AJvYcCV2JCsp4F8VS2MFcrlCHoU8mM9bWusD8eYzRVXor7OCzEFzeFjasyMe/buYISPLh4TiDtk9Gg==@vger.kernel.org, AJvYcCVKFzhF3Q69fPC49QVErZSVTZX56xr3izOPWOffJIhoYlS378dOSyaNj4RknGnqWUnwQFDS5KixydT42w==@vger.kernel.org, AJvYcCW1+Y/HOc4TeO+sIIzJJn8E1tTZqQWyyehzQi6Gw0srt+LnGKFvMCFpsXgVAM/2iGmzrqY0T3jzCKZJ56/k@vger.kernel.org, AJvYcCW1I9qJpek22a1C6Ty+ZXFJU8ymIoLnYvTHnumJ/M2RMI8h6iuFaBaUYaFfPZL5ZZ5iguE=@vger.kernel.org, AJvYcCW2vvGbF3fEdJrQ8oEz4AWOhEHxRB1QEPDSgEr1Mz+KW3N7Tg++5WwCLd350WhniU7vj5A/tD5BKe4=@vger.kernel.org, AJvYcCWIGOPFsjnBrlSR/avnaTd9VUK1ZCFVhLEqCq8beYbrWtJDDHx+K248M/20Ic1GCYiyn5NkWyahfc50@vger.kernel.org, AJvYcCWPGgzIKxNvQlQGWmawfHAd9q7jRU0MFqbeD4zdOivP71Ll0LZT5d1PZo4KJY50m1o7RqyNvGZCZaNN@vger.kernel.org, AJvYcCWvoB2k+89PWPoJsfSaYzfcz4L9RNh0Y7Z7B2Lx
 CjDasUHTp5f7gSxCEkst14JbCE6USRpuZ+D45ULtcA==@vger.kernel.org, AJvYcCXQ4dyNj9UNkuWQxl14h7bJAQUJgaGKcxirecC8JUpYKKZYX+/mUmuCTXLYga8rGMet3nwYD36/5Lvc3g==@vger.kernel.org, AJvYcCXWdockLL3cJDzRvwdUIX6K/5204zXHjH4PQfuCdktison/u2ndAlCf3qM+2g1dVZe2DjFcq/SNN0iBEw==@vger.kernel.org, AJvYcCXtt7VeSymgeL0mSOXbYVL/J8p3W1LV0bHgoErNxdIpCZnPT6Kly24iUHkQX+16pKQDbZmDnuYj@vger.kernel.org
X-Gm-Message-State: AOJu0YxKL7z3roL0zzDlzhVp7FH50dM+C6phrcspRv0Ywfbd9tKLAtFs
	8HFXu1gC+WCvJewZhoZEDmZmtlbvvVzV4yQ6IS2yM3+EPSeRFmO7
X-Gm-Gg: ASbGncut/uOyhFRKvxFyrJgKHULs9vW4DQaqbZWCse9r6kT0P+VeDMTFlRdyvAR6SRQ
	jbaYvQgOBQ6yk39eWYpF4m7NPz4Be5inFR5H3PwQlPdruOKJ+EHN09wZXX/K87GhCVAEpLmsBZv
	kPW+9I98fBrsPmSVIV/IFGPqMjWQ5On6TkoKMNE7Uk2rk0nwDjg0gYkV/TRokKg87cHCiwzOszO
	tvsQ0nfWefE0NR20/hC3Ao1JkCNkmkNMioe0Cu3YMwPJng4i5A3voBSky6EKED+ZEl2vmlTKFQz
	B2O17NY1LoYwYLgCb8Ex8qjDUEKkflLKlk1sNJqcH3MXZb5UTQo0hjhiuRPjbhA+zZLUyUYU2Cl
	EgzOGhLw=
X-Google-Smtp-Source: AGHT+IGixqzhC2Qwqifdf8ByyftQ6fOugkJkfimMCdWUSausF3MeJcw4pdlkoqCsjupr2prYcZ0FYA==
X-Received: by 2002:a05:600c:6d45:b0:43c:e70d:4504 with SMTP id 5b1f17b1804b1-43eb63d417dmr27754705e9.19.1743633488458;
        Wed, 02 Apr 2025 15:38:08 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3020da17sm69168f8f.64.2025.04.02.15.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 15:38:07 -0700 (PDT)
Date: Wed, 2 Apr 2025 23:38:05 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, Breno Leitao <leitao@debian.org>,
 Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>, Karsten Keil
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
Message-ID: <20250402233805.464ed70e@pumpkin>
In-Reply-To: <Z-2qX_N2-jpMYSIy@mini-arch>
References: <407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
	<ed2038b1-0331-43d6-ac15-fd7e004ab27e@samba.org>
	<Z+wH1oYOr1dlKeyN@gmail.com>
	<Z-wKI1rQGSgrsjbl@mini-arch>
	<0f0f9cfd-77be-4988-8043-0d1bd0d157e7@samba.org>
	<Z-xi7TH83upf-E3q@mini-arch>
	<4b7ac4e9-6856-4e54-a2ba-15465e9622ac@samba.org>
	<20250402132906.0ceb8985@pumpkin>
	<Z-1Hgv4ImjWOW8X2@mini-arch>
	<20250402214638.0b5eed55@pumpkin>
	<Z-2qX_N2-jpMYSIy@mini-arch>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Apr 2025 14:21:35 -0700
Stanislav Fomichev <stfomichev@gmail.com> wrote:

> On 04/02, David Laight wrote:
> > On Wed, 2 Apr 2025 07:19:46 -0700
> > Stanislav Fomichev <stfomichev@gmail.com> wrote:
> >  =20
> > > On 04/02, David Laight wrote: =20
> > > > On Wed, 2 Apr 2025 00:53:58 +0200
> > > > Stefan Metzmacher <metze@samba.org> wrote:
> > > >    =20
> > > > > Am 02.04.25 um 00:04 schrieb Stanislav Fomichev:   =20
> > > > > > On 04/01, Stefan Metzmacher wrote:     =20
> > > > > >> Am 01.04.25 um 17:45 schrieb Stanislav Fomichev:     =20
> > > > > >>> On 04/01, Breno Leitao wrote:     =20
> > > > > >>>> On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher =
wrote:     =20
> > > > > >>>>> Am 01.04.25 um 15:37 schrieb Stefan Metzmacher:     =20
> > > > > >>>>>> Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:     =20
> > > > > >>>>>>> Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:     =20
> > > > > >>>>>>>> On 03/31, Stefan Metzmacher wrote:     =20
> > > > > >>>>>>>>> The motivation for this is to remove the SOL_SOCKET lim=
itation
> > > > > >>>>>>>>> from io_uring_cmd_getsockopt().
> > > > > >>>>>>>>>
> > > > > >>>>>>>>> The reason for this limitation is that io_uring_cmd_get=
sockopt()
> > > > > >>>>>>>>> passes a kernel pointer as optlen to do_sock_getsockopt=
()
> > > > > >>>>>>>>> and can't reach the ops->getsockopt() path.
> > > > > >>>>>>>>>
> > > > > >>>>>>>>> The first idea would be to change the optval and optlen=
 arguments
> > > > > >>>>>>>>> to the protocol specific hooks also to sockptr_t, as th=
at
> > > > > >>>>>>>>> is already used for setsockopt() and also by do_sock_ge=
tsockopt()
> > > > > >>>>>>>>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> > > > > >>>>>>>>>
> > > > > >>>>>>>>> But as Linus don't like 'sockptr_t' I used a different =
approach.
> > > > > >>>>>>>>>
> > > > > >>>>>>>>> @Linus, would that optlen_t approach fit better for you=
?     =20
> > > > > >>>>>>>>
> > > > > >>>>>>>> [..]
> > > > > >>>>>>>>     =20
> > > > > >>>>>>>>> Instead of passing the optlen as user or kernel pointer,
> > > > > >>>>>>>>> we only ever pass a kernel pointer and do the
> > > > > >>>>>>>>> translation from/to userspace in do_sock_getsockopt(). =
    =20
> > > > > >>>>>>>>
> > > > > >>>>>>>> At this point why not just fully embrace iov_iter? You h=
ave the size
> > > > > >>>>>>>> now + the user (or kernel) pointer. Might as well do
> > > > > >>>>>>>> s/sockptr_t/iov_iter/ conversion?     =20
> > > > > >>>>>>>
> > > > > >>>>>>> I think that would only be possible if we introduce
> > > > > >>>>>>> proto[_ops].getsockopt_iter() and then convert the implem=
entations
> > > > > >>>>>>> step by step. Doing it all in one go has a lot of potenti=
al to break
> > > > > >>>>>>> the uapi. I could try to convert things like socket, ip a=
nd tcp myself, but
> > > > > >>>>>>> the rest needs to be converted by the maintainer of the s=
pecific protocol,
> > > > > >>>>>>> as it needs to be tested. As there are crazy things happe=
ning in the existing
> > > > > >>>>>>> implementations, e.g. some getsockopt() implementations u=
se optval as in and out
> > > > > >>>>>>> buffer.
> > > > > >>>>>>>
> > > > > >>>>>>> I first tried to convert both optval and optlen of getsoc=
kopt to sockptr_t,
> > > > > >>>>>>> and that showed that touching the optval part starts to g=
et complex very soon,
> > > > > >>>>>>> see https://git.samba.org/?p=3Dmetze/linux/wip.git;a=3Dco=
mmitdiff;h=3D141912166473bf8843ec6ace76dc9c6945adafd1
> > > > > >>>>>>> (note it didn't converted everything, I gave up after hit=
ting
> > > > > >>>>>>> sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addr=
s.
> > > > > >>>>>>> sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_get=
sockopt_associnfo and maybe
> > > > > >>>>>>> more are the ones also doing both copy_from_user and copy=
_to_user on optval)
> > > > > >>>>>>>
> > > > > >>>>>>> I come also across one implementation that returned -ERAN=
GE because *optlen was
> > > > > >>>>>>> too short and put the required length into *optlen, which=
 means the returned
> > > > > >>>>>>> *optlen is larger than the optval buffer given from users=
pace.
> > > > > >>>>>>>
> > > > > >>>>>>> Because of all these strange things I tried to do a minim=
al change
> > > > > >>>>>>> in order to get rid of the io_uring limitation and only c=
onverted
> > > > > >>>>>>> optlen and leave optval as is.
> > > > > >>>>>>>
> > > > > >>>>>>> In order to have a patchset that has a low risk to cause =
regressions.
> > > > > >>>>>>>
> > > > > >>>>>>> But as alternative introducing a prototype like this:
> > > > > >>>>>>>
> > > > > >>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int (*=
getsockopt_iter)(struct socket *sock, int level, int optname,
> > > > > >>>>>>>   =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct iov_iter *=
optval_iter);
> > > > > >>>>>>>
> > > > > >>>>>>> That returns a non-negative value which can be placed int=
o *optlen
> > > > > >>>>>>> or negative value as error and *optlen will not be change=
d on error.
> > > > > >>>>>>> optval_iter will get direction ITER_DEST, so it can only =
be written to.
> > > > > >>>>>>>
> > > > > >>>>>>> Implementations could then opt in for the new interface a=
nd
> > > > > >>>>>>> allow do_sock_getsockopt() work also for the io_uring cas=
e,
> > > > > >>>>>>> while all others would still get -EOPNOTSUPP.
> > > > > >>>>>>>
> > > > > >>>>>>> So what should be the way to go?     =20
> > > > > >>>>>>
> > > > > >>>>>> Ok, I've added the infrastructure for getsockopt_iter, see=
 below,
> > > > > >>>>>> but the first part I wanted to convert was
> > > > > >>>>>> tcp_ao_copy_mkts_to_user() and that also reads from usersp=
ace before
> > > > > >>>>>> writing.
> > > > > >>>>>>
> > > > > >>>>>> So we could go with the optlen_t approach, or we need
> > > > > >>>>>> logic for ITER_BOTH or pass two iov_iters one with ITER_SR=
C and one
> > > > > >>>>>> with ITER_DEST...
> > > > > >>>>>>
> > > > > >>>>>> So who wants to decide?     =20
> > > > > >>>>>
> > > > > >>>>> I just noticed that it's even possible in same cases
> > > > > >>>>> to pass in a short buffer to optval, but have a longer valu=
e in optlen,
> > > > > >>>>> hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores=
 optlen.
> > > > > >>>>>
> > > > > >>>>> This makes it really hard to believe that trying to use iov=
_iter for this
> > > > > >>>>> is a good idea :-(     =20
> > > > > >>>>
> > > > > >>>> That was my finding as well a while ago, when I was planning=
 to get the
> > > > > >>>> __user pointers converted to iov_iter. There are some weird =
ways of
> > > > > >>>> using optlen and optval, which makes them non-trivial to cov=
ert to
> > > > > >>>> iov_iter.     =20
> > > > > >>>
> > > > > >>> Can we ignore all non-ip/tcp/udp cases for now? This should c=
over +90%
> > > > > >>> of useful socket opts. See if there are any obvious problems =
with them
> > > > > >>> and if not, try converting. The rest we can cover separately =
when/if
> > > > > >>> needed.     =20
> > > > > >>
> > > > > >> That's what I tried, but it fails with
> > > > > >> tcp_getsockopt ->
> > > > > >>     do_tcp_getsockopt ->
> > > > > >>       tcp_ao_get_mkts ->
> > > > > >>          tcp_ao_copy_mkts_to_user ->
> > > > > >>             copy_struct_from_sockptr
> > > > > >>       tcp_ao_get_sock_info ->
> > > > > >>          copy_struct_from_sockptr
> > > > > >>
> > > > > >> That's not possible with a ITER_DEST iov_iter.
> > > > > >>
> > > > > >> metze     =20
> > > > > >=20
> > > > > > Can we create two iterators over the same memory? One for ITER_=
SOURCE and
> > > > > > another for ITER_DEST. And then make getsockopt_iter accept opt=
val_in and
> > > > > > optval_out. We can also use optval_out position (iov_offset) as=
 optlen output
> > > > > > value. Don't see why it won't work, but I agree that's gonna be=
 a messy
> > > > > > conversion so let's see if someone else has better suggestions.=
     =20
> > > > >=20
> > > > > Yes, that might work, but it would be good to get some feedback
> > > > > if this would be the way to go:
> > > > >=20
> > > > >            int (*getsockopt_iter)(struct socket *sock,
> > > > > 				 int level, int optname,
> > > > > 				 struct iov_iter *optval_in,
> > > > > 				 struct iov_iter *optval_out);
> > > > >=20
> > > > > And *optlen =3D optval_out->iov_offset;
> > > > >=20
> > > > > Any objection or better ideas? Linus would that be what you had i=
n mind?   =20
> > > >=20
> > > > I'd worry about performance - yes I know 'iter' are used elsewhere =
but...
> > > > Also look at the SCTP code.   =20
> > >=20
> > > Performance usually does not matter for set/getsockopts, there
> > > are a few exceptions that I know (TCP_ZEROCOPY_RECEIVE) =20
> >=20
> > That might be the one that is really horrid and completely abuses
> > the 'length' parameter. =20
>=20
> It is reading and writing, yes, but it's not a huge problem. And it
> does enforce the optlen (to copy back the same amount of bytes). It's
> not that bad, it's just an example of where we need to be extra
> careful.
>=20
> > > and maybe recent
> > > devmem sockopts; we can special-case these if needed, or keep sockptr=
_t,
> > > idk. I'm skeptical we can convert everything though, that's why the
> > > suggestion to start with sk/ip/tcp/udp.
> > >  =20
> > > > How do you handle code that wants to return an updated length (ofte=
n longer
> > > > than the one provided) and an error code (eg ERRSIZE or similar).
> > > >
> > > > There is also a very strange use (I think it is a sockopt rather th=
an an ioctl)
> > > > where the buffer length the application provides is only that of th=
e header.
> > > > The actual buffer length is contained in the header.
> > > > The return length is the amount written into the full buffer.   =20
> > >=20
> > > Let's discuss these special cases as they come up? Worst case these
> > > places can always re-init iov_iter with a comment on why it is ok.
> > > But I do agree in general that there are a few places that do wild
> > > stuff. =20
> >=20
> > The problem is that the generic code has to deal with all the 'wild stu=
ff'. =20
>=20
> getsockopt_iter will have optval_in for the minority of socket options
> (like TCP_ZEROCOPY_RECEIVE) that want to read user's value as well
> as optval_out. The latter is what the majority of socket options
> will use to write their value. That doesn't seem too complicated to
> handle?
>=20
> > It is also common to do non-sequential accesses - so iov_iter doesn't m=
atch
> > at all. =20
>=20
> I disagree that it's 'common'. Searching for copy_from_sockptr_offset
> returns a few cases and they are mostly using read-with-offset because
> there is no sequential read (iterator) semantics with sockptr_t.
>=20
> > There also isn't a requirement for scatter-gather.
> >=20
> > For 'normal' getsockopt (and setsockopt) with short lengths it actually=
 makes
> > sense for the syscall wrapper to do the user copies.
> > But it would need to pass the user ptr+len as well as the kernel ptr+len
> > to give the required flexibilty.
> > Then you have to work out whether the final copy to user is needed or n=
ot.
> > (not that hard, but it all adds complication). =20
>=20
> Not sure I understand what's the problem. The user vs kernel part will
> be abstracted by iov_iter. The callers will have to write the optlen
> back. And there are two call sites we care about: io_uring and regular
> system call. What's your suggestion? Maybe I'm missing something. Do you
> prefer get_optlen/put_optlen?

I think the final aim should be to pass the user supplied length to the
per-protocol code and have it return the length/error to be passed back to =
the
user.

But in a lot of cases the syscall wrapper can do the buffer copies (as well
as the length copies).
That would be restricted to short length (on stack).
So code that needed a long buffer (like some of the sctp options)
would need to directly access the user buffer (or a long buffer provided
by an in-kernel user).

But you'll find code that reads/writes well beyond the apparent size of
the user buffer.
(And not just code that accesses 4 bytes without checking the length).

	David




