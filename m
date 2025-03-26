Return-Path: <io-uring+bounces-7252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A4CA71D2E
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 18:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DC4B3BBC2A
	for <lists+io-uring@lfdr.de>; Wed, 26 Mar 2025 17:31:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DC62397BE;
	Wed, 26 Mar 2025 17:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FnfTNLvv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5EE239592
	for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743010320; cv=none; b=ue/0h1w0DE1N1WmTVmEd6SP5/UF6/B9hbx9GIWQhjNZauMfBgyj3js219YYyzeyIJ9rF8qhQyBGeS/tgOtR9/KTxJoihxlhwqoFNNS5r7jH2uaV3TKx9/9fxPeQj2CegzAnA0rNOJrXEs6WOx1Ec6B4x49GjDCqgCxTPzD65pDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743010320; c=relaxed/simple;
	bh=ApVXiA9JPxeDJiY+bJAZzl9b29ymaQInYWf0uYBUIvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vqr0h7XcZjj5dRtlc63frgkNyeIio9LIUWCMSKyXr/COEpIsbm5a5Kcyw29yw9EqQUlRXf532Fp8PYry1xNW/0SjmYbe+YuR8wnU7Ra4FOnrMtQnoFFu/oPc/JUN1h8BPqMvqNeYhuy5+OfZLfhz8FkARqJsi4p2PL8UjekS5C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FnfTNLvv; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c592764e54so17937185a.3
        for <io-uring@vger.kernel.org>; Wed, 26 Mar 2025 10:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1743010316; x=1743615116; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SkIulgoTL6tlyyzZtYI7VaNWhJbd+nkeEIRVTyUEc6I=;
        b=FnfTNLvv1Cca7xDrMCgfJ+S1vzytkjgM5PBXN+r84suhm5g134Mkxjbxj0Vu4vEB/A
         60oQygg3mSqz3CRfPiyASJq4gmq35nPhJtKx0nEk3de4F32yzyk8jgRxxpx19txxIf3u
         NXezqfGdexN22HWtLO9PFrtsIJXizOI/j956GR40r9EAP/veMkGfec75Amd/BFp/0ajR
         uED5Lk8UHdvicb3c5p6oUhvJDfVFEX7i0+DgxlVXYqXItaftmQPnKgqJ0ZY5ipcVSM6o
         I41xn/mHV+XnHnW+y3vWG3gkMJ38V0rAi66Ap9OH+2KiTP5QqTDQ0xs+aNU8edKKSQm6
         SENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743010316; x=1743615116;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SkIulgoTL6tlyyzZtYI7VaNWhJbd+nkeEIRVTyUEc6I=;
        b=bGM4i1MZEKYkmut24mtf9NgheV5oG6GN5aRQnASsCcLsEPsF544CjBznij41UMIkWd
         NawAOJrE/RTmCBeRowW3ZIql4ea7SoULJJzttHpL6nHnH/HgU2ZFUYmVZGWe83azwvZK
         obOD3RRED3MlqAum+Khuay1hIE0/CQJ6SPN6USTr/trEm4RhioXbmBikybSwSfL4JZKa
         Q+lmYNZo/ckR/Z6gs4ZaFr9P8i1a23/Qzm7d1njYp0eYrEWvcM+cEYvY6U6gfM+AIipu
         +I1BRs/CMy+u9Hi6ZEmaB9LW/v+BIek1cIxjrI+Z/NI2cibx6PCC4APnzQbbObY/zGrq
         bCHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVGA9UtJA9EFQzR39fh0U8rc84vjpXIBtq08I9iPtn2rPuxutA0feNv3tnm8wrmdgV1Ft6CY6gzBQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywp4fwdrIMdoylEIiiOtaJXJPUrXRO6VWM45hDEFH5pB6+vtBQN
	Y07q9/ZnS00lmpm0zimRlHQgHRlV7i6eSOfj5Ns9MHv3qJ7qJQdmx1vOnyBno1c=
