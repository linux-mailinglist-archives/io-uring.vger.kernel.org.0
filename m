Return-Path: <io-uring+bounces-4272-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D9BB9B7D11
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 15:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 706D01C2170D
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E505219C556;
	Thu, 31 Oct 2024 14:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EaF35z7Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A550C156CF;
	Thu, 31 Oct 2024 14:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730385537; cv=none; b=EorgnSF0gZS/zyHvHEBUGmPO8H7zbsD5jxc4VsW+1+V3jVTd0ReLD6jSyWlAZjc2UEvlSX79q5ZHRNhPKAtSEeX2XpcKT5saeqaQw0reqcEFktruCi+yf7qYMynxlJWlkogW3G00aWRj/3RP4KXZ3maQ+iTC+jJNWuaMtJgqUc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730385537; c=relaxed/simple;
	bh=6G7C/il9g/dzmCRVL+rh/gHJAyO9BLO/eAVlrTtKqdI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kr3EnoOn4Qx0yvZOcY9Ic4YDDsx0NNwoTwHLdl0Bt/H2Q4DkHbl9KLYE5HR4sCTyLAyrwsnY+GWAc15iRwbBIsZc++kBFTm48DCsOttbtZfC3MrAMhcDBJJWnDqbgy+YwGTHMJUoDF8Flic9554GuZLbVrbiVSwbkM0XHjKd8cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EaF35z7Q; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a99f1fd20c4so129658066b.0;
        Thu, 31 Oct 2024 07:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730385534; x=1730990334; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VkLkUT2155S8/1ZjBvkJQuF+oTKJuM1LeXuQm4xdwNg=;
        b=EaF35z7QAw8+27bb48NKUVj6QBfr5FebEwHpqmtus2RbpZK8ipUCHKln4D7GXtRv5+
         7nLMxGZngs3s5ZW4U90yhIm0fjgw1XmKlKnpfNNL86n4bn20yii3M76K7Xzr6ZfeyrTT
         x/n+CIFY+Tm8vSx5V7SsBZvnNYfj5tMXMqiDIpkedS2wqltykuQCB6AdUIDhbcc8mOdl
         UzuKo84ZD12SPjDKDTs8TkGEHgwYeGElvArK0oSYPYWw0AvMxWU/SuXZlWHP6mGgJoYc
         5nbQ5kpbMB9iNr0XEgXesNTfrwL3qi4zv/Gg+OE/m+n7a7MaeuuLAgiQMqgByTva6J7m
         enTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730385534; x=1730990334;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkLkUT2155S8/1ZjBvkJQuF+oTKJuM1LeXuQm4xdwNg=;
        b=WKJRBbzLTH6iip1ZfOx/s3AqSdV99rUTsJF75q1vkClyW6TcBIjrE7zXxqC41z0lET
         dJo5ym/Hpq99WlarvVRGvdu8UT7kHcqed3PRtY8ZxXAmiydGtn1XpYTondY6MfGfXKmQ
         9GD3o17CmJDnXyZgSYjJEiHXcQuCx6872EADZtXu9UKTIKtpUivck9lIry7clQR0YsDU
         2Okc6OUG10+hltZGFe6YsHLAzqiSFVos+d8Iwpit6llgMgceu6DMud+cPsQG1sLGRcIZ
         GxlV8FMckFxaf6C7y8fJ6WHlM76XmTw52dSEO5cYstIlfbbe7wR/QqboTFf/MdtBmlm7
         2DjQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4V6sAATbGf6L8J46Me79ApGtpFPL+ElT6LPadkfpr6wPP52vZBQLK6c0KAg50sGtC5Eb4ktWBzg==@vger.kernel.org, AJvYcCVufR4/xh0B5lATxeVHyggVGiRk7r58qsD7L0uck4x/faEXKysLXDw9aK2frvvNPxjNThij4X7nQ3SL9C4=@vger.kernel.org, AJvYcCWEAPGHwmWHJxLZuRot3sltpHdUaCu3ohk6ySr/YetQdDuBlclbP14Dl49RKNoVF4h0+yzS+mLKeA9+4A==@vger.kernel.org, AJvYcCWiPV+SUz3npLU9vUu+KFATdrB0IKyUVH81HHIkjnbRPUFkUSU3pePNiig3g2+88IiKV+2+2ISVPrfKKtgwQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBlQQ41sna3amknwStPOZ7cPBahhqmQWGzsgk9/u7PYtPTQVWp
	w65/N4CBfcUEfJRkC3iCLBKqPjJ5r+sCEZMeRkGIlm2bWJ9jC0Zv
