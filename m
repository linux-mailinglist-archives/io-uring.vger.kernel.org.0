Return-Path: <io-uring+bounces-7347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5825DA77F45
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 17:45:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4653016CE5B
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 15:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CB520C461;
	Tue,  1 Apr 2025 15:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IlUb/NJm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B20B1EB19A;
	Tue,  1 Apr 2025 15:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743522344; cv=none; b=agOlZXuuuF5BAM7Xr59n9/ArHO8FhU4ybiT66R+ZwiXtl/Hwf/DVuQIpoFKoCWL5VPEBJFJUcgoUdHVPwA/RCrYe27ZKydamqQqmblvpAaU/zZEgEcdGmw0jClmlTAtHClIeQ/EaYtDfWSP93Wk+yS44XdojRIrTvzL0Km8yvwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743522344; c=relaxed/simple;
	bh=WBy7/6zN4feM/TeCGcXiAJPz1NiTYo51RtnynhTaOM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AF4xALAKLO67GBmk/VUPSJ8wmnooPp56jgV5GpUW3dS344/HFTuHr12e/PYFe3pO//uyV8fmUVA07RDnrn963/tQ4N6I6qWl/QcsaAmpov01DE/R6m1m6guNhxE19Q+jWEzBMJyoK61b9cjoW0PKgDnu3cfJV/ZxNXq0bZZldag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IlUb/NJm; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-224019ad9edso30283745ad.1;
        Tue, 01 Apr 2025 08:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743522341; x=1744127141; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Kzegyg8cpGoKhVLZCKUfoTEzY8SEhsuSorY4Wg6W7wk=;
        b=IlUb/NJmDd+jXbBkm2j3X4/qbX9tLdvY+lq4ly40ihU+XoIeqKyNy5FT7Ar+XvapOO
         6OPTtzLlQgvpe/K5ib36AyKGwcBvn4ES/MvXedwXV0QtauVG3VuM0BBPDcJK9PWEtAO/
         SDqd2U0r6IiE0v7XGDRYgxDgIcWb/UsmOAuTVLOwIIFm+a+6rfSAUprJzsdEkCxrEzaa
         MSuZKbMvXOd/+BfPoCgPR+OZGDRSc0sahpNtYQ6pHpA3GSDYpaKO7njh0ngxqpC34Gg9
         GtYtPOph5KxOOUmuuutxPmSuadD8TedBQ+LYFKu6OH5B3bm1V8tt7VT5MWpPp46Dvp29
         idaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743522341; x=1744127141;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kzegyg8cpGoKhVLZCKUfoTEzY8SEhsuSorY4Wg6W7wk=;
        b=fm389fWXx6fq47oTkuwZ3x4Cd1AZut3umgi+lnd0ohRTP96EzHn9b7CkCIjOjNDkTs
         J3ZUA5YDVdM4vxgFBIpkbY6hDuvgWhWxWmjk/gHvIG5X/wO6fc3jIBRuS3GsKYFBTGhT
         G8vVEwDhNDFTNW1mxdDnF8W9Dv3DZeCzVaKYcBv4RSG1jFkq2CxEEszLrq6+u7nFLP10
         UQO5J4yB9QoxYvMH03IazKJduhfBYcHSVQ2VrmEGgHtc6Rlw0tCbvoeNUZnnTYDEEaa1
         lCeKlhAXECROO+LH2HfPaccxIVKcyiA6s4Vb1n4d6jw4LD/tXI3OaefTjXx4GQdVfZH8
         IRxw==
