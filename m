Return-Path: <io-uring+bounces-8612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6963AAFC565
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 10:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC3051BC2E91
	for <lists+io-uring@lfdr.de>; Tue,  8 Jul 2025 08:23:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC4F32BE059;
	Tue,  8 Jul 2025 08:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKeLe21O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE9B2BE637;
	Tue,  8 Jul 2025 08:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751962974; cv=none; b=pEAa7/0M2xyUJ4wUg1bJ7M+LW7jU1Zvfe/7o84wDvJ1EwqfpfQmXZs2PNxJoxBnIQk1OTZMzk+ufZFItJ3LlnLSLY4u0ZsPEGGRrlPPNTuWkycj5ZV1MIVkUYLSuq01g5LF2rJgA9tVKs534dv3ux13NwYnK5E+0XQ2eUlAbEBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751962974; c=relaxed/simple;
	bh=jualjBCwRjVeX+QgNMtQhdaM5v4JwMGLvjZ44KhUcy4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B6+te/Mz0azKfQp/hdVUDWrPtRXUuDTDFybJGLuh6FpFJulqDKnoWH0+YoVk1bS9ND5VdjARTdqHPr5lQTVPdLbQfOeeSDDsnDInlu4kqUk/kAhbSmfC5rWbZpYKHANlmxU7zQKho8b1D/cfmLPuq+T3N0eSxnwv5XXqRw7sqQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKeLe21O; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ae0e0271d82so826948666b.3;
        Tue, 08 Jul 2025 01:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751962971; x=1752567771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=924t1oAYx0L0AbJARjwxcHPMhukyHGVh1zX2+tHv7tg=;
        b=HKeLe21OVJRBTWnZKK7TvGTZE+8YqAqqKcjchc7wXY4LrR2CRJlC2kkM3W0cAsJgfg
         ZqgLMa62zi81XdDppCE+i9jYkLXB0WR/r4rm4VkZGTAFeOAWKwy1OAIfuu1XLQJ5NQhn
         ZtvPj/WZ25xcRjH1/t7R+dJSO6KPVJSXRtPC10ho0fxiYCj/xo6Tzzk3j+Da3LzJb3NK
         CmYeTaeRtrnX+fci7TdyqOJTCW6/m/74pgappP4N+htpQB3SjMof4kBodjKTHvNimW42
         VnEK/RnRFhFapSiNNEs77EJNwaQvJkAVoo9/9KQcBQJweuJ+Ibf2CYLYNUlL1Cqdkde7
         I+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751962971; x=1752567771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=924t1oAYx0L0AbJARjwxcHPMhukyHGVh1zX2+tHv7tg=;
        b=WPq7wxIDrSyzBKwGWwc4FtoFiFGkp+II1e/fW3WMyLvWIgPWU43PBGC8xlzD6V9Eo7
         +VbSsEMmcehbwXQaBItKR5YrKmMILcKI8icnMOQzsWRuT4lUYa4RQxho4zBwJ8Ia3yPZ
         L2YFsbbqV12ufr3h5b36wIvQfcF3//szPzM3MsSXx5dnxNqWF5qJrBa6eRCTn1vkicVX
         DsmXHVxvap5SIwymfiefrvEdg5Rce2g4TLmtbaxCi33ZpFnFEeOd02neb6J1Pbv1exg+
         S4EhU+n4J4RzZWx+dgu0GuSHYSvjQtJ93yr4GE8Rvj+ODoZhZ4wmVYYdAthvtA7Uw1tX
         2Jsg==
X-Forwarded-Encrypted: i=1; AJvYcCUurj4a7Sl9FroXhPOZ4zc2mZYcBiGv/rf6kkDuJBCACsSTfVRA+7bitoRGiC81bFj0UUcC/bmkmg==@vger.kernel.org, AJvYcCWi5K0W8TulPoKGSy/npnJ1Rs63VYNmoHdBBqyGMSK854UGvZjnE6tfgbQdyh9E0cDUWHfBeKlkiYWkapLu@vger.kernel.org, AJvYcCXvtyhHHKtUm04NWcTqZ1PXCTpEtp9A7CaagjdF9dsyOxPLOlCOOcVscr+9WgGmOZa/XXetXNEaHuHby4QpdQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyUhI1B+6ymj+yGXIS1yo2/TucZfUX5MYIQ13GgB/OMsHjEXZ23
	BCo2Sa989vWcKxTfYV1wzK8w3iujOR+lS2FqEhTqjmfJfCHvH7wDbx9+
