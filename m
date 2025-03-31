Return-Path: <io-uring+bounces-7334-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EA3FA7705B
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 23:50:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D6B53A597A
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 21:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47AE218ADD;
	Mon, 31 Mar 2025 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="morUWOEi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B41F214A8F;
	Mon, 31 Mar 2025 21:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743457793; cv=none; b=FmKcYp2rN9vrht9v6oiuFDaavfd2I/eMzM8TjLMYvxws4jCn2dY+NOcMRtmqgR8Pi7B7Tvrk7zU5N8d5V/50mHVCd/QYhKrIpa8CS5ztgZVpPxRPqdkmS1R+dDb0xact/ih5tT5MpKM8aRouPlpC5kFy3W6e/BEx9PwkazJhV+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743457793; c=relaxed/simple;
	bh=AWpak+pu550+V4KBVwcURhmwvApWhG8AaMXUc5d76HI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qGtx4Z7Z1sXkWDKLN6A6yHfzshyp7z0hpydEKH0Is4CY8pLTotMlPfNBMKjb4O8SdAxnrDFjpGAfvXAAzOjrqjll84u93efWd4+dJkLTrA+K419sEoY5LWxibW5pxkCLsW/j45T0tsSPSfk2oBRObu9Nl+sJr0szUfjJvTwaAu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=morUWOEi; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39149bccb69so4353554f8f.2;
        Mon, 31 Mar 2025 14:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743457790; x=1744062590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vdstssp5d3ULMv78iW5ykH4+Ki4j9LIskO4UfhbPQIo=;
        b=morUWOEiSIHhr65OgWkLtpYzIKD+He8Q+R6m3H1i42TPB2PX4NB5OkXfVOaG+FQMeG
         LvFwMfVv+5Pqh6EMHDe+tn6jv36XziePWgVd9jYjlmlKwUwYM0ohFZvzwM29f/tlGbJQ
         PxqKNaV0doSFloJO+LMqlWil/OINdG1VdV7GVDhLoofTCJy18Ac3nqLtLQtnGJ7VOAe+
         S7ygjO8CdFMUWaTTiLNaIZajPzc2Jmbzgqeewo4feO9KrkYQq2LRRdoXMm3O+9O+xS4A
         C4j0GyrDKZYBCQXuZloE1gpsIOSO6AeHkckV/98z1HF4x+3EchLbtUlvlNmtGd8sDNJV
         qF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743457790; x=1744062590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vdstssp5d3ULMv78iW5ykH4+Ki4j9LIskO4UfhbPQIo=;
        b=UGFftaY4B2Yd7ZtTyQpGxsTJ0BmdOMfQZ3SSwepEit3uBbBu8W0V5mt6RusvtJ8llY
         T03tnGNwMSTBsGq2KaR/I4ENrfCzZpgk99Bvfy6XJlvGC79vK7NfeQFUFfu23X7uNCgN
         BEUTvHvtexDSBEnn47tY3XD73lpWni5fpEliT1Q1yP9hfohhzzspxAUBDwbPfQytUsK8
         ri7QwtovOy0N1YZB0/MW49yaqGXeXyCJ106Uy+VBBKFAaz0APQAjp6aoiyeZXwndtWdw
         geO11UUwc1GWh1BAAwzit3gteD7UQ0hUqb7oFtV+1JR83fm0VqZ2fn8BgMeBS4bQgIF1
         XfHA==
