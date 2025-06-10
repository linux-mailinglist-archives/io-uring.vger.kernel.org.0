Return-Path: <io-uring+bounces-8300-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E26DBAD42B5
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 21:15:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9A09168502
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 19:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18CB7263F2D;
	Tue, 10 Jun 2025 19:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fMeFfYPJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1CB263C8F
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 19:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749582917; cv=none; b=hdLCqe3QM3CzcXN06YAT76VBUS+i6vtF5vVZJkDpSOoxzxz7DJli0NL8l+iW0j4lOaRECw8bfOoeT7SD+mdZzC2TQ30J6iBZFGiOWz8ytowomyW3PRIUSZ+oJFG91h6Le/RyqXADPj57jB21lKjmnJaQsaoN2+xNjBtXGzrYA8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749582917; c=relaxed/simple;
	bh=MGy6qK/VBqdaCyvHOKbfJnBf8uDNk/GPbvPFMvvtLsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dU7rYY+fL2CUR5FtBqVePGArIWdlM3prsk37a0r5cNtEUEGe/x7wSh39VmmS5bV5Sh9jJLfovhv+0Aucu0pVU3gbVqZITqLV/grlXCJNR5sXS2JSzSxwq0CjHbI2C6hx4OEIwOjHV4B83QGLfaAf6YKN6SQ9IvyUwEgRiq5MXew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fMeFfYPJ; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddd32e3955so13161755ab.2
        for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 12:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749582913; x=1750187713; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/j9FXKinYS0jl8lPBzroNI7xxfpIKvqswm8O4WB94nw=;
        b=fMeFfYPJ9cN/Rqzw7vX2Wr2E9PWA8Y8MWH9icNw36MzJvi0kQHv8hCE7wiEn8Z2Bex
         +zuh7Fg5+sKLyZlDJHlGBaxz20l62KIABGGeAcrQkpwgApo0YudTtqrBeM+/68xw7X5Z
         /8XD+zpsyYulOmwJeBBaBBueVgoxwqIKBmO9yKF/WFi8SjLBOrSWlBFQ+gVqILsvMQ2z
         qYddQVUniDAjQisJP+ZvDx1cWAjtuNSR6LG0h9IrxFTvo24sfDpbdJEBvmk90KPPlME6
         6qRoAzyjlr7gZWPOebiDMIZcmTAZUCYOmQYIg9mW6WTlXadbqWFcDdTD6kAiIGLpMA0a
         M6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749582913; x=1750187713;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/j9FXKinYS0jl8lPBzroNI7xxfpIKvqswm8O4WB94nw=;
        b=Eq3fMPVZ/eiaP2aa9uFk8UPVGhwMmI2xXtZGLKQDIlvVO522z35zLvtRMThwIim0g7
         0IQ1tddwsW6rJjvlBvDBqbYYvBq2lWsfGZWtnNV8hGBYzlVBVQ8YlyTByRtmufaWz8vH
         6AMx+L92mUOurbCIKBKd8HTPbDqHVC2CPxefm9PPwChLr5RD+gKTdXsMEijss6WP0HKg
         A9wVv8Y/AQKwQIe1H08AoIufpSqZcWlmaztsZpww9bxxHxPy1WJGB/fuw84olcQwMWjF
         mPcuIai26fDDeFvV4dpiidn7nsTJJzuB68yeOuf6/Ls2rNzOBb1ObMU5AqvmHQwSVjnR
         nitw==
X-Forwarded-Encrypted: i=1; AJvYcCUtpEyeXfj76fnPr3nwbXfHIe8uzroLAdV3LOEjgHUXncrU/EbMxx8M6DKUzzJyMtrtQiOD2TLWuA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0e1zQup6d1575DnXvdBheE9sKWfI/WbJ3FRcZhpF0cleSq1ln
	A/McqkcfNqkG/qkwmuGe3cwNnQqQed4/RtpTb0eDSwaGTzauLvm4MuL1r79q0VvzWHI=
