Return-Path: <io-uring+bounces-7155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7185CA6B824
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 10:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D050B18894F4
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 09:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 233D01F0E49;
	Fri, 21 Mar 2025 09:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ix2nqMN1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9811EFFAF;
	Fri, 21 Mar 2025 09:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742550927; cv=none; b=TbeR5k21KdwZwpKlliY+Yk/o1D1NgHsbCXqVkwhCI4Hr6L3TeJn56wLxuzAk7qJA1hg9LlaRfNJNSvLinr+MIMsZmGUWIw8iTd0HfdZ+wgJ/7Q2k+Ss3MdaQuRnDaXfmCgXp3mRmp3WZv0liu/9zIbJlvv4WVgHvAkMK6533kCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742550927; c=relaxed/simple;
	bh=emY32bq6POxE5dVGpv7GJv8QtE46PSUJBwrKrveZhnU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gDx0mM0NY7PnHWlhIrcXg7t+Iv1nlfERlgV7gclvLaBDMN60Fnyl5t2t5cJvuKVgTO5hNq4OwEo1C1vY3JsvT9vmmTV4K3bQMjAcMDy11LSN+DXhdrJxkf0exn562vEpncqHCNDZfDjtTcJv0JgPBgoZn71XttkBdjmLi7dffWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ix2nqMN1; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-ab771575040so565474466b.1;
        Fri, 21 Mar 2025 02:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742550923; x=1743155723; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hGxPTZgzQQh40KKZP2p1g5UxF7T4fChcDIcF48afktA=;
        b=Ix2nqMN1sQ6zAy6kubKaCOvrLPv+CFyouiFaQKi2ONHfJzk35acFdVhIiJeWkKB508
         ZPcdWPljrREuWuIktCC4gDY5NqLl3/opHqlQslp/84G4XCtnf9SpoOb0sSW+98SJ+ejU
         a9fn6PDZlgrBxPOMIm6rELdGKA/5xleFhdxSWKeAVHUzlQxKZMjtGJp0AeWjejp6B2nR
         4UhvvpHtyNsrv42Hw7m5Rlb8EuAjpVY82+byEJyj2EW/iDDDnNmdBAw59phFv4LcUvlo
         mkBMZa+SLGESuRKVRyaJYIIMr2jhgvHCTHHamf9LTd5vVLBSSu7RpNEV0hRjCjZm+4fl
         1UXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742550923; x=1743155723;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hGxPTZgzQQh40KKZP2p1g5UxF7T4fChcDIcF48afktA=;
        b=WLp9h/z/JvebEd8URlQgjo/5x+HRxX1+pQig5a+Jg/4W/oYgfYhA1ievOHMpDS5tQQ
         zTN30O79yfiFSmJyNiTt6QD+BN42oX6aL8vqHM91nX/pT+35MnBrM+VB1VZPbg7yPAe0
         OeRCkX0aVxAZOuoaZ97peVbcVpQ0J2XCVTIqmULrsFqcMV1Toj6eiLVVfG7FCJetIdbV
         dVShVjQeSeGa9FiVsyUdRCiyd5SLO/2AYlszT6qE+hLTkeh0DxNwAXz+emPpppkbULUg
         06LMR3I+grZXvQ45UNwl0mowq/44u+yo9ZSbRbzefbYAsVSX2WHatYrEBwmbKZoSU2hx
         VYsg==
X-Forwarded-Encrypted: i=1; AJvYcCU0h9S3vbRQfLstHd+HKtKGhP7YR834nHmYfekmWxo5ZeVHKeqGczudZ6XqSWelXEKULyTHXYq07w==@vger.kernel.org, AJvYcCW1iIqveVwEhUBsMWpVG6p8HSaJgN/jPKlg3I09QlFyRdZQdgQ0xKZQmTFzQ6mYUKCjp1UOV8TiYrSwPf8=@vger.kernel.org, AJvYcCXnk4+LQm1tINo8YHDh0pph36A7rtYJVVD8NOVsfQ6mCjkolW66vRzV8eGmYxNk9mTymew5Er3AivfOnW+w@vger.kernel.org
X-Gm-Message-State: AOJu0Yyb26rXUbmRBeo+EwanxlN1BI7AjcuqkyJz8bDf0zjD8LdlOCOM
	EvXxjkfEnt+JtPeui9+7whQ1a0QGt01u//jb63hngUO3sfff0u02
