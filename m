Return-Path: <io-uring+bounces-8848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 886DAB14435
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 00:06:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A2D94189A83A
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 22:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 234BB1F4CA9;
	Mon, 28 Jul 2025 22:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8OWcMbi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D7E8488;
	Mon, 28 Jul 2025 22:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753740401; cv=none; b=K1Pf5Ozslwz6oUgYTXTLKnBE90II/DTIZhUqMbPNbDKU7Y5YaaNM1aDZ11OTAPyNDL3WlxPNNG2cQz2nVLivoH09qVRA5I9CRv2kVOoPuwzglAGYCnkSosweuueStGX2WGxy8WKW3WqlMByv7m5v5xGwpj2SnxqMbEI0FuKU/+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753740401; c=relaxed/simple;
	bh=DzPxSZg9plhhUNL+/1cJzQHxDXAyoRrOHymnWam8ij0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gFrbuTWa6SOOKFhGK3wMpiRMX6DZ9JH5/CIgnjiwwLUD09ToQav1iqLTb0upyA7lTO6noDYgn/BC69D24zAkeENNbuI/jZ/11sJOIWDGcSMnLIVjbfFXusC7kGEIL9mNzZF8MInBCSo99hJ18VF3S5CilvkUKAYCnh8cfMKZE5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q8OWcMbi; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-23dc5bcf49eso67748645ad.2;
        Mon, 28 Jul 2025 15:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753740399; x=1754345199; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XZJ5GElUQmBd+wsZknAbjPYYYEXANeLIyzreKcYGoWg=;
        b=Q8OWcMbijKWZH5ezKa6FtjcsxK5yJob01MKP6kmhHRS05b3tr9CpoUls9kdz0pOlug
         VIYZ+FWh/fD4tJL0Oe8K99TzihNINd6u3v7azbSRBYWhEZYqI3ZVr+gHmk2TH0cs+nKO
         Agp1VWwG277okfwNNCKzJtmjLIrxsUQhCo6b4hoaWz0YmcCvEJjSFr/GK0fxUP9ZbeKW
         4JlQUPopu9B2TjVyM9UWzXK4VwNAbS4nLuAM/k/FCiGgw8uPE30v9/CA0Vy6cPbwsO4E
         HH5QnqtplwS7e3gqFHl5WaPEXw5bseuXmbjwHwgp76vRoUEKtcJGb023RoLkY8pAqLuC
         FF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753740399; x=1754345199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XZJ5GElUQmBd+wsZknAbjPYYYEXANeLIyzreKcYGoWg=;
        b=HokjtOQn3Gc6Qy3TIfgWD/A0pNt5XgJVTPM9Ep76VxrtmpOeT/3x6iOtFySqHAC8aA
         IRnpKvGMJEX6eftzKfBX7vQFXlMUMHHPZRyeHRX+Bf3Cx1yqr7RI+RR8vEpsHrsaxRIl
         lIoVqIASuYqADYd9Zkq4CJ2iun2fNRTwa6A+9lMaF53zPZ/ZCD626QEqrh+ctZXXq8Z8
         30VLuB3mTS5L6NNmuDkOVUnbcLzz/ETDLhdtHTyNyMbiEFfzOftBYbryxI3cZupB8HqC
         qckPP7OZxwIplg8lXKlxxwS1tJwwzPbq9ci00BHfrZEFgzR4oDkfgRqfsJcogPW8l44d
         +zJw==
X-Forwarded-Encrypted: i=1; AJvYcCU6apLvBdcusyQQ98bWZgglzN+zLgoMymD0ronDpSl/J/+RzsrjDoGwrdHyBIolg0KwbWR4HHX5@vger.kernel.org, AJvYcCVUwGQjbLkegAyGw2Dr7rCAms4+njxlEsFHSlfFNjUkIPp2cvNkWigoHekTP39kA+vG2i/kfzq2cA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+ApsGeUKFoHbR0Z7jYg3eIz00/FiYvyRAEoDoEshTYmJ1AePK
	EFB/M4XvD+NCGIW8EwtR/VfDKWer8/9NapxoO86qhfC8m+nDIVe5noM=
X-Gm-Gg: ASbGncuj9u5FRvS+VrxIAWzVtdgYP4sTuMgK/fiKchPK54vqZA9ln0lw0WBCPrYGoZb
	c56EOA6crNaUvEbt8BA7X3h3DOWIclrgXpk11wxXSmqOEULHVhpxMvr11Y/BTf9qTUza6voUGXm
	2hmXl4qG/MpfPmm7NW/5t95V78MnG81qzpWxsrOo6kT12iML3BttnZDERSYXkBB0XSsi0nCsV76
	e928ZoGN65wVhYMJYsqZsqJHmRBtROfct/imQLOF0mW8rdxIL0uU2Vq0DTlm4XhqMRK5GwooMCk
	w4IKbN/4kqABhQx3x0gY/KHc23FbMRNYYgomA9VkzdLu+HbD2E8L3v2E7J6/w/PsqF3DfJ/V+mE
	1CPIijKnpQ0UggRa0u8rHgKDlXDuddvvBD9PB53SzU0rl8xAkrv/Pj2YzrfcHwjADGBiO8w==
