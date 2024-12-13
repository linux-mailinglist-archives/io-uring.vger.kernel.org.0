Return-Path: <io-uring+bounces-5487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EB0D9F1473
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 18:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7EAAA1882C51
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 17:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFFF187FFA;
	Fri, 13 Dec 2024 17:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JaUVwjLc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA8F1422D4
	for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 17:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734112649; cv=none; b=HR0f2F5nIq4B3pcHI1NXJ/jh3uXVyTP4IneLccAA/tuD64jNDyki8Em09b1Q/WxfR5Qf7fP84zh0cJv+/StLToAlLShL1mwar0C92+hnawvusyZETwK4YlQdBK4K7VPqkSnuQjiaK2TIFOXIWr2cVZSdo3NN2OnDLkanTdsH1vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734112649; c=relaxed/simple;
	bh=wGx9a+XabHmZFDRAuRV8PgVQitDLKUcZ+lbawg8rKF4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L2Hb+uXmsJ/XywHEb9KUBv1do6+2jUYXtDYIHzjjp10OztQq6JHBMFYPGMyuB3gzbgwKtpzclNtuxlaYF0lIgKKnpBdmS+I+ftzaMqgVPDeUO1BtmlKvIKOs0DSxHBvwSJ5Ct++m4CoNOPG66PstqthfVFi0wdx8uIvO01cUTr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JaUVwjLc; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844e9b8b0b9so77021839f.0
        for <io-uring@vger.kernel.org>; Fri, 13 Dec 2024 09:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734112646; x=1734717446; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NJ0MdihJSIQEq733ivWrCooxpbpOeLDD6hkL86wZ/mM=;
        b=JaUVwjLcph4eElxsvQg1rKpAfSdICB6lymIa6HnKFmXIhLnm7b09lnoLsNQlh9WZTi
         /Bl3zk8ezlt391BcLSKbD9gUY4Fwm1ix54rS2ApbMkK/aDrt65aBz2eII5wMjxj4c4+k
         swYe/PivVIafliS+U9CfoM7SQmq5jU5eRcwS12sWMHg04rxRuL3rzCjn73YeorpNCNA+
         4c0gZ8ksz5iCWGDdBLbYmNi+wP6RQ0XNcF1o5BXyOyqZ07SqrAq4hwKxD+TQC0viprv9
         uNBMaDInocysHwSyDC995QgrME2hdPevzPFNvOwt33Q/1fvLEX3F9LRUQDD5fdvQkLyA
         6KOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734112646; x=1734717446;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NJ0MdihJSIQEq733ivWrCooxpbpOeLDD6hkL86wZ/mM=;
        b=dSwvgYhZPrfq37bLxTe7aLnN0FmJJWWcfuHaYR78YpnIGmiNqgzOJhakyZD2JOOoPP
         uE7kn+Gb8/CJW+gf6AjiSEVWBUqO6ejIcpGKdga/IUds0CrQKtockGuLlA/fIgSjTf/6
         I0vad1+TKFN/3IFXpfxH9KdZDRE7SQ6Zr7RSi8eJbH9G+eSQnBrQGhidUwYobCCxuD/r
         uWWXC5BN9TNX0+WNDl/AVk7lTJQ8xj4apu4Qc8NRCEhdXRUiweSKKbzjvXZxqCwV9aE5
         HYQq4TtQHcEvaWFhPNP9bT12Liq9NAZgZhOc+jvSlGiwPtMnJo2B8I6G2aNLZjlm9N6O
         oS1A==
X-Forwarded-Encrypted: i=1; AJvYcCVFP1x6wIPAhXF8JrtT46kq1OCUVLKZUSK16/0oWHcXzSYJZsQHe0gnfR6ZtTWW3O4Ccqy6qtGeVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy05jhaWB2w32lj0FlQwct5njVreVdLp1DRhNYXB3yVItCYetuS
	4MYIFgjIOR1yVeCZYqdH3/+TdaHI8KEIdcpUxQoA5MHDaekMOV9oy2vVySAm+ew=
X-Gm-Gg: ASbGnctOR/hGGAKkm/zjc92ODbRljEt/JGfYh+ffoq7DQKmk5ezD7X2x+p4RNxpmF0Q
	lM0FTiL8UtDB0QVl3IYGgtxCPj5P6G5kM2nIR4UJITMoheWTLc78w/Qs9TRZmbubBs98Tr1e6/Q
	+GAvsUgwAnlspXuxzgFSkPzMiifOk9Z5UdR1AV6y+iVZfhTrLhPA+aT/cewO34tEM0Ome6urbJ2
	YLmlkF4k2IipS3srWnF1TqetAdrbBkTc7L26sHfn8BU7Wb0Th1Y
X-Google-Smtp-Source: AGHT+IHkwAS8Ej9VSR79Cb1OkN5DFMUGnboRhod3n1OF/JTt+wCsm5amZhwtb9LdbY3/dNNzoCVRQA==
X-Received: by 2002:a05:6602:14c3:b0:83a:b500:3513 with SMTP id ca18e2360f4ac-844e8a9d211mr389912339f.8.1734112646477;
        Fri, 13 Dec 2024 09:57:26 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e2d34da311sm1835667173.155.2024.12.13.09.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 09:57:25 -0800 (PST)
Message-ID: <26caf39f-041c-419b-beaf-e75c5870d626@kernel.dk>
Date: Fri, 13 Dec 2024 10:57:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in get_pat_info
To: chase xd <sl1589472800@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CADZouDQpNvEd7ntUgOAQpU18PErENx2NsMMm05SXXODik6Vmtw@mail.gmail.com>
 <ca3b85d6-ddbf-48b9-bdf5-7962ef3b46ed@kernel.dk>
 <CADZouDTH=t7WTFgrVyL_vYsJaWF4stjAj5W8NF2qAK0bW2HVHA@mail.gmail.com>
 <2310bb0c-8a8d-4520-a1ab-40a0489312e5@kernel.dk>
 <CADZouDS7MWbFdh69DXeSdzUSt4AhEqN-+gy_PTdUV2pAAYyEjA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADZouDS7MWbFdh69DXeSdzUSt4AhEqN-+gy_PTdUV2pAAYyEjA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/13/24 10:55 AM, chase xd wrote:
> This should be the right fix on their side? I was just wondering why
> the newest lts5.15 not applied this backport.
> https://lore.kernel.org/all/262aa19c-59fe-420a-aeae-0b1866a3e36b@redhat.com/T/#u

Ah I missed that - yeah not sure, I didn't track that side of things. You'd
have to ping the mm/x86 folks involved there, not really my playground.

-- 
Jens Axboe


