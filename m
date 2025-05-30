Return-Path: <io-uring+bounces-8163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42278AC91E0
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:52:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C51A75026DD
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F36CA235065;
	Fri, 30 May 2025 14:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C5rFgJn6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CC522D782
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748616717; cv=none; b=bqjwMqAmdwK9bx2o1YHJS/Snqwo92OUoz2NW4qUfB3Grj54ZOyQRIRD62LaoLpn4XM+HhTR6n3/RVSkw3wwRXhq4L1y381ks7OJL8nTnM9B3B5ruFxDY4V1MJ45uFeD4ypQSNgKDVKN5PDd7SeupxWBtLQPe0yNtvQl6Xgp/Wdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748616717; c=relaxed/simple;
	bh=umj6ga3RgziNmWL939by+HZcadg7rZBcwNAyHIuf4hg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=raxKjQPrZapSF3xUgLdKUUPcIzcasu0Ek61LWJbDZMrlQUWf/np8H7IakulfFxAwPPvDHD6zV6X3T/Cs0Rt9EemWiN6WDoJ3eOSWVWoze2o1AXJ/3cJphlbISk44m9Q/bWmLsLBcATb0r1zc6We8whhaG9tjy8v7obY7/EvCkyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C5rFgJn6; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ac3eb3fdd2eso387838166b.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748616714; x=1749221514; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=plZqDCvFF4hfrcsQ8SmxmaCb847Brdnb5oY90DIGvmc=;
        b=C5rFgJn6vbL0FVs8TpWZh7Ns73vRSIhOBU+F/LbswWMcl4YMaEbBjRzid3Ol57gFC8
         RJ4X00ap40Dd2qPjO2a7OcOAytd5QXrD/Llz/nyfDrbVA6kMIa7tqnF8370FtN8fxFAz
         KIqEb1SmutD9KwGMyRppFuy4mYvglWG5bZR7CW2Ph6VHr/InuZr/wmqcEmW1DO9/8e4O
         me1Sn3zpJbnbGg0WtNoDlmwUJPVflulawmmv9WGeEJneIe/Mj9Ng6Ccd4/iTDxIwodf1
         SmeaCo5asz+slcd9vJdKBDW1WoCSTdpzH5iY16dvSCgSWSTBRUwuKluNqDXIJkGrGO69
         vK2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748616714; x=1749221514;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=plZqDCvFF4hfrcsQ8SmxmaCb847Brdnb5oY90DIGvmc=;
        b=LYDdYwXbhR1+ik/msWR+5I6LeAdQuJ3jv4C8Bo7nn9Bnx1ubGOMtjwYbp0NJCCpWzL
         yZH3/itJveW+ToaqUHdQb8jGr99AGIn6QyS+cNajq4EsmwSN/WUo3G3i5ICLzWAw6rtB
         7jEC9hTENQ0QUZZWrMFrd3dvKAg2mpDUMDiSiTBTgP4RewTzZn0P1eKsXjIq/cpVrGdl
         dHFw2u+LPdh6KJAh5Y1DUp5pz/7rNDWkkqnPCOB6bOtbxj0MMwPfQkJqVHp8tdy1UdgY
         gf7m2U4btNsWHHJ5dFXqfUMfYbjn87JG65p503iG3tNYuljOzAwAI1JGuohuCjjcBZB4
         RaGw==
X-Forwarded-Encrypted: i=1; AJvYcCUeta1TeCmAf2Jh474vOhwfnPykFcGanz/fCh5DP/i+DHThwTUUy6CBif27ZtLwpBp1Vwo+P16RSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyyK28x5QlFXeLRyBtKeuh4nwBz6o7FAl+Ccu9eRjUgcZxkUvUY
	xv9eaXxL86decUpDsWvvX62H5v/HtCoIcWGQp2jecY15cCYL/98PcUcX8/7wZQ==
