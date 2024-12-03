Return-Path: <io-uring+bounces-5173-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74A459E1B82
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 12:59:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A66A166757
	for <lists+io-uring@lfdr.de>; Tue,  3 Dec 2024 11:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D06579FE;
	Tue,  3 Dec 2024 11:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IN/x506m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585A26FC3;
	Tue,  3 Dec 2024 11:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733227188; cv=none; b=NMydsAGsljvqLVaTc5nC0VOKsac2A9Dr8oHk959iuCEcQeerqIKsb54thzuTNVKLQ8KkklAGmA7aMJZYrFdPQ0BRi+/n14+7jxwZfpLl85qaQ/hwO1BMTgb59IboJrTvJR/2SwamACJO4W/WhPabbPU8wjCUQEvPmxD3Rm8Xi8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733227188; c=relaxed/simple;
	bh=5f7uC9CEMYhOatLZfF783ior1u8CO4DdxN0J/XgPd+w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KeWOKdxxJ7xue1A3CIbrZEVWuEykftFuKDfnEQjIM/0FM6aT20eJebRQzZgidxTeynYt4iocL+LIrVr8Ls6htZrm4y4yKvhQPYw35i2/E0XbLILSb9ocL6H5rC27UaDgxm5yxalrNKfU53zCAwNv15ILvmjaYjEjGnATdXZA5mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IN/x506m; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aa5500f7a75so850678766b.0;
        Tue, 03 Dec 2024 03:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733227186; x=1733831986; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wrpw/gEIImhg5C05XMjsYpabyaleC2cQZtMyShGtK8A=;
        b=IN/x506mhVwHF1Qi9PZrYjU89q+0UbAJU+23B6rIZ8dbO3HywuwXxh2SufNLRMK2wE
         jihhFSRToujKVT5gSImhcNzw2AicdK09hoiZ4BPPY50fb2GIvNGfwNQE2BOEKr1i7lcu
         2gfI/Vyh8jXqS5UHXs4FgjSHmdFZwxst2SFsxoNClQnaJauqBhfgVgcWYA+Qgu3nq38A
         8ujEcWz0qpXf2GenuexK3PHikGL/lGzuWfJUbVp7GL7lZNDugvROysNE4q3Aj5c5E0Wc
         L8+QRdBzOo+Y9AQmfkx1cIaNQFso+ZbAB3xkibc5kWaLG0VlSjIYAW1PEqOb/B8c9cn4
         VRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733227186; x=1733831986;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wrpw/gEIImhg5C05XMjsYpabyaleC2cQZtMyShGtK8A=;
        b=GyZHsXOriMd0DwgXoHUyaQGMjkJ1Tlk9J6LfUywRPkEQ2A4RLfAr1DyFPYdWAHK0b1
         +NnIRlXGOXeycIPaUNU4KskJXDKyOLefzdd36HDgQnHDW0ixJrnO5GW60vQ4aj9GOdpu
         dj16h0stFjSECkgnr+O3xNXR1NZgSw/9nLTyhC+1TvvaFw+4vXIcTX5RO47ZyCGH0w4Q
         kd2whAsehVjjtb3m5O3/a0gtKWUtBk6C7wL26JS/K+xa/EbTUbZPdsYbgPDKrautAA/C
         B63Yj/JF8CRijEnHqOaUUFILSgMjwd7F+GhLA1IpyV3wjw+cFH9Apr3BgEH50W34nkz0
         +Mdg==
X-Forwarded-Encrypted: i=1; AJvYcCVY+L2Vbo/CUMFYHOTz4v+W8sFTPHyzAQG905oneOA4JsUZXJhRabBwDPeyQbyFTk6s4kcG4gwZrScn8w==@vger.kernel.org, AJvYcCX1ougLJK+81c3ybFd21Fu+eVyQfoJ1EePRIqYZ+wE9T9bSAfBfhWxGu0zeiVzYfMdraa8VsQFSNvO447sCRA==@vger.kernel.org, AJvYcCXPr33tD5q8iFqO4Y0FIXSzcPlEpl2gXFZvw52nrRMeJhLCo9UG/91bqzrpoQLPAFyVmIPrMYXCdJRvHXw=@vger.kernel.org, AJvYcCXug9OwHMNQ98db0RYsAtSzRj2us187VX7FKWEjce0zwnH+4k2c6r1spXfCc8PT7hNKqckz+EtD6g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8BYXWO5UOWnGHc+Zp7eTgcCixoz1cDBPkBFdFQiqxt+SSD8fO
	w1NAns2zPdz1WwnC7PG0bSG4+vRXjjVvnBkwuc7pIhaw1vlhKSNa
