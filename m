Return-Path: <io-uring+bounces-4013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF75E9AF4F8
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 00:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 19DDEB20E68
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:00:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A5822B667;
	Thu, 24 Oct 2024 22:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="m1SDoowK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C3722B67F
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 22:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729807242; cv=none; b=rpPQngJCPdSexXPikEMAYe/e96QAvg4ANBDV5t15L0A+KF7Lc+v9tdeDRw8rH801SZGrdE8tWSW7xTgQQKDngyK0ug82EofnsTrcnBMKbArmSdMANF0aaMhPjkQ/wCM3/btCu7auRpukbFnsdWwNsl4ChtRkp09YLQWqFGz2whE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729807242; c=relaxed/simple;
	bh=a9PVuWIdeyUhxvrKzRL3GLGPxz0m11iVGlnuETc/eFo=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=f9wUlA2G2hmLDIPxSPQ2s0Ne62PMcPv7oDZMc8QE/cdGmfzd5/2SFN91BtXi1laEg1SbwjetCxMvOkBj/zBxmLYHuYxR4T6qA1gAwYgVb7uF9w5uRtwle1JwSrnqSMExOSPdemaFvYOTtZ4Mm+GNUdPdi7HS4v1rqZL4FYQU2BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=m1SDoowK; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c77459558so11292035ad.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 15:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729807237; x=1730412037; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KCNplL8u+f3ol8PhFpZjb61DxvneF5Xxcoa8hntzeI8=;
        b=m1SDoowKLfzvUKs92X6QAg8UGNPurE+nS6S+dyVrYH5ry8xpVRhmgHGxmrb8jkAclp
         QkRSIsJm10BjF1eId2QffAroG7txnLp7Te4AJd+fXqzp0dTFG+G9/zWP4jobC/rjL0J7
         pw7H9z8cyJOI3W73jmw7fl+1Q+K3dF1heZlZ1EG3PzK5RzeXxDMm8rFSyTCo9h/ky577
         N+vDLCuldxsRuoNMPzSWwgobgrT4dbW5EVKqEKKlNg9wmgixyp1s6Nj/P+DrUNRGXMNW
         yhja/ibJ/tqRTzTZNhZxZtCTil7ZvA6sD8CiUZ/YtYceWptAgkU+zRnmfs+eV/qLW006
         nwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729807237; x=1730412037;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KCNplL8u+f3ol8PhFpZjb61DxvneF5Xxcoa8hntzeI8=;
        b=dbuVqkwjnzT7lHWQCtdl+s1sB3ZhsrCE8cfZeNshu4X2KfSQwNANOSba7SlIxjsz+P
         yVD+jobktDmZ24cixs5ejhq0TgIyyNy7rDCNA/3sCjp/1dGSw9WM8OiMEoDg92YxIs/x
         Qh2jetC7roa6HnHdraQtu6eciy8q7ZOTT9PqMmrHOPPbVIjZ4LiPenXRJ93NgB21c5ge
         X65mrUjk35ihCeCXSX5MKLsi2Y9wnIYmV61FXYHTK6+Db54fkb9uxG6KhX2Rz98+qL7R
         lnMF4Uei/oIux8CJ1g7+ikEeor3xGTymdVimzo80T8Cg1YoMRvcMORDER96cDBwIT8n+
         DZyw==
X-Gm-Message-State: AOJu0YxSgDkK5xTAxBk6abqn+bCgQmd8NkNl+y4qGeQ37lMKzfSH7mYA
	LxlsRoG+dmymAQSMXGTOC+lNzfCc9sjt7mgdKbmKEKplL5DBMQ4gDd5E8GaybIyjxIZDVWrckT1
	1
