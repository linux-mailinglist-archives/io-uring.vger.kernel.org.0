Return-Path: <io-uring+bounces-5268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 620A69E6DC8
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 13:07:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1CA8D1881F8A
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 12:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EE1320010E;
	Fri,  6 Dec 2024 12:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JFrSscEa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F871DACB4;
	Fri,  6 Dec 2024 12:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733486820; cv=none; b=R51xuQb72QhmJur/JcnISb5JhSUeDNlF43209JarzZAGgYyZZCSLTC3KE3mtwuKffkDOaRNLF65t2DjNMqD5RkFequGx+/UmpJs0thiP8KTjYfAVIaNaBuQBFZH8yvJBZOVIkgArTbPH6Fg7Y0pYmM1uwZsUMH3cYJCNUUywUAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733486820; c=relaxed/simple;
	bh=ByULjhXg2DQyej12KlVZA9mocPU6ZLijXj6wfydlVoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qgVACc0l0LESc2BhEuHodb1JcxUNMTcPt3YZF+7zh5CSnIh4vikBnw9gqyJzeH5ZQq+ZDEGaQXGvF0qK9s+Tiygz7JaVLsZh4XBBX47a214fpBhC4AHyjI8YAxhH8ECl8fSg+EMKoupuGuAVLSplaPi4Vh9/1z866KRkJtbaYN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JFrSscEa; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3862d6d5765so274891f8f.3;
        Fri, 06 Dec 2024 04:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733486817; x=1734091617; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ofi8J7HkOXqzmy0PwYhWkfzpyBnLUyhAbaIeruP1+Ek=;
        b=JFrSscEaHsUdJnQ26rdppXR+tp2AhAus3NPlZ88qCzgIDfhIbxQqH1G2QlWz5vj0Sw
         uodxWAdUtSNC1QWNvPUFIyd7/Lz2eqb23nnhPh185OL6XYbT9f97OVfb+ATZ5fbToDGt
         NW9RHNVXZ8vDm5R8xPLp2izmsZt4wgvpOZTdvdGcvSsipzjm44FtoNZxXY/5RHsrMamN
         L+s0dIdJbB/XQeLsvM5QUmM90H/bzCoT6ARMBQ3fmLbr3ULr041RvVCLba6QtTz1D2fR
         Bu4Eg92wg/GJ7Ztu9GChFAqhqzTsLLIF992PuixUyTpm1CMYI3DARk4eMZr5PotRHv7X
         9jEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733486817; x=1734091617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ofi8J7HkOXqzmy0PwYhWkfzpyBnLUyhAbaIeruP1+Ek=;
        b=pkZ0EYzsLXCxJEjGmsMDnM1pBBHSKK+Rc15BQ6XfCowjMF90g/jBzk8U8wQh5BGSxA
         i3iC0e9Ddd4Gn7OMMKMc31grbWah1wD6ob56XaxzZxJaaWJaaGRdPCs+j/7j3Wkl+rlB
         WJsWMs83DlDm7rUuZr7O+0NLito8pckkkgiPqUAllkXDQVoAFcG+TEZoaCrBEMe2Cv78
         BjmvnEKFQg8k0tzHDmPEExZVxumv1GAS2UbQpwsnjXxtahV3DVgMJ3+oKBvvw7qw1eNV
         q5F5Km8pcsSQpFA/aoawiOGA3V44xmKdVvzQUY7jtVJuDK5F5LehndOTVfHof8ejke9W
         kPfg==
X-Forwarded-Encrypted: i=1; AJvYcCVdWY2AdLKo2ZA+Qvq9c4PIH+nnxwliPgWJSWz0G2b1CbrHlZhYkIsFemirz11RSwgp4IJwodHQ0w==@vger.kernel.org, AJvYcCVp4lHtbiY1Dr0VXdj/oHj0BSuci2u2hfhlbWasgRMxF9nQVIQTgELzB20bcicwCdQaxqEQPIlNPAkYQrs=@vger.kernel.org, AJvYcCWaeVfpgJxbmJ0pw171clJ8THZsXv/JHSEkX88XG5RafKv+y3Wv0KBc+GNvD52S3Dqs2GKqZ55nSt69fGpNOQ==@vger.kernel.org, AJvYcCXEBMZAeYgZPfUUuJnayoF8xdvzZ86uX6nwDiJNxo0/7aiOEo/EdqyckMrlFH3RqEintLfulI/6i04c/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxwXDo14EWnp2TRiJMMkWbckyDoRNtVk7+r15ENmxlesjFo1Ya
	j1Gpc8COikI2F1jzKcmTPUVNzzyUqWAJuBfUekjvv02KB+IZ857b
