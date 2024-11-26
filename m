Return-Path: <io-uring+bounces-5051-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CD39D9796
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 13:53:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 762C0B2664D
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 12:53:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50A5D1D4324;
	Tue, 26 Nov 2024 12:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q3PexHtl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816981CDFBE;
	Tue, 26 Nov 2024 12:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732625594; cv=none; b=ujY0qDHzXSj4xAOrazI8To6pcbDD+vc7MDE/pfLRKB5KuHtEA5Zo2k2sMawjIYIfHAtu2+WaNfQ5RtmFTSiCpOWyN5BM/EEYSiLXjXleH5qQzworSzadrlFFNVP64tBwnYh02jyKDa6Ve+Ek3K0K/aEK1+zJSOYuABf2kauh46E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732625594; c=relaxed/simple;
	bh=jp2Iqac2vEBsU1gj8PmSJavL3H1RBYLZs9pt9Vz6+lk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gHuyISn+0HOBjkZtkQ1DI0ixzFP4bT252LG8p15Ia/3FpKX8k/R9ME+QbyjKu/m8xzRHQrDKSTB9YrNknMNhu0AUnOh/NA5CYXEGeJwIBUDU1IKBoeMljCcfYJegBnEBN4I1D8RZckFnf3optnspFPbkkVtn4fkYCq5L3br7MaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q3PexHtl; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9e44654ae3so756900566b.1;
        Tue, 26 Nov 2024 04:53:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732625591; x=1733230391; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TYeQkAYIxhkFR/C0PdfSBmynLd1wfKbnNjKfq6tkF10=;
        b=Q3PexHtlcwr9hfgZ9R7h9aQkc3uX+WY7YyTzmhfB/sqpLacd/+f4/1XNAMesZ1kD/y
         xRHo3GbS7goAQW15TvODXq7HeGEQ9jEJW2NxAkcSEWu9rJvqwleVt2dJ3f0qJgTv9Hsq
         CXHW8POTzPD70flvQaHi/fgBaKuUk+RJ8qAFciNZ2UyiLoJAogAVjPjptCIgNIJcLnmr
         /nyFDvjxY0zI0LkAOU5p8hPZ9BGaF71vjwL6tUEReU+LoKw9Nvak1CfrF/ZNpY0uTgTf
         6USl7ndBvxQu6S+Gwhxp+//m27hWklYduA7uVsLqVbH8mqwDadtyb+b8LKr4UsLGi7pd
         2SSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732625591; x=1733230391;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYeQkAYIxhkFR/C0PdfSBmynLd1wfKbnNjKfq6tkF10=;
        b=Dky8D/ANErFcxGCBoe6MU8QMolNU7SzASuN7YBu6b/FUBfQ8UNkOKgp9mgDFeV7r65
         0Mbi55J27mObaUhf0EdDDHRVgCpIbstZooZheInk3bfqj1YIwCHvFsropq5UoKrTnROr
         RJsX8uVovT5+ELp28lf4jDV6JPDoRRAjWpOS3qgDLEz0IvKh6yZTxhN8jjqeJVj2RmkW
         wSalLcEYtNAbwNSfcPPQoOIrnqVcOySi4uotXzjZvLHzVfqjB9GziPohxQFVJVW6dxcN
         jQC0XZeOHhF+pJI9HM5PJK8fuyFBRJS8t04NvIuzwaE6ZfNrXww164FiBYn8SrSNIti2
         Z1/g==
X-Forwarded-Encrypted: i=1; AJvYcCU9h2IurkCq5S3U0QvZCeKVo4fWE7MihHIwTx47LbSocSFeJdepJPQDFRLtQFqvgRRN5HQz+sKOBDcRtLs=@vger.kernel.org, AJvYcCWViGAKDM9Pj9zj5oL8Png55+7JI2EMkehhFLSsmMIqAZwEpRNk3um2tWRvZp8dweS5sw6cGwuYhA==@vger.kernel.org, AJvYcCWd+1i2jB9widXSdo4N8Rch/fgM4AcyAGAbJIC5uwkks56uH90Cp+lfkxXOcCg0Sr8gOrff2udKacp1sQ==@vger.kernel.org, AJvYcCXG7MBiAlbZpOxVc3BULhuwsBwaDe8+huaUNzVyBcMt5wHmCVjq0ZuP8p8HcjWfeMVoUs8mA4/DMaLzipySQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwEp4V32HHMRj+D0rpaurXV1XXTuIyBirsNhRO+7gtWkt68u3uw
	lFBN1kJsIfdi6r6h98GM7nVCWpTNCflMT86xi5O/ygdqWiUBk9/Y
