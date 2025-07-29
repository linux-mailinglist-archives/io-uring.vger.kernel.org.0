Return-Path: <io-uring+bounces-8859-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 62AD0B15161
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 18:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FEF43BA5E7
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 16:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96E05223DEE;
	Tue, 29 Jul 2025 16:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T624DFFf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA7042056;
	Tue, 29 Jul 2025 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753806787; cv=none; b=QwK6vKq9HP0Ana4pxAbSYjmom6Ae/hH9Rh4xM0oFdEhsALh+ffeO2LaC5V86OFOnsF0Nw33zt4xMui41BOdYT7HCwaw6GGAP6LdJnfV6jDZhPOxp94BY7XPbtxzfvk3qGdyyrEg5D/qMer1nBv/JjXyUzk/vDjVQJvol3Y4vsE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753806787; c=relaxed/simple;
	bh=HxbsQntJmxrzuyCAsaP8tTVUNAzCOIIVhILFakGHdvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tRNSjgRhtWfYaJeYpygD3nq6sZj/8xcJZSUHblwxaRynR1Wuye/ePryWeJc4c1QAMXPW4en6nchcD8Te2R27eEVL19TJVG7uVYCDNpO+5Vb7ea3vQW/CBt9tm6Nvb4CABnTbYMTpzhvd83mH4knh8tpYFZX18tHKj5C14pMiDyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=T624DFFf; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-747e41d5469so6332612b3a.3;
        Tue, 29 Jul 2025 09:33:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753806785; x=1754411585; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J1NFI4N6+x+hzlzaal5TyQHWXT7ik9IXfSuhbG3naz0=;
        b=T624DFFfvNrKSR+fVkN9pYeqALVQ59H7AzcTCoXOJw50C8yySJpnPZsZCARnlLnQZh
         wx2Ynhx1+J32dI4KuliGDhdU4X46j1UY8oo/OAFxb7CuLpGEFyVx15Le+OojPOv2MC8m
         njPQI2OvmspqXex6lGbfvNfl+4gMP06bKoQF77c0xLkQOmZADrp8qEwQplV1AFBhQs5a
         lEWaVUo0KrMxIJRsydJ7hP5xc6evBxclCc9MWdyJfXaOtYJXuctUo7UtaGE7t0wJMHGZ
         jWXCwD6285ryf4KoHTSLa8RosI6roK92noivB4fGl+KkNxOmDvYhgpRN/kvXW5TpcW4M
         QnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753806785; x=1754411585;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J1NFI4N6+x+hzlzaal5TyQHWXT7ik9IXfSuhbG3naz0=;
        b=Ek/X/2Hc1CstUUdguldVSVnlNj5styWGBeri1AlNQFb+4NcWchQJeZw1hMB4T4tI6r
         jfxRKkRykbu/1QeiwEJmKRy9vAwZ8Kj/V7cMubvpxCrIHkhzWGC8r0fJMDpypM2v+tFM
         onSDUwNLTVTfOZI7qoFUXyodOpb2shyCHMavoCyLKoknS1HR9N1qRapO+26hRLYt2ZyE
         jjy44ioTYTvlTUfUPT7f6kklyOegBwsSQfAG59Sgc+qz5gKzUtol3h9KjfALb2+Tb/C5
         zETYqSosKxR/Rx+WMgkK0Zvhr+W9awcEIw6TgKzxaHI8UYFgNE2NDpHtDrGBmahaXOSX
         l/8w==
X-Forwarded-Encrypted: i=1; AJvYcCVafa+fMhK+g+qxBZS72/LPkRv5w8aDeURf/qhRg1RlPwafKtBq7P+vNm3TaWs4x8xspuWUGYAV@vger.kernel.org, AJvYcCVsoPwBOvKnuESLuajrRQDnBibmpz/aE+hzmAbRGaR4NXLy58x62kQeGvRg0T/vJL4mFHukKyff/w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKCcL4JIElH8YB+J2tiV1IinsH7Da3Q8UIwQ/R/i8FTcZembAT
	xVrxl9klwK5bdXn+5CZxcU0tA52IF2zvCOw+SDoQtGRSU6L3OeASM5U=
