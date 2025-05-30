Return-Path: <io-uring+bounces-8160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD4DAC91B3
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 16:38:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C982A3A9851
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 14:37:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26547235043;
	Fri, 30 May 2025 14:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C5OzxZkL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B515E97
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 14:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748615880; cv=none; b=UUnJ+zrKcyO/jjUwULYtPnfovBBsXZD2+akucyCdpTWIbiHDXZMBhHyUb3R98vMA9RiZhftGI93gU6wSi+lOrhdRyAj+Zev2AdFd3xcNKyatLR69oaqcwGZReiFhjfZRuQR2RGPkBxe+Wk7ioB57JFkB1rCjl0gzAcgkdCnAQTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748615880; c=relaxed/simple;
	bh=jusyCPRcdDXxKnU5dD7atXttEaOUrrRQlCnXvb4UrkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FtQAxYXpb2JlXaBWxifbNNo1D8N1++0SI5semq3GW9D3xzrCALxdUusdaKa/1/OX6go/cDbUOJjRRYJ5dWkTLGaPOqgOCsfWvk8WfxZcQgdbfoCLlMNpyoUBGTLPkPhUieCmAEbXEwLnqalVFySDIQ3JdDPK3gVLppaZIHOAjl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C5OzxZkL; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3da82c6c5d4so16351555ab.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 07:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748615875; x=1749220675; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t5EpHoCSGxlfgsqd3fUl3XVG3wyKQ97cFuWvZ5GUmXI=;
        b=C5OzxZkL5ziY4vHGyHGTve5VVt+omKRLAcqZc0H8BHv6zyWJAt0SBI//RBVYkD3teb
         ZQia6og0VyjeRr8+f00LSJawamDcZLPMl0AE/3HqpCdBdggSG/NcJ8kx1QS3gMvJsBnJ
         Ify17FF4Y4J16VHgq8pALz6HM++cx9gaYBCbe6bdf4QMk0FAlEyRGUV8C6b25eogntlE
         2o+s1OTNbwo4tr78n5zC49hmhCRhIX6bV2iWJb9CEwkc1dl3+xxGhielb7rDTdY6VlVD
         kCnoo+RmhTL1MK35xzXHTg1lOGAeShKgHbogOj+vn+J7acDGrjE550xLOuRCBfO2mzSe
         JKdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748615875; x=1749220675;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t5EpHoCSGxlfgsqd3fUl3XVG3wyKQ97cFuWvZ5GUmXI=;
        b=OsSoUaee/ddhpPB5nNnh9ydxaxon1TpRrFhuFk9F8BKQ4gEjcnvMUzJQfZcX/GvQQY
         wdRrVY3fgWSIaoWZ4SUY53/pononDYXboZvbEnCMc8hhOPhRODd0/MgJod/t8sAKI3Hs
         a3Mu4+ycLzCy/D83mOVAGDkp8zEoYCqbs3vP85LO6kdRlIboWGTlDOtUk5PWEUqnWPQ9
         195vk8rdstnjCPXpdFWQwXavZjD58mnKDxGtSClT336lTGwv52pnAxEQWMnihjx/8gmh
         Qv2mbVDjGs5czc3AoxIZ34xWVMAIdiqxV8eXIMCEF8R4da43dHxBNBMOFtl36F0UnmeR
         JqQQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1rZn+4V4eeRzAaZir9e3qI/ECqtjy5lz7cs2DTiaOZa8qkp/Rz/8Q1kIlb+ynYdvm6ZSbOksbmw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxn+Kc7SnpCXg4MjxT5VFwSdkuzJwxp0L/Vy9nhi5XMB08NvblT
	sIHH3kx3VE6eD+pIVHsvNDZan+mLA5HyccSpNKxBEFT/zFXBlQJ8bJF17NP50TmOlAQ=
X-Gm-Gg: ASbGncsFuz07tqg5MVPSmvCJ54CH/w1U/oTMuN+u6Disoi+xwCg8wVT7ytqLk2JZUSd
	6XJsRdPiuODkyy2v8+8J2i0xjSn7/2T/X/LYX8GFrU4XbkSCC2XqQIGUOVQdlQ2AlS+1LidoF9s
	4qgTRYvGrbHnlLoLUaCQ0NVgc3o1XCR5J7p5OGIod5ibLEnZ5LYRwb1GtFKtExAWka/FNLpXbeF
	04xkleGJ4uVrC2JQe/FA1zLHlvSHXMbcNdbknMdMkaofdHpoDNqhoHjnXyLQxY8XjkIiMUOz0YW
	mCia1oKqbSMn0+8nm9jrXBAH3C7I9akvw4IfuXDCN4orrVg=
X-Google-Smtp-Source: AGHT+IGtJsX6dcIBV4kRh88kiahEX73yhX1H+la/p8gC+F38tIpk/0OesPPWedmQGo1nR68elakN6g==
X-Received: by 2002:a05:6e02:1708:b0:3db:6c09:a60d with SMTP id e9e14a558f8ab-3dd99c35f24mr40366035ab.19.1748615870973;
        Fri, 30 May 2025 07:37:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fdd7e3c18dsm472439173.69.2025.05.30.07.37.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 07:37:50 -0700 (PDT)
Message-ID: <341c18d0-dce2-451d-86a6-ad4c05267388@kernel.dk>
Date: Fri, 30 May 2025 08:37:49 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/6] io_uring/mock: add cmd using vectored regbufs
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1748609413.git.asml.silence@gmail.com>
 <a515c20227be445012e7a5fc776fb32fcb72bcbb.1748609413.git.asml.silence@gmail.com>
 <bd72b25d-b809-4743-a857-7744a3586bea@kernel.dk>
 <4207774d-5f78-46d6-9829-4feb24c81799@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4207774d-5f78-46d6-9829-4feb24c81799@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/30/25 7:40 AM, Pavel Begunkov wrote:
> On 5/30/25 14:25, Jens Axboe wrote:
>> On 5/30/25 6:51 AM, Pavel Begunkov wrote:
>>> +static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
>>> +{
>>> +    size_t ret, copied = 0;
>>> +    size_t buflen = PAGE_SIZE;
>>> +    void *tmp_buf;
>>> +
>>> +    tmp_buf = kzalloc(buflen, GFP_KERNEL);
>>> +    if (!tmp_buf)
>>> +        return -ENOMEM;
>>> +
>>> +    while (iov_iter_count(reg_iter)) {
>>> +        size_t len = min(iov_iter_count(reg_iter), buflen);
>>> +
>>> +        if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
>>> +            ret = copy_from_iter(tmp_buf, len, reg_iter);
>>> +            if (ret <= 0)
>>> +                break;
>>> +            if (copy_to_user(ubuf, tmp_buf, ret))
>>> +                break;
>>> +        } else {
>>> +            if (copy_from_user(tmp_buf, ubuf, len))
>>> +                break;
>>> +            ret = copy_to_iter(tmp_buf, len, reg_iter);
>>> +            if (ret <= 0)
>>> +                break;
>>> +        }
>>
>> Do copy_{to,from}_iter() not follow the same "bytes not copied" return
>> value that the copy_{to,from}_user() do? From a quick look, looks like
>> they do.
>>
>> Minor thing, no need for a respin just for that.
> 
> One returns 0 on success the other the number of processed bytes.

copy_{to,from}_user() returns bytes NOT processed, and I guess the iter
versions return bytes processed. Guess the code is fine, it's more so
the API that's a bit wonky on the copy/iter side.

-- 
Jens Axboe

