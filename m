Return-Path: <io-uring+bounces-2982-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BBE3A9662FC
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 15:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0A021C21EFC
	for <lists+io-uring@lfdr.de>; Fri, 30 Aug 2024 13:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BAE61AD9FC;
	Fri, 30 Aug 2024 13:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QlnQdefH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842AB1AD5D9
	for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 13:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725024807; cv=none; b=BRtOxf1Fp6aTVZ+/1X9ztI1EwJswbR0wqUXXs7QoyuiUyBih1Rk0Es3yznn1Y0IpUpvATjP95/0Kr/Ik8lEiu5dScXddOAv0RCeRapMittjEA/rHvoB3K6J1K0+tQZRaWf7dDYP/+uv/ISY1bT3fviZ/VcahmzCAgAfTz4qH6Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725024807; c=relaxed/simple;
	bh=0jVFYzBH9Hdz61Rn549YKK6jieADES5owZKhcJMx/6Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TGweu+kizkDfXnU90+LkY6LSd3owsPsZR+X3zidt7EthQu919Vw5VG6OlSKCI5nIc7iALDBJ7Z8ixPptXHVCDBHJQt5//gUP15AoUZKqcojBxNuN+LyTBBKyzseb0TiN8GzKbN20f6XgDBXwGucedJl3tMPUNZzs6UmmwzBVDC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QlnQdefH; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-82a24deca03so38267739f.0
        for <io-uring@vger.kernel.org>; Fri, 30 Aug 2024 06:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725024803; x=1725629603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KEnpMpTM6G1CN+8e+lzCtFBJLDVYfIcnOQr5ol3rSBY=;
        b=QlnQdefHyTf67I2l/QVuHOjHvkSO2LOgmnjO7xDwaLYengSYvG7/b5vkiquEsHKVq7
         BX8DWYp0x66eGppZEOl0LqsX16mW2x34X0EilmQGkDjUAha0H/g0tzyn2/tqrjbALdZG
         d/vlbbYTn7sJux2K73mG3HPPwZ3HjQP5b1y9YU0lT7PDdZ8PRGzYDtZ9ut8hrzfZAXfo
         OReF9smkA1RI/ZOQNNtxSuTaQAl4xiA/C1YnDUYkTv3u2DEswW/1oqd6NE1oYng9oxnT
         Zmyx0Cr7gL3Ko34o2KShSw+CDFeyb0asohjfrv9j8+VntwSW0Bh4Ig79f/N9sXwa2w9T
         jGzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725024803; x=1725629603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KEnpMpTM6G1CN+8e+lzCtFBJLDVYfIcnOQr5ol3rSBY=;
        b=SHApI/St30cf0COSr6PdaHgBuZ6pe+mP9hKzXgTqxxgNmiiAU4qicv+ZeZWG8gBK9+
         iVlaXTkEuQBprH0yFQbYmVlpUNXB4q3pUDdH3KP5O4f8HCWMjNWKwf4Kygpq7vbT+Ijy
         iPVkNyOkNK2iAhuWOomP5JjQL8qQineotIWUmPlzkqi9ra+DTihERHJo9TlB746J2s9b
         X5YW03YxWL19Cm/4kHP/EgPMYP9zAWvfNOwSERBFZe+p3XCbxrcWkcd5NlY0qm0MfP9Y
         QlC0aCPAFgxbjLXpO+xj9gZCc2OQ27QO/kmhUs6CC+reYU78UZZvAOdaf7H0E48q8l6K
         P7SA==
X-Forwarded-Encrypted: i=1; AJvYcCU5nPECu+EXZuqlcx95chjy/ndmE6/HCIrNYXly6veTzZ2/CB+TlXrQNours+ZZZ79Pn8UP7tPYGw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/dzDzLLMx80VM/kdqmlsn7ulFwOJweqSc12ueTffnG0ihi4s5
	O7nitOcF80aqnht2hvF28eSezdCygyZPG2Hm/mni/08p5BKhhO9naWlnl6WdJJY=
X-Google-Smtp-Source: AGHT+IHzMPfqUHOnEpSQY6wr4omk8okeRBDPm8PK2zVH1oLsXh2w+rcIi988+fGRfFdIWjMn7+8sNQ==
X-Received: by 2002:a05:6602:6d17:b0:82a:2cd4:a788 with SMTP id ca18e2360f4ac-82a2cd4add5mr116095639f.15.1725024803545;
        Fri, 30 Aug 2024 06:33:23 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ced2ead2d6sm743421173.146.2024.08.30.06.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Aug 2024 06:33:23 -0700 (PDT)