X-Gm-Gg: ASbGncubeMO133f9AxgYPhESogkrgg48wn/6RRdbcNLlR7Z79EAn6AGaL+atne+Ykvn
	Ij6gunpyNcXD2tDeaDabSCFcJcp54s37+RoCRw8/eoamxaub2TLsRZY5UM53830WNdDez1I+EGM
	IzoCZ2R+pLJnEdaJPg/J1KuDWD2oTvEN8Jhj0lPF/ugwvo2Op5SIA0GRfjf6XH/fSG2ht7P+eMD
	ibSUXSxrEOdBIcDldyGxB2EvuI7+fq+HNEMwrJgZt2z4TaHH45Zpq7HkmNXgNT+JmJP9ysrds1k
	r1MOFPHzAvRY7SlKeHu1UR6Q9xlgBABr79BaBhY=
X-Google-Smtp-Source: AGHT+IGcpvYp3s03Bz7oKBIO03FZbkxQfna6XvWcbUmCwGiU6FTlnxHk33r6KzJ7Cawr3NxN8yaEZA==
X-Received: by 2002:a05:620a:2912:b0:7c5:58b0:42c1 with SMTP id af79cd13be357-7c5eda12934mr74754085a.34.1743010311319;
        Wed, 26 Mar 2025 10:31:51 -0700 (PDT)
Received: from [172.20.6.96] ([99.209.85.25])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c5b92d68dcsm786416685a.42.2025.03.26.10.31.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Mar 2025 10:31:50 -0700 (PDT)
Message-ID: <570272b0-4d96-4e98-bf73-e313cc49918c@kernel.dk>
Date: Wed, 26 Mar 2025 11:31:50 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring/net: use REQ_F_IMPORT_BUFFER for send_zc
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250325143943.1226467-1-csander@purestorage.com>
 <5b6b20d7-5230-4d30-b457-4d69c1bb51d4@gmail.com>
 <CADUfDZoo11vZ3Yq-6y4zZNNoyE+YnSSa267hOxQCvH66vM1njQ@mail.gmail.com>
 <9770387a-9726-4905-9166-253ec02507ff@kernel.dk>
 <CADUfDZr0FgW4O3bCtq=Yez2cHz799=Tfud6uA6SHEGT4hdwxiA@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZr0FgW4O3bCtq=Yez2cHz799=Tfud6uA6SHEGT4hdwxiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/26/25 11:23 AM, Caleb Sander Mateos wrote:
> On Wed, Mar 26, 2025 at 10:05?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/26/25 11:01 AM, Caleb Sander Mateos wrote:
>>> On Wed, Mar 26, 2025 at 2:59?AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>
>>>> On 3/25/25 14:39, Caleb Sander Mateos wrote:
>>>>> Instead of a bool field in struct io_sr_msg, use REQ_F_IMPORT_BUFFER to
>>>>> track whether io_send_zc() has already imported the buffer. This flag
>>>>> already serves a similar purpose for sendmsg_zc and {read,write}v_fixed.
>>>>
>>>> It didn't apply cleanly to for-6.15/io_uring-reg-vec, but otherwise
>>>> looks good.
>>>
>>> It looks like Jens dropped my earlier patch "io_uring/net: import
>>> send_zc fixed buffer before going async":
>>> https://lore.kernel.org/io-uring/20250321184819.3847386-3-csander@purestorage.com/T/#u
>>> .
>>> Not sure why it was dropped. But this change is independent, I can
>>> rebase it onto the current for-6.15/io_uring-reg-vec if desired.
>>
>> Mostly just around the discussion on what we want to guarantee here. I
>> do think that patch makes sense, fwiw!
> 
> I hope the approach I took for the revised NVMe passthru patch [1] is
> an acceptable compromise: the order in which io_uring issues
> operations isn't guaranteed, but userspace may opportunistically
> submit operations in parallel with a fallback path in case of failure.
> Viewed this way, I think it makes sense for the kernel to allow the
> operation using the fixed buffer to succeed even if it goes async,
> provided that it doesn't impose any burden on the io_uring
> implementation. I dropped the "Fixes" tag and added a paragraph to the
> commit message clarifying that io_uring doesn't guarantee this
> behavior, it's just an optimization.
> 
> [1]: https://lore.kernel.org/io-uring/20250324200540.910962-4-csander@purestorage.com/T/#u

It is, I already signed off on that one, I think it's just waiting for
Keith to get queued up. Always a bit tricky during the merge window,
particularly when it ends up depending on multiple branches. But should
go in for 6.15.

When you have time, resending the net one would be useful. I do think
that one makes sense too.

-- 
Jens Axboe

