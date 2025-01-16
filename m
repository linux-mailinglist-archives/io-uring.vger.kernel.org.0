Return-Path: <io-uring+bounces-5921-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD8AA13CEF
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 15:55:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6543716B7FC
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 14:54:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D6A6146D40;
	Thu, 16 Jan 2025 14:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wjzaOKGC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3579198A29
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 14:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737039093; cv=none; b=cIvfx04xyXmY90ikoYhxzKe4ANzH/r6Yignie7fkB7U/gc1lom8Y0EiGX7oHMzQCBaQhUa0fw71VyWBiRyAsmNnbY4u0zwN5tznzzkBJflbnA6uNkFjO/JxR6rbcDr4KOmNusVQS5ipFLqir/h5gjvlsispASXVBcuAQBKouY/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737039093; c=relaxed/simple;
	bh=it7Kx1p5oB48RRPUcbmeh3Do7Q+17ZFuF9AleZo6h5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iW5tguAAV3j8jMRuYMxf51zn3e83CL4oA7KTaXoOiH45J2w4LX8UqwAposFmYpF7R3Vzn0gE07CpvTqlVFphdx08MrH5qvp9/ZwAccqXrnz3ztiICbTHd6c1PiThruvgAmBbfC17pRy0UIWRSfA8iC/g1jMl7V9Ckwkbk4Hkarg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wjzaOKGC; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3ce85545983so3673645ab.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 06:51:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737039089; x=1737643889; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W+YKRKJAI9ueYbnqMHO1JZqRYlu2N0OhJ4VTt6cLYLs=;
        b=wjzaOKGC22uAPUsHqjrATVXZBIaghmgqb0bXMHR6lzY3beeJC+PFlVBpCr3USOZsNZ
         W16/kpaJ+gLzfX4tgazDZa4NW9mo+DhgPT+5gytQs9GkF2clYn/cGtzePJgF2D2t1Jmh
         ccRlzWT0kXX8CGofHP8bo6N8JicEX6Hf+aaHui+HVH56DOdC7jdZfA8G0AdilUKFqym9
         ZfTcpPnlSXP8rG05j+JaD5LfTruVm6BqJ3xbGdxZllt8bps3tq/wTO3m7BTp0GlaghpE
         dR+QGNG1XDkiP2HJ8ZeI433lj7CsQQam1kZv9ftztc/lVd9A9vhkquF2A+P4fRtxxG9G
         KWmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737039089; x=1737643889;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W+YKRKJAI9ueYbnqMHO1JZqRYlu2N0OhJ4VTt6cLYLs=;
        b=rF+QzeSLx5tNR2fBQWEkOHRG+yTf9UQmKTaMntWBAYBifpzHS8ttYlmO8fiCqhIvmA
         N5zCAM2x2+O4Bebqx++75H9c7Bx6I5tXHcNWwujhxnRXXGgp3UY53hI44LJCBZu0GtYu
         7DE0JP2RpV/YXJ+rMTmPRrxGlPqMzeM9b++oyVwe5Hdm7EG1wLf1ThYJX4EcJfWxDxTY
         0B94jSpnmv56PCActE97CTWVZDJ3hq7WFl9U1f3rOwHeclImHDBu/7Hhna4UV3SPVn0k
         eugaPDeW6my2tFBSHl9tzOBlJJtJ1QPUsMxuzL+EPrc+/LjuUTbUVIMNU/tyzusOPScl
         JxvQ==
X-Gm-Message-State: AOJu0YwPz5Ochk2vfVDil6FUnaD6qjweVIjwlD5TqJHcqjUBo9Pnou0b
	BbaQ39xaVoKCY2ynJSh4TemfMsmdun6+yKeEs6BF1emO3/UBGe/ja2qNcaNZdDU=
X-Gm-Gg: ASbGncsS/dhyVmHBJ8udPIys4NICJKg9kviUD3Ifu391PUQVr+1lhsvHJgbSXLmLfa8
	gIc+Hp+dJ4Pkkoo5gP7LU3N6B8wqnNfsfzeNyMI+Fok8xyCongcyzjY6Kb+b6XKBE9WoqkgYjbJ
	lygwygSytNoEjJLiKFl0qSycrg6HhrGlSOdYRNmTpZqRN5s/8HSi+oV8DxMA6Z5z8LkQDJIcDJu
	ajb8qfJFFr0GTmZQzinZOGguxCpGP/3TT4CdbedxdxYVQYa6O0y
X-Google-Smtp-Source: AGHT+IEGE2cibYOQ3RFaSXFNQEUGVjV4+8d0y8Q6k79vGuIKMucFY2+sAYYa/vr6Au52SdKD0SIbpA==
X-Received: by 2002:a92:de50:0:b0:3a9:cde3:2ecc with SMTP id e9e14a558f8ab-3ce84a1ab85mr57633365ab.6.1737039089004;
        Thu, 16 Jan 2025 06:51:29 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea756c0ab2sm51530173.136.2025.01.16.06.51.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 06:51:28 -0800 (PST)
Message-ID: <70895666-4ec5-4a2e-a9c2-33c296087beb@kernel.dk>
Date: Thu, 16 Jan 2025 07:51:27 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] test/defer: fix deadlock when io_uring_submit fail
To: lizetao <lizetao1@huawei.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <77ab74b3fdff491db2a5596b1edc86b6@huawei.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <77ab74b3fdff491db2a5596b1edc86b6@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 6:10 AM, lizetao wrote:
> While performing fault injection testing, a bug report was triggered:
> 
>   FAULT_INJECTION: forcing a failure.
>   name fail_usercopy, interval 1, probability 0, space 0, times 0
>   CPU: 12 UID: 0 PID: 18795 Comm: defer.t Tainted: G           O       6.13.0-rc6-gf2a0a37b174b #17
>   Tainted: [O]=OOT_MODULE
>   Hardware name: linux,dummy-virt (DT)
>   Call trace:
>    show_stack+0x20/0x38 (C)
>    dump_stack_lvl+0x78/0x90
>    dump_stack+0x1c/0x28
>    should_fail_ex+0x544/0x648
>    should_fail+0x14/0x20
>    should_fail_usercopy+0x1c/0x28
>    get_timespec64+0x7c/0x258
>    __io_timeout_prep+0x31c/0x798
>    io_link_timeout_prep+0x1c/0x30
>    io_submit_sqes+0x59c/0x1d50
>    __arm64_sys_io_uring_enter+0x8dc/0xfa0
>    invoke_syscall+0x74/0x270
>    el0_svc_common.constprop.0+0xb4/0x240
>    do_el0_svc+0x48/0x68
>    el0_svc+0x38/0x78
>    el0t_64_sync_handler+0xc8/0xd0
>    el0t_64_sync+0x198/0x1a0
> 
> The deadlock stack is as follows:
> 
>   io_cqring_wait+0xa64/0x1060
>   __arm64_sys_io_uring_enter+0x46c/0xfa0
>   invoke_syscall+0x74/0x270
>   el0_svc_common.constprop.0+0xb4/0x240
>   do_el0_svc+0x48/0x68
>   el0_svc+0x38/0x78
>   el0t_64_sync_handler+0xc8/0xd0
>   el0t_64_sync+0x198/0x1a0
> 
> This is because after the submission fails, the defer.t testcase is still waiting to submit the failed request, resulting in an eventual deadlock.
> Solve the problem by telling wait_cqes the number of requests to wait for.

I suspect this would be fixed by setting IORING_SETUP_SUBMIT_ALL for
ring init, something probably all/most tests should set.

-- 
Jens Axboe


