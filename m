Return-Path: <io-uring+bounces-8531-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87B4BAEE568
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 19:11:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F4C81893C85
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 17:11:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321EA28DF40;
	Mon, 30 Jun 2025 17:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bbds/7vm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76BE2571C7
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751303478; cv=none; b=eyw9PDJmf8CYXxL1rSv47hwP3L6egQakywMG5A/47SMhEKPGwDMG8nJKeZ+1w43hDP2IJoUupNKJ/x/YiM6gnLr2E6AerJVLwTYopq+yf5SOMTtrdeoEISxbeDwc012JX8XpLBCQBQASrgu2f4AtIVnz4rViqLVXPxHKx9cz2L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751303478; c=relaxed/simple;
	bh=YcmCnxylDK1FEnOV6eDbaLXPa1LIQiZZQ57s7QekJyQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NDQzvpQywVR8SasjX0lu4A4zZMuGsFVTZFXoKcAxeTbm6o7cQ8dK0LlStsh+4kLWJNu14RJ3zi4VzwtbVBIB8HE6qgaDoT90IXGTfTUHLLrmFK4a5Qvknb1JjCDmXDyxeaLZd2/ghltZjxkcNlLQgFqdPSrcWVpZGhksIpOUKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bbds/7vm; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso2878984b3a.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 10:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751303476; x=1751908276; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KkRQPdnEQhH31J9ce/2evu2b5gi/2h6cLKnbveAWpVc=;
        b=Bbds/7vmb4cATtg4Du9ePsy5AiSwfO0h/jOEpTgsTNiCj0PArX3balh3YR4fhVfsp8
         VCbLiczDxhQJ6nEyXEwq2COpXljs4PUh9Q4wRRCiNiyZJcvlT8MVmQeCBpnsgxrRi6XW
         uAt1/7hKfo/YGC7OdZiw0wkKBvFUthJeBChA9BFQbOGZJfQp6bLIuameKqxFZ8jwyjfM
         kbae20fu+UK6PPzBgfIaTZQHRnuyZaM1f0GIuleTaJVxoYPgXuPZfNNkceWsiYVda8Xz
         uuwQuLwuR6eHriYTaxp8OlFfDoAC0VfFUJhEk9SZNMPZMJyKSTnotRSqWzDSKfyA6MpA
         dLkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751303476; x=1751908276;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KkRQPdnEQhH31J9ce/2evu2b5gi/2h6cLKnbveAWpVc=;
        b=Brgsujf0sV7Jn4ZuCcuAGErCj1QKVp2C8GWVVdqxdEzF5ys6belPnfFKP9VyuzLgep
         +K6z14IjnZAYf5Yhm7j1djkZtLMm+dOutYcKRkcm7+vf1QzKjW9mfLt/nA5F0p4/7oz8
         yThlasmuadKndmHi7DQmTnHVpLk25Vyzu/TLbI3cRgWfX1W1htn5gp6n5hE8nNs9MB2q
         fUzeyOLmAeNTA3ur4uDKpKbzepMzvwdEV7WqNZaNRDbTfrICfJDFitGt9JogISRq7sEa
         0ecmwDo/xAisalFEgqhFii/jXCVHkas7NRTOBWMVUO1FirZPMVt6ZivR78ESpnJ/Dkp8
         Crqw==
X-Gm-Message-State: AOJu0YxD0FfhrHHqhsuUHgynY5kS6EAnN4YYJT5jz2PJT+OZPx/2oZAR
	aAfrFfj5NVnR76Bd47JnpRIPc99LWAnyMT5gYqzedeAkewP215TM+3PDiINH+zd/
X-Gm-Gg: ASbGnctE7Bvw2kbpYRodDg7KFvvZPl2IQVpaVDP2KVf7/LVCwi7Jq/Oc2avX2j0f9We
	mZwPkBajETvqO2FAlP4EgJTW9Z78R2bzEUNf7G0XX4q/XVbKtWmZfS1Z/EA/JCGU+bUy0nFn7hT
	aupri/rDRWbe6K5pEk3BbQvz7SbJgoSgy9r+pplYbBW806oldZ7Tufa0BZT8MEyrxQ6n+KD8/Bq
	/GCbaTcvr9IA/c6Pr/duXZvdBYIuHDoH28UWoeZuHQ0SlCwjo/H/216cYu70OGtYjK9YMABf2DE
	cIu3eXduwaQrqJcmj3+ox4xK2d9Z/wF0R1gOVziON/DJZIq3Wmi3caG/FYMdSH63EAxWAoRFlme
	q9Kjzs3kf4Q==
X-Google-Smtp-Source: AGHT+IHlxPzfOFxGUDOJ/RoFHc9kSVpsdvSbEafjpLRQ06LSRhP7GRT92n4d9KOy77KxAp+dD4x37A==
X-Received: by 2002:a05:6300:8e19:b0:220:ae5b:e0c5 with SMTP id adf61e73a8af0-220ae5be0f3mr12032016637.32.1751303475554;
        Mon, 30 Jun 2025 10:11:15 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:106::41a? ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b34e302913bsm7517146a12.32.2025.06.30.10.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 10:11:15 -0700 (PDT)
Message-ID: <34125872-bc2b-4b49-8331-d85587bfdb9c@gmail.com>
Date: Mon, 30 Jun 2025 18:12:42 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] zcrx huge pages support Vol 1
To: io-uring@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>
References: <cover.1750171297.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 15:48, Pavel Begunkov wrote:
> Deduplicate some umem vs dmabuf code by creating sg_table for umem areas,
> and add huge page coalescing on top. It improves iommu mapping and
> compacts the page array, but leaves optimising the NIC page sizes to
> follow ups.

Any comments?

-- 
Pavel Begunkov


