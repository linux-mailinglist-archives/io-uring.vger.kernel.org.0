Return-Path: <io-uring+bounces-7309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A38F4A76347
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 11:38:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04D8E3A7993
	for <lists+io-uring@lfdr.de>; Mon, 31 Mar 2025 09:38:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E8DF1DA61B;
	Mon, 31 Mar 2025 09:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WVrWTFqD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759F741760
	for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 09:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743413892; cv=none; b=RDsiailshhB6yC681QnmUEfOM7L9u0Cu8rK/wg5TkyMtkph4f0UvZTKvpJKypn9S7Z5yfvkUdMhNuRtaiV1RjVS7Y+H0X7VcpKVIYbpMv+FQZFWHJ6dbIBia3/Jt1LcD0Btxm6G/fIqcgaPrC22Nqd7GQ11Ofughvb/0k7V1dd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743413892; c=relaxed/simple;
	bh=jBY5x9dHPXScxQ/yDEPf25QlUqGYnrj9L+MuJKs57Uk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=b5KlGqvzX3qk9hUndP7E4FuRzM2RTt97N+bNQuxox3NpUh5qZl+hRzZMD1ip1rH67lVALFueM4YXSTI76XWeP7SErULHAj0c/u3H9QeVUbNZQB9fO9ZnCsojlvh8ktiG4K6Gt1vUuTKkTQZsYOiHT9WlYq9FhwNigLO7GL6YcvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WVrWTFqD; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3913b539aabso2389799f8f.2
        for <io-uring@vger.kernel.org>; Mon, 31 Mar 2025 02:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743413888; x=1744018688; darn=vger.kernel.org;
        h=thread-index:content-language:content-transfer-encoding
         :mime-version:message-id:date:subject:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9TGAL0kETTTwl/NhHEERxMNc/FGMholqHsEhYslYAag=;
        b=WVrWTFqDfA1l2GfRY3hhdzI6koTPBUVRLkktMGHFOid7mRvCX60YLkKDqE8OzEXC9M
         Kc5wKidYMmGxjq62U3FgoSPJMkCfUX5cLQ5MfQsEzJZ/Yciz+DDqV995Glg9gDHQ4YzU
         rti7Ht9BUK74kFxXLaXxz0dObJwmFBGIpfhjmrQ5VIpO5/Ko9KSaXVqdHEhQJPwonzyy
         7XwGMyoYaNkq6P7KIzBghHD+EZLspVxo0XM1k0/SU8r3Xarpd9LbErn5S+w/hQED6ePE
         lcGIYZqmJLAs2hg0pLZVxPmRonNn8ial/gmFtoK3xIYPY7dO1MljV/b1jsjlP0+vHQl6
         zjMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743413888; x=1744018688;
        h=thread-index:content-language:content-transfer-encoding
         :mime-version:message-id:date:subject:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9TGAL0kETTTwl/NhHEERxMNc/FGMholqHsEhYslYAag=;
        b=FESrTiODLkU2D8/Z0cwPtlegN1jmCDja9a4D06g1fdVihBEevRn7EBhWge/mYyNwSt
         LyfGvC6DFb7oswwnfqULZEYx4BHNYLLVGFebkzf/If0WVANWRZrq4/MF9LHz7j940fJA
         OkNiqgflDAeZE7vxF9qq1QcKeiyKfkE2kbw62gqufqR4mIAznHQHtmkH0/dgDGt5IHlE
         UAKdvx33y5Mv/p8Ui9+ylW1YrP8JP7VQlEv9T2wKAG9LTAFKs/HqTMFCVNMBvEwtE+tK
         uoIY8pd0NyULD9COGsUFzqGnjN66WrkyYerp1IO6TSm7b0NLWGGUJE/McLpw5wUQ5RNb
         5gCg==
X-Gm-Message-State: AOJu0Yw9iBp1yFWPWEvFn0b/CUbZxL2kGX4hke6ZTwYsIAk62Ty2iUzj
	iBcZIiasGVvIWjo19FVKknMq2Q12bds3ooifcDC2n9u7Mzfo6u2UXYhgGA==
X-Gm-Gg: ASbGncscas1dYdniR8yuFg8wDF2QRLy6ehQ/DJm75hGQqvIUdZveYlskp5ARhvpfRZV
	u5Noz39km7Uj0HlhVqWAmuz9goflKYebwF7GzV7rbncDs4hOA6Oznw0YdXK1hYkL5yoF1gmrO9v
	ew2UwxYLS+Wf6bPZPiAA+EhAdjKMtCTYfIw4a8c7O0eATGQJoXphkrKMIIcyn3qFH84UP9wnbLM
	W6P/z8iBLj/k/pRJ9fQvemug1a4ih7l6UEFQRb6ufvfTnnCe+PCr0E38IvPk94QbnGmBVIDc3NR
	F3MHOwzehNdBI874YqIWmDIpS2JcO1eLf5gKBrP6EF1Qz4Az/Z8+/xUX0zke/6uxEnPbNf4jy7Z
	QaPZnwwSrNqrV8OuQXOQwunv//YjAqif6oQ4/Ybtp/4QY8F0zEAsuYZgKl5HgSQbien0=
X-Google-Smtp-Source: AGHT+IHuDtjkDQCORULBz+HKLOPXF+zQcsb2H/rDJdTyao2aRvGL+lrtkO/gxAdCbR7Nd0V4OK4awg==
X-Received: by 2002:a5d:64e8:0:b0:39c:1257:c7a1 with SMTP id ffacd0b85a97d-39c1257c7c1mr6501225f8f.57.1743413887860;
        Mon, 31 Mar 2025 02:38:07 -0700 (PDT)
Received: from DESKTOP4MOFK1P (gill-18-b2-v4wan-170254-cust628.vm41.cable.virginm.net. [82.11.138.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66363fsm11141141f8f.36.2025.03.31.02.38.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 31 Mar 2025 02:38:07 -0700 (PDT)
From: <michael.yacc@gmail.com>
To: <io-uring@vger.kernel.org>
Subject: io_uring usage (ordering of commands)
Date: Mon, 31 Mar 2025 10:38:08 +0100
Message-ID: <027001dba220$9c8cadc0$d5a60940$@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: en-gb
Thread-Index: AduiIFQdl4D+ydybSpaCmhIbAUQSJQ==

Hi,

This is a newbie question about io_uring usage on Rocky 9.5 Kernel
5.14.0-503.22.1.e19_5.x86_64.

I want to use io_uring for UDP packet writing/reading to/from many
destinations/ports

If I understand the io_uring documentation correctly in the general case, if
I submit N different UDP write commands there is no guarantee they will
complete in the order submitted.
Is this true ?.

But, if I submit N * UDP write commands to the same file descriptor, ie same
destination and port, can I assume that they will complete in the order
submitted ?.

Thanks 

Michael