X-Gm-Gg: ASbGncvgyWBEYcUMX8x1RDvLaajy4ByFSKXbrUAfTe37VRKRLOIEq+X0D7GdN1pxKF0
	UpqA23VsOedIi33dWsZWMwn8Rj8AqA+zVWpa1srHIVBvCH8eR0l3LGonqdgtvZfSFORKat9y6iB
	fK2Aaqw3vtN66oW9ZF/Sr9Vha6KIXbv3aikzFdzhOkph+jsnYPlSJJecZWx5vIPi7ixztJaaONY
	ppx0YY8w/3TRbymtYcm8Vsn5xZf7svY2reTbVe0vIHTyYy6hkFKiOGlRsOjFg==
X-Google-Smtp-Source: AGHT+IG4y9LGZwq9NfK9cdHd+NVO7Xgo2sU20E7rmPmT2a1si682Vjey0TVrQO9Z6X+iYPB4Df14SQ==
X-Received: by 2002:a17:906:4c9:b0:aa5:44cf:3ea7 with SMTP id a640c23a62f3a-aa5f7f4773dmr171377066b.56.1733227185269;
        Tue, 03 Dec 2024 03:59:45 -0800 (PST)
Received: from [192.168.42.213] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa599801591sm605350766b.91.2024.12.03.03.59.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 03:59:44 -0800 (PST)
Message-ID: <b8574010-e2fc-4566-9df8-80046fec2845@gmail.com>
Date: Tue, 3 Dec 2024 12:00:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk,
 io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241128112240.8867-1-anuj20.g@samsung.com>
 <CGME20241128113109epcas5p46022c85174da65853c85a8848b32f164@epcas5p4.samsung.com>
 <20241128112240.8867-7-anuj20.g@samsung.com>
 <yq1r06psey3.fsf@ca-mkp.ca.oracle.com> <20241203065645.GA19359@green245>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241203065645.GA19359@green245>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 06:56, Anuj Gupta wrote:
> On Mon, Dec 02, 2024 at 09:13:14PM -0500, Martin K. Petersen wrote:
>>
>> I have things running on my end on top of Jens' tree (without error
>> injection, that's to come).
>>
>> One question, though: How am I to determine that the kernel supports
>> attr_ptr and IORING_RW_ATTR_FLAG_PI? Now that we no longer have separate
>> IORING_OP_{READ,WRITE}_META commands I can't use IO_URING_OP_SUPPORTED
>> to find out whether the running kernel supports PI passthrough.
> 
> Martin, right currently there is no way to probe whether the kernel
> supports read/write attributes or not.
> 
> Jens, Pavel how about introducing a new IO_URING_OP_* flag (something
> like IO_URING_OP_RW_ATTR_SUPPORTED) to probe whether read/write attributes
> are supported or not. Something like this [*]

An IORING_FEAT_ flag might be simpler for now. Or is it in plans to
somehow support IORING_OP_READ_MULTISHOT as well?

I have to say Adding a good probing infra is long overdue. For example a
user might want to know which attributes are supported. And beyond
io_uring it might be interesting to probe whether a particular file
supports it.


> [*]
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 38f0d6b10eaf..787a2df8037f 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -723,6 +723,7 @@ struct io_uring_rsrc_update2 {
>   #define IORING_REGISTER_FILES_SKIP	(-2)
>   
>   #define IO_URING_OP_SUPPORTED	(1U << 0)
> +#define IO_URING_OP_RW_ATTR_SUPPORTED	(1U << 1)
>   
>   struct io_uring_probe_op {
>   	__u8 op;
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 3de75eca1c92..64e1e5d48dec 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -67,6 +67,7 @@ const struct io_issue_def io_issue_defs[] = {

io_cold_defs would be better

-- 
Pavel Begunkov


