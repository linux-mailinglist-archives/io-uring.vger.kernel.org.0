Return-Path: <io-uring+bounces-2384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 840E991C768
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 22:36:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D15C286612
	for <lists+io-uring@lfdr.de>; Fri, 28 Jun 2024 20:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842AB78274;
	Fri, 28 Jun 2024 20:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZdWNNS6Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB116F312
	for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 20:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719606956; cv=none; b=YHXR+rMWXDPUDaXFX3CwEfOoinXD+a0cB/Nfwsu8IDikbOAN1eYOLovKRxyyhMB7Bfnm8lGBQsTvgs5zpNw1yWgktcx64ZG43sVuShwP61P2L8y7taVGSO9DjBAjhQ0FWVSLxGlFp3Y1xJBrQA5vPch1qYVabfubR6rxThGtMs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719606956; c=relaxed/simple;
	bh=2nK2ZjmuMglhk0yaxdHKn3zTOaIl4xSOLewXX/lrfIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kdj7+7XVbgNuAqHKd0wvmZ2Wxr1Cu9GQLzTTeVVB8ieYuznEyukQDduBozi6gAMuFl6VwDd2OpexOwCxYG2Ewv1urSymgZhUM2N438bPgSV4IHVfRDzYPX+PR40q3vT1xom/ZrYYc3p7r937K5gjlCKDTe+4mn1Y5fCNKsj5n44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZdWNNS6Y; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-25cb5ee9d2dso193796fac.1
        for <io-uring@vger.kernel.org>; Fri, 28 Jun 2024 13:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1719606953; x=1720211753; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=knIuVjnXEJJ+j66MeUZ5fq37co54uOPBN7W+VUSdPRA=;
        b=ZdWNNS6Y4sWEegiSiVGc+tAC0AXgr2h5kIPlCVj2/VdKSAHWccBtYJ0RuCqz5arL+Q
         p6HNY6osXGaFmV/K5vybhFXfOapRAh+iiaMO1CXfJO+q92g5QNOUZfN4g4e9SP1W90PN
         CIbNVv2llJlmPJKBUGiGLnJfNqVmNO4tm2WMYdhMfsI9sjWSapkt6/iB3VrcZKlLK0Is
         zBi5lvOHH9EaL05V5J9ug7wqtVGhrqbsdkxWGs+bbaMeB3hVBuqXnK6zR9m5DV0+EbIZ
         1Kfo2pO+4xNkDvZnAtNcvTSR6nzWkZns1KLjAiYVEd+X2u3bjJhg+JbQrb5Feh5stQpp
         OJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719606953; x=1720211753;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=knIuVjnXEJJ+j66MeUZ5fq37co54uOPBN7W+VUSdPRA=;
        b=CkEtDymYihQrfIQriZDsNyta+j38ELqPjyVN1iuNurxfCVI8HL8hoNCKIpVRPRTBEz
         kS4OdzQe80RmHfLCjksG+bt+9gaV91N3/0KOE1WqiXhR5A3ddTwcMmwx8Qk1bal065IP
         UzlSUH+c2AaZmZ1YSSexjeq0vTgBMMjaqtDLGfEvqHYMDhSwSFehumGUmW85NX2lSvZL
         qA4CXwxUQBg3huIiXQN7rYIViTNPzPFWYDHRQLHrtHNv140c09ulPx+52/Lryt3VOtXO
         FzptJqxyUjI5i6KDdLes/Ky2HPGrD84QQb9nPx883Z8F9tX3rv3JahAzVW0wPMvj/L1G
         Rpdw==
X-Forwarded-Encrypted: i=1; AJvYcCUgqzmP7OEGDFr20ZHu8ulO337Bnp9FEOLk46OWGJTPc9u7C6J8i+XhIYRm6JLL0F3hKgterBdCodG3TMpnjq5juHyb7zL/Wn0=
X-Gm-Message-State: AOJu0YzVX7ijnPHibkCHDmd6USUbLPcswZ5NW0k+M53HgT3gQqjdThiU
	LQOlXq6u9xwQI65e2DOwjKDWa0Xzke8RnmP49AwgUcXBIEs/NvQeigjNIOSmqkQ=
X-Google-Smtp-Source: AGHT+IEb27cDCyXqmGni9JEqeFfVr+iPwZqfQQ0Azcu74e0UA/6M2OvYs4xelVHD0QGZqahyFDcDGA==
X-Received: by 2002:a05:6830:3d87:b0:700:ce5f:968c with SMTP id 46e09a7af769-700ce5f9712mr10578115a34.3.1719606953383;
        Fri, 28 Jun 2024 13:35:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-701f7a98f39sm438118a34.3.2024.06.28.13.35.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Jun 2024 13:35:52 -0700 (PDT)
Message-ID: <0d5d9177-8e3c-4ee2-8a77-8bcd59920118@kernel.dk>
Date: Fri, 28 Jun 2024 14:35:51 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/10] block: set bip_vcnt correctly
To: Christoph Hellwig <hch@lst.de>
Cc: Anuj Gupta <anuj20.g@samsung.com>, asml.silence@gmail.com,
 mpatocka@redhat.com, kbusch@kernel.org, martin.petersen@oracle.com,
 io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20240626100700.3629-1-anuj20.g@samsung.com>
 <CGME20240626101513epcas5p10b3f8470148abb10ce3edfb90814cd94@epcas5p1.samsung.com>
 <20240626100700.3629-3-anuj20.g@samsung.com> <20240628060444.GA26351@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240628060444.GA26351@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/28/24 12:04 AM, Christoph Hellwig wrote:
> Jens, can you pick this one up for 6.11?  We can't really trigger
> it as-is, but it would be good to get it out of the way and avoid
> someone else triggering the issue (e.g. Mikulas with his dm-integrity
> work).

Yeah done - worth noting that patch 1 in this series is already in
my tree as well.

-- 
Jens Axboe