X-Google-Smtp-Source: AGHT+IEWyvhWmVEUN/7c9sJ3B+KEM+IiQGdvUpKK3+C5fSLQHrtLB49W1oB21c4Rjg23JwUb7LNlBw==
X-Received: by 2002:a17:902:f70a:b0:240:eea:35f2 with SMTP id d9443c01a7336-2400eea38cfmr105303125ad.24.1753740398706;
        Mon, 28 Jul 2025 15:06:38 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-23fe5eca766sm50434205ad.211.2025.07.28.15.06.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 15:06:38 -0700 (PDT)
Date: Mon, 28 Jul 2025 15:06:37 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch,
	horms@kernel.org, davem@davemloft.net, sdf@fomichev.me,
	almasrymina@google.com, dw@davidwei.uk, michael.chan@broadcom.com,
	dtatulea@nvidia.com, ap420073@gmail.com
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
Message-ID: <aIf0bXkt4bvA-0lC@mini-arch>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch>
 <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>

On 07/28, Pavel Begunkov wrote:
> On 7/28/25 21:21, Stanislav Fomichev wrote:
> > On 07/28, Pavel Begunkov wrote:
> > > On 7/28/25 18:13, Stanislav Fomichev wrote:
> ...>>> Supporting big buffers is the right direction, but I have the same
> > > > feedback:
> > > 
> > > Let me actually check the feedback for the queue config RFC...
> > > 
> > > it would be nice to fit a cohesive story for the devmem as well.
> > > 
> > > Only the last patch is zcrx specific, the rest is agnostic,
> > > devmem can absolutely reuse that. I don't think there are any
> > > issues wiring up devmem?
> > 
> > Right, but the patch number 2 exposes per-queue rx-buf-len which
> > I'm not sure is the right fit for devmem, see below. If all you
> 
> I guess you're talking about uapi setting it, because as an
> internal per queue parameter IMHO it does make sense for devmem.
> 
> > care is exposing it via io_uring, maybe don't expose it from netlink for
> 
> Sure, I can remove the set operation.
> 
> > now? Although I'm not sure I understand why you're also passing
> > this per-queue value via io_uring. Can you not inherit it from the
> > queue config?
> 
> It's not a great option. It complicates user space with netlink.
> And there are convenience configuration features in the future
> that requires io_uring to parse memory first. E.g. instead of
> user specifying a particular size, it can say "choose the largest
> length under 32K that the backing memory allows".

Don't you already need a bunch of netlink to setup rss and flow
steering? And if we end up adding queue api, you'll have to call that
one over netlink also.

> > > > We should also aim for another use-case where we allocate page pool
> > > > chunks from the huge page(s),
> > > 
> > > Separate huge page pool is a bit beyond the scope of this series.
> > > 
> > > this should push the perf even more.
> > > 
> > > And not sure about "even more" is from, you can already
> > > register a huge page with zcrx, and this will allow to chunk
> > > them to 32K or so for hardware. Is it in terms of applicability
> > > or you have some perf optimisation ideas?
> > 
> > What I'm looking for is a generic system-wide solution where we can
> > set up the host to use huge pages to back all (even non-zc) networking queues.
> > Not necessary needed, but might be an option to try.
> 
> Probably like what Jakub was once suggesting with the initial memory
> provider patch, got it.
> 
> > > > We need some way to express these things from the UAPI point of view.
> > > 
> > > Can you elaborate?
> > > 
> > > > Flipping the rx-buf-len value seems too fragile - there needs to be
> > > > something to request 32K chunks only for devmem case, not for the (default)
> > > > CPU memory. And the queues should go back to default 4K pages when the dmabuf
> > > > is detached from the queue.
> > > 
> > > That's what the per-queue config is solving. It's not default, zcrx
> > > configures it only for the specific queue it allocated, and the value
> > > is cleared on restart in netdev_rx_queue_restart(), if not even too
> > > aggressively. Maybe I should just stash it into mp_params to make
> > > sure it's not cleared if a provider is still attached on a spurious
> > > restart.
> > 
> > If we assume that at some point niov can be backed up by chunks larger
> > than PAGE_SIZE, the assumed workflow for devemem is:
> > 1. change rx-buf-len to 32K
> >    - this is needed only for devmem, but not for CPU RAM, but we'll have
> >      to refill the queues from the main memory anyway
> 
> Urgh, that's another reason why I prefer to just pass it through
> zcrx and not netlink. So maybe you can just pass the len to devmem
> on creation, and internally it sets up its queues with it.

But you still need to solve MAX_PAGE_ORDER/PAGE_ALLOC_COSTLY_ORDER I
think? We don't want the drivers to do PAGE_ALLOC_COSTLY_ORDER costly
allocation presumably?

