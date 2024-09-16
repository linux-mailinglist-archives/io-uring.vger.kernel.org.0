Return-Path: <io-uring+bounces-3199-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C7518979E0F
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 11:12:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4C1641F24F30
	for <lists+io-uring@lfdr.de>; Mon, 16 Sep 2024 09:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F961494A9;
	Mon, 16 Sep 2024 09:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FQPrb4TJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A00618C1F
	for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 09:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726477939; cv=none; b=utHi1x7L6BeQXq87hInQzZsZMJb8zm1fp+L/wEYXdiqKxrZOHaj6TdP8Rl7h9m5mXLjdeIjzCcygFONgbIVzmtKyzYIvL0lTwmUP8Ca1MTGvkemrd0D/mUDmDJCpJCpZPl2rE3fHHVLxeMbUk62qCP/BR2I0qs/UNWvZcTI0aok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726477939; c=relaxed/simple;
	bh=+Ey4HbaQUyfqR62z7briPvM1EDk21SkWncd+Pk1RliU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tPURwWjLeZwIINmPD2XdDkCIUhMnF0AAoYI5wZ1MbZX6FOZDHLi95+9eDj/7TYVcjNpXPWhyXvidsbonaF3wXOa5/b8TTiA6zTno/62wnT1KwIQqY+5sTM5cc5RqglN4X2oW6b4GGXR0owweAE4jPRCidDnR9c6r8HvSD330ClQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FQPrb4TJ; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-710d5d9aac1so1462385a34.3
        for <io-uring@vger.kernel.org>; Mon, 16 Sep 2024 02:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726477936; x=1727082736; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JPqdtapiW8Z+9KhRX5zapFawAeR5tCAxv1xTspJbZxM=;
        b=FQPrb4TJx368ozcIyXSlDFLTRaMF6FPTjmy4+5yQy9r3FYGrv+hJXeXgjB7tw8I0t+
         iZWhjttqBxnwh3lr03c7I8VoO2iaVxam0o5OPsQZbiqilwpOjMo+wd991XFGgRfalDRb
         YlHtFRiLVNat3b3Pd7x3R9e3cwcw1Ixl5DbcqN9cR61vPrFVRioSn3GF25COErlh2jkX
         0jP1m6iLE5V/BRSRU1JJwXAVc4LzvULA60kkHAd4JZH/+24VK+R0tmh1Mr5TauOxNx8R
         s6IczTAowNdZk3TCv8UfQ1jLXEtNGL5Qw38PSKJEBC6s5xHbp05+hmixW4WTLvvdOh7I
         gS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726477936; x=1727082736;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPqdtapiW8Z+9KhRX5zapFawAeR5tCAxv1xTspJbZxM=;
        b=lxoZgVmZInFJ6we9Gpx0dg7eHrUY9CEGa4wkv6JO5xYoRlgnjcsYSfd+A8JpXCF/xp
         Y+JAXaR/cxom4gOxRnJSx+h0GcAaFZ1jHDCXaiZ5ZfVPO5SZlTvsVaqy9z/b0EOZbtwT
         /BCEDxS4BnSxeEyuRNtmUyz2NpJ5HLii6CCTRZQ50IbvtHZiUb1sMaIKqZh5zMaPueOe
         yvJ6EDNJ1/SV9qJhPSndUR5ILHst+sJejqlWjuNuvVlWo+k9zNftrFkDyhrYJSsKV68/
         Ux+ywS7dNOmq80P3QUo/BZdR6LoymOIz77HbwNiYr+leqkgk5kUNDpp1rJ/4xhXPRVdv
         ojyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWbXlNK1bcQ+Odti8pzV0WTS0VTHrQ03zuK+m8kfhGZActLAYN3kfObUcodSOzxlkZVgnNNQlHhXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzMJ3EnlDbIGx3fOmwjW6VmD7I56RavxY2Q/GPw7twXl3Pz97bv
	JuxvlpeFGi0liLAj0uS0gPd1B7ylMmixdOhgWLRbj+zWGPLXEJfWw9XFWhhG2lDcXKh7vEQ0rjN
	RO2arAQ==
X-Google-Smtp-Source: AGHT+IGkz2Y4Qjldz2mPu3bfWi2F+QzrkmtUouoBcLI8B7dVVU0qAiHOVO4Mzc1MypdMhTb+HattaQ==
X-Received: by 2002:a05:6830:f94:b0:710:f4d5:4919 with SMTP id 46e09a7af769-7110951b1ffmr8761429a34.9.1726477936328;
        Mon, 16 Sep 2024 02:12:16 -0700 (PDT)
