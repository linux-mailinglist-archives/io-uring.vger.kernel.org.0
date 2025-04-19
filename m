Return-Path: <io-uring+bounces-7561-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5E91A9438A
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 15:14:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFDC61652FE
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 13:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1E931D86FF;
	Sat, 19 Apr 2025 13:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="kdMLVfbM"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68D241C3F0C
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 13:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745068453; cv=none; b=sC96BDkMrCta+zZzOFdNqf7paTNKhwF4QrCXu0WwtXI0WYB12kkS19ObDAL+g4DbhxxcLL/QXR88Y5sdMM+IptyKH/89XgoGJPtpLaFU1298Az1vbIVurHTVWfWPFpaX25Jc6r5ncO5p4O0sGs5cauzug655RWpTYaoMnYWKnps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745068453; c=relaxed/simple;
	bh=onrxbMV8iHZ8TsztepkrSg4U/6wxFOZoHDsOc24FZko=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=VxXB4o0cEJR6z2H071gueZOELxvvKSWbHPSiKkRtpRLMQPvUHjsPHL+bCuqYyGfp10tUVIOavDtfgOtJBlP9PNM3t8zfsbgBmPfAvRj6a8hxu7U6XlYRtQDPkTYRtF6OsmC3CUAbx/oCV3uGxbYEvTKP90nAfFFShzIdGOWZAGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kdMLVfbM; arc=none smtp.client-ip=220.197.31.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:
	Content-Type; bh=XA5ok6+ulZKDmDAR9m8pv8LYKrx90sH16rJajLciHg4=;
	b=kdMLVfbMPaE6P4AT8IxQZWqHRTl2AePV7iO/0qD15EFfDdy6Ym4fQU6WwrCxil
	DP1IVddntYKYFu/V4aSI+7NHA0zPOLrN6icNlWwt5nLRLdDTREQz6IdnZdPt76Jl
	PqRdMOs+Ua75jQcGT8X0yjaw97/sg4ch+GXFVE233siuE=
Received: from [192.168.31.211] (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wC3MBGNoQNobeyGBA--.30774S2;
	Sat, 19 Apr 2025 21:13:50 +0800 (CST)
Message-ID: <ff6274aa-6953-4892-8649-a7f82d0e3091@163.com>
Date: Sat, 19 Apr 2025 21:13:48 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH liburing v1 1/2] examples/zcrx: Use PAGE_SIZE for ring
 refill alignment
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20250419095732.4076-1-haiyuewa@163.com>
 <af78093c-9cf9-4e71-8d89-029ab460fab9@kernel.dk>
From: Haiyue Wang <haiyuewa@163.com>
In-Reply-To: <af78093c-9cf9-4e71-8d89-029ab460fab9@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wC3MBGNoQNobeyGBA--.30774S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7KrW8ArWfZF1DXF43Ww47XFb_yoW8GF4xpr
	429a4kCw4q9r1agayrJw1rC3WYvwsxA3W7urWrtFy0vF4qqFZagFWxKrWrWF4xZryv9F9r
	ZwsrXFyrZFs8Zr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zRrgA7UUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiERQ0a2gDmnr0BAAAsh



On 2025/4/19 20:51, Jens Axboe wrote:
> On 4/19/25 3:57 AM, Haiyue Wang wrote:
>> According to the 'Create refill ring' section in [1], use the macro
>> PAGE_SIZE instead of 4096 hard code number.
>>
>> [1]: https://www.kernel.org/doc/html/latest/networking/iou-zcrx.html
>>
>> Signed-off-by: Haiyue Wang <haiyuewa@163.com>
>> ---
>>   examples/zcrx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/examples/zcrx.c b/examples/zcrx.c
>> index 8393cfe..c96bbfe 100644
>> --- a/examples/zcrx.c
>> +++ b/examples/zcrx.c
>> @@ -66,7 +66,7 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
>>   	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
>>   	/* add space for the header (head/tail/etc.) */
>>   	ring_size += PAGE_SIZE;
>> -	return T_ALIGN_UP(ring_size, 4096);
>> +	return T_ALIGN_UP(ring_size, PAGE_SIZE);
>>   }
>>   
>>   static void setup_zcrx(struct io_uring *ring)
> 
> Well, in that same file:
> 
> #define PAGE_SIZE (4096)
> 
> so this won't really fix anything. Examples or test code
> should use:

The original plan is to make the code consistent for page size as:
	ring_size += PAGE_SIZE

> 
> sysconf(_SC_PAGESIZE)
> 

So fix it as 'examples/proxy'?

	static long page_size;

	page_size = sysconf(_SC_PAGESIZE);
	if (page_size < 0) {
		perror("sysconf(_SC_PAGESIZE)");
		return 1;
	}

> to get the page size at runtime.
> 


