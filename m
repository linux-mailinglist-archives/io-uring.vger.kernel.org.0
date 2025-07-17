Return-Path: <io-uring+bounces-8709-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF4E9B08FDE
	for <lists+io-uring@lfdr.de>; Thu, 17 Jul 2025 16:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 50587581636
	for <lists+io-uring@lfdr.de>; Thu, 17 Jul 2025 14:50:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A69C2F8C45;
	Thu, 17 Jul 2025 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jNUglk+n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A102F2F7D0B
	for <io-uring@vger.kernel.org>; Thu, 17 Jul 2025 14:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752763808; cv=none; b=WfOhmc9hNMNvX4PbufVid8CN5bs9YURxm1l5tr52mnA4IYFUqiyLayLkcQiDyTQL+O0zV/R48cXHmwtsTErZgwQesKjzpdlN2na4ervoLC1mfKw/St70XZ6YFuKBFa1W640f7sCztDgCoOzF1fN6CPMGPDAEu6GYG1oRn6MWKno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752763808; c=relaxed/simple;
	bh=5IVjB201Z9M1JrjnRRTGYI6g7gcFXQCY2rk0tBsCHGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=SgThRGptzkmW1v23ev9dBUHH6DDoCfmIR9QfTO8zGvOsn4qcMDFLr/oVCdt1mKrJVPadINbWm1SFYQI+hR8SyKg+SNs0+QUJL1PhxwsYqrVbssY3xdwq5C1HpKoWY43LocUDeh/xPUzugYJhrsEgpy3YVZH/Jf9qeost/k/Lie0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jNUglk+n; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3de252f75d7so8554545ab.3
        for <io-uring@vger.kernel.org>; Thu, 17 Jul 2025 07:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752763803; x=1753368603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CpBIweq0iD5LnrXWqctByL8uGzmcjIqlzYC72NvOVqQ=;
        b=jNUglk+n1tGzPr2YaBmdivjgQYcUPJrKE5FrqpSwzJ8mO98PpVzyklaICSG/4QeEUn
         FyNX4cafl8Zjj7lAVeeenffjEaR3h0mwkfrp2KICrYmKgoK4ygIjRNZjPkv0n7LTcp6X
         qIX0/DwXKOAhijAuhSuir4yAteMGZbZ/oMtHar092sEVNNvv4Efn4ar/AIQe5oeo3vy4
         3oI/8fmriBn9HFl/sEW8n0rTH7HljtNdGbEG2pWdwdLILo4DHuydxQoe+vmywKUhz0Iy
         YVx2u2pAEk/A/8LVx1rzwl198+OlWRHEQvuzx8vVmfnvOQaxkbTw/7s7KbDAOdOBs5Nn
         a6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752763803; x=1753368603;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CpBIweq0iD5LnrXWqctByL8uGzmcjIqlzYC72NvOVqQ=;
        b=BsgwVmKNY9FF6iOMBKM9wNkFvIZhAWpFsrl5R6wWflkxxkJv8t4k+c1L9FScE8Np/7
         lv3/X68mSDty+nrKK1MslyKO8xPs0uLX5uGn6RFPp4jiYGIfW5rCWcJC6/yi+3TFzlum
         gNYaf0BjD2n6l+EZOAElC/4yyXE3fmKZT+ZUN0gNaCxQjCYw8UjIDT+xbEc+TkfnXfkf
         Ltw0CxYaMRllsFnyHUt/48jtVBTAped+5ainyzqmJ8kee+JEuBbgSul4uFI9QZh/dz17
         7hE7gkG/HHU98fzzoQzT5voOcdS9tY+tMPfesB1lNAaL6g1AX89q0vJzngo5zU1GWpRv
         m7oQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDfntqHicxTzRyjK/XXDwY+ETBF0zk4hCCD6BgsY2ls6XqUif/9irI4I7QXk5TIt0TwVbnZJMRSw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyp9Tq5KJ894YqFGV9fpYBIqyvbuUUumAMXKRt1TLzj4I2OOdH1
	vvz47+2V0dKwKLVwPiFFzp3z74lx9t0A6WASye4Rs5n5+0pzcUnoESEYiFAtS+Mgobw=
X-Gm-Gg: ASbGncthHxqtzn7KjWptrYi4ff4keU8gAwvFAP3LVmbPVwegasReXPd08vF4wAtxNlQ
	7CC5OQevHkxVJPej/EV0o0FW+9tgjwQLP8gcQXGOPSfBX/FVkMv7/6t4Dzkgah0tEGoz0pDnRJ8
	fsqLN89v6OkeAoRAYE3cS6xxkFsy/aXd+hMotq0cc1VGR8+1ZsXZ3/wyXwr7wGqHXgNfczIWARp
	L1ufWHLWIOSu2IrzMSbAS+b4IBSs6CiX9ZncA+BTA6Qom8Kz8swJFu+bsAtfdq0zqzR0oh5zJl3
	u6SVUUn1pYPVpokVamPKLltDMCqWt/ipE3nIekE4PbToOdgAldlo5Wn7ZGzogj2FYeyEW03BpIJ
	yzpLs7iYv6Ser1H+JP4s=