X-Google-Smtp-Source: AGHT+IFnsTDEu9901HwDyX1wLhB7K0vSuEPK3se7fLDkiB4AM963FVsTn0Wi1M8sFwsV0z3De8GP/g==
X-Received: by 2002:a17:903:990:b0:20c:af5c:fc90 with SMTP id d9443c01a7336-20fa9ea36bcmr103634535ad.49.1729807237532;
        Thu, 24 Oct 2024 15:00:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20e7eee6538sm76716495ad.47.2024.10.24.15.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 15:00:37 -0700 (PDT)
Message-ID: <1117c5c4-88b7-45f5-a0c2-100dad801444@kernel.dk>
Date: Thu, 24 Oct 2024 16:00:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
From: Jens Axboe <axboe@kernel.dk>
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org
References: <20241024170829.1266002-1-axboe@kernel.dk>
 <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
 <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
 <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
 <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk>
 <CAG48ez2iUrx7SauNXL3wAHHr7ceEv8zGNcaAiv+u2T8_cDO7HA@mail.gmail.com>
 <a55927a1-fa68-474c-a55b-9def6197fc93@kernel.dk>
 <CAG48ez2MJDzx4e8r6AQJMVr9C8BC+-k1OoK8as0S7RD3vh8f6A@mail.gmail.com>
 <d107ca88-3dc9-4fdd-8f19-235fdfaa6529@kernel.dk>
Content-Language: en-US
In-Reply-To: <d107ca88-3dc9-4fdd-8f19-235fdfaa6529@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 3:08 PM, Jens Axboe wrote:
> On 10/24/24 2:32 PM, Jann Horn wrote:
>> On Thu, Oct 24, 2024 at 10:25?PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 10/24/24 2:08 PM, Jann Horn wrote:
>>>> On Thu, Oct 24, 2024 at 9:59?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>> On 10/24/24 1:53 PM, Jann Horn wrote:
>>>>>> On Thu, Oct 24, 2024 at 9:50?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>> On 10/24/24 12:13 PM, Jann Horn wrote:
>>>>>>>> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
>>>>>>>>> the existing rings. It takes a struct io_uring_params argument, the same
>>>>>>>>> one which is used to setup the ring initially, and resizes rings
>>>>>>>>> according to the sizes given.
>>>>>>>> [...]
>>>>>>>>> +        * We'll do the swap. Clear out existing mappings to prevent mmap
>>>>>>>>> +        * from seeing them, as we'll unmap them. Any attempt to mmap existing
>>>>>>>>> +        * rings beyond this point will fail. Not that it could proceed at this
>>>>>>>>> +        * point anyway, as we'll hold the mmap_sem until we've done the swap.
>>>>>>>>> +        * Likewise, hold the completion * lock over the duration of the actual
>>>>>>>>> +        * swap.
>>>>>>>>> +        */
>>>>>>>>> +       mmap_write_lock(current->mm);
>>>>>>>>
>>>>>>>> Why does the mmap lock for current->mm suffice here? I see nothing in
>>>>>>>> io_uring_mmap() that limits mmap() to tasks with the same mm_struct.
>>>>>>>
>>>>>>> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
>>>>>>> understanding. Obviously if it doesn't, then yeah this won't be enough.
>>>>>>> Checked, and it does.
>>>>>>>
>>>>>>> Ah I see what you mean now, task with different mm. But how would that
>>>>>>> come about? The io_uring fd is CLOEXEC, and it can't get passed.
>>>>>>
>>>>>> Yeah, that's what I meant, tasks with different mm. I think there are
>>>>>> a few ways to get the io_uring fd into a different task, the ones I
>>>>>> can immediately think of:
>>>>>>
>>>>>>  - O_CLOEXEC only applies on execve(), fork() should still inherit the fd
>>>>>>  - O_CLOEXEC can be cleared via fcntl()
>>>>>>  - you can use clone() to create two tasks that share FD tables
>>>>>> without sharing an mm
>>>>>
>>>>> OK good catch, yes then it won't be enough. Might just make sense to
>>>>> exclude mmap separately, then. Thanks, I'll work on that for v4!
>>>>
>>>> Yeah, that sounds reasonable to me.
>>>
>>> Something like this should do it, it's really just replacing mmap_sem
>>> with a ring private lock. And since the ordering already had to deal
>>> with uring_lock vs mmap_sem ABBA issues, this should slot straight in as
>>> well.
>>
>> Looks good to me at a glance.
> 
> Great, thanks for checking Jann. In the first place as well, appreciate
> it.
> 
> FWIW, compiled and ran through the testing, looks fine so far here.

