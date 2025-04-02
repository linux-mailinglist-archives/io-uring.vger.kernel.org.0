Return-Path: <io-uring+bounces-7373-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 580DBA7977D
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 23:21:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 621273B32E9
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 21:21:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38B011F4167;
	Wed,  2 Apr 2025 21:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/qNj1uj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06FB19D897;
	Wed,  2 Apr 2025 21:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743628901; cv=none; b=UevhxSPPT8yAzB8n2iDJBfIrA0N6CqMOfHL4rKsnfiORKzgvYBqtOYNqpXrNvMc2EnmUbU6wTkeUXfVK7Rd032ITJqSdOkHRbGywcA5I/do63H7bBMw6SabUc2b7yKnVwGKUwacc80K1RH3zb1zAm36fXkTylrsJLMkFv1dJCoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743628901; c=relaxed/simple;
	bh=OCZY50PScFiiRcEIz0TCfkAwI2pYmIk3fblOb3XY4DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C71NKJqyGSNkjsWT3XdvCjiJtjls5uV8aIyqisbETV5r8lFlH3oXEuZYY015UNAwAXi97JsSh+plw/trBHqXZii8hriCudRmgxhPt6qmY9vEM4WxVQ4bmhYV74ZN+lld8LdaoXLbTV3zYCt5sJI3i0r/CIb4IBWoDmhDhuuinwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/qNj1uj; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2260c91576aso2277905ad.3;
        Wed, 02 Apr 2025 14:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743628897; x=1744233697; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IrMLbogI0pA5EiUoKFkfUfqZVsjIVpB9siCn/c6p38s=;
        b=C/qNj1ujRQoXwPpYI5G4odgmdjnCbSKxphohpwCOeKkcojD33ny2CTUH8ds2xkpslP
         6IshYto2bgeE2XhjX4oz97jY6awOv585L+sU41+aaXGobYTaA5O9zY2gdteW7v8uvyHa
         G+lcvx2iTHnoK5So6GvfOrrrEIqdbtLVwKLbnZELtQu005grlFUJCxqNMrkqwH69YT6W
         m92zNkWTPKZTTOCE3kikaxG2SzysuVKWNlEBlHfA+8AaNMNR8OQYN8NaJGPSOEfCTMwY
         smbLka870uSRuBqp2+Hy/dSDlrocHzS6vOMt7evZrYp9Mf5ysRokGhd+LTYtac7vL89A
         fmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743628897; x=1744233697;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IrMLbogI0pA5EiUoKFkfUfqZVsjIVpB9siCn/c6p38s=;
        b=H7HpbTZB8drTGHyvF8fBT/jQyyD1+3z69c/uaJyTVv/bm0AKv4OGzKX8SIQ9DEdM2G
         BFhRO6qp0D3J0DFgR8V1hinZmZ2+6K1dg5Mqdch/769I+C04+iQ3Iy/hlUSbeaGFIp5W
         bJIR0QEjwcHS8EULemHFr/GsjMrA118akE/8URyASRRlsU2xy0++m3TxKMboIBHGvfMT
         MHUjJfrtbfzau9HbVRsmF65pFBfbQ4bR554Eus4cwZJzLqpNmVx0mInmfSeVWpYPshLR
         tKmVNQnh6qIh2APpQWlEoEN42Vn1tepO+NsZ8Rmj26OFBVavFP+67KFDY1On6yIrVfIl
         dLEw==