X-Gm-Gg: ASbGncvZt9uMS/7Vg0kgA3vGQ4xNI8oGKs8Wq5iS0tvUVFl3rv4qjkMjLD8cX8GHn44
	9jj2YLhNo5YBjyX5OQh0h6veX1kPX7mBua9DDaoquMbULUkK+b5Tnf+QX/GkvMAgyeWzcUPaWWk
	k7FxLgs/oPzTiRJqddc+0a/kM/8z2J6Il1rR9o9gAgfW+aR/Rc5M1euJl2Ji/N2CPvifchP0xDx
	86TEbiRsEOd4aO9zzFN8XwuaKLRUTRKUikgWqv6H9IZMi2ALK/SqA6TWIVpuWEmpMyBqN82uaql
	DrXMDCnjBQeWxybLFsFsAdjCV5Mdv2BJ2i5Y2/u1HJf1X/Px9LR5Bg==
X-Google-Smtp-Source: AGHT+IGl/EazGASwBGic4cjYROwCQT0URMReSd1nVM1pAcMs8PHtW3kuyvTfa05qhoO4q1P1cMRu7A==
X-Received: by 2002:a17:907:1b1e:b0:ac3:ed82:77c2 with SMTP id a640c23a62f3a-ac3ed8279a1mr301741066b.5.1742550923100;
        Fri, 21 Mar 2025 02:55:23 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.236.254])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac3efd569f3sm121390566b.171.2025.03.21.02.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 02:55:22 -0700 (PDT)
Message-ID: <24ab1cff-2020-4e65-b554-78cb7e8a3c34@gmail.com>
Date: Fri, 21 Mar 2025 09:56:16 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Jens Axboe <axboe@kernel.dk>, dsterba@suse.cz,
 Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
 linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
 <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
 <20250319170710.GK32661@suse.cz>
 <4ba22ceb-d910-4d2c-addb-dc8bcb6dfd91@kernel.dk>
 <Z9tzvz_4IDzMUOFb@sidongui-MacBookPro.local>
 <27ae3273-f861-4581-afb9-96064be449a4@gmail.com>
 <Z9w92CmC51cLN3PD@sidongui-MacBookPro.local>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9w92CmC51cLN3PD@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 16:10, Sidong Yang wrote:
> On Thu, Mar 20, 2025 at 12:04:33PM +0000, Pavel Begunkov wrote:
>> On 3/20/25 01:47, Sidong Yang wrote:
>>> On Wed, Mar 19, 2025 at 11:10:07AM -0600, Jens Axboe wrote:
>>>> On 3/19/25 11:07 AM, David Sterba wrote:
>>>>> On Wed, Mar 19, 2025 at 09:27:37AM -0600, Jens Axboe wrote:
>>>>>> On 3/19/25 9:26 AM, Jens Axboe wrote:
>>>>>>>
>>>>>>> On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
>>>>>>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>>>>>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>>>>>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>>>>>>> for new api for encoded read/write in btrfs by using uring cmd.
>>>>>>>>
>>>>>>>> There was approximately 10 percent of performance improvements through benchmark.
>>>>>>>> The benchmark code is in
>>>>>>>> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
>>>>>>>>
>>>>>>>> [...]
>>>>>>>
>>>>>>> Applied, thanks!
>>>>>>>
>>>>>>> [1/5] io_uring: rename the data cmd cache
>>>>>>>         commit: 575e7b0629d4bd485517c40ff20676180476f5f9
>>>>>>> [2/5] io_uring/cmd: don't expose entire cmd async data
>>>>>>>         commit: 5f14404bfa245a156915ee44c827edc56655b067
>>>>>>> [3/5] io_uring/cmd: add iovec cache for commands
>>>>>>>         commit: fe549edab6c3b7995b58450e31232566b383a249
>>>>>>> [4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
>>>>>>>         commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d
>>>>>>
>>>>>> 1-4 look pretty straight forward to me - I'll be happy to queue the
>>>>>> btrfs one as well if the btrfs people are happy with it, just didn't
>>>>>> want to assume anything here.
>>>>>
>>>>> For 6.15 is too late so it makes more sense to take it through the btrfs
>>>>> patches targetting 6.16.
>>>>
>>>> No problem - Sidong, guessing you probably want to resend patch 5/5 once
>>>> btrfs has a next branch based on 6.15-rc1 or later.
>>>
>>> Thanks, I'll resend only patch 5/5 then.
>>
>> And please do send the fix, that should always be done first,
>> especially if it conflicts with the current patch as they usually
>> go to different trees and the fix might need to be backported.
> 
> Sorry to forget to cc you Pavel.
> https://lore.kernel.org/linux-btrfs/20250319180416.GL32661@twin.jikos.cz/T/#t

Ah, you already did, great!

-- 
Pavel Begunkov


