Return-Path: <io-uring+bounces-6252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41E44A27BCB
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:46:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1E1ED1883818
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7497B2054EF;
	Tue,  4 Feb 2025 19:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Rsv/Sp/z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C96FF158558
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698335; cv=none; b=ilnz/Fe4C7IQLl2vwJvpQih9GBLpmw0CgqnQ4oy4hANzW3yZaW4WMYtRa8fy39OmNuXrNLrEROO0mJPWbE5DjhhT7lowsX+WN8QEWcXPCwJ5tv9wEvFYcKuPU5CfVggLVVkpJyBPcdnUri79plk0mmTK5ACOeUktOvZxmiobDPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698335; c=relaxed/simple;
	bh=AWm6SRoVJLrztDNtraR6Ywyc1Zgy0EqSsNUFbVwwIds=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Hq3cxEhWR1v//9A1fjEjQGnajjOYHm1GTw3yQsJi8s4FXBXhv1EadqTyu6G1T51H2xYZN72zJzs8wQgKU0GhC3GNQv/CxqR8C0kjDyCwaXkRmekkcFfGbvBCs+I6GFKgPbvn8YgDgyqw5picX66FMwYuZaUjjni1NuDUey0rZco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Rsv/Sp/z; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so5359839f.0
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698331; x=1739303131; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kCaLJAqQDbtyXBCxltyHzUvfbctOseKjqFt2LzfHmYo=;
        b=Rsv/Sp/zyNcBldxh2z7QmSotGAaqkGe+7vgO5g9/Vix2qEGMnO533jj0biboo+/uRd
         5y/+E3414Sv0Gc/rsuH06WKLIW6CFvufEmeoIok5lLLBagcMOp3NxIs9qXSbEBhUuYaQ
         2g42LUzeRdGe08omi8yucBcEWcwuCU+zFtEYHL8dQQhjBpGf+06Gte1fbccLVBZZf1JZ
         GUuOWTgwav2z9BT2iZSi8wxTPej7J1+VY2Y7MzlZPNXevnltIw9UrRikO8RLmUhdsdy8
         9s3LQjYTua4jpU+WnaU4gZccosp20jlmxZDMtXv5a0IlTgPfhlmtYtc8Pd3ptHBZwo1x
         e3kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698331; x=1739303131;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kCaLJAqQDbtyXBCxltyHzUvfbctOseKjqFt2LzfHmYo=;
        b=Im818v1Fw2Djxe2uIwf+IoLtLR+rS+3zaQRxZqCfkGmy+aM94geRwIpdUbuMxMIcJJ
         CdWsvD2xeuErjjxzAIXLa0IRd+Rsj7BFg9+gs0LxPm8lVb6hXDlthx3SFJhEmoD6S9qI
         aCSWRc6Sz34TMpBntMTLr7N2onWCOYcSDGY//6xtF4MB1Hb06WlivxZvLXT1RqlNL39q
         P+tLKBaOalAHQfiILmkKpZvxvY1O2GQ112aujXNQh4kw1azBv5cAsowVbGdPm7viOQEz
         wp1LOuP0kF0ey6lUcdyvuVdV3sEdwxpI0aWEzzyl4JnqX7A9aP3g1RTlO8ga/jHuyFsf
         l2vQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiMFtxwYnLmpjCnOZUtPtO+Rk5lkYqYGm00wZWOZdI2WEATw9bH+3JcqnkTcKWRwmJq6hLhI300A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ9UmrRykrLCIXZjPX2qJuNVhqL0s2WLnxm8H3ZW5hMI2iHmYc
	EFvv69LWCQ6dEKgW4pu2hCLM87kRvufKxK33F79eJFTYvTcyYgs183odqmooHpY=
X-Gm-Gg: ASbGncvH59MSR3dsHzGYXWaos61QG+KH5K9qRpRqKoYrBOnR6PUWcOru16kVyBWSpJh
	29yvPpFv3HflOwW1c6eLYjDmMKMRI5TBKGf9lyzHKO0C7PR4Pka2Q2zE4IHyRwrLSVfccH6oAI4
	iZSgkGxYTcfkBmLS2hUwfBO9Q2+CEZZ8pA3bTODsutKTIKXH3eAAf44yQXnwF+FJ9iTVLTUvhj8
	7Uwv28cAvSKTE7A+z9jFwec9tT6JsCgVRljSbdP/WXz0ivkRD6BdEP/33ArXltsm151qmcUj+iq
	RMtEQBz4jYY=
X-Google-Smtp-Source: AGHT+IGKMGtyC0z1dZUkfQ6BO3AVDd1waxB6CoIvaCTe3UQZScJQnLt8679sVZwJEgQU+3Y/5hNPtA==
X-Received: by 2002:a5e:9747:0:b0:84a:7a0d:cc67 with SMTP id ca18e2360f4ac-854de0af199mr363785239f.8.1738698330691;
        Tue, 04 Feb 2025 11:45:30 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c0db2sm2821658173.115.2025.02.04.11.45.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 11:45:29 -0800 (PST)
Message-ID: <7d927254-6e75-43c3-be17-6e449395ff0d@kernel.dk>
Date: Tue, 4 Feb 2025 12:45:29 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] io_uring: cache io_kiocb->flags in variable
To: Pavel Begunkov <asml.silence@gmail.com>,
 Max Kellermann <max.kellermann@ionos.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250128133927.3989681-1-max.kellermann@ionos.com>
 <20250128133927.3989681-8-max.kellermann@ionos.com>
 <a7733b94-c7c0-4e95-975d-e45562d54f3f@gmail.com>
 <fcf5df70-d709-4bec-b4ce-aa833d1d4da2@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fcf5df70-d709-4bec-b4ce-aa833d1d4da2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/4/25 5:07 AM, Pavel Begunkov wrote:
> On 1/29/25 19:11, Pavel Begunkov wrote:
>> On 1/28/25 13:39, Max Kellermann wrote:
>>> This eliminates several redundant reads, some of which probably cannot
>>> be optimized away by the compiler.
>>
>> Let's not, it hurts readability with no clear benefits. In most cases
>> the compiler will be able to optimise it just where it matters, and
>> in cold paths we're comparing the overhead of reading a cached variable
>> with taking locks and doing indirect calls, and even then it'd likely
>> need to be saved onto the stack and loaded back.
>>
>> The only place where it might be worth it is io_issue_sqe(), and
>> even then I'd doubt it.
> 
> Jens, I'd suggest to drop it out of the tree, for the reasons above.

Yep I'll drop it, thanks.

-- 
Jens Axboe


