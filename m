Return-Path: <io-uring+bounces-10392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4126BC3A814
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 12:18:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFFFC3BE7CD
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 11:15:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D75230CDB7;
	Thu,  6 Nov 2025 11:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ciaHEo2m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ED72F3C31
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 11:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762427728; cv=none; b=oJtlWXIolWfA3hthYXw7HxmFQnj9DPNi30asIX6fFYIU42t++a8AM8mp5oGjhT0hQVq0JQ+znsZA+4qwD2KQ0YclZ23eUCGYGq3Hq+jYCfcDQiMPvd9/VQhXzvWbmySQ21LIy5FQ7vCir20OIA93pszrhv0w4Syx373Av2Dtwfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762427728; c=relaxed/simple;
	bh=usdOJTkWaf+iTY0kMRtBh88Fp3x7MBRGg9VKG1CN5wE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U3e9/sJdzgb628s3rtAQFCxeFDgozW906559VgR5/x84C0mApSf966YvTBKLkqyuEKzpY1EiiRFu10tmSfMgjK8yPIEhhPYQbrOOeJ/0aGF+c5inhGTPds91Cz/cacRB/Hkpk2gHerY7K5tPYLe6n8wNbxjp7Nf7l1C0E5kshyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ciaHEo2m; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4710a1f9e4cso6572355e9.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 03:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762427725; x=1763032525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UOTpMadguFj2Y/FLVtLbnTeNY134l04T53zoMxu74oA=;
        b=ciaHEo2mxWmFCvhLki9wwLupamaFaqFdunvyxvVdjb2sJsTOhFpcYBu788cQ6x7Y7o
         UYanrNrT9XubdxPOXcnWWpZhPdwcudQYa/GwikEUHRDy2NpqpO9vw5a8PSyGKBe+DHTF
         PDxEY1OQDGL49wsYsKiOACJjRk22ynYtxO3mA50sekqXHBO6OAY4gr0yOx0mB//sMcrT
         yoJJT51lHX0C9p+nkzHml0rsUZeB8oAJSsmVg0c9BydkizH4nAXeRRD36/rWAqHrNmiG
         Q2V0wtIivVvIp9Qm1vvhF6+VuNhuCUvgzzGV367rf1CAABzZsutOZspq+OfDF1QeATxz
         TMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427725; x=1763032525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UOTpMadguFj2Y/FLVtLbnTeNY134l04T53zoMxu74oA=;
        b=usocu71QQT6AeIL6QSFgein2kdIIt5qS3S4jicFydxTh4wwnfielFBwamxTL2nNZ3e
         pDaDEVfI1wT3u9LudkMTfpite4uiq3lZ9qC1r/vH6SV3kbQtYo5/7K8u4bTvREOEE7FB
         uJenuiM3KWJgVfwtf82oWzkLvgnWviJ4i3S6LAmbEWv8hq/13Vk9kvx0OpiQGyPzMgxK
         fn/vCqRhR2cj72/6PbCrVskCTTJoO/oBKZDHSyoUPt3yQBB4fDp7scQ1A5Ewng31ofPm
         a+oryQ+Id3Y1ebakF2z2E6GTz3Z+PQfbHhsT+105FwKl+bd88ofbuHCqi6Gm0YoPlFdA
         iRgA==
X-Forwarded-Encrypted: i=1; AJvYcCVqePchuVFxwt8/YVsDMwL1FcsmYhQGNmU5dY42SltbU/kSC5peA8LACPSs68QI9uUZWxnvA/uMRg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6LaODMNMRKSoVOwNgZXYERCTVRmaBsy1LQFjsyf+sLNGhP1Ha
	nK8CK0k0/D6ldjCnIj2l0H5wkvucn8joPw3+fC6qGj4Ev5TAPqzvP+Bt
X-Gm-Gg: ASbGncsXAqITV9ZabWwO7ihMSbsu0/gbEY1xoVts1a8Z4mUY970xmWMl1q+Hq20UtjX
	ZZNn8AtLFxjqPP9FaB2AEg4gFEgcbMU1Yh8g2Pwv6dVmtEo52QQPcPtFX3o91WEKWFbRvzDCykY
	UxAwLg/3UdYQqgg7lHctiA31kM6q7gekKjvacpp2MmBtnTtz7SD4AIuSZNNw6O0zRfkl4FKkVzM
	H1+ptKAAesI+sYM0N+K08yFZuwUQO+t8gUaMwPowEEtdUTwnm4Vc+TvYC5oySHNCeTFbs9RaKK5
	JhgxViKRKKJEc3yhdXG0/WidV3bipcscifC1TsHwJOdGGG8XhaatsJuI5cz905sfH59VIs6/UwC
	bZbs2UNlvfRHK7acZJYpypmGri1Kge0Is3xOx4jJMEYmmlYwEJ+/DQKnfcqgu696VSlWNQytYjq
	642wnrDCbve7eJ2Z6vewIdBj1+S/dBzDgWVoLGc71MAxOXNFAedBk=
X-Google-Smtp-Source: AGHT+IH7csHg9e2iXXdTBjcOpBCH//jMuxN8iBwlKTB+z7/Dgxz9Ynes+X14otLTGDAb8ZYdHjmmmA==
X-Received: by 2002:a05:600c:5291:b0:477:c71:1fc1 with SMTP id 5b1f17b1804b1-4775cdf76d3mr64956335e9.19.1762427725033;
        Thu, 06 Nov 2025 03:15:25 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477625c2fb8sm41038665e9.10.2025.11.06.03.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 03:15:24 -0800 (PST)
Message-ID: <60d48025-bc2f-48c7-9b01-f1462c2b5056@gmail.com>
Date: Thu, 6 Nov 2025 11:15:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/7] io_uring/memmap: remove unneeded io_ring_ctx arg
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
 <20251104224458.1683606-2-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251104224458.1683606-2-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/25 22:44, David Wei wrote:
> Remove io_ring_ctx arg from io_region_pin_pages() and
> io_region_allocate_pages() that isn't used.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


