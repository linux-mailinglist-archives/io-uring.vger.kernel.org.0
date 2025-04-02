Return-Path: <io-uring+bounces-7366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F39CA78E9E
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 14:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D9B11892BD5
	for <lists+io-uring@lfdr.de>; Wed,  2 Apr 2025 12:35:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99427238D35;
	Wed,  2 Apr 2025 12:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QcGL7P7x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6FE1E50B;
	Wed,  2 Apr 2025 12:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743597327; cv=none; b=h30ZLn+JkUvc/rCp75EnT9baK+mFmpIEYgLM+MWwud50Qun1Ux5MpdGxKAT6pA39HwOp0mgns5oiEJt1UYX5q7ABX5OL4/FlKCRYaplSHZcKR/4K9Wx4DYTBsPG2Yl+gT7w8qXNuNzbN7PkeE046zPzBWsN+Pj/boMr0YLapqP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743597327; c=relaxed/simple;
	bh=5x5voHAbthWztCnJTAxyUPzXr6ODagheOFflvD8Cgow=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMA7oZUMCtonaVfpWJxkF+P0OJ7BSsOvWYg+QhSJkZK+hI/WxIvN1zTQQR7g1YfghwIV22VO40xeAgHkqNDHApafGqfZFCwT1Hv/91aD+Rqjj7hca6jJ9eGt6abJElLe4u2nZ6WAlNCmU/BzGqdHEMrwE8HJuLxjYxuNT6f9UeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QcGL7P7x; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3996af42857so578663f8f.0;
        Wed, 02 Apr 2025 05:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743597324; x=1744202124; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQPuk4z8aXO1/VwBQYL7UU05vvl1F/e5DxjIm3de0nQ=;
        b=QcGL7P7xdIlNJFtbv1qiOnhd1v9UoUavw/eehcp5qTLK0ORnH24kzw7vGiboSbQGWD
         ppytj7pxBsNeBJ/KEKu+yDjfacmVaip2Rdtoiwu/lcFmMPR30sBASZMW3vgAcQlC/kcJ
         ONvHmufdnMwPmONrOTcijCBRR2mOKJRGN5Ik7OM0eZsVFF/wU6crTCymAIDEJLJ57LrX
         yCfYIunRsZeYeilqu/gLbzXgnpL2aIL7IAMuIsvD1k4EzGkwrkdWakxLu2W6ESTmdWUy
         CfBPgOa9ZZm0VX6/PZ/plvawSRCxyqIDzzojeiKRQDut4z5jxdRiFefL8ekzy/gSebAT
         iATA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743597324; x=1744202124;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQPuk4z8aXO1/VwBQYL7UU05vvl1F/e5DxjIm3de0nQ=;
        b=rchl1ru5mEMrx+XbmE9zYhC8XxudatiZQckUfx+Q2yI1Sj58lcKLgfU4Ag+BlD5Arb
         Apv4e0Uz0JaADiMbZPpur/U4xYeYusWhzxeYuYyN/bxXAX+msULtfbg7i1pT4E5IQ92U
         8ff4RlkkHQPUJkr8GnaY+PCPHdU911BPpY5oiE18oD6ZPQEJ4ecEA2ugmAK81GNC1yxt
         YNrSUQXHmX/OBYDNiDE0LoPdGvJU+NVDnFyibzPnKYAF4MTAJPPHF+19EBuLrx57rYti
         Z3mnVI5AD3WEUFgh1GuXKzJ8NRZkLp6T/wnEwj+4NbspODNC1CzRoL+iaejXknP/MY30
         /CAw==
