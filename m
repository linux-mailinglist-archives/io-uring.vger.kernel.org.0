Return-Path: <io-uring+bounces-3983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 39F9D9AEB2E
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:57:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DCE41C2115A
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 15:57:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6AF19DFB4;
	Thu, 24 Oct 2024 15:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="U0ILPL2U"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678021B0F26
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729785440; cv=none; b=ariqR8t9N8MC2JTaamD4KIcXaQxj5uuf9ZCJtGIiV6LkyRbn1BY9fGU1k7BHZU8mb8djINVZOW9iudTKVfb4q1u9iAQZU9ONF8UytJpB5eR7X5Skjh/mP0HBcvSxiuJLJnimgvKewgUO4a2D0RE0IYYsnN6/Uao+iJ/sCnm87Yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729785440; c=relaxed/simple;
	bh=7uxM9ho6gewc9k1763Ke0yJIkYnRfdwYVAX54FI7OF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=rJ5Duwuq3GGGkFc/+671LSyjwf4sALeMQ9K7js2OFTC6XO/zGCHzHZU+aQCYN4Y7jqNmjRfZbFhQZDCJbMxH5mdQHZOLg8VXxvRbTdoP6swfPZDJEfBJJywApVD7RMjgw26B+xqexYCtVLr0mWeId9W6jHbT1XnbIAgdbB+zqLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=U0ILPL2U; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83aba65556cso45384639f.3
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729785437; x=1730390237; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=879SW7c0vU/125E6UaF0FKIhhlzvoqHxcz5vFNwZ8iw=;
        b=U0ILPL2Uq+VBoE6Nxl9tSPapg1vBc3DX6jbG9mlF7JoHkvMtEtASc0WdpQUfV4JDIe
         5oodnsU/WBVJXV9BTT1sAhyt/l1u2n0Aor1XrvrieJdyNCIjL+BZHAIKNXGCU6VBZzoZ
         obdTIB9ON8EbbzTVSDZY/iphNc7Ek/I28VaFuYJ1lqdQEwUj5kmV3AZ76SPeo47OjIHZ
         5NK8FEqlVdvoWqiubncvSMVpdrSKM6TfVsG++hnJwyELYQVVaBgqwuof1fd5L8h3cQQ3
         uq4Cw+X29fY6L8ufoepsJVzuEjy5tvoCVs6IVoEWw9DYHMdxkoOpAgCLbICW6KDvVlrH
         iALA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729785437; x=1730390237;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=879SW7c0vU/125E6UaF0FKIhhlzvoqHxcz5vFNwZ8iw=;
        b=HI+ZOi/VQu4bw1SB5+nZDg5chQr1TaZLsDycmzV13GE3tGMbZ5+ddjDFa/yYlwuZUP
         dXJDJUn7gHPCWLjmJ+d9U4TcAyRrS6NZjryxMmOakJC1OTu8kcg4hZQwo9RDI6RfEKmf
         mH9AirElJqVnOOh1jbENQzR8tcdu/kOPHMVrI20Stzk3bJKT/EY02Z036kwnDFhxoZSL
         JZkua1rzVGBsKHM+9F7JA/989jFIF54n5Imkl/2MDzouSeo9nSqhBt/jUL5kGaHVTrcs
         xHKGdRFAln7zjKcuNW7uEsFzlwj1LiT0B/OvbojmLxN0+9tUdGrHZn4W2Owq6BGO7egL
         rX+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXaSGQJtj8eTa4N3aoZSHvfLOSGTsUQDiWI1RikbLajNRCjka8bgmANo0tCl/6Bp4ulPmQHNaJi5A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzfMzYo/x3QtaIGukmgOZdQRA/OtJ5+o/Ax7YNMcN1+aktq4Qu8
	F8CT+OgeTIri6RfBM1D/IRzHFy6VRpBs44bvs4ynlPUVk/G7tyDnH9hLtD7D/8w1tPFsn7e87/B
	C
