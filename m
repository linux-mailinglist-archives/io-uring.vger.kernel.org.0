Return-Path: <io-uring+bounces-4056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5844E9B1B75
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 02:07:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 93FE0B214C6
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:07:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9276801;
	Sun, 27 Oct 2024 00:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MQbNxTpR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866182F29
	for <io-uring@vger.kernel.org>; Sun, 27 Oct 2024 00:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729987636; cv=none; b=M3YcaiFPka/WjuPABjhE5r8yfXu9ppJ+sO81hfrmMOK5BOweLZDel2c/m/ZaSGknyFq4MMH7SWbNmoVrX2AEcCpSgPG9vn3ka+c9ikHJwejSVJ3KMwMyBlYp/Rh61KUyCVMx4mB76p3XcP2Qhe3LfHWv3OYchosZTivgvtDMXJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729987636; c=relaxed/simple;
	bh=N6Yyv3HHJhVBQ9NKZoaWRzNDtwlIKpbwMMPtvPojGmc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=CKw2owFBPafxRVB4Eky/oE+sDZzzY+ByLDrP6tV5/wKF7Pe0lnHVgrRsCz7tM4jGDE74RfwvZd8jKALUb+5ICcxDMTOn+jL1YbGSUZPcc7VHYLqni0ea0xIcBYYmt7dV38Bv3ObKgs7Z4azhCGzXlf0bkGoZ/7DhcUjGAD6Bk70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MQbNxTpR; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-7ea12e0dc7aso2200047a12.3
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 17:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729987633; x=1730592433; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8R3G7AqjWZObMmrO1kNujg8dF27gMMmre0n3SCm9Kk=;
        b=MQbNxTpR4D2tCzQt2E6uap6aqV2V1gvCsyscrHsV4ILojRajvz9lJtdPYgH0c21cZ5
         ie2C7kHGs7mbc+sPCC4pgCPMwBIncToJrXeWpEhCs72zXCULNxvp9uwm5ykVM8dYdUSU
         pmRltHJVaZbUZmdOLIhFH95/nyoddpxXwCxYnQeqTZAxim1wmfaTTBbdEHtoFQmz1Ek9
         sd5r1IrzgZawskjMlh/b71eodUHWwwxfpOmVtv6TKCzxGP/BADrB/1fCZBmrDERotefM
         C7S67EaxR3UvXDCF4r2afPARZFLIY0yVJot047orDLKBO1sz4bYO0uHE9haOOtkMmCO9
         WHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729987633; x=1730592433;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w8R3G7AqjWZObMmrO1kNujg8dF27gMMmre0n3SCm9Kk=;
        b=f8P9y2gOf7eQurvvPa3cdhGv11fKKS91mepBTTO6nc13OzFxaFv+IUfn2cWHrPCBT9
         ju3iJvVMKQV4jqZ0v8RZnsBjU0ms8Lmd8mxcqArjObX+Wch7ndpW5cMzfUmplPXHXT8T
         N+SowESp7bZbmTUCXjZoFMJykGzBIUcaSiST5gXldYVUe1/YS1bkaiI/5t0ZSQusbMDv
         ShZbmM3m50CikUc0WcYu6ca8OsxSn3T/8q3EBgUrr63FI+8lOAIBIcMXiQanREI8eZbw
         C8ifKii19746Adg6W43Q+//8A+y4ZH2z5Au9m0vriLyFEJHJkjjruq77+Esl656yOBH+
         27Zw==
X-Forwarded-Encrypted: i=1; AJvYcCUrVAiW2+ysaMM7kocyCoDH4Kio2HJ+IuiwcMm5jk2RXAMYyWNNdKPkfuH5VYSKvs6LFcE7BR9cdA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYf9bMy/QijYzBCBqHykyyAPopyZBNIq8iUeByD3Ped7Oi5ay0
	w6Z1hnPJeu1Rg+90h10SytIYwnIowSecKzEj6btgnz9p/LgzJqYWpvSOk+SCpAI=
X-Google-Smtp-Source: AGHT+IFcapSkOX/3D7DFAqGCa3Tu97Ds42ZW3VkvwgARCp5b9XKgHmssf1p+2DCRXRMJ5+7m68Kv0g==
X-Received: by 2002:a05:6a20:c6ce:b0:1d9:77a0:20c7 with SMTP id adf61e73a8af0-1d9a81ba801mr5444518637.0.1729987632847;
        Sat, 26 Oct 2024 17:07:12 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7205791e54asm3256765b3a.30.2024.10.26.17.07.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Oct 2024 17:07:11 -0700 (PDT)
Message-ID: <b51adba8-7722-4f74-a865-47bf1638820f@kernel.dk>
Date: Sat, 26 Oct 2024 18:07:10 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] INFO: task hung in io_wq_put_and_exit (4)
From: Jens Axboe <axboe@kernel.dk>
To: syzbot <syzbot+58928048fd1416f1457c@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <671c817d.050a0220.2b8c0f.01ad.GAE@google.com>
 <5ed947b0-5762-4631-8633-b737bc09eebf@kernel.dk>
Content-Language: en-US
In-Reply-To: <5ed947b0-5762-4631-8633-b737bc09eebf@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/26/24 7:44 AM, Jens Axboe wrote:
> On 10/25/24 11:43 PM, syzbot wrote:
>> syzbot has found a reproducer for the following issue on:
>>
>> HEAD commit:    b423f5a9a61f Merge tag 'acpi-6.12-rc5' of git://git.kernel..
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=1393565f980000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=fd919c0fc1af4272
>> dashboard link: https://syzkaller.appspot.com/bug?extid=58928048fd1416f1457c
>> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=122f04a7980000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132cbe40580000
> 
> Perfect thanks, we'll take a look.

Took a look, and it's one of the usual stupid cases of "let's just flood
it with things and exit will take a while". In this case it's adding a ton
of classic provided buffers, and then exit takes a while to prune them.
Not convinced there's a real bug here, outside of the config have lots
of debug options that slows everything down. It'll finish eventually,
it'll just take a while with how it's being used.

-- 
Jens Axboe


