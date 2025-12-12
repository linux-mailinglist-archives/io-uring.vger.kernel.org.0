Return-Path: <io-uring+bounces-11019-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 91D93CB7945
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 02:53:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 23CF63013E81
	for <lists+io-uring@lfdr.de>; Fri, 12 Dec 2025 01:53:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 872DC2264DC;
	Fri, 12 Dec 2025 01:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iqK6Q+yA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f68.google.com (mail-pj1-f68.google.com [209.85.216.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F3633985
	for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 01:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765504392; cv=none; b=hXrmHWpVUWfz5SOBQnGNlEez1o21XiK9hYaZWliLQRxuTEj+YYK90/sIHWYTsU5d+WuAUKaGkDIuswW6e28gXwfTtaXslxFrGat9HCeHZ2721+3dX9mSVenYX+n4z3NhaMRAZw8r0UNUqQQyns1Rkae0d7RL2JxYp1fRAvZeMrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765504392; c=relaxed/simple;
	bh=fYIo+55tWxPROi0fyvPyk+3fUsgCJ+6aoo8xOFrBtEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QQxtdN/J9YhBPO9SAwoJUH+FF1xRzk0kGrGSYSf0+9AEd6CfHml6NdQnady1hb3kcX8ORfyBWnH0IFC+znvZMixn8WTmS9DhZoln/bDcuTThl7MVIijdg2wMn/kDY4JXAXm5ENUVW+6m8PpGZAtVN7R80lIPP1wzKyu8RkyTvYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iqK6Q+yA; arc=none smtp.client-ip=209.85.216.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f68.google.com with SMTP id 98e67ed59e1d1-34372216275so867112a91.2
        for <io-uring@vger.kernel.org>; Thu, 11 Dec 2025 17:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1765504388; x=1766109188; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rc/zkrnsu1iumz3hKLqB8W7xw1ymf0kT5fH6xQTWUAs=;
        b=iqK6Q+yAJaTWBgkwN6W3kq/nAYU5qqVO5+vneEwlfyFN6xdRBhT21XHqFjdnBcQgqa
         0Qr5QsYXqIjSKKdddqm+v9f/AMs8/IiWekEHM3SkgeRq1V4iITYDW3gBEiZWISDY9ljg
         mZoBxpa9LBiBzgqjYzTV6gd8m9ALlUHmBq+yOAgb94phV7eNON79NASX9pHWeJh9PJEx
         WQCcWwH4TJGT4og60ZxR2rvWti2hHwfKFkv2VrqE/s6n0t+MY8GPBeA/r2KqGMUAXoOl
         qbhWsUpq+H+75zhCnA9bWvKyp3iB57IHAr686SMv5EqLh06cSS3E76EkLYDilTbFOprD
         N0hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765504388; x=1766109188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rc/zkrnsu1iumz3hKLqB8W7xw1ymf0kT5fH6xQTWUAs=;
        b=FX/+43KkX6GOnWVckECHVSXnld/k1bGo4cUrBemmfUHs1ioBGY2wSreJ8JKVFXdke4
         1dAzEKtXdC9M7TSLnZuff4RHj3EpH+pposfQ/9mNBai3cJ6V5tmHbcVqzyIoX/g1vFW/
         w40Bnp/8+ohWhO3usoTlls8yUpyZjTwUVa0C7rL/Yj+YM/DIg+UOAwRx0wHoRDfRUwj6
         rhH7GYYVGXfON0c4xxBsB9nrqpQw2aq14IN0FDxRajf0La4Yu/jBkjYHYmu7OAx9AzTX
         eLjdG2weQF2KI4HL+khwml2TPSjhCFoBUsC2kqvQvjpZHyiyqJVmQIjwFdBao0wRqwIf
         xgsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzX2N1+DTQjtp0m6DNFlIidWrxTPk0NVvY0R09anpyb81+YxAJK2zgJvh+Qo/1+4CvIu0FVyTzWA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5d8v1LshDgCGy03f4Nm6DaxMOWFhVXzCnkr2C8dGWn1EenYvI
	JVPUP/wq0FlCy0SIuOgdL/7JYhs1nTqAWZk6iSFqDHxv3dhl3Ybn4AyRnqlfx7x/isE=
X-Gm-Gg: AY/fxX7MR8yeEtjUNOeW11H+4CbbgcFct6F857AfgzOUxYQ2LHTlVvMtXbw+hcWpxIH
	uFkxQEHMrkn3sjU8WdZTYx4Li0ridyTgmxdYxl9pT+/zE6rkZLAn4vcDHITQXzusMQziHg/NZIY
	sbeBPE4YqmcmAcp84pHerZAkTO5tVcBZOF+Y4L0bbV3ut90AliJrX2EXbqntjqDvQMjzw9pvYi8
	JR2iBkfeCDoQhp5AV2mBZmy/Jq5lmpSi3E9lfE5WEun+c9kcE807JUBRNcrpo0Gu73xB2p1esZi
	eYR2669dki4wQWgpyp44bwFolllDB0lOAo+j4Vhkl6gtzTdmRZCf0SjGbKW6I8uZeBnfHCFmF5E
	THr31l6lhvkCRnEFYsq41qejTkvh4Y9QyKLMAYz5RJxAA6Kax+EawiS2pDvcdcXDleQlHnEb8FC
	gljtLS7EGL8hDJ3ZNaAunPYPA15rh66OH11CnJBuMPMZwydzESqg==
X-Google-Smtp-Source: AGHT+IHkvrXyxNXLEGlBJEUBaAizU68MfitlSnZsDR/QV+tK3jLbJB0LgnhC/ErBHmGsqrKFSY0V+A==
X-Received: by 2002:a05:7022:a87:b0:11e:3e9:3e8b with SMTP id a92af1059eb24-11f354f5679mr175449c88.50.1765504387775;
        Thu, 11 Dec 2025 17:53:07 -0800 (PST)
Received: from [172.20.4.188] (221x255x142x61.ap221.ftth.ucom.ne.jp. [221.255.142.61])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f2e1bb3b4sm12870968c88.4.2025.12.11.17.53.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Dec 2025 17:53:07 -0800 (PST)
Message-ID: <1d8a4c67-0c30-449e-a4e3-24363de0fcfa@kernel.dk>
Date: Thu, 11 Dec 2025 18:53:05 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
To: Fengnan Chang <fengnanchang@gmail.com>, asml.silence@gmail.com,
 io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
 Diangang Li <lidiangang@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
 <20251210085501.84261-3-changfengnan@bytedance.com>
 <ca81eb74-2ded-44dd-8d6b-42a131c89550@kernel.dk>
 <69f81ed8-2b4a-461f-90b8-0b9752140f8d@kernel.dk>
 <0661763c-4f56-4895-afd2-7346bb2452e4@gmail.com>
 <0654d130-665a-4b1a-b99b-bb80ca06353a@kernel.dk>
 <1acb251a-4c4a-479c-a51e-a8db9a6e0fa3@kernel.dk>
 <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <5ce7c227-3a03-4586-baa8-5bd6579500c7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/11/25 6:41 PM, Fengnan Chang wrote:
> Oh, we can't add nr_events == iob.nr_reqs check, if
> blk_mq_add_to_batch add failed, completed IO will not add into iob,
> iob.nr_reqs will be 0, this may cause io hang.

Indeed, won't work as-is.

I do think we're probably making a bigger deal out of the full loop than
necessary. At least I'd be perfectly happy with just the current patch,
performance should be better there than we currently have it. Ideally
we'd have just one loop for polling and catching the completed items,
but that's a bit tricky with the batch completions.

-- 
Jens Axboe

