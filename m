Return-Path: <io-uring+bounces-7069-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id F3A20A5EEA1
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 09:57:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F1D63B7127
	for <lists+io-uring@lfdr.de>; Thu, 13 Mar 2025 08:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19D6F263F45;
	Thu, 13 Mar 2025 08:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbHr2b77"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24B31BDCF;
	Thu, 13 Mar 2025 08:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741856216; cv=none; b=HVkrx/A3/sXdg96DNvgpXAYdiZa3mlFWBaFSuDB5lu33xCpw/VUVwexi7odQFjcMojDTQY2D3zqmxcV6IW7IfvrlEBYYzCULJw8tzZRea7Ae7/bVb8vb5XBvYks7f4uqey5IRMuqlF3clqqTo1+oeC3vt4361LH6gW/ilhTQjks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741856216; c=relaxed/simple;
	bh=c039YNETMcNqRqnRXKVd621FpuTy63kWGtPKmojyopM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=paLJoooKPg/qGbjJKUJbCf9sk+I248Yeqc3wAiOnE1b34nTM4yfh9ZFYtKs2oS6NVDxsafbagKaV84LdyaIOlnL+RQrX/FmHiYTZ+w0QmUONqC+0mDoMd5oG4GvrSYx05qT+YpAYjKcRL9DgV8+I+0/0XWQXP7MCH7jH3xKNBk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbHr2b77; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfa7e7f54so4320445e9.1;
        Thu, 13 Mar 2025 01:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741856212; x=1742461012; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oRQXI6lA2k16mQbfcxjJ2ekaa8g5t6U5iqSudrtHjjA=;
        b=RbHr2b77WEX+8OQYm9ei0rK7hDls0lNU+tMkWCYnCRiwspPM8Q6fCJE/Jno8x5atJH
         m7KuVAG9SNEXU2faLk9C+qwjvVzwNGE9QUxzm6xjhXAM1asV7HqZ+8sE9LbRGI0CvPVC
         2Hp+EnlRIovpN6bohh2ahV/H7TeA1vbKtXTVMpFLrOBI0++ILsXJNKHCAw3roXdINiWG
         3C0RDMLiYs/VQGsDpHZwP00D4xRP2VMaki2oUdyC1b1QwE7GbEcbO4T9eDZPGS053iv0
         UJ36GcsnHV2e4vEPY45dqmzsVa7jKCXkqv1m9661HNmUqmmb0PL71ASAhD56Ntd6N7yD
         UPYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741856212; x=1742461012;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oRQXI6lA2k16mQbfcxjJ2ekaa8g5t6U5iqSudrtHjjA=;
        b=I5AiJkAt8jioh81GWypOn7vsF94nZioD/RyGp2gIZbxkl6pu/xCw1Lny53HVxEWbtG
         3UHvUGg/0rjCBEwzr0+Yx5jrtNb+3+I2CrU76VvzMr0CnbNwE+l82dIiXFDrsA2cNiFp
         zhD/ivlM5vEhFahzwbAwz4yg+tXA5Ar7kGWW1tZAw3oLzrjnTOhyQhrtysw9onClexOc
         +sNR6eA6QcBXX4/49V/nZxLbwkNUFYvgJKnYxjM9c/uI/NNRmBTSjC4UShP2JDe0FICg
         yD4sQlFT0aGI4Eks7ruWNHA7sG7BcORx2q2yczYMDAJsJg+qtcqp8DTwZjTsO6cYCNdW
         oodg==
X-Forwarded-Encrypted: i=1; AJvYcCUpuePeSBxyHMH858TbP+x1rzACqmlGNuLEXLg+7yk0xyYTjioGGLgm5oo2ce4h/2DEWpvCTKFcFg==@vger.kernel.org, AJvYcCV6ykcz47UWj/2TNrxT00R4G8I5DGd3ko3NbuH26uaNSGWh63YrFX6nU2fucuzcymCNCvwmJd/Up/3ptKj1@vger.kernel.org
X-Gm-Message-State: AOJu0YzTfERvr3HcIjor+gB+cyQ45L4kYjBYPmTFNfqkQeHqh1nmOIu/
	5QAR/Z26fJQ/roVRe65dtn831hD2snO4QYVZlDWQkjvfMQK3zJnvxhWFgKEp
X-Gm-Gg: ASbGncsPamE9oDwit0uTOSTvfXFPcNh67hKAl8m2tfxbvWyiewGj0TfIYFWsOyHn5y2
	+S53D0NAsC0a4CsooZmm2FvetYoZlKrtryUJzJMjAprZrFuAMxMaCk+k5G5iHT2HKxaG8mdl5LO
	KwDwTiWVvfSEjRJyqVr1gpCLlSituRu+muNxGjiGKQINjV1zrkr1x/z+Za+GkXWe2sRMKEmmQI9
	fArZz/n7DCzFZzNdHRMuTqYkKlcoH6aX20/x2ZvwC9RCRu5gP+SHBKD9gZfp2KPThyFwI3iskIe
	EU2xSuEW2F4xgDUrhOsOGfQBqhGz9RhFIydTKiStuOin4ikE6BNOORJ6eA==
X-Google-Smtp-Source: AGHT+IGzld6XmsHuSGyS5xO4/BFT6L9qRZC3dbHu5qjOj3rnyoHn2qbidcUUT57sIIpYDj10Qe2Y+w==
X-Received: by 2002:a05:600c:548e:b0:439:873a:1114 with SMTP id 5b1f17b1804b1-43d1c18289cmr70405e9.6.1741856211785;
        Thu, 13 Mar 2025 01:56:51 -0700 (PDT)
Received: from [192.168.116.141] ([148.252.129.108])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d188bb34asm13182135e9.18.2025.03.13.01.56.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 01:56:51 -0700 (PDT)
Message-ID: <7a4217ce-1251-452c-8570-fb36e811b234@gmail.com>
Date: Thu, 13 Mar 2025 08:57:45 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/2] introduce io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250312142326.11660-1-sidong.yang@furiosa.ai>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250312142326.11660-1-sidong.yang@furiosa.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/12/25 14:23, Sidong Yang wrote:
> This patche series introduce io_uring_cmd_import_vec. With this function,
> Multiple fixed buffer could be used in uring cmd. It's vectored version
> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
> for new api for encoded read in btrfs by using uring cmd.

Pretty much same thing, we're still left with 2 allocations in the
hot path. What I think we can do here is to add caching on the
io_uring side as we do with rw / net, but that would be invisible
for cmd drivers. And that cache can be reused for normal iovec imports.

https://github.com/isilence/linux.git regvec-import-cmd
(link for convenience)
https://github.com/isilence/linux/tree/regvec-import-cmd

Not really target tested, no btrfs, not any other user, just an idea.
There are 4 patches, but the top 3 are of interest.

Another way would be to cache in btrfs, but then btrfs would need to
care about locking for the cache and some other bits, and we wouldn't
be able to reuse it for other drivers.

-- 
Pavel Begunkov


