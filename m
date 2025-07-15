Return-Path: <io-uring+bounces-8684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3109B0652B
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 19:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDCC13B0795
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 17:32:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03D296A8D2;
	Tue, 15 Jul 2025 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hy2SxxWD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B31F1D514B
	for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752600782; cv=none; b=k4WrFuZbirqTQSL6xTIJwRmSY3IfODDvgqhniIOZnFEtFtMHMCX3NvVF9ZLaGnLPTlcRXLbPHrLyuOJ14ATnqhvnh1A9qQJ/MKz3OxQM7FKCr+oH413SRq5a9U77MNY06uDLTj0v66fjL+hFEqYAQBdZbD+T+tz0dIH2yXtXK5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752600782; c=relaxed/simple;
	bh=5Wn+zoFUX3oPhVDs7+eQb1gCLbcJxzpIBYdam4jn5No=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=guRAqfHlHOyStwOs8ELqT4xqN3zRWELrNieJ3WAtVEQq7EbYMBlovjE7rbQ5rFBrhpIrB+oRbaUtVUn5wKYan9vn/KAfy0/s+r7fd5YeCKYCR6upQqWc3DSttGPz+y/8F84XejLAirFHBt2k3+6srMZ9s/aWcSi+EiVuIz9AOso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hy2SxxWD; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8797652b1f2so369474739f.1
        for <io-uring@vger.kernel.org>; Tue, 15 Jul 2025 10:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752600779; x=1753205579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p4rRGopLqR/fVjm2X0UGV9bTZHQvDX4/mVSd0umVqI0=;
        b=hy2SxxWD3YpmuXPp6/5XLveMHMj1khAp9Ui92/I2jftQKqdcebKMajQg//r29eD8FG
         dkaJ4uVE8bLx0FefdxSpalVt5U3kaoo244RGVO9wTtOA7VChtzviSZx1m6pcC+SXrGLV
         hZtZObdWQLeJ0pmOFv5MeFypVDABw4Zk1v1w+tjlzWBz4ZzLa3DTMcuOuuBqLtsfPoyZ
         RodqSJc7hDMAhUPb3HSspjMOLtADYTODB9Mvu39TXmhP8Wt+TQ5xgIf252kUMuYBKHiQ
         plnjgt6rTTSl+HedUsZMb5w2Wx+FOvcTy8H+DYMcQnwvQxvs/qnEfyZHE2idyxATpDIL
         wbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752600779; x=1753205579;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p4rRGopLqR/fVjm2X0UGV9bTZHQvDX4/mVSd0umVqI0=;
        b=iFPh88QVA2TsFYpAVCUuitFgDJLgKJmtVVJznaX5XElnfhjj07o4Ty9f9XA3GvjiNh
         8zCtOKKa9Cnbzwh0CkfoDK/AaROenRsBHHNx3VEsdzewBblCPGB4rv+314G7xRS6m1HA
         Ujt93Y+zqca22OWXqsHPr0RHgcEIfKv178LS9wPtxKMPh+3k3GdzdeXb5T/+RDgY8pWB
         AMTuoyfMQ5hoeWwkb6TdLm7Ldl4qP++b1IjNg43bBx5x0meryV00eDo3iw4IwSyBoElk
         568ziDsMO57RKKXto3KjSsGxS0UAbLKlRAHgoEbstLFIwLviqPzlNfD8y0hdByauRLL7
         pRJg==
X-Forwarded-Encrypted: i=1; AJvYcCVnvyeu3+uJzn2PjrInRHpF9SkUmRgjIlPg5FDCLKtg9rxjlKJhT2nRxzcRXXuPMneLWyrsQZwitg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKu+X0D6MvxpT74s7H3WU9f/U7WfQ8DBSgVOtf2oiEruN3ud/q
	e4RRWOPYJY6m3SNKYk8VD64JdtcielmqP5YrRG1neOGcLQRhojIFnsApCWIzohrIwoEE8xyb1lW
	k6qc+
X-Gm-Gg: ASbGncsrfyaypCzOQtubnb2jW+LaeRZey2kwrBul2JXUEytDMoBJSNBFKP1w37XQfXC
	i7+DiNG6ENWPXoznCXrH0aiY1ehsedyBN/nsGOKjEBVoPYFUr7lk/l4RdpezDNT+Xr6Im/nmb8n
	5jMX+noWZupL6vDwAIvLX6db4Y5rIGoQA+eGiGlsqys9KLTSALQWZ6nj2PvIwibPPPvO0h/1IH0
	U0h7sBtYtG2Dz1uhe2cIXzR15eAqdk/4tsSkYvWoC+r6dlptkeRzOGStfJPx+WQzVqc6euBfqHn
	GOcsaeC3RO7QxPBt93wG/7P8+NLU7lVoCsrHqOmknGGfpNkwmFN7znj79jDf0f2VViqekIcQXf6
	X6rS1Yak0+RPS7D7ayg==
X-Google-Smtp-Source: AGHT+IH6cT5lgqMxHxrzC219CzxgVkR9x1fL7B7TX34zTp5CLYezunKncj3JE8pNqruxAFjQTwujdg==
X-Received: by 2002:a05:6602:1508:b0:876:8790:6ac8 with SMTP id ca18e2360f4ac-879c0892410mr28539339f.1.1752600779013;
        Tue, 15 Jul 2025 10:32:59 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8796bc13994sm330219039f.25.2025.07.15.10.32.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 10:32:58 -0700 (PDT)
Message-ID: <c2cf0c2b-b5bd-476f-a5d2-b5305ed6c3d9@kernel.dk>
Date: Tue, 15 Jul 2025 11:32:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: Support multishot receive len cap
To: norman.maurer@googlemail.com, io-uring@vger.kernel.org
Cc: Norman Maurer <norman_maurer@apple.com>
References: <20250715140249.31186-1-norman_maurer@apple.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250715140249.31186-1-norman_maurer@apple.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/15/25 8:02 AM, norman.maurer@googlemail.com wrote:
> From: Norman Maurer <norman_maurer@apple.com>
> 
> At the moment its very hard to do fine grained backpressure when using
> multishot as the kernel might produce a lot of completions before the
> user has a chance to cancel a previous submitted multishot recv.
> 
> This change adds support to issue a multishot recv that is capped by a
> len, which means the kernel will only rearm until X amount of data is
> received. When the limit is reached the completion will signal to the
> user that a re-arm needs to happen manually by not setting the IORING_CQE_F_MORE
> flag.

I like this. Worth mentioning that there's already a test case for this
in liburing:

https://git.kernel.dk/cgit/liburing/tree/test/recv-mshot-fair.c

-- 
Jens Axboe