Received: from ?IPV6:2600:380:6345:6937:6815:e2a7:e82c:fd22? ([2600:380:6345:6937:6815:e2a7:e82c:fd22])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-71239e9d5cfsm1027932a34.19.2024.09.16.02.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Sep 2024 02:12:15 -0700 (PDT)
Message-ID: <eb406d03-d2a0-4352-8d32-4f390599eb52@kernel.dk>
Date: Mon, 16 Sep 2024 03:12:13 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/sqpoll: retain test for whether the CPU is valid
To: "MOESSBAUER, Felix" <felix.moessbauer@siemens.com>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <36b09a00-9f72-4ef2-8f73-79b2ba99b11c@kernel.dk>
 <6c5bf2c20fb540ec3e3790f67b1f728f24d552ee.camel@siemens.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6c5bf2c20fb540ec3e3790f67b1f728f24d552ee.camel@siemens.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/16/24 3:11 AM, MOESSBAUER, Felix wrote:
> On Mon, 2024-09-16 at 03:07 -0600, Jens Axboe wrote:
>> A recent commit ensured that SQPOLL cannot be setup with a CPU that
>> isn't in the current tasks cpuset, but it also dropped testing
>> whether
>> the CPU is valid in the first place. Without that, if a task passes
>> in
>> a CPU value that is too high, the following KASAN splat can get
>> triggered:
>>
>> BUG: KASAN: stack-out-of-bounds in io_sq_offload_create+0x858/0xaa4
>> Read of size 8 at addr ffff800089bc7b90 by task wq-aff.t/1391
>>
>> CPU: 4 UID: 1000 PID: 1391 Comm: wq-aff.t Not tainted 6.11.0-rc7-
>> 00227-g371c468f4db6 #7080
>> Hardware name: linux,dummy-virt (DT)
>> Call trace:
>>  dump_backtrace.part.0+0xcc/0xe0
>>  show_stack+0x14/0x1c
>>  dump_stack_lvl+0x58/0x74
>>  print_report+0x16c/0x4c8
>>  kasan_report+0x9c/0xe4
>>  __asan_report_load8_noabort+0x1c/0x24
>>  io_sq_offload_create+0x858/0xaa4
>>  io_uring_setup+0x1394/0x17c4
>>  __arm64_sys_io_uring_setup+0x6c/0x180
>>  invoke_syscall+0x6c/0x260
>>  el0_svc_common.constprop.0+0x158/0x224
>>  do_el0_svc+0x3c/0x5c
>>  el0_svc+0x34/0x70
>>  el0t_64_sync_handler+0x118/0x124
>>  el0t_64_sync+0x168/0x16c
>>
>> The buggy address belongs to stack of task wq-aff.t/1391
>>  and is located at offset 48 in frame:
>>  io_sq_offload_create+0x0/0xaa4
>>
>> This frame has 1 object:
>>  [32, 40) 'allowed_mask'
>>
>> The buggy address belongs to the virtual mapping at
>>  [ffff800089bc0000, ffff800089bc9000) created by:
>>  kernel_clone+0x124/0x7e0
>>
>> The buggy address belongs to the physical page:
>> page: refcount:1 mapcount:0 mapping:0000000000000000
>> index:0xffff0000d740af80 pfn:0x11740a
>> memcg:ffff0000c2706f02
>> flags: 0xbffe00000000000(node=0|zone=2|lastcpupid=0x1fff)
>> raw: 0bffe00000000000 0000000000000000 dead000000000122
>> 0000000000000000
>> raw: ffff0000d740af80 0000000000000000 00000001ffffffff
>> ffff0000c2706f02
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff800089bc7a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>  ffff800089bc7b00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>>> ffff800089bc7b80: 00 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
>>                          ^
>>  ffff800089bc7c00: 00 00 00 00 00 00 00 00 00 00 00 00 f1 f1 f1 f1
>>  ffff800089bc7c80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f3
>>
>> Reported-by: kernel test robot <oliver.sang@intel.com>
>> Closes:
>> https://lore.kernel.org/oe-lkp/202409161632.cbeeca0d-lkp@intel.com
>> Fixes: f011c9cf04c0 ("io_uring/sqpoll: do not allow pinning outside
>> of cpuset")
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
>> index 272df9d00f45..7adfcf6818ff 100644
>> --- a/io_uring/sqpoll.c
>> +++ b/io_uring/sqpoll.c
>> @@ -465,6 +465,8 @@ __cold int io_sq_offload_create(struct
>> io_ring_ctx *ctx,
>>                         int cpu = p->sq_thread_cpu;
>>  
>>                         ret = -EINVAL;
>> +                       if (cpu >= nr_cpu_ids || !cpu_online(cpu))
>> +                               goto err_sqpoll;
> 
> Thanks for fixing. I'm just wondering if cpu_online is really needed,
> as offline CPUs are in the mask as well, aren't they?

Probably not, but I felt saner just returning the old check so we don't
access the cpumask variable beyond the end.

-- 
Jens Axboe

