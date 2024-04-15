Return-Path: <io-uring+bounces-1561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 008AC8A5A46
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 21:02:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23BD91C22039
	for <lists+io-uring@lfdr.de>; Mon, 15 Apr 2024 19:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55D03155734;
	Mon, 15 Apr 2024 19:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hi4jF++g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD56A69DE4;
	Mon, 15 Apr 2024 19:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713207746; cv=none; b=S3A3bZUYT7vcjjq/pweRsufpqxGvSw937qwkYhiqVxDO3a3sDoMyIW3uA03hmQ8gzBx9MDA8V4/pPESMgCfZFdsGPycSgSPGFzjsjt4ZXItqAjonpd6zFtUHsysJtS6tOSrpYZWzpm1AZpRVQiF/4BoO5RCkbzqGE8+rWjMqM7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713207746; c=relaxed/simple;
	bh=igCRGSTpsTcjSC7RMwyaZ+Z3d9OSXggjb5arvKLkauI=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 Mime-Version:Content-Type; b=qYD0SfYxBz+hvGBF/Y5aSSJoJn4TYE1WcIjRgA/QNhNszufYr5SpCfkYr67wdh/zNF29duIEcBMQ8xtxv/dsM+v4QB3/yRmnsz2KYWQGdZD3sO9wmjaenw5xJObxdb4a/kCkyBY2XaABiHFHGcd0XCPKN/seycKIGkDl1FOMGRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hi4jF++g; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-78d57bd5781so262234585a.3;
        Mon, 15 Apr 2024 12:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713207744; x=1713812544; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jh9eAFpBFglJQ/VypV4zpTSuEubiumfcebuJxnXU6uk=;
        b=hi4jF++g2p3VuZVw9J+YUxPWldMLHFfwx2MqiV+mbBa3WzN/erkQMt/+J2Pngew6RV
         marxr4KLrXROYwKgzR/J8sWapswAONKopuOyp7u3oSE6cXg/vUggx6SbqncddleuhcyT
         I4mEFILlzZ52fBCjjh7G/0NsD6g3SACu4Jd8zpjNdyx69UhLnQK1LzYYcsB8Y+5CG6ZT
         MmxPZ23J18D5Nan9ZVkEFRullfiiL/duQGRacDNu+e8PbhWvrLLRDFuto3ZS1H02gLF5
         x0nEjUZkAlNOnUThJ6Kfu4u4JMPPB8WM11Pgkr+cEdkjzaosyByoaMFVQyBDgBLQEtGw
         Roig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713207744; x=1713812544;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Jh9eAFpBFglJQ/VypV4zpTSuEubiumfcebuJxnXU6uk=;
        b=OMAJtf+/QED1gCvLpCM6rxzg8XWy8taFEHS0jxBUKpA0DoE4AD5wrTq86Xfkmr07gX
         eBd9oFAYCcpRiLfZ1AXal90O5zQ1fzw3Zb1m4CgJCg9QwvK8fpcIJ339IKVKgV4GFT5A
         fcbPMmoToFVVXAvn6KbL7h/PqJS4MSd0yUoJ0mlb4uCHflKp6LJ8xPcyTjMqODliDw+N
         HKKsoRrUzkusO11BZ3VV5VOIVqpBQ7hsR0wRWd0C9C+7mGvVd4gFl/Hkqg7dIEHOOnsg
         WNxO/gpkTtlm0boD4jRVzPloFft/Id9e87PPzOi8xfPDtWddqK1kQfu7oTOf5xyDHi3b
         wONg==
X-Forwarded-Encrypted: i=1; AJvYcCWCQQSIqIJruJcgzc1euj0MViDZIUb65UjTMklW0/tIJCEIcU9pNNJb91aEqJYKPQZ6Lh20UhRnR2qJ1yN6wQPMgp7O1HsMYgpuReb/U3AXz6zTbzQb8/Ln2ddJo6gsl+8=
X-Gm-Message-State: AOJu0YysdBajESnCJJL0qbuur5C9P+q4xncDqiHKG6xU1R8jH/QNJCV4
	yiB2eBvQxP4ewFAfQDLViTzEtM+1TgY01brqXMTE1r54546NjJ4c
