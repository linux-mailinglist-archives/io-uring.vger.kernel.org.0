Return-Path: <io-uring+bounces-5063-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 084499DA5F6
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 11:38:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E597B2A38E
	for <lists+io-uring@lfdr.de>; Wed, 27 Nov 2024 10:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAD00193067;
	Wed, 27 Nov 2024 10:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSll/P6/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F097192D7F;
	Wed, 27 Nov 2024 10:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732703703; cv=none; b=k1lKNC8Qi+TGzHQJmGcexoqiF2drjIULJ2EFeJG2UdlU5NmlP+gjVaHME6hDBSgaPxWlOpVyVLzh6zcYGgsZdUBDCL9jToVIYs6cKc8FZjCxda0I2CMlQe04qWueRZilZDsDGM3R+LEYDCD3qFKlTjer29XjrGn4Ta9GkurlR5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732703703; c=relaxed/simple;
	bh=3Wpn5UYrFssZipkh5pS29bUTggjto2nrp9MITQ5FvlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fAdaor/1dIzgSvMFa3qLp1uRRblCjbd+UeqKgkCI7MEoemvZyH7QNa8xo9AvreoXx56bUtqdQHgQVVNrQuFnzwDeo4z50wDdRJEz77P9X6uHpZyAdAzKLbA5F1ANNJFHsbw6+Q5Gyz89syTtLRZVY84/Aw7DFJaXWyxhktUngQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSll/P6/; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3824a089b2cso3996389f8f.1;
        Wed, 27 Nov 2024 02:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732703700; x=1733308500; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9ZlrO5h50BcTQskeYOFGG+Op70eMgkFj46C8sSDAd2w=;
        b=QSll/P6/+pKAW+XwaWtPG0ag7FmIpWx/KVGQhiH6z6y9o1xH+krpAlHkFEan3ZRY7W
         7DxKTR7yNy7WHb1sfi/qDZj1SMxU/LUebggHWKRBQDCb7Qehd+nA+WCHv+p9K2keWBX4
         yT86lqFv/91LTy8yihxoe0fQkxHK31TXu40bCE0D5ZtK7yC+r/VUjKCluhW8z544m/Cd
         lL8cLfa2+nrFnw+k2m3iOiLEyb2QvOMyCIyZQmzuBW9JLnuBMD0llAAVwV2lDuLKmEo+
         2n29Dla4kQuTUvORF80bq7isNh5Du3MLDLR9EPPV2WuvpJJHSxP+zSz+yCgsE16RwU/B
         G6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732703700; x=1733308500;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9ZlrO5h50BcTQskeYOFGG+Op70eMgkFj46C8sSDAd2w=;
        b=iUk3TvRugStLKdHwIgDns9AjujvOhY1q8WeY5jq0Yp35esB3dCeHWBoH91oDL5FJkY
         x2lUf6K7ymbbhwNdThmoBgT7Wqee3LI6OKAXwki/tAMowNfU8gU0emilFB28moPGet/i
         FSm9g2ospE4bsglnESfK7/TY6kBUclkRYXFOcm26Uink/peCQpyfYKoGAXsrNXXryPeK
         rkS9/okgNp31enzbpEiae8StCND5dPPdCVVKz6OHuaHOPBHeG/Xl/k2y/IUOK0MEW9cF
         hmorQ7lV1AegNh+gZKxqmb7x9XRl+SF+4mY98kFM5w4zdIPrEQ3kqQYO6ope9Mzkx1OF
         goZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUd3S4j/8+sDUM00ylpc1bxo6kOngjVNkuL0Pd/kDGUlfrGJvf5R1gPm0Lb8hBl79mXnG9RC3jfclLoaAA=@vger.kernel.org, AJvYcCVqRZgQJ8Cvp6SO0aqTO0WHMpwYAFxXvagc5DFan1mx4jQYMBvGtJzPK4C7lzTk8KDf0SrxfbcSFZpHcvNAyw==@vger.kernel.org, AJvYcCWXkN0qCVHxs+4demj4CQVk9YsVrM1pE1O5smagIVSwW0A0XS0GXr9wXsE1f4B4fp2R674n971O5fV8yQ==@vger.kernel.org, AJvYcCXDb2EAfvHMkaCjccRpJ1H1WKhq859O6NBVoTqpbLOHOopoh9N9n+0T5bB+RpiPM2H8Q8125G4/OQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwZf2sekUgHkdy3F0kOgWKLtR7xQqL4+PFlmzynIOTQhqXtgoxS
	4Eg3ubKefV9OdUcUyr03N3hE7MucaSx/P7o6ECKPRd70EclFQJNK