X-Forwarded-Encrypted: i=1; AJvYcCU3ET9hdKoCZuK+lJXILl+QeOU+9q2P4mmTWak/Kb6lNcsImdv3f60sxiyThbSwBN1mMHzEbRhC@vger.kernel.org, AJvYcCU74I9PmntDjz8zfd5JZDle0wx1kYIfc3UH7VOnGLXRO8T1kaRpYEDHuDyHwR4oHrjh9lA1fW464D6N@vger.kernel.org, AJvYcCUpJAx58K9xug8hCIcO4omOHbbtVDeMV2FnHsQPCgMsjTFNxbSlMeWQecOe0YeZLxaFaGlvKWOxqhv/@vger.kernel.org, AJvYcCVUJIQV2CYwVKa47sx5jWjf8kaOKvNmxOpNFNgFc7bhaOknHWN7EAW74bdQDDY9T5HrEmu/12SEhRy+yOKN@vger.kernel.org, AJvYcCVc+6wQcTWNvC5fGMy4colAI6SZ5ypD70q24zcagN2lOyQSLqbRKyMOSFXfjAFRFAokq50N2/Y2WQlJZw==@vger.kernel.org, AJvYcCVsGxNX+HQ7AxC/1/MOiDCNjX8hTbxrcPkogZqgWZQ3OzRI/ptciXR0N1SDcONAsKeZ9pkDuueh0ltZKQ==@vger.kernel.org, AJvYcCVvaLjZn2jWAOMryTf4TiQ9104/LhPJuQlmGmJWUymC9iJ0/4vjoG9mB07t2hOOTQjCHjs=@vger.kernel.org, AJvYcCWAO6wB/JHNG23o7D8wYYPRsT4woPW+mTI+ON3VykxaRxp85v9QbDMaZ+YrItzAgAFSU0SMypZBWDKDhg==@vger.kernel.org, AJvYcCWTozHbnxqZ0g4Mvqobcf98xg3b/LKrcQklnfZuZmUTH9yjYQr7huKmW5V+sDaIgNuZGK4npl2r1tw=@vger.kernel.org, AJvYcCWUySn7qvYZ7IfLe11HJ2nL9+AItCC9UNyZkXUmJaOC
 5Snh0leeY34sY0lWbq7yG235zceWfeh4PKthCC7pWu0a@vger.kernel.org, AJvYcCWyNyjHbs+QL6MN+LXrAl1LtFZ9eY4JHcwvO0So+LWgY7csykGT6u2JddCF8rfT3w6cfy/x1w==@vger.kernel.org, AJvYcCX7HB3HV08iHwh/h7qhgJbtQznDp2S8P9T8x5XmSZO//Yk+PNt1m2Eg82rqf5DdmxFJsMM93cb+dEgfkQ==@vger.kernel.org, AJvYcCXnjTIbGQ42spZ/B8cllCy0Wnw15dTI6sCfNv7cnja1bz3/Tn2ImuYGsX8lMVOYVQ4lGKCcun7G0y+h8Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8kWe0OlPNKLMsRXrarDGAeF37TCmufpkhVJnukaY4cKLB0faL
	3tWGhirrQsk7ZSfwk9zR2+yAODq9btzp1uLBk55AM5iuoqTpS46r
X-Gm-Gg: ASbGncuwgp92SBngGAPvxqqxLAH0bom1QCyMzyiznnf/tCGA/5eVlJAmlDK+rd3Vnp6
	zAE5/LFt43ItXHumAUnhVbRGkS3yvPE1fPlWNMfine5e6ZD9Rq3gxTzT6aH2JW4g2J+rNl20ZsS
	zLqzJDsjitfGTXUaMmFSOVSU0qhHKnhsrrj2sLnDCplbP++r/MfJOV8Rhmp+SPpgcNN3ZeF43sh
	cS4bJRDDLZnS/RUO5Agu/e0ZkYgeE//MONrwhzPhIos2dK1WIj/OOfA+YsfwGcXbqTM2VGK70wH
	NG2d1QNr0uXb/qzKsUWEM9iad3ZDAwpqwWqN/VX7BfwQ3XSteV0ZNaELqpRH+bnF6OV4o4YKwmQ
	+sKwCmsE=
X-Google-Smtp-Source: AGHT+IHaPOBKU7A29Yjs98Lc1iT7Oi631s03TvCGaxR6gPTH2ceLJBkQprnFjuTvnVXixjBxLkV5PQ==
X-Received: by 2002:a5d:648b:0:b0:38d:df15:2770 with SMTP id ffacd0b85a97d-39c2a2c9272mr2009745f8f.0.1743597323750;
        Wed, 02 Apr 2025 05:35:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43eb613ae24sm19468475e9.40.2025.04.02.05.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Apr 2025 05:35:23 -0700 (PDT)
Date: Wed, 2 Apr 2025 13:35:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Metzmacher <metze@samba.org>, Jens Axboe <axboe@kernel.dk>, Pavel
 Begunkov <asml.silence@gmail.com>, Breno Leitao <leitao@debian.org>, Jakub
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
Message-ID: <20250402133520.40451468@pumpkin>
In-Reply-To: <CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com>
References: <cover.1743449872.git.metze@samba.org>
	<CAHk-=whmzrO-BMU=uSVXbuoLi-3tJsO=0kHj1BCPBE3F2kVhTA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 1 Apr 2025 17:40:19 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> "
> 
> On Mon, 31 Mar 2025 at 13:11, Stefan Metzmacher <metze@samba.org> wrote:
> >
> > But as Linus don't like 'sockptr_t' I used a different approach.  
> 
> So the sockptr_t thing has already happened. I hate it, and I think
> it's ugly as hell, but it is what it is.
> 
> I think it's a complete hack and having that "kernel or user" pointer
> flag is disgusting.

I have proposed a patch which replaced it with a structure.
That showed up some really hacky code in IIRC io_uring.

Using sockptr_t for the buffer was one thing, the generic code
can't copy the buffer to/from user because code lies about the length.

But using for the length is just brain-dead.
That is fixed size and can be copied from/to user by the wrapper.
The code bloat reduction will be significant.

	David


