Return-Path: <io-uring+bounces-4431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0859BBA8A
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 17:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 049DB1F219EE
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 16:47:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C2751C07FC;
	Mon,  4 Nov 2024 16:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LcLW9qZX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B93742056;
	Mon,  4 Nov 2024 16:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730738832; cv=none; b=l1BT3ArAZCE+63zILg1pNX7slzC1Q4QFPABpvZI9EGXg3YpRbnd8lhQUmrV+kuKgCkoqn28W/oVRgaveJ7XDa9gBFK4y6AYvUxY/kVr5GPAh8oFbcJo5c5cRMJXd9lYXPg6yPhSjUoUmn9szr/Z5kaw3gdhKehUWCPJD7M/O/XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730738832; c=relaxed/simple;
	bh=gaYi+6pFXfrzBuPVYbarYjwF407HXun2Zzw8YwLjYWU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IL3G+oziexmR2n4dDoRf8SWg0i86+ztOa/C3t8+OdQTlwLVfqMCg6VzDeSdYY12HYVQ8BbKwKt3gECFtP5QUK3jvOGuHt3Ub1WKqkB2VUgjIXNs9/2zrVc86uOCCciq4caUV/+xWOicncKGrNa8YfYkjt1bDHnIg6ZmEkmKSv/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LcLW9qZX; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2fb5014e2daso39239631fa.0;
        Mon, 04 Nov 2024 08:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730738829; x=1731343629; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IJ3U/qdQXRj8Up7zewmdnkj3mq9OTD/YfUz+/m+8mBI=;
        b=LcLW9qZX9VT1j1IVe483pt+J/pMovS3H6/XIMGhTz28ZR+bQXkcpsPvuPpKLsMJdif
         S9zt494CZbxb/O9oXxiyza2GSoxoVFfLBfrdVdq64WjlaNIo5rfc3+1XO1Yk2Vx9fCGs
         HGwxThQn/6s4JV20olNMfFkK+TT128OqXjPjZuPOeKqiN02WbZ2xPOyPCJOQrvEe+1bx
         XfAcrJ0ESUj4UVSMAahHz5BhC/5QMNWCSQtYwnExOc2KMJUJ32js5NPdHfO9jtJBgcf8
         Jf9iwsrYLOwjS1IxDLECfowynEj51QP8Wtw8vctX4gVwI53few0JZ8cJggAQabkVYfRf
         Qy4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730738829; x=1731343629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IJ3U/qdQXRj8Up7zewmdnkj3mq9OTD/YfUz+/m+8mBI=;
        b=DeY6fMoQxOfYjHyuMHXD5gYx9ti44ReSFpTgqD9sPWB38skbKtw2FIZGXWJghJe7OL
         2HlyCUNUfGOBvx58sN59iZyGtm/idMEG2KF2qr98zYednsSopfPR5SsHHsUWp1KvyXaO
         xnGqPz1UEXtN96z3CDuCoJQnoFH9CVS1ljuAKOh4O2a6SajbWaLCJnep5kiW1lspKvTB
         GtzTxoBAYe/SFOiRmsKFjc89WzcX6cePglIhbow5hVxAan/fZe47ZTExrBQL1Da2IM8Q
         NZtseUQUwdtVo2Wg9scuUsF+/Tyoz7mGRHi/RcLdDQwJYj1ZPKhC1dJLWq4PNXHRvv5e
         9kog==
X-Forwarded-Encrypted: i=1; AJvYcCVH3S4SCHB4q2IIFGv6R0FyZKmmOVZGrugfiAqPITZkEfKeqqYpG1Ev/DIreZnfyKouFMk0rPPFT+PYRFY=@vger.kernel.org, AJvYcCXcXQBnZs3E3+WxDBDbzjYnWswu2pvLC+/XhtA38OBalKxAaEp2IKRmSiHIG+dYSkbuBfHl2RBj9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwKW4zYEM7UnTWrWTbg97dmDbpP9HiMDEMDiuHx+jymEHuB1eG5
	ALmbPRjkgmafZ8GgD4jpWxKbNmcDL34NhH2jHv9MuBcooQD0gS3V
X-Google-Smtp-Source: AGHT+IH8WqU4CV0Xwne2w2zJG398+yWElH58DauF0i2yzos4xh4ekeMSXjNaj3JWY+I1np8koQ9wqA==
X-Received: by 2002:a2e:a9a2:0:b0:2fa:d31a:1b77 with SMTP id 38308e7fff4ca-2fedb756e13mr52080511fa.9.1730738828516;
        Mon, 04 Nov 2024 08:47:08 -0800 (PST)
Received: from [192.168.42.71] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cee6aafe0asm43705a12.23.2024.11.04.08.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 08:47:08 -0800 (PST)
Message-ID: <6c774395-6537-477d-a5a6-f58edb07f436@gmail.com>
Date: Mon, 4 Nov 2024 16:47:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/cmd: let cmds to know about dying task
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc: maharmstone@fb.com, linux-btrfs@vger.kernel.org
References: <55888b6a644b4fc490849832fd5c5e5bfed523ef.1730687879.git.asml.silence@gmail.com>
 <269a3887-070f-4faf-85d6-73e833f727ab@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <269a3887-070f-4faf-85d6-73e833f727ab@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 16:15, Jens Axboe wrote:
> On 11/4/24 9:12 AM, Pavel Begunkov wrote:
>> When the taks that submitted a request is dying, a task work for that
>> request might get run by a kernel thread or even worse by a half
>> dismantled task. We can't just cancel the task work without running the
>> callback as the cmd might need to do some clean up, so pass a flag
>> instead. If set, it's not safe to access any task resources and the
>> callback is expected to cancel the cmd ASAP.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>
>> Made a bit fancier to avoid conflicts. Mark, as before I'd suggest you
>> to take it and send together with the fix.
> 
> That's fine, or we can just take it through the io_uring tree, it's not
> like this matters as both will land before -rc1.

There should be a btrfs patch that depends on it and I would hope
it gets squashed into the main patchset or at least goes into the
same pull and not delayed to rc2.

> But if it goes through the btrfs tree, we can adjust this to use
> io_should_terminate_tw() after the fact.
> 
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> 

-- 
Pavel Begunkov

