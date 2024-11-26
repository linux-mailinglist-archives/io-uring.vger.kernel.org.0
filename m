Return-Path: <io-uring+bounces-5052-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0109D97D7
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 14:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD09728248B
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 13:00:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35F3D1D042A;
	Tue, 26 Nov 2024 13:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F6UmYTTc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2422C95;
	Tue, 26 Nov 2024 13:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732626021; cv=none; b=AgriG2yo4JTLFAhBL3ETJNjTRseO33JBhrOFTgKkgSniTScCU6PCPuUPe4/DlV03BJFBCE2ASG7aVxzk9OyVCA2ZtIg4jY9BCiNho82wjGzUYzuZmZB09WHICanVdtBsHhmk/pgwY+FfhXeY0w98KzJkC+sdmREI5u9hUqQIyu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732626021; c=relaxed/simple;
	bh=G34qdhCAqH9iqyq5N1T9gpB25ZjHSNbvW52DdTDvZ9E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XYPabFYfYRZ6Q7W89XG3PBh3vivs27npBJYkjwLz0VV6o7NyoczmLgVeCmdcnhoboURGcd9GNFsCmUoS87RWFG43p3SwPx5cSHAtFVXLE2+2bxxmGHPrOMl5BQ3/WbsPO05mlbO3ACzoaSaSn/YXZNkVt8p/R7xDn24NVz1KWWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F6UmYTTc; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d036963a6eso4164646a12.3;
        Tue, 26 Nov 2024 05:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732626017; x=1733230817; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F3yoydyNiuN0rSJxRIOYTIsz5+plA0TViJjCd+DIF2Q=;
        b=F6UmYTTcvKp1KTv/srMZduhW9D/++BIH+agxVpGbfayV6Smh/1FmrjPnc/iVtmK1cd
         TOPiiwnzbPoLyKw8hvOT8/E1Sqhy3vum7zxQi33HI+KfUYelFBRmn4ENeP5mTfUruz49
         RCLTOz1QdxQWEqXZ/FJmW7NpRwFNIhwIAiCulj/yOztLXiB/4tVGrjymaT6ed7f/7oK7
         fQ4akDBDPNLMt9esHTkJXdJOXhA/VEKiTVj2fnaivqi3zdrmnPwLXiXapO2fSDM49ZUG
         yVmgitCq9/kcWfoqjZGdnwVTA+bQHwMRGFAo3HrESvtpsZTnnBVcf8SpcPtF1suzV3ns
         Kl/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732626017; x=1733230817;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F3yoydyNiuN0rSJxRIOYTIsz5+plA0TViJjCd+DIF2Q=;
        b=UbNnGMmzUrk9nrSe1zH5Emk2v1Yni+CNyUXK0HrSRu3a6ySHHJQYaL5Cj7SoiUHGHh
         gszYPZ5j8qgtQRGQ+je7ld73Ta+K69q+d22SzZmZ0tJXc3TgQtMOjb1Bjf59SPuNHDNq
         JbzElAQkxlZiJ90EFCsp8GnL54ASNILP6aDFKvD+PHir1izuqrVq6n0mMBn7Mh8VmX3c
         6U89J0kh3Zmbd5kKdAd0UQ/8ZKFkLYR8XCKhRHgz8YKqfUtPntkvyoUaHVc4/ETfzuqt
         4PAcpZFMAA4YRUJjGzXvrd7BeT96+9cC4InfeuC9WqV5BC7NtqBApfRVRhzVcG+9qndb
         7oZw==
X-Forwarded-Encrypted: i=1; AJvYcCUJBumcCC5Bjw/SI53GGIn4eFU4L0mIKIBTiBEN4e82uuUqAvxsJOyCXEsUKmWTR9S37o8h6BCpeRooEA==@vger.kernel.org, AJvYcCVoVhgCP6BCDCw1TR+nD+dK9JgJRdzvdtqHkBtql8xZavZfTvZ7SCDdMvdx39sjK+vWOPJ5OMdiJEaMoQ==@vger.kernel.org, AJvYcCXUFg/s0QTcgmbZoICuFm/MNETQOH7d3ZcKN42s5rn0lb/xXtvZPzzrRsbqU0EOQEjiHMzp0/0Fs92jINz1bw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzT+Ysh89eYw3IXipcVCuMeyn1AR1tcspNO/5KFy2//jX2bU6pv
	GOhVt960N06YJv5ewlD3RecmoBCtGBZYj2k4pWZqqBBD4PZdY4PP
X-Gm-Gg: ASbGncsioyxleTHmGw9VXrixQbEtW8QFAkgwJmZwfKSQFNX1zPuSrPmf/Q9+RWhRDk+
	DsSu/jtR5IBlgVIw1G+73yH994KPca2owuqYRbnxiMhLsZqSqP93XdER0OgzzN1wDNOZy89aiJk
	oS72/0cBQ0X4KNpR3WlJxHD7gdNvfITp8fIfv5PEH4ZGScYAaCydUsNconfZr0kNyvwDBFVWFP2
	Scfo0+FWsgqKM0HWjDAPrXAZhu9Xh219HwDDWd9wvkRLa1k6KHyL4B8t+VkbQ==
X-Google-Smtp-Source: AGHT+IEP82AjkuoW0ZVsrpYLJBWQ9XK9zYr9tk2OCe5t4oYFiJxerefDCiqo9eMqXwn0bVG+EkwlPA==
X-Received: by 2002:a17:907:770d:b0:aa5:29ef:3aa6 with SMTP id a640c23a62f3a-aa529ef3b9fmr1061664966b.23.1732626016527;
        Tue, 26 Nov 2024 05:00:16 -0800 (PST)
Received: from [192.168.42.208] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa52e45391dsm480198366b.60.2024.11.26.05.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2024 05:00:16 -0800 (PST)
Message-ID: <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
Date: Tue, 26 Nov 2024 13:01:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de,
 kbusch@kernel.org, martin.petersen@oracle.com, anuj1072538@gmail.com,
 brauner@kernel.org, jack@suse.cz, viro@zeniv.linux.org.uk
Cc: io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
 linux-block@vger.kernel.org, gost.dev@samsung.com,
 linux-scsi@vger.kernel.org, vishak.g@samsung.com,
 linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
References: <20241125070633.8042-1-anuj20.g@samsung.com>
 <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241125070633.8042-7-anuj20.g@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/25/24 07:06, Anuj Gupta wrote:
...
> +/* sqe->attr_type_mask flags */
> +#define ATTR_FLAG_PI	(1U << ATTR_TYPE_PI)
> +/* PI attribute information */
> +struct io_uring_attr_pi {
> +		__u16	flags;
> +		__u16	app_tag;
> +		__u32	len;
> +		__u64	addr;
> +		__u64	seed;
> +		__u64	rsvd;
> +};
> +
> +/* attribute information along with type */
> +struct io_uring_attr {
> +	enum io_uring_attr_type	attr_type;

Hmm, I think there will be implicit padding, we need to deal
with it.

> +	/* type specific struct here */
> +	struct io_uring_attr_pi	pi;
> +};

This also looks PI specific but with a generic name. Or are
attribute structures are supposed to be unionised?

-- 
Pavel Begunkov

