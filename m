Return-Path: <io-uring+bounces-6772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD95DA45354
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 03:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 240C31642E9
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 02:46:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB7C21CC6D;
	Wed, 26 Feb 2025 02:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gR5DQUub"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B98921CA09;
	Wed, 26 Feb 2025 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537940; cv=none; b=SyVcIhHaTRJQ9RoA/166/n25qRIpriCp/XUW+lg2jEWoSEtSTv9Ce/8XXzxsS5ye5kFGDHboDzl4LSId0HtCpZbhn5baIKU/z01D95NDGPEZ5Md1oVD848fJcwyb/voWrdvezKW7331uIxpogBBD5EQgbeBMOPEvKX9zVBVHEo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537940; c=relaxed/simple;
	bh=1t/UK8fwolX0tzMlFLtSZXHHRjXoEdt8MtlhpZuseZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EKZVDxkgyDL/Wi0DNmmKkTKDf/Z4RetYfMilCzie1GQJxxxOr4lhdG9kISDBKNcGT+C3loLVca80sUhecBnUmt6ChGPtZxAkBF94t64k6PTmEhiV/HRyh1Ys4O7k9/I9HO7aYnm2gM1fMs+ow6jJmcdiiREKP+UJ+7tBlYYmQhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gR5DQUub; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aaedd529ba1so731932166b.1;
        Tue, 25 Feb 2025 18:45:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740537937; x=1741142737; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ClOCb43QOYWf7pEWcrwi7W/0a+GT2X1dE7IJGHH0lZ0=;
        b=gR5DQUubHBpOPRHaEhVO/aJDNxEci+NxF6DhyB4L5vnvj2AxiYdhTqnBVRFuJN+e4M
         Z5UkbaziXw4absNsLb4YydQSfmfidiDIV3nl6TxaDcyXj2wvmE6WD1DkjkGquP6rEbcK
         JOANh61Z5WskXPosLH12oV8DfcU8pQslqH0FAZiIbmP5W/n6triW9vJHLa+8XW+B+h0C
         N0zaLkGz8rrPs1K/3Va0TV9vfVmuF8U6D9/jVahiHHFyi8YRCs4nCn5rwsKGc3XNpYx/
         xq3qN4TF36UwyiWbD7GuRa2BsS7GYVU8ZekLshhqOPL4m5y+u7BZbWkElMJGT2ZYL+NI
         nEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740537937; x=1741142737;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ClOCb43QOYWf7pEWcrwi7W/0a+GT2X1dE7IJGHH0lZ0=;
        b=oDAZ3rzJ/rs8zLJ12zt9rJK6/Cg+ZwG56W4UM4e6NFWipItkW1OUIEGzldCSDB2wty
         dnIvBWp3p4fxKKKaK/0Ek0AQAWtZSI2nBik1++d4Ve07+Ze6HoRbt2WIjmWiJ9Zojwb7
         20WM5PHpAhmY+S3y0wA224vZ7JWh1bL0i+fKEnN6NJJPhRJtWKe4cUsTbPfICfpdSCDD
         2GEm9PWEbhviruugZUzB5bV0IxJlMkJonoFrA089SzA4HcwCXpGwojBpBqcAGXTaPagv
         E0jPyfpCA3V34lwuvGG6YXRnFfD+Xr5limegVI3f/E/RkZDtDX7YpnNt1xxUsCUYrXnD
         UDow==
X-Forwarded-Encrypted: i=1; AJvYcCUfMag7ii01sQa37myefGAt+SQOUWuhkDBegWczGxs/5iGfoZ+4UjR79+S/hpGycwIxBj3T3AdPh9u+@vger.kernel.org, AJvYcCX1DgvtRZlmGSC3sYbYIMP22nfFOUgIJSxYYxPBz+o66/SM2JXTFQgUFoOqKxaSA1NNKWOZX8t/aQ4zckCk@vger.kernel.org
X-Gm-Message-State: AOJu0Yz3k59PBpsC0/BB83qe3L33gLZddEatk9Gj9dk/tk6UD9D8SJ5q
	oG2Y0WST3M9xkk6Gxvdb9rWaJaN9qQexGiNT7RIwF1BJUhnH5zvB3rgfUQ==