X-Gm-Gg: ASbGncscJn4MF520ztyHejbZA0QTFg9dB/DddJ9qlsK+q1U4OFRX0hnvcnxyxWp016K
	Zyh9QSPFZMM8GeVE7QDiwvXqwuKhaDY67S2q/1CQLGZ+RQd2mcHYMR/+3wYNk+i5mSDAF5cVpSD
	gR/d8EhrcEHsgiKfQf5KMW++aoQO1ZKEaM0tpa7k8YZAfHzg7fWU5aNcXG/8HO/EQV/euPw2vyK
	6OY9khC7SXGqgmmEClBv80ZEzWtnGGfGCloPScSsA9U+T5cIUh3uznspw==
X-Google-Smtp-Source: AGHT+IFukNP/9d0bzhZHBl9HWucpX6QKCTEFooLAnEDxeoA5TREQULmq2p5TXYB5euFXhrTUS8HHng==
X-Received: by 2002:a5d:5887:0:b0:385:eb17:cd3d with SMTP id ffacd0b85a97d-3862b33bb70mr1874874f8f.8.1733486816789;
        Fri, 06 Dec 2024 04:06:56 -0800 (PST)
Received: from [192.168.42.94] ([85.255.232.54])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3861fc51451sm4480100f8f.47.2024.12.06.04.06.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2024 04:06:56 -0800 (PST)
Message-ID: <80aa4160-94fa-4ec1-91b8-2d125ab41120@gmail.com>
Date: Fri, 6 Dec 2024 12:07:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Keith Busch <kbusch@kernel.org>, Anuj Gupta <anuj20.g@samsung.com>
Cc: axboe@kernel.dk, hch@lst.de, martin.petersen@oracle.com,
 anuj1072538@gmail.com, brauner@kernel.org, jack@suse.cz,
 viro@zeniv.linux.org.uk, io-uring@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
 gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241128112240.8867-1-anuj20.g@samsung.com>
 <CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
 <20241128112240.8867-7-anuj20.g@samsung.com>
 <Z1HrQ8lz7vYlRUtX@kbusch-mbp.dhcp.thefacebook.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z1HrQ8lz7vYlRUtX@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/24 18:04, Keith Busch wrote:
...
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
>> index aac9a4f8fa9a..38f0d6b10eaf 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -98,6 +98,10 @@ struct io_uring_sqe {
>>   			__u64	addr3;
>>   			__u64	__pad2[1];
>>   		};
>> +		struct {
>> +			__u64	attr_ptr; /* pointer to attribute information */
>> +			__u64	attr_type_mask; /* bit mask of attributes */
>> +		};
> 
> I can't say I'm a fan of how this turned out. I'm merging up the write
> hint stuff, and these new fields occupy where that 16-bit value was
> initially going. Okay, so I guess I need to just add a new attribute
> flag? That might work if I am only appending exactly one extra attribute
> per SQE, but what if I need both PI and Write Hint? Do the attributes
> need to appear in a strict order?

Martin put it well, this version requires attributes to be placed
in their id order, but FWIW without any holes, i.e. the following
is fine:

ATTR_PI = 1
ATTR_WRITE_STREAM = 2

strcut attr_stream attr = { ... };
sqe->attr_mask = ATTR_WRITE_HINT;
sqe->attr_ptr = &attr;

In case of multiple attributes:

struct compound_attr {
	struct attr_pi a;
	struct attr_stream b;
} attr = { ... };

sqe->attr_mask = ATTR_WRITE_HINT | ATTR_PI;
sqe->attr_ptr = &attr;

The other option for the uapi, and Martin mentioned it as well, is
to add a type field to all attributes.

FWIW, I think the space aliased with sqe->splice_fd_in is not
used by read/write, but I haven't looked into streams to get
an opinion on which way is more appropriate.

-- 
Pavel Begunkov


