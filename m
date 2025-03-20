Return-Path: <io-uring+bounces-7146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6905A6A5DB
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 13:09:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E2E66189E2BD
	for <lists+io-uring@lfdr.de>; Thu, 20 Mar 2025 12:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98428224248;
	Thu, 20 Mar 2025 12:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nL0fH3Kt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E42206B8;
	Thu, 20 Mar 2025 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742472221; cv=none; b=hxHEt8o0+N8SAxXxs8NU1FcEKgH/4m2kf87giElzWJITeix4nkWC2mpuTQoRwKqGcA4mgQlG2vTG/PdD24MymuCtYWsBaRNc+tsyq1RykzB4a3g0hOd5+bHeiMWhlReLEN86KN63FVmTg4LWxZ+twY1PgfRYQj0NjXtXSpnSqNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742472221; c=relaxed/simple;
	bh=21vwweFK2F6TfCSCu35zl7LS6xGibp24XH2IwzpROc4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNDZAfmh7fp1V0ThLV9VQ8DiUlaqSv4x2+L1ZjFPViVv08YUI0OwMDIpgSv6bV0iNbyBsBFSWAjCYigLXU0aIOQhX0fW24Z/EEqKEtebThZM0HcqGVfKiXOibe+GF5aH7fNJ5zJC9iafmS51pj4qnMcep5XDG0d1G8Y+TveHUDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nL0fH3Kt; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5e6f4b3ebe5so1274794a12.0;
        Thu, 20 Mar 2025 05:03:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742472218; x=1743077018; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/4HC6wo6cnKpwf6RkJrvN6AC0UGaCa4F1leVOf8hXaw=;
        b=nL0fH3KtCsxX1Ao9DuR1kv6PGkWalw8ry++wa5Eb2q6+up9GZnEidqvPiYhs7zWijh
         PW6CrxfH+LkiclV5r/RTEanIbMRFRLjjbi1Xdy7jLavSPMQENsb4csR5hIqyPcYln8hq
         Q+yp6K3+vkazWBUoJQxItDWzWaDGBt8v8hQstVMKy9kOmbGBQMARAuvHBQncnDNbkhFr
         BBolNsGGy5UAiDt7hgNbEZs2xEeuQiufJkbA1rc5SD9miTXNBMcmScFagvbLiKvC0Jvq
         vq/2B6YZjhoN1Gp8YrX12qFvdtXsUXuRuOGLA9PG1whOvBOm/97I1k3SBrYTquPxveHY
         tF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742472218; x=1743077018;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/4HC6wo6cnKpwf6RkJrvN6AC0UGaCa4F1leVOf8hXaw=;
        b=IYLkx+O2UkPAn47F2O8AdKiU28bn5k6CdConu/qIGtcezJ3Ty0o0xnwnldH1kcjhyc
         zUobmfA0If7ncA89kAvliEbxSg5Cf+nzUsfmXQkq8ynbBon3JkMIh0goGedY3iTqPrHg
         +BvfZizBcL7fBjV7jftN7ecFXf0UqY5zAHfA5cC6NQFxc99HNFd/A3cyDWj2pKTpr4BI
         pGDp+TImvQooXRQn+4eRly54jGfbt4Bv+UL9xfOf4NLBwIcRz7rB9uzEfL3KKbMXy/Kh
         QEPx1dBuhh24renRAk1TQoTLdgZlBt5StZCuy9RKjh7MpePDMNL9dU8d2xWNKtuVp58K
         tjtQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1n328Uxx3/YHU8730NGNHKaUMeEr0ZcGCa4aqLETtk8DRuZ7Rw1pq2zPvrPQl4i0iO+dqwwaUUQ==@vger.kernel.org, AJvYcCX1koZjY+ERTrezwMFfNdO+bLliwHzMqmWZ0TLJhhUkc2XNX79tHwhTP3kWVpwdUB/HfOj1VW67YyqdxT8=@vger.kernel.org, AJvYcCXkYiOpeuFM7+dEJ37G4LckH/2uIVN9KrQ2PEA1dNXTCILlMU1n/yCbHQpXs3fQNPfFJU9c3FKDs1AMIWL+@vger.kernel.org
X-Gm-Message-State: AOJu0YwuI2/+nhYEj+CduSyIrAq/D+ewQyR2Ox5U7ql8e8zQkdsvGYp/
	E3QcwPZwQ4BbQiFQkdGKEv/tDUcD2LqZ5cciVp0a8LKAogr+aNjh
