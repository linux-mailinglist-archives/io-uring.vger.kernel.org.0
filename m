Return-Path: <io-uring+bounces-6325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 501E1A2D69C
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 15:24:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4D121658ED
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2025 14:24:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7912124634C;
	Sat,  8 Feb 2025 14:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZOveJHZW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6A020328;
	Sat,  8 Feb 2025 14:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739024679; cv=none; b=IRJOKDmLDZpVD3O8LjyjIWY+3wR0QXkeQB5lxVktgGpfXe5okqDT6GojC5IAS4rIxk9iBJDG+EfkS4BQIdfk0ZDN5HcBXhlA/a/GNaJmMNotKYza92GAmz1iFpirBSkzgHHf/cW5aHuTOUm5tIEpHPuIKSIEika+7TYExDJSZag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739024679; c=relaxed/simple;
	bh=7LRB8xPXXtJGv3bcCTivLNeUv1HygxukPA03Zbre7GY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I1+9G5XJhiLC9/vAjcTe2m+cKQUFYpoCm4kM7HIjzUOs3IiyZiBz6FLLRqyapoTcqCqiib16LlHC5EhmY0Q1sAkGjy9hThqpfQM0cmQ3IECj/L7+9eUdQwZ2OvXzBJCeodai3i3/zANOnjdYQXZsHplaPwAoFU5S/SXyjbSK04s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZOveJHZW; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ab79de014b6so148621966b.0;
        Sat, 08 Feb 2025 06:24:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739024676; x=1739629476; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Tr7CzipofOmK+X8jPjs2LkZvCHXfflisAxvDDajPx/4=;
        b=ZOveJHZWi8zxLnNTKH0jXnKLvIDj9B+u03yazhXgowcdPmQRv4I9yak02w6rIDE3O5
         Ec4SMWWTMwcO5Rg1fYvbI4c3/mXvesAMxh2PKe9T0x4u4naP7pJpnQRYH1e9i+YHuqF2
         SiWg4PHQNNGa8jMOf/KE0egtXccXWoosSFAZ3mohc1bq9FdKABtUBKDno+EUpH14t6V9
         YSsyrOCyMRjCMKrDrzKQq936C9Or8nc/Ki2teDSsynBw92mdvTtQ8q9yfHK1GqHtAiN6
         IeYHjfifyaSnruTkmGK0FoNF2RvNAdQRpQjF0yjC3pEmFw1Cq/X4yzasZoJO7x5wOfdn
         Z50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739024676; x=1739629476;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tr7CzipofOmK+X8jPjs2LkZvCHXfflisAxvDDajPx/4=;
        b=OiapHD7JBczs/aYxuG5ocuLtr0kFXgWxh88x8c+DcldMG3oDB7zCxv8SNlrScebjDt
         Ai/h+7YJaN94oWiZAdfINE1Zal7c0rSLkqK9ust4xl+/mVUjboe3GjwVMXQ1OxIqYc+/
         CGTm0P1RtXYl4sSxjmQqKpDxK/nEtc9uZRKdyi7OxBFPYoK3qobz7q29ZPOAXlMmCS1X
         GllBbbuvxwyaF5BYUazPxfavUE+oLnea9lNGbUwbSDAJm9VkLXL5F0OIO2wSsraM3Mfh
         zGEljqJMOo5SvKmvaH8yYsjsw75flMnLrSThyC1+S08kUvgyDWv7R7MsXKSJNFc6oKed
         4j/g==
X-Forwarded-Encrypted: i=1; AJvYcCWkSNVFxxWaYXE0hkzVRen5qI+J7Dw9+/zj4VZMG10Y2+K8RDOahUdpgf5dIMEkZ2A5Hs4RTxj6rPLdL50=@vger.kernel.org, AJvYcCXLs8t/JZ4jMhfuHMZ7qWaeCEfcOwBXH3DXSamjbl1Gr/HXU1v+49gLU/9cw834eq1H3sjD9Xfg8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyEuBbVBR9A5g6nQbVFdDdCkoicJJRDRGJhB+5I+CSvx9usiaOm
	LYnBIpz5MYcEVcln0Cx3zqIEd2GlGm+NkbqnuBTLiNvbUd+IwengTzFYsg==
X-Gm-Gg: ASbGncsucb+HJ4jvR4OLUbpXGYftB2C6a7nakaG+TnmBPmAPnyAdDBucbaGdr9iTJe2
	XRotpLlfVZ5P7iW451MkCZx+N4KSyuCSrTQpkd2F6miSzeNkpDoGgJdSnBpBDzmWNjsYqWB5GJY
	v89vMwA98ZfLLK2b5VusoU6GFCrAEhVDrmZwa347WSPE92j6ZiHHnNHd5rQRGJjIvRzAIkObV0p
	/aCcsVA4Qsw4/V18XhHcJE/MDfqGmyYtTRxS5gXtiml/QY+xFWKP/O+d+Spa21eVXZbmoAIYcB2
	VqHopTF0pcTGDfoVLt/b1IvD7Q==
X-Google-Smtp-Source: AGHT+IEhfF/KXPLSVo/Q1fvICvh5kRXb7xCjPex5C8UnFmfBdYRn49MdjrDtAARU0oxjfXXwWORtlg==
X-Received: by 2002:a17:907:1ca0:b0:ab7:9df1:e562 with SMTP id a640c23a62f3a-ab79df1e783mr259937166b.48.1739024675796;
        Sat, 08 Feb 2025 06:24:35 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.220])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab772f4936dsm479997766b.29.2025.02.08.06.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Feb 2025 06:24:34 -0800 (PST)
Message-ID: <accde96d-cb90-4b42-b19f-d91677041239@gmail.com>
Date: Sat, 8 Feb 2025 14:24:37 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, ming.lei@redhat.com, axboe@kernel.dk
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-7-kbusch@meta.com>
 <a6845bcf-8881-4b92-acc0-0aab8d98cba9@gmail.com>
 <Z6Yt3o7LKtVdFx32@kbusch-mbp>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z6Yt3o7LKtVdFx32@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/7/25 15:59, Keith Busch wrote:
> On Fri, Feb 07, 2025 at 12:41:17PM +0000, Pavel Begunkov wrote:
>> On 2/3/25 15:45, Keith Busch wrote:
>>> +struct io_alloc_cache {
>>> +	void			**entries;
>>> +	unsigned int		nr_cached;
>>> +	unsigned int		max_cached;
>>> +	size_t			elem_size;
>>> +};
>>> +
>>>    struct io_buf_table {
>>>    	struct io_rsrc_data	data;
>>> +	struct io_alloc_cache	node_cache;
>>> +	struct io_alloc_cache	imu_cache;
>>
>> We can avoid all churn if you kill patch 5/6 and place put the
>> caches directly into struct io_ring_ctx. It's a bit better for
>> future cache improvements and we can even reuse the node cache
>> for files.
> 
> I had this that way in an earlier version. The cache is tightly
> connected to the buf table, though, so splitting them up makes for some
> awkward cleanup. Grouping them together makes it clear their lifetimes
> are as a single unit.

I'd say it's tightly couple with the context as depends on the
ctx sync, and the table doesn't really care from where memory
comes.

Anyway, there are basically two reasons. If we're adding node cache,
we need to reuse it for files as well. And I'll likely need to pull
it all back to ctx for cleaning up caches in general, and I'd rather
avoid such back and forths as it's not so great for backports and
things like that.

Is there a good reason why it needs to be in there?


> The filetable could have moved its bitmap into io_ring_ctx too, but it's
> in its own structure like this, and it conceptually makes sense. This is
> following in that same pattern.

-- 
Pavel Begunkov


