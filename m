Return-Path: <io-uring+bounces-2627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 18647943941
	for <lists+io-uring@lfdr.de>; Thu,  1 Aug 2024 01:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B77B31F22B6A
	for <lists+io-uring@lfdr.de>; Wed, 31 Jul 2024 23:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE29816DC3F;
	Wed, 31 Jul 2024 23:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jEVAJVOO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3429C16DC31
	for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 23:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722467560; cv=none; b=K/CTBZvj7+6MpWaqGlrr8LsKnY1lE2c3b+N4qMEfQqW9xdoACH5xRIupLWJ+vac0hP8TCwqCeAAjYVh/b1skXkJ6+tObrpMJV4gEhY/r6bW6y5cM+4+xHsugiKNf8jJdOs8f/cIjqXbu3VCkPV01lJCjuwZ16a/ZKKQEwd2opUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722467560; c=relaxed/simple;
	bh=+b5FKwRyKcoQDLHLplcPc2abjR7YuDO+xdig04hRJzs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QEzj+AeV5cb4+Dspj2uLccG39XXzS0u1HJMllSrdjRCYGfDXNfGvpuu6inFuyj0WNhuaJ1cCC2wBiPFwrB1SLc5RZexWbJEWVmnu9+kBODMyBlwwOqILnd4M7A9ehWW5yCw1oj3iF8lfBiLyIXksg4EiKfQUuapEFonnFa/+wT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jEVAJVOO; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a7a8e73b29cso519457566b.3
        for <io-uring@vger.kernel.org>; Wed, 31 Jul 2024 16:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722467557; x=1723072357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l7Ujxn6a9i7nfZSI0EbXAwQJP046tm0fW+Sb1JxMgqs=;
        b=jEVAJVOOO3datkNpQXB9BuqAG7arxB9VH4V4gyJ7o8pvs4CLsg0Z1A2YLSI/sKpiXL
         mHCH7xyj9duAouFohmjc4pBuAgClS9bRf/iw+I7IPkpij1FidaRNdZa7XXpg5mOewqjm
         Hh7ahrrbioRv+8SoZ7NYYefwkB+/CBfyPP5rp6xFZJKOEOcpY7r2q0/0zfgkbWvv197o
         bAxAPFzn0HdhmcvuBqilBUo700xuGqPeBo1VddOB+s/WluWSs4XjU4LhJTLpYyWLrbfK
         JG4TVPwwb33UvaUtRiQS14IOv+qey9w2JsI2ikw5tfUWQy5sRSfhHQYPTOlJ9O0gYazp
         iZyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722467557; x=1723072357;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7Ujxn6a9i7nfZSI0EbXAwQJP046tm0fW+Sb1JxMgqs=;
        b=wIsUYMVe0gdeauo+Rsmen/psQSdzCiFPMslBBjA8Hkh0Y+OZngQctqvZO14USlvnFY
         FX40icTUiuv5wVUxApsqmsN65d4NyTL0ZSxi5Z2JbHmcA2gsgwGTXZvXXFTeCEN4MgwZ
         RnAOp3nZzy8HJE3Lh5MZdZ9NaOkDkCDcHs/SPsXGKyF/Xx0dOHTMC5jD5Dg04eV7wKe7
         YHH7d/PZylTPRUN4ay6x/0uzmxf6MdREAaQVrZfvaiurOoXF774a1LpZau725wflUxm2
         fDCfUq5DLiQXjjuf2f/qgOjOsbWBJHGUqVrf8jwXV2o9DPEfNbR1L1LLSMJl0y7yCkwI
         d2XA==
X-Gm-Message-State: AOJu0YyBCNouX2AvSQzqB6P4txOA/w8rjCcYP1y41yAjGpYhpW1GceMD
	ghbZvSX/hQZzctkhT2ManVMDmus8pYjm4mBIeYhk9dWxlQOSOMUu
X-Google-Smtp-Source: AGHT+IF4vaSVA3bBaEUMcxhvpxWBqDo1f/6BuqOsVitjXAfwJVewY0AIW7Wd5J+e/XpjV9NavXCFgA==
X-Received: by 2002:a17:907:9488:b0:a77:e55a:9e8c with SMTP id a640c23a62f3a-a7daf65a041mr43786466b.47.1722467557057;
        Wed, 31 Jul 2024 16:12:37 -0700 (PDT)
Received: from [192.168.42.198] ([148.252.147.239])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7acadb8044sm814989666b.198.2024.07.31.16.12.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jul 2024 16:12:36 -0700 (PDT)
Message-ID: <2b0e7ae1-ac02-4661-b362-8229cc68abb8@gmail.com>
Date: Thu, 1 Aug 2024 00:13:10 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v3] test: add test cases for hugepage registered
 buffers
To: Chenliang Li <cliang01.li@samsung.com>, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, peiwei.li@samsung.com, joshi.k@samsung.com,
 kundan.kumar@samsung.com, anuj20.g@samsung.com, gost.dev@samsung.com
References: <CGME20240531052031epcas5p3730deb2a19b401e1f772be633b4c6288@epcas5p3.samsung.com>
 <20240531052023.1446914-1-cliang01.li@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240531052023.1446914-1-cliang01.li@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/31/24 06:20, Chenliang Li wrote:
> Add a test file for hugepage registered buffers, to make sure the
> fixed buffer coalescing feature works safe and soundly.
> 
> Testcases include read/write with single/multiple/unaligned/non-2MB
> hugepage fixed buffers, and also a should-not coalesce case where
> buffer is a mixture of different size'd pages.

lgtm, would be even better if you can add another patch
testing adding a small buffer on the left size of a hugepage,
i.e. like mmap_mixutre() but the small buffer is on the other
side.

-- 
Pavel Begunkov

