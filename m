Return-Path: <io-uring+bounces-7520-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48539A91F0B
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 16:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 660244478F5
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 14:01:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C4F186E2D;
	Thu, 17 Apr 2025 14:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jjsSLf8i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC02217CA12
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 14:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744898461; cv=none; b=EFuRKPm/sMgUGJWLX3xABJOveaBGJX5m93mZ4Drtj3Jld89wiyTs8ey1gYqI0h6KB61v7zIUE5h93/rvqOjemPnc5QO9tAJ3djC8tj2Bvji9DTz1lPRgQMUakgCr9h9VftYJhNFlS1OjevTCUgh+tSgtuUjaPh1wgDPvByDgMp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744898461; c=relaxed/simple;
	bh=S33vVH62Ipcxp0rWly3eyOchMSqBzBo+OASVpMIetFc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qEsg1QFMabGdMvUDtPDWwpu2OXcOMg8SMJ2uo9VTCS9g8v6cYKERrpZVff+FLiYeG0kf1SyAHYvFLcjVb8zeW3JrG5RHumievBWONwNXR7xkZEGyzTQrovKzpfy7EhoUB/r3fLyxL/nhvd9Kv6k79z0Ke65qjQS3vBt8zE39NDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jjsSLf8i; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5f435c9f2f9so1275959a12.1
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 07:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744898458; x=1745503258; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xKq4ypYBfvFz1mRzRFiyY7Cej4SfNKK6kZkOocBR5Xk=;
        b=jjsSLf8iQ6HqrT/IvgBHZ/vVI9jqfBsdILt3sFBwXheDfsecIN1pmricf9maV/VwsS
         G1tAGOJ0R+1i5tDvO0tvcv2RggtvPLOgNS7l0BKRSLWyTsOzkFx9eT/zvuU2+GBRDosO
         iMGUYB/qIlzk8H5SohJ0N1MCeuKdG7fMGnvvDDB166rBzYSJOkYTI+U63roggzdZxFhb
         ci/UbT0Ew38W0426cqHyvCm8Kj11cQEJ/xgN0A2a4/CITnLbe97y7SPXRhmQv6u+NkMA
         L6e/wg+7qvQraZV7pbIipDpJF0Iy9SopnNIiGTwjWTU/QN5a0Nx2fLmyu5SaZmdNiUUQ
         D0yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744898458; x=1745503258;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xKq4ypYBfvFz1mRzRFiyY7Cej4SfNKK6kZkOocBR5Xk=;
        b=ezG+AVPo40NXqd3uwZsn5HobsNeuzHV8nUDgqEui1HMbtFQuhO7zmulHJlycb/slgL
         bDgkw4BgkxN2fFHwMsBV1Ro3Y1eyHF7gKyG7QMdVL2+n/O4SnOM8P8S5eUwlXzprNo4r
         arjx9Ih5z/PtTnvJOF36caG31qYn1G+NLggl+wWL5g6e2+mwaqdnf2H9dXxbBaCbwVq6
         Su5Q8SduP0HRid+ZEh8O+DWl1z3laZ6hSV8KjEbShY139p5ERlNBAvJwZsUCCK9Zzjg8
         zibHOqknS1jyPSCieVKQ2WF74b4Su4iZrHztxBymi2I2QFJEkBhTRofMLDEwqV2bSZJa
         0/2w==
X-Gm-Message-State: AOJu0YyWrXgkLiV+ge4onSNi3AYZmyEaYavTvkrShMXHLXGmyjEeJET6
	IB7uo9Xanx9ValP+cMLubxSrCplQQ7GUPOdUXTV0nYJV+7aQZ4GpYW0R2w==
X-Gm-Gg: ASbGnct1loM9O4C/qrtKl/nSjGCgsiU7T6FOKKKmCrIvvVhR1GhC9JPvBB1qf/tIVug
	kSBSjei350YJpWenRHilJEf+eQ6t6tQbAnePLvHPkq9pfk8dDSgdis7SefSE8N3cotcGbxQUowd
	o7smne2ryJcpklnML06HYfk1DgKte1XcYOQAbDsF5fN2tStXJ04O6byz0lDHaq33yWtPUU68QvQ
	tLJNLbDBPoUsHCYJ+mgyNv2HAPo0EJ/tVNlLOTNfVNYIcx5L4sYK73QxnuJSmG7ndR8+bIu262J
	eRCS5RtN9ze34fVQGFr714xyBgPN5IuUK5BE2xTnbyCUljhb8Uo2aA==
X-Google-Smtp-Source: AGHT+IERCcDohMefhcxVCl/DLtDlTP8oUA7TNuqpUig6wSfjaZTfKzpPxj2vvPV38J2AzxuFrzAt1g==
X-Received: by 2002:a05:6402:42c5:b0:5eb:cc22:aa00 with SMTP id 4fb4d7f45d1cf-5f4b748ff90mr4970448a12.19.1744898456757;
        Thu, 17 Apr 2025 07:00:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1e4? ([2620:10d:c092:600::1:f7d5])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f36ee5500dsm9906082a12.4.2025.04.17.07.00.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 07:00:55 -0700 (PDT)
Message-ID: <167282a3-7b78-4692-8e8e-261a964b3556@gmail.com>
Date: Thu, 17 Apr 2025 15:02:11 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org
References: <cover.1744882081.git.asml.silence@gmail.com>
 <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
 <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
 <CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>
 <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
 <20250417115016.d7kw4gch7mig6bje@ubuntu>
 <ca357dbb-cc51-487c-919e-c71d3856f915@gmail.com>
 <603628d3-78ec-47a3-804a-ee6dc93639fd@kernel.dk>
 <f8e4d7d9-fb06-4a1b-9cba-0a42982bce48@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <f8e4d7d9-fb06-4a1b-9cba-0a42982bce48@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/17/25 14:57, Jens Axboe wrote:
> On 4/17/25 7:41 AM, Jens Axboe wrote:
>> I'll turn the test case into something we can add to liburing, and fold
>> in that change.
> 
> Here's what I tested, fwiw, and it reliably blows up pre the fixup. I'll
> turn it into a normal test case, and then folks can add more invariants
> to this one if they wish.

Awesome, thanks!

-- 
Pavel Begunkov


