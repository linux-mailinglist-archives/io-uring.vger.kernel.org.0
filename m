Return-Path: <io-uring+bounces-8298-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA7FAD4251
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 20:56:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D65417973A
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 18:56:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7081C256C80;
	Tue, 10 Jun 2025 18:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KtRJSyHn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E238E256C7F
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749581796; cv=none; b=Zmp1S2GYkFMMNhmUdkLiRgr7FD0FA3lcshIbXHENSpTFWc2VCO31V6vje6/MqIPN+pntrRANGVXlenrDmbPlyPjzzFmA/Mi1XtxSsRfQJVLQc/zzcg0jgszr6pq0uw0Dl5mpS9IfyBs1SHfRsDLyt92VRn5rf+XJoo744O0VH8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749581796; c=relaxed/simple;
	bh=Gjf7MJgtoowVX5GjyxKfHrfyG/iuTCDkZxXqDKA8T4c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u6QDH0cla1ZlzRqRBzXQdvVIT8bdwRby5cw25ORBZ0AYxmSWQUpXJuQHmd5fOVKrcAWwJBy3rWCCmK3EDfPcqV9bCcRoEI8mNqhoGPoXA6fVU8y9ZWzBJiPJ/15BPRhb15gt4QeLaUFiBRU1/x4hlQ6ChL7RUEZENWsyLOABGQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KtRJSyHn; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-86d0c598433so161103739f.3
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 11:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749581793; x=1750186593; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i/hEVzGZOHW0F1bE6WnTuLQwtY9o2+fUFVVXN65KjKU=;
        b=KtRJSyHn96TInDB3HzBYfP2cum3MMgph6vO1cgNuPZFngghPBuHs9rPWKwk4YjUbQ/
         gMccFG9KiZDLHk9kHeDm0GLkWDfb7LgzCwGnVqhTce/tUtENj/yUSfF28hueRLISzix2
         mziuom4db1QQoPcb/B1yLCWgTFJ1ISz2S3PLFaeADrJHiM7UDbzi4RogZxe/xvQF5ZAd
         RvMm/X5a1BJQiM1LdH4BtpG5ZF97wZdPoHIiu+MVlMhFH1y0itmh63XKvQs4bfRk3qzo
         Aammq1kJeGdrQFvxbaFsQikNbRNgTdcCRoUDUMYxVSQizAIPsohCMzPnn1AxX/CpvjV+
         cPpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749581793; x=1750186593;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i/hEVzGZOHW0F1bE6WnTuLQwtY9o2+fUFVVXN65KjKU=;
        b=pnEE326E4ossXP1J1NX3zMZcZhuVZn3ofXbpgmfAF3ZdgbsTf95wyhrJFwtObN5Ebt
         cX+M8vHzDhuOOLY8zvOLTTVz9jirgaACh+yG4RT6uEv1mYN/aGgjsxjK/hAp2Sm7z1DV
         Ec3RLtKNNQlc5BeMY/lvIs9sjAAdHZpFdMvy56r3wN2RRZ+PqhrncfdQRmWyzZieGG5r
         JfpfimLFQxr8xtvSqFQaXMuOw1aEt6slkJ5Q3r9fw4nbDJNVu2epU0r/cNU6JM9szs5+
         MJMnhEErY5tEQbdJ600Q741bC5Wh4SOc2GCPdA42pIam2zbgIIXpPsySiSJr0xY/ft0i
         RwVw==
X-Gm-Message-State: AOJu0Yy26EPcc4q1lI2DvbVqwngHm+2wdkXWiJxDN8SEFIWPT86maKKR
	GUzjo9t66HSDSxebVcYzxvdKJou6Dd8xP05oxu9GPYlKeDmDHz6C/3NqWWbzYmNj7W4=
X-Gm-Gg: ASbGncuFvxWWiGPgdiCfEzOIUTz8H2UA/KpIwCoLFygYupHtGCCz3qzqjGZnctZnIC4
	ihGBPGG6iFLEtjLcu2pfoQAiKMRU1mX0xsU6l2sB4mhKbchsP0eqnt/wD0nTCi0cQmzp38j3lc0
	aIGjSssCRQgKgrK34GLzRlxydR+iL6IRKgNKeQOlyAj6OE37AcyJ0RJXV2R+89J2pkrL/i0Bx0L
	beXxJgWRA8H2Cj0IU48KSVQlZIwc1a92JyQw3MhDcW0r6voaDTubialGVUoNim+wNkW2QHxso0q
	gfPrqaX0tGVzDNXIK56wuCyjdXuJ36GeTsUzJhfvO4lEi0joQ5ccsOShyRA=
X-Google-Smtp-Source: AGHT+IGslyx0wN5AwCzp0VhTy4YPbwswY2jFAV33oi+CcIONtrvt6dFy77ZL0hwJrEMh+yuktXQhLA==
X-Received: by 2002:a05:6602:360c:b0:86c:f3aa:8199 with SMTP id ca18e2360f4ac-875bc4359acmr66688239f.11.1749581792972;
        Tue, 10 Jun 2025 11:56:32 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-875bc699510sm3141539f.37.2025.06.10.11.56.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 11:56:31 -0700 (PDT)
Message-ID: <48f61e8e-1de6-4737-9e58-145d4599b0c0@kernel.dk>
Date: Tue, 10 Jun 2025 12:56:31 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: fix use-after-free of sq->thread in
 __io_uring_show_fdinfo()
To: Keith Busch <kbusch@kernel.org>, Penglei Jiang <superman.xpt@gmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
References: <20250610171801.70960-1-superman.xpt@gmail.com>
 <aEh9DxZ0AQSSranB@kbusch-mbp>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aEh9DxZ0AQSSranB@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 12:44 PM, Keith Busch wrote:
> On Tue, Jun 10, 2025 at 10:18:01AM -0700, Penglei Jiang wrote:
>> @@ -379,7 +380,8 @@ static int io_sq_thread(void *data)
>>  		io_sq_tw(&retry_list, UINT_MAX);
>>  
>>  	io_uring_cancel_generic(true, sqd);
>> -	sqd->thread = NULL;
>> +	rcu_assign_pointer(sqd->thread, NULL);
> 
> I believe this will fail a sparse check without adding the "__rcu" type
> annotation on the struct's "thread" member.

I think that only happens the other way around, eg accessing them directly
when marked with __rcu. I could be entirely wrong, though...

-- 
Jens Axboe