X-Gm-Gg: ASbGncvtYnU2hrBbXj6Od/O9n6ZmHmVttEjTZPzp4MbkF6gU+WxeON2h7DI5LNTzyr1
	ACYuNc4AUHEwBVcVCSt1bpjS+bW88rlDRpB7V2j7UBqrTWSdjfcHSAYhYJj2Rh6LvSlTLtlc0Fy
	0GvIa+cQjeKs8Ah60iwQ8V/Nd+mDpgz5kIPM/m/Zwn9utSkFoHlNDB1bDNaRhxKG9YaF/KxE00o
	vD8CIDEcJ/bnHjxgdxFZwT1Cmt3otSfvQ2/6twS2is751+Bh08M8kgeBUmZrUjb9uqiPyBQdwxi
	nwacNd2MbnmOuX4RX1DvvWrNQv42hekg74AcXqNf6ga1P+k4sVnyaMS+8BNqczwi
X-Google-Smtp-Source: AGHT+IHr30AU8gUkUOajtLDfUZ4mNBp7HWZ5NYougOaC3hffGqaK7vxtWi1W/pr9TfB7/KbC+9COCw==
X-Received: by 2002:a17:907:7210:b0:ad5:3055:784d with SMTP id a640c23a62f3a-adb322b02c7mr322484466b.34.1748616714093;
        Fri, 30 May 2025 07:51:54 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::15c? ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39e15sm338851066b.149.2025.05.30.07.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:51:53 -0700 (PDT)
Message-ID: <4e5e0207-9749-4d49-8d55-9710c972b673@gmail.com>
Date: Fri, 30 May 2025 15:53:06 +0100
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
 <4207774d-5f78-46d6-9829-4feb24c81799@gmail.com>
 <341c18d0-dce2-451d-86a6-ad4c05267388@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <341c18d0-dce2-451d-86a6-ad4c05267388@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/25 15:37, Jens Axboe wrote:
> On 5/30/25 7:40 AM, Pavel Begunkov wrote:
>> On 5/30/25 14:25, Jens Axboe wrote:
>>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>>> +static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
>>>> +{
>>>> +    size_t ret, copied = 0;
>>>> +    size_t buflen = PAGE_SIZE;
>>>> +    void *tmp_buf;
>>>> +
>>>> +    tmp_buf = kzalloc(buflen, GFP_KERNEL);
>>>> +    if (!tmp_buf)
>>>> +        return -ENOMEM;
>>>> +
>>>> +    while (iov_iter_count(reg_iter)) {
>>>> +        size_t len = min(iov_iter_count(reg_iter), buflen);
>>>> +
>>>> +        if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
>>>> +            ret = copy_from_iter(tmp_buf, len, reg_iter);
>>>> +            if (ret <= 0)
>>>> +                break;
>>>> +            if (copy_to_user(ubuf, tmp_buf, ret))
>>>> +                break;
>>>> +        } else {
>>>> +            if (copy_from_user(tmp_buf, ubuf, len))
>>>> +                break;
>>>> +            ret = copy_to_iter(tmp_buf, len, reg_iter);
>>>> +            if (ret <= 0)
>>>> +                break;
>>>> +        }
>>>
>>> Do copy_{to,from}_iter() not follow the same "bytes not copied" return
>>> value that the copy_{to,from}_user() do? From a quick look, looks like
>>> they do.
>>>
>>> Minor thing, no need for a respin just for that.
>>
>> One returns 0 on success the other the number of processed bytes.
> 
> copy_{to,from}_user() returns bytes NOT processed, and I guess the iter

Sure, it doesn't contradict it, they follow different semantics.

> versions return bytes processed. Guess the code is fine, it's more so
> the API that's a bit wonky on the copy/iter side.

Which API? This command or copy helpers? copy_{to,from}_user are used
here in the way they're always used in the kernel, and that's fine,
they're not supposed to fail for valid input. That's unlike iter
helpers, which may return a partial result.

-- 
Pavel Begunkov