X-Google-Smtp-Source: AGHT+IEYdlPe6Zw0TpI3Jgc0CjM1TmLcHkIejQof2uwndoiHyPhWSMRCJHrMPPlOHezBEEPEmGOyjQ==
X-Received: by 2002:a05:622a:15d2:b0:436:96be:20f with SMTP id d18-20020a05622a15d200b0043696be020fmr12822531qty.4.1713207743806;
        Mon, 15 Apr 2024 12:02:23 -0700 (PDT)
Received: from localhost (73.84.86.34.bc.googleusercontent.com. [34.86.84.73])
        by smtp.gmail.com with ESMTPSA id o22-20020ac85556000000b00434b1f4e371sm6343026qtr.13.2024.04.15.12.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 12:02:23 -0700 (PDT)
Date: Mon, 15 Apr 2024 15:02:23 -0400
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To: Pavel Begunkov <asml.silence@gmail.com>, 
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>, 
 io-uring@vger.kernel.org, 
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, 
 "David S . Miller" <davem@davemloft.net>, 
 Jakub Kicinski <kuba@kernel.org>, 
 David Ahern <dsahern@kernel.org>, 
 Eric Dumazet <edumazet@google.com>
Message-ID: <661d79bf3a774_2ce362948c@willemb.c.googlers.com.notmuch>
In-Reply-To: <3b06ebe5-509e-45d2-9a41-5f2af67a36a4@gmail.com>
References: <cover.1712923998.git.asml.silence@gmail.com>
 <3e2ef5f6d39c4631f5bae86b503a5397d6707563.1712923998.git.asml.silence@gmail.com>
 <661c0e083f05e_3e77322946e@willemb.c.googlers.com.notmuch>
 <e686d9ba-f5fc-48c7-9399-06fcbed6ebd5@gmail.com>
 <661d448142aa_1073d2943a@willemb.c.googlers.com.notmuch>
 <3b06ebe5-509e-45d2-9a41-5f2af67a36a4@gmail.com>
Subject: Re: [RFC 6/6] io_uring/notif: implement notification stacking
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit

> > 
> > Slight aside: we know that MSG_ZEROCOPY is quite inefficient for
> > small sends. Very rough rule of thumb is you need around 16KB or
> > larger sends for it to outperform regular copy. Part of that is the
> > memory pinning. The other part is the notification handling.
> > MSG_ERRQUEUE is expensive. I hope that io_uring cannot just match, but
> > improve on MSG_ZEROCOPY, especially for smaller packets.
> 
> I has some numbers left from this patchset benchmarking. Not too
> well suited to answer your question, but still gives an idea.
> Just a benchmark, single buffer, 100g broadcom NIC IIRC. All is
> io_uring based, -z<bool> switches copy vs zerocopy. Zero copy
> uses registered buffers, so no page pinning and page table
> traversal at runtime. 10s per run is not ideal, but was matching
> longer runs.
> 
> # 1200 bytes
> ./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s1200 -z0
> packets=15004160 (MB=17170), rps=1470996 (MB/s=1683)
> ./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s1200 -z1
> packets=10440224 (MB=11947), rps=1023551 (MB/s=1171)
> 
> # 4000 bytes
> ./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s4000 -z0
> packets=11742688 (MB=44794), rps=1151243 (MB/s=4391)
> ./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s4000 -z1
> packets=14144048 (MB=53955), rps=1386671 (MB/s=5289)
> 
> # 8000 bytes
> ./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s8000 -z0
> packets=6868976 (MB=52406), rps=673429 (MB/s=5137)
> ./send-zerocopy -4 tcp -D <ip> -t 10 -n 1 -l0 -b1 -d -s8000 -z1
> packets=10800784 (MB=82403), rps=1058900 (MB/s=8078)

Parity around 4K. That is very encouraging :)


