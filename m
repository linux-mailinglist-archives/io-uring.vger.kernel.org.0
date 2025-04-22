Return-Path: <io-uring+bounces-7606-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1BAA9634D
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 11:00:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDB973B55E0
	for <lists+io-uring@lfdr.de>; Tue, 22 Apr 2025 08:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF2125A642;
	Tue, 22 Apr 2025 08:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5KRqHpE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C924525A35D;
	Tue, 22 Apr 2025 08:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745311735; cv=none; b=Rj4mEK7fp9lYUF+1dbI3P0EBQYH3BMwr+Z7/U3NFo5w5VAWktm0DqVEGzlnoEE0wxlrLLv3ODP/GusChdf00s9AXEVSPZ7Qn2Fr1n3RtZtzrV6KGWzhhKIH+N9CdSv+JUaKI3cfBEBOxYXgt0Xge5g2vD7AxQcfPhghbLyxPWIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745311735; c=relaxed/simple;
	bh=KW31rLdHieAVttWlXqZDlGqckJQkm/jxPincsbZfTWo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jLzMxKgwL+/WB7BpieahUF1cIMMpjdaFZ8J/jod1Q1skxg8puSC4zZiGdKlQKLaYpc7ZZp+uf93HX5al5dNszKNYObsMSaM4Jwj/T4GjVW4acDqnW2RYrGew09kg9LWWO5l5AotwGf9QPP1dtH5bUO8gwjVitgLSx445BfB7neY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5KRqHpE; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaecf50578eso708057266b.2;
        Tue, 22 Apr 2025 01:48:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745311732; x=1745916532; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vTcfchV0kSjCMkwTEVSbych5JRvggW47LDP0GDLHX5Q=;
        b=C5KRqHpEqlfldVpEj31nBC2elJbnepwzP5DG2rblY2bBkOyp1b3RCPwbCDwFFRLsKQ
         0FMvQIsXjuHeQYL1Y0n0DiE/85YfDGwWip/3o6u+OYAxUOzRI59uvrbUBCi70LiVW/nQ
         EqBOQ9FFwHTeBbUhlUOXJ/qViXNNFtNIjsMEhjXx7xKhdmPXX9BntmTQHwbLwpVz2IHo
         SM4AIn+MwvfjOGolRAZURVdeRR6L0XXYhIx1BvdADQzEAsopHB6LR/CztM0YQtdm60FU
         aIFF3G+jCeeS2n3RuCt/2mcZv0JMePjAriQHJoPKTh46I67kgL1tg9cU5LqPLJNz2APC
         5IAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745311732; x=1745916532;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vTcfchV0kSjCMkwTEVSbych5JRvggW47LDP0GDLHX5Q=;
        b=Ljy3GfFjRcEo7MObvEYiwX/SiCpWu50BfBsK2Pwi4UvnxO/O6OjMWLI7PhUvltpkYY
         FVGgn11fz7YcukYZT1w1RHhBax35JXl/RXArlqghAAKpBwZ7h5Uj1UVeuRiw8hdypPbl
         mm/2oCNKorK/DtEaKDnvvggVvvUVpdyyE7n7LACegvNoNKuNNK3LmBsdh2CLTDKdYBO/
         1E5Qweq7npYW4ij5XiCy+DJW9/yz/TQaPe99z3MaDIImYojsI/amlLtJP65LUqyx3Cc1
         cHXLGmv7gBN4xGeYPXizvjVQtl+vt8kkLqZ5sQvk3nXHQXgygASMqmMzH54k0M5Wgc6/
         Scgw==
X-Forwarded-Encrypted: i=1; AJvYcCVHcrOjR58oJsxQHy9XaADKXuSN9PhWohyDhAKjZIoOgX1SbYegajrQ08hfdzbxsiJyQt4vMO60pQ==@vger.kernel.org, AJvYcCXnB3xGpGLUxkehp3lZojLoweTY4A5YFoqifb+RSBGRZya/feATeTpF78j48URv2lD4/jNc0CnpiOLOkRBU@vger.kernel.org
X-Gm-Message-State: AOJu0YxePw4JyfM5jpB7NEn/z8Yu8oH60X3t6+Ne83/Z+7U8rVlE0chp
	S5yzCp+YGSv6Ab3p1qzp3wKXEc4yhQ2ur7zImVoBPuwBhk9OLxMDM26LHQ==
