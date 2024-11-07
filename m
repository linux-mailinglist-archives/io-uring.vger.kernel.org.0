Return-Path: <io-uring+bounces-4517-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB6E9BFC6F
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 03:14:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E3BD1C20C2F
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 02:13:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F111FC0B;
	Thu,  7 Nov 2024 02:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="aE2BWeL2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC61D529
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 02:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730945635; cv=none; b=ptXDdrxWN6cIuGf1NE21Kh6vJlx/DeZ8PwkX+K0aTvw7p03Fu1HN8Ns6kqyQ+9MK+6A1sgLUduD+PdEnjI4aTlWCEix2eQ1+aJQAzB4HFrcjtLkh3pvRGl0nJ/FfqvfrpAE7+zJrrssJJB4pPIAERGjTUP+O3NZzKreuItAHYvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730945635; c=relaxed/simple;
	bh=QmOKJoLbXfCPhoujyLUCs8eC+8ymTGJFjTfT6H8QI4k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z1Y5SbRWPw3Z8yhLEE2xCrB2yKSbK9wKmTpTL7tnqxhXsBuLktDLAlNViHhoYdZBJoSyAUWfPTDs/FiP0/HhwQje//s5WITbS7ljfDFVWSPLEvcS8WeA70xYhN6gkx8OHNKQTmMGjkgFS4tu5QJd5ajWScagi8xomgw1xagHcAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=aE2BWeL2; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-71e49ad46b1so334448b3a.1
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 18:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730945633; x=1731550433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lP/wxxYW0vPUOe2ZOLRbZuJHsjp8tE+TnM0HGbQAiL8=;
        b=aE2BWeL23g1yKhbBROLFVdNrToQa+JEMSYKA4hrwJTj7RNEKU7EdLNSXa/mpVQ2ddR
         M8F4U7+58wKFVWCAKNrRM7dIoeW7VyD+1o3d272U6c/LNIeE0SFZsXH5dRnK+kpd7Nsy
         RHt9nN+pG2C5eRWkSDQOFX+I+CwNfNFEpUeJJhdGWNoOtxlZT3yqBK8ltK/DY0n/Rkxm
         18kX2ANF0w0YlFAzQboB2M23MgitkVcmQxTKeG6EdtlNy3A7S74Xnh483LATR5RqmTqL
         72m5n4F3OV1qe+iMIofaD2XJWwGBMWwQNc/ufrxot2+bUTSFOdSehk/mrkGk223cTZQ/
         lTJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730945633; x=1731550433;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lP/wxxYW0vPUOe2ZOLRbZuJHsjp8tE+TnM0HGbQAiL8=;
        b=h3ZZdQUglq+HwAemRAyFFikDvIsfaJ6FY9EAlOAiqziilvr86rnVt08O1AWX/CFbOA
         FtqeIoBXV7YxQAvyI2c7H7dRLhw1F4WvqLVXFGuJtj17x7xdJuhyOwW/OH9x1vsSFfRr
         wgrDHGmbGrQn4PZZf7UtVdH7jdUubzQw8vO32kL92NvuWZneC0iD48DkWBOZKgoTRBuU
         tObW3DnDNi2QP4KYcOgOhiQqDUnb6AB62E6ZvQYKY8oJdhnxMIGNhaYHc4LMoOVkW7af
         49waxYZJXaxxlBHvjq70+uC6faTVSCWzZiQkELGqZ6DxapMJGp3fbjBJv7Fq2MxK1d/P
         U40Q==
X-Gm-Message-State: AOJu0YyIe4BeAVaRik2+0m+K6gwegcgUAefYVPasLo0QujPtr8tq1gt7
	OOJqquJDcqBAyWNSVbClpoNbjBWBiZpBDVKAY+F81xWcFKCix5fZtkGi+c3QTSk=
X-Google-Smtp-Source: AGHT+IEI+2EDnXUDsL4ApqSMlUwwcThkDyc6C/xIv61vUcxwn/TRearptDuzS2ixi5/9nsrgJRz3QQ==
X-Received: by 2002:a05:6a00:3cc8:b0:71e:780e:9c1 with SMTP id d2e1a72fcca58-7206306ecf4mr59445175b3a.18.1730945632596;
        Wed, 06 Nov 2024 18:13:52 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724079a4177sm264801b3a.99.2024.11.06.18.13.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:13:51 -0800 (PST)
Message-ID: <08c15db1-288b-4190-9b97-ccd7ff9519ff@kernel.dk>
Date: Wed, 6 Nov 2024 19:13:51 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V9 3/7] io_uring: shrink io_mapped_buf
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241106122659.730712-1-ming.lei@redhat.com>
 <20241106122659.730712-4-ming.lei@redhat.com>
 <44abdb96-3210-45d2-b673-ec2eb309bac2@kernel.dk> <ZywSJCDsogZ0wl_o@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZywSJCDsogZ0wl_o@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/24 6:04 PM, Ming Lei wrote:
> On Wed, Nov 06, 2024 at 08:09:38AM -0700, Jens Axboe wrote:
>> On 11/6/24 5:26 AM, Ming Lei wrote:
>>> `struct io_mapped_buf` will be extended to cover kernel buffer which
>>> may be in fast IO path, and `struct io_mapped_buf` needs to be per-IO.
>>>
>>> So shrink sizeof(struct io_mapped_buf) by the following ways:
>>>
>>> - folio_shift is < 64, so 6bits are enough to hold it, the remained bits
>>>   can be used for the coming kernel buffer
>>>
>>> - define `acct_pages` as 'unsigned int', which is big enough for
>>>   accounting pages in the buffer
>>>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>>  io_uring/rsrc.c | 2 ++
>>>  io_uring/rsrc.h | 6 +++---
>>>  2 files changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index 9b8827c72230..16f5abe03d10 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -685,6 +685,8 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
>>>  		return false;
>>>  
>>>  	data->folio_shift = folio_shift(folio);
>>> +	WARN_ON_ONCE(data->folio_shift >= 64);
>>
>> Since folio_shift is 6 bits, how can that be try?
>>
>> I think you'd want:
>>
>> 	WARN_ON_ONCE(folio_shift(folio) >= 64);
>>
>> instead.
> 
> imu->folio_shift is 6 bits, and it is only copied from data->folio_shift(char),
> that is why the warning is added for data->folio_shift.

Ah yes that is fine then, for some reason I read that as 'data' being
an io_mapped_buffer.

-- 
Jens Axboe


