Return-Path: <io-uring+bounces-7370-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DAFBDA79101
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 16:21:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38E4B17224B
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 14:20:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92A8B23BD1C;
	Wed,  2 Apr 2025 14:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fm1vme6X"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90958238D50;
	Wed,  2 Apr 2025 14:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603591; cv=none; b=mOalks5jY73Q4OG0By9OeJPfnwQGiwGCfkWHsufsN8tD3EQOTcxvPsw+whiX7vETcta+y4WP1MPBY0Ttjb6W52sQqzzmSAwHpaNGbgpkXTIEwKhEGdjmvKuzUhcTO6K0R7LLMXGQB3C9GqLFLjKMHr9hw2qIgVYs2OQejJqTd6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603591; c=relaxed/simple;
	bh=QmSKLMexLZuOsKJ3JTWnQfENhcug/imYBhQTapPo4Y0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aADtO7e5TPqrtt0m8lviIntjzlkm3T/QcCjaYWhJzoCIpAhWhMOkui6lV7Sh0GHXsKghTN6xzf/UOB/OxAy1AUSixweGqcKCLjP7P3Vz+PdASgVALUy4YWGyX5atCp2/11wq3+4qWQuHzoMDCRcgcTu9VmyuQcbASFsqH1uJ/6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fm1vme6X; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-225477548e1so119997465ad.0;
        Wed, 02 Apr 2025 07:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743603589; x=1744208389; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qsDyRyLthI5kIXY7kfZ4YoKcSQd5W0JI6ColIoFAbyw=;
        b=fm1vme6XEa50uMT6d5KqapKRGh+i40EPxJ9u523Ln+Jzt+iCRBpClBhi3nuQiqQuW5
         f/B4ekhYY1ciIdbXprW4ECJFlP/IjUgmeLbw2RHs7tC7pNPs5PCjd0N2GXbrcE7AwGzV
         5KQUfr7gocQCxh4RoWN82LVLCuWofH28uULVd3sk/MjUBaceKq0sjfOecz56SdtslFXb
         Vw/VUWPihASibpnCF2WvVSk5Mpqp4Qcj+0PH30lZrCmyGeVwjplyaV288EAYF5DmH4ch
         musv2GlhM51mA1eHYOS4gemm05gIy4kQlpUoweStOIbsIxFTFnPe/4BvvvsIojlR1pH7
         0E6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743603589; x=1744208389;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qsDyRyLthI5kIXY7kfZ4YoKcSQd5W0JI6ColIoFAbyw=;
        b=hzPRgU0yVrcR6lUZykBP2jKOIHte2CO3qX5baQlcpILrIw5KBVkp1zuHEaRVmoNPZE
         4bUp0a1tin09WhsIlTfep7sW45T50ezCTbmJXOcRmXtU4Qa49i9+LppGu+RO6UEmEnDM
         nBn42bpqm5ygO02UeWSymoJ76AGPmp9WBhTC91vUwKJpcBRBytrzaD0ZHhYvM/70migY
         MKrBDsyOZdXP3tex2nrC9vS6P0nY0XqY3lneo+KRD14f5J78DgJ2PFOcoi06czJTmw6r
         iBT6mcWIJyDuLfzYY4FDOtmWgjMScJMqPWO6/6Juhyf2pqIfiQ2gPxGe4ss/KzxwbRHY
         WTww==
