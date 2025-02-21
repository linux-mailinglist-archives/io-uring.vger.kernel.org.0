Return-Path: <io-uring+bounces-6608-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F8DFA3FC04
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 17:50:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A410D88244D
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 16:40:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33AFC20DD6D;
	Fri, 21 Feb 2025 16:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Y2GBrl1Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B8D1EDA11
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740156001; cv=none; b=ly38vqtsrtSMnxIoSBw0rs+Sh8wSYAZqZ0ByOXvK38lvMbo4a9qvfunp/opBKHDa2EfmTqV65TPUXJXICGbrM0ZBOVMTXBSScFxs0WDcJ45xTDdKsWaPvUVDnyCgMCmL8FDbDSNlr5i7Xt2hmsN8hsFSxCvVg6vJXBSaiDHJhV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740156001; c=relaxed/simple;
	bh=VE5mMyStHsDU17NQ22dtIc4GazCDgcLebbjhX7Gm4lQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IcgjAgUhgZFMehFPyf0eWyVHN+Z30vibG+amPpUbka0v1/UWpOQ899U4w1mO3FJKy6SRMlw/0p0PiTpMq41lsCjL7esn+q7Yw6Dad655cnJJ5bL5bz7yjMp69+fmveMVN6rISAzjm91uC9uxds8XCuH+KbhvI8CR2/f6Lga6eyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Y2GBrl1Y; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3d193fc345aso7709695ab.2
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 08:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740155997; x=1740760797; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tpIVheEuZLG2iAHIpc9LKyrAoq5nqc9ptuNxDevkzBg=;
        b=Y2GBrl1YCah/odD6SEeL6NNdNgHuuHA5oMu1xzQeXx7mdo5U5Jy0ZGKMKllFlLjzS1
         dqzFJVDKfUEoORsrEAgTho30PKqum+rUlmoLUAofgt9SGG9ewqIo2aqYWW1LSa5KxR0r
         Xcd03+Rrzfpg0sg/xMMztPEdaXMAdp4aUgs/XCNs7Dyaw/+p/kb+565lvc2Ul+Kgbh2R
         7OKA5zIPvAKZIfuzeBOpJzqWGLmSP4XKCAIbPGSKHzBpUmOalOvp8um4HtXNSFtflxa8
         lhKfqRPejPPkqO7qtky4gTM2RT3Znm3I6O39ea2PlAFqgL2yXx2thhwRTpdij9d1CduM
         MJIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740155997; x=1740760797;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tpIVheEuZLG2iAHIpc9LKyrAoq5nqc9ptuNxDevkzBg=;
        b=FQ0pT6F5LXBf3kjBa+u6mrQvVe79XcIkNnvqveRLTcsQSk+OsCS8BB6ayq66n9v7qL
         99hUmTkj3ew+F8D+CT9qpikyIKw0rSC/RNst3B9KbEnDvHCH+iAQ8RClPWvkO18QL8x0
         WMyHkMqXodHRu3vo8ttMsHy9B2O1/iWNL/F34aD6fgbBQI+6bcwaoyaZ4TjQFBgsZDJQ
         LQ59h+x6Pw+2wV/K1vVlS3ny3QFf5LUtei/m9yKBJsfutLoKAWTKmjg71KICDz5MAiKz
         mJpITLUeQJVdhaYrsSWVy/CnlGBVCNyE5reTf+NTCOWfRbBTyQd9I6jbeNPafv57vcNj
         GgPg==
X-Forwarded-Encrypted: i=1; AJvYcCUQO+pzJzkye8d2l+6jqMH4l478yxMcctfxE1Evvyb3b7C8rQ/YLCrZEC4H6hUin3c0/O1Gc0XeYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzN+3JE9bHi/w6s2PV73KGE0iMz7gyiUo+LbxUePITx+1BHGJ5O
	IgKN+DePQQgqMa/kFy1HwopAS1tXt8ReKsCmDOmgarDtSjNVsCmS0/zLqhvSgTs=
X-Gm-Gg: ASbGncv5lp/3UcRM5bh44ZIKCjhJROt531Xwb+6sz2O4abSoZQHJFuRecPc9zFM4Jg0
	Dj9buRmPeyX9bwO0ycU7J/XEa3KilyGTSQ/sQP883Wa9SVbgoPMUHxtqyM2BI5YB92uaowH3jUB
	ZOhdvvcbtQnl91ejJ27LsMGd+Lc7GeBDN9vo1dD0Q6hUovo/GEp8ml2rqzPeTIUAeRmQCmqg8b4
	PqecslxF62USGlrA1GZP6saSSk/sinLch+wHZnm9iFOhjzgrkY3XrfDUX2/G21hnerovdgyua4F
	t1R6JcbGC2D8pesu3qXnNrg=
X-Google-Smtp-Source: AGHT+IEQDPSURcGXmuozZVdFy3UCuIUjqREgH/Da4GyTWHQurE3pBhVbAP+8ISGsn67fSxl7Tt603A==
X-Received: by 2002:a05:6e02:156e:b0:3d1:968a:6d46 with SMTP id e9e14a558f8ab-3d2cae6b841mr37216195ab.6.1740155997651;
        Fri, 21 Feb 2025 08:39:57 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d18f9c5bc9sm39596575ab.28.2025.02.21.08.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 08:39:56 -0800 (PST)
Message-ID: <0c1faa58-b658-4a64-9d42-eaf603fdc69d@kernel.dk>
Date: Fri, 21 Feb 2025 09:39:55 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
 io_uring_mmap
To: Pavel Begunkov <asml.silence@gmail.com>, lizetao <lizetao1@huawei.com>,
 Bui Quang Minh <minhquangbui99@gmail.com>
Cc: David Wei <dw@davidwei.uk>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20250221085933.26034-1-minhquangbui99@gmail.com>
 <590cff7ccda34b028706b9288f8928d3@huawei.com>
 <79189960-b645-4b51-a3d7-609708dc3ee2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <79189960-b645-4b51-a3d7-609708dc3ee2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/21/25 5:20 AM, Pavel Begunkov wrote:
> On 2/21/25 09:10, lizetao wrote:
>> Hi,
>>
>>> -----Original Message-----
>>> From: Bui Quang Minh <minhquangbui99@gmail.com>
>>> Sent: Friday, February 21, 2025 5:00 PM
>>> To: io-uring@vger.kernel.org
>>> Cc: Jens Axboe <axboe@kernel.dk>; Pavel Begunkov
>>> <asml.silence@gmail.com>; David Wei <dw@davidwei.uk>; linux-
>>> kernel@vger.kernel.org; Bui Quang Minh <minhquangbui99@gmail.com>
>>> Subject: [PATCH] io_uring: add missing IORING_MAP_OFF_ZCRX_REGION in
>>> io_uring_mmap
>>>
>>> Allow user to mmap the kernel allocated zerocopy-rx refill queue.
>>>
>>
>> Maybe fixed-tag should be added here.
> 
> No need, it's not strictly a fix, and whlist it's not yet sent to
> linus, the tags only cause confusion when hashes change, e.g. on rebase.

I do like using fixes still, if only to provide a link to the original
commit without needing to dig for it. And yeah there's the occasional
rebase where I forget to update the sha, but those get discovered pretty
quick.

-- 
Jens Axboe


