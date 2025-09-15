Return-Path: <io-uring+bounces-9798-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F6E7B585FA
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 22:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80EE218876E0
	for <lists+io-uring@lfdr.de>; Mon, 15 Sep 2025 20:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA111D618E;
	Mon, 15 Sep 2025 20:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="J6FvTk+/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6089275AE6
	for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 20:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757967614; cv=none; b=rpmM2F/IGwKi2w8o9RqB4YDEiB8YHHeRoems1ZYCbulQ2uqowmvq3VMM81e5IZZiTx0v528X1YhJkF/muIpzJwc5cNmrrYk1U/vV3F0RDON8LGLqF1vBW6cc4AdIpg6SRjprXC8J5TyYy3x/ULi3NoX6o7ULryWHOlNwhhPpZcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757967614; c=relaxed/simple;
	bh=9XaKAnL421IV6jFM81UmTgIXNlNNk4aZ80DICN3l4+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=AjOVu58dCZdaIQjgecpwLXJX7BR9LPPN0ci01CN8gf/dsmLpY6r0OxdAu0SrtxFGC4FLdq/9QO7FnB2SB0aFGMPTgBW9kAltklp/VTsNQ6oXAMTiKgeaQa+j5XQMsNdgX/leIh1RbggKTsLA+4qkvupEVFEBRXO2d5JS3y84rhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=J6FvTk+/; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32e2794c97eso1430299a91.1
        for <io-uring@vger.kernel.org>; Mon, 15 Sep 2025 13:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1757967612; x=1758572412; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lo5sgspXubdQVaiRP1ULZqOXYwj15MVaePW9NOhc+NY=;
        b=J6FvTk+/if5S1MK9j6f52VMI4x5ZlVRv9m9Up7d+J5XiECtn9VOnR0yBEV5/5rMzLl
         4liLAMY5g6vc4QJs+M0q21euBpMeXWtMSTF4pJSLjVs7jvKNZTD3/bXgARWkcKsAdp8U
         ITT9xzFAPp7nf4dg4a10s841PZAXTSzuMPWa27EGtpaCzElPfRyoNYvxvJKP9jBPWLJt
         CHggwB+Nsp4UNwLVfFM8Buy37Q/lWyB+u0XYQ5h444mRDVFCa945+P/2HDxDHTNx4X1u
         7YGuZvsrUQKx9ZRi4JFQxYWKlgVHMwUGrJAoTx7P6GsIB9n4dHItF+iVvTMDgcjUfphO
         ywWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757967612; x=1758572412;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lo5sgspXubdQVaiRP1ULZqOXYwj15MVaePW9NOhc+NY=;
        b=pZRxHr7nWLRzYhbG/KcfhsAln5fpcgq01IgQPnpz6KAp1QoKX1A+x11aT7fpfDyRok
         t/XKC8DYWL+yTyBWBzF0Lx0xcM0QelW2FwojYBp+g98jLpcQhafz7ARjUFqhsYsWVFAC
         6e6fo/7e7ByQyakXQ4CDD1vsJr17fb6Y2AM9jOQcgBCBPzec4ryuDIyoy4eHs78DI32p
         KbdcfoFduU992nYNC/3K92RqTKjPC36R+cqqN5HetGNKrom+Me/uczb6ZAXHTiLIpeaU
         8j4pRoD6tD1lbRwcfSqpIKVAFuBCHCEMPRKpA6s1NNJtHCnnf8iYXggLKhf7AdAHindl
         LSSQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpcjGdWQSGUQcftTFNTGxvy02XtVFp8B618A9H0c1fxT2OvPSaMf176JYvWaIK1ofZWFBN9Lmz+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzztOSAqxUE+9u6PF9bJcm5FRKEioJm3ImlDw0d0ngWsflbgq+d
	TejtZeBPOSQi6pciBgfcpgiR4+tqe06wcoyEsbtJ2tNbfFGL0JUadXAitMmTqM7gIwo=