X-Forwarded-Encrypted: i=1; AJvYcCUQcrsm/Rm2ALVJDXwvFnMYrUCVo8Kv8Zhi1pZewpPOdr9979FqwqxsO8alwKtOPfMhYaxte5IHCukBxQ==@vger.kernel.org, AJvYcCUTlmbbTJUKmPlVs5zE0CTClYIKLv+YiSfPoWKHeVaPlKrSC99nGvgwJYkaUzm17WN9a8iJQXroKQPeuw==@vger.kernel.org, AJvYcCV+u0obV1qKfTzFWtDi/a9tFaczicDRR+MTBD9HyFghP+H6ea1mOqghzsRWSjiAyeY+bpI15iP3@vger.kernel.org, AJvYcCV3VTUdRtFhEepJaQVUiIxPDZJjBt+cPeM9E3KtkTUvZFi+wNEsQjAFu2A1PX+dyQgJyaG8pQ==@vger.kernel.org, AJvYcCVxsJ2f9xRExcW8qvMmoWKETcR48SM0BNtitGZR10bh15Sgg3kY31mmLW84diHbUbDSBH7hL5fJXCXR4w==@vger.kernel.org, AJvYcCVy7zgsn1xdsDRfdvNl6L9/G1QstXruhM1kOy96OmdYHP1zip4/g4pt206qE2PLQzILF4NeXvoKhraB4Q==@vger.kernel.org, AJvYcCWQW6S9sB5r8o5a3ES2+XHqYiWCZ/QaviVp1OWgJIG3AlDJ9JXBIR5yrvmohVaFaPwC6he/QbDNsA6U@vger.kernel.org, AJvYcCWd0CnBHpm9oGSaoSutr1uSk8t9RDqmQZvey058F4AwtAqXgBa9cUo3vSEZYoqwVIMgCxFs6iuPtfo=@vger.kernel.org, AJvYcCWf/hW4v5Lm8Om1qxlWiVNgQi8UeZY4HUu4fVnufalFezM8eQ+37KFobRV3NovVAZZhI6VwlVYc0fYieJVpLebU@vger.kernel.org, AJvYcCWoHEu1hy8W4gBFQROawwsCuc9FnrLs
 zPYhxmLnrJqgnAg/XNwqy2qA9H+8fNzSSXz9inm4fFa0nezb@vger.kernel.org, AJvYcCWvpIFKoiyBYjMFKz/rG+hYi1VK3Z4glznhFXMdRRv4NBxKD17654yiZU4kOzi+P9zTwaM=@vger.kernel.org, AJvYcCX67/XFksifD4TezFPSCv1F9kzngqU6HXfgVMJiB/XmwylBSzKrT6DVzIHSTWipi1lr0eF1eZzrpWTwvDM/@vger.kernel.org, AJvYcCXTFBzPfTo1XAFstd6IUk2LWuJKbmfPUhZuaEqknpXCf4mofKjdsMDl2vBp2+F2c/J18vQwJ/Fg3ZVoaA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+Q9DPMWIWojZj8OA7uU+F+8KfYF0+xe0ak+WFqrAhfobvbQPa
	FMQcXUxvr5vobBjBCVqoZJeX1GDe0s1rykPpKDWQmJ2Z+yLxFZMV
X-Gm-Gg: ASbGnctNz9M+RQvskGSXU6sbRAaBhPoFm+GWB4B+ImTOwwqKt+fShMdbRY0vz1g02MB
	Tykm3FdizCtQJoDDAUCj7Bp4XxkaVTROUXE5yLjJZu+vEc2qixt7J9OjoCouyvl2ok/bWSoU2Yt
	ODcGvv5D/WLL1Jy2A0nFMVQir4R6hvHD/Z1eEtHj01/eEvXJRxDsTW8ayyqs6aOTzuiPx5rO7XH
	Qn1ylFedeccUwdZOs9h6JY3z59/CMz/eKyHJKHJAmZ13Ja4tK+5D3wzqKAZrED6tHH8gXF7ND1y
	xTTasyB9S/g1pHt9iytQExV5jrUxhJSfwIN4DE3sck6R/TG+FLNRqxz3PhO/5SDY4IxelzpEm6G
	eL/IH630=
X-Google-Smtp-Source: AGHT+IHDaz6qc5K6SYy9jlhEIozUCY4N2JwSt3T6Lks7AZ/C8EYmlUGrPLhFAhoyTSOCg3hYOLXzSQ==
X-Received: by 2002:a05:6000:18a8:b0:399:6d53:68d9 with SMTP id ffacd0b85a97d-39c12118aedmr9281669f8f.38.1743457789764;
        Mon, 31 Mar 2025 14:49:49 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b7a4200sm12490080f8f.96.2025.03.31.14.49.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 14:49:48 -0700 (PDT)
