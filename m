Return-Path: <io-uring+bounces-8860-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BC8FB15181
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 18:41:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A09847A2C38
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 16:39:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C8C295DBD;
	Tue, 29 Jul 2025 16:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WHPbkgBP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD74186295;
	Tue, 29 Jul 2025 16:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753807266; cv=none; b=fblagQcXJgUsOOXxA7AuhbD+4oQgLYV0nT9cVhNANRMpu7cAcVZT9w7e0A56v9+g66dD8aPGxrS7IaXl95kfx6sxdw/s/obGVk8SOHSCVXd5VbyalFElG4NmZHOkc6MEFgAfXFNl6JellcCobl8FEATqdZjYqVe8tTo1JMi3OWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753807266; c=relaxed/simple;
	bh=Llyr5jaiR1mDdsA/piUhjEcFPCZCD3P3dFT3wnjZNQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aiwj4IYSIpjdsjjjdr9xU2ra0OUWvLZSzEVxj+k4c4S/uJ+F9lu2JzBuCGEHHyjTS/sKQGbMBgkUqQFj3E/j0uLP5FuM/BLdx2PagLfvo8qbCQ9H52l06ZAqksBXXc6AmFpCu5nuhvEA4BvVlDT9bnDy22x9CWqaozJDpy4cG0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WHPbkgBP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2400f746440so25017105ad.2;
        Tue, 29 Jul 2025 09:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753807264; x=1754412064; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Ru7FYkhdAigOEVoVfqZe/qLye1UlV/5kW+i8Hi2XMCA=;
        b=WHPbkgBPbGUanFnE/Kgg61QLBvqpJARDJ7srKnx8nNxIAJMSoBybxf7w6tUDs6oPjY
         hM7gtm2pwg4T1qmyEcNYVV2z3JwNcLQKNejl0zLr/ra2VJ80JJGSRlhcbu1HkNSiWk7u
         CiEl78drE3Cfcw60DAcOvY0U94pW0eREm+zTxE1vxRd8y1VPc2I6xjFpzFXdQ7Y3N29N
         0uHS4i7ef6JJKw+YNFWj7udtC3E/vIobUxKmReFMQVYGyI0ZBHVXQCpnGOKcFPddv+dM
         ZGW6mOTxPZVINQSuB4Gut43nZurzngBVsVyh736NfoFf6bduj11vF9swHj7RmOviaYk5
         PLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753807264; x=1754412064;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ru7FYkhdAigOEVoVfqZe/qLye1UlV/5kW+i8Hi2XMCA=;
        b=vXiYkWom4zk91ELurcs1gninW3PM8lieXSpkGmS8DVYU2Moz3FSqiqutKCfA5i7UGo
         WUm75sMoOG+SZwwO7kGoqmsEP2BNMSndR+BRQ7I4WlhJb7At+9FrNTnEfmOBp2vwfQuE
         CC5EljKctALKeswLBBgbfM2EqxErq316O939H0aISJ4sSlvszDLHrssyYuX/2Rf8BYDQ
         NLUNOOpuPZRHlrryMVRzJFRFnTtRntsvVMybYsVRtWeAuFeFpFvwKRZGEo8GXmrN1R+1
         I+zyWr9eOQ/+eqbyerhqCjqw2R+XOoQoG91L/GV4owwkbtm8C3Ekd6ayU32jiFsHOVJN
         WK6g==
X-Forwarded-Encrypted: i=1; AJvYcCUzs53Y6rRktrQGNil30YLFF1+XdynxaR5DR1cqLPAue2su8UTDhnz4775Q0NStm4jAmtKwa+cAng==@vger.kernel.org, AJvYcCXDMmDziLyWYlLjUNlNasZqAq32uzCwn2yIK4fH5vD2ogVZRZl4RM9mi7vxxycNhfo+IfS26jdn@vger.kernel.org
X-Gm-Message-State: AOJu0YyKCjn8gLdIqVhK7epLcNH9ICxuMESFw5Qu3dfjXGPU1JG2/Pk1
	B09UHUI2hTgCvOewx40uDMk6XI87yyLZyOA51CmbEueIQoFz1Gi+euk=