X-Google-Smtp-Source: AGHT+IEY/yNTa0txJ4pT/TViloNSgQ2AVGyaSyxSq4a6q74CeZqZDDyyU4Sb0Do7we+yZDmBhF1MeA==
X-Received: by 2002:a05:6602:3405:b0:82a:a76a:1779 with SMTP id ca18e2360f4ac-83af61830femr811071039f.8.1729785437389;
        Thu, 24 Oct 2024 08:57:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a5572e6sm2714246173.57.2024.10.24.08.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 08:57:16 -0700 (PDT)
Message-ID: <c44ef9b3-bea7-45f5-b050-9c74ff1e0344@kernel.dk>
Date: Thu, 24 Oct 2024 09:57:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] io_uring: add ability for provided buffer to index
 registered buffers
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20241023161522.1126423-1-axboe@kernel.dk>
 <20241023161522.1126423-6-axboe@kernel.dk>
 <34d4cfb3-e605-4d37-b104-03b8b1a892f1@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <34d4cfb3-e605-4d37-b104-03b8b1a892f1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 9:44 AM, Pavel Begunkov wrote:
> On 10/23/24 17:07, Jens Axboe wrote:
>> This just adds the necessary shifts that define what a provided buffer
>> that is merely an index into a registered buffer looks like. A provided
>> buffer looks like the following:
>>
>> struct io_uring_buf {
>>     __u64    addr;
>>     __u32    len;
>>     __u16    bid;
>>     __u16    resv;
>> };
>>
>> where 'addr' holds a userspace address, 'len' is the length of the
>> buffer, and 'bid' is the buffer ID identifying the buffer. This works
>> fine for a virtual address, but it cannot be used efficiently denote
>> a registered buffer. Registered buffers are pre-mapped into the kernel
>> for more efficient IO, avoiding a get_user_pages() and page(s) inc+dec,
>> and are used for things like O_DIRECT on storage and zero copy send.
>>
>> Particularly for the send case, it'd be useful to support a mix of
>> provided and registered buffers. This enables the use of using a
>> provided ring buffer to serialize sends, and also enables the use of
>> send bundles, where a send can pick multiple buffers and send them all
>> at once.
>>
>> If provided buffers are used as an index into registered buffers, the
>> meaning of buf->addr changes. If registered buffer index 'regbuf_index'
>> is desired, with a length of 'len' and the offset 'regbuf_offset' from
>> the start of the buffer, then the application would fill out the entry
>> as follows:
>>
>> buf->addr = ((__u64) regbuf_offset << IOU_BUF_OFFSET_BITS) | regbuf_index;
>> buf->len = len;
>>
>> and otherwise add it to the buffer ring as usual. The kernel will then
>> first pick a buffer from the desired buffer group ID, and then decode
>> which registered buffer to use for the transfer.
>>
>> This provides a way to use both registered and provided buffers at the
>> same time.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/uapi/linux/io_uring.h | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 86cb385fe0b5..eef88d570cb4 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -733,6 +733,14 @@ struct io_uring_buf_ring {
>>       };
>>   };
>>   +/*
>> + * When provided buffers are used as indices into registered buffers, the
>> + * lower IOU_BUF_REGBUF_BITS indicate the index into the registered buffers,
>> + * and the upper IOU_BUF_OFFSET_BITS indicate the offset into that buffer.
>> + */
>> +#define IOU_BUF_REGBUF_BITS    (32ULL)
>> +#define IOU_BUF_OFFSET_BITS    (32ULL)
> 
> 32 bit is fine for IO size but not enough to store offsets, it
> can only address under 4GB registered buffers.

I did think about that - at least as it stands, registered buffers are
limited to 1GB in size. That's how it's been since that got added. Now,
for the future, we may obviously lift that limitation, and yeah then
32-bits would not necessarily be enough for the offset.

For linux, the max read/write value has always been INT_MAX & PAGE_MASK,
so we could make do with 31 bits for the size, which would bump the
offset to 33-bits, or 8G. That'd leave enough room for, at least, 8G
buffers, or 8x what we support now. Which is probably fine, you'd just
split your buffer registrations into 8G chunks, if you want to register
more than 8G of memory.

-- 
Jens Axboe

