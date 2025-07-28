Return-Path: <io-uring+bounces-8841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BE496B142E2
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 22:21:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BD977AF057
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 20:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A3A221FF51;
	Mon, 28 Jul 2025 20:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmRX01du"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AAE86338;
	Mon, 28 Jul 2025 20:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753734104; cv=none; b=Mt//sa/pSiiVEc0UJeLUflOXpnvI35W7Q83DA5OEybA0WFjkt9WLyq1SQvMDRopjwm1/2FELbLOFrpP4apbMBdJWRZGytgKKt97EP498NMUDEEiDAx1Fydmfb7tMFeQRS/gKJYWmvBqry5EEBVqzq1xu23YiSqMNfFmFCMtv27I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753734104; c=relaxed/simple;
	bh=l4AuZL6O61ueerR2ma2aBYt/pbVTkj+cAkJgKt5W5zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ouJSFxRDAvAnDFMEmBzP1Gb+9rm/4uGbUGF7crrqFN+wgVTMGbR/EoYIAk+yjhZ5oQ4vu/zRCxGzOCMlysV1Rp3wisU9J9eGzxxgQ7yUniMSEvbzUjtqjUOGDtJicB3NgBKzQkGT6209ARftoVLq+YjvKTwSdpSc7vuG+UCEjGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lmRX01du; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-31eb40b050bso1582435a91.0;
        Mon, 28 Jul 2025 13:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753734102; x=1754338902; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gxi1rRMyzKFFhBcMnN3BHcSVoVEhk7Werz3CzOGN/Dk=;
        b=lmRX01duCQo1wzcfq6OQR+uEibQodlxwpchXyvOZo4UchD5I5UQsfI5eIqKnmu1c+R
         Aya5p/S1mCh8VTNAfD77/sItSJ/VGWZPaPWAFIgH0ciIgNkEsvff9AykrJ8f+dxg+6iH
         luE36peClnUgwUMHIBgciEwM02MIBIQehuzDSB2NJoijxkA8oA8hd+EWqGB9i+AT2Oek
         cm9fjhDJg5q+UFRL74t1zu/ZTWo4nWZ5xJHMBYXXRA8/vFIvrqRvoP60Ck/p8xjPhuQN
         5ZaFPYpD2L2KwSlAKWQvOx8DH0GMWHF+N7d549p+1KaFUO3Kk/JC0jTP5QcLT+rdURET
         2Wyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753734102; x=1754338902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxi1rRMyzKFFhBcMnN3BHcSVoVEhk7Werz3CzOGN/Dk=;
        b=UBDnn6e7/RwTBTFzXecQNTJT3QvCj2T9Vonm+aVzhxfukeIZIQpgt0+VrBXw/m8HPJ
         eDMToxu0sXPHtjWmUd0QwuSUwXERmq4/aqWkQnmfUfWZqVzhj8j0vph1T4vugy0J8Uzb
         vZ8FA0Gc0BfDHLhPok35V/lZdJO4aDvzfdfpq7IWwhqG6M23C2cSWrvJ3ot/wqms8uWp
         a1j7QaR7UjvTVTfjwNbTpul0L5Tt4P0Kbf5k3fIbWAMTpT9UJ6fr2HsLEkDIrxVcG/wQ
         u1KXovTUFbMAUarT1hojUjn39ZJ8Ii0QNKwfysia4hmPEUbzJmAI603PuufZqRfQL7oE
         GuhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXN64gSI4D0Y6a8KrdlA8E8eSdhXZGNtdn6+9IB71OE1wcpu5/LxGVA/Mj5TBC+ntXCgwdwIKO4@vger.kernel.org, AJvYcCXhoiGOCydS1DZlPM522XOpcydKJWBRAVXz7mGZ+jc2GiReHqP6MEJvcX77CcZ47a9e8aWRKWF4pw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzt9bonVjkAvLVVF3J9UWHyn0xn48N8OrumKwJwEx+gnC4QDn6V
	X96k4ZGYpBlZoB2ACvjcN0zKLgDJ1WRYfvfedR5Og7Qy2eRKTng1I6g=