X-Forwarded-Encrypted: i=1; AJvYcCUHxxLXar0fdfOq7kfvdRxu5/WDCxmzBK2cU4q36+knYQ37zUZb31NsuxgdihTfYpmvL/7NM1eD8WLKhQ==@vger.kernel.org, AJvYcCUNAFIiShfdkX5RNBx5jms5d2OGrlbDIa2kxzYtrXeOtX+dTVFBKrYFQsxIF73v5gKxFxZKiqXfBLY=@vger.kernel.org, AJvYcCVBw87wYoRh0pU0r+94MoHEDNakbAee9Vw/hcc8B69LyysrqO0aXr+z9JqW3jDkuk47NbaHUCceiItzMQ==@vger.kernel.org, AJvYcCVEZnxbGHAv7eJzKR5qjMiwpotL0QXSkrF5QvmWLAZHYC7rg2L1MWpACZdiqspiv7u/vS/nqFZG6U3zlE6B@vger.kernel.org, AJvYcCVfS6Me2xxZhQvG4YaX5RIQj4ZrVamV9Xmt39+T9pWqpGimgN1ZXPJLKvlu4scO3LRjr/+7N0DR98RApX9/M/F6@vger.kernel.org, AJvYcCVxEbj6Xc84sDJ0a0q/RgDRepIn1jGKU3U/8TgiMtH8q9IwDPo2zLleG+PRBQkAsLYhwqIqPA==@vger.kernel.org, AJvYcCW2x0rVVJvFQHvAhLU0EbDscZfdFCPBPFcQoHlq3zp94pdLwyp8tQ7RsBe7nUl4DV42IzpeWem9@vger.kernel.org, AJvYcCW4yGUSiJtK8l8ZBrhCs03i8YqPKeqBoa5ozceBgvEV0+0ZOHOOYfp0pq//lW3+3tf6T7x/nxTIvTKZ@vger.kernel.org, AJvYcCWO1I1Utbzi621O2fQpMvjIyUlq28VQMdVJtgqrSxJU05XYXYXfbe3zMcn4QlR7M02S1XLuVMma46hTeg==@vger.kernel.org, AJvYcCWPbD5wwExMgpb4qp7HXecHWMH0T95O
 asKsq/pAMtWfUdR7XUQdO2buLldp9307FCLPlRdYC0N/7t/r@vger.kernel.org, AJvYcCXAUsNjYPvPeK2OibZgEs2WwpoUOtKFxXqq6mfmn4d4+Q/CT+2fNM7+/pvCUpMy8DIjia939rLszKUhjw==@vger.kernel.org, AJvYcCXPWJXyiroHz9lWdO2PNVtFpg+X1wt6XZzphxfjrJDZ6hxqtawQr17XYcvPtrfUEzkQnoXa8eZd8Hkq0Q==@vger.kernel.org, AJvYcCXhhHZ6A24d1D6OWPNWCRRQQmSchp+spjLTbKnBr6/UuVmR8rTrHIzQQKHXXtSVDhSzf80=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyhn0ue1Dwx2e3VhQmyP+uOHrFegqU83ikyUkQ+lkHxWxIuNF4R
	3ce0I2OaovU9nBlJ2oibrM3zl++ZKC6GpqDM0RIuGPre4++Ix7c=
X-Gm-Gg: ASbGncvpnnU/aX06vLcU81GFHixJ1zw8rTdmurVxj4eXrdjCxEdMoNuhndOlFgOQ4g+
	oXxOd9j6ErWH5TFtVXnf02hJWCdPRrcy+gTcwL4QVKLUqSjllFNvlNamE+kfttvUTum7XMz9Pg5
	780um28/GA/FwPC0U87sgpy2ySHa01NruKeQSNCz3jb0LnaHQ5LMHrQS++ZlQ6yd1Dj79CGzr1u
	bkoAbqsZ+xi9A0mA/7/o2H7wDiczI3tlL0jbJJI1Y187ON9Ch4CFP+JWv2RTqylVk7kry6omv+l
	iXjbAQ9M0fn9cDDeisURntmWAqXW91ZwCBNxa/MlldIM
X-Google-Smtp-Source: AGHT+IF8/7u5sPPUnxUKs7/1U46BgrbqaNr+VNf0UHTBb569zkxnb+rV1+QWTbUu5Xora+LmVv4FIA==
X-Received: by 2002:a17:902:d54f:b0:224:1074:63a0 with SMTP id d9443c01a7336-2292f9e62bfmr264543585ad.34.1743522341280;
        Tue, 01 Apr 2025 08:45:41 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-2291eec6f91sm90062555ad.17.2025.04.01.08.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 08:45:40 -0700 (PDT)
Date: Tue, 1 Apr 2025 08:45:39 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Stefan Metzmacher <metze@samba.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Karsten Keil <isdn@linux-pingi.de>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Neal Cardwell <ncardwell@google.com>,
	Joerg Reuter <jreuter@yaina.de>,
	Marcel Holtmann <marcel@holtmann.org>,
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
	James Chapman <jchapman@katalix.com>,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Matt Johnston <matt@codeconstruct.com.au>,
	Matthieu Baerts <matttbe@kernel.org>,
	Mat Martineau <martineau@kernel.org>,
	Geliang Tang <geliang@kernel.org>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Remi Denis-Courmont <courmisch@gmail.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Jan Karcher <jaka@linux.ibm.com>,
	"D. Wythe" <alibuda@linux.alibaba.com>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>, Jon Maloy <jmaloy@redhat.com>,
	Boris Pismenny <borisp@nvidia.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Martin Schiller <ms@dev.tdt.de>,
	=?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
	linux-hams@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-can@vger.kernel.org, dccp@vger.kernel.org,
	linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
	mptcp@lists.linux.dev, linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
	tipc-discussion@lists.sourceforge.net,
	virtualization@lists.linux.dev, linux-x25@vger.kernel.org,
	bpf@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
	io-uring@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] net/io_uring: pass a kernel pointer via optlen_t
 to proto[_ops].getsockopt()