Message-ID: <3ca0e7d1-bb86-4963-aab7-6fc24950fe84@kernel.dk>
Date: Fri, 30 Aug 2024 07:33:22 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 00/19] fuse: fuse-over-io-uring
To: Bernd Schubert <bschubert@ddn.com>,
 Bernd Schubert <bernd.schubert@fastmail.fm>,
 Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Josef Bacik <josef@toxicpanda.com>, Joanne Koong <joannelkoong@gmail.com>
References: <20240529-fuse-uring-for-6-9-rfc2-out-v1-0-d149476b1d65@ddn.com>
 <CAJfpegurSNV3Tw1oKWL1DgnR-tST-JxSAxvTuK2jirm+L-odeQ@mail.gmail.com>
 <99d13ae4-8250-4308-b86d-14abd1de2867@fastmail.fm>
 <CAJfpegu7VwDEBsUG_ERLsN58msXUC14jcxRT_FqL53xm8FKcdg@mail.gmail.com>
 <62ecc4cf-97c8-43e6-84a1-72feddf07d29@fastmail.fm>
 <CAJfpegsq06UZSPCDB=0Q3OPoH+c3is4A_d2oFven3Ebou8XPOw@mail.gmail.com>
 <0615e79d-9397-48eb-b89e-f0be1d814baf@ddn.com>
 <CAJfpeguMmTXJPzdnxe87hSBPO_Y8s33eCc_H5fEaznZYC-D8HA@mail.gmail.com>
 <3b74f850-c74c-49d0-be63-a806119cbfbd@ddn.com>
 <7d42edd3-3e3b-452b-b3bf-fb8179858e48@fastmail.fm>
 <093a3498-5558-4c65-84b0-2a046c1db72e@kernel.dk>
 <f5d10363-9ba0-4a1a-8aed-cad7adf59cd4@ddn.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <f5d10363-9ba0-4a1a-8aed-cad7adf59cd4@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/30/24 7:28 AM, Bernd Schubert wrote:
