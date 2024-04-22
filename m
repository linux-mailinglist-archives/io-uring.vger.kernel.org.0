Return-Path: <io-uring+bounces-1609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B4598AD3E5
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 20:27:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9A4A1F21AB9
	for <lists+io-uring@lfdr.de>; Mon, 22 Apr 2024 18:27:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46BC41552EB;
	Mon, 22 Apr 2024 18:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MyvobiZi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47689154C12
	for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 18:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713810454; cv=none; b=EQVmMHUeZXqDp+8jVBzwdRNCSRI3+yXo+5qcbUEx/rtJNy/hbGYQKEkUqMCORH1ljRJOi/Fw+aXZr382aMWocKA+DSAvGOyMGkKpHZtnxs65GBhM4DV5KBhrDjuslehGwnSfM4NdPaHcg8ELY5PC7Q16R5vj0RjzvLx4YJu4hGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713810454; c=relaxed/simple;
	bh=NbRPx8U6l7TKqqagb1LOqNTi4gmxfhyfbSWYu4vv1TM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DBdkRQRlsR1fQGS3c0zI9TvsTNOgy7DBRO5auXltS6RIw52mqXfGpjdjzscXc/OPRqvj/mPveVnhXG9Si/lGMpT3ppTg7xUMNPqqH/NayoPj0bDJjbzsQyaiQVSxqx4F6N8I6xJQhp02XLC0CjlIfUT+B7eVOLIa7Fh1AvqESBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MyvobiZi; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-36c0d2b0fdeso948605ab.1
        for <io-uring@vger.kernel.org>; Mon, 22 Apr 2024 11:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713810450; x=1714415250; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TEICl6bZH7kNUGOlyYtgXN5hM8fFIzE2nunBdbyAu3M=;
        b=MyvobiZiuV6ubhmjnRSdhNr6+/xWozWzSst85kI2sYtJNQHjj1QX/1rYiwnaX2rIM3
         Z/dTMq4KLJ1y/nyzqBrdykbNu1Pw2QdaRnDpk4kNNk6rRyMiWFzgb9RqrHHZx7Nrth+h
         nmwXVbFwBOYWurbpJleNUmZcYNJuoC8fdwA1g++VoJHoeNyhDHSKfaAxqmNRhE9QFp9M
         Bq7olmm2fsck8SYFsqc98LgZ0dkQ8F48zLquYp6Lp+CDul6hzNa2Aazw38AdSGoOMxVB
         fZAEnsi1C9PmAnCN8jBqYKnPMwFfvUpnmGl6hg/vuKOdVqJfr8/uCc8SlT2Z11f7XeSE
         76BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713810450; x=1714415250;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TEICl6bZH7kNUGOlyYtgXN5hM8fFIzE2nunBdbyAu3M=;
        b=lZMYeTBtZpNOS1OhgREzWC18moG39t7JEK/7kMMwPw2oZCoUWn1s7YuJkVCbPwAohO
         E8R2kRaWHr2nuasWZLh0KbGAxIH9cAZyR69ru5kyKdGO/FxC6BGRNFR+0P1FJZ3NPyHw
         w0Ei6zmUiHFuMWHjaqqN0O2XqSbRAWYP0cm+w0cL2w6WeA3ylSFCfFR19j70k5USBH1H
         qG4emKapt3Rhie+dJziZwl0IA2eYtraH5K9FPUZAAabIJPiMU+L1pHg6A/9RwC2mKuMq
         6CfZww2uemBs5TRwPMRFxeaV+nZufiy2LtCUCmOl+bybRRMe86iK3hBHLEBWDUPm80XM
         dyFg==
X-Forwarded-Encrypted: i=1; AJvYcCX86cv+q9K0rpquVZ2ufbL0AKg/8iRnArPVEdY7sFD8YrlDZO6hPmDqA3um7tVOROEVerxlpKwPqAXFLVdyA5Qv3Jt51As1Z7Q=
X-Gm-Message-State: AOJu0YwFb7gKUeypKj/YSK/lAWEpyrg94c628DOfy/1uijGSKUc6G33S
	xUgYS1JrDimUAdbdyTwriwV+Sz2V8lV7xeD1iOiF3OFc/tHDp9wjT4oCZd72Gf0=
X-Google-Smtp-Source: AGHT+IFiWPY5KtY+4EEfMUYMPrIExXglEBc8UWOKY8pk+Q1qXqIy9ztYOzurbkWpGi29o5c2nCocaA==
X-Received: by 2002:a05:6602:1205:b0:7da:693f:d676 with SMTP id y5-20020a056602120500b007da693fd676mr10951210iot.1.1713810450117;
        Mon, 22 Apr 2024 11:27:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ha14-20020a0566386b8e00b0047f1b5975e5sm2994521jab.76.2024.04.22.11.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Apr 2024 11:27:29 -0700 (PDT)
Message-ID: <e36cc8de-3726-4479-8fbd-f54fd21465a2@kernel.dk>
Date: Mon, 22 Apr 2024 12:27:28 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/9] io_uring: support SQE group
Content-Language: en-US
To: Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
 Kevin Wolf <kwolf@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
 <20240408010322.4104395-6-ming.lei@redhat.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240408010322.4104395-6-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/24 7:03 PM, Ming Lei wrote:
> SQE group is defined as one chain of SQEs starting with the first sqe that
> has IOSQE_EXT_SQE_GROUP set, and ending with the first subsequent sqe that
> doesn't have it set, and it is similar with chain of linked sqes.
> 
> The 1st SQE is group leader, and the other SQEs are group member. The group
> leader is always freed after all members are completed. Group members
> aren't submitted until the group leader is completed, and there isn't any
> dependency among group members, and IOSQE_IO_LINK can't be set for group
> members, same with IOSQE_IO_DRAIN.
> 
> Typically the group leader provides or makes resource, and the other members
> consume the resource, such as scenario of multiple backup, the 1st SQE is to
> read data from source file into fixed buffer, the other SQEs write data from
> the same buffer into other destination files. SQE group provides very
> efficient way to complete this task: 1) fs write SQEs and fs read SQE can be
> submitted in single syscall, no need to submit fs read SQE first, and wait
> until read SQE is completed, 2) no need to link all write SQEs together, then
> write SQEs can be submitted to files concurrently. Meantime application is
> simplified a lot in this way.
> 
> Another use case is to for supporting generic device zero copy:
> 
> - the lead SQE is for providing device buffer, which is owned by device or
>   kernel, can't be cross userspace, otherwise easy to cause leak for devil
>   application or panic
> 
> - member SQEs reads or writes concurrently against the buffer provided by lead
>   SQE

In concept, this looks very similar to "sqe bundles" that I played with
in the past:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-bundle

Didn't look too closely yet at the implementation, but in spirit it's
about the same in that the first entry is processed first, and there's
no ordering implied between the test of the members of the bundle /
group.

I do think that's a flexible thing to support, particularly if:

1) We can do it more efficiently than links, which are pretty horrible.
2) It enables new worthwhile use cases
3) It's done cleanly 
4) It's easily understandable and easy to document, so that users will
   actually understand what this is and what use cases it enable. Part
   of that is actually naming, it should be readily apparent what a
   group is, what the lead is, and what the members are. Using your
   terminology here, definitely worth spending some time on that to get
   it just right and self evident.

-- 
Jens Axboe


