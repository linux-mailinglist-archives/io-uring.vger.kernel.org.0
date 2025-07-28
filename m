Return-Path: <io-uring+bounces-8835-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 924C1B1410A
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 19:13:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A78B518C25C9
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 17:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D38274B52;
	Mon, 28 Jul 2025 17:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGIfXFZ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8078D1C862C;
	Mon, 28 Jul 2025 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753722819; cv=none; b=OAzlXK3K6fln2Y2eXvJDpC7FnQ0+762lKLBZHGNBnWQZH3pF+80/nT/Q8xN8LQFGQ2Uc+d2cMcsNps1fsDuWH3rg/VsJuhsLD7x7yQWxVRQ3+oIsayydqIPpXDArraPy9kGxTFQLtbC8DVmFIHASi6HHMpnS7eWnrlwzZLZ0owQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753722819; c=relaxed/simple;
	bh=HzRZ99e/VSa2+YLlUnamobTr1FOy7JSafnoQ80kiM9s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DrO78XvdlTbN0wGVevTb58GGKE3cB9+L7hQzgAmfChjzJfkrLmVkRfa5Oa/cLJySBOdj4rpODukYKO81owsm5s2iFuz6eHxGXTZxeiqHATZBh8YEukwXI/XDSoe92tCrO4aGiCMzGEm9mBnW4YtiK5b2Xahq18lfeUKnl4fIpuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGIfXFZ1; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24009eeb2a7so12330165ad.0;
        Mon, 28 Jul 2025 10:13:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753722817; x=1754327617; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ThRqSvHlUQ3qm8Em1xYonul0QAneRzrIjlr+qcVP/5g=;
        b=kGIfXFZ18Udw6qxEFCy2E8hbrLVvppJRqT2s41soGcLocsYcO++sk8vs7k2yTz6Wm0
         yIUsM+gpIF5JEK1s/g8KxTkGkrnZbKiMpHxHYSkmcq6fFQ/QDFJjMxiL/IVu91ENtuax
         6gVwbcj51VqpGiVpCPwaJydSysNWmL4sV5jCZLQTY7EK909fDEFihfghx/lspbbZZE5w
         H8fMHEKIGwrEcVpJMx0Fo9n4QW+UxWgkcs9EEVijvTzxFdP++n0XBMs1O01v3L48ykVZ
         5dMQqTt+OjK/BKjmXVXAZoxt0Irl03Y97LGbM13WFuwdzGtZgJgRFVOb0j1OYTTdiQh+
         ZLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753722817; x=1754327617;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ThRqSvHlUQ3qm8Em1xYonul0QAneRzrIjlr+qcVP/5g=;
        b=vlzj9B+asdYGhwUjRql5VkszCa2xqnqmimMqRONWrrqy8kwVg4NMn2MUmyaq1DO1km
         Ju5/KHWE+3G7ko1JYLwJLQE4jFJXiH87HW8tstBa7mueG6EQQ1DRvAc7e8ZBxLt5/D7n
         QvqEvvFQgeGT+y2MJFG7ou2hstW7Rf4qGLyiIxwcK0iXQTaMNNARxhToZ8tlLsGJNYdP
         CDqxJZnXQwaWvo3+1vYkXJ+J32oQMkWjItOwMdi5OzAu/zsNOaBHePB2hNRmNpYScQ3N
         basVipP1RQqceKh1/NxiCBdzT6qdaKgMVbhEsFc/WAF3XKtYQNJvAfd08zx7LQLaareK
         a/fg==
X-Forwarded-Encrypted: i=1; AJvYcCVTzhhEiR0rOPtx+7Fl/ic1NUtnGiS4i3c3U2nzdYMMZlZt2aNjsgIh+QkVRd5RY38CnHEvq//nFw==@vger.kernel.org, AJvYcCWmkfqXzruBuTeDuLUSoijwulT/xzE9OBmRegQDRNesATQbaHNAwCJF1Dt4t+v5Kwhcp8Z/S0Ho@vger.kernel.org
X-Gm-Message-State: AOJu0YwyYMgaZgz3haG1WNLhRrBuUMEfWK88cp2GXZ1Rrj0VV1lnmlv7
	ijFdBQQeLWX7nkvmyKCKJEMKto9DdglqJx15yOqQT2VaKI4LuJzXwWMGy7J6
X-Gm-Gg: ASbGncupS45HTyNy63wOwOpiTckia5zVTnzX2NjeshjUvMa5z+5bUIROVzYv7iN1Fur
	1AwjGhm5CPM6nQWm41bn9j3ZhLmGcxqvzLj7zF2LSIcv+XAvY4B+UCL+xsHzEXjlanh/Rgh0Ae1
	Yb5XUyYoumwe6mlmve9Nn8ROBa+eb4hW4ln7ehYiAhzXcElFIPGILvqtfn5z2iOzGVVSPvlmk6d
	CbbvZIp3bN6do9tzq9h6ek1bjiuiqiF8iKwFhua/XQYNCW4PgP27pAgb3tzAErERuzk4ubnwrV0
	Yl9YKjsGW4r9RcpN0aCjvhNKHmr2Up/ueSh1+RuhBqgH+AE3/VQS/Kkr/YKW8TwA3nq+hbCavNF
	fXknd6wF0l6tMAsKaU4s8Ua+InjtWL0OXGVp0P6UIY2DCddIeeRX5sYvHGag=
