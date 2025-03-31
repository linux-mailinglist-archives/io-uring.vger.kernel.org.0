Return-Path: <io-uring+bounces-7332-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B2AA76FE5
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 23:06:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DC033AA6CB
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A5F821C170;
	Mon, 31 Mar 2025 21:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eUvvJktx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1B761D63DD;
	Mon, 31 Mar 2025 21:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743455095; cv=none; b=FqqqgqELlSNr7cys+HgH4+esX0qFcrxRQuplk/IIfpFFYulU3ZUtbjD2L++nk5b/CDgZbm9fQIDZi94fzDjQPCzs5dvTSV8QLtjCsePaTBMdqfm4VVaSApuVqMj5TgotSJscQqCY9+nqxwvuDAKdmwkW4+9taFr45bQhovWqam4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743455095; c=relaxed/simple;
	bh=U+1yEEOZzVsnuUOy+RsFKoOt/F2YbfNHQ5QjEgiuuAI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t3CAKiAFtgMoY3GonZUqi+4KfYCFXkKJidi51oIFzOlyoDeN9hVTYF7JAzHpsCUvtxesmEu2+1ewmXSgYAlVMithJjbB/IcZAh7ImNiFKHbRNzOBTcfx8sEz7LMdbt5+qyYsLlkkzJB/dTNmqvwA/Qgyc8cwKSh6tJj9dYulZeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eUvvJktx; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-22580c9ee0aso97925585ad.2;
        Mon, 31 Mar 2025 14:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743455093; x=1744059893; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYhYk9y2DXMVeKQttY/EQvcE7aZgDZ1TAkVyVBo9hSY=;
        b=eUvvJktxaCAAI6XUQIGaNozpKoDBqD5n50gV1B1gWbam94qyq3rR5UlEPlV+cPaba8
         QnnVkEcZlvZUbP/CYH6DQGJ98I//1dHtRwwslKg+X6xLiNu8W+065gax+KC9thAw5qhn
         I2YEj1KQ7U2Ax6iJyZj5XYYnQcFHku46LcVNh6SfLf4vc0ukhP5Jw/hY40d4qeFYSY4p
         jVwWARJHOaP/XtG6v1A2ZnixfVjOIt0MGiajmN+/I2KYM2kTS0FHrfWaTdkW2uvxwv8p
         W7AQyuD5OYUUZ/tDNfWB0RDZfDE5QtPJ/yMlXbY86+8EoQMwj7bJkm//zNJiFevyTORg
         EPEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743455093; x=1744059893;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYhYk9y2DXMVeKQttY/EQvcE7aZgDZ1TAkVyVBo9hSY=;
        b=N4TPDuMg7WsZdw2d7Nq3iXmYEaSjLiC3MDV77YvFJ7lFoGVpH0h22yCgnnmJKF+3Y+
         sJ/oeVmAwn+3SRAz/TqEMFrSP3CiThuYfi02pTVq7brwZ8ivJ+TP8+CM+28wtSARGCgz
         mdXPkFIBSmHSECY+CdghAaLteBjoffAf9KHB/HcK0ViZNnEmul+RPct5O8iDrryTfG+w
         XJWJ8FxDYU6O74M5fh7WAEKCyNmhGjFanROKoowBRLjFnB7g1ZEeZavrDH4Y+2S+nooj
         ArYSOjrR8I17VaVQDrfG92HAFtoW7/zmmzShnQGE/JWjpEzWN2ZsyIMuaiNxUqwd1mE2
         VqWA==
