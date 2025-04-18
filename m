Return-Path: <io-uring+bounces-7546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 995F9A93A1A
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 17:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B010463415
	for <lists+io-uring@lfdr.de>; Fri, 18 Apr 2025 15:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34268214227;
	Fri, 18 Apr 2025 15:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R7Lz2CfH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F235214236
	for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 15:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744991451; cv=none; b=TU1q1pGiKwuC82CXFb2da5yPpZHsYBSi5yl5BtNCg9+mKsfDmTzr5SovuAQFFlvONeJ4IJoSicsVIAt7yDYSYt+X1CWoPvhIi5rf76qNF4lhLM3lkd5GJzPfJhzYQZXtAKLWZslOUxhLXnqnRfYBpQh9JnfVMIIDtQpfGGNPcEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744991451; c=relaxed/simple;
	bh=J7szO2zD1SYsvDbLGhdzlhfEBH4HgcFRYKalDR2Ee/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IKB+fjr/ZgjG0Nk8OMxkrvREnPPufy14uAX/Y1qGML3+dJBreMoRwJpeNwf3O3OxQCfFT6ZNYfIn0nBNs2e/J6zEwaGkOWi8ubTVKCZpzw3yX+6UQExWnKbyfZssUyGv4ZiNqp1KaNINth1u6BRYOrdG3AQ8lfqt1ceJr6YSbV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R7Lz2CfH; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-39ee623fe64so1715912f8f.1
        for <io-uring@vger.kernel.org>; Fri, 18 Apr 2025 08:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744991448; x=1745596248; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n8Rp6wrJ/8ysRjWvWeJSPHwJsuVnhnnZRj3EG0+L6bc=;
        b=R7Lz2CfHvGllziXiuoU2ewJWm3XT4rhWFDXVHIq89AUQG8G/Bgxjf55CsYk5WajnKs
         dgwRGQxrlFXGB4IZGDjOzN5EeIxWHSsc5JsQZORDMptg+6ZGexLHRa7nmCoCC7GeRpxE
         NzhwIPC/yYL2JJUlwY1HlCX7wD0vrzOk8E+RaWYfFLboD5lMyjy0x60c5YaZ6KcYgR+S
         F9Um7TvXRRZIhGuqDPBbEiP3O7slHaFd+u/ZJ13YCissgq0JO4bPRYD2M0nu6C9TyPh1
         gTeYYEfQDXKBN11Z82nDWGVbpVXh67GtfihVfWCq13Aq5rkYfYY0TfgvmpgSqFSIKDrK
         EHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744991448; x=1745596248;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n8Rp6wrJ/8ysRjWvWeJSPHwJsuVnhnnZRj3EG0+L6bc=;
        b=VOLfxep6TSL8FVX8UzPJ5ZVoA195ZQCI8eejrbviCcu0Qg7llpgqV3Sciq4mSrKEZY
         JVGvCFK2CR4nfRrDTP9S5iZkHkQg/edDtZXKtDNH7no/k+hqa8hKq6/+PPBO34PVe3KC
         u/98++SRZAoC8rzYeQQiNDWhHlzjjy6M93A8Y9C0ynhv57KNn7xtLVblZCXND8nMCe7g
         ZKt+FUw/wli5ReGOBPdf+vaF8YKHrxWFXtR2LBHW8Ciky0HBPXLmeBiGcvC2iasAaReL
         8TByAe264TdD4TkQ2mM7bPhVzt8COoYsUGmqKaVxi3hvic0Oj7YzE39x1rNWHMOG6IWI
         YgCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQAPjUHwGKZ/jd6wjs/NGouwEFM2go77AXdV6lbB35RCkahxmkAaONJvm3Dh2zWS9WkkAOSZU2bQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLaKgsN0IlnQW7CFzn48dg6kfjLf5aOgQ4ICoaE8Dp52tdpH1g
	keFdcijVKvZtUw1ReK6NEj+7hYF3LyyBHJnvN2yd9guxeTlmpQ8kn8r7fA==
X-Gm-Gg: ASbGnctqDIV6whOhWRsOgCpT6Gl0bxbnEppkoNXkyQFeAqcnEOSN+XWUP1hLPgRf6OU
	L+xPhWBx5DtYXXLOVj3HrfgsKPVF7npM6hFkHFZiDZiUdopB66oCxZkSkZ1ubO0Pp/5gFL/ztxp
	EyFwrLiS6RRbwvjjPj24tXMbRbuwSuA7FY2mENSPXUiU/9LPR/5sfoXqTAHHL3AwOZyM4G0w6VM
	jUX1blasgvgktqMsIww/bA+RktSNcQ461PnL7M4k9WwRuR56ZNQmA9fk6QrCwJVxp7iya7XcADJ
	NKHIFjc7xDTOjQslPR2eB0H2zkYPH3LjuqeYc+cnNNCs9et7Zw==
X-Google-Smtp-Source: AGHT+IEnT+L8HqXC8Nh6TUcffYZJesPIqAJ5+ivkE3DeI9/bhAgT/23NRkrVEHRB+w5Tg4sa0vKuzQ==
X-Received: by 2002:a05:6000:717:b0:391:4231:414 with SMTP id ffacd0b85a97d-39efbace967mr2535753f8f.40.1744991447520;
        Fri, 18 Apr 2025 08:50:47 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.40])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39efa433133sm3063938f8f.28.2025.04.18.08.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Apr 2025 08:50:46 -0700 (PDT)
Message-ID: <99dd671f-5d4c-4742-816c-264f521ca78f@gmail.com>
Date: Fri, 18 Apr 2025 16:52:02 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring/zcrx: let zcrx choose region for mmaping
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org
References: <cover.1744815316.git.asml.silence@gmail.com>
 <83105d96566ff5615aacd3d7646811081614d9a0.1744815316.git.asml.silence@gmail.com>
 <f0dfc45a-6916-4c1a-a917-2c0a3f05c8a7@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f0dfc45a-6916-4c1a-a917-2c0a3f05c8a7@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/18/25 16:35, David Wei wrote:
> On 2025-04-16 08:21, Pavel Begunkov wrote:
>> In preparation for adding multiple ifqs, add a helper returning a region
>> for mmaping zcrx refill queue. For now it's trivial and returns the same
>> ctx global ->zcrx_region.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   io_uring/memmap.c | 10 ++++++----
>>   io_uring/zcrx.c   | 10 ++++++++++
>>   io_uring/zcrx.h   |  7 +++++++
>>   3 files changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
>> index 76fcc79656b0..e53289b8d69d 100644
>> --- a/io_uring/memmap.c
>> +++ b/io_uring/memmap.c
>> @@ -13,6 +13,7 @@
>>   #include "memmap.h"
>>   #include "kbuf.h"
>>   #include "rsrc.h"
>> +#include "zcrx.h"
>>   
>>   static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
>>   				   size_t size, gfp_t gfp)
>> @@ -258,7 +259,9 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
>>   						   loff_t pgoff)
>>   {
>>   	loff_t offset = pgoff << PAGE_SHIFT;
>> -	unsigned int bgid;
>> +	unsigned int id;
>> +
>> +	id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
> 
> We using the same IORING_OFF_PBUF_SHIFT?

Let me check that, and also it likely doesn't return the right
value to the user as well.

-- 
Pavel Begunkov