Message-ID: <Z-wKI1rQGSgrsjbl@mini-arch>
References: <cover.1743449872.git.metze@samba.org>
 <Z-sDc-0qyfPZz9lv@mini-arch>
 <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
 <407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
 <ed2038b1-0331-43d6-ac15-fd7e004ab27e@samba.org>
 <Z+wH1oYOr1dlKeyN@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z+wH1oYOr1dlKeyN@gmail.com>

On 04/01, Breno Leitao wrote:
> On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher wrote:
> > Am 01.04.25 um 15:37 schrieb Stefan Metzmacher:
> > > Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:
> > > > Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:
> > > > > On 03/31, Stefan Metzmacher wrote:
> > > > > > The motivation for this is to remove the SOL_SOCKET limitation
> > > > > > from io_uring_cmd_getsockopt().
> > > > > > 
> > > > > > The reason for this limitation is that io_uring_cmd_getsockopt()
> > > > > > passes a kernel pointer as optlen to do_sock_getsockopt()
> > > > > > and can't reach the ops->getsockopt() path.
> > > > > > 
> > > > > > The first idea would be to change the optval and optlen arguments
> > > > > > to the protocol specific hooks also to sockptr_t, as that
> > > > > > is already used for setsockopt() and also by do_sock_getsockopt()
> > > > > > sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> > > > > > 
> > > > > > But as Linus don't like 'sockptr_t' I used a different approach.
> > > > > > 
> > > > > > @Linus, would that optlen_t approach fit better for you?
> > > > > 
> > > > > [..]
> > > > > 
> > > > > > Instead of passing the optlen as user or kernel pointer,
> > > > > > we only ever pass a kernel pointer and do the
> > > > > > translation from/to userspace in do_sock_getsockopt().
> > > > > 
> > > > > At this point why not just fully embrace iov_iter? You have the size
> > > > > now + the user (or kernel) pointer. Might as well do
> > > > > s/sockptr_t/iov_iter/ conversion?
> > > > 
> > > > I think that would only be possible if we introduce
> > > > proto[_ops].getsockopt_iter() and then convert the implementations
> > > > step by step. Doing it all in one go has a lot of potential to break
> > > > the uapi. I could try to convert things like socket, ip and tcp myself, but
> > > > the rest needs to be converted by the maintainer of the specific protocol,
> > > > as it needs to be tested. As there are crazy things happening in the existing
> > > > implementations, e.g. some getsockopt() implementations use optval as in and out
> > > > buffer.
> > > > 
> > > > I first tried to convert both optval and optlen of getsockopt to sockptr_t,
> > > > and that showed that touching the optval part starts to get complex very soon,
> > > > see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
> > > > (note it didn't converted everything, I gave up after hitting
> > > > sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
> > > > sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
> > > > more are the ones also doing both copy_from_user and copy_to_user on optval)
> > > > 
> > > > I come also across one implementation that returned -ERANGE because *optlen was
> > > > too short and put the required length into *optlen, which means the returned
> > > > *optlen is larger than the optval buffer given from userspace.
> > > > 
> > > > Because of all these strange things I tried to do a minimal change
> > > > in order to get rid of the io_uring limitation and only converted
> > > > optlen and leave optval as is.
> > > > 
> > > > In order to have a patchset that has a low risk to cause regressions.
> > > > 
> > > > But as alternative introducing a prototype like this:
> > > > 
> > > >          int (*getsockopt_iter)(struct socket *sock, int level, int optname,
> > > >                                 struct iov_iter *optval_iter);
> > > > 
> > > > That returns a non-negative value which can be placed into *optlen
> > > > or negative value as error and *optlen will not be changed on error.
> > > > optval_iter will get direction ITER_DEST, so it can only be written to.
> > > > 
> > > > Implementations could then opt in for the new interface and
> > > > allow do_sock_getsockopt() work also for the io_uring case,
> > > > while all others would still get -EOPNOTSUPP.
> > > > 
> > > > So what should be the way to go?
> > > 
> > > Ok, I've added the infrastructure for getsockopt_iter, see below,
> > > but the first part I wanted to convert was
> > > tcp_ao_copy_mkts_to_user() and that also reads from userspace before
> > > writing.
> > > 
> > > So we could go with the optlen_t approach, or we need
> > > logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
> > > with ITER_DEST...
> > > 
> > > So who wants to decide?
> > 
> > I just noticed that it's even possible in same cases
> > to pass in a short buffer to optval, but have a longer value in optlen,
> > hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores optlen.
> > 
> > This makes it really hard to believe that trying to use iov_iter for this
> > is a good idea :-(
> 
> That was my finding as well a while ago, when I was planning to get the
> __user pointers converted to iov_iter. There are some weird ways of
> using optlen and optval, which makes them non-trivial to covert to
> iov_iter.

Can we ignore all non-ip/tcp/udp cases for now? This should cover +90%
of useful socket opts. See if there are any obvious problems with them
and if not, try converting. The rest we can cover separately when/if
needed.

