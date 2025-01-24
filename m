Return-Path: <io-uring+bounces-6121-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21AD3A1BDD3
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 22:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 257CD188F13D
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 21:22:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCED31DC98D;
	Fri, 24 Jan 2025 21:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TQKqz1Ha"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F841D54D8;
	Fri, 24 Jan 2025 21:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737753759; cv=none; b=X75SMq+IlCoLD+XxSbl3d5Zpsq9F0rXB6ZJ8SV/bA3Qwy7+Axt3lVOeWNrS6aZzS42tdkmA5x5wmNCxx4+xitVaM7Ks6JC8Kkjn2tE/196MamOwlJWiZCjKBf8N3gQPvZfiTW1y8NDis20XIiSiJxuawWgiYCNfrqqwLHEZiAFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737753759; c=relaxed/simple;
	bh=OmKVWgpSYw1ESO4/d3sffoNrKilZSlarV7IcejrXiSg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=okrpaO90aRQkcDDnu2PDAG4uL0i5YIjCeeWxtJ8gEzLXLqt3Ok1hWJzik1nxZhppXaCYuRevscvXDBrA2vQbsv/9eHU0FQwECalPcp/aAoSdiOLH3JnJmjsFYl32VSoNUxwboEo7oJdKY17RaKEzM9lzQ4zpc0jRutPEerwK1zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TQKqz1Ha; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-38789e5b6a7so1458991f8f.1;
        Fri, 24 Jan 2025 13:22:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737753756; x=1738358556; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xqEqyb48CxyGTiHhVzsyeSHk3Tx0rO27cd7ixGvlFH8=;
        b=TQKqz1HaSahQRWUjcGjsBVIwBN6me7NYsrHbudgyRrl2nSw2BWmZmrp1fMPL54NQjG
         HcIHVov5feG9YW0yTGLOCEXg8ASMqOBuECQsbMU19TNE8tS31eZNw/14cUrCt1STcJiz
         0VLjptjMTFeeYkLzXBwVQlAiP/k45C85XJXVxZSRN4ucf62p8QDmje6E6lUOV65Pcx0X
         j+SeB1sNCvvXvZxXQu3uB7dAs8/8HtVDKwyZ4IYGmq0QVE5fNRcYmTvbRa8Vh9syYoaC
         AIddBbaKM9cvLv7pxCCoHedlcKqAfV3qLFo0KsMtvmfE3vWaHq0Y3JwUvC5KDVoTfqoS
         uXbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737753756; x=1738358556;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xqEqyb48CxyGTiHhVzsyeSHk3Tx0rO27cd7ixGvlFH8=;
        b=l0yFnbhdOVk4LhploC9o2afFBjhh5iuTOuj3LtaOcs4ezN88eVRRK6qQ0MtcEMpml4
         bse+SyUPUiE/cpz79T2qzufHxPoztUorEzZmZ22+caOiywGj0aoNISj8qPi//FYZL2OM
         RxTYwSSH1oFeh4Hu6f8egTuu2yzDMmx5n8ndMk2sbuYFBejxfIwuZWZwxSDr3NoeLEWt
         YsV8wauqCh8d50wh8YWyrDuyPO7AjDDdAJlgkdXEttg1PPXLsOFN0jnpKAE+RUcKUvn5
         FLZ8hEk9c9oRUy+9cIYfHDyqjLL/ojSlGkeS4NxD8U4kDpH8gAhVAjnDhWRUVQjnK1x9
         EELw==
X-Forwarded-Encrypted: i=1; AJvYcCXajdkVLy2Vwe5r6f2lwS2cdeQuV2zAG0mVdMFl/VynutusgepelttM4sLVITofCOD7mvX/gog1@vger.kernel.org, AJvYcCXfaNniKMUJhhHus7LpJhWzb69zLilnJnDXhT3p1arkQxcZLthkEye8kmy1yWxawtuS3wVWzwE1yQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzi941QybUBXhMrCE0xMy+X6vUVZIyW42ukNDqVT50OtbNimf+x
	zcn7W4LhSxNw85PQSldwVuCj6UEhp7SGieZmKNB3Elr7wOm07tWI
X-Gm-Gg: ASbGncuRH/Lf6gaN2ALfavqsuh+WOuFjLUehj7Ulluk3sPE0seet9hAPfwSdgtyQ9KF
	GnMMjwLOeU1ZC9JkUhTbIxx3sV/SH1rt9Cj8JwM4V2zhDbr2gIrBGXtAT1PU78rqEhb0/flSAS1
	PbwGGj3Vv31IqcJ3YC0ZIIutIgEHEOqNErOoooT0/oGpx43rdFfmW9tgRb8K9Cu5fMRnZ+Ee0MZ
	FpU/ldLhobc2qpdXtuA1Vf4qQ0RNQO8qGK1H8WJJyrEOdgLWQxCLMwUFFx1f7Quplg6C4gAPF7Q
	n0D8CYoQL9gwYZn1MsvdYU23
X-Google-Smtp-Source: AGHT+IG5JW5NJWyy27ie6prb9cZhkGaIWt9yws4++wxjavDdpmDSqH9ekoKxdb0+XxtzWp5QHge5pg==
X-Received: by 2002:a5d:64ec:0:b0:382:4b52:ffcc with SMTP id ffacd0b85a97d-38bf55bebf8mr29428082f8f.0.1737753755925;
        Fri, 24 Jan 2025 13:22:35 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.79])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a188a61sm3820815f8f.52.2025.01.24.13.22.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 13:22:35 -0800 (PST)
Message-ID: <de8f5241-e508-4c30-b807-f16fd1cdbe9f@gmail.com>
Date: Fri, 24 Jan 2025 21:23:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 stable@vger.kernel.org
Cc: Xan Charbonnet <xan@charbonnet.com>,
 Salvatore Bonaccorso <carnil@debian.org>
References: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
 <721da692-bd23-4a73-94df-1170e3d379be@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <721da692-bd23-4a73-94df-1170e3d379be@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/24/25 20:47, Jens Axboe wrote:
> On 1/24/25 11:53 AM, Pavel Begunkov wrote:
>> [ upstream commit 3181e22fb79910c7071e84a43af93ac89e8a7106 ]
>>
>> There are reports of mariadb hangs, which is caused by a missing
>> barrier in the waking code resulting in waiters losing events.
>>
>> The problem was introduced in a backport
>> 3ab9326f93ec4 ("io_uring: wake up optimisations"),
>> and the change restores the barrier present in the original commit
>> 3ab9326f93ec4 ("io_uring: wake up optimisations")
>>
>> Reported by: Xan Charbonnet <xan@charbonnet.com>
>> Fixes: 3ab9326f93ec4 ("io_uring: wake up optimisations")
>> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1093243#99
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/io_uring.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 9b58ba4616d40..e5a8ee944ef59 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>>   	io_commit_cqring(ctx);
>>   	spin_unlock(&ctx->completion_lock);
>>   	io_commit_cqring_flush(ctx);
>> -	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>> +		smp_mb();
>>   		__io_cqring_wake(ctx);
>> +	}
>>   }
> 
> We could probably just s/__io_cqring_wake/io_cqring_wake here to get
> the same effect. Not that it really matters, it's just simpler.

Right, I noticed but am keeping it closer to the original
in case we'd need to port more in the future.

-- 
Pavel Begunkov


