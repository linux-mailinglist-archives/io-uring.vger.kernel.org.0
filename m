Return-Path: <io-uring+bounces-8153-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E92BEAC9066
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:39:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B32A34E01E1
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4744A2868B;
	Fri, 30 May 2025 13:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMcg2F/d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8011D18DF62
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 13:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748612354; cv=none; b=Hwgdk5ZLlx9q7udT/FHUDk6tTqovQknVwnpurVhTMHMgIP/d/mgn1fMFeUVaZCsPPO9r98WPGl03BRY/cGpaPlLDWO7lM1BF0Zi73/OPp0bzqfCf7Tnu+XbVPctOW2qyeS6HVP3QzoPeRkcZd0WmPjcdEgEYmxSaL2mwCKCoq1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748612354; c=relaxed/simple;
	bh=OpC5u3jlOUYGMOzBp9kuAQ1dJdbIyxx4njMT4ryejlo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QI31btdR3dMR9fXCQLXdfOEGy5Uv97s8hiaHNyrxNrNpXEiN8xvTfSgtYpHWPS8UkPpJisEISZTFwCpiCoDCI6VsM0K09u7FNm3uTaeRlWtudLgo1Q3grX/DUN0KGhZc9qTrmJHLFtRCUVp1IPxoXvP/yvbZqdHB2mp885Qh4cI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMcg2F/d; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-60462000956so3444887a12.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 06:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748612351; x=1749217151; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SIoJUhh17PJe6tMn5lP/6xptCb7o7tfx+73EPAU40No=;
        b=QMcg2F/dIc9x1H019GOUP3GTGeJsdMa1erO3ZJs0whc2y+hVNaIcPBe3cdtNy4rSq4
         lbWXv/GHJT4hrwakttNJ47NEHIevq7iQSOG9DtEevkfKETPzEnUWvjQ0qfK68wdQkhkb
         wd2qPKj+RNxkX0ZSfbjWIPFXmBmqgYt5/N+0x51/CNYi/Be1LMa/U+2d7zMaNygsDwSn
         jhAIiqc1DCQ4c8VEvDL/Uuc1dC1edfuDF3ZphfFTdaCJ/2tLliCF3V5a5GmlgbwwSg39
         GuaZQeyPRavZr+EgKYk3DtUcwDmPEHbiPY7d9riF3YyoSEw0U6GMpn7wds2w6dTblt1y
         vmkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748612351; x=1749217151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SIoJUhh17PJe6tMn5lP/6xptCb7o7tfx+73EPAU40No=;
        b=BLSzkPlvN9dODc3Z6ed7moWKQhsAHix97mSZsl/2yrNS9R/erdoKtoXLKxbvtwcr4i
         cjyJkxibodGhTsqozoij30OkIW7ONZoBEiEF4MXM2cxTd8+EhodH6D0mmL7L4wbu0Quk
         Rmx12vH3VjFMmFE1pI3RSEDbdIqF8ioBl3o0TdJXSZnRUK02P+7FatMQUDp5L6i1k8Mw
         Bm8QZjlCDC+pshjjv6V0Fqwke27oQaf5FDt+38rk4Gg8Lv/dk4G3m3KdTb/WS45bcDJW
         bVAVRWD/3prKCj/V860KhZmThD6DMCU+F1HARIfDltgIHQMZkmIyY+eXtf8bAqdpksKw
         W8ng==
X-Forwarded-Encrypted: i=1; AJvYcCXoBHtpXg1cNuwcaBgANXfILbSokQoYrLa+wk09NQbCX2DJFfQYKN3GiyuQhVlxFYHGmCv2LRntjg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZzxrMElEDkyhV8B/9g3tIew3Qu69Ci6oFQkCNyAK8/CFbEJIe
	9qqJ8TmvYLYTxGo9RN0s6VjLcZP/bDE2guLCx7wq6pCThSp71SlcfIn0r7ANTQ==
X-Gm-Gg: ASbGnctNT85GwEc/x7lNVFdYgYcGCHZNhUrVep/nuN6Y7JGkVt1VUNsiOSDSIiHzLl4
	SR4cS0bSt8nOqTMA9aOTkQ8Nx5PpeYFn60H2D8GGhWa+DOfuBjA7mED4KdycckYLMXO535rUU32
	eSRw0CLL2ysmOJ9q1DJjUG2qYpV0UiX5TcOi6hs6Uy+aPGmgesM2S2hxyS4MSQ7F848rP+BDH6z
	r5qcbb8jlbBp3RAMNdpZrDNTsumJ9fLbpN4C8LrtmiLH3LquKXEJ6bKoGMHGZ6WbDfEVs3bPP8U
	DcdKBWi9stCYlI9nz6iUGxYEntH6/GsplKD5NwaBsAfoTEV4e326SbZGaSKM1+h8uaTPj8VBz4A
	=
X-Google-Smtp-Source: AGHT+IG3518QN6ZbuS50L1CeDEpaqZWweqwimg6/l1dG0cjk5ZnrZU8kO1ikF8T1HygLUn01I4sVgQ==
X-Received: by 2002:a17:907:3f29:b0:ad2:2fa8:c0a7 with SMTP id a640c23a62f3a-adb36b4cfa8mr214675466b.21.1748612350548;
        Fri, 30 May 2025 06:39:10 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39565sm327510266b.134.2025.05.30.06.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 06:39:09 -0700 (PDT)
Message-ID: <4207774d-5f78-46d6-9829-4feb24c81799@gmail.com>
Date: Fri, 30 May 2025 14:40:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/mock: add cmd using vectored regbufs
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <a515c20227be445012e7a5fc776fb32fcb72bcbb.1748609413.git.asml.silence@gmail.com>
 <bd72b25d-b809-4743-a857-7744a3586bea@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <bd72b25d-b809-4743-a857-7744a3586bea@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 14:25, Jens Axboe wrote:
> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>> +static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
>> +{
>> +	size_t ret, copied = 0;
>> +	size_t buflen = PAGE_SIZE;
>> +	void *tmp_buf;
>> +
>> +	tmp_buf = kzalloc(buflen, GFP_KERNEL);
>> +	if (!tmp_buf)
>> +		return -ENOMEM;
>> +
>> +	while (iov_iter_count(reg_iter)) {
>> +		size_t len = min(iov_iter_count(reg_iter), buflen);
>> +
>> +		if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
>> +			ret = copy_from_iter(tmp_buf, len, reg_iter);
>> +			if (ret <= 0)
>> +				break;
>> +			if (copy_to_user(ubuf, tmp_buf, ret))
>> +				break;
>> +		} else {
>> +			if (copy_from_user(tmp_buf, ubuf, len))
>> +				break;
>> +			ret = copy_to_iter(tmp_buf, len, reg_iter);
>> +			if (ret <= 0)
>> +				break;
>> +		}
> 
> Do copy_{to,from}_iter() not follow the same "bytes not copied" return
> value that the copy_{to,from}_user() do? From a quick look, looks like
> they do.
> 
> Minor thing, no need for a respin just for that.

One returns 0 on success the other the number of processed bytes.


-- 
Pavel Begunkov