X-Gm-Gg: ASbGncu+gT8sv1mnR67NuQICjjnYnlvpRgWB5wsYKyPCYS1XO+RJFgXAl74ptqlIOoI
	knQmbbgPPy8DySGnXdpYi6yKKi2WGf/Aicknb0MNWw0SS0wi2EOtcMuMJN7Bto6vrIXalHtT/Hm
	j8lcDR+yEsRR4bRwzEGzIoAoq1OF42hIW9zPnwPtXcgFLPA8GXkdQjAYTwdGo87qqfSVnF+9buD
	0jNUoNsboPLAbxX5cWTd7yManBl+z6aDsLef0QnpXIvk4P9C6kRqtW+6YJk+oufffDnmTFsya24
	ETPm/zlpV7JOTC705xCHVfR9W7vFoRqTCg==
X-Google-Smtp-Source: AGHT+IGkJ5hiJxQZNCY3voxHVuFTQXBPbgv4dk6BnOTL0vy8WN87/zd+SF2pa6vBcGctMh4MgLckCQ==
X-Received: by 2002:a05:6402:350f:b0:5d0:bf5e:eb8 with SMTP id 4fb4d7f45d1cf-5e44a256d6amr12037364a12.23.1740537937080;
        Tue, 25 Feb 2025 18:45:37 -0800 (PST)
Received: from [192.168.8.100] ([85.255.235.21])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed20b81a0sm240790466b.180.2025.02.25.18.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 18:45:35 -0800 (PST)
Message-ID: <19e0b12d-f2e0-4e49-b9b7-cb23d313cb20@gmail.com>
Date: Wed, 26 Feb 2025 02:46:32 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
 wu lei <uwydoc@gmail.com>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
 <20250226015334.GF6265@frogsfrogsfrogs>
 <543f34a8-9dad-4f63-b847-38289395cbe2@gmail.com>
 <20250226022032.GH6265@frogsfrogsfrogs>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250226022032.GH6265@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 02:20, Darrick J. Wong wrote:
> On Wed, Feb 26, 2025 at 02:06:51AM +0000, Pavel Begunkov wrote:
>> On 2/26/25 01:53, Darrick J. Wong wrote:
>>> On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
>>>> There are reports of high io_uring submission latency for ext4 and xfs,
>>>> which is due to iomap not propagating nowait flag to the block layer
>>>> resulting in waiting for IO during tag allocation.
>>>>
>>>> Cc: stable@vger.kernel.org
>>>> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
>>>> Reported-by: wu lei <uwydoc@gmail.com>
>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>> ---
>>>>    fs/iomap/direct-io.c | 3 +++
>>>>    1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>>>> index b521eb15759e..25c5e87dbd94 100644
>>>> --- a/fs/iomap/direct-io.c
>>>> +++ b/fs/iomap/direct-io.c
>>>> @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>>>>    		WRITE_ONCE(iocb->private, bio);
>>>>    	}
>>>> +	if (iocb->ki_flags & IOCB_NOWAIT)
>>>> +		bio->bi_opf |= REQ_NOWAIT;
>>>
>>> Shouldn't this go in iomap_dio_bio_opflags?
>>
>> It can, if that's the preference, but iomap_dio_zero() would need
>> to have a separate check. It also affects 5.4, and I'm not sure
>> which version would be easier to back port.
> 
> Yes, please don't go scattering the bi_opf setting code all around the

Sure, even though the function already adjusts bi_opf through
bio_set_polled.

> file.  Also, do you need to modify iomap_dio_zero?

Is there a reason why it can't be hit? It's in the same path, and
from a quick look ending up there seems as easy as writing just a
little beyond the file size.

-- 
Pavel Begunkov


