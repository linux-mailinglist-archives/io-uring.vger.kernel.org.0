Return-Path: <io-uring+bounces-8952-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D597B24988
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 14:31:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1520E72764C
	for <lists+io-uring@lfdr.de>; Wed, 13 Aug 2025 12:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3500E39FF3;
	Wed, 13 Aug 2025 12:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2RTbpkxo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA293C8FE
	for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 12:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755088267; cv=none; b=okWOFDUj47AS+MVCw+7Q1NR408INuxw/0USK45bmUVCy5hZ2sXm+LQbrO0jKPgzlt5aB6y69gbp7l1+ZmQE7Y7CmDjCtpwmNXw3D/BIFsmjvPP7ZEQYAV1i1xJAQL5hlfHm8zHdfldN8BfcDj9Y0BepK+zZUHi+lX5QSj1r9ak8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755088267; c=relaxed/simple;
	bh=TA+1dRl1SAfauvpeLC4KgPDduEfXimkEClavXfse24Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XHTGg+DjoSmv+ZDHFToVw2myiwHfcU7xg08sdCc2r/LyEVGawwRmxuDnIPm6QLEfFA7R5SiF/qyvEjPI5/XRIipa5dXo/N4REEH1lFvCTqIt9eirmtLk8rN/R4mOrP2bXhQS+QCtGW5N/9SOof09Md8oNGyaO5IfrazbbyPy98I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2RTbpkxo; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32128c5fc44so821547a91.1
        for <io-uring@vger.kernel.org>; Wed, 13 Aug 2025 05:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755088263; x=1755693063; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=I1+AIgcDFfPuuvATTLTciJysna71lICKFsTUicf0vvQ=;
        b=2RTbpkxoPVfpgQudqR4xirLOEMSS17LV7ZTEo/QtUF0OA3RZxUxyntdWrRtfFo7Yl0
         mB+t6NysW0C1uJEs6UvzJ/Yka3kFHBeqtlcFYI8xm1he6VaHz6lateU7oNcP0QrmXtKU
         mmnNDp9D5k1MHQJC2804xlhylD7MnUJhgUeIcYJ/R+rhgRCtb7t+cH0467jjY+f4frJs
         N6LopIJgQ031kAHnwYBNsVNKCwPd9kJE3IvEAWTprYMbdrEGF3E1beOoTwpW/0Kt4fBu
         w8GMYXyBFXZSnl1s+P7ruZEICKvucUHq8bkdDsbsS/gJcWSS7Pf74x9yKIIR1RYutCOh
         ERyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755088263; x=1755693063;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I1+AIgcDFfPuuvATTLTciJysna71lICKFsTUicf0vvQ=;
        b=nrslBEB2y/Sn36RxiQS2XXzUAoMncZWKmNBDA0EHumNE3RTpVhVYX2jYhJNrO7bJKq
         R00zMRDrU3ilsim2/ccMZqvXQ2+8uY3Vemk81RIe/ZbogWydaXnVvPrWD2/1zL+IUTO6
         dp3sd2SrlAP4B89TTjCWJa+cpST9vWrQC47h3k4D42LcJKJMwYABsCwb1PT49e8qK+Nv
         IIf+uUnQBTC+VfzG3KoQaQQMX9mHybR9c+45LIhw8UKOg0TSsXCxfLyoI2cjBaGoGhCp
         xZV+v0dKoUN+lBRBld/lXzPC30yLvZpNhZs3XMKlZn/wKS6BOh/QI9FKU7dDIWbapb9a
         SH0Q==
X-Forwarded-Encrypted: i=1; AJvYcCWRsXmY/gYfU/7mpRE7TnWUienL/6bdUS/4jiJD5cxV4ChgwoF8+s0Bif2kBDVzxgfYtg00Nsjiiw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwgnnC8uH0iRDzo7SaZ/tiGjas0977cB7MkwPAoBCsov0HdtWBl
	2t3SJ/M6EPMypcz6ldc+AOBUSU7gFToPSi2iVGJkBuRXgntP/6uNzY0EyjoJVn9W7MQ=
X-Gm-Gg: ASbGncvxZvUX1F/D+8t/x/hIzIy7zPwOVtzNzIEtizX0cM1jWmcxbhqxibRXE+p+l30
	m7zwl8kQysdoyvO2OguyxNxW5q/p7Aqi8h5AB18jsN4w7neQzBI2XmPAg0OqlA3+6wQ6xm4rMkY
	AiRn2t4augRIPq1J46MDo0FM4q5w4oj936Sl82/O9TTbpt/x5VhBOd3UzmYheJcKGFAsph3hmbE
	DStvE2nkWfdpqw2Fsi4DxCks4BP8EM1idVJietgBWUMUXfhSfXrfjbLmzdcxlkoRrS2WMZvhJu6
	ifpBT/AYY38kirvV8XoN0y9OMnA/O7gWkkRx3kI5TTazjxyftkIyGqzf5gV9o/p6bEjyaSiVHmW
	5ZaM3SqPNTmOrl4FdlVm0
X-Google-Smtp-Source: AGHT+IHhp9YuB6oUY4YLAWMOIqauRh+2xkOAzlHHldEAnAZM5AwK9vl3D3HQsk1hbgdIMZNxPRjRcg==
X-Received: by 2002:a17:90b:51ca:b0:321:c56e:7569 with SMTP id 98e67ed59e1d1-321d28b1c13mr3738135a91.10.1755088262575;
        Wed, 13 Aug 2025 05:31:02 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32325763516sm73275a91.10.2025.08.13.05.31.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 05:31:01 -0700 (PDT)
Message-ID: <4b843462-f8be-456d-875d-51ce1e6dd3fa@kernel.dk>
Date: Wed, 13 Aug 2025 06:31:01 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/io-wq: add check free worker before create new
 worker
To: Fengnan Chang <changfengnan@bytedance.com>, io-uring@vger.kernel.org
Cc: Diangang Li <lidiangang@bytedance.com>
References: <20250813120214.18729-1-changfengnan@bytedance.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20250813120214.18729-1-changfengnan@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/25 6:02 AM, Fengnan Chang wrote:
> After commit 0b2b066f8a85 ("io_uring/io-wq: only create a new worker
> if it can make progress"), in our produce environment, we still
> observe that part of io_worker threads keeps creating and destroying.
> After analysis, it was confirmed that this was due to a more complex
> scenario involving a large number of fsync operations, which can be
> abstracted as frequent write + fsync operations on multiple files in
> a single uring instance. Since write is a hash operation while fsync
> is not, and fsync is likely to be suspended during execution, the
> action of checking the hash value in
> io_wqe_dec_running cannot handle such scenarios.
> Similarly, if hash-based work and non-hash-based work are sent at the
> same time, similar issues are likely to occur.
> Returning to the starting point of the issue, when a new work
> arrives, io_wq_enqueue may wake up free worker A, while
> io_wq_dec_running may create worker B. Ultimately, only one of A and
> B can obtain and process the task, leaving the other in an idle
> state. In the end, the issue is caused by inconsistent logic in the
> checks performed by io_wq_enqueue and io_wq_dec_running.
> Therefore, the problem can be resolved by checking for available
> workers in io_wq_dec_running.

Good catch, and thanks for sending a test case as well!

-- 
Jens Axboe