X-Forwarded-Encrypted: i=1; AJvYcCUCYaHR/S9/AIGg3c97T9NcyFdOzT4rFlW/UThhYbGA76vn/R6bEHo1EAuzB6wKuU3MgoiiiIcUC5oviA==@vger.kernel.org, AJvYcCUW54EeQ1NjA5FPEPsNQ8SRRlac1cQnwYGEM2SuHwHEdLHD0fCvd43JiPxHepYH0nvk2pW2px77E6ZxmGfz@vger.kernel.org, AJvYcCVBo63n2T9sVQ9kVw96efk357mW/g6daZ3n9JZoXu0ibNqezvp/gc2Tzf/bnQIrrn50MFgl38cw7MN1aA==@vger.kernel.org, AJvYcCVhhOgC/jYJI+D4+/DgoZPLv68Uui6qa1aOrUbGK/7YhvGVI5mmUAMzA6ecHglyWMFUU+9/qEDM@vger.kernel.org, AJvYcCVkKZBtYducp0dRJRXaouT4ojP/RHkK6TuO/sVLu/ywcVUoobyA5b3UJXA2ge1YJfJhMAfQww==@vger.kernel.org, AJvYcCVrdfRxciursSST+0cZA9i1Mu/LAzCWgb+GdL0zxI5Cy4nCsPwSaLZul3tls+7RsdbuDmQ=@vger.kernel.org, AJvYcCWOgBCUtn+AbSKAtDd5x0wdXL34fdlojLto8THtafrYDZR1AMHY/S9K6j+HkPIh05rxMKvWMjSexp2OiQ==@vger.kernel.org, AJvYcCWjguqBdFApMT5lNYu5CniXxtcRnHtOt2f06KNu1S62aQDDsUdHe3ikdIDcC+dc5YcSN+npI3eo3LMO/w==@vger.kernel.org, AJvYcCWkBCYWUKVH2r/tR8FG8gUbi8d6viJQf3R/q/2SY9Jvg1V0YRBFjBw6wsQr15kQOtypoW7JIbwO+uHV@vger.kernel.org, AJvYcCWkQ/akFfow+/1K3goVcTCOI0apc3xN6p7qyWBXIKVx
 8N1+BDxQjy3a6ERnD1zvd5o4PFjIanKsWL8k@vger.kernel.org, AJvYcCX2ar/AUezsgSGZnwKowzMFDQmUflGvfuB18XfmHaXlXpdRb6INnvoAo6FWNuY5Hj1ackmXullK6MO2Ub8uMovg@vger.kernel.org, AJvYcCXEf05CibTIo7jQunkyGFxTxVDFmaVKImRxJxGRaIqdag0KtMpzboJgFGXV5JgTSXY7pPXYAOMUyLW54w==@vger.kernel.org, AJvYcCXs9GFZoAlQNjh+ksT3ZqRdqhozpPVUy227xVb+Zm4gtQlr4XhzHpI2+gpS0Ky2FGfFgj7TjMb+6oU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOj9Fx5TtKOuQXVhSvI3QH7YNfhLpptFCMokWrA4qcQtZA1qQq
	GfmasBDn7cNWKK2CLXGiiu2ODhC0bv0ZtLQg8eEWuaInTG93M0E=
X-Gm-Gg: ASbGncuN0zML8l54Wy+VgyPc1pWUcZz7NYqE5GuBcbWBbnd1fg4HxxLW6VzvV7KiZvi
	TLY5IzFPNs3T26Z7WHu8OLpyI6GtJS85qEhjXG+ef79RL0ykgEFf4z98crsvb2ELKna4IxIV4kU
	eszCn3i2EHcD0zpqqElFkUKemvCtS7Hk/AsnY1Lvq3wqIZbBbaOGxJDUD9kRje/woOlHPaNtdxS
	ZdF/wAgrzELY/FOTNWVE9IvST/P8tFUaJWcOLr3Pdx/jaRhzxziS/OJ6M2nrLcza8QiXAHcq10d
	QlkkBX65MddXv1sjI81CKzSwD00wqs6rMb0l9k0S25Iu1Z68VEE/HmU=
X-Google-Smtp-Source: AGHT+IG/kMHvWorUD9WkRvq58v/22Ct9eFPyBZLSK3FKft1U/aymg17BN6IaugHDl/+VvoD/r2ksjg==
X-Received: by 2002:a17:902:e74f:b0:224:3c9:19ae with SMTP id d9443c01a7336-2292f9de650mr297499695ad.34.1743603588484;
        Wed, 02 Apr 2025 07:19:48 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-73971073a9fsm11326286b3a.92.2025.04.02.07.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 07:19:47 -0700 (PDT)
Date: Wed, 2 Apr 2025 07:19:46 -0700
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
Message-ID: <Z-1Hgv4ImjWOW8X2@mini-arch>
References: <Z-sDc-0qyfPZz9lv@mini-arch>
 <39515c76-310d-41af-a8b4-a814841449e3@samba.org>
 <407c1a05-24a7-430b-958c-0ca78c467c07@samba.org>
 <ed2038b1-0331-43d6-ac15-fd7e004ab27e@samba.org>
 <Z+wH1oYOr1dlKeyN@gmail.com>
 <Z-wKI1rQGSgrsjbl@mini-arch>
 <0f0f9cfd-77be-4988-8043-0d1bd0d157e7@samba.org>
 <Z-xi7TH83upf-E3q@mini-arch>
 <4b7ac4e9-6856-4e54-a2ba-15465e9622ac@samba.org>
 <20250402132906.0ceb8985@pumpkin>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250402132906.0ceb8985@pumpkin>

