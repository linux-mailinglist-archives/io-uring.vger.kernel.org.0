Return-Path: <io-uring+bounces-2183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15231905469
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 15:57:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 885571F2649F
	for <lists+io-uring@lfdr.de>; Wed, 12 Jun 2024 13:57:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F0317DE2A;
	Wed, 12 Jun 2024 13:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TtmDfUOe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D71517DE2B;
	Wed, 12 Jun 2024 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718200450; cv=none; b=ZHaU/mzgKm+HoAAj04ZJc5BZ3O3kJRIz7amCx2KRGpZ7IXleXqvhykiWnHxlkohUIggoo8PgShg0c52ptbjQMyj3oz/Oi62kqhdHblPlm3Q1T2NMq1DlRVYRAoKq1yG82YoywnCIKj3HMouLRlP+Yh+ETIE9B9ATzpq6OARR21E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718200450; c=relaxed/simple;
	bh=0n4qv6NG9+E+G1mmCBlGWR8bcBrn9FxGi4U/ghc+jMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pOLvDTZL48/PzRIq7rJr+v19LvOzPENOuPPi8J1LQHFKRSDKBh9qCK/egcPFJajyfHuD1O2r7K6Q7lY0N2GmGCNp9Lj6vbyEqTU/dVDHzqIPETJAb6QXl5cQiIA8p+0e5cKc9eV/0lhgjx4zCr/iTwuot8F0k4uEJVAMh8ee3sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TtmDfUOe; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a6ef8e62935so308243466b.3;
        Wed, 12 Jun 2024 06:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718200447; x=1718805247; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p2ZwRFtLK8ixvJ/wY/t4DAaHcZNjb8eBDynqr74sQJU=;
        b=TtmDfUOeNYA+QxuJxG38H9Lw9vYLFzOrGg5Dr3Eu5bzWXz1kbgiV/MELcTwAbNILMi
         69O5gZ3p0VWIT5mbvD5gOWEMYlUrk5jhFishY43HaUmW/vkZVCR7xfdvSCziamWzeX1V
         mIBGeSfczjr+19tXCSE7seHp/KMWRYatvZx683GJMrwi0BBCa9q2DCQTMUVHfRAhNwpO
         J5wO+Y4uVSElzv+tbfq7MZZ9kOIAiIVy9Gd4Tah9SeDzsGFRf84ydwEvbD/x8OjjzbUJ
         QzP1MSmNVazPIfPtMiA++Cm9aKeteIWyxL7mXDZTA4oOoaayPNGF7Z6wKiFelATe8ls6
         ey3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718200447; x=1718805247;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p2ZwRFtLK8ixvJ/wY/t4DAaHcZNjb8eBDynqr74sQJU=;
        b=BowsJCdHvkorHBysljTZ87wGBATJvWbzNHk28ogs6FkNQchm3zDKFpYx8Y1JMHxwDo
         IJI3Gs84h33T9nchT5iDEQ57ytYWFiRia38WxR2vZgvOHnKJ3NLiEDPnqsvMYq92MfWD
         l8cw2yc4hr/gsiPD5PLR5BVXUe9vJJjXP1wK+KSmD+TsjQdQIVvnCu9SFfH8fLbZ1yD4
         5Lbjc5WiZJdj9l+u5QPT9PzridqAPnMi8bvfeV2Z3MvHaFDfZjhvyuG4s0/O2xQ7Wtap
         j+VQ40LKXVAx6ECPwZFjzNNiV5vRLlekGZ+YE5SbHBngiz7kpv5n9UwoPuU2fAGpLH8p
         mIRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXFeV+1xgaAWGE86kV0hnpBA4bCDit0v+HtH/4WQNK582tdEm7ptc0juCCIkIQ59grCt4xWi8HS82QQVQnyORzIgP/823qeAvQrqC/IjBStRVt2ANTGP8/CkcPMjPV1MBba0qLCAWo=
X-Gm-Message-State: AOJu0Yw+61IQG5g9JrLAd4MBZmz09ckvd/N/ZkaEBqYWo2T0J1kVOcjR
	LbFymw0UTnyJOITlp5vf0aIJgAKH938MenWX1rg3tCbyfvIbBCOp
X-Google-Smtp-Source: AGHT+IHuGl6WjNGlT3H5D496VhLA2zp1fgWFBDM8Sb/mr6A/NPted1/MiCnc/mu8MZz+vA8a6N/OqA==
X-Received: by 2002:a17:906:475a:b0:a6f:4b2a:2877 with SMTP id a640c23a62f3a-a6f4b2a28b4mr108581866b.22.1718200447078;
        Wed, 12 Jun 2024 06:54:07 -0700 (PDT)
Received: from [192.168.42.148] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a6f1c2b1e80sm438247266b.145.2024.06.12.06.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jun 2024 06:54:06 -0700 (PDT)
Message-ID: <07dcda2d-1b78-4ac0-8ce1-5956c67b3778@gmail.com>
Date: Wed, 12 Jun 2024 14:54:14 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [io-uring] WARNING in __put_task_struct
To: chase xd <sl1589472800@gmail.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CADZouDTYSbyxzo3cXq08Kk4i0-rLOwuCMRTFTett_vTTmLauQA@mail.gmail.com>
 <9baaad14-0639-4780-809a-0548e842556f@gmail.com>
 <CADZouDRyyPKQyckxQ0SpEO=AJiZuh=r4PfMN6EU4nUJJTaOFbw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CADZouDRyyPKQyckxQ0SpEO=AJiZuh=r4PfMN6EU4nUJJTaOFbw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/24 07:59, chase xd wrote:
> Repro hit the bug with a low probability, so maybe you need to try
> more times on the branch I reported. Also, this bug still exists in
> branch 6.10.0-rc1-00004-gff802a9f35cf-dirty #7.

Yeah, unreliable, just hit something with some version,
will try to repro with 6.10 and see what's going on


> Pavel Begunkov <asml.silence@gmail.com> 于2024年6月12日周三 03:17写道：
>>
>> On 6/7/24 18:15, chase xd wrote:
>>> Dear Linux kernel maintainers,
>>>
>>> Syzkaller reports this previously unknown bug on Linux
>>> 6.8.0-rc3-00043-ga69d20885494-dirty #4. Seems like the bug was
>>> silently or unintendedly fixed in the latest version.
>>
>> I can't reproduce it neither with upstream nor a69d20885494,
>> it's likely some funkiness of that branch, and sounds like
>> you already tested newer kernels with no success. You can
>> also try it with a stable kernel to see if you can hit it.

-- 
Pavel Begunkov