X-Gm-Gg: ASbGncs6wlSQdJJz1fQy3FIX6+m5G55JpMcPsP2Xov9eyISsq7b9VLrd7NxCJaJUfTd
	yprDdMjielNpQa7ZAYcuUIybqwKtvliaAF+EgJKY+hDQix8HeSIdOXhJZqAl0xJxi8LbPmsL1c7
	Vi0FwSRGT7A+9pLFuH6oe8kJ98tPpONW0eSMZCyKbAh0e3oTrr960Fnnd0zyd1n6BBcl9E/Z49p
	8SCwtr7mUlvJ13sAmIm4zLoRCr/P+9kEUUIxSyZsmUqzHCJjkPXe759QQ==
X-Google-Smtp-Source: AGHT+IFk0SXZCKGCnlLrTdF+H7B8tOKDqCjKa0psfP+s3ClB+df5BuAqqiAyl+b/3U4nAA+9UpIchQ==
X-Received: by 2002:a05:6000:440c:b0:382:3f31:f39b with SMTP id ffacd0b85a97d-385c6ebd533mr1529071f8f.25.1732703700155;
        Wed, 27 Nov 2024 02:35:00 -0800 (PST)
Received: from [192.168.42.80] ([85.255.233.86])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3825fafe207sm15991312f8f.36.2024.11.27.02.34.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2024 02:34:59 -0800 (PST)
Message-ID: <5f77cc2b-d589-42db-9985-e56bac1da569@gmail.com>
Date: Wed, 27 Nov 2024 10:35:46 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
 kbusch@kernel.org, martin.petersen@oracle.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
 <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
 <20241126135423.GB22537@green245>
 <a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>
 <CACzX3AtBc-Vio1H28MM2tRvcLzTYBTFJt8CKgF5NeGTniKFUbQ@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3AtBc-Vio1H28MM2tRvcLzTYBTFJt8CKgF5NeGTniKFUbQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/26/24 16:23, Anuj gupta wrote:
> On Tue, Nov 26, 2024 at 9:14 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
...
>> This example would be incorrect. Even if it's just one attribute
>> the user would be wasting space on stack. The only use for it I
>> see is having ephemeral pointers during parsing, ala
>>
>> void parse(voud *attributes, offset) {
>>          struct io_uring_attr *attr = attributes + offset;
>>
>>          if (attr->type == PI) {
>>                  process_pi(&attr->pi);
>>                  // or potentially fill_pi() in userspace
>>          }
>> }
>>
>> But I don't think it's worth it. I'd say, if you're leaving
>> the structure, let's rename it to struct io_uring_attr_type_pi
>> or something similar. We can always add a new one later, it
>> doesn't change the ABI.
>>
> 
> In that case I can just drop the io_uring_attr_pi structure then. We can
> keep the mask version where we won't need the type and attributes would go
> in the array in order of their types as you suggested here [1]. Does that
> sound fine?

That should work, the approach in this patchset is fine as well.
I'll take a look at the path a bit later today.

> [1] https://lore.kernel.org/io-uring/37ba07f6-27a5-45bc-86c4-df9c63908ef9@gmail.com/

-- 
Pavel Begunkov

