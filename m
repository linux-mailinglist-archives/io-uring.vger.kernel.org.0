Return-Path: <io-uring+bounces-4264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D5DB9B7B9B
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 14:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504D71C20A99
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 13:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB451991B6;
	Thu, 31 Oct 2024 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UKqxr8Gq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF5919DF8D;
	Thu, 31 Oct 2024 13:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730381112; cv=none; b=NayJ6ymqmQ7OqyYcfQHlcpew4ZY84Oe07fqrZjVloS8zkd5zHoWAUtl/HKJdpeLkEh6MZ1fJdFFHT9VZ47DOln9Ibos+gVg1cTxaWG/TdnBKbhwy02uGrik7lU57W8UxEohgKft8g9JAaEBZ9qbuUZDAH8miFKEghHLxgVUGAcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730381112; c=relaxed/simple;
	bh=toSLAGN4xN7lUpujsiGaFRBsZJh4djUOjpeLDkKG6wE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qSoETmoo55JluiP8SdKnGiJCymKPTS4FaD1tgQI5rLCiX1NwSehkOI2DdezY/u3YszUCRVbFF23RO7qsA4k20kMS8dhSQdQ3R3bWEIFKqrAjb2nck5KGSaf4sXnKvSogqkY9FGLL9Mo+kjk4tXcQulVS4KNnPXSz6Wz6B/WUeVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UKqxr8Gq; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a998a5ca499so120588566b.0;
        Thu, 31 Oct 2024 06:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730381109; x=1730985909; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K6cbZF5NkvGcs+kZ0RnSIe9pMIrHfLfqVnHAPL6wpb0=;
        b=UKqxr8GqtKfmmAQZOlEnTgPdG3qapfNTZK4javvFQq3t7rBvbW+mAEqTojQEEYsSZa
         wk/bt6n8izlR6Ysh/vOBXsQh6Zfh9MwqU+DKtxG/yKjuFsyRPrvXxAjxhNWhudRzPn40
         8bdU6MW3J8QEwRPS3RXx9/mkR88/fMKpJACQPlwzJ4UjLYT042fXNJMtQ1804LT80w9i
         V7TDhRgtRtfdOC7gc9PD15E8LazMYYJWXnYV5sZUyt+kXNm8Nj/vE7kD3UnNx2gzphp1
         hMD1Q3aHVnbf53y8jIdWS5c4pGA7lEVLYEkEBL9vYClv23i80tsR97CyC9JPDp4/v81N
         jq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730381109; x=1730985909;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6cbZF5NkvGcs+kZ0RnSIe9pMIrHfLfqVnHAPL6wpb0=;
        b=GaBYy1MQhtVr4bxBHVxPmYvtICxhEBlsl7cvNXG9Yb8AHQ9rhtQ6bJ+BBKBVrNJ6gd
         4c36xNM+QccvU9X1LyagMGz3vltaDs2p2IMK1ai7/qdhG0UWefR5WFsMpdqGKXexKvR/
         MtGdCJyGPtk4/Yh/W8Accrug3DOaiEQktWgJO6SWUuJd0WWdtB331SHwC/P4ndpXFfM+
         z3QG8abucYUJMhY5NJph9eKHInUc5T7QAmkSh+NW5uFRSuhyu0QorAZaujCzeI1gQ8D5
         6u9Ls47FD69DBBjy5Idfcq8lmHmpsSDyAm7wTPC4DfeGJOz2e0uzbRsBfNXgSu7xozqi
         Jodw==
X-Forwarded-Encrypted: i=1; AJvYcCUC8eLscs5yu2+lRtGu8+vCbYb781tjjsQjAw3txCbFLiN9ytUT36yCBZB+pdYen0PWxHTZF0x6INv8lA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyGxq7L/qjRmLDPcgglPTCgkwBaYT5ckWzkNwtmuew8tVmbqFZP
	JbfC3hzD4GQVIEF0yQdsoYjSmIji5RSLAzNCaEH5fPYgANX2ustq9akoag==
X-Google-Smtp-Source: AGHT+IEhDyciBUCuAZsPH2a1Cy6ciaDnBtFuYoncECF/kIVnXzgCi1ODSO4LOxHUcNiGlbOyOWAzOw==
X-Received: by 2002:a17:907:7ea0:b0:a99:b2c5:86e9 with SMTP id a640c23a62f3a-a9de5cfea9cmr1808633766b.11.1730381108366;
        Thu, 31 Oct 2024 06:25:08 -0700 (PDT)
Received: from [192.168.42.141] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e564cc430sm68966766b.88.2024.10.31.06.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 06:25:07 -0700 (PDT)
Message-ID: <1f40a907-9c53-408d-997e-da49e5751c66@gmail.com>
Date: Thu, 31 Oct 2024 13:25:24 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 0/8] io_uring: support sqe group and leased group kbuf
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
 <15b9b1e0-d961-4174-96ed-5a6287e4b38b@gmail.com>
 <d859c85c-b7bf-4673-8c77-9d7113f19dbb@kernel.dk>
 <bc44d3c0-41e8-425c-957f-bad70aedcc50@kernel.dk>
 <e76d9742-5693-4057-b925-3917943c7441@kernel.dk>
 <f51e50c8-271e-49b6-b3e1-a63bf61d7451@kernel.dk> <ZyGT3h5jNsKB0mrZ@fedora>
 <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <674e8c3c-1f2c-464a-ad59-da3d00104383@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/24 02:43, Jens Axboe wrote:
> On 10/29/24 8:03 PM, Ming Lei wrote:
>> On Tue, Oct 29, 2024 at 03:26:37PM -0600, Jens Axboe wrote:
>>> On 10/29/24 2:06 PM, Jens Axboe wrote:
>>>> On 10/29/24 1:18 PM, Jens Axboe wrote:
...
>>> +	node->buf = imu;
>>> +	node->kbuf_fn = kbuf_fn;
>>> +	return node;
>>
>> Also this function needs to register the buffer to table with one
>> pre-defined buf index, then the following request can use it by
>> the way of io_prep_rw_fixed().
> 
> It should not register it with the table, the whole point is to keep
> this node only per-submission discoverable. If you're grabbing random
> request pages, then it very much is a bit finicky 

Registering it into the table has enough of design and flexibility
merits: error handling, allowing any type of dependencies of requests
by handling it in the user space, etc.

> and needs to be of
> limited scope.

And I don't think we can force it, neither with limiting exposure to
submission only nor with the Ming's group based approach. The user can
always queue a request that will never complete and/or by using
DEFER_TASKRUN and just not letting it run. In this sense it might be
dangerous to block requests of an average system shared block device,
but if it's fine with ublk it sounds like it should be fine for any of
the aforementioned approaches.

> Each request type would need to support it. For normal read/write, I'd
> suggest just adding IORING_OP_READ_LOCAL and WRITE_LOCAL to do that.

-- 
Pavel Begunkov

