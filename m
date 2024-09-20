Return-Path: <io-uring+bounces-3241-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB9E97D111
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 08:16:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC9F283FCE
	for <lists+io-uring@lfdr.de>; Fri, 20 Sep 2024 06:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 277D52746B;
	Fri, 20 Sep 2024 06:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AFeeyDvx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0244DB644
	for <io-uring@vger.kernel.org>; Fri, 20 Sep 2024 06:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726812990; cv=none; b=Kx4FHLvIzinpO6oEAr5bxr8oAnbEnq9ebYgFl4uKLJRsPSUEM9o61OZrETOQ1A2vteXA+cA4zXFHkr3S1Stw946Aha3YULW+SkyP4OKI6nmdSsxYB4lEtc0tAY1ToiwkaNTbtP6zyIC46wSNbiDbLOm73WqXFP9MSqg56NDrI6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726812990; c=relaxed/simple;
	bh=x82bL5TAamfbaREGO0OOWbVhEsTMQhs6jHl9eoqOSRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=COxS+C+zgN+xtYP+dVEvWSiM3NZ2/OeNQMgaEIgivmZvAhhuOzotaI63Zq1ViIrpHQvkWZRvrkKMiniZDlcpQymlIT8dlnNO2+b4t7bm2cS4UY10P7Kdil1S0/ZhQ4/m/4kCVpsuso+2gFl2n0amKPHBS171x3MZapJ1ibOH4CQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AFeeyDvx; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4280ca0791bso14974825e9.1
        for <io-uring@vger.kernel.org>; Thu, 19 Sep 2024 23:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726812984; x=1727417784; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6RCv/rgK71GW9hmAjLRWGCxlDYvnMXge9G1nQFmSKjA=;
        b=AFeeyDvx0cJA7eVgLVmgWQDI2oT1ck3DV4J0hzV2JmFutiWmwow2/137zqf0OElD2/
         B8lYj2KOtd4km7n9U4JXpL4Uv/hs4cSa+hFT3SG3ACIjey4jXO4hoMtDfVK/bKqK8dF2
         rAY0Hwv+wAWCQ0AIHi8h46ms456kr6ZP0IYeVVEUVvHs/9UURxM0lFqbDHlENiEhRDdF
         bXjGVU1K1vOQ2foJkrmUApJyW/Czn7W+g5HSMVg21VlN4ymP5qbyeYg4foiHViRCphIg
         LGImQX3I3pOxfSHhsrVR8nMwmYNFSgycdhYYoE0iK+qpjwsLiRYLrfFJdJAOhfTjbXRa
         jD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726812984; x=1727417784;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6RCv/rgK71GW9hmAjLRWGCxlDYvnMXge9G1nQFmSKjA=;
        b=BUexE3WM7wpQeaCXasOR9LwTaQCkUcXrj+geIj8HR0/AwGXaojJjBXSh6Z4aF5vZQm
         JdYKbIJ3Tl2Lu5IYoSAzMpjdPlzVRXiaMVcVRrnvHLJfXUypoGFKLupRmamisw2aoVeK
         pRrVfZLVryXMRy3CNYvf97f7SHvYp2S+G96VbxOnL9J4e9Mb8g53/5oiBVpJ7QPBtFDY
         rEYKyIruQDhlL/9pxh2+eJW6Mw1650qZPYSDdWYrGwE8OD9WzIjRW+AXCIinlL97lgXx
         rEQz0fvUTHxegmFWGE/1DKdo8QBGZGWV0CCX/To/I8DXhdO4PKHpbE4CkjdVcFNwJlyK
         uRHg==
X-Gm-Message-State: AOJu0Yz+jLJdjyTAiA2Msc1ZphB4R+VJzu1aAQPeD9lkM+KZxTMJkyEr
	vVG0eRzYYfWWhs9PLTH3MaSVDM4w0HGJf9DTuCib87F73mUvhVASKldy9qp+ivPcBYIVAr7UGeD
	JBiRZOA==
X-Google-Smtp-Source: AGHT+IGDYapQ/bcvovesPF/uFJ8EcwWgvFd95QrMcQCJAhYnoNVKRLcsfTH527NOVxEOb3BLZlmJIA==
X-Received: by 2002:a05:600c:5101:b0:42c:b97a:5f7d with SMTP id 5b1f17b1804b1-42e7c15a14amr10295825e9.7.1726812984530;
        Thu, 19 Sep 2024 23:16:24 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e7afa9c93sm13175485e9.18.2024.09.19.23.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Sep 2024 23:16:22 -0700 (PDT)
Message-ID: <1c02959b-030c-4993-b566-8b72b682a8e0@kernel.dk>
Date: Fri, 20 Sep 2024 00:16:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring: add IORING_REGISTER_COPY_BUFFERS method
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: io-uring@vger.kernel.org
References: <20240912164019.634560-1-axboe@kernel.dk>
 <20240912164019.634560-5-axboe@kernel.dk>
 <87jzfagrle.fsf@mailhost.krisman.be>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <87jzfagrle.fsf@mailhost.krisman.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/24 10:41 AM, Gabriel Krisman Bertazi wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> Buffers can get registered with io_uring, which allows to skip the
>> repeated pin_pages, unpin/unref pages for each O_DIRECT operation. This
>> reduces the overhead of O_DIRECT IO.
>>
>> However, registrering buffers can take some time. Normally this isn't an
>> issue as it's done at initialization time (and hence less critical), but
>> for cases where rings can be created and destroyed as part of an IO
>> thread pool, registering the same buffers for multiple rings become a
>> more time sensitive proposition. As an example, let's say an application
>> has an IO memory pool of 500G. Initial registration takes:
>>
>> Got 500 huge pages (each 1024MB)
>> Registered 500 pages in 409 msec
>>
>> or about 0.4 seconds. If we go higher to 900 1GB huge pages being
>> registered:
>>
>> Registered 900 pages in 738 msec
>>
>> which is, as expected, a fully linear scaling.
>>
>> Rather than have each ring pin/map/register the same buffer pool,
>> provide an io_uring_register(2) opcode to simply duplicate the buffers
>> that are registered with another ring. Adding the same 900GB of
>> registered buffers to the target ring can then be accomplished in:
>>
>> Copied 900 pages in 17 usec
>>
>> While timing differs a bit, this provides around a 25,000-40,000x
>> speedup for this use case.
> 
> Looks good, but I couldn't get it to apply on top of your branches.  I
> have only one comment, if you are doing a v4:
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/uapi/linux/io_uring.h | 13 +++++
>>  io_uring/register.c           |  6 +++
>>  io_uring/rsrc.c               | 91 +++++++++++++++++++++++++++++++++++
>>  io_uring/rsrc.h               |  1 +
>>  4 files changed, 111 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> 
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -17,6 +17,7 @@
>>  #include "openclose.h"
>>  #include "rsrc.h"
>>  #include "memmap.h"
>> +#include "register.h"
>>  
>>  struct io_rsrc_update {
>>  	struct file			*file;
>> @@ -1137,3 +1138,93 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>>  
>>  	return 0;
>>  }
>> +
>> +static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
> 
> 
> The error handling code in this function is a bit hairy, IMO.  I think
> if you check nbufs unlocked and validate it later, it could be much
> simpler:

Sorry missed this due to travel - this is upstream in this merge window.
If you want to send a cleanup against for-6.12/io_uring, then please do!

-- 
Jens Axboe

