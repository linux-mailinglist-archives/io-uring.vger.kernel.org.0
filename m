Return-Path: <io-uring+bounces-7377-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12BD4A79FEF
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 11:24:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 045921723F3
	for <lists+io-uring@lfdr.de>; Thu,  3 Apr 2025 09:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B9BD2CA6;
	Thu,  3 Apr 2025 09:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="As0Gg9+t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2B524166D;
	Thu,  3 Apr 2025 09:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743672200; cv=none; b=Jz3kAr/yWXRkaWl89UU+/ZcbeGUZkNEXsQghXlCZPNehN/Mrl7m+P/shwpy6Qb4LbpZX6w05Ti5wg+4Rm7mvMZAcTEmPyxlENzfzJoXeaTP4tht4Grnh+1A/FyaH+AOmjWz+/ky3JaZi3So3fUQAmAC/gGDInvd0UyMGYEf0or4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743672200; c=relaxed/simple;
	bh=N9b1V6CdmaW7F29XZvMGIsaoGCxay6Bf9zquuc1bzM0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pp+80ZqXYeqvqjtMxe5jv/Xy1j5MBpD0EEnCFMt1PJTzne44wG+fQqP7DeXmocoGqKuUwsoA0OmosPzeMtd3EfZmV/9gefSC45eJRGH0NEkoqZfO9/zwfKmyCZKtISmILX27ppdRQwFNzgBuw5xyb5S/A9HlWjh5nJ/oUdyz6mU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=As0Gg9+t; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ac41514a734so113301766b.2;
        Thu, 03 Apr 2025 02:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743672197; x=1744276997; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=exPJhyprvwS7fDK4cgybdTAY3YzrLn/mjakVTSTU8mc=;
        b=As0Gg9+tIAIOFm/SiSHPf3BjXegH1u60bsW2WQsMMWgvOy1ase4qO3BdjVOO1cV04Z
         YaEifwGQ3bEpnhJ6lvChvBVjD6IL+KrfzqwYn4bYky33PU9MBrJ9GnYaX/igl9pZLfOg
         ksoQNONnQNlz2XWYo7ZH7HTDXppcbprHpBCxBG6L49YoNJp38lgpM70dALwtU7QICmU8
         gJhHMB9x+3LET4xSRiOMzaMTmGdDvkqpHvOZETN8/sAs6Y35sn4VgarFxPyfh4BsORut
         IGtgTtmXfrduqSfzkzVB0wMSJrpuvtYvsfQNsNe/WbWPsAMchetvzRfYPsaJIaKdLHY2
         9Zqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743672197; x=1744276997;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=exPJhyprvwS7fDK4cgybdTAY3YzrLn/mjakVTSTU8mc=;
        b=n46yvCaQWJFxW7e1rH3Xg828rMZCQfMxQkQfeunT+scVvfhjMZBMPO49+3HSH1gnlq
         pfOjjCxJ0wyJVPIRqPjQm3XcfmimzlYdkP4I0VBCafgOEIqPWpTT1/7764rFLDs6anq/
         yOzkM8fGraMT5H+yiYyC+ybgvX/Vw8+59EFBCcGhlagngUx9aauqJLCHWxAB789wy71W
         zJb97mb+HXYBro8wiV+nrQuFzaAdCB/abEe5VZ2duXOxpykSUgvlkNg2e9nUJhp8MQHL
         86DOVvYNcD/ycNdfeTPlj1+ihrAQjueoj+6ueBSBobF1l1AeYQBZ/N5VYgIRDpBTkDDP
         V48w==
X-Forwarded-Encrypted: i=1; AJvYcCULDC5PU5l+ZM6QAi0wgun/fcxLiPqaP8rQFo8NWLflE7rx8RwjZfq25uAOVzU2JWdW13WXTChNog==@vger.kernel.org, AJvYcCV2larLCrxJXbdjRIHNLY6Zb5OwfkFwaMZAxqxYpFOcJVBTN5Ie99Ppa7kpQpQVXBPuJbs3He+Xh/bMdcdv@vger.kernel.org
X-Gm-Message-State: AOJu0YxHNkeDlGXebf8AHsTmT5M0FCH85WJMXSiXB74eHRiH49yLJX1t
	0Mvdzdw1YewJ9Hngk2fajTjmQrQOOXqQgeyYpt3jgNhd4dJruHmwbAsGMQ==
X-Gm-Gg: ASbGncsvCocvEZwz6qohOT7lT74vOr4F9yH+PYl/tH2AdRsvDVUuM5zS+pRvjXjdwJE
	nh6izALCMuGNZyUrwkDz72p5ab0m/OvZB2nbN3n5aOSO9c7FU7OkLLiSxg4rUFECt3Dj/aN98QY
	stTZWkUCA/LoGTPYx7gNLt6Zi9po1bpzZWnTnpVsbhA6nR0XHB7APoVdsgLF9ttbgnviWFWEoGx
	qxIFWuNCmjqSWLk+gw0vwvx2Czxn1BFD/eL8bY3BkGYdDeps2aObAhCMEJO9R3TCHe4v65h9iSk
	qi0gUvVuUEEWpk/S4GLfyxISeTpDvhSSRCF6RPQKpiL0Uc7vv3gSqRkawTBQKIeR3aLv
X-Google-Smtp-Source: AGHT+IE/3z/YaoSAMyKn8ZSk+y/PpRn/DKRL8782yHX+u07rx+ATTyFbOC7QjrVzzvXk0OuQVzwNzg==
X-Received: by 2002:a17:907:2da7:b0:ac1:ea6e:ad64 with SMTP id a640c23a62f3a-ac7a1731d04mr503075366b.28.1743672196558;
        Thu, 03 Apr 2025 02:23:16 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325::2ef? ([2620:10d:c092:600::1:7d8b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013eb4csm61916866b.96.2025.04.03.02.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 02:23:15 -0700 (PDT)
Message-ID: <ad93b770-803f-4480-95d9-6061f9e778e0@gmail.com>
Date: Thu, 3 Apr 2025 10:24:31 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_req_task_cancel /
 io_wq_free_work
To: syzbot <syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <67ee32f2.050a0220.9040b.014d.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <67ee32f2.050a0220.9040b.014d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 08:04, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    92b71befc349 Merge tag 'objtool-urgent-2025-04-01' of git:..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11195404580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=a8120cade23cf14e
> dashboard link: https://syzkaller.appspot.com/bug?extid=903a2ad71fb3f1e47cf5
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/2e7df7bc2f52/disk-92b71bef.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/be59123d5efb/vmlinux-92b71bef.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/7c9eff86053e/bzImage-92b71bef.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com

It's benign, the write is for unrelated bits and the flag used in
the read path is set before there could be any races, the compiler
would need to make up a value to anything bad to happen.

We can improve it a little bit though, it'll try that.

-- 
Pavel Begunkov