X-Gm-Gg: ASbGnctcQ+bZGMt5pL/uLp475Qt3HElXmT4NL24qq9Y/hXQMbKfYzW2sr7Mp/Znx3hU
	mpzsKwt9JdgTXF8FzUWlFY4xGmY/DbyksPYPGYL9Lqr3TlKM+AgC7dyDZ/oHYBiJaUjscHu5vNQ
	fQv+LDdURWJhEfLoansR1DcexpXgpnGkBczyTnuw3r/mmeEXRA0xNaDB0anZnXNTJlLaaDyW/KU
	usdRDfqqXLAKPd3JYD7G0557mM3uFjU46lC5P/B77/fI55+UFg0eb4DEGfM5dS9gSeRMEVh2MSq
	0TY9HdWvz0OsyWltSW1UPHjarlui/1DgIxvJ9AJTxz+FII1iiUM7z9To0Z2ZU9kRmDMp/Twr4IX
	GTJa026tZrwwYwvRZpy9qFbRFl5fe17pF4YfuRUMReTLZFHc1Fcidbf7PslE=
X-Google-Smtp-Source: AGHT+IEjrKsWuvfJSXX0fFlRb3tbFbX+u5N7H7z9urdqPz2kKBzy+WvWpVYVm7b0aUWHfawEm/lc4g==
X-Received: by 2002:a05:6a00:ad2:b0:740:b5f9:287b with SMTP id d2e1a72fcca58-76ab0a264e0mr372498b3a.1.1753806785099;
        Tue, 29 Jul 2025 09:33:05 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7640adfe772sm8515803b3a.72.2025.07.29.09.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jul 2025 09:33:04 -0700 (PDT)
Date: Tue, 29 Jul 2025 09:33:04 -0700
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
Message-ID: <aIj3wEHU251DXu18@mini-arch>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
 <aIfb1Zd3CSAM14nX@mini-arch>
 <0dbb74c0-fcd6-498f-8e1e-3a222985d443@gmail.com>
 <aIf0bXkt4bvA-0lC@mini-arch>
 <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52597d29-6de4-4292-b3f0-743266a8dcff@gmail.com>

On 07/28, Pavel Begunkov wrote:
> On 7/28/25 23:06, Stanislav Fomichev wrote:
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
> 
> Could be needed, but there are cases where configuration and
> virtual queue selection is done outside the program. I'll need
> to ask which option we currently use.

If the setup is done outside, you can also setup rx-buf-len outside, no?

> > steering? And if we end up adding queue api, you'll have to call that
> > one over netlink also.
> 
> There is already a queue api, even though it's cropped IIUC.
> What kind of extra setup you have in mind?

I'm talking about allocating the queues. Currently the zc/devmem setup is
a bit complicated, we need to partition the queues and rss+flow
steer into a subset of zerocopy ones. In the future we might add some apis
to request a new dedicated queue for the specific flow(s). That should
hopefully simplify the design (and make the cleanup of the queues more
robust if the application dies).

> > > > If we assume that at some point niov can be backed up by chunks larger
> > > > than PAGE_SIZE, the assumed workflow for devemem is:
> > > > 1. change rx-buf-len to 32K
> > > >     - this is needed only for devmem, but not for CPU RAM, but we'll have
> > > >       to refill the queues from the main memory anyway
> > > 
> > > Urgh, that's another reason why I prefer to just pass it through
> > > zcrx and not netlink. So maybe you can just pass the len to devmem
> > > on creation, and internally it sets up its queues with it.
> > 
> > But you still need to solve MAX_PAGE_ORDER/PAGE_ALLOC_COSTLY_ORDER I
> > think? We don't want the drivers to do PAGE_ALLOC_COSTLY_ORDER costly
> > allocation presumably?
> 
> #define PAGE_ALLOC_COSTLY_ORDER 3
> 
> It's "costly" for the page allocator and not a custom specially
> cooked memory providers. Nobody should care as long as the length
> applies to the given provider only. MAX_PAGE_ORDER also seems to
> be a page allocator thing.

By custom memory providers you mean page pool? Thinking about it more,
maybe it's fine as is as long as we have ndo_queue_cfg_validate that
enforces sensible ranges..