X-Gm-Gg: ASbGncu+bTLrdF3k3F9BSR/BWzdd2fVkvJSiVKba73WIaw3IfbNMwjO/YfX80xRmoD1
	g/vm5MPOzyc/FpqQucXdAripPgtCvTyNMn+GzHMLBcIsNyYSeQuymvfhmbeMvinvNgjmsr2YX/A
	Ldxxl+Ora9pCVFDVyxsR2IGYzUt/8M27R6142ldgq7cgP3uRpCDqgaWq4y5Jnj9Xydt2/K6vJAQ
	m7OrU6P9VNUbDtkN+rMd/VneRYYQfNAxi5zLXr9gkToukC3j8Cx+tJXRNfScdCrNRWr0apNDgh4
	+6pCAnwLfSq8nUbhqfWo411AwH8qmQ8vHnIjN/WFYW7ESJj4qPK4+OWUKiSkAW2lDFq4TVeZiBN
	YUl4GKwkCVSHirBCMqQSLeMQ7TbCSjYK++QruklOz7sh5ApeJFWxGoMD0Ysk=
X-Google-Smtp-Source: AGHT+IHq3WWJt0/uIxbBUVjUP/FwvGd8tZbjSK9RdlAN2IL+XhQaIstyzGJbFxcL2f1AJus8NxGnTw==
X-Received: by 2002:a17:90b:5103:b0:329:e703:d00b with SMTP id 98e67ed59e1d1-32de50f8e8fmr16002531a91.19.1757967611955;
        Mon, 15 Sep 2025 13:20:11 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1156:1:ce1:3e76:c55d:88cf? ([2620:10d:c090:500::4:3a40])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32e346b842asm5721591a91.29.2025.09.15.13.20.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Sep 2025 13:20:11 -0700 (PDT)
Message-ID: <a0782edd-0987-492d-90b1-547485276398@davidwei.uk>
Date: Mon, 15 Sep 2025 13:20:10 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: How to use iouring zcrx with NIC teaming?
To: Chao Shi <chao.shi@alibaba-inc.com>, io-uring <io-uring@vger.kernel.org>
References: <efed6a43-6ba6-4093-adb8-d08e8e4d2352.chao.shi@alibaba-inc.com>
Content-Language: en-US
From: David Wei <dw@davidwei.uk>
In-Reply-To: <efed6a43-6ba6-4093-adb8-d08e8e4d2352.chao.shi@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-09-10 20:46, Chao Shi wrote:
> Hello,
> 
> I'm running into a issue when using iouring zcrx with NIC teaming.
> I'm glad if anyone can help.
> 
> I wrote a program that uses iouring-zcrx to receive TCP packets. The
> program works well when only a single net interface is up (by manually
> `ifconfig down` the other interface). The server uses Broadcom P2100G
> Dual-Port 100G NIC, and is configured link aggregation with teaming.
> Teaming works at L2, i.e. TCP packets (of single or multiple
> connections) may come from arbitrary port. I'm using kernel 6.16.4.

Hi Chao. I'm not familiar with NIC bonding. Can it be guaranteed that
packets belonging to a single connection (as defined by its 5-tuple)
always go to the same port?

> 
> To illustrate this issue, consider the belowing example:
> 
> The server program registered **two** zcrx IFQs (2 data buffers and 2
> refill rings), one for each NIC port. It accepts an incoming TCP
> connection.  The server receives packets from that connection, by
> submiting RECV_ZC sqes. Here comes the problem.  The field
> `zcrx_ifq_idx` of sqe is used to specify which IFQ will be used.
> However, which IFQ to use is not known before packets are received. If
> `zcrx_ifq_idx` specifies the wrong IFQ, the kernel will fallback to
> copying.  In a rare but possible situation, packets of a single TCP
> connection may received from both ports.

How can this be possible? Can this behaviour be disabled such that the
same 5-tuple is always hashed to the same port, and then hashed to the
same rx queue?

This sounds similar to a single NIC but multiple ifqs, one per rx queue,
in an RSS contxt. I use SO_INCOMING_NAPI_ID at connection accept time to
determine which ifq to process the socket on to avoid copy fallback.

> 
> I'm looking forward if anyone can help.  I'm new here, so correct me
> if I am wrong.

