Return-Path: <io-uring+bounces-8656-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B952FB02D02
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 22:59:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EFEEF17A75A
	for <lists+io-uring@lfdr.de>; Sat, 12 Jul 2025 20:59:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2DB72253A7;
	Sat, 12 Jul 2025 20:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="noALKeZ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44762AE99
	for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 20:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752353954; cv=none; b=VfMYrmlYf1RPZ58Q5pa1bTCefeemR3SJQ1CbcmbcTkPKmJfvZXVtnKXHOTxj680eEufx6ELwdW8JW70d1L0dwlNOliQ1lix7Qg6d225U9JB8OCEz7kt904SE+YOo0QMAIrNBnDgv/ob9w+x2RbR8D8Zd0dGWgieyYKmBXkz1fkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752353954; c=relaxed/simple;
	bh=yRlZrIrQeyJ8Wl3z4bCE4cRAQ3HemPoNm9yrKZh/kc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B6pyrZLRxT5JudgbPuCSHvbwa3kxdTsmX5ScAL+P1RkTXg3iN+PMfjV6PTd36I8YZL6SKx1wFXpUrqv9vM2uGZ6WFyAWfVfKFdd66OwxMpA2sP8EJhsdw2yPcNXng5sAJRCjcYrJqIZL0zWKlTTvqJBpwKpzhGg6MGMQ6oHuPcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=noALKeZ2; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8733548c627so112820339f.3
        for <io-uring@vger.kernel.org>; Sat, 12 Jul 2025 13:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752353949; x=1752958749; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wqJWDF8M2UpI+xLr261vur2ziN6yR9iB0uwv3B4Nxxw=;
        b=noALKeZ2/n76zjDSM2V0A5jU4hwSF+cZVmFz2Wt9PXD/iw2/1vzUNgwppOv1M7FO5A
         OsRC0WsGay2nZLRhoLPmf8nMGSmJa4AxvCAEEMxq0UebDH0QhoFutlgiWA6zYGCBqjMQ
         thEX2vgaYaAfxPOtKJg5NRKGtST3QOBEGsMq/otw1XIhlJ35DeEIWpw+fYHdBius3B0T
         ibDkVHK/meO/0e0bhTg0tbtgHXfiHQuy01uoQlfY5mUpwo8CZfvQBZqF57+pYvCKOnZy
         dTC5KQ2W+wBKJnCeBefoPPChrTE+aseKAraV24YFqMoWLfS9mnOQccHsA8IXyhKvHs/w
         1dnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752353949; x=1752958749;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wqJWDF8M2UpI+xLr261vur2ziN6yR9iB0uwv3B4Nxxw=;
        b=A87Le2YAe/hIaeDkdrOu9imhS3ImbsS99kKgR6PLflEeC8Z85llwdbX6Fbm/72Vipw
         JVbCeEbtiogVKVxF38s4EdLSFVwNZweHlwZ0C6Z1czGWrIFSxnDKcJbnhWtvKmQHu+8y
         VmKcGVifadJocMz/gquGMjXjRfvcXfxSVsD8ICTtPWvdEz5q247i6exvDNZqFj93+PSX
         dejh9tvZ/TgAbfw4nLUVEOwQm/suyF0gXDjZlZXplAmswy1gfNLsVLn3+vrjzKbSbmNw
         6FNNaSGmIaIe/OmOBElVMnds+wbi90fdZPOB8S+kd3yD2jJNnEnuQTQecYbofol557QA
         VUrw==
X-Forwarded-Encrypted: i=1; AJvYcCXxGXLs10EOnZNW6GaHknExFsGhByyrGRQ7betA5LvtFXwisoS4X1rIBjbECdxEqjFu+tEVyRIhZA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxIcjbWpkTrFqAn2iXh3OPbsMIA8WUJKWsAkU8CjbJIOi3p+UgB
	YHfvSOmUWGvKh2HLedY95FB5qBcwFRpWiav5ND1K1vbLtdx9CSpIkYLwB2ncYpMGi7Q=