X-Gm-Gg: ASbGncslUjU0Euq/1rpl6Ym5u3yIfOnzMG/V8MNLRedSKkK1zZwQ+FMjgefDp5kqUQ6
	s85JUgeAiTfUXq9mlRTA7MHAdMzC0uQd2Q0d6kmLOwFaH++yNhhHtg1CPi3CkCx/Y7Bda30Fp73
	XkV1r52lA1xhvwbjasF/9V06ZNWipkiGsov26LSESK0vQgkUz2Y9Pm264E//+VHeNSBJ+8v6Naj
	D0n9He8T4MclIFrrPkqhyHGCzpYwpVrC/L0CZj7RxlTEzf6tpIOuOein3amJgsvHAOskP4QPjuc
	iLe1NvhygxujVBHZfn0uwG+Dw1iLCzCyUuS7HyRRHdaCbxzg9chRYlBI5URGvEJg
X-Google-Smtp-Source: AGHT+IFcTtHeMeBV+dwoYAtApkIuboT4/g2a+FGJCaGsgF3HZVk6q3qMVio+74045HzSHkwt+OSVew==
X-Received: by 2002:a17:907:1b2a:b0:ac3:8988:deda with SMTP id a640c23a62f3a-acb74d9be42mr1451284866b.40.1745311731878;
        Tue, 22 Apr 2025 01:48:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::158? ([2620:10d:c092:600::1:558d])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb9333d517sm449337566b.55.2025.04.22.01.48.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Apr 2025 01:48:51 -0700 (PDT)
Message-ID: <63319d5c-00c4-48da-8388-fe46cd2191a8@gmail.com>
Date: Tue, 22 Apr 2025 09:50:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: Add new functions to handle user fault
 scenarios
To: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Cc: axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250422030153.1166445-1-qq282012236@gmail.com>
 <1c141101-035f-4ff6-a260-f31dca39fdc8@gmail.com>
 <CANHzP_tebha40yy=8rqeu9DMqfrS-veF3=rp76H8udDvs69rfA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CANHzP_tebha40yy=8rqeu9DMqfrS-veF3=rp76H8udDvs69rfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/22/25 09:22, 姜智伟 wrote:
> On Tue, Apr 22, 2025 at 3:59 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 4/22/25 04:01, Zhiwei Jiang wrote:
>> ...
>>> I tracked the address that triggered the fault and the related function
>>> graph, as well as the wake-up side of the user fault, and discovered this
>>> : In the IOU worker, when fault in a user space page, this space is
>>> associated with a userfault but does not sleep. This is because during
>>> scheduling, the judgment in the IOU worker context leads to early return.
>>> Meanwhile, the listener on the userfaultfd user side never performs a COPY
>>> to respond, causing the page table entry to remain empty. However, due to
>>> the early return, it does not sleep and wait to be awakened as in a normal
>>> user fault, thus continuously faulting at the same address,so CPU loop.
>>>
>>> Therefore, I believe it is necessary to specifically handle user faults by
>>> setting a new flag to allow schedule function to continue in such cases,
>>> make sure the thread to sleep.Export the relevant functions and struct for
>>> user fault.
>>
>> That's an interesting scenario. Not looking deeper into it, I don't see
>> any callers to set_userfault_flag_for_ioworker(), and so there is no one
>> to set IO_WORKER_F_FAULT. Is there a second patch patch I lost?
>>
>> --
>> Pavel Begunkov
>>
> Sorry, the following changes haven't been submitted yet. I was planning
> to submit them separately, thinking they belong to two different subsystems.
> The other changes that haven't been submitted are as follows:

They should always come together, there is no way to review it
otherwise. Maintainers will decide how to apply patches best
when it's time for that.

-- 
Pavel Begunkov


