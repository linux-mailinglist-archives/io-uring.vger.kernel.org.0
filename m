Return-Path: <io-uring+bounces-7343-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64622A77D6D
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 16:14:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD7B116C402
	for <lists+io-uring@lfdr.de>; Tue,  1 Apr 2025 14:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F04852046BF;
	Tue,  1 Apr 2025 14:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cZCOZcA5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454512CCDB
	for <io-uring@vger.kernel.org>; Tue,  1 Apr 2025 14:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743516865; cv=none; b=skaQ/SDF55aayDLX7b4dnkCW4Vu+cedgGNmBBwT32jMgLV3Qbgt5snnEtRsifUeyUBQQKm29H1qEnvgzG8YNz4XG77x3E9EdU2q5dKccOaUXuNAqj8EKL/Aejs6DwEgtk1gU17UURwH3mMv1pmMBnCWkPTiY7f+HMqTBK5QLl1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743516865; c=relaxed/simple;
	bh=BZLbpbi/eQbwl+EWJgXpxw7AFjL+K/1ubEngKwOaSWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rhrFLxDcfZJYY7TPJ6/svWUcaq1KuWvhbSy5ggsRymijsTcUSLkpha/aUL79VcErYBnlQ/6sTT37eGfTgK2Oj3mmp0dGpRYtiKXsqtuMqGCi9TKlyqxiL9dj50xNxVCmoOc8o+XUvjHj59DjHnqSegfbv6dP/TC2KyL6r+qGYXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cZCOZcA5; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5e5bc066283so9024372a12.0
        for <io-uring@vger.kernel.org>; Tue, 01 Apr 2025 07:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743516862; x=1744121662; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cwyTSdb1hUbi0Pt1YxcbS6cZD5eaJSjt5gvGirCI1O4=;
        b=cZCOZcA5//xNTPwjjf3lBplZL4FjQwY+6YHEzZH8swXehP4yV8jhtxNMVFgiW/vDwp
         iNgEhQecrKD0KUFF+Os6us4rZxi3EAQPJz5tD4wruyrmo/sOaF1YuuWx4z826ji1x48a
         uJbbqDWzzPgAzN4LO+Ryu6Dh0gFrP5kikujn4FSHQWC+SedrXxCfgicDJPTnEkTCdOJL
         7z6GF+kN5B92mAuq2QB75pWwP8yy6bcRHj2AEel2irT285T2WKdXPNpVep+RuD8BHoab
         39+DDZSsZH3JcaThwG0o5LhKqNRa5k57BOtmiChuyYHUVn/E65l7EVf391iV4pDjYjjS
         wDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743516862; x=1744121662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cwyTSdb1hUbi0Pt1YxcbS6cZD5eaJSjt5gvGirCI1O4=;
        b=pLsRuA4D3izBlo0vSigwcrJOAaVk/vq8IxM7NV8B1hfVVnKtXCX+IATYEIeRAwKrbC
         iTW9oZPzOUhYJofIbSAWxM2KqxVh6B128/PcOrLFX1+x+fIEqUr5vRWHTewURUCyny+v
         ajTVa47oAu+29IcSkZ78mAqHg9lKNKWDlKFMOBrT1SN1TTToX9e1e77wmENQIlMRVWEK
         rW66Z9ph0JiLk05snrXnFDnesfFjAzB2MYoR/nBLNshOo7Qjav0sG1gDP6Ao4R//nLck
         9AKgIiklH425pmd3O6WmLtbZubxHBCKEkXKoHnQMDDFM4p0shyQ8VFTwZ2uiBPJ8fS6F
         hdWQ==
X-Forwarded-Encrypted: i=1; AJvYcCWIY5Cs/TWGwVh31T6e1rruF7YE8MiXNw+DHM+1agSgv6oqo2E3QFoQ/4Gd6hUPJYvdrGH2PGZ/tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyK4QoZQJGUVmFtlw9RGymoQYWRFmYYDLpVs0ek9f13KfyN7dK1
	sZuTomO1yUZIYKLA6L3YDqsIHBHcohIinYh1TbOQ17ZOZdMfyVIPdcGQvw==
X-Gm-Gg: ASbGnctZcyQ6RT0IxeqlWQ4+LWxU2wqhbeBLgD9tUcYw8APSXozPMW8j0RvlpWeLh4Z
	cQNHfYFZh1obX8Zfm1/9QVD1FMj6mT4HhGyDjvrWO68/8AG3qgkhmSJ1tfHXfKv3PcQUJSLs6tf
	a8Da7c2mMoqSuSwKhCL8CPmWZSMX2HaAKzvYlw0U/CR2BYm0G4mubMkkmqDxsuyIMv8tzkOAIc1
	a+sgr4wwM6tWFJuT/WlPephGyC6uNhO3cdibMyFSCq8QlJO9ftySNXQ5wQoB2GYDW2keB8JUWrv
	Q/blzD8Iu0soVStLNPXFTvywMNyHh9+1/wPwnG6p8PIhqzcxXGRqGX8=
X-Google-Smtp-Source: AGHT+IEnjbZL5b2gOhfkjuU0H4sGah1xRVEW82A/PcwNpLgNhI3DLiXm/DAPMgcyB6gNPxMaj+XxcA==
X-Received: by 2002:a05:6402:320e:b0:5ee:497:91f0 with SMTP id 4fb4d7f45d1cf-5ee049794d5mr11575029a12.34.1743516862316;
        Tue, 01 Apr 2025 07:14:22 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.140.143])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5edc17dff0bsm7075076a12.70.2025.04.01.07.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Apr 2025 07:14:21 -0700 (PDT)
Message-ID: <59a05fb0-fe33-4e28-b3b3-48bfbd5486a4@gmail.com>
Date: Tue, 1 Apr 2025 15:15:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring/kbuf: remove last buf_index manipulation
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <0c01d76ff12986c2f48614db8610caff8f78c869.1743500909.git.asml.silence@gmail.com>
 <968861d1-23c0-40e6-9f7e-c306db54bb8d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <968861d1-23c0-40e6-9f7e-c306db54bb8d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/1/25 14:13, Jens Axboe wrote:
> On 4/1/25 5:15 AM, Pavel Begunkov wrote:
>> It doesn't cause any problem, but there is one more place missed where
>> we set req->buf_index back to bgid. Remove it.
> 
> Want me to just fold that in with the previous one, it's top of
> tree anyway and part of the 6.16 series that I haven't even
> pushed out yet?

Would be great!

-- 
Pavel Begunkov


