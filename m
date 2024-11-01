Return-Path: <io-uring+bounces-4313-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B9E9B95EF
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C0A7282347
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 16:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6825443AB9;
	Fri,  1 Nov 2024 16:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VTNuA18C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B651CA81
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 16:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730480138; cv=none; b=T4hoN0tpqT2qR6XdmT517K2w1THxS3sjcomBIRHtRNftf7V0ljUyrLNBqIJgKgMF+h+I5MkUclQ/foISSBf/ebq2zL8JNXvoYZvV/tCLEaFks2xLffkYvyMmxqteJZvlcgWzj8v3kt6Z1fC1RJcJa28cBpERW5Wai2I9QyeGqZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730480138; c=relaxed/simple;
	bh=ZwtFM6tqS5iWTUSH6d+8Siyo5flIEfbUwnEmnG/4ZWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QbI9Zpy/hIr+1G3GJyynj/a/4uB85Gtyqs+fnguMYZ5KG6OlQifYmgwWK0x3+XpLhd/H5Q+CDT0wvGHg0H27Px3U0tGuZJ0bQS4iTtpaDgpt3aHnUdun425YjNBq4GghfrjTi9NuND8hHcx5MTr/72Dnxtn6jxP7qjxw4pxYi4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VTNuA18C; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43163667f0eso18216995e9.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 09:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730480134; x=1731084934; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jwY4U1v91GDeidMfbeJFNL74/RHGRTgB5aXeEpadhTY=;
        b=VTNuA18C78ZDi/cTbMNDrsIx24t54VPv+Z86+77AZg9tX0l+rWHrUnTujxKwsdA9Yw
         RXQVavwhy3LjUyHVI6FoSEx6onbVvC20rAMoE64AiZaFMfM+nagqNvKCcODgqCVtw8NA
         JMFtN3dZh8cmC2D8Gpam1Lr3log+ICq4JBd5XpaoJCBvAN5PjsKlfnAmZwIaikQLxApD
         1DgCNg+eeQTf+am5HEWKsMKGN+gnGscypZPihnDu52iLlTiWwcnE/PZlN6wamxycgLUN
         Usep5cGjQ7Zbh8C63LAs/JkRw8JxFKyOBkYpugovQhHT6GPhsuI4B7vUqO0jCcJxBA44
         Vo8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730480134; x=1731084934;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jwY4U1v91GDeidMfbeJFNL74/RHGRTgB5aXeEpadhTY=;
        b=b7mOswFc/RKIBOxtIUFAmvqcj6hcGbNnQxAICfOCa3s/nmm9zwwM/SvmbSovCO38nv
         IGw0kdSeYVh460sNJzT4woF52jgDVVYD8fMgyalX2jEVYsQg6OzvscTSkXArcwivl9ER
         1mAx/G3VNcj7Diz8d4dxpvXmuFcmjU9ycbEWtYfcZnjSx4FwqfGnxAxPFcCk+IB6TvPj
         X6hjsyjlgLlBmF+EzCAalaAOajG6DeZd/j0EZcuNq+RyL0ezt63E2Aew6FVOVxdyr0GH
         8Ka7fa4qGcV+uyVCH/NlKuP6qZVa8oOJG2RjAd2JknCRIWcZZIYvWGfEA3xCDUPn90KN
         JBCQ==
X-Gm-Message-State: AOJu0YxMFGEsTGjA3s5HFzqGwZuLWzxTh1yMIeQn89b63oi/GZS+Ldjq
	DZfljdLWFyiPNDvsAFcrCUP8eOBHRIii8baAZVmjmbVeuqRoGOwuHkUINg==
X-Google-Smtp-Source: AGHT+IEpnRj0xKg5KPiPSZln8nbQY5cmjR5V8qj34lTe1Mn21K7XCQFl5cisUpaNdKPWbMxvFfBGXA==
X-Received: by 2002:a05:6000:1541:b0:37c:cee9:4684 with SMTP id ffacd0b85a97d-381c7a5d493mr3341105f8f.14.1730480134310;
        Fri, 01 Nov 2024 09:55:34 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d5bf225sm66588155e9.11.2024.11.01.09.55.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 09:55:33 -0700 (PDT)
Message-ID: <73389bbf-5fc6-4256-a76d-2a027154a0d9@gmail.com>
Date: Fri, 1 Nov 2024 16:55:46 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] io_uring: extend io_uring_sqe flags bits
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <e60a3dd3-3a74-4181-8430-90c106a202f6@kernel.dk>
 <ZyQ5CcwfLhaASvMz@fedora> <ZyRAKm0IQV7wWjhC@fedora>
 <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk> <ZyTm9rBQpy7WFdwK@fedora>
 <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e648e765-9076-4236-a75d-c7baf68c1040@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 14:42, Jens Axboe wrote:
> On 11/1/24 8:34 AM, Ming Lei wrote:
>> On Fri, Nov 01, 2024 at 07:59:38AM -0600, Jens Axboe wrote:
>>> On 10/31/24 8:42 PM, Ming Lei wrote:
>>>> On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
>>>>> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
>>>>>> In hindsight everything is clearer, but it probably should've been known
>>>>>> that 8 bits of ->flags would run out sooner than later. Rather than
>>>>>> gobble up the last bit for a random use case, add a bit that controls
>>>>>> whether or not ->personality is used as a flags2 argument. If that is
>>>>>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>>>>>> which personality field to read.
>>>>>>
>>>>>> While this isn't the prettiest, it does allow extending with 15 extra
>>>>>> flags, and retains being able to use personality with any kind of
>>>>>> command. The exception is uring cmd, where personality2 will overlap
>>>>>> with the space set aside for SQE128. If they really need that, then that
>>>>>
>>>>> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
>>>>>
>>>>> Also it is overlapped with ->optval and ->addr3, so just wondering why not
>>>>> use ->__pad2?
>>>>>
>>>>> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
>>>>> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
>>>>> just a bit ugly to use.
>>>>
>>>> Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
>>>> feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
>>>> fine to take the 7th bit as SQE_GROUP now.
>>>
>>> Not sure I follow your thinking there, can you expand?
>>
>> It could be one io_uring setup flag, such as
>> IORING_SETUP_IOSQE2_PERSONALITY.
>>
>> If this flag is set, take __pad2 as sqe2_flags, otherwise use current
>> way, so it doesn't have to take bit7 of sqe_flags for this purpose.
> 
> Would probably have to be a IORING_SETUP_IOSQE2_FLAGS or something in
> general. And while that could work, not a huge fan of that. I think we
> should retain that for when a v2 of the sqe is done, to coordinate which
> version to use.

A setup flag over an sqe flag for marking IMHO would be a _much_
better approach. It doesn't take an SQE bit for nothing, you can
parse and process it in the slow setup path, enable static keys
for the hot path and so on.

-- 
Pavel Begunkov