X-Gm-Gg: ASbGncujq4uQ8vGhfQyMr9gGD70XGV4WfCrM+BmIVc9/s+K7ecyiDvBZsnoL5xShoI2
	VbN7QsbvyJedP0a7q9ovhJrvK35CeMrLG7owIrWboYGEk4B/TCFlj8ZpMJsHiN4TmHu9YEksnLU
	oRSXAWZDHMGlbvi6JpHHj1Zj45qvg+ghCjLAg8DoXfTRpgrtUFZzU1xu8ZBnyHqqNGkUPYNOrGL
	IAMicYz7qu3IYZnVQJ5YEgOCSjnhjgdiiiweBRVdW4R9kTI46DlcrHgvms2udAmNpwzc0tEIOph
	K0z1SRKQonS83X8fW9kHcCdeB165hhul5NMoJmsbe+/nizXT9IEum49ddDTxt0+wn6/5UrlehJA
	CQN+FRJKFeyyR
X-Google-Smtp-Source: AGHT+IFRhFpukk54KqJz8QtnZPdPwrY7CEKukPrAMpsTs5CSWpsMsefxxFsE29fpi/KgKVDQ1FDJew==
X-Received: by 2002:a05:6402:5204:b0:5e5:e090:7b62 with SMTP id 4fb4d7f45d1cf-5eb80fa43afmr6933161a12.24.1742472217508;
        Thu, 20 Mar 2025 05:03:37 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5148])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e816afe22esm10265582a12.79.2025.03.20.05.03.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 05:03:36 -0700 (PDT)
Message-ID: <27ae3273-f861-4581-afb9-96064be449a4@gmail.com>
Date: Thu, 20 Mar 2025 12:04:33 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [RFC PATCH v5 0/5] introduce
 io_uring_cmd_import_fixed_vec
To: Sidong Yang <sidong.yang@furiosa.ai>, Jens Axboe <axboe@kernel.dk>
Cc: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
 David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20250319061251.21452-1-sidong.yang@furiosa.ai>
 <174239798984.85082.13872425373891225169.b4-ty@kernel.dk>
 <f78c156e-8712-4239-b17f-d917be03226a@kernel.dk>
 <20250319170710.GK32661@suse.cz>
 <4ba22ceb-d910-4d2c-addb-dc8bcb6dfd91@kernel.dk>
 <Z9tzvz_4IDzMUOFb@sidongui-MacBookPro.local>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z9tzvz_4IDzMUOFb@sidongui-MacBookPro.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/25 01:47, Sidong Yang wrote:
> On Wed, Mar 19, 2025 at 11:10:07AM -0600, Jens Axboe wrote:
>> On 3/19/25 11:07 AM, David Sterba wrote:
>>> On Wed, Mar 19, 2025 at 09:27:37AM -0600, Jens Axboe wrote:
>>>> On 3/19/25 9:26 AM, Jens Axboe wrote:
>>>>>
>>>>> On Wed, 19 Mar 2025 06:12:46 +0000, Sidong Yang wrote:
>>>>>> This patche series introduce io_uring_cmd_import_vec. With this function,
>>>>>> Multiple fixed buffer could be used in uring cmd. It's vectored version
>>>>>> for io_uring_cmd_import_fixed(). Also this patch series includes a usage
>>>>>> for new api for encoded read/write in btrfs by using uring cmd.
>>>>>>
>>>>>> There was approximately 10 percent of performance improvements through benchmark.
>>>>>> The benchmark code is in
>>>>>> https://github.com/SidongYang/btrfs-encoded-io-test/blob/main/main.c
>>>>>>
>>>>>> [...]
>>>>>
>>>>> Applied, thanks!
>>>>>
>>>>> [1/5] io_uring: rename the data cmd cache
>>>>>        commit: 575e7b0629d4bd485517c40ff20676180476f5f9
>>>>> [2/5] io_uring/cmd: don't expose entire cmd async data
>>>>>        commit: 5f14404bfa245a156915ee44c827edc56655b067
>>>>> [3/5] io_uring/cmd: add iovec cache for commands
>>>>>        commit: fe549edab6c3b7995b58450e31232566b383a249
>>>>> [4/5] io_uring/cmd: introduce io_uring_cmd_import_fixed_vec
>>>>>        commit: b24cb04c1e072ecd859a98b2e4258ca8fe8d2d4d
>>>>
>>>> 1-4 look pretty straight forward to me - I'll be happy to queue the
>>>> btrfs one as well if the btrfs people are happy with it, just didn't
>>>> want to assume anything here.
>>>
>>> For 6.15 is too late so it makes more sense to take it through the btrfs
>>> patches targetting 6.16.
>>
>> No problem - Sidong, guessing you probably want to resend patch 5/5 once
>> btrfs has a next branch based on 6.15-rc1 or later.
> 
> Thanks, I'll resend only patch 5/5 then.

And please do send the fix, that should always be done first,
especially if it conflicts with the current patch as they usually
go to different trees and the fix might need to be backported.

-- 
Pavel Begunkov