X-Gm-Gg: ASbGnct0u/+wdZq0gf4oh8P19lBBwHL4MaE6rvD99IQ1sb1vpZwjDEjXjalNeCJIT9o
	d0NEL7U9GmgoKLyYNavSRzKNC3FMxVd+Av+cOmmk7kxWfsuQ8+QQWwy6ODAxQHElwYIMsl9BE3c
	9tv9udtMns5OMO7zps4NBG+8LJAU3Cg7OfrEv0C9xbSIrjdfeu8RlV6f11ph1kzIR6HIlq+KJWv
	Kq9TWCWN9AX+v/y8p1eN0lVWSfbzi1UIfZGtIeaEKEwjl5+dtq4R7kWr2pebqndrR14jXeDFflS
	TrTQz1Zs2tZGv4WoERvXJBepn4DqCDfJ+YsmXFpyxmWbwibo3Im/pPEoMJI=
X-Google-Smtp-Source: AGHT+IFUoILLNcJdpEHEAO4wv+jyXarSE4Tf4X3NS0sRBswrKwrDvVX2ugMzP7x6D2U4fQz3KE3/aA==
X-Received: by 2002:a05:6e02:3b07:b0:3dd:ebb4:bcd8 with SMTP id e9e14a558f8ab-3ddf4262363mr5452575ab.9.1749582913421;
        Tue, 10 Jun 2025 12:15:13 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddf4775d44sm224475ab.72.2025.06.10.12.15.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jun 2025 12:15:12 -0700 (PDT)
Message-ID: <60ce403c-12e6-4677-9503-a7cf3411fae6@kernel.dk>
Date: Tue, 10 Jun 2025 13:15:12 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] io_uring: fix use-after-free of sq->thread in
 __io_uring_show_fdinfo()
To: Keith Busch <kbusch@kernel.org>
Cc: Penglei Jiang <superman.xpt@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzbot+531502bbbe51d2f769f4@syzkaller.appspotmail.com
References: <20250610171801.70960-1-superman.xpt@gmail.com>
 <aEh9DxZ0AQSSranB@kbusch-mbp>
 <48f61e8e-1de6-4737-9e58-145d4599b0c0@kernel.dk>
 <aEiDs5J3Uy3NSK3m@kbusch-mbp>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <aEiDs5J3Uy3NSK3m@kbusch-mbp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/10/25 1:12 PM, Keith Busch wrote:
> On Tue, Jun 10, 2025 at 12:56:31PM -0600, Jens Axboe wrote:
>> On 6/10/25 12:44 PM, Keith Busch wrote:
>>> On Tue, Jun 10, 2025 at 10:18:01AM -0700, Penglei Jiang wrote:
>>>> @@ -379,7 +380,8 @@ static int io_sq_thread(void *data)
>>>>  		io_sq_tw(&retry_list, UINT_MAX);
>>>>  
>>>>  	io_uring_cancel_generic(true, sqd);
>>>> -	sqd->thread = NULL;
>>>> +	rcu_assign_pointer(sqd->thread, NULL);
>>>
>>> I believe this will fail a sparse check without adding the "__rcu" type
>>> annotation on the struct's "thread" member.
>>
>> I think that only happens the other way around, eg accessing them directly
>> when marked with __rcu. I could be entirely wrong, though...
> 
> I was just looking at rcu_assign_pointer():
> 
>   #define rcu_assign_pointer(p, v)                                              \
>   do {                                                                          \
>           uintptr_t _r_a_p__v = (uintptr_t)(v);                                 \
>           rcu_check_sparse(p, __rcu);                                           \
> 
> And rcu_check_sparse expands to this when __CHECKER__ is enabled:
> 
>   #define rcu_check_sparse(p, space) \
>           ((void)(((typeof(*p) space *)p) == p))
> 
> So whatever "p" is, rcu_assign_pointer's checker appears to want it to
> be of a type annotated with "__rcu".
> 
> But I don't know for sure, so let's just try it and see!
> 
>   # make C=1 io_uring/sqpoll.o
>   io_uring/sqpoll.c:273:17: error: incompatible types in comparison expression (different address spaces):
>   io_uring/sqpoll.c:273:17:    struct task_struct [noderef] __rcu *
>   io_uring/sqpoll.c:273:17:    struct task_struct *
>   io_uring/sqpoll.c:383:9: error: incompatible types in comparison expression (different address spaces):
>   io_uring/sqpoll.c:383:9:    struct task_struct [noderef] __rcu *
>   io_uring/sqpoll.c:383:9:    struct task_struct *

Proof's in the pudding! Want to send a patch?

-- 
Jens Axboe

