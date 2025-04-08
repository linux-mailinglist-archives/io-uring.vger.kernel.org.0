Return-Path: <io-uring+bounces-7434-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71462A815BF
	for <lists+io-uring@lfdr.de>; Tue,  8 Apr 2025 21:22:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A55323AD776
	for <lists+io-uring@lfdr.de>; Tue,  8 Apr 2025 19:22:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068B717C91;
	Tue,  8 Apr 2025 19:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MpI9x2Ru"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7060B20E332
	for <io-uring@vger.kernel.org>; Tue,  8 Apr 2025 19:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744140163; cv=none; b=OmxB/82hbnEqquI0UYXDxZp7g5sv49xPVsRaWKeJFfsrPTfh6cfJOo263mStc+0W1G9PRiXdZGPIN2PMaolAtlDJcTd7o98w2k4At+68eVErtppuWXF4U+zctMFnkuiPq7dlP7MHUvjCXCKxS+hnYcXyF64sbfBnBK69jaLBSWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744140163; c=relaxed/simple;
	bh=cyWiAO1F+ck3wufO38yfVfZMUxByyoYpBEG4/cla5PQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fZy7nc7smMxNqVIugwaRk16h4fzNtppXlcVaIPfzeUKyBXYsScbp5y8RpdMrLZgzBHIMz0OyhvHzGIiUyyg4lDItYhNTcj2AVo+dWbI5ZgFhGBHZQY6yiXmwhWwiM01Nz07vECcd2/9oN4nKHj5cEjGvQO1pAMT7wvSR5rfLyco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MpI9x2Ru; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86135ad7b4cso73657639f.1
        for <io-uring@vger.kernel.org>; Tue, 08 Apr 2025 12:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744140158; x=1744744958; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rOgalVljpRqYXcaMbe6L63KcQ/EhYTQhQ9hKYvApvQc=;
        b=MpI9x2RupKxULhH0h3Ky1txl+qVlYGfD+olN8TfR9MPz1JOcVQXUr+FaqeklZGTo9+
         TJwKC+UwhxMy0kLLhPJYuvL/Q5DtsfxWVOGPRRGftCuqninryMcLD+3R7aNMoJswq1Dx
         x+8kBg2oVRDrR1c5UNdrlCnD49CUALPDvhMXroIIyepkOv6vftoTgDjxQw49NyR8emPH
         XdfutU+3yuyLuvSZRTTKF77nufaAgXeV6VXj9147xyOnLuvHvBTgDkNhZ1k/zdT1yaGJ
         sHaoqZ/bSoLvEj5oEpDHk8N8kr+8Scy59lqjeziiCrvC9xBUEJ2Klr183jHxuDEsSWmt
         a5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744140158; x=1744744958;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rOgalVljpRqYXcaMbe6L63KcQ/EhYTQhQ9hKYvApvQc=;
        b=CGht4CsvoJrv3Jm1kxuArM42+bSuOQWwedmv2SmWaBN8AfJ3hCkG8f2PfojxhRR9IY
         y6cCMcc1kyIyITP8FmzpbrM3C3K9vZUDX2v3wC5VMRk/pPNgnwUbzOCYIKUYekh2Sxiz
         Ieo5NntPezOs2thzAGENrJqYl/QBBf4vqWIRc8FtWx8bRYD8ShPTeV4jF7HUf2TR/Ncf
         84rOlsjOn0ax2RhmWB3Vb28y0yuqADwCiSRi0vMTMTDLYa0Lzn9heRgebx1z0hMADrbM
         0AIpq3A+9EhtnWKbzDCXbM1wbyQ2zpkIOqCcfCAlejELC90F/MCscH/R04Tn70we/pxC
         d7Bw==
X-Forwarded-Encrypted: i=1; AJvYcCWcXIBvw1dLjhuNSzpivXJGnVH659qBKJxk3Nh9VuFYotTW/Du89BIvOXdHrks6qJ6NF7i6RKYq8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyekDF+8SwwnNJn2gd3cHUloLUS2wcODbnU+ueJV+vMq4e7yE4X
	OqAryokrKX0AtU52b4AO6LgNSBhkXdDw75Zv4pUVyqunEMHoZOuAfZoqWKZKVxLpebQ2vAufc+G
	W
X-Gm-Gg: ASbGnctZyP1f+LHyQGLP9uc1/de+r5q3wIPPtqLT2kTrGUcRNQ6/AYBobgAzIT4pQHl
	IGu/ZPryI/hKSdJI+05R7177GiS6GxvMc6voP1rkLDd8tVMlUTPXnrK3YK6UvDIJbzM0QbPIHu0
	qrZnywyOHbILy3k9sUJQcEwQy38LyyvOsx+pJ2ZqkAnujLmcwAEVQi/Pbhdgs2lrMrY6dRrHO7x
	+9pSiIye/xI1TGPRvzCPodFXfhAKnYzEpTQaSaFDUibGw3VxtC/rfAVl+CxWKSKpKZCpVV1WZL3
	UFdyFP0NmDLduFACO0sXUGh62+dQhQJQ4g6F27vC
X-Google-Smtp-Source: AGHT+IGd+NqjUncx7BfRfuo2rCi8OfI/LYa+5AeV2IlKoGr3AZal2gujQLKVsl6vZByoY8iIGqwF/w==
X-Received: by 2002:a05:6602:7284:b0:85b:3885:1595 with SMTP id ca18e2360f4ac-861611919b7mr45563939f.3.1744140158408;
        Tue, 08 Apr 2025 12:22:38 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f4f43d5477sm631701173.54.2025.04.08.12.22.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 12:22:37 -0700 (PDT)
Message-ID: <27a391b1-80a1-43ae-9550-73f48c1b8fea@kernel.dk>
Date: Tue, 8 Apr 2025 13:22:37 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: consider ring dead once the ref is marked
 dying
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20250321193134.738973-1-axboe@kernel.dk>
 <20250321193134.738973-4-axboe@kernel.dk>
 <c84461d9-3394-4bbf-88d5-38a4a2f6dccd@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c84461d9-3394-4bbf-88d5-38a4a2f6dccd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

(getting back to this post the merge window)

On 3/21/25 3:22 PM, Pavel Begunkov wrote:
> On 3/21/25 19:24, Jens Axboe wrote:
>> Don't gate this on the task exiting flag. It's generally not a good idea
> 
> Do you refer to tw add and the PF_EXITING logic inside? We can't gate
> it solely on dying refs as it's not sync'ed (and the patch doesn't).
> And task is dying is not same as ring is closed. E.g. a task can
> exit(2) but leave the ring intact to other tasks.

It's not gated solely on dying refs, it's an addition.

>> to gate it on the task PF_EXITING flag anyway. Once the ring is starting
>> to go through ring teardown, the ref is marked as dying. Use that as
>> our fallback/cancel mechanism.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   io_uring/io_uring.c | 6 ++++--
>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 2b9dae588f04..984db01f5184 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -555,7 +555,8 @@ static void io_queue_iowq(struct io_kiocb *req)
>>        * procedure rather than attempt to run this request (or create a new
>>        * worker for it).
>>        */
>> -    if (WARN_ON_ONCE(!same_thread_group(tctx->task, current)))
>> +    if (WARN_ON_ONCE(!same_thread_group(tctx->task, current) &&
>> +             !percpu_ref_is_dying(&req->ctx->refs)))
> 
> Should it be "||"? Otherwise I don't understand the purpose of it.

Yep that's a braino, it should be:

if (!same_thread_group(req->task, current) ||
    io_ring_ref_is_dying(req->ctx))
	atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);

-- 
Jens Axboe

