Return-Path: <io-uring+bounces-1891-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B3F8C421A
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 15:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 33C8A1C210CC
	for <lists+io-uring@lfdr.de>; Mon, 13 May 2024 13:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE92152194;
	Mon, 13 May 2024 13:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ONF4g88H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA14A152192
	for <io-uring@vger.kernel.org>; Mon, 13 May 2024 13:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715607620; cv=none; b=dFO3jtLtslm+ZB4eKNYIHpgLBFaSshPtbn9dKBqpgZYmt3SJ3bRwu8+0oWe+muwnW4ez+oPd7YIGC0vn+WTnlKkrVkPILCCu8yMtTxlOV6Ne5YFTPKXlOE2L4C9Rhz2PYRxpCym5FmjYYE5X0N6PzWiox7GRiGy5A9jvW6tYSKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715607620; c=relaxed/simple;
	bh=hgWrDCPD4sIw8o3/I6JJkWkOzesFgOPVKZx5ttHMQ8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iBPBiO56u+kV/r5tcXSpNLFajpwTfx3JSgttOWgCghcwT7xJGa14vjQ/V25CWJzgIN16GigZ58csw9KyCwHARfpGhQI1PeB1qK1poWPF+R4E5kQdF+4VCCXg7QO/5mTqYQCGDGyMoyA6xVWurS/qZPyZrvIUrkHcQPfSJQb42ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ONF4g88H; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1ec4ef7d13aso2075205ad.3
        for <io-uring@vger.kernel.org>; Mon, 13 May 2024 06:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715607616; x=1716212416; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q+PW9WkzxsOaTLdxqWwlcohbdSrQPxlEF7ADRy3wMEo=;
        b=ONF4g88HuG4qN8XfoH4cSTcEs5ufaBFKSaKh3IkKKj78KlUh3ERuzdXrPDZm0api7n
         GtM4W8AaZt/za6l1YuCtMq0rcpIrKyepLRIUzGUms11c0gnNGUhLk9e3sBDcgSVQuABJ
         Jy09qmKiROrna3FwnD8cM9IEj+6GurNDWr4uISa72RDbXib/fW2ERyKz61FjXc/iLLg6
         V4CLbRQBv4gdPYzCmj6fnPni72ca0co7eJ03ADAoSqTzCL3kyJ71e+uTZ3ReHkKgGGxc
         mq2vaJ82Sf4TTpmTxe3DEs5KyXCw8TaysfW1uZ6tR+J2qWf5ohDJLez9WfuzvNr9digv
         MKZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715607616; x=1716212416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q+PW9WkzxsOaTLdxqWwlcohbdSrQPxlEF7ADRy3wMEo=;
        b=fwi+G0/HXwPkw7DMTiIjqyQubBXpc5QRk5JCrC0093Kwog3kGThUX8kUkKWIkvI0mB
         noclb1jCZyQC1PXREn3/ZUvJBKOTdXXLAlACEA59Y9ZJPRIc+qcj5YVqfiBtQ+jgJoWN
         DryUz3TKFszwgb8bT0F1VVMUDAHeWuS6YFb2yGiFUw6ctzr0iAcHzJRqZmZeetgYT5Wx
         3JG8z8c6LY7OgzGL+rgzpI0DC/DkRy3wBJEJCEVMSRdEd7RMbPPCk96uw1lUXu1Oeftb
         /r0e4pGrhf4/GfpGGCUPQ/LBNcNni1rw6UKWGFFwHuk/XMwqF0jK7Qc17mI9azVKuQC1
         cMUA==
X-Forwarded-Encrypted: i=1; AJvYcCVjGkhqNyYT6E+hD/op4QbY+VfWUOSDQQm9xtEJvX75/fmunz39hQhfpBQYj6wfwdlK6WbMm+8HdkHoyZhAzqF5Yok+/Ft9BgE=
X-Gm-Message-State: AOJu0YzoHtvUrv0CgaIMnpyCjOwUkIy2yPOW78MQeJivOPmdJkcEYSHT
	y2F+dc6xedBZNHuR0Kp67eDkKdCQkhXRHUN4hKzUI/+9PdCe0ItzADb5I49n4DVF2vdsdB05gm0
	w
X-Google-Smtp-Source: AGHT+IHKc8+Umkalvk1Detqw1fQ/H6ZePm2K3xnk+idTT6FZzdDpOUKmvIfF00pGubMtHA9PWiva4g==
X-Received: by 2002:a05:6a20:3ca9:b0:1af:aeb7:7a10 with SMTP id adf61e73a8af0-1afde07d850mr13347224637.1.1715607615991;
        Mon, 13 May 2024 06:40:15 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-6f4d2a664a6sm7712461b3a.39.2024.05.13.06.40.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 May 2024 06:40:15 -0700 (PDT)
Message-ID: <76621ef7-8d0a-47d9-bc64-405f9277a336@kernel.dk>
Date: Mon, 13 May 2024 07:40:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/5] io_uring/rsrc: coalescing multi-hugepage
 registered buffers
To: Anuj gupta <anuj1072538@gmail.com>, Chenliang Li <cliang01.li@samsung.com>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, peiwei.li@samsung.com,
 joshi.k@samsung.com, kundan.kumar@samsung.com, gost.dev@samsung.com
References: <CGME20240513082306epcas5p2fd8ea6fd88b2c4ab1d17b1508fe2af97@epcas5p2.samsung.com>
 <20240513082300.515905-1-cliang01.li@samsung.com>
 <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACzX3At7k+kspDrzz-=HhFGHpcgi+O8S6D+fPND7imfiodHTOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/13/24 6:09 AM, Anuj gupta wrote:
> On Mon, May 13, 2024 at 1:59?PM Chenliang Li <cliang01.li@samsung.com> wrote:
>>
>> Registered buffers are stored and processed in the form of bvec array,
>> each bvec element typically points to a PAGE_SIZE page but can also work
>> with hugepages. Specifically, a buffer consisting of a hugepage is
>> coalesced to use only one hugepage bvec entry during registration.
>> This coalescing feature helps to save both the space and DMA-mapping time.
>>
>> However, currently the coalescing feature doesn't work for multi-hugepage
>> buffers. For a buffer with several 2M hugepages, we still split it into
>> thousands of 4K page bvec entries while in fact, we can just use a
>> handful of hugepage bvecs.
>>
>> This patch series enables coalescing registered buffers with more than
>> one hugepages. It optimizes the DMA-mapping time and saves memory for
>> these kind of buffers.
>>
>> Perf diff of 8M(4*2M) hugepage fixed buffer fio test:
>>
>> fio/t/io_uring -d64 -s32 -c32 -b8388608 -p0 -B1 -F0 -n1 -O1 -r10 \
>> -R1 /dev/nvme0n1
> 
> It seems you modified t/io_uring to allocate from hugepages. It would be nice
> to mention that part here.

Yes, please just send a separate series/patch for both liburing and fio.
This series should be strictly the kernel side changes required, then
reference/link the postings for the t/io_uring and liburing test case(s)
in the cover letter.

-- 
Jens Axboe


