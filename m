Return-Path: <io-uring+bounces-7359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22401A7845C
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 00:04:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4A81A16D9D9
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 22:04:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A205211299;
	Tue,  1 Apr 2025 22:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XLAo6ytb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493F6F4ED;
	Tue,  1 Apr 2025 22:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743545074; cv=none; b=YfW4EcGlT/A6m0pq4esmGywGpRFCll5zIIntx/b/v1a6wHZVHP2gMsa5SmiEI/1kW2Z39IiIiATmQYbON6WAc/FLcSF8DwoY7SnOlThGnKSlXn49lotyHX2uywolkhx3yTc5KbYVSrBa6h8Kwf7x6jQGUD4OKoW7ywEzoamsMiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743545074; c=relaxed/simple;
	bh=agdeiF6flSZjHG7+QC27xoiUttx+psRcUZtUCJh6XU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DV7kQpnMgq4oFfnmrSBitE8itqfkYvHsFQGa5G7wujuYpqBQmkK80SurWmqm61ZxtjC0pVwdmxOEaSKfjA2SXzasuemQLKCeboDQi/EpMdWgIOl9wrXlQG1MFj/ypEYUILh0Rf7G8QR54/UvS7pi5dQeN+aF5lqfwutSNp72aW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XLAo6ytb; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-301a4d5156aso9715461a91.1;
        Tue, 01 Apr 2025 15:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743545071; x=1744149871; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Q0/k3VMEP498Bb2MPHwJKyiOd9QATuPY1pK0uH9FvIY=;
        b=XLAo6ytbRxT+uu9HHt443ajKIb3NqX+nFi6NPDsbCJ7C0fJ+6+4MI5PJv7c/+J3u47
         t/H9P5dsh+PZ6TWSagXeC5Il+/nN489/T00stcD0ZzX1LL1YtTJA3hujhOpSaAJw2BSw
         mxVFoLHTrNl1vEaIxvLV3lO75uh0uuN3ya3bzB0KXNg77d5Im6NryOf28cmX805XK/kY
         1vktkRUC6Q1CnvopAf3ScZVTsNHGB9bnLfGAySf8qKtljjsv9rUD0NNL7ST1g+4EEZhb
         DEE3uMRBbZ4/QSC/wlC85s/ojUdcvG3vBFNVecPmiwKsqD27hgF/U5roauHeyJV4PhLN
         HIsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743545071; x=1744149871;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0/k3VMEP498Bb2MPHwJKyiOd9QATuPY1pK0uH9FvIY=;
        b=UV8QUfHr7+S6dmbILLNLZf3JAkQV0cy8oXe1i8j54sh3fsT7AzIvFI9l0w//nurSDn
         wD32QrYZ7PCOxflMSPGFDICA6T+iZaq5mhcpIdglZkjw0YB8H8vJdbmxLC27jWVP0moG
         837GUQK+2MY+MQXKsgVurJA1qRB5FwXYlJ4myfkLnh1TB232eXTiA4mtYQIb+Ydkt60y
         Y8ROVADelSJuMqxQS2usVLLTus9P/tQJEaLye1kFdzd4ZGO4iVjpsymrTO0/vY6H2tfx
         Ba640Q2/XYeOSqGawDh8MDMGtfwrMkPi8obtrsCibYoqUNHqkpBzl4C52XuiezzpY8QG
         kPAA==