Date: Mon, 31 Mar 2025 22:49:46 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Stefan Metzmacher <metze@samba.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Breno Leitao
 <leitao@debian.org>, Jakub Kicinski <kuba@kernel.org>, Christoph Hellwig
 <hch@lst.de>, Karsten Keil <isdn@linux-pingi.de>, Ayush Sawal
 <ayush.sawal@chelsio.com>, Andrew Lunn <andrew+netdev@lunn.ch>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Kuniyuki
 Iwashima <kuniyu@amazon.com>, Willem de Bruijn <willemb@google.com>, David
 Ahern <dsahern@kernel.org>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Neal Cardwell
 <ncardwell@google.com>, Joerg Reuter <jreuter@yaina.de>, Marcel Holtmann
 <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>, Luiz
 Augusto von Dentz <luiz.dentz@gmail.com>, Oliver Hartkopp
 <socketcan@hartkopp.net>, Marc Kleine-Budde <mkl@pengutronix.de>, Robin van
 der Gracht <robin@protonic.nl>, Oleksij Rempel <o.rempel@pengutronix.de>,
 kernel@pengutronix.de, Alexander Aring <alex.aring@gmail.com>, Stefan
 Schmidt <stefan@datenfreihafen.org>, Miquel Raynal
 <miquel.raynal@bootlin.com>, Alexandra Winter <wintera@linux.ibm.com>,
 Thorsten Winkler <twinkler@linux.ibm.com>, James Chapman
 <jchapman@katalix.com>, Jeremy Kerr <jk@codeconstruct.com.au>, Matt
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
Subject: Re: [RFC PATCH 3/4] net: pass a kernel pointer via 'optlen_t' to
 proto[ops].getsockopt() hooks
Message-ID: <20250331224946.13899fcf@pumpkin>
In-Reply-To: <d482e207223f434f0d306d3158b2142dceac4631.1743449872.git.metze@samba.org>
References: <cover.1743449872.git.metze@samba.org>
	<d482e207223f434f0d306d3158b2142dceac4631.1743449872.git.metze@samba.org>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 31 Mar 2025 22:10:55 +0200
Stefan Metzmacher <metze@samba.org> wrote:

> The motivation for this is to remove the SOL_SOCKET limitation
> from io_uring_cmd_getsockopt().
> 
> The reason for this limitation is that io_uring_cmd_getsockopt()
> passes a kernel pointer.
> 
> The first idea would be to change the optval and optlen arguments
> to the protocol specific hooks also to sockptr_t, as that
> is already used for setsockopt() and also by do_sock_getsockopt()
> sk_getsockopt() and BPF_CGROUP_RUN_PROG_GETSOCKOPT().
> 
> But as Linus don't like 'sockptr_t' I used a different approach.
> 
> Instead of passing the optlen as user or kernel pointer,
> we only ever pass a kernel pointer and do the
> translation from/to userspace in do_sock_getsockopt().
> 
> The simple solution would be to just remove the
> '__user' from the int *optlen argument, but it
> seems the compiler doesn't complain about
> '__user' vs. without it, so instead I used
> a helper struct in order to make sure everything
> compiles with a typesafe change.
> 
> That together with get_optlen() and put_optlen() helper
> macros make it relatively easy to review and check the
> behaviour is most likely unchanged.

I've looked into this before (and fallen down the patch rabbit hole).

I think the best (final) solution is to pass a validated non-negative
'optlen' into all getsockopt() functions and to have them usually return
either -errno or the modified length.
This simplifies 99% of the functions.

The problem case is functions that want to update the length and return
an error.
By best solution is to support return values of -errno << 20 | length
(as well as -errno and length).

There end up being some slight behaviour changes.
- Some code tries to 'undo' actions if the length can't be updated.
  I'm sure this is unnecessary and the recovery path is untested and
  could be buggy. Provided the kernel data is consistent there is
  no point trying to get code to recover from EFAULT.
  The 'length' has been read - so would also need to be readonly
  or unmapped by a second thread!
- A lot of getsockopt functions actually treat a negative length as 4.
  I think this 'bug' needs to preserved to avoid breaking applications.

The changes are mechanical but very widespread.

They also give the option of not writing back the length if unchanged.

	David
 