X-Google-Smtp-Source: AGHT+IHgy72+xf0zy2u4ibYnZqijgJyothbCzVyB8LNV+B9H3h6X+CKob8pNbhEshHta/sBwmpYt4Q==
X-Received: by 2002:a17:906:c154:b0:a9a:38e6:2fdf with SMTP id a640c23a62f3a-a9e50ba7dc2mr353194166b.64.1730385533573;
        Thu, 31 Oct 2024 07:38:53 -0700 (PDT)
Received: from [192.168.42.106] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564c55f4sm74922966b.78.2024.10.31.07.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 07:38:53 -0700 (PDT)
Message-ID: <914cd186-8d15-4989-ad4e-f7e268cd3266@gmail.com>
Date: Thu, 31 Oct 2024 14:39:09 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] io_uring/rw: add support to send metadata along
 with read/write
To: Keith Busch <kbusch@kernel.org>, Kanchan Joshi <joshi.k@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
 brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org, gost.dev@samsung.com, vishak.g@samsung.com,
 anuj1072538@gmail.com, Anuj Gupta <anuj20.g@samsung.com>
References: <20241030180112.4635-1-joshi.k@samsung.com>
 <CGME20241030181013epcas5p2762403c83e29c81ec34b2a7755154245@epcas5p2.samsung.com>
 <20241030180112.4635-7-joshi.k@samsung.com>
 <ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyKghoCwbOjAxXMz@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 21:09, Keith Busch wrote:
> On Wed, Oct 30, 2024 at 11:31:08PM +0530, Kanchan Joshi wrote:
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index 024745283783..48dcca125db3 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -105,6 +105,22 @@ struct io_uring_sqe {
>>   		 */
>>   		__u8	cmd[0];
>>   	};
>> +	/*
>> +	 * If the ring is initialized with IORING_SETUP_SQE128, then
>> +	 * this field is starting offset for 64 bytes of data. For meta io
>> +	 * this contains 'struct io_uring_meta_pi'
>> +	 */
>> +	__u8	big_sqe[0];
>> +};

I don't think zero sized arrays are good as a uapi regardless of
cmd[0] above, let's just do

sqe = get_sqe();
big_sqe = (void *)(sqe + 1)

with an appropriate helper.

>> +
>> +/* this is placed in SQE128 */
>> +struct io_uring_meta_pi {
>> +	__u16		pi_flags;
>> +	__u16		app_tag;
>> +	__u32		len;
>> +	__u64		addr;
>> +	__u64		seed;
>> +	__u64		rsvd[2];
>>   };
> 
> On the previous version, I was more questioning if it aligns with what

I missed that discussion, let me know if I need to look it up

> Pavel was trying to do here. I didn't quite get it, so I was more
> confused than saying it should be this way now.

The point is, SQEs don't have nearly enough space to accommodate all
such optional features, especially when it's taking so much space and
not applicable to all reads but rather some specific  use cases and
files. Consider that there might be more similar extensions and we might
even want to use them together.

1. SQE128 makes it big for all requests, intermixing with requests that
don't need additional space wastes space. SQE128 is fine to use but at
the same time we should be mindful about it and try to avoid enabling it
if feasible.

2. This API hard codes io_uring_meta_pi into the extended part of the
SQE. If we want to add another feature it'd need to go after the meta
struct. SQE256? And what if the user doesn't need PI but only the second
feature?

In short, the uAPI need to have a clear vision of how it can be used
with / extended to multiple optional features and not just PI.

One option I mentioned before is passing a user pointer to an array of
structures, each would will have the type specifying what kind of
feature / meta information it is, e.g. META_TYPE_PI. It's not a
complete solution but a base idea to extend upon. I separately
mentioned before, if copy_from_user is expensive we can optimise it
with pre-registering memory. I think Jens even tried something similar
with structures we pass as waiting parameters.

I didn't read through all iterations of the series, so if there is
some other approach described that ticks the boxes and flexible
enough, I'd be absolutely fine with it.


-- 
Pavel Begunkov