X-Forwarded-Encrypted: i=1; AJvYcCU49PZela/y5WWMugDePTq5Bqzr6mVP7fD6QV5Ii6fxGoGGSFwycCWTtcca1rGGDVt46cVClthBffeh@vger.kernel.org, AJvYcCUcViefDrk7rhsGdnejF6HK4+a511KTwO21Ubp8myyLWPMoxRfq7Ldt8NHDpT27YqKwBDYJo4JK5vmKCQ==@vger.kernel.org, AJvYcCVCJTYERnWFk057B8lysvjWxM7VlS9wBl3tEqusV/RQFLQDZezYLGJbRSONxpOTQWmF78tpXguyqRkScw==@vger.kernel.org, AJvYcCW3BjiTZDhB+owmbHKlMoGE7rAMV38kTznbLZW5mBOiFCJdZ0vlhlI7+yP7Uq5nlpfbucBBKg==@vger.kernel.org, AJvYcCW97qpzDO23BQSton5Bj3/qCUi5zOBQGhhMAOQxe/xEd7UtWo0Ji2U2MLZhECT/1ey19JaRmpnYyIrQcxCe@vger.kernel.org, AJvYcCWCaRmMDQZbwX2du90fhNQ/q/AZ66gJgEy+ZoQqClK8cO6qLAHEIuUNiq3cxOm4U9BrjGYfsKFeY60=@vger.kernel.org, AJvYcCWojcbPtWpqf2Dy6Zjt7wCI0bTVjiDIDL4LsvAIgodk44/gheY01LdSgjNcVQzELr6MfX2pr7XuZx2Z3A==@vger.kernel.org, AJvYcCWrFq8VJmfBWD5/1I6Gfu30eC4kTjw9XDMYaWQnvdpR6Ur8nCs7oyKnFKFvrdYnsp0dSqZNMx9k5u/wFw==@vger.kernel.org, AJvYcCWsF6XXpoNZJaqtzd5i6RMefB6C0BxIIUCLb528ajw6XV3NaxWkKuvv2IPjDdd9HB7ZIYDfoCtf5lALBg==@vger.kernel.org, AJvYcCX9RjM380E6LNEzVAyeh/6QwYt1
 CBeIBNXIbsxw7VrCInK7tBjgJGAfw8lndHcvqfzGHPqpkggm@vger.kernel.org, AJvYcCXfJoRLe5BljDlmOBAw0lLyi1JGvZpwVf42RYDPq4Lz2gSrYJ2/9HcuFpAJcrriRZWwv/GPtMSr3lw0Q/b1DFaz@vger.kernel.org, AJvYcCXpXINpyPmZy829L+1iH9ODl1qq7z6NAZKuEr7PdpA5985Ppigq65/MmI1Up/SBFcNEJic/+uXx9eUo@vger.kernel.org, AJvYcCXvu8Bh7W7wDEEpNQPCpdMh14fDFeGJL7v4gJA8epYh1+xsuYHDXjbOF4mWIy2Uk98fGLQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3Wq/jpMBOd0vL4b5o3g07CfLmepZlhWQ+SqVXJZ4A5+hlS1Bn
	f+xaWqbUWCD+jddGBptk6wY+5YE9/pNmh4ktgYrzeafnf1gznSA=
X-Gm-Gg: ASbGncvgeGkSOSF5UX67vBDm1S5nY2ZnA4MmneXoDKlNxc43Vw39It/B1DmhbsoBd03
	Zhc3g9GSnDlSrYRe5RK+Bsojlbe+gUSKb/lgdjzXmdvZEvDMhw12J0BweXF1o99L2THshQU6xAG
	8rzrUvtcbz1fq2Js0diEEpKYW24nGZmRfLsEY4xYl+QdqWmTeXMEqiEey2IQsTQplVJwVpTU1ID
	pYTyT9FmQp0/FZ/Sz+HuakmzGLBMRCzfU0cHhoYD9oK+rpt9R4czixdDB76fEAJhXxTVYiSdn9H
	nR3svadPXyg99/Fx8Q3zyjs6sJ79q7YcGUr71f781+zO
X-Google-Smtp-Source: AGHT+IGTZ5DyZovQGM9Bl2jMk1IKZO36cvV6hqVrBnVxHHo4OZw/HU7weWXdQUpCce417vldCTmIzA==
X-Received: by 2002:a17:90b:5448:b0:2fe:b735:87da with SMTP id 98e67ed59e1d1-3056eca7caamr582408a91.0.1743545071398;
        Tue, 01 Apr 2025 15:04:31 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-3056f5fb159sm84361a91.0.2025.04.01.15.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 15:04:30 -0700 (PDT)
Date: Tue, 1 Apr 2025 15:04:29 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Breno Leitao <leitao@debian.org>,
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
Message-ID: <Z-xi7TH83upf-E3q@mini-arch>
References: <cover.1743449872.git.metze@samba.org>
 <Z-sDc-0qyfPZz9lv@mini-arch>
 <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
 <407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
 <ed2038b1-0331-43d6-ac15-fd7e004ab27e@samba.org>
 <Z+wH1oYOr1dlKeyN@gmail.com>
 <Z-wKI1rQGSgrsjbl@mini-arch>
 <0f0f9cfd-77be-4988-8043-0d1bd0d157e7@samba.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0f0f9cfd-77be-4988-8043-0d1bd0d157e7@samba.org>

