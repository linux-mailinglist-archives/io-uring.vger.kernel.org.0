Return-Path: <io-uring+bounces-4301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6057F9B92B9
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:59:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 246F4284171
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 13:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 705CD1A0B08;
	Fri,  1 Nov 2024 13:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PcLL8V9L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB831BF24
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 13:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730469584; cv=none; b=rgAUUDFvL5rD3Ksh3kt9cXPjsDcqTwByw6qxWdNa4si/1paQRYntwSc51GQBL/l9ztYu2HzKi3Vbkc+WnTJZ2GsHWwOuBFD3KZ1k6b9uxNiFo67xrZh6U2o3anUHE9rcCG2UheubEv79ro5cisgeFnRMWOEja+ECAPZ0oeb8ITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730469584; c=relaxed/simple;
	bh=Ope7o+ZLBP1KpRftn53oEmbmV2rvwsZeKcfogt4TQPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fR6KB1tE+dXYQ8YjcHvcKd2setT1O3/Rh9FupdSNHruOAS/CitatmUGm1bcQktQPTB5m8DtrSHwAVld0M1yCTQ86a3X/oK7JKyGLJRtJ6cDv6lbFp8oTOBq1guYIR2PEG9lTntA1/xnNqf5SlJf74vSH3MCeDTkREA1hP64qIfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PcLL8V9L; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-720aa3dbda5so1480455b3a.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 06:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730469580; x=1731074380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5UaNe981wNt5HFRGg7NUMNMTV6m1WPggkaCgT6JhNm0=;
        b=PcLL8V9LBCjyeZDcX/WV1LTfKC+K8qu+X7KuF3PsSxn76glrCn6IUH0To/BWYMI/Nl
         kFGE9G88xreW4f810JePaoxiQCpiYRMb7UvBTy1lDWtfJ59RzbXIDzmpDTJAKv/FycBC
         0kBV5kzsSkCbhR9Zaigq8DCN+TlLM60kvx/gvBmPNSvtJh23vWYQFHaSf4wNIQKgehh5
         EyXZEoJGmyoT7VAxHRejxD3H9rE+F4QEKJzU/IuUpVl3R092Kg49lliAO5x7pRf3OFZl
         yR36B+8SOv5eA15N1rINdgK+Y3r7IMtMp2+gGXAUsEWW5hZRqtiTTwC8z/5+VMnC9Puh
         yFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730469580; x=1731074380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5UaNe981wNt5HFRGg7NUMNMTV6m1WPggkaCgT6JhNm0=;
        b=HQsL5V7shQE2ERTdxBpy0cEZsw8IPIdVMpIScmZhm+0ydbyBdvNGv6Y3kUcCQ8VGzN
         6gft7c69GCPMYAFSi+1TKILE+dHZYS6DkIal5fwzap72N6L3azRRrx9LhSuh4rk6vx2s
         i6SCxI3gbCCN3fr05nFy8oj2ZimPnhC4L485tF6aLFZRK4Fz/D6Wzv1TSGaKLAC5k29e
         0XADfUyY39pl61v9dg+gBNI1VpMCfpmWj8aZLKK4emhlRjCgZKuog/q038oTkH8IaquS
         UJW0xSmHQ0RQHVDhyDDH9tR8AEJ6U8VUQ0dxepmh3AxqY1A308ZVLeEE+A1SvhCI/P98
         Vj1g==
X-Gm-Message-State: AOJu0YyWEH/7gSdtCnJ/RUzCbI2qeidGPgq72rFh8iSL3dFAR8R3kBh+
	i0eH5mZQrcV4QgAS18ge2FSg9tMJ47hD3VsS522s+zMF8l7RmTimeJJxDimBLAY=
X-Google-Smtp-Source: AGHT+IF+sfIl7yiP0EP+wlV7nNJz+B6Mel/Pr1jNj1QXrayjuJX3YMx0JspmDNvfsJeIxOHzGKbabg==
X-Received: by 2002:a05:6300:668c:b0:1d9:1aa0:10b6 with SMTP id adf61e73a8af0-1d9eeb07c8dmr12723483637.3.1730469580212;
        Fri, 01 Nov 2024 06:59:40 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ee459f9050sm2549484a12.74.2024.11.01.06.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 06:59:39 -0700 (PDT)
Message-ID: <3a907323-331f-4442-a2a0-4e2757aaba8b@kernel.dk>
Date: Fri, 1 Nov 2024 07:59:38 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyRAKm0IQV7wWjhC@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/31/24 8:42 PM, Ming Lei wrote:
> On Fri, Nov 01, 2024 at 10:12:25AM +0800, Ming Lei wrote:
>> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
>>> In hindsight everything is clearer, but it probably should've been known
>>> that 8 bits of ->flags would run out sooner than later. Rather than
>>> gobble up the last bit for a random use case, add a bit that controls
>>> whether or not ->personality is used as a flags2 argument. If that is
>>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>>> which personality field to read.
>>>
>>> While this isn't the prettiest, it does allow extending with 15 extra
>>> flags, and retains being able to use personality with any kind of
>>> command. The exception is uring cmd, where personality2 will overlap
>>> with the space set aside for SQE128. If they really need that, then that
>>
>> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
>>
>> Also it is overlapped with ->optval and ->addr3, so just wondering why not
>> use ->__pad2?
>>
>> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
>> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
>> just a bit ugly to use.
> 
> Also IOSQE2_PERSONALITY doesn't have to be per-SQE, and it can be one
> feature of IORING_FEAT_IOSQE2_PERSONALITY, that is why I thought it is
> fine to take the 7th bit as SQE_GROUP now.

Not sure I follow your thinking there, can you expand?

-- 
Jens Axboe