And also fwiw, I did write a test case for this, and it goes boom pretty
quickly without the patch, no issues with the patch. Sample output:

==================================================================
BUG: KASAN: slab-use-after-free in vm_insert_pages+0x634/0x73c
Read of size 8 at addr ffff0000d8a264e0 by task resize-rings.t/741

CPU: 5 UID: 1000 PID: 741 Comm: resize-rings.t Not tainted 6.12.0-rc4-00082-g0935537ea92a #7661
Hardware name: linux,dummy-virt (DT)
Call trace:
 dump_backtrace.part.0+0xd0/0xe0
 show_stack+0x14/0x1c
 dump_stack_lvl+0x68/0x8c
 print_report+0x16c/0x4c8
 kasan_report+0xa0/0xe0
 __asan_report_load8_noabort+0x1c/0x24
 vm_insert_pages+0x634/0x73c
 io_uring_mmap_pages+0x1d4/0x2d8
 io_uring_mmap+0x19c/0x1c0
 mmap_region+0x844/0x19e0
 do_mmap+0x5f4/0xb00
 vm_mmap_pgoff+0x164/0x2a0
 ksys_mmap_pgoff+0x2a8/0x3c0
 __arm64_sys_mmap+0xc8/0x140
 invoke_syscall+0x6c/0x260
 el0_svc_common.constprop.0+0x158/0x224
 do_el0_svc+0x3c/0x5c
 el0_svc+0x44/0xb4
 el0t_64_sync_handler+0x118/0x124
 el0t_64_sync+0x168/0x16c

Allocated by task 733:
 kasan_save_stack+0x28/0x4c
 kasan_save_track+0x1c/0x40
 kasan_save_alloc_info+0x3c/0x4c
 __kasan_kmalloc+0xac/0xb0
 __kmalloc_node_noprof+0x1b4/0x3f0
 __kvmalloc_node_noprof+0x68/0x134
 io_pages_map+0x50/0x448
 io_register_resize_rings+0x484/0x1498
 __arm64_sys_io_uring_register+0x780/0x1f3c
 invoke_syscall+0x6c/0x260
 el0_svc_common.constprop.0+0x158/0x224
 do_el0_svc+0x3c/0x5c
 el0_svc+0x44/0xb4
 el0t_64_sync_handler+0x118/0x124
 el0t_64_sync+0x168/0x16c

Freed by task 733:
 kasan_save_stack+0x28/0x4c
 kasan_save_track+0x1c/0x40
 kasan_save_free_info+0x48/0x94
 __kasan_slab_free+0x48/0x60
 kfree+0x120/0x494
 kvfree+0x34/0x40
 io_pages_unmap+0x1a4/0x308
 io_register_free_rings.isra.0+0x6c/0x168
 io_register_resize_rings+0xce4/0x1498
 __arm64_sys_io_uring_register+0x780/0x1f3c
 invoke_syscall+0x6c/0x260
 el0_svc_common.constprop.0+0x158/0x224
 do_el0_svc+0x3c/0x5c
 el0_svc+0x44/0xb4
 el0t_64_sync_handler+0x118/0x124
 el0t_64_sync+0x168/0x16c

The buggy address belongs to the object at ffff0000d8a264e0
 which belongs to the cache kmalloc-cg-8 of size 8
The buggy address is located 0 bytes inside of
 freed 8-byte region [ffff0000d8a264e0, ffff0000d8a264e8)

-- 
Jens Axboe

