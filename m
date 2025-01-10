Return-Path: <io-uring+bounces-5817-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 80E47A09E20
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 23:36:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F31CC3AB6FE
	for <lists+io-uring@lfdr.de>; Fri, 10 Jan 2025 22:35:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 331EE216605;
	Fri, 10 Jan 2025 22:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AB1hi/5e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB921C182
	for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 22:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736548293; cv=none; b=EZUG59s95NCvnM5avJXTHjbXPzFbuit20eInT/97GXUgGf0kEgYhdBVYznNGFSOjvqZmH6iwl+2Or2OrpM60+Rd1OUweTUbuM2wkcw140hTyqs4qeUDdBAj3ULy281QpX37aifFfloKccdrRCMZZ0FHCaIzvax3oFOGb5+78CfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736548293; c=relaxed/simple;
	bh=af+jsATXId/bgZrwQLx0BzFik4PK0/Qcooqz4LkjZJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L9NJKPUUJqFIclAeE2akYukZshFCMEVVi3BLImv7L8IqdUpfBYox286hQ253ivaKegawdGDNM9FHJBTxlOvCNBzgf9XZULEwAc1sLACXDwY5Cmkyq3DQQyOh7eSySL5LpeRGzmfCKGH/LuFjYsuvBvI/l3GzGWcATBFG/oa+pU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AB1hi/5e; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-aaf900cc7fbso475802866b.3
        for <io-uring@vger.kernel.org>; Fri, 10 Jan 2025 14:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736548289; x=1737153089; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ZKUC8w+T45i2dCF01rPDdpKWteQtwcs4SDX7JQJ44E=;
        b=AB1hi/5e0rOIrLe3Ce1sh+TZJrh2gwOtC9XiDlKN3GPS/ia7X5atBSaJyO8W5FnHlc
         NhO1GIjE+xfW4HC+/cHYbPnD6w9vkwCVXtFRqbIGSnNYn+4sfrAR6F4CrjNgtMZcgoH3
         nWEMldgI2J1fhfV9opZiTkttidg8pgdjGOmizDUIukd/ptrblt1DrwwtvGxApvkMyFnP
         m2Tz7ZWg413c55iICUidGK30x9A3ra4i8jfE8OfYMpvtnIWY5vllwh+vscT/mzZ8e3d5
         88T6BAndhjgNQQ3LCl6L/ve10n9AIRk0d5gOh95rVjTmQ2aw1E6bhFNMy1diUvMqGwsW
         f/jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736548289; x=1737153089;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ZKUC8w+T45i2dCF01rPDdpKWteQtwcs4SDX7JQJ44E=;
        b=Hgmr/g9P/8qxi/06YtB/SFmMqzW9aD8fkYz/1RBVnq/0+gZ1X+MkYllX4OXmIkDMg7
         yjeVDMGe78eB4wDYCdLzPYY59QcMVO+stliCXK6e3sXFldXVo/egrJK4dzH1RR50xF9O
         1N20PSbQjaAkArBO/YEQ5qz3zSwBUlO4+EzFfh2p5cDk7gOsDIJu8isrfzeupHCEF/e2
         I4k0PTvkx8NiY+2lMfL/TT1QvtIpJmS3/Q8fLtTy1mfeOYG6JXhIe4AAr3Q6Nz9d6w1m
         0cITl+/aCz/YkIt0Rh3FPRq8zSF45IsBPezAUX6nw1I+aFOmlaDr1ZtDiyXezCg2D7E+
         1aIA==
X-Forwarded-Encrypted: i=1; AJvYcCV9WAoiCr2LZliuWqBckzpIQytCgEGmvbOF7O+jgrOtbEi1UZtfMvICoywtnGFHTwjWc8QYlx0qAw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLelyzudVe5blfjx3QTBqTCYwAnIiDf6oIWg7GjszWYlXnjeJI
	7fKo3PzwhmPrzeZxMPtsv23xYxfp5+/2srGoLuuOAOD6fWth4+ZU
X-Gm-Gg: ASbGncv4oG5xEdEClelPWcQNYTBFAmkDFQEv6CJ5n1Xtym2THJxNsBN73YbMxtAIDh2
	/CfqWFX0EkfnhhoKk17PzyevI90AvRAmrgGT3AKLhc3TJURzNG1jFRAdfb0mobBGk12W9aNCFSH
	5w2M/1C8PE4WYtqAUOnEoB5l07sQbb4X+DETUbkj8O2Y546SVFsQp3cEBEm8z36g8qKPWn5CrTb
	stOpb7R211gvi7F97m9+ki3EXl/c1btazdv5xIsi94EaqlwjbpGgE3kA5EMxaep8ec=
X-Google-Smtp-Source: AGHT+IEaR+odSAgzkU0javs84qjhM+dLENFxWJw5WGltIrmbBX2I6sGGkVGv8eKRgosdy4GwVxsE9Q==
X-Received: by 2002:a17:907:96a0:b0:aa6:87e8:1d08 with SMTP id a640c23a62f3a-ab2ab6bffc3mr907041166b.8.1736548289312;
        Fri, 10 Jan 2025 14:31:29 -0800 (PST)
Received: from [192.168.8.100] ([148.252.141.212])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c90da8b2sm207172166b.44.2025.01.10.14.31.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2025 14:31:28 -0800 (PST)
Message-ID: <cac3b207-c00f-4f27-bf40-3d182b05fcf8@gmail.com>
Date: Fri, 10 Jan 2025 22:32:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: expose read/write attribute capability
To: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@kernel.dk
Cc: Anuj Gupta <anuj20.g@samsung.com>, anuj1072538@gmail.com,
 io-uring@vger.kernel.org, vishak.g@samsung.com
References: <CGME20241205062910epcas5p2aed41bc2f50a58cb1966543dfd31c316@epcas5p2.samsung.com>
 <20241205062109.1788-1-anuj20.g@samsung.com>
 <yq17c7cewsl.fsf@ca-mkp.ca.oracle.com> <yq11pxa5n3i.fsf@ca-mkp.ca.oracle.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <yq11pxa5n3i.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/10/25 22:21, Martin K. Petersen wrote:
> 
>>> After commit 9a213d3b80c0, we can pass additional attributes along
>>> with read/write. However, userspace doesn't know that. Add a new
>>> feature flag IORING_FEAT_RW_ATTR, to notify the userspace that the
>>> kernel has this ability.
>>
>> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>> Tested-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> Jens/Pavel: Ping? Would be good to get this into 6.14.

Thanks for the reminder, it got lost in the list.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>

-- 
Pavel Begunkov