X-Gm-Gg: ASbGncuX0+ImVQUe8ULBaSN33zhR2gCZPcliTm7hSVCiLEB4aevy2YSMk63+uJPrdy5
	dmoLupNy8IT6//oXp7OdRyHTPELK0S6a0H5BVRJuddAd6VjPYTWQZbSWs/dxGNFdtKdjmEACZ77
	q3rCTyMv1Ag5GkkRtEP4OaSYpKpOXKxM8VuJx59cbChG3EYv5S5+jIYMl9+4T+PkmENvWxkfSOo
	V2pJtTWwKwI/MJ9EcgvvbZ46bsBXhGu/8uILlUY4lAh2UhADVcTU3TJB4drng==
X-Google-Smtp-Source: AGHT+IGkolV4gihApPpCMJ1KiZPbLGP6lKKAGid5kl9EQsMAfw6bzTw1axV/cNE6wN4oES6cLCpT/A==
X-Received: by 2002:a17:907:7854:b0:a9a:6bc2:c0a3 with SMTP id a640c23a62f3a-aa50990b2c0mr1380344766b.7.1732625590540;
        Tue, 26 Nov 2024 04:53:10 -0800 (PST)
Received: from [192.168.42.208] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa50b52fcf9sm588338766b.118.2024.11.26.04.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 04:53:10 -0800 (PST)
Message-ID: <37ba07f6-27a5-45bc-86c4-df9c63908ef9@gmail.com>
Date: Tue, 26 Nov 2024 12:53:57 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
 martin.petersen@oracle.com, anuj1072538@gmail.com, brauner@kernel.org,
 jack@suse.cz, viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
 <a28b46a0-9eb5-45db-80ec-93fdc0eec35e@gmail.com>
 <20241126104050.GA22537@green245>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241126104050.GA22537@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/26/24 10:40, Anuj Gupta wrote:
> On Mon, Nov 25, 2024 at 02:58:19PM +0000, Pavel Begunkov wrote:
>> On 11/25/24 07:06, Anuj Gupta wrote:
>>
>> ATTR_TYPE sounds too generic, too easy to get a symbol collision
>> including with user space code.
>>
>> Some options: IORING_ATTR_TYPE_PI, IORING_RW_ATTR_TYPE_PI.
>> If it's not supposed to be io_uring specific can be
>> IO_RW_ATTR_TYPE_PI
>>
> 
> Sure, will change to a different name in the next iteration.
> 
>>> +
>>> +/* attribute information along with type */
>>> +struct io_uring_attr {
>>> +	enum io_uring_attr_type	attr_type;
>>
>> I'm not against it, but adding a type field to each attribute is not
>> strictly needed, you can already derive where each attr placed purely
>> from the mask. Are there some upsides? But again I'm not against it.
>>
> 
> The mask indicates what all attributes have been passed. But while
> processing we would need to know where exactly the attributes have been
> placed, as attributes are of different sizes (each attribute is of
> fixed size though) and they could be placed in any order. Processing when
> multiple attributes are passed would look something like this:
> 
> attr_ptr = READ_ONCE(sqe->attr_ptr);
> attr_mask = READ_ONCE(sqe->attr_type_mask);
> size = total_size_of_attributes_passed_from_attr_mask;
> 
> copy_from_user(attr_buf, attr_ptr, size);
> 
> while (size > 0) {
> 	if (sizeof(io_uring_attr_type) > size)
> 		break;
> 
> 	attr_type = get_type(attr_buf);
> 	attr_size = get_size(attr_type);
> 
> 	process_attr(attr_type, attr_buf);
> 	attr_buf += attr_size;
> 	size -= attr_size;
> }
> 
> We cannot derive where exactly the attribute information is placed
> purely from the mask, so we need the type field. Do you see it
> differently?

In the mask version I outlined attributes go in the array in order
of their types, max 1 attribute of each type, in which case the
mask fully describes the placement.

static attr_param_sizes[] = {[TYPE_PI] = sizeof(pi), ...};
mask = READ_ONCE(sqe->mask);
off = 0;

for (type = 0; type < NR_TYPE; type++) { // or find_next_bit trick
	if (!(mask & BIT(i)))
		continue;
	process(type=i, pointer= base + attr_param_sizes[i]);
	off += attr_param_sizes[i];
}


Maybe it's a good idea to have a type field for double checking
though, and with it we don't have to commit to one version or
another yet.

-- 
Pavel Begunkov