X-Gm-Gg: ASbGncuj6QxDkJdmirADzFFIYE4UIXixX1iZ+1g4SeNmfhUe5qamK/ficvxEOizd2aP
	iwI3bThgDnSTTlff9ePkNn1g/ai/VReIzdVGZl23qTdrA5lXuwzXL05ktlnMMO3/43PlHZLe/pw
	tn9vyYYWZkIBZcSlq+ydtwEAL5NhWjIW26yG96J0hTRAD1wMN0x8FWNC4uE1lQWKGl5sp3C8lJS
	CVDdYAXEubI2FW/JbBRR9jcHdCkyQ+RMsTbjlAp5bWeTbnQ5tcQkhwZTxaQ3aPdEQe1f6nYrgIF
	1kl2YoAk2NdtVSIiCCgYxRcf6vZ4XYDGou/bYKd9W8cPBgThTni1xFUJ5GdBZ0TpoRFKqxrXMHM
	0JbheBsjLVRHlMNdpkS9zBbp2nh+EHNYrygLgmWmGdXg/uwL88g0FfqF+GVGnOudXMb/FuA==
X-Google-Smtp-Source: AGHT+IGAiWAEDHcJbWRqkSIiS2LNZQn4nWaDpzERfrGvEEWG8uFI4XwtneZvDUhxQcLCiH861ToHtg==
X-Received: by 2002:a17:90b:35cb:b0:312:da0d:3d85 with SMTP id 98e67ed59e1d1-31e7773626amr18926121a91.6.1753734102023;
        Mon, 28 Jul 2025 13:21:42 -0700 (PDT)
Received: from localhost (c-73-158-218-242.hsd1.ca.comcast.net. [73.158.218.242])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-31e83598598sm6447907a91.39.2025.07.28.13.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:21:41 -0700 (PDT)
Date: Mon, 28 Jul 2025 13:21:41 -0700
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
Message-ID: <aIfb1Zd3CSAM14nX@mini-arch>
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch>
 <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>

On 07/28, Pavel Begunkov wrote:
> On 7/28/25 18:13, Stanislav Fomichev wrote:
> > On 07/28, Pavel Begunkov wrote:
> > > This series implements large rx buffer support for io_uring/zcrx on
> > > top of Jakub's queue configuration changes, but it can also be used
> > > by other memory providers. Large rx buffers can be drastically
> > > beneficial with high-end hw-gro enabled cards that can coalesce traffic
> > > into larger pages, reducing the number of frags traversing the network
> > > stack and resuling in larger contiguous chunks of data for the
> > > userspace. Benchamrks showed up to ~30% improvement in CPU util.
> > > 
> > > For example, for 200Gbit broadcom NIC, 4K vs 32K buffers, and napi and
> > > userspace pinned to the same CPU:
> > > 
> > > packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
> > > CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
> > >    0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
> > > packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
> > > CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
> > >    0    0.69    0.00    8.26   31.65    1.83   57.00    0.57
> > > 
> > > And for napi and userspace on different CPUs:
> > > 
> > > packets=10725082 (MB=1227388), rps=198285 (MB/s=22692)
> > > CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
> > >    0    0.10    0.00    0.50    0.00    0.50   74.50    24.40
> > >    1    4.51    0.00   44.33   47.22    2.08    1.85    0.00
> > > packets=14026235 (MB=1605175), rps=198388 (MB/s=22703)
> > > CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
> > >    0    0.10    0.00    0.70    0.00    1.00   43.78   54.42
> > >    1    1.09    0.00   31.95   62.91    1.42    2.63    0.00
> > > 
> > > Patch 19 allows to pass queue config from a memory provider. The
> > > zcrx changes are contained in a single patch as I already queued
> > > most of work making it size agnostic into my zcrx branch. The
> > > uAPI is simple and imperative, it'll use the exact value (if)
> > > specified by the user. In the future we might extend it to
> > > "choose the best size in a given range".
> > > 
> > > The rest (first 20) patches are from Jakub's series implementing
> > > per queue configuration. Quoting Jakub:
> > > 
> > > "... The direct motivation for the series is that zero-copy Rx queues would
> > > like to use larger Rx buffers. Most modern high-speed NICs support HW-GRO,
> > > and can coalesce payloads into pages much larger than than the MTU.
> > > Enabling larger buffers globally is a bit precarious as it exposes us
> > > to potentially very inefficient memory use. Also allocating large
> > > buffers may not be easy or cheap under load. Zero-copy queues service
> > > only select traffic and have pre-allocated memory so the concerns don't
> > > apply as much.
> > > 
> > > The per-queue config has to address 3 problems:
> > > - user API
> > > - driver API
> > > - memory provider API
> > > 
> > > For user API the main question is whether we expose the config via
> > > ethtool or netdev nl. I picked the latter - via queue GET/SET, rather
> > > than extending the ethtool RINGS_GET API. I worry slightly that queue
> > > GET/SET will turn in a monster like SETLINK. OTOH the only per-queue
> > > settings we have in ethtool which are not going via RINGS_SET is
> > > IRQ coalescing.
> > > 
> > > My goal for the driver API was to avoid complexity in the drivers.
> > > The queue management API has gained two ops, responsible for preparing
> > > configuration for a given queue, and validating whether the config
> > > is supported. The validating is used both for NIC-wide and per-queue
> > > changes. Queue alloc/start ops have a new "config" argument which
> > > contains the current config for a given queue (we use queue restart
> > > to apply per-queue settings). Outside of queue reset paths drivers
> > > can call netdev_queue_config() which returns the config for an arbitrary
> > > queue. Long story short I anticipate it to be used during ndo_open.
> > > 
> > > In the core I extended struct netdev_config with per queue settings.
> > > All in all this isn't too far from what was there in my "queue API
> > > prototype" a few years ago ..."
> > 
> > Supporting big buffers is the right direction, but I have the same
> > feedback:
> 
> Let me actually check the feedback for the queue config RFC...
> 
> it would be nice to fit a cohesive story for the devmem as well.
> 
> Only the last patch is zcrx specific, the rest is agnostic,
> devmem can absolutely reuse that. I don't think there are any
> issues wiring up devmem?