X-Gm-Gg: ASbGnctvf7047xqB+aMYXQKgJ0Co6dugW+cX8Jx3SwfxbK//BMy68mY4+tIF1bvvCrM
	8nbDWZ2XxAyCVq01hPtF3sKXMAsexzAeHlkBCyGCKSVVKvVKOwdIlYMQvIj6O/3wwQrqm0m7/I1
	qoe8KgnmQBlZFHsT5w8+w0V82wKdkQdyMjLMPQGE2pDPIOe6tRD/Btpe/pBmdNpa1OU49UDaaSY
	uyww2mPsa59Rvorefrx0XOBhLocTl/4iN+TZEYH7XWPJpYgQzl/rCxilGG6295UdD21KRM0kol3
	MTN2GD7Cwmt7MnQC65qfuiuox26X2eWEEVw2LpljwKaLsbjMzlUSakFe/f8BTO2NM92BTlzKoWX
	bhdKODRHPfF2IXfaV5bc=
X-Google-Smtp-Source: AGHT+IE2wAau2KCEr/0ipFtvq8+LTcFfUKbVShCtMpSAz6JNiG06CvlSx24cqDFV1X92IiyxbeKLqA==
X-Received: by 2002:a05:6602:6b0f:b0:86c:f8ba:5f08 with SMTP id ca18e2360f4ac-87977f65e0amr921696039f.1.1752353949192;
        Sat, 12 Jul 2025 13:59:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556973275sm1412247173.80.2025.07.12.13.59.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Jul 2025 13:59:08 -0700 (PDT)
Message-ID: <9d9b87d4-78df-4c31-8504-8dbc633ccb22@kernel.dk>
Date: Sat, 12 Jul 2025 14:59:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] io_uring/poll: flag request as having gone through
 poll wake machinery
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <[PATCHSET 0/3] Add support for IORING_CQE_F_POLLED>
 <20250712000344.1579663-1-axboe@kernel.dk>
 <20250712000344.1579663-3-axboe@kernel.dk>
 <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <801afb46-4070-4df4-a3f6-cb55ceb22a00@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/12/25 5:39 AM, Pavel Begunkov wrote:
> On 7/12/25 00:59, Jens Axboe wrote:
>> No functional changes in this patch, just in preparation for being able
>> to flag completions as having completed via being triggered from poll.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   include/linux/io_uring_types.h | 3 +++
>>   io_uring/poll.c                | 1 +
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
>> index 80a178f3d896..b56fe2247077 100644
>> --- a/include/linux/io_uring_types.h
>> +++ b/include/linux/io_uring_types.h
>> @@ -505,6 +505,7 @@ enum {
>>       REQ_F_HAS_METADATA_BIT,
>>       REQ_F_IMPORT_BUFFER_BIT,
>>       REQ_F_SQE_COPIED_BIT,
>> +    REQ_F_POLL_WAKE_BIT,
>>         /* not a real bit, just to check we're not overflowing the space */
>>       __REQ_F_LAST_BIT,
>> @@ -596,6 +597,8 @@ enum {
>>       REQ_F_IMPORT_BUFFER    = IO_REQ_FLAG(REQ_F_IMPORT_BUFFER_BIT),
>>       /* ->sqe_copy() has been called, if necessary */
>>       REQ_F_SQE_COPIED    = IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
>> +    /* request went through poll wakeup machinery */
>> +    REQ_F_POLL_WAKE        = IO_REQ_FLAG(REQ_F_POLL_WAKE_BIT),
>>   };
>>     typedef void (*io_req_tw_func_t)(struct io_kiocb *req, io_tw_token_t tw);
>> diff --git a/io_uring/poll.c b/io_uring/poll.c
>> index c7e9fb34563d..e1950b744f3b 100644
>> --- a/io_uring/poll.c
>> +++ b/io_uring/poll.c
>> @@ -423,6 +423,7 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>               else
>>                   req->flags &= ~REQ_F_SINGLE_POLL;
>>           }
>> +        req->flags |= REQ_F_POLL_WAKE;
> 
> Same, it's overhead for all polled requests for a not clear gain.
> Just move it to the arming function. It's also not correct to
> keep it here, if that's what you care about.

Not too worried about overhead, for an unlocked or. The whole poll
machinery is pretty intense in that regard. But yeah, do agree that just
moving it to arming would be better and more appropriate too.

I'm still a bit split on whether this makes any sense at all, 2-3 really
should be RFC.

-- 
Jens Axboe

