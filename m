Return-Path: <io-uring+bounces-9823-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 275C9B5A095
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 20:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3EC23BE1E4
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 18:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAA129BDA3;
	Tue, 16 Sep 2025 18:35:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VSypxN4n"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D8C2C0F84
	for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 18:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758047724; cv=none; b=L5O1Ai1mwfJ46OCMLbHwN1D2KDBlHLFEBmkCCgPO5bmMV10SdkRs1mee27bPbFLuuVg28lAN9TSk94rx6/UdEU+tIhEA0fsTmFps7jmZDLRT7wsOATheEg8snMevgWA4w2IeRGE4kZsf7To/lxwRGmweiKoKs/vfcyxrugjf9I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758047724; c=relaxed/simple;
	bh=7WqzqY2cj8QidvvhEmbK3Khm3ep29EPU6br1eXXiBDU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=oa4TQ3l2JcJ6blqv3LzLotPm1txv6C/TTyWgg8dl703cg2nMQzdT+Xpn/QXIoDBVgavMOXl5iZhkGeU4NlGxwluXFuJrtPQPM3oTfZ1+00HHb0VllFp3pPE56pIhdvYCdYRIy5YoqADmgm0MXLGa8ojtKRfRgJ2ytEwxqQpuwHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VSypxN4n; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-4240784860bso10685925ab.1
        for <io-uring@vger.kernel.org>; Tue, 16 Sep 2025 11:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1758047721; x=1758652521; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zix/Z9Mx8ORyPy7Xiaoa3W/ZLgTzfJHOxwbGNUvSvHo=;
        b=VSypxN4nD8WbHt+0QrILlHMiaBK9nGiRjDL9mrSfhbhG76/wIx3UfPl73KqKwdv/x5
         lLT4pgohFrloCE5GlANSJPD/kOrM+oNF2gbMFvOhS/ZLIqpfNke+MuVWX99unewkPTqF
         y6z084xh3Bqe9plR7aQxPY0cMKX9lMmBujOT6z6o7L95U52Xrp+49CXFmvjgTvj3frC9
         X9CduO75k3onUcyq+D52pO4/IlQ15tIPI0bHvkqUyabKAUeiYwVy+pk5X/6vYvpTjC+D
         U0VnVvIKvm02CEq+3efeLSxc4/FAmLJ63IZ+MMk/0aFOmCdhs4J4PXEQs6Y2UHAfTTtt
         dWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758047721; x=1758652521;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zix/Z9Mx8ORyPy7Xiaoa3W/ZLgTzfJHOxwbGNUvSvHo=;
        b=OsN+YHkVH04Zg380cvOeHBtkBBg4+F35QZZj9s9u+95CH3y4rCS+gs+zOKiCpxx2Us
         wFwwCMMkM5Xhb+IN4K0DwkIljMl1quCSxY9MRTUr1+M90CSEwbg/ll37pEqa6EdRu5ie
         dRWd1ADfvdFJZNMbswShgKLnof9oib2pEgEj7rPhX5csqVWs/aDuhOeIbTdBtDUlQ3YX
         KMTi895fpmTh73H9ly6qmU1SRE+RIKxZQ6XlUnQbxh9ChCOrXNgBH1qvHv8gxRD8843N
         IWmiuofgnPVu8xFXy8AqFlE+1Q9wyW4o5weaECuzPX9yhSEonoPhlJc9omVox4xtUE4z
         nY+A==
X-Forwarded-Encrypted: i=1; AJvYcCUkbUEVxXP4GqkL81yLK8oqlLGphbM5/jI8wD89Xeju/yIToVHI06qa3MzkQXEnl/Fdvy1PY9/PDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxISMkEx7qBSgYpra5X/gedPUnHDaqsVM/Sr0mE+CAsAZP8Y7W7
	1+2xuvmW0irYSstpAT+REyutweBI4tAvCm5VwVzTRxU22cAsOUmYAIBnfub/bLSbHUU0auwYZKH
	iE26L
X-Gm-Gg: ASbGncsL20LwlGPDu/5u9U87KoafFYBWcrEPI/vCkWA57QHZKiNqrFbek/Irn64S8kf
	/NmpPkMC6E9Y94heC4z+RCIR+ciVmfUnUAsVNnIGcfcr0+Zyf+Qt/nrrEtZAY0zKeCOvYBfEb2Z
	wJmPq5jeYxHUT9fh8FPiXf3jgdLSNLIwLdeduVtGPW9wFrAj96px3A7h2+bctNRVsTGf4yI5F6M
	I9Z4WPcleO3UkDjGAopzIj74wXJ5UrN6aH04HL9UWxBg6ebEfeDSHVGp+TtMA5YhMjuP+wZoL31
	5aUOWbDKtsQNgOsRKKXL/PokZeJ5muILCtUtyKqgL2gho1h1czs8cXWsPt+mwCa/ImVUmBSZxWu
	hFBLgQTmh2LOMI0LIihI=
X-Google-Smtp-Source: AGHT+IHhlL1yuBpFl9RgZCl957C/tUlHK9ZDo44RpqE6U09ODjY1aOJpDH286Tlg8ClTLkvhZ1/rsw==
X-Received: by 2002:a05:6e02:1feb:b0:416:d40f:d3e3 with SMTP id e9e14a558f8ab-420a30271cdmr169249235ab.15.1758047721286;
        Tue, 16 Sep 2025 11:35:21 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-51202c9cae3sm4861762173.16.2025.09.16.11.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Sep 2025 11:35:20 -0700 (PDT)
Message-ID: <2ff474cc-f388-4ec3-a17d-23bf720b46bb@kernel.dk>
Date: Tue, 16 Sep 2025 12:35:20 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next] io_uring/query: check for loops in in_query()
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <2a4811de-1e35-428d-8784-a162c0e4ea8f@kernel.dk>
 <a686490e-03f0-4f21-a8d6-47451562682a@gmail.com>
 <6e347e14-9549-4025-bc99-d184f8244446@gmail.com>
 <3acf3cdc-8ace-42e6-a8a8-974442d98092@kernel.dk>
 <437ebe86-3183-470a-b5d3-1d5ff8557e01@gmail.com>
 <da6a8cb0-d726-48ea-8f10-2e5852e5acd3@kernel.dk>
Content-Language: en-US
In-Reply-To: <da6a8cb0-d726-48ea-8f10-2e5852e5acd3@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/25 12:33 PM, Jens Axboe wrote:
> On 9/16/25 9:05 AM, Pavel Begunkov wrote:
>> I'd rather delay non fatal signals and even more so task work
>> processing, it can't ever be reliable in general case otherwise
>> and would always need to be executed in a loop. And the execution
>> should be brief, likely shorter than non-interruptible sections
>> of many syscalls. In this sense capping at 1000 can be a better
>> choice.
> 
> Let's just cap it at 1000, at least that's a more reasonable number. I
> don't think there's a perfect way to solve this problem, outside of
> being able to detect loops, but at least 1000 can be documented as the
> max limit. Not that anyone would ever get anywhere near that...

Forgot to mention, but I'm assuming you'll send a v2 of the patch?

-- 
Jens Axboe