X-Forwarded-Encrypted: i=1; AJvYcCUBg7GT/yQxgmoS4l3vOA3gK97se8WqIlpUSKGg2WeLmGVCBGQzPgGdkLHfHehfrmsv+SZchg==@vger.kernel.org, AJvYcCUQJPz5g562Sy3ask/L5OSXtlliiwK6VWlLeY7qsbWF5CZStQKZuE/9KCCH4EN2g93mPWJK0h1xfehPNQ==@vger.kernel.org, AJvYcCUTYv4gA4SSSd5c0vFnKFCe9WUSQ6qbeMOqKI9tZfoa3aMRxLANPRprYnAwwegNpZwx2A2f+82bTq15qQ==@vger.kernel.org, AJvYcCUdOr75UNYchjCD8ICbpRI4IU6h71HwF5+VQhqVcm1H2vzvDli099pZoIoHxFwBo2yAR6XobEjMEH8ePQ==@vger.kernel.org, AJvYcCUl+lcGULIDP5EXFIX8jycnPpZXGxEShXKnurMvsGxwp3G3k+humhzPbsPkIRWhqywgZTA=@vger.kernel.org, AJvYcCUpBYi4IYwchoHardn9gBg2tZlbDCsKm/sMVjrp8UsFhg5WfZr64UDm0fxw9E+uO6LztROONeu/@vger.kernel.org, AJvYcCUuGa4R2NZpDWSTtoVi5KhvFM4O/BbgErU7jTzRtc3E8drWlnYFQXugLtnaavZiIMWt+CNdfweAR31iJA==@vger.kernel.org, AJvYcCUxyi19ZsGHB/F3Ot03AdKQFQ/2E23HMkgNbxJNc92nvapEpv8xWPQIxxidi0qFFpOsrxbC0pT23Ulo@vger.kernel.org, AJvYcCV8vuYcdCmlVCbkMqsvI0VcEvPnFy6lsWWb0KBTMgEcPYO3jYwRdjpVz2LWl9tqDCf5yT3ZjPgxSQjAeVLqizJR@vger.kernel.org, AJvYcCV8zKg3m5GGYYx4gLhDgI3FiIq9FGV1nc1d7VSd
 xe0C26rqZjDDXFUcCnyHmsS8JLJX9Qm91onsCv3T99wX@vger.kernel.org, AJvYcCVPephLkKTdrQsgtZZZpUq5bJiCjn2B5MkK2g6ecwLNkBShpbned9qmvgw5ljsKEGtWqTIR8S8P3W4=@vger.kernel.org, AJvYcCW7uqAB66Ary3KPonJlJnKYzAjSG+WVTrX0pIaJuZvLM3nYCVn4dbCzEnp82RGpuKD1JQfD1zgTxDqr@vger.kernel.org, AJvYcCXII84sUJcMlMxKZL6U0/ELND+Y8XfStBWUrKlXBXiHo5m4VIRg7bi0OXGGDWw/cMwrbToeYx7vyL17CA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxeTgQl3xwTOOQu1feED/x9zymZJBvH50oOm64FeSDPK5M1GcmL
	AowwyWoHQ3k5MD34Oz+Khk9WKI9U7r0GYDvNBuJr32U2xb/uUDg=
X-Gm-Gg: ASbGncs/8+SW8QoyUkkUtbXEEryA/QWnRuiZWux19n6rw0rHGXjn/fQ0UwpCn/I5Ln0
	R3jLiAjHCsnzroBE0nuJcc5WRnVBC4gwE/ph2OPGPhHt6C+O3HMa0mstYULMdUYhianNx0KmkkR
	CpgMuxXraAcVfg1EBygzNzSLzZxlrbUW6g597T72l3p1IVOvTUhhSUL6c2ih/R/aK3ja56b4bZ3
	JyXILgGU9qtaIPMjaqjyGFHsAr3lkyxlnLcG70+7qV9bOLjB9YcuP137s2k5fj8nw/fdc1d6por
	FZ6uEZmYbomlRMxBn/Uhkfv8f4g1yPHmlZZkdBSGyziQ2fLLqfCZnHk=
X-Google-Smtp-Source: AGHT+IFXBij7YY6OTj5GMzGgIwp1/yPImE6Pq87f1IxAZ8AzDKSftLkrfp99lNthyITIW+quB0Qxkw==
X-Received: by 2002:a05:6a00:1412:b0:736:3fa8:cf7b with SMTP id d2e1a72fcca58-739803bc866mr12795498b3a.13.1743455092825;
        Mon, 31 Mar 2025 14:04:52 -0700 (PDT)
Received: from localhost ([2601:646:9e00:f56e:123b:cea3:439a:b3e3])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-af93ba10126sm6811351a12.75.2025.03.31.14.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 14:04:52 -0700 (PDT)
Date: Mon, 31 Mar 2025 14:04:51 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Breno Leitao <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Karsten Keil <isdn@linux-pingi.de>,
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
Message-ID: <Z-sDc-0qyfPZz9lv@mini-arch>
References: <cover.1743449872.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1743449872.git.metze@samba.org>

On 03/31, Stefan Metzmacher wrote:
> The motivation for this is to remove the SOL_SOCKET limitation
> from io_uring_cmd_getsockopt().
> 
> The reason for this limitation is that io_uring_cmd_getsockopt()
> passes a kernel pointer as optlen to do_sock_getsockopt()
> and can't reach the ops->getsockopt() path.
> 
> The first idea would be to change the optval and optlen arguments
> to the protocol specific hooks also to sockptr_t, as that
> is already used for setsockopt() and also by do_sock_getsockopt()
> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> 
> But as Linus don't like 'sockptr_t' I used a different approach.
> 
> @Linus, would that optlen_t approach fit better for you?

[..]

> Instead of passing the optlen as user or kernel pointer,
> we only ever pass a kernel pointer and do the
> translation from/to userspace in do_sock_getsockopt().

At this point why not just fully embrace iov_iter? You have the size
now + the user (or kernel) pointer. Might as well do
s/sockptr_t/iov_iter/ conversion?

