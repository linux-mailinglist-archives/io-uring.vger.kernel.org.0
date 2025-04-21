Return-Path: <io-uring+bounces-7583-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11344A94A0C
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 02:22:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34F0216E4CB
	for <lists+io-uring@lfdr.de>; Mon, 21 Apr 2025 00:22:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 647E4EAD7;
	Mon, 21 Apr 2025 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="CxCpWdaE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A16134D4
	for <io-uring@vger.kernel.org>; Mon, 21 Apr 2025 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745194971; cv=none; b=CyHM9n+WAwdRws1Q79Ql0mTl5KNTuVcNH3tGO1QtyPXCm/SL5L0Iwd7ZzLuHnjznhr6fh4I99aL/LseWEYTpV/pubLMzIMIAGFUWJRm6HoRAdPCFkdFrIdKsouIQWpSS9bxRJ6duA1BcBNQBtkEzhTmhWF9ATU0tNoBhrTLUL3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745194971; c=relaxed/simple;
	bh=3CcI7BPDsQKM88oUu72ux5cuqpzhUgpOABMkfDXjeZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jclGkE46sbSXdaQJTY/R9yex8PcZ90qIan4H/MJhWeo7uT955gNlFd21s0gQirZFhlYd9yxZtERNQqwFwxobx3yeb+yPVxXfC/nq79KppcJVkvyD4qYcCE0bqdQCeVFtdkOcF/8lkWdb+rN6Ogv/lox3iTp2dvSlCufhM64KWNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=CxCpWdaE; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b061a775ac3so3122819a12.0
        for <io-uring@vger.kernel.org>; Sun, 20 Apr 2025 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1745194969; x=1745799769; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HP/8ipxgQYJ4Zpoz8MzZmLhKyXCYtHfFpXXNCJCLdMU=;
        b=CxCpWdaEb7ee3VurjSq3Cxbsc0CU4702vb0nTmsTSsuqcRJfjssmuaVOoT6Ao13Qmz
         HeSNFQJ75pKalTAhPZvIpX+CxzMGdWurezC3rdgBu0rxKAgmsehZnWjzhG5aFqdHqUzR
         tLocUJqr4iGRXgQpYIbw8i2IKWhrRgzypSpc1S/Uaj6R7uNogKintObExSdsw6c9kCb7
         NApbeEjfBByIQbSKxg0iGH903Cp/8Qxxi05eikH8wnlTyjrYHPhyC0zgI8FqHmqbC0Yj
         XzgQl3HqQyIzZV66J4hwyAnHudRxjvZSLYsv4Lz5tvzk5JhP8wPZkGTYnzXpsEai8xt5
         BB2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745194969; x=1745799769;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HP/8ipxgQYJ4Zpoz8MzZmLhKyXCYtHfFpXXNCJCLdMU=;
        b=A8HMlAmlJ8f6UzeNYwA9eAqTLFu/tnfLdTAsf1fjRKKJUsomgZ55xb+RGNC7V3Owqe
         UXbNZow6IUBAhVkCIRbtejhwQvEVUyasiOBz3irpEAXH9tVWEpAfyRseWMveDJMrbwET
         fHn93BAVDF5rE5/Z/ZZKg3mAtLhnHBvYVWxH+3NIvRVFMBPi3DVVZyTtKOLKyQy93gGk
         Mdf3iIdxN05Ab5/92QjXJw3hZp+ItAlIHRs6Lgk+0lV8SWJ/FbwMI6I6Er/uuvT26XRF
         C/EMvjFiOqj5wavbHDSQzWQ8s8rZ1kGi0tkGNaGdV/D9if8Sw0Ifg6IJyzm2Mg99KpVF
         KRSw==
X-Forwarded-Encrypted: i=1; AJvYcCVYMmtSkDu9nQBBb4Vp2GRkhFmwfsshMSo+7u8XNduHBcIsN8URYGYDWk9hdpE0p104aXj9tQn5ew==@vger.kernel.org
X-Gm-Message-State: AOJu0YwK6xJY/PdgiRTgx3UrR56CJODMepBf0NjSfSSfM+fbAwxTAqBR
	fhVY7KYYqDWdGz33na34qwQYVMK0Ww/vkHHcPACalchq1PUBsEHOqSzBQBYJCcU=
X-Gm-Gg: ASbGncs36f7Tk3p6JXA0Mn32u3ufykVpm875q2CKanxCPRD3nMelmUisMfLaSqUzqmw
	i5ha3xfekWesGdUXxOEBuZbOnCrYpKFFrUIIWzVoE3YknS9xtJAl5mvl33j8w3e/u3MnMG/+ylR
	x/x9LrEqyjb2wu7okQ0DWSTNbusNaRk0TJthE+WDhSY5vWryELwG6yd9w9xNnRAu5RD78L/+RvC
	rl/0jIq/53oswIh2T9qnZLwscsm4HJiZQnhCmcQlCu8NkAikJjk/6TrggKQpIyDYpkWeSQFJJzY
	03blmWoNZgxKtGzEIuODuG1cZHSCqh6ISGxMjx3DL/HgXcE=
X-Google-Smtp-Source: AGHT+IGIQq9xsGeZ0FRsHmndcR2WVcvFM3zUwMqfoAtyiRe/RndFx+afDhapbzV+myVxHkQsfEDV7g==
X-Received: by 2002:a05:6a21:338d:b0:1fa:9819:b064 with SMTP id adf61e73a8af0-203cbc4d64bmr14903678637.18.1745194968902;
        Sun, 20 Apr 2025 17:22:48 -0700 (PDT)
Received: from [192.168.1.12] ([97.126.136.10])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b0db13a57a1sm4593637a12.27.2025.04.20.17.22.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 20 Apr 2025 17:22:48 -0700 (PDT)
Message-ID: <5a6b754c-d511-42ce-a9db-5aa9ae222599@davidwei.uk>
Date: Sun, 20 Apr 2025 17:22:47 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing 1/3] examples: remove zcrx size limiting
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1745146129.git.asml.silence@gmail.com>
 <64f4734fbd7722e87a21959ac668b066bd984717.1745146129.git.asml.silence@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <64f4734fbd7722e87a21959ac668b066bd984717.1745146129.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-04-20 04:24, Pavel Begunkov wrote:
> It's not handled too well and is not great at show casing the feature,
> remove it for now, we may add it back later in a different form.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  examples/zcrx.c | 34 ++++------------------------------
>  1 file changed, 4 insertions(+), 30 deletions(-)
> 

I'm relying on this selftest. Can the deletion wait until the
replacement is ready?