X-Forwarded-Encrypted: i=1; AJvYcCU+Jyqq7bzl60FjlyueJxqiO9acAjDEyRlN8VuVcLFz1t3wzVD07mtS4V36gpm5O0kLiXNS278Jj/GRKA==@vger.kernel.org, AJvYcCUccjSrde6HvZPRzNVh0mqtT/aLbHx13FRneE/zv2Y4B0+N+SjNeOH5yHc/N1MxbKFYfYgZ4/uTIhBfzw==@vger.kernel.org, AJvYcCUuBJIYlNnnbrpbxcUxGnwmcIK2+SKX5IdjxUJXUR0osTrYRl/ubChqhNCl3vN0JATxuEcvc5Lm@vger.kernel.org, AJvYcCUxb8PQKcNXXFvt9Yv1VqLpZX3OgmQ4xdlzdDORJkdjYwJFsBurfUWu3HC4ExYdL2NcIQGjYHJQB/E=@vger.kernel.org, AJvYcCVTR0U+ZgxOjP1KNLVpVLhtydf44+GSan6SScO48KCsyK65gssLgMg1viLrZXsA/haqpUxexf6AVHbWfw==@vger.kernel.org, AJvYcCW/CNvWx/9IGjRieN7cqEgRuUME4p+VI1aD41nKnfunpIuyiyeirLOvOatfpDpPly8iFVw=@vger.kernel.org, AJvYcCWw9bSEYQyxFUMclE2GKKGf/qFnAISiy1wSBzA7gbWCZOmak7fE4djRSfDxu9JrTz55Y2+qIV1ik8gr+dVh@vger.kernel.org, AJvYcCX4pDKRsbAEECHwRgLSjW03oaCJEwq/40+Sjk2SmDABgakw8d40As4Zk4HNmAQBPSMeTbAX+1kMrE62@vger.kernel.org, AJvYcCX8qeC8mE8VVF8KB2NL5NsuTL6Y/DHprKx3PbAZwFs33dWPVpVoqncCTwLDFkkPocbhf3Gp6veofpUvyw==@vger.kernel.org, AJvYcCXAYv1C7XSOKvlpCr+f4FubHdhnv1Q1ok5UTFwJ
 U1IHrjJRNSaI0lP1funZxBu+fp0noaniQw==@vger.kernel.org, AJvYcCXLGLBwTytGIz7zZGxZkHJS38CfORhbZFKpLFBsUTBuU8Ve96v/cj32LRbFu7Z91KBv+jCYLTqPB6QHp87wNUso@vger.kernel.org, AJvYcCXdpoow5W3VCSrE/yliv9s+CESaLdz57sZ6f3ixOd1Rtsc8w4bxTdITWyDadV6dk5vG53cgIKse6kq2@vger.kernel.org, AJvYcCXfSjPYrJ6oLorPFHWV/rvBz6jC3XOzKnv3+ehfhDSksaWaxrMPNEvO1dV6kwAnUCJzDUQWfZFD2JKiFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxvhP3m3C5IEUIz1Qh6PMJ/+eGPJv21Qx6qHQpS/quJyhnANy9+
	vymHgO1KpUj4+EEtvBQ49jlXZEMvIRtn9oEd+b2MwXSLdgEQaXw=
X-Gm-Gg: ASbGncu/oy2MXecerhnzLA0UozDkqlQdnTvMiPOFxL0aL5eccLXUnhTSesHr19WoiQH
	WxjVSvPLvFXrpd/m2ussBLx74i0KvW55oqnelh0xZripoMYR/gUDF+/HWDY8z0LuS11+AZCItzG
	lqENoL4ucDAs8RKq58ftluIQpGUIu6MyYCXPKOi/Na1XL/YiIqhDo8hJwzglGOc22+SKKEY6Bi1
	/M6so6CiyrykfwCC9YUB9i5fsuVhd6fJMYZLcmI10vOAdD+Vg9OhklbkrM2Zwyb4drtim7nNxnB
	L29JIgxVD6cU4IZgyqlow+mEKpcidJ0MBo0oyYUn7lfy
X-Google-Smtp-Source: AGHT+IEwr8UeobizrDFNiy1RCGrbw4rnamtoMzo4LLKXEmciC2aMPH75HcTCUyPyfCrHsXdJyb5ueA==
X-Received: by 2002:a17:903:11ce:b0:224:1157:6d26 with SMTP id d9443c01a7336-22977d7df4bmr4295725ad.4.1743628896623;
        Wed, 02 Apr 2025 14:21:36 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-229785aea7fsm291575ad.2.2025.04.02.14.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 14:21:36 -0700 (PDT)
Date: Wed, 2 Apr 2025 14:21:35 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, Breno Leitao <leitao@debian.org>,
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
Message-ID: <Z-2qX_N2-jpMYSIy@mini-arch>
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
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250402214638.0b5eed55@pumpkin>

