Return-Path: <io-uring+bounces-967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AC4987D100
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 17:16:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DED5E2808B5
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321392AEE4;
	Fri, 15 Mar 2024 16:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNK5wBBC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F45E1B7EA;
	Fri, 15 Mar 2024 16:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710519357; cv=none; b=B6fnvWSzzFugznLsnyY709SCFQG3OCN27ZS3OLM8UrcE2+g7b6/UZKrIKyHNsBeuK0mnIWTCpl0moMAWjEY/9IEn4GSYLIkMIOUmx54p3ipP3RTXusWRrFIhO69XyrNnrrSLBrgmb6rITPgbdpcA/8iRCCUPaTIu3QakWD3tLtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710519357; c=relaxed/simple;
	bh=4thJhcVyo+AeGEr9j49bSf5qazfZl5llw+UqcR2Q1bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cm2GBbppvChDwx99X3pfTe9gEfYGwbp9DQTGr+Kxh9r8JOJWuQBkWRkn2TF9pUmzERxQqhVjNsKNUcYuDUsgeOm77gX57F0weffEeID3CW+/BUeTlIT14exeGevGH83jQF4Art0M6bEgBkQlwoif7bxFi00xqKL6YVgReXU23bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KNK5wBBC; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-413ef770149so14694355e9.1;
        Fri, 15 Mar 2024 09:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710519354; x=1711124154; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0DBUaZkHzOQdrBwSi4uyB21zyIns6fq5VuZik4xra1o=;
        b=KNK5wBBC5F7+HK5I4q0cWB4+AN2qQ7L4ae5EXrPEgvCSYUwbwX+fbiYmIckjriDHIh
         8wVwcL7RMIFgwJ9ZLexPpXWbUg9+tFOd+4NrCRNmojnpCSPdeWSDUqMyqJYApT//FktI
         FHY51KTny2LGJBlhb2XHoP0l8Wm1fJB6e/UFIRcWmMJm3yjFr90FM8KAEN5gGibDyGz8
         IIxeEW/txQkBd3QScVAEIM9Ee5KbtBxDH7WnR090NPzhzCBSR5/Inwn8/11UODXr0p9o
         CmtQElg35YDggvtCn8ENT4vp5Q3L1te4RnW1l0othWwjj2zJTzWgJg+gStkXmAAJhUW0
         wOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710519354; x=1711124154;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0DBUaZkHzOQdrBwSi4uyB21zyIns6fq5VuZik4xra1o=;
        b=r3RtC1/DE0QCcVDoT/mvouD0/tnLC1QBt2a3sck4yRR/X3i6xa7K13jEcoa2E0eAGS
         HI3Wu9oMcexsJvDGsgpas0WWTnkY1bi3STSO5M/m9k0msxfvbHlg7qePLxdcdAxLJxfs
         nRsEQ9h81Rsp4faCbudKgXz/jEglu3o9OOrR+eAMPEvDi6HnG/+0JPPxtzi4Kg7c53nb
         FELUwOxIZHSovnm0lMXxEVDR0htaPeLP3OzLOIGUw+6HcfHIrQ7Gz9i+pca+sSOPx36w
         LM+k6pnJXdwEVT2O/kEXuUjbpNuxDxrykvoRWWjKku3rSQvB/CICdt7pbaKNgS/6gVBk
         jPDA==
X-Forwarded-Encrypted: i=1; AJvYcCXfREZehxxgwmmld446ECqSSz5YLLOvM/kdOaloVDcOQdEW2zQI/V33Ai+lCIhew0ohT7dwwU6Y2tV/zb7pl6ZZBXndrixqMcg=
X-Gm-Message-State: AOJu0YzM7SpBgGZyIMK8PWp8YhTlPywPiTxzeUxZDWczCW/0C2wA6WGW
	7LMVarnN3Ck6fPByXNa7HiUjIFq0hxSXbyGSsrMYb9pgQcdY+r7I
X-Google-Smtp-Source: AGHT+IEGQTW7c6XFkxdxhDCkyI7M6f0zg+RdWb/qa+PU9fXLdfUReGK8IJ5LNcAv3B5UICjsvPk9rg==
X-Received: by 2002:a05:600c:1da5:b0:414:3a:3b8f with SMTP id p37-20020a05600c1da500b00414003a3b8fmr1808772wms.38.1710519353599;
        Fri, 15 Mar 2024 09:15:53 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id o18-20020a05600c4fd200b004132f9cf053sm9338384wmq.33.2024.03.15.09.15.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Mar 2024 09:15:53 -0700 (PDT)
Message-ID: <89fcab68-81f7-44d1-8677-277a269da75f@gmail.com>
Date: Fri, 15 Mar 2024 16:14:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] io_uring: force tw ctx locking
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>,
 Ming Lei <ming.lei@redhat.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <1f7f31f4075e766343055ff0d07482992038d467.1710514702.git.asml.silence@gmail.com>
 <6d100f51-9afd-47ba-8280-51f841f9de3d@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6d100f51-9afd-47ba-8280-51f841f9de3d@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/24 15:40, Jens Axboe wrote:
> On 3/15/24 9:29 AM, Pavel Begunkov wrote:
>> We can run normal task_work without locking the ctx, however we try to
>> lock anyway and most handlers prefer or require it locked. It might have
>> been interesting to multi-submitter ring with high contention completing
>> async read/write requests via task_work, however that will still need to
>> go through io_req_complete_post() and potentially take the lock for
>> rsrc node putting or some other case.
>>
>> In other words, it's hard to care about it, so alawys force the locking.
>> The case described would also because of various io_uring caches.
> 
> This is a good idea, I've had that thought myself too. The conditional
> aspect of it is annoying, and by far the most interesting use cases will
> do the locking anyway.

It floated up around a year ago and even before that in my head,
but these days it's just completely loosing actuality. And the
rules would be simpler, req->task context (syscall & tw) means
it's locked, unlocked for io-wq.

-- 
Pavel Begunkov