On 04/01, Stefan Metzmacher wrote:
> Am 01.04.25 um 17:45 schrieb Stanislav Fomichev:
> > On 04/01, Breno Leitao wrote:
> > > On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher wrote:
> > > > Am 01.04.25 um 15:37 schrieb Stefan Metzmacher:
> > > > > Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:
> > > > > > Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:
> > > > > > > On 03/31, Stefan Metzmacher wrote:
> > > > > > > > The motivation for this is to remove the SOL_SOCKET limitation
> > > > > > > > from io_uring_cmd_getsockopt().
> > > > > > > > 
> > > > > > > > The reason for this limitation is that io_uring_cmd_getsockopt()
> > > > > > > > passes a kernel pointer as optlen to do_sock_getsockopt()
> > > > > > > > and can't reach the ops->getsockopt() path.
> > > > > > > > 
> > > > > > > > The first idea would be to change the optval and optlen arguments
> > > > > > > > to the protocol specific hooks also to sockptr_t, as that
> > > > > > > > is already used for setsockopt() and also by do_sock_getsockopt()
> > > > > > > > sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> > > > > > > > 
> > > > > > > > But as Linus don't like 'sockptr_t' I used a different approach.
> > > > > > > > 
> > > > > > > > @Linus, would that optlen_t approach fit better for you?
> > > > > > > 
> > > > > > > [..]
> > > > > > > 
> > > > > > > > Instead of passing the optlen as user or kernel pointer,
> > > > > > > > we only ever pass a kernel pointer and do the
> > > > > > > > translation from/to userspace in do_sock_getsockopt().
> > > > > > > 
> > > > > > > At this point why not just fully embrace iov_iter? You have the size
> > > > > > > now + the user (or kernel) pointer. Might as well do
> > > > > > > s/sockptr_t/iov_iter/ conversion?
> > > > > > 
> > > > > > I think that would only be possible if we introduce
> > > > > > proto[_ops].getsockopt_iter() and then convert the implementations
> > > > > > step by step. Doing it all in one go has a lot of potential to break
> > > > > > the uapi. I could try to convert things like socket, ip and tcp myself, but
> > > > > > the rest needs to be converted by the maintainer of the specific protocol,
> > > > > > as it needs to be tested. As there are crazy things happening in the existing
> > > > > > implementations, e.g. some getsockopt() implementations use optval as in and out
> > > > > > buffer.
> > > > > > 
> > > > > > I first tried to convert both optval and optlen of getsockopt to sockptr_t,
> > > > > > and that showed that touching the optval part starts to get complex very soon,
> > > > > > see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
> > > > > > (note it didn't converted everything, I gave up after hitting
> > > > > > sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
> > > > > > sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
> > > > > > more are the ones also doing both copy_from_user and copy_to_user on optval)
> > > > > > 
> > > > > > I come also across one implementation that returned -ERANGE because *optlen was
> > > > > > too short and put the required length into *optlen, which means the returned
> > > > > > *optlen is larger than the optval buffer given from userspace.
> > > > > > 
> > > > > > Because of all these strange things I tried to do a minimal change
> > > > > > in order to get rid of the io_uring limitation and only converted
> > > > > > optlen and leave optval as is.
> > > > > > 
> > > > > > In order to have a patchset that has a low risk to cause regressions.
> > > > > > 
> > > > > > But as alternative introducing a prototype like this:
> > > > > > 
> > > > > >           int (*getsockopt_iter)(struct socket *sock, int level, int optname,
> > > > > >                                  struct iov_iter *optval_iter);
> > > > > > 
> > > > > > That returns a non-negative value which can be placed into *optlen
> > > > > > or negative value as error and *optlen will not be changed on error.
> > > > > > optval_iter will get direction ITER_DEST, so it can only be written to.
> > > > > > 
> > > > > > Implementations could then opt in for the new interface and
> > > > > > allow do_sock_getsockopt() work also for the io_uring case,
> > > > > > while all others would still get -EOPNOTSUPP.
> > > > > > 
> > > > > > So what should be the way to go?
> > > > > 
> > > > > Ok, I've added the infrastructure for getsockopt_iter, see below,
> > > > > but the first part I wanted to convert was
> > > > > tcp_ao_copy_mkts_to_user() and that also reads from userspace before
> > > > > writing.
> > > > > 
> > > > > So we could go with the optlen_t approach, or we need
> > > > > logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
> > > > > with ITER_DEST...
> > > > > 
> > > > > So who wants to decide?
> > > > 
> > > > I just noticed that it's even possible in same cases
> > > > to pass in a short buffer to optval, but have a longer value in optlen,
> > > > hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores optlen.
> > > > 
> > > > This makes it really hard to believe that trying to use iov_iter for this
> > > > is a good idea :-(
> > > 
> > > That was my finding as well a while ago, when I was planning to get the
> > > __user pointers converted to iov_iter. There are some weird ways of
> > > using optlen and optval, which makes them non-trivial to covert to
> > > iov_iter.
> > 
> > Can we ignore all non-ip/tcp/udp cases for now? This should cover +90%
> > of useful socket opts. See if there are any obvious problems with them
> > and if not, try converting. The rest we can cover separately when/if
> > needed.
> 
> That's what I tried, but it fails with
> tcp_getsockopt ->
>    do_tcp_getsockopt ->
>      tcp_ao_get_mkts ->
>         tcp_ao_copy_mkts_to_user ->
>            copy_struct_from_sockptr
>      tcp_ao_get_sock_info ->
>         copy_struct_from_sockptr
> 
> That's not possible with a ITER_DEST iov_iter.
> 
> metze

Can we create two iterators over the same memory? One for ITER_SOURCE and
another for ITER_DEST. And then make getsockopt_iter accept optval_in and
optval_out. We can also use optval_out position (iov_offset) as optlen output
value. Don't see why it won't work, but I agree that's gonna be a messy
conversion so let's see if someone else has better suggestions.

