Return-Path: <io-uring+bounces-4300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCEAD9B92B6
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:58:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E5C228409A
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 13:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC24F1A0AFE;
	Fri,  1 Nov 2024 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AFM/bTHw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831401A0B08
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730469527; cv=none; b=I4cjG1CTm9Vix7/bjtuydml2IllHuLZVI2CmDm+70Eu69E68satz3uc0cWeTKh+0IeDiNVvDhAdLosNoU+LuDqQbt709gWOyeQg/RlMgkv16ib4/jgyUCPdzCeL9xaGb1PAcoSXU5LqZY1bOapJ5JS840JblksJgLQHpIMXcjcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730469527; c=relaxed/simple;
	bh=YggvHeRV4UPpndcbBp7jj5FFhGYrbIXPbf3zVCmLw0M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OXBP2YIzEjVinjZ3Gs+46kXxUerlkVKbZRVjNHmTQSml00K6UE86lkF42pAOlybjZ2/mNmq2SQRb6Gu9d4nK74nsoQWX+C4nPhpMOHchZ2Qxfve5UFSWlXoMWbDyRPY/TJaINjJOYmiZTt0ZNFnxk4jkO5gA13S2EOZoJsotYnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AFM/bTHw; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-20ca1b6a80aso20820785ad.2
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 06:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730469522; x=1731074322; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N4YhYN4Kj8tat0wLdEiKS2P4Bg0yoIWYMODnrc6fE9M=;
        b=AFM/bTHwk0OFUH106WuXoKM+vepwizwYTvhD9JWSBNN2tbd061aZ9THYeh26J864GB
         c6WY49zR7LV0EzRfbwjo5MTvBEaJONTDFa82XW44YKxJWY/pF8OQDlAdnXN5PD837sg+
         1ZRyjWaC3QohJsRBXknwqWQfescUHJ/QjKp9+9NPnV9K+OYJAFsSjEFl84YdO9gX2Wfr
         od5axPY481Xm/hVA1lukESqWZUyTqUTo7kPx37/gRb+lsJ41O2A1LKHoWPyxbHZdV7qL
         +cDGAnctYLFGJNiFmkydzo7ehTr0FEKXN/RG1ulvBKSoqX8P5PXIWFeKJbeLb2nUeXb4
         brBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730469522; x=1731074322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N4YhYN4Kj8tat0wLdEiKS2P4Bg0yoIWYMODnrc6fE9M=;
        b=AiXwW+0S/BgPROGHjGQr+h5quE5XvicghzzLD6/7opLx9DNDjYz3Gbb3nHr/qZJH8v
         sCAT5R1S0fL7vePrlbWRHmUtdw9s3qvk6n6z8zEwnK7Td5RuBbAOdTQT3v9vbipW276+
         ABA8twK6S6y9kracGzwSwpsOWnQsVg/K9fo7Prr4DWRyoleSU4KY1Bsza4tOvybu/Y/4
         L2Bvlg7hGemKbe6J+v0Hhuiq9XdSDSCCefngcdRT/1aHYiAt6XgrYUE1gf9/0vs30sew
         bC/UvsYfn/J3Hd+WJqQQ2mombk6dP+SjhujgLccT7a92fYFPE6XNjYHlqOvEXuHyYHIb
         Aa2Q==
X-Gm-Message-State: AOJu0YyyHrfdAixJXlJqUI0sRiM638N5LabPvj/SG+0BnCCsOyN+fL7F
	qkfZ93B/t5ZmioPJxMgb+VKNtrZHjO6HhcYtSojj2Cz89cS3Qiag4rQXGcSLY/A=
X-Google-Smtp-Source: AGHT+IE5smwq2sUjNrJCAmhH5j/djX/1FVqTwmqYJCfiK3yR60007BK+ZIFa+Ha0cWnYmypC0bObvA==
X-Received: by 2002:a17:903:1c3:b0:20c:a0a5:a181 with SMTP id d9443c01a7336-2111af3cae0mr42155915ad.19.1730469522526;
        Fri, 01 Nov 2024 06:58:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211057d457csm21625825ad.267.2024.11.01.06.58.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 06:58:41 -0700 (PDT)
Message-ID: <3ab28e41-1183-456c-a66d-1141d414d8db@kernel.dk>
Date: Fri, 1 Nov 2024 07:58:41 -0600
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
 <ZyQ5CcwfLhaASvMz@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZyQ5CcwfLhaASvMz@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/31/24 8:12 PM, Ming Lei wrote:
> On Thu, Oct 31, 2024 at 03:22:18PM -0600, Jens Axboe wrote:
>> In hindsight everything is clearer, but it probably should've been known
>> that 8 bits of ->flags would run out sooner than later. Rather than
>> gobble up the last bit for a random use case, add a bit that controls
>> whether or not ->personality is used as a flags2 argument. If that is
>> the case, then there's a new IOSQE2_PERSONALITY flag that tells io_uring
>> which personality field to read.
>>
>> While this isn't the prettiest, it does allow extending with 15 extra
>> flags, and retains being able to use personality with any kind of
>> command. The exception is uring cmd, where personality2 will overlap
>> with the space set aside for SQE128. If they really need that, then that
> 
> The space is the 1st `short` for uring_cmd, instead of SQE128 only.
> 
> Also it is overlapped with ->optval and ->addr3, so just wondering why not
> use ->__pad2?
> 
> Another ways is to use __pad2 for sqe2_flags for non-uring_cmd, and for
> uring_cmd, use its top 16 as sqe2_flags, this way does work, but it is
> just a bit ugly to use.

Agree, __pad2 is the better place, we don't want it overlapping with
add3/optval.

-- 
Jens Axboe