X-Gm-Gg: ASbGncvw+5ne3L+1xp7lwJRmbBrmRgP/PnGUH9EDUBYDLhusi0YVvz0cq72ULePjLbX
	Gz9jYxsRgJAw3XZmAOy7KKylQCH5PKR/T6DHVPocApTZhvUubRHJbb2abCP5FhKHkVDLRPCiYTp
	pJZIPlvkXfKvf2qZgDwrBf6e28vxNliC1gk62njhSiUcmpf6k77PTo2SN/iHFafVu0DbwFKElr+
	J8ftrbkX83DnlTWVPn2RBgNEfJO/uXV8uJC/NiYpNCZe/IGeNUCsrg45SKJfDfuBqxTf8cHOB6d
	dKS/El6JDQdNQVx6L5eLWNznrlUplhxMdWZFHOlEDse+nFJ63Qmh5sOqg56L5vwS/VJKhwgdN8o
	=
X-Google-Smtp-Source: AGHT+IGMRQ61VwYQ2vN+Uf4NWX9g1lKr9RmLW1NnlHUktgMRBPQgnpFd7IvsAZfTjj5Azpyp5TXuCQ==
X-Received: by 2002:a17:906:d54c:b0:ae3:a3f7:ad8e with SMTP id a640c23a62f3a-ae6b061b38bmr206333866b.25.1751962971375;
        Tue, 08 Jul 2025 01:22:51 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::1ac? ([2620:10d:c092:600::1:4dfd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae3f6ac679esm854716966b.104.2025.07.08.01.22.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 01:22:50 -0700 (PDT)
Message-ID: <9bfb10a9-0400-461f-af4d-54946455e74c@gmail.com>
Date: Tue, 8 Jul 2025 09:24:18 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [fs?] INFO: task hung in do_coredump (3)
To: syzbot <syzbot+a8cdfe2d8ad35db3a7fd@syzkaller.appspotmail.com>,
 anna-maria@linutronix.de, axboe@kernel.dk, brauner@kernel.org,
 frederic@kernel.org, gregkh@linuxfoundation.org, hdanton@sina.com,
 io-uring@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, luto@kernel.org, peterz@infradead.org,
 syzkaller-bugs@googlegroups.com, tglx@linutronix.de, tj@kernel.org,
 viro@zeniv.linux.org.uk
References: <686bf556.a70a0220.29fe6c.0b0e.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <686bf556.a70a0220.29fe6c.0b0e.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/7/25 17:27, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 2af89abda7d9c2aeb573677e2c498ddb09f8058a
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Thu Aug 24 22:53:32 2023 +0000
> 
>      io_uring: add option to remove SQ indirection

Doesn't look like the cause, the previous repro from 28 Oct 2024 didn't
even have any io_uring, and the patch only reduces sizes of some
allocations. The common part b/w programs is
prctl(PR_SET_SYSCALL_USER_DISPATCH_ON), might be related to that.


> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14ec9582580000
> start commit:   05df91921da6 Merge tag 'v6.16-rc4-smb3-client-fixes' of gi..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=16ec9582580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=12ec9582580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=45bd916a213c79bb
> dashboard link: https://syzkaller.appspot.com/bug?extid=a8cdfe2d8ad35db3a7fd
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a2228c580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d48bd4580000
> 
> Reported-by: syzbot+a8cdfe2d8ad35db3a7fd@syzkaller.appspotmail.com
> Fixes: 2af89abda7d9 ("io_uring: add option to remove SQ indirection")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

-- 
Pavel Begunkov