X-Gm-Gg: ASbGncujFr5fYPrMJipgCcq097kPsqPcGxcoI31RmCR9jjZP7uwgx7qLcX4yVZWDdul
	BztFHpwfw/zlJDotwy9grTzeLjZj3Bwtg8m+OHARd4uCMC2WzguNe3OI3KindcAYjQip8udjNSW
	xsxI5b1rX6hJsPWvkiBo6NSpc7kSex9oeerFlDkk1mHTnNv8OcWfpBKtXELEs3AWcqvF0JduXWf
	iIcLBvhFQTA+A0O4Kbp4EFZnbOzYrNJbmGcEVS/V1fBvIjzehI6Q6825PA+XfoTjlSQc7P5eJ10
	IGt3if2UfZYEQExt+k5S/BVW1V2bSHdlPCSmw9ub7Pfi/slLZkzKYOJWya6ipu1lMRJnhAvTJey
	HveaQyoTSm5//MQTFkK2Hk3MST2WdoHhGbwaF2dqz3oudT03T3MWrqoGAB14=
X-Google-Smtp-Source: AGHT+IERa0EOnuLcjvz3JRG/EuKxPZfiOb/TBLMk6UnGG/dNLbvL7o+o+SG+cb0snWBvMJ00DCaTCQ==
X-Received: by 2002:a17:902:e801:b0:23f:df69:af50 with SMTP id d9443c01a7336-24096b237eamr873835ad.34.1753807263561;
        Tue, 29 Jul 2025 09:41:03 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-b3f7f569d18sm7422028a12.11.2025.07.29.09.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 09:41:03 -0700 (PDT)
Date: Tue, 29 Jul 2025 09:41:02 -0700
From: Stanislav Fomichev <stfomichev@gmail.com>
To: Mina Almasry <almasrymina@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Paolo Abeni <pabeni@redhat.com>, andrew+netdev@lunn.ch,
	horms@kernel.org, davem@davemloft.net, sdf@fomichev.me,
	dw@davidwei.uk, michael.chan@broadcom.com, dtatulea@nvidia.com,
	ap420073@gmail.com
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
Message-ID: <aIj5nuJJy1FVqbjC@mini-arch>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch>
 <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch>
 <CAHS8izPLxAQn7vK1xy+T2e+rhYnp7uX9RimEojMqNVpihPw4Rg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHS8izPLxAQn7vK1xy+T2e+rhYnp7uX9RimEojMqNVpihPw4Rg@mail.gmail.com>

On 07/28, Mina Almasry wrote:
> On Mon, Jul 28, 2025 at 3:06 PM Stanislav Fomichev <stfomichev@gmail.com> wrote:
> >
> > On 07/28, Pavel Begunkov wrote:
> > > On 7/28/25 21:21, Stanislav Fomichev wrote:
> > > > On 07/28, Pavel Begunkov wrote:
> > > > > On 7/28/25 18:13, Stanislav Fomichev wrote:
> > > ...>>> Supporting big buffers is the right direction, but I have the same
> > > > > > feedback:
> > > > >
> > > > > Let me actually check the feedback for the queue config RFC...
> > > > >
> > > > > it would be nice to fit a cohesive story for the devmem as well.
> > > > >
> > > > > Only the last patch is zcrx specific, the rest is agnostic,
> > > > > devmem can absolutely reuse that. I don't think there are any
> > > > > issues wiring up devmem?
> > > >
> > > > Right, but the patch number 2 exposes per-queue rx-buf-len which
> > > > I'm not sure is the right fit for devmem, see below. If all you
> > >
> > > I guess you're talking about uapi setting it, because as an
> > > internal per queue parameter IMHO it does make sense for devmem.
> > >
> > > > care is exposing it via io_uring, maybe don't expose it from netlink for
> > >
> > > Sure, I can remove the set operation.
> > >
> > > > now? Although I'm not sure I understand why you're also passing
> > > > this per-queue value via io_uring. Can you not inherit it from the
> > > > queue config?
> > >
> > > It's not a great option. It complicates user space with netlink.
> > > And there are convenience configuration features in the future
> > > that requires io_uring to parse memory first. E.g. instead of
> > > user specifying a particular size, it can say "choose the largest
> > > length under 32K that the backing memory allows".
> >
> > Don't you already need a bunch of netlink to setup rss and flow
> > steering? And if we end up adding queue api, you'll have to call that
> > one over netlink also.
> >
> 
> I'm thinking one thing that could work is extending bind-rx with an
> optional rx-buf-len arg, which in the code translates into devmem
> using the new net_mp_open_rxq variant which not only restarts the
> queue but also sets the size. From there the implementation should be
> fairly straightforward in devmem. devmem currently rejects any pp for
> which pp.order != 0. It would need to start accepting that and
> forwarding the order to the gen_pool doing the allocations, etc.

Right, that's the logical alternative, to put that rx-buf-len on the
binding to control the size of the niovs. But then what do we do with
the queue's rx-buf-len? bnxt patch in the series does
page_pool_dev_alloc_frag(..., bp->rx_page_size). bp->rx_page_size comes
from netlink. Does it need to be inherited from the pp in the devmem
case somehow?