On 04/02, David Laight wrote:
> On Wed, 2 Apr 2025 00:53:58 +0200
> Stefan Metzmacher <metze@samba.org> wrote:
> 
> > Am 02.04.25 um 00:04 schrieb Stanislav Fomichev:
> > > On 04/01, Stefan Metzmacher wrote:  
> > >> Am 01.04.25 um 17:45 schrieb Stanislav Fomichev:  
> > >>> On 04/01, Breno Leitao wrote:  
> > >>>> On Tue, Apr 01, 2025 at 03:48:58PM +0200, Stefan Metzmacher wrote:  
> > >>>>> Am 01.04.25 um 15:37 schrieb Stefan Metzmacher:  
> > >>>>>> Am 01.04.25 um 10:19 schrieb Stefan Metzmacher:  
> > >>>>>>> Am 31.03.25 um 23:04 schrieb Stanislav Fomichev:  
> > >>>>>>>> On 03/31, Stefan Metzmacher wrote:  
> > >>>>>>>>> The motivation for this is to remove the SOL_SOCKET limitation
> > >>>>>>>>> from io_uring_cmd_getsockopt().
> > >>>>>>>>>
> > >>>>>>>>> The reason for this limitation is that io_uring_cmd_getsockopt()
> > >>>>>>>>> passes a kernel pointer as optlen to do_sock_getsockopt()
> > >>>>>>>>> and can't reach the ops->getsockopt() path.
> > >>>>>>>>>
> > >>>>>>>>> The first idea would be to change the optval and optlen arguments
> > >>>>>>>>> to the protocol specific hooks also to sockptr_t, as that
> > >>>>>>>>> is already used for setsockopt() and also by do_sock_getsockopt()
> > >>>>>>>>> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> > >>>>>>>>>
> > >>>>>>>>> But as Linus don't like 'sockptr_t' I used a different approach.
> > >>>>>>>>>
> > >>>>>>>>> @Linus, would that optlen_t approach fit better for you?  
> > >>>>>>>>
> > >>>>>>>> [..]
> > >>>>>>>>  
> > >>>>>>>>> Instead of passing the optlen as user or kernel pointer,
> > >>>>>>>>> we only ever pass a kernel pointer and do the
> > >>>>>>>>> translation from/to userspace in do_sock_getsockopt().  
> > >>>>>>>>
> > >>>>>>>> At this point why not just fully embrace iov_iter? You have the size
> > >>>>>>>> now + the user (or kernel) pointer. Might as well do
> > >>>>>>>> s/sockptr_t/iov_iter/ conversion?  
> > >>>>>>>
> > >>>>>>> I think that would only be possible if we introduce
> > >>>>>>> proto[_ops].getsockopt_iter() and then convert the implementations
> > >>>>>>> step by step. Doing it all in one go has a lot of potential to break
> > >>>>>>> the uapi. I could try to convert things like socket, ip and tcp myself, but
> > >>>>>>> the rest needs to be converted by the maintainer of the specific protocol,
> > >>>>>>> as it needs to be tested. As there are crazy things happening in the existing
> > >>>>>>> implementations, e.g. some getsockopt() implementations use optval as in and out
> > >>>>>>> buffer.
> > >>>>>>>
> > >>>>>>> I first tried to convert both optval and optlen of getsockopt to sockptr_t,
> > >>>>>>> and that showed that touching the optval part starts to get complex very soon,
> > >>>>>>> see https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=141912166473bf8843ec6ace76dc9c6945adafd1
> > >>>>>>> (note it didn't converted everything, I gave up after hitting
> > >>>>>>> sctp_getsockopt_peer_addrs and sctp_getsockopt_local_addrs.
> > >>>>>>> sctp_getsockopt_context, sctp_getsockopt_maxseg, sctp_getsockopt_associnfo and maybe
> > >>>>>>> more are the ones also doing both copy_from_user and copy_to_user on optval)
> > >>>>>>>
> > >>>>>>> I come also across one implementation that returned -ERANGE because *optlen was
> > >>>>>>> too short and put the required length into *optlen, which means the returned
> > >>>>>>> *optlen is larger than the optval buffer given from userspace.
> > >>>>>>>
> > >>>>>>> Because of all these strange things I tried to do a minimal change
> > >>>>>>> in order to get rid of the io_uring limitation and only converted
> > >>>>>>> optlen and leave optval as is.
> > >>>>>>>
> > >>>>>>> In order to have a patchset that has a low risk to cause regressions.
> > >>>>>>>
> > >>>>>>> But as alternative introducing a prototype like this:
> > >>>>>>>
> > >>>>>>>            int (*getsockopt_iter)(struct socket *sock, int level, int optname,
> > >>>>>>>                                   struct iov_iter *optval_iter);
> > >>>>>>>
> > >>>>>>> That returns a non-negative value which can be placed into *optlen
> > >>>>>>> or negative value as error and *optlen will not be changed on error.
> > >>>>>>> optval_iter will get direction ITER_DEST, so it can only be written to.
> > >>>>>>>
> > >>>>>>> Implementations could then opt in for the new interface and
> > >>>>>>> allow do_sock_getsockopt() work also for the io_uring case,
> > >>>>>>> while all others would still get -EOPNOTSUPP.
> > >>>>>>>
> > >>>>>>> So what should be the way to go?  
> > >>>>>>
> > >>>>>> Ok, I've added the infrastructure for getsockopt_iter, see below,
> > >>>>>> but the first part I wanted to convert was
> > >>>>>> tcp_ao_copy_mkts_to_user() and that also reads from userspace before
> > >>>>>> writing.
> > >>>>>>
> > >>>>>> So we could go with the optlen_t approach, or we need
> > >>>>>> logic for ITER_BOTH or pass two iov_iters one with ITER_SRC and one
> > >>>>>> with ITER_DEST...
> > >>>>>>
> > >>>>>> So who wants to decide?  
> > >>>>>
> > >>>>> I just noticed that it's even possible in same cases
> > >>>>> to pass in a short buffer to optval, but have a longer value in optlen,
> > >>>>> hci_sock_getsockopt() with SOL_BLUETOOTH completely ignores optlen.
> > >>>>>
> > >>>>> This makes it really hard to believe that trying to use iov_iter for this
> > >>>>> is a good idea :-(  
> > >>>>
> > >>>> That was my finding as well a while ago, when I was planning to get the
> > >>>> __user pointers converted to iov_iter. There are some weird ways of
> > >>>> using optlen and optval, which makes them non-trivial to covert to
> > >>>> iov_iter.  
> > >>>
> > >>> Can we ignore all non-ip/tcp/udp cases for now? This should cover +90%
> > >>> of useful socket opts. See if there are any obvious problems with them
> > >>> and if not, try converting. The rest we can cover separately when/if
> > >>> needed.  
> > >>
> > >> That's what I tried, but it fails with
> > >> tcp_getsockopt ->
> > >>     do_tcp_getsockopt ->
> > >>       tcp_ao_get_mkts ->
> > >>          tcp_ao_copy_mkts_to_user ->
> > >>             copy_struct_from_sockptr
> > >>       tcp_ao_get_sock_info ->
> > >>          copy_struct_from_sockptr
> > >>
> > >> That's not possible with a ITER_DEST iov_iter.
> > >>
> > >> metze  
> > > 
> > > Can we create two iterators over the same memory? One for ITER_SOURCE and
> > > another for ITER_DEST. And then make getsockopt_iter accept optval_in and
> > > optval_out. We can also use optval_out position (iov_offset) as optlen output
> > > value. Don't see why it won't work, but I agree that's gonna be a messy
> > > conversion so let's see if someone else has better suggestions.  
> > 
> > Yes, that might work, but it would be good to get some feedback
> > if this would be the way to go:
> > 
> >            int (*getsockopt_iter)(struct socket *sock,
> > 				 int level, int optname,
> > 				 struct iov_iter *optval_in,
> > 				 struct iov_iter *optval_out);
> > 
> > And *optlen = optval_out->iov_offset;
> > 
> > Any objection or better ideas? Linus would that be what you had in mind?
> 
> I'd worry about performance - yes I know 'iter' are used elsewhere but...
> Also look at the SCTP code.

Performance usually does not matter for set/getsockopts, there
are a few exceptions that I know (TCP_ZEROCOPY_RECEIVE) and maybe recent
devmem sockopts; we can special-case these if needed, or keep sockptr_t,
idk. I'm skeptical we can convert everything though, that's why the
suggestion to start with sk/ip/tcp/udp.

> How do you handle code that wants to return an updated length (often longer
> than the one provided) and an error code (eg ERRSIZE or similar).
>
> There is also a very strange use (I think it is a sockopt rather than an ioctl)
> where the buffer length the application provides is only that of the header.
> The actual buffer length is contained in the header.
> The return length is the amount written into the full buffer.

Let's discuss these special cases as they come up? Worst case these
places can always re-init iov_iter with a comment on why it is ok.
But I do agree in general that there are a few places that do wild
stuff.

