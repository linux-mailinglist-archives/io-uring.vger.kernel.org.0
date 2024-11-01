Return-Path: <io-uring+bounces-4305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C679B9381
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 20D6B1C216D5
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:42:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 491C21A7273;
	Fri,  1 Nov 2024 14:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3dpprIfX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668901AA787
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472168; cv=none; b=tIvliprlGMbTpxc4pztWQTuUs6pOPhYTmXuClHvm0Po4zAytVPWaF1+0PPmR537s5QKw8uGoEQ+ZjJ7/Wp4GMMRxfkp+JztYImgfwJ21xLHvdCgM4m7vi1uYcoYDr23WnzD8Je6gKNvYefdV0s6O/fvNWfSqDO8+RiZ0MQLrLe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472168; c=relaxed/simple;
	bh=mszviQ/L4y1bnkz10UAEd1/H4XcUKLujNcAGiHvIYLM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DQRz5Kc7WWKkr0APGq5S+EfiYwTGO+7MjxxUvzrMMRMnleUEhihFy1NQGDuTdmlH4wkw8kJ/WF6CINSX9c/KTnsaicpckjZ0qM60OXCxwDxDKGSaoOu+RThImDLvEIguuoTdMzKFWxLVs4OUlm8rENTTQrjR/bXbyBQw1ILSpwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3dpprIfX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20b5affde14so16676585ad.3
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 07:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730472164; x=1731076964; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBr+kumU7qmmAYNPmAe5037X2aivRbq/Uucz4QCN680=;
        b=3dpprIfXVvb9tc52i6JZHF6q65vLDwvB9TKdlF67laKSokT/GPbkP10GLxCQffA60V
         vvfKiwgGbyGwHW3KKFXz+njqZLmp3KDqCILVnIz6qsZnf5nXTzacvbBcRidjGVNJoGDm
         ENgWSaOa6X5lwoNxujIpg6Bo64ekuEyJpXwaxz5g+mX044/KhRHzl7Qr5Qtef0DxIv9A
         ZUt0UfI62s6r+TwIUlFglhw2ehaCLhsv4FjsDhwJGX1u8/8kpC1opTp9Ir0uLQDMkRfZ
         R9E10wOpx4XzoKMk1VOyH1zOVV21a+m526weYE5SGn4hbMofBynAoL/XGJmLz1gtqhYP
         Uqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730472164; x=1731076964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBr+kumU7qmmAYNPmAe5037X2aivRbq/Uucz4QCN680=;
        b=a6H2uUzet7pTQE8PE/ZUFHO/ZOr5TUc7LmftpKWYjWVYDfZ691xkalUOgYkL9/y8pB
         PxyGoOxJBGJBihNpAQ307IqYtFYPeaiU0FV41eRc2E4cPq8AH+nNZcg7W3C+CZrUsYCA
         7q1BXpxPhTAvB0rd5rCUl29LXJaeLQuXO/f7FZERgWxqHPXx9R7/72pwHC5FKlpg/vW0
         8g7arlH0i4pkId2FUWPtQ7Xlx0Z4JPe9AMacciCE7N2paMjcST5GhTOPh2E75oViMdCa
         veFACyCtcjT+MjR5K3wGmg/lQQX3cNX8EJltrNg6zNoCxSNtopTxqDdLaV66NQqginsU
         +bpg==
X-Gm-Message-State: AOJu0YzeapmMxPpm6TkWZtm3Cwy6yQRp3EU60X+uDJ99413Qad9cpEu+
	rQFDgw/9d3FeCf/FFDn1DR5CTBtrCwHralVSIcZ/GaAWu56XM6T/EEiZ/LTwKvi/98K7wLgaJ0w
	BiYA=
X-Google-Smtp-Source: AGHT+IE/dsO/2QHIGlqh3kr+tn0EAfzWL9GLQqFbzoofex/h8/KajrvSWAJR7C8NrmLSJb724daPrQ==
X-Received: by 2002:a17:902:f543:b0:20b:a5b5:b89 with SMTP id d9443c01a7336-210c6b0171emr278810405ad.35.1730472163625;
        Fri, 01 Nov 2024 07:42:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211056ed906sm22352705ad.32.2024.11.01.07.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 07:42:42 -0700 (PDT)
Message-ID: <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk>
Date: Fri, 1 Nov 2024 08:42:42 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
To: Ming Lei <ming.lei@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>,
 Pavel Begunkov <asml.silence@gmail.com>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora> <ZyRAKm0IQV7wWjhC@fedora>
 <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk> <ZyTm9rBQpy7WFdwK@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyTm9rBQpy7WFdwK@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/1/24 8:34 AM, Ming Lei wrote:
> On Fri, Nov 01, 2024 at 07:59:38AM -0600, Jens Axboe wrote:
>> On 10/31/24 8:42 PM, Ming Lei wrote:
>>> On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
>>>> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
>>>>> In hindsight everything is clearer, but it probably should've been known
>>>>> that 8 bits of ->flags would run out sooner than later. Rather than
>>>>> gobble up the last bit for a random use case, add a bit that controls
>>>>> whether or not ->personality is used as a flags2 argument. If that is
>>>>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>>>>> which personality field to read.
>>>>>
>>>>> While this isn't the prettiest, it does allow extending with 15 extra
>>>>> flags, and retains being able to use personality with any kind of
>>>>> command. The exception is uring cmd, where personality2 will overlap
>>>>> with the space set aside for SQE128. If they really need that, then that
>>>>
>>>> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
>>>>
>>>> Also it is overlapped with ->optval and ->addr3, so just wondering why not
>>>> use ->__pad2?
>>>>
>>>> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
>>>> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
>>>> just a bit ugly to use.
>>>
>>> Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
>>> feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
>>> fine to take the 7th bit as SQE_GROUP now.
>>
>> Not sure I follow your thinking there, can you expand?
> 
> It could be one io_uring setup flag, such as
> IORING_SETUP_IOSQE2_PERSONALITY.
> 
> If this flag is set, take __pad2 as sqe2_flags, otherwise use current
> way, so it doesn't have to take bit7 of sqe_flags for this purpose.

Would probably have to be a IORING_SETUP_IOSQE2_FLAGS or something in
general. And while that could work, not a huge fan of that. I think we
should retain that for when a v2 of the sqe is done, to coordinate which
version to use.

> Also in future, if uring_cmd needs personality, it still may reuse top
> 16bit of uring_cmd_flags for that.

Right, that's what I referred to in terms of uring_cmd just having its
own way to set personality.

-- 
Jens Axboe