X-Google-Smtp-Source: AGHT+IFtQnfd1vJPyKxBUTqEU7Mo3iNydraXDK83XiWYjG4gUBn9YG8lRYV4srXBcsburlx2TIRUHA==
X-Received: by 2002:a17:903:1c5:b0:234:986c:66bf with SMTP id d9443c01a7336-23fb2fef327mr162387805ad.11.1753722816510;
        Mon, 28 Jul 2025 10:13:36 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-240355c4152sm22747485ad.114.2025.07.28.10.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 10:13:35 -0700 (PDT)
Date: Mon, 28 Jul 2025 10:13:34 -0700
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
Message-ID: <aIevvoYj7BcURD3F@mini-arch>
References: <cover.1753694913.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1753694913.git.asml.silence@gmail.com>

On 07/28, Pavel Begunkov wrote:
> This series implements large rx buffer support for io_uring/zcrx on
> top of Jakub's queue configuration changes, but it can also be used
> by other memory providers. Large rx buffers can be drastically
> beneficial with high-end hw-gro enabled cards that can coalesce traffic
> into larger pages, reducing the number of frags traversing the network
> stack and resuling in larger contiguous chunks of data for the
> userspace. Benchamrks showed up to ~30% improvement in CPU util.
> 
> For example, for 200Gbit broadcom NIC, 4K vs 32K buffers, and napi and
> userspace pinned to the same CPU:
> 
> packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>   0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
> packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>   0    0.69    0.00    8.26   31.65    1.83   57.00    0.57
> 
> And for napi and userspace on different CPUs:
> 
> packets=10725082 (MB=1227388), rps=198285 (MB/s=22692)
> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>   0    0.10    0.00    0.50    0.00    0.50   74.50    24.40
>   1    4.51    0.00   44.33   47.22    2.08    1.85    0.00
> packets=14026235 (MB=1605175), rps=198388 (MB/s=22703)
> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>   0    0.10    0.00    0.70    0.00    1.00   43.78   54.42
>   1    1.09    0.00   31.95   62.91    1.42    2.63    0.00
> 
> Patch 19 allows to pass queue config from a memory provider. The
> zcrx changes are contained in a single patch as I already queued
> most of work making it size agnostic into my zcrx branch. The
> uAPI is simple and imperative, it'll use the exact value (if)
> specified by the user. In the future we might extend it to
> "choose the best size in a given range".
> 
> The rest (first 20) patches are from Jakub's series implementing
> per queue configuration. Quoting Jakub:
> 
> "... The direct motivation for the series is that zero-copy Rx queues would
> like to use larger Rx buffers. Most modern high-speed NICs support HW-GRO,
> and can coalesce payloads into pages much larger than than the MTU.
> Enabling larger buffers globally is a bit precarious as it exposes us
> to potentially very inefficient memory use. Also allocating large
> buffers may not be easy or cheap under load. Zero-copy queues service
> only select traffic and have pre-allocated memory so the concerns don't
> apply as much.
> 
> The per-queue config has to address 3 problems:
> - user API
> - driver API
> - memory provider API
> 
> For user API the main question is whether we expose the config via
> ethtool or netdev nl. I picked the latter - via queue GET/SET, rather
> than extending the ethtool RINGS_GET API. I worry slightly that queue
> GET/SET will turn in a monster like SETLINK. OTOH the only per-queue
> settings we have in ethtool which are not going via RINGS_SET is
> IRQ coalescing.
> 
> My goal for the driver API was to avoid complexity in the drivers.
> The queue management API has gained two ops, responsible for preparing
> configuration for a given queue, and validating whether the config
> is supported. The validating is used both for NIC-wide and per-queue
> changes. Queue alloc/start ops have a new "config" argument which
> contains the current config for a given queue (we use queue restart
> to apply per-queue settings). Outside of queue reset paths drivers
> can call netdev_queue_config() which returns the config for an arbitrary
> queue. Long story short I anticipate it to be used during ndo_open.
> 
> In the core I extended struct netdev_config with per queue settings.
> All in all this isn't too far from what was there in my "queue API
> prototype" a few years ago ..."

Supporting big buffers is the right direction, but I have the same
feedback: it would be nice to fit a cohesive story for the devmem as well.
We should also aim for another use-case where we allocate page pool
chunks from the huge page(s), this should push the perf even more.

We need some way to express these things from the UAPI point of view.
Flipping the rx-buf-len value seems too fragile - there needs to be
something to request 32K chunks only for devmem case, not for the (default)
CPU memory. And the queues should go back to default 4K pages when the dmabuf
is detached from the queue.

