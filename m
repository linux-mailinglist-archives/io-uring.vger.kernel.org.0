Return-Path: <io-uring+bounces-1874-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 08E2D8C328E
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 18:43:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5ADD282003
	for <lists+io-uring@lfdr.de>; Sat, 11 May 2024 16:43:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A13A7F;
	Sat, 11 May 2024 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0Lb0SYGh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02E11AAC4
	for <io-uring@vger.kernel.org>; Sat, 11 May 2024 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715445790; cv=none; b=DSH6ERqN+fOQa5gx2UYvM9AUncepK9bTAr0+wX8lZ1slV2nRWyMS06RhdJMnVhTrJKTM2HSv0TTfinuD1Inp0LfJpl8vw+7A6XVdvoqT+LD/Sxeu6cgxRz1XqRqaVc8mVWvGq/veiyrCXRCPDLyg9H1O9Y7CJC58PpgH/eqbFO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715445790; c=relaxed/simple;
	bh=Ylzz52QCMLLM270b9SllbzdV5RwAfNa6cGeLsqbaJKA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUh7wscBBHw+fSFFDTfq47NERrrcInce6f29gqJK07TU3GF+YvlMpXpbyxFbSOsZo7GL6Bj+JWqIUpflmIcaZlZnfu6MdZpxc8rH4AagF61HI6Wbr+mb7Eh7rLhgEjT2NiVd+w+sY/E2cTCRxBUjeclfivoPHXE5A/JXEFlWbcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0Lb0SYGh; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2b432ae7dabso790826a91.0
        for <io-uring@vger.kernel.org>; Sat, 11 May 2024 09:43:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715445786; x=1716050586; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jo26BfXCNtlaiJ4PgOC+Tx6hkcCtGpOk7lgmThHiteg=;
        b=0Lb0SYGhmma6GGICWgwE+fmmXMt2FB8RFg1kCgUN29vy/b/xQQBhoDRjD6UMad23vL
         JOTt22rKhTHnMYQ37UiXAvziuenHkq8ZDvlsmVLKYe/Gv1zqaXOxlxlXSM1XHw5TWc06
         EdDGDmBD43Dkk6AucoOsY/RWdnJN4CUNWaUhdOSc7YOphRBdX8K6efS43aZhxuYfvqc+
         TzSq2kQ62+P/5PBfz3IWV+IFZC2HNHe7i0AjAGMR8yUO9UqnnhofkQnfjdiFLRUOzHHW
         MvIPNqzmpHM0AJ/iEM5NKgCyuUmdiVFQykKgAiWPk+MIZiRtV0tEl9VNRgbugyoHZhd7
         Ywhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715445786; x=1716050586;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jo26BfXCNtlaiJ4PgOC+Tx6hkcCtGpOk7lgmThHiteg=;
        b=gB0UaskDE5bZrtHzGQegqRYukEg1z2ulM9w5/Bs6KO9egcCGIFnv5TRELr3Us171KN
         nYG5/tw3ctjKVtWJM8hMgSRNG9efNQBXSAqVh6ASnDEnGCMsp129solofcqfpbSB9UmV
         D2xSlJttQGgFFN7kKJUpZC3KZnSQKecLFqmOWr0xzd3AGzNW7E9kxl4Id2R82xmRNy5m
         QLKiKBOqpvXHWJygrXIjBbOPOKbDn7LYltBaEO8bfXDCs870ZMk0aEOPiSdEHZdq7y54
         9j25NT7JEva+7tcuYhBE3bqfpW0CoV2yQf28fcZu9O8GxETn39MXvk9EuivuoRjNhhqL
         YZDw==
X-Gm-Message-State: AOJu0Yxt91v9/P4Jw6NfzKgqaa9DjYxWa3fULhknEKaqmI+nY/8mKn6N
	7kp5LxVkOCx0JPHYi99HBLWnUVJHiBE5b82thuCcTphPaERXqm1dmN2SPBlxJAY=
X-Google-Smtp-Source: AGHT+IFa42xhRFvwsrz0AVmF94Yt9vmc83wkBmzQXmAT5iennbTThqiVVCbt057bK7WNfb+PlFynrQ==
X-Received: by 2002:a05:6a21:6da1:b0:1af:a4a5:a26a with SMTP id adf61e73a8af0-1afde0b59e5mr6287827637.1.1715445785818;
        Sat, 11 May 2024 09:43:05 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b67158c36dsm5043716a91.38.2024.05.11.09.43.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 May 2024 09:43:05 -0700 (PDT)
Message-ID: <0fa012c7-427c-4791-95be-7ba72cfe593a@kernel.dk>
Date: Sat, 11 May 2024 10:43:04 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Chenliang Li <cliang01.li@samsung.com>, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, gost.dev@samsung.com
References: <CGME20240511055242epcas5p46612dde17997c140232207540e789a2e@epcas5p4.samsung.com>
 <20240511055229.352481-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240511055229.352481-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/10/24 11:52 PM, Chenliang Li wrote:
> Registered buffers are stored and processed in the form of bvec array,
> each bvec element typically points to a PAGE_SIZE page but can also work
> with hugepages. Specifically, a buffer consisting of a hugepage is
> coalesced to use only one hugepage bvec entry during registration.
> This coalescing feature helps to save both the space and DMA-mapping time.
> 
> However, currently the coalescing feature doesn't work for multi-hugepage
> buffers. For a buffer with several 2M hugepages, we still split it into
> thousands of 4K page bvec entries while in fact, we can just use a
> handful of hugepage bvecs.
> 
> This patch series enables coalescing registered buffers with more than
> one hugepages. It optimizes the DMA-mapping time and saves memory for
> these kind of buffers.

This series looks much better. Do you have a stand-alone test case
for this? We should have that in liburing. Then we can also augment it
with edge cases to ensure this is all safe and sound.

-- 
Jens Axboe