> On 8/30/24 15:12, Jens Axboe wrote:
>> On 8/29/24 4:32 PM, Bernd Schubert wrote:
>>> Wanted to send out a new series today, 
>>>
>>> https://github.com/bsbernd/linux/tree/fuse-uring-for-6.10-rfc3-without-mmap
>>>
>>> but then just noticed a tear down issue.
>>>
>>>  1525.905504] KASAN: null-ptr-deref in range [0x00000000000001a0-0x00000000000001a7]
>>> [ 1525.910431] CPU: 15 PID: 183 Comm: kworker/15:1 Tainted: G           O       6.10.0+ #48
>>> [ 1525.916449] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
>>> [ 1525.922470] Workqueue: events io_fallback_req_func
>>> [ 1525.925840] RIP: 0010:__lock_acquire+0x74/0x7b80
>>> [ 1525.929010] Code: 89 bc 24 80 00 00 00 0f 85 1c 5f 00 00 83 3d 6e 80 b0 02 00 0f 84 1d 12 00 00 83 3d 65 c7 67 02 00 74 27 48 89 f8 48 c1 e8 03 <42> 80 3c 30 00 74 0d e8 50 44 42 00 48 8b bc 24 80 00 00 00 48 c7
>>> [ 1525.942211] RSP: 0018:ffff88810b2af490 EFLAGS: 00010002
>>> [ 1525.945672] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 0000000000000001
>>> [ 1525.950421] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000001a0
>>> [ 1525.955200] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
>>> [ 1525.959979] R10: dffffc0000000000 R11: fffffbfff07b1cbe R12: 0000000000000000
>>> [ 1525.964252] R13: 0000000000000001 R14: dffffc0000000000 R15: 0000000000000001
>>> [ 1525.968225] FS:  0000000000000000(0000) GS:ffff88875b200000(0000) knlGS:0000000000000000
>>> [ 1525.973932] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> [ 1525.976694] CR2: 00005555b6a381f0 CR3: 000000012f5f1000 CR4: 00000000000006f0
>>> [ 1525.980030] Call Trace:
>>> [ 1525.981371]  <TASK>
>>> [ 1525.982567]  ? __die_body+0x66/0xb0
>>> [ 1525.984376]  ? die_addr+0xc1/0x100
>>> [ 1525.986111]  ? exc_general_protection+0x1c6/0x330
>>> [ 1525.988401]  ? asm_exc_general_protection+0x22/0x30
>>> [ 1525.990864]  ? __lock_acquire+0x74/0x7b80
>>> [ 1525.992901]  ? mark_lock+0x9f/0x360
>>> [ 1525.994635]  ? __lock_acquire+0x1420/0x7b80
>>> [ 1525.996629]  ? attach_entity_load_avg+0x47d/0x550
>>> [ 1525.998765]  ? hlock_conflict+0x5a/0x1f0
>>> [ 1526.000515]  ? __bfs+0x2dc/0x5a0
>>> [ 1526.001993]  lock_acquire+0x1fb/0x3d0
>>> [ 1526.004727]  ? gup_fast_fallback+0x13f/0x1d80
>>> [ 1526.006586]  ? gup_fast_fallback+0x13f/0x1d80
>>> [ 1526.008412]  gup_fast_fallback+0x158/0x1d80
>>> [ 1526.010170]  ? gup_fast_fallback+0x13f/0x1d80
>>> [ 1526.011999]  ? __lock_acquire+0x2b07/0x7b80
>>> [ 1526.013793]  __iov_iter_get_pages_alloc+0x36e/0x980
>>> [ 1526.015876]  ? do_raw_spin_unlock+0x5a/0x8a0
>>> [ 1526.017734]  iov_iter_get_pages2+0x56/0x70
>>> [ 1526.019491]  fuse_copy_fill+0x48e/0x980 [fuse]
>>> [ 1526.021400]  fuse_copy_args+0x174/0x6a0 [fuse]
>>> [ 1526.023199]  fuse_uring_prepare_send+0x319/0x6c0 [fuse]
>>> [ 1526.025178]  fuse_uring_send_req_in_task+0x42/0x100 [fuse]
>>> [ 1526.027163]  io_fallback_req_func+0xb4/0x170
>>> [ 1526.028737]  ? process_scheduled_works+0x75b/0x1160
>>> [ 1526.030445]  process_scheduled_works+0x85c/0x1160
>>> [ 1526.032073]  worker_thread+0x8ba/0xce0
>>> [ 1526.033388]  kthread+0x23e/0x2b0
>>> [ 1526.035404]  ? pr_cont_work_flush+0x290/0x290
>>> [ 1526.036958]  ? kthread_blkcg+0xa0/0xa0
>>> [ 1526.038321]  ret_from_fork+0x30/0x60
>>> [ 1526.039600]  ? kthread_blkcg+0xa0/0xa0
>>> [ 1526.040942]  ret_from_fork_asm+0x11/0x20
>>> [ 1526.042353]  </TASK>
>>>
>>>
>>> We probably need to call iov_iter_get_pages2() immediately
>>> on submitting the buffer from fuse server and not only when needed.
>>> I had planned to do that as optimization later on, I think
>>> it is also needed to avoid io_uring_cmd_complete_in_task().
>>
>> I think you do, but it's not really what's wrong here - fallback work is
>> being invoked as the ring is being torn down, either directly or because
>> the task is exiting. Your task_work should check if this is the case,
>> and just do -ECANCELED for this case rather than attempt to execute the
>> work. Most task_work doesn't do much outside of post a completion, but
>> yours seems complex in that attempts to map pages as well, for example.
>> In any case, regardless of whether you move the gup to the actual issue
>> side of things (which I think you should), then you'd want something
>> ala:
>>
>> if (req->task != current)
>> 	don't issue, -ECANCELED
>>
>> in your task_work.
> 
> Thanks a lot for your help Jens! I'm a bit confused, doesn't this belong 
> into __io_uring_cmd_do_in_task then? Because my task_work_cb function 
> (passed to io_uring_cmd_complete_in_task) doesn't even have the request.

Yeah it probably does, the uring_cmd case is a bit special is that it's
a set of helpers around task_work that can be consumed by eg fuse and
ublk. The existing users don't really do anything complicated on that
side, hence there's no real need to check. But since the ring/task is
going away, we should be able to generically do it in the helpers like
you did below.

> I'm going to test this in a bit
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 21ac5fb2d5f0..c06b9fcff48f 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -120,6 +120,11 @@ static void io_uring_cmd_work(struct io_kiocb *req, struct io_tw_state *ts)
>  {
>         struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
>  
> +       if (req->task != current) {
> +               /* don't issue, -ECANCELED */
> +               return;
> +       }
> +
>         /* task_work executor checks the deffered list completion */
>         ioucmd->task_work_cb(ioucmd, IO_URING_F_COMPLETE_DEFER);
>  }
> 
> 
> 
>>
>>> The part I don't like here is that with mmap we had a complex
>>> initialization - but then either it worked or did not. No exceptions
>>> at IO time. And run time was just a copy into the buffer. 
>>> Without mmap initialization is much simpler, but now complexity shifts
>>> to IO time.
>>
>> I'll take a look at your code. But I'd say just fix the missing check
>> above and send out what you have, it's much easier to iterate on the
>> list rather than poking at patches in some git branch somewhere.
>>
> 
> I'm almost through updating it, will send something out definitely
> today. I will just keep the last patch that pins user buffer pages on
> top of the series - will avoid all the rebasing.

Excellent! Would be great if you can include how to test it as well, as
then I can give it a spin as well and test any potential code changes
proposed.

-- 
Jens Axboe