Right, but the patch number 2 exposes per-queue rx-buf-len which
I'm not sure is the right fit for devmem, see below. If all you
care is exposing it via io_uring, maybe don't expose it from netlink for
now? Although I'm not sure I understand why you're also passing
this per-queue value via io_uring. Can you not inherit it from the
queue config?

> > We should also aim for another use-case where we allocate page pool
> > chunks from the huge page(s),
> 
> Separate huge page pool is a bit beyond the scope of this series.
> 
> this should push the perf even more.
> 
> And not sure about "even more" is from, you can already
> register a huge page with zcrx, and this will allow to chunk
> them to 32K or so for hardware. Is it in terms of applicability
> or you have some perf optimisation ideas?

What I'm looking for is a generic system-wide solution where we can
set up the host to use huge pages to back all (even non-zc) networking queues.
Not necessary needed, but might be an option to try.

> > We need some way to express these things from the UAPI point of view.
> 
> Can you elaborate?
> 
> > Flipping the rx-buf-len value seems too fragile - there needs to be
> > something to request 32K chunks only for devmem case, not for the (default)
> > CPU memory. And the queues should go back to default 4K pages when the dmabuf
> > is detached from the queue.
> 
> That's what the per-queue config is solving. It's not default, zcrx
> configures it only for the specific queue it allocated, and the value
> is cleared on restart in netdev_rx_queue_restart(), if not even too
> aggressively. Maybe I should just stash it into mp_params to make
> sure it's not cleared if a provider is still attached on a spurious
> restart.

If we assume that at some point niov can be backed up by chunks larger
than PAGE_SIZE, the assumed workflow for devemem is:
1. change rx-buf-len to 32K
  - this is needed only for devmem, but not for CPU RAM, but we'll have
    to refill the queues from the main memory anyway
  - there is also a question on whether we need to do anything about
    MAX_PAGE_ORDER/PAGE_ALLOC_COSTLY_ORDER - do we just let the driver
    allocations fail?
2. attach dmabuf to the queue to refill from dmabuf sgt, essentially wasting
   all the effort on (1)
3. on detach, something needs to also not forget to reset the rx-buf-len
  back to PAGE_SIZE

I was hoping that maybe we can bind rx-buf-len to dmabuf for devmem,
that should avoid all that useless refill from the main memory with
large chunks. But I'm not sure it's the right way to go either.

