Return-Path: <io-uring+bounces-1371-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79125895D34
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 21:59:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3143D283E99
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 19:59:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0B6A15B0E8;
	Tue,  2 Apr 2024 19:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="evhFTEII"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9829F15AAA1
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712087963; cv=none; b=ma25THwNVjCyqXvETQ/lCoJ7E+tteDsx6F7YrAGAV5OMPSYUJ8NBzbhblkbAwV3TLdE9O4jwAy8AzWkPeqvg3JyADAiNowBtMvr8zFnJhf9S0Q8Bm8s74EYn3oj42x0dm4wqXAb6Y2Yu4Se5PU7TSNhYjCuta3dDvP9cj9UM6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712087963; c=relaxed/simple;
	bh=ctBaDdtB/zIaqzmsAi1WlfmOVv8kdm0fHOMUHEu7K7c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Lpd/SdNm6kaTwnxUQVeuAevFMwab3Pw8aquiC4kPz7EXxqgX6NTXBMRXQhwIJ1vziRbDpaMPhDlQLzTiht6XObtQx6GWjpqG2lkb1L9xQkTUoB8H9Q5D3ho1Q1gqgbYqIG9phLgwTbIX5dVn3QNaBfeAaZj0wuiboT4lVjse4QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=evhFTEII; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so41507139f.1
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 12:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712087959; x=1712692759; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w+2hPWENo2kIwhpmwheQ5zkf8aArr0SEpgp394tDYsE=;
        b=evhFTEIINL5yjusDJzMLYdTjHehxsOJbtE13sWCY87Nh4EWU0iKP5ewVhuZCaggXCi
         RasEpLX9VYaVjR0T885Kgg6upzE0zm/IlNFMri1oUCq4oBILbiPJzcfUqA9daFWbcJE2
         VzzMqiedPB6l2EVG/TlObUSnApGASeMXXUuMnYxVw/4NHNrW/MjWzFf6hgiR5/96MN2+
         H6/UiMPJEyu5Y+mShxygphSAql3DW6V7FMk04KrvNqWXG8khE4Y5524RGZz9+5V2UWNw
         X9LFljjSc1gjjdQSnuaCXD6634KNqAS2s1sja4KWoiOz21eO0aMyLEWeLQwrZ+S6o5Ow
         9i7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712087959; x=1712692759;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w+2hPWENo2kIwhpmwheQ5zkf8aArr0SEpgp394tDYsE=;
        b=ESTrrpVwMqgq9m1gfiPan8nB7tj8RHztxa5cblk7zHFswqC2shm/sqlqLUTFhMxFYs
         Wrto88mizTa926OjJjfVs+pYL9wSPT5cA18/bKv2tyas1zLCSLe08UiiL4kgw4NrKFNs
         IHzkGOkoHx4AXAXxycdPRcDdbmo9doBq/akhPUuP8C1T55vZhjPphSv671lr4PfdzA2d
         l3CQFAPG7BMFJ9gWu02zUXmbS5aDKdEE9Xa7KlRnIKSxOsgudhsHIOy52TTlWCHOgm88
         KgG3/lXkFmGqfnySFSjBT65TDRYyFZumLQZ01fOk5/FNiCp3XnDOU+tGito1icpVkzhF
         lDyA==
X-Forwarded-Encrypted: i=1; AJvYcCXTsF7H2GRzNZa5DbKx0vMrVW9ilJJ3PfumWCk/HR5HtBcgPYlQ8qo3KyI63uW+gQSykMPwwsGwOgB2ovevdTqumiI6NHQzPXk=
X-Gm-Message-State: AOJu0YwxKHNs9rXNMMTudKtyFOl8F8q/7p36LOTeEaVoGGnvGYaVb1TN
	D4ZPZAd79G4i1XNGsZ6ZHg4F0SyMddOoNE0hkvZpe0a4SkJTEEbLF+dDWXnniv8=
X-Google-Smtp-Source: AGHT+IHWEzRV0+5Be6w96HcI6dObzxMasA1ZubNSJc5I0ur8BSwnYn7rz2gasLq2yK0qIKxdcPHHTQ==
X-Received: by 2002:a5d:8706:0:b0:7d0:9e57:d0c1 with SMTP id u6-20020a5d8706000000b007d09e57d0c1mr12227306iom.1.1712087959658;
        Tue, 02 Apr 2024 12:59:19 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p4-20020a6bce04000000b007cc7c30e70esm3328712iob.46.2024.04.02.12.59.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 12:59:18 -0700 (PDT)
Message-ID: <bbcb9605-9d8c-4077-b8e4-01f26888b621@kernel.dk>
Date: Tue, 2 Apr 2024 13:59:18 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: kill dead code in io_req_complete_post
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>,
 io-uring@vger.kernel.org
References: <20240329154712.1936153-1-ming.lei@redhat.com>
 <d9f6917a-72ad-43a0-8f8b-117284b95656@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d9f6917a-72ad-43a0-8f8b-117284b95656@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/24 12:40 PM, Pavel Begunkov wrote:
> On 3/29/24 15:47, Ming Lei wrote:
>> Since commit 8f6c829491fe ("io_uring: remove struct io_tw_state::locked"),
>> io_req_complete_post() is only called from io-wq submit work, where the
>> request reference is guaranteed to be grabbed and won't drop to zero
>> in io_req_complete_post().
>>
>> Kill the dead code, meantime add req_ref_put() to put the reference.
> 
> Interesting... a nice clean up. The assumption is too implicit to
> my taste, but should be just fine if we add
> 
> if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_IOWQ)))
>     return;

And include a comment as to why that is there as well.

-- 
Jens Axboe


