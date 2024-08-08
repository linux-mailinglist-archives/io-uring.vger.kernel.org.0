Return-Path: <io-uring+bounces-2684-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B91894C3FD
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 19:56:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5230F28132C
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 17:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D5E145B24;
	Thu,  8 Aug 2024 17:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UmzRWQv0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E38A12CDAE
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723139811; cv=none; b=AiYijRgAH5XhOa0AtGo3fXaw5KwLNdUPpUmB7YMvIu2aU1RCXhhLgsZ1ZIoBnvBcQI7500fu8jY81q+jHqwFWkQYhVElUXUHEKTFAJnhcHgOxbJUXeB9eDJpCnMOK7NcK21vAsbEWUpUsvmqDTsu4co3eHOgKnh1pRICrZogL3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723139811; c=relaxed/simple;
	bh=RXB/IZeHltAuSjnmYCbdMurH08GZGLkDZG89e7YwEhc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=CDyPNwfIsVBcO3wo5eojVppoSl7iRuh6XI7CFHzjtYsAQDtgQ/2eA5BuxKIEDZsMgIeQ/nlaDX9yMcj9JsmaMTSAFURtqEfCp7VpO+dODKENG0XrnMgIoOudu/jNOqrRJLw7SzlrYN9WvaMPTLHW/SHBFm7TtvEpbDWg1P37M88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UmzRWQv0; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-70d39a836ccso74719b3a.0
        for <io-uring@vger.kernel.org>; Thu, 08 Aug 2024 10:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723139805; x=1723744605; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A7v2HU4hvoPAzONTCKHa/ClJGoLdz/GjA2lZOw7N3e8=;
        b=UmzRWQv0pisbax41XNL2ZecydEUhDcUHguyeLDji4gd0xoyEBd+aWRSd1R71X/2yAH
         zOFNTapkoG4LINmRr5Qu4jDtmJTT8tVDIRfO2fxtsZ3jwfvlQrDvKRz9sq0aMXsu3yNh
         BqzV4DJDmbfyEd6oPmMgydoxU4QC74f0HgZEV+Jz9mI4T2ySu7t9nKKcNUN+RZZYLSzx
         Dr4GVu/Wyu7vFh1MWJodYPIrJVDabXqZcIxvqRJzZDnoj31o/9HHn9KIN6qWSRuNNSBP
         Ce7AIMCORG20vRiP5d19Q7ARWhMm55K8vzsj6EzUrQLxqRleXefH1Na4MbyH+VDgC9O8
         7/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723139805; x=1723744605;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A7v2HU4hvoPAzONTCKHa/ClJGoLdz/GjA2lZOw7N3e8=;
        b=Te7F4Xs6mij8gqASymgNZJgeddEVU0Vox6br/HKETyZRJcsnWnJyFwhWA+fML21ChO
         zO3j6Qrss4FcJaO3qUgSXNMAt1djcGcz6F+KfQWTXWvwLnOoIuVvz1rAz70RCyW645Kx
         LynWNEVogjlWygLcT43JLAMk6Vpj9n7WN5OOiJGtQBmNs4q4PmjKyBfx9HCniFyNrbfv
         JxLsebXRWiJ/4EIHtA6U6o5BwQjUs3xJJNn+WRATum1fDOX2mNcZp6LDn8GMrgIaFq2t
         RDmIwcsjJmKJPfEvW4hmWra908DlQQ6nzI7iN2rAemhMUNnCv8C49cNwsqwCrrQ/5k+P
         QHtA==
X-Gm-Message-State: AOJu0YzsU/y03EfHGUXwiiD8Ow9ACeULt43wu+h4YdPcyNavfaa4NGIw
	ogCDT2cyVbCS1h8bNFuPd8Tfs87ots54SKHmjow7sL8A/Fcx7w/bZbad8Utaf+dyMtzSRvUuQ4/
	h
X-Google-Smtp-Source: AGHT+IFtehP3ipYHwUS6rHzUWooM+p+Hll8FnUOIuJlykZiI25aUBx8ZqZZA78gqRab6JaFfMkR5VA==
X-Received: by 2002:a05:6a21:9985:b0:1c4:dba6:9eff with SMTP id adf61e73a8af0-1c8933257c1mr362426637.1.1723139804915;
        Thu, 08 Aug 2024 10:56:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7b762e9c066sm8451302a12.13.2024.08.08.10.56.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Aug 2024 10:56:44 -0700 (PDT)
Message-ID: <9c4ddf3f-089a-4517-b084-c63997b56657@kernel.dk>
Date: Thu, 8 Aug 2024 11:56:43 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/net: allow opportunistic initial bundle recv
From: Jens Axboe <axboe@kernel.dk>
To: io-uring <io-uring@vger.kernel.org>
References: <5fa6fc2f-b39f-4327-a195-61997d36b0e8@kernel.dk>
Content-Language: en-US
In-Reply-To: <5fa6fc2f-b39f-4327-a195-61997d36b0e8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/6/24 11:49 AM, Jens Axboe wrote:
> For bundles, the initial recv operation is always just a single buffer,
> as we don't yet know how much data is available in the socket. However,
> this can lead to a somewhat imbalanced string of receives, where the
> first recv gets a single buffer and the second gets a bunch.
> 
> Allow the initial peek operation to get up to 4 buffers, taking
> advantage of the fact that there may be more data available, rather
> than just doing a single buffer. This has been shown to work well across
> a variety of recv workloads, as it's still cheap enough to do, while
> ensuring that we do get to amortize the cost of traversing the network
> stack and socket operations.

FWIW, I dropped this one. Don't think it's clear cut enough.

-- 
Jens Axboe