On 04/02, David Laight wrote:
> On Wed, 2 Apr 2025 07:19:46 -0700
> Stanislav Fomichev <stfomichev@gmail.com> wrote:
> 
> > On 04/02, David Laight wrote:
> > > On Wed, 2 Apr 2025 00:53:58 +0200
> > > Stefan Metzmacher <metze@samba.org> wrote:
> > >   
> > > > Am 02.04.25 um 00:04 schrieb Stanislav Fomichev:  
> > > > > On 04/01, Stefan Metzmacher wrote:    
> > > > >> Am 01.04.25 um 17:45 schrieb Stanislav Fomichev:    
> > > > >>> On 04/01, Breno Leitao wrote:    
> > > > >>>> On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher wrote:    
> > > > >>>>> Am 01.04.25 um 15:37 schrieb Stefan Metzmacher:    
> > > > >>>>>> Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:    
> > > > >>>>>>> Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:    
> > > > >>>>>>>> On 03/31, Stefan Metzmacher wrote:    
> > > > >>>>>>>>> The motivation for this is to remove the SOL_SOCKET limitation
> > > > >>>>>>>>> from io_uring_cmd_getsockopt().
> > > > >>>>>>>>>
> > > > >>>>>>>>> The reason for this limitation is that io_uring_cmd_getsockopt()
> > > > >>>>>>>>> passes a kernel pointer as optlen to do_sock_getsockopt()
> > > > >>>>>>>>> and can't reach the ops->getsockopt() path.
> > > > >>>>>>>>>
> > > > >>>>>>>>> The first idea would be to change the optval and optlen arguments
> > > > >>>>>>>>> to the protocol specific hooks also to sockptr_t, as that
> > > > >>>>>>>>> is already used for setsockopt() and also by do_sock_getsockopt()
> > > > >>>>>>>>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> > > > >>>>>>>>>
> > > > >>>>>>>>> But as Linus don't like 'sockptr_t' I used a different approach.
> > > > >>>>>>>>>
> > > > >>>>>>>>> @Linus, would that optlen_t approach fit better for you?    
> > > > >>>>>>>>
> > > > >>>>>>>> [..]
> > > > >>>>>>>>    
> > > > >>>>>>>>> Instead of passing the optlen as user or kernel pointer,
> > > > >>>>>>>>> we only ever pass a kernel pointer and do the
> > > > >>>>>>>>> translation from/to userspace in do_sock_getsockopt().    
> > > > >>>>>>>>
> > > > >>>>>>>> At this point why not just fully embrace iov_iter? You have the size
> > > > >>>>>>>> now + the user (or kernel) pointer. Might as well do
> > > > >>>>>>>> s/sockptr_t/iov_iter/ conversion?    
> > > > >>>>>>>
> > > > >>>>>>> I think that would only be possible if we introduce
> > > > >>>>>>> proto[_ops].getsockopt_iter() and then convert the implementations
> > > > >>>>>>> step by step. Doing it all in one go has a lot of potential to break
> > > > >>>>>>> the uapi. I could try to convert things like socket, ip and tcp myself, but
> > > > >>>>>>> the rest needs to be converted by the maintainer of the specific protocol,
> > > > >>>>>>> as it needs to be tested. As there are crazy things happening in the existing
> > > > >>>>>>> implementations, e.g. some getsockopt() implementations use optval as in and out
> > > > >>>>>>> buffer.
> > > > >>>>>>>
> > > > >>>>>>> I first tried to convert both optval and optlen of getsockopt to sockptr_t,
> > > > >>>>>>> and that showed that touching the optval part starts to get complex very soon,
> > > > >>>>>>> see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
> > > > >>>>>>> (note it didn't converted everything, I gave up after hitting
> > > > >>>>>>> sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
> > > > >>>>>>> sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
> > > > >>>>>>> more are the ones also doing both copy_from_user and copy_to_user on optval)
> > > > >>>>>>>
> > > > >>>>>>> I come also across one implementation that returned -ERANGE because *optlen was
> > > > >>>>>>> too short and put the required length into *optlen, which means the returned
> > > > >>>>>>> *optlen is larger than the optval buffer given from userspace.
> > > > >>>>>>>
> > > > >>>>>>> Because of all these strange things I tried to do a minimal change
> > > > >>>>>>> in order to get rid of the io_uring limitation and only converted
> > > > >>>>>>> optlen and leave optval as is.
> > > > >>>>>>>
> > > > >>>>>>> In order to have a patchset that has a low risk to cause regressions.
> > > > >>>>>>>
> > > > >>>>>>> But as alternative introducing a prototype like this:
> > > > >>>>>>>
> > > > >>>>>>>            int (*getsockopt_iter)(struct socket *sock, int level, int optname,
> > > > >>>>>>>                                   struct iov_iter *optval_iter);
> > > > >>>>>>>
> > > > >>>>>>> That returns a non-negative value which can be placed into *optlen
> > > > >>>>>>> or negative value as error and *optlen will not be changed on error.
> > > > >>>>>>> optval_iter will get direction ITER_DEST, so it can only be written to.
> > > > >>>>>>>
> > > > >>>>>>> Implementations could then opt in for the new interface and
> > > > >>>>>>> allow do_sock_getsockopt() work also for the io_uring case,
> > > > >>>>>>> while all others would still get -EOPNOTSUPP.
> > > > >>>>>>>
> > > > >>>>>>> So what should be the way to go?    
> > > > >>>>>>
> > > > >>>>>> Ok, I've added the infrastructure for getsockopt_iter, see below,
> > > > >>>>>> but the first part I wanted to convert was
> > > > >>>>>> tcp_ao_copy_mkts_to_user() and that also reads from userspace before
> > > > >>>>>> writing.
> > > > >>>>>>
> > > > >>>>>> So we could go with the optlen_t approach, or we need
> > > > >>>>>> logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
> > > > >>>>>> with ITER_DEST...
> > > > >>>>>>
> > > > >>>>>> So who wants to decide?    
> > > > >>>>>
> > > > >>>>> I just noticed that it's even possible in same cases
> > > > >>>>> to pass in a short buffer to optval, but have a longer value in optlen,
> > > > >>>>> hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores optlen.
> > > > >>>>>
> > > > >>>>> This makes it really hard to believe that trying to use iov_iter for this
> > > > >>>>> is a good idea :-(    
> > > > >>>>
> > > > >>>> That was my finding as well a while ago, when I was planning to get the
> > > > >>>> __user pointers converted to iov_iter. There are some weird ways of
> > > > >>>> using optlen and optval, which makes them non-trivial to covert to
> > > > >>>> iov_iter.    
> > > > >>>
> > > > >>> Can we ignore all non-ip/tcp/udp cases for now? This should cover +90%
> > > > >>> of useful socket opts. See if there are any obvious problems with them
> > > > >>> and if not, try converting. The rest we can cover separately when/if
> > > > >>> needed.    
> > > > >>
> > > > >> That's what I tried, but it fails with
> > > > >> tcp_getsockopt ->
> > > > >>     do_tcp_getsockopt ->
> > > > >>       tcp_ao_get_mkts ->
> > > > >>          tcp_ao_copy_mkts_to_user ->
> > > > >>             copy_struct_from_sockptr
> > > > >>       tcp_ao_get_sock_info ->
> > > > >>          copy_struct_from_sockptr
> > > > >>
> > > > >> That's not possible with a ITER_DEST iov_iter.
> > > > >>
> > > > >> metze    
> > > > > 
> > > > > Can we create two iterators over the same memory? One for ITER_SOURCE and
> > > > > another for ITER_DEST. And then make getsockopt_iter accept optval_in and
> > > > > optval_out. We can also use optval_out position (iov_offset) as optlen output
> > > > > value. Don't see why it won't work, but I agree that's gonna be a messy
> > > > > conversion so let's see if someone else has better suggestions.    
> > > > 
> > > > Yes, that might work, but it would be good to get some feedback
> > > > if this would be the way to go:
> > > > 
> > > >            int (*getsockopt_iter)(struct socket *sock,
> > > > 				 int level, int optname,
> > > > 				 struct iov_iter *optval_in,
> > > > 				 struct iov_iter *optval_out);
> > > > 
> > > > And *optlen = optval_out->iov_offset;
> > > > 
> > > > Any objection or better ideas? Linus would that be what you had in mind?  
> > > 
> > > I'd worry about performance - yes I know 'iter' are used elsewhere but...
> > > Also look at the SCTP code.  
> > 
> > Performance usually does not matter for set/getsockopts, there
> > are a few exceptions that I know (TCP_ZEROCOPY_RECEIVE)
> 
> That might be the one that is really horrid and completely abuses
> the 'length' parameter.

It is reading and writing, yes, but it's not a huge problem. And it
does enforce the optlen (to copy back the same amount of bytes). It's
not that bad, it's just an example of where we need to be extra
careful.

> > and maybe recent
> > devmem sockopts; we can special-case these if needed, or keep sockptr_t,
> > idk. I'm skeptical we can convert everything though, that's why the
> > suggestion to start with sk/ip/tcp/udp.
> > 
> > > How do you handle code that wants to return an updated length (often longer
> > > than the one provided) and an error code (eg ERRSIZE or similar).
> > >
> > > There is also a very strange use (I think it is a sockopt rather than an ioctl)
> > > where the buffer length the application provides is only that of the header.
> > > The actual buffer length is contained in the header.
> > > The return length is the amount written into the full buffer.  
> > 
> > Let's discuss these special cases as they come up? Worst case these
> > places can always re-init iov_iter with a comment on why it is ok.
> > But I do agree in general that there are a few places that do wild
> > stuff.
> 
> The problem is that the generic code has to deal with all the 'wild stuff'.

getsockopt_iter will have optval_in for the minority of socket options
(like TCP_ZEROCOPY_RECEIVE) that want to read user's value as well
as optval_out. The latter is what the majority of socket options
will use to write their value. That doesn't seem too complicated to
handle?

> It is also common to do non-sequential accesses - so iov_iter doesn't match
> at all.

I disagree that it's 'common'. Searching for copy_from_sockptr_offset
returns a few cases and they are mostly using read-with-offset because
there is no sequential read (iterator) semantics with sockptr_t.

> There also isn't a requirement for scatter-gather.
> 
> For 'normal' getsockopt (and setsockopt) with short lengths it actually makes
> sense for the syscall wrapper to do the user copies.
> But it would need to pass the user ptr+len as well as the kernel ptr+len
> to give the required flexibilty.
> Then you have to work out whether the final copy to user is needed or not.
> (not that hard, but it all adds complication).

Not sure I understand what's the problem. The user vs kernel part will
be abstracted by iov_iter. The callers will have to write the optlen
back. And there are two call sites we care about: io_uring and regular
system call. What's your suggestion? Maybe I'm missing something. Do you
prefer get_optlen/put_optlen?