X-Google-Smtp-Source: AGHT+IHtLbYFlyVOm/F+OnLZmEJAhgfTNwwhZKT2Wl+v/pteAXTPDXqnTMcRoU9m7xDgjJXxoWE01g==
X-Received: by 2002:a05:6e02:2709:b0:3e0:ec1e:18fe with SMTP id e9e14a558f8ab-3e282e85d2emr73976565ab.15.1752763803325;
        Thu, 17 Jul 2025 07:50:03 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e24623ece5sm52186195ab.58.2025.07.17.07.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jul 2025 07:50:02 -0700 (PDT)
Message-ID: <0b3afe88-f6b8-47b4-9e59-9b232653f6a1@kernel.dk>
Date: Thu, 17 Jul 2025 08:50:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Relationship between io-uring asynchronous idioms and mmap/LRU
 paging.
To: Steve <steve_iouring_list@shic.co.uk>, io-uring@vger.kernel.org
References: <a11e741c-458f-4343-8f68-28ecc151cb34@shic.co.uk>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <a11e741c-458f-4343-8f68-28ecc151cb34@shic.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/11/25 12:12 PM, Steve wrote:
> I hope my post is appropriate for this list. Relative to other recent
> posts on this list, my interests are high-level.

Certainly is.

> I want to develop efficient, scalable, low-latency, asynchronous
> services in user-space. I've dabbled with liburing in the context of
> an experimental service involving network request/responses.  For the
> purpose of this post, assume calculating responses, to requests,
> requires looking-up pages in a huge read-only file.  In order to reap
> all the performance benefits of io-uring, I know I should avoid
> blocking calls in my event loop.
> 
> If I were to use a multithreaded (c.f. asynchronous) paradigm... my
> strategy, to look-up pages, would have been to mmap
> <https://man7.org/linux/man-pages/man2/mmap.2.html> the huge file and
> rely upon the kernel LRU cache. Cache misses, relative to the memory
> mapped file will result in a page fault and a blocked thread. This
> could be OK, if cache-misses are rare events... but, while cache hits
> are expected to be frequent, I can't assume cache misses will be rare.
> 
> Options I have considered:
> 
>   1. Introduce a thread-pool, with task-request and task-response
>   queues... using tasks to de-couple reading requests from writing
>   responses... the strategy would be to avoid the io-uring event loop
>   thread interacting with the memory mapped file. Intuitively, this
>   seems cumbersome - compared with using a 'more asynchronous' idiom
>   to avoid having to depend upon multithreaded concurrency and thread
>   synchronisation.
> 
>   2. Implement an explicit application-layer page cache. Pages could
>   be retrieved, into explicitly allocated memory, asynchronously...
>   using io-uring read requests. I could suspend request/response
>   processing on any cache miss... then resume processing when the
>   io-uring completion queue informs that each page has been loaded.  A
>   C++20 coroutine, for example, could allow this asynchronous
>   suspension and resumption of calculation of responses to requests.
>   This approach seems to undermine resource-use cooperation between
>   processes. A single page on disk could end-up cached separately by
>   each process instance (inefficient) and there would be difficulties
>   efficiently managing appropriate sizes for application layer caches.
> 
> In an ideal world, I would like to fuse the benefits of mmap's
> kernel-managed cache, with the advantages of an io-uring asynchronous
> idiom.  I find myself wishing there were kernel-level APIs to:
> 
>   * Determine if a page, at a virtual address, is already cached in
>   RAM. [ Perhaps mincore()
>   <https://man7.org/linux/man-pages/man2/mincore.2.html> could be
>   adequate? ]
>   * Submit an asynchronous io-uring request with comparable (but
>   non-blocking) effect to a page-fault for the virtual address whose
>   page was not in core.
>   * Receive notification, on the io-uring completion queue, that an
>   requested page has now been cached.
> 
> If such facilities were to exist, I can imagine a process, using
> io-uring asynchronous idioms, that retains the memory management
> advantages associated with mmap... without introducing dependence upon
> threads.  I've not found any documentation to suggest that my imagined
> io-uring features exist.  Am I overlooking something? Are there plans
> to implement asynchronous features involving the kernel page-cache and
> io-uring scheduling?  Would io-uring experts consider option 1 a
> sensible, pragmatic, choice... in a circumstance where kernel-level
> caching of the mapped file seems desirable... or would a different
> approach be more appropriate?

Just a heads-up then I'm OOO for a bit, and since it looks like nobody
else has replied to this, I'll take a closer look when I'm back next
week.

-- 
Jens Axboe

