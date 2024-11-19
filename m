Return-Path: <io-uring+bounces-4848-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 630D89D301F
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 22:46:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B1CF8B2328D
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 21:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EDF1482F3;
	Tue, 19 Nov 2024 21:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGheTNHs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896EE19CCEA
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 21:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732052811; cv=none; b=rXIGM7yzLegzai0cQpC1SspzE36nCHm8lqnQ7B6bre/cL5mWdE7biXmkD/0ZKUQOwfY/k06IekCNP43+MxlfffwhWqCQuS+KegXS28YieFSVNcsRF+SO0TCRVkeZ/uNPdqN56keWzHuOygwmjleNvUKC2u5Hugp8KogYIJTYGH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732052811; c=relaxed/simple;
	bh=gll+lJt0XzcLWcLlBzf+PX0RlPfgcty82FI2MsYcH+c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TDSJOM2G8Tt7cNJYL4XzL/7tC3QZZ+RUSfOyfqtb2NH5QAAVLSCiyuYUDkBaVEx1CubvXeWELIE7JIG1i6xVYnl8ZWtwxcxEw4i0aDgpbHC2NmpuSDwSPxv872+vmhZAI17JD2qIpvnWeGlRg0v41r/zCRl2bMpxiHmQFULgDfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGheTNHs; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2118dfe6042so45883805ad.2
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 13:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732052809; x=1732657609; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=8x6GMloqm6ao99cti3TsTHoJaoxyVToI7uPv9Gqmopo=;
        b=OGheTNHs/NoIg399lYIwdiyPqAzWGo2zYbS5f1H1WO4CarnrgrkTeq1V5VilhI37ua
         rQky/j0PpBeRoCKa+2xTjTzrwv6aPS+s8wDb5KhRB5zQON+rpotivLGK5TigbmbFFQTf
         3rF+cpWIK8hLir92ajUDbLru64EYBPSkEYji32wmWw3Om2x5Jwm8pG9k97U1CJqSKqv7
         K7zSGgJ3k+7+a1YMtwHnIKdgJHx/m0Y+qMjsQ8BLslSRwb/RTgogtNaqP3lscORpvRbw
         bQ04Q59N/s6HGik798FlHmy+yIDBdsBgh1DqtuE2y6BF8oHoIUk4DE7TV3PIPl+08u21
         yBEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732052809; x=1732657609;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8x6GMloqm6ao99cti3TsTHoJaoxyVToI7uPv9Gqmopo=;
        b=a/TI4aUwHGEQd1mI9otyUh6J0pxc3H2fQwJZj0Rz45z6/wej/RD8Wrt1nPP5bKMb/v
         xObbcxDVS40OCoftVoVMf9Au6rbXRdvP2CtzGN56ZTrgzHoUzwCS0Nhr1j8W+lo63DJw
         2FcXhhLxJmE759DNBIIsbhRJZXgd1JiF96YrOD11ezxMNEoaDdiEkFqdtHzapYW+Hdhj
         gMiq69/NcmpSrWgfc2QDJBVS2VSkjUVmRYZqj1vN+D3Sowy81ecde9t1qJNMJ+7FNImM
         be6zHQBhGEg+TQMIRM2Vine7pD7H7sghmtUzoCEaso1WqPGQWsP3prYAOnPouKu5v/O9
         f2sg==
X-Gm-Message-State: AOJu0Yy98ileu2NUOMI7SwF300d/NDz7q/Z5WuunWjlEPseVuel3HxDR
	ewUbzXM8/u2Ii+h8YjwGJ2bS/TEQLQVhBZ2YG/jdme2PdWiDYogKQ2Q0bQ==
X-Google-Smtp-Source: AGHT+IGArdhxZexRtFP8E6s1yhn/wjR/9k6EG5VXtNWaf42InBjEBYVldx4LOsOKBBAUWWw16Ogmew==
X-Received: by 2002:a17:902:d501:b0:211:ff13:8652 with SMTP id d9443c01a7336-2126cac20c1mr986665ad.28.1732052808628;
        Tue, 19 Nov 2024 13:46:48 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-211d0f35143sm78578575ad.148.2024.11.19.13.46.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 13:46:48 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <47a16a83-52c7-4779-9ed3-f16ea547b9f0@roeck-us.net>
Date: Tue, 19 Nov 2024 13:46:46 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: io-uring@vger.kernel.org, linux-m68k <linux-m68k@lists.linux-m68k.org>
References: <20241029152249.667290-1-axboe@kernel.dk>
 <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net>
 <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
 <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
 <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
 <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
 <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk>
 <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
 <358710e8-a826-46df-9846-5a9e0f7c6851@kernel.dk>
 <CAMuHMdUsj9FsX=_rHwYjiXT8RehP6HW5hUL9LMvE0pt7Z8kc8w@mail.gmail.com>
 <82b97543-ad01-4e42-b79c-12d97c1df194@kernel.dk>
 <4623f30c-a12e-4ba6-ad99-835764611c67@kernel.dk>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <4623f30c-a12e-4ba6-ad99-835764611c67@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 11:49, Jens Axboe wrote:
> On 11/19/24 12:44 PM, Jens Axboe wrote:
>> On 11/19/24 12:41 PM, Geert Uytterhoeven wrote:
>>> Hi Jens,
>>>
>>> On Tue, Nov 19, 2024 at 8:30?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 11/19/24 12:25 PM, Geert Uytterhoeven wrote:
>>>>> On Tue, Nov 19, 2024 at 8:10?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
>>>>>>> On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
>>>>>>>>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wrote:
>>>>>>>>>> On 11/19/24 08:02, Jens Axboe wrote:
>>>>>>>>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
>>>>>>>>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
>>>>>>>>>>>>> Doesn't matter right now as there's still some bytes left for it, but
>>>>>>>>>>>>> let's prepare for the io_kiocb potentially growing and add a specific
>>>>>>>>>>>>> freeptr offset for it.
>>>>>>>>>>>>>
>>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>>>>>>>>>
>>>>>>>>>>>> This patch triggers:
>>>>>>>>>>>>
>>>>>>>>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create slab 'io_kiocb'. Error -22
>>>>>>>>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f238aa69d #1
>>>>>>>>>>>> Stack from 00c63e5c:
>>>>>>>>>>>>           00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9044 00612c1c
>>>>>>>>>>>>           004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffea 00797244
>>>>>>>>>>>>           00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a5 00c614a0
>>>>>>>>>>>>           004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b6 00c63ef4
>>>>>>>>>>>>           00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000010 00000004
>>>>>>>>>>>>           00000038 0000009a 01000000 00000000 00000000 00000000 000020e0 0076f23e
>>>>>>>>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
>>>>>>>>>>>>    [<004ae21e>] panic+0xc4/0x252
>>>>>>>>>>>>    [<000c6974>] __kmem_cache_create_args+0x216/0x26c
>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
>>>>>>>>>>>>    [<000c675e>] __kmem_cache_create_args+0x0/0x26c
>>>>>>>>>>>>    [<004adb58>] memset+0x0/0x8c
>>>>>>>>>>>>    [<0076f28a>] io_uring_init+0x4c/0xca
>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>>>>>    [<000020e0>] do_one_initcall+0x32/0x192
>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>>>>>    [<0000211c>] do_one_initcall+0x6e/0x192
>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
>>>>>>>>>>>>    [<000020ae>] do_one_initcall+0x0/0x192
>>>>>>>>>>>>    [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
>>>>>>>>>>>>    [<004b912e>] kernel_init+0x14/0xec
>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
>>>>>>>>>>>>    [<0000252c>] ret_from_kernel_thread+0xc/0x14
>>>>>>>>>>>>
>>>>>>>>>>>> when trying to boot the m68k:q800 machine in qemu.
>>>>>>>>>>>>
>>>>>>>>>>>> An added debug message in create_cache() shows the reason:
>>>>>>>>>>>>
>>>>>>>>>>>> #### freeptr_offset=154 object_size=182 flags=0x310 aligned=0 sizeof(freeptr_t)=4
>>>>>>>>>>>>
>>>>>>>>>>>> freeptr_offset would need to be 4-byte aligned but that is not the
>>>>>>>>>>>> case on m68k.
>>>>>>>>>>>
>>>>>>>>>>> Why is ->work 2-byte aligned to begin with on m68k?!
>>>>>>>>>>
>>>>>>>>>> My understanding is that m68k does not align pointers.
>>>>>>>>>
>>>>>>>>> The minimum alignment for multi-byte integral values on m68k is
>>>>>>>>> 2 bytes.
>>>>>>>>>
>>>>>>>>> See also the comment at
>>>>>>>>> https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L46
>>>>>>>>
>>>>>>>> Maybe it's time we put m68k to bed? :-)
>>>>>>>>
>>>>>>>> We can add a forced alignment ->work to be 4 bytes, won't change
>>>>>>>> anything on anything remotely current. But does feel pretty hacky to
>>>>>>>> need to align based on some ancient thing.
>>>>>>>
>>>>>>> Why does freeptr_offset need to be 4-byte aligned?
>>>>>>
>>>>>> Didn't check, but it's slab/slub complaining using a 2-byte aligned
>>>>>> address for the free pointer offset. It's explicitly checking:
>>>>>>
>>>>>>          /* If a custom freelist pointer is requested make sure it's sane. */
>>>>>>          err = -EINVAL;
>>>>>>          if (args->use_freeptr_offset &&
>>>>>>              (args->freeptr_offset >= object_size ||
>>>>>>               !(flags & SLAB_TYPESAFE_BY_RCU) ||
>>>>>>               !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>>>>>>                  goto out;
>>>>>
>>>>> It is not guaranteed that alignof(freeptr_t) >= sizeof(freeptr_t)
>>>>> (free_ptr is sort of a long). If freeptr_offset must be a multiple of
>>>>> 4 or 8 bytes,
>>>>> the code that assigns it must make sure that is true.
>>>>
>>>> Right, this is what the email is about...
>>>>
>>>>> I guess this is the code in fs/file_table.c:
>>>>>
>>>>>      .freeptr_offset = offsetof(struct file, f_freeptr),
>>>>>
>>>>> which references:
>>>>>
>>>>>      include/linux/fs.h:           freeptr_t               f_freeptr;
>>>>>
>>>>> I guess the simplest solution is to add an __aligned(sizeof(freeptr_t))
>>>>> (or __aligned(sizeof(long)) to the definition of freeptr_t:
>>>>>
>>>>>      include/linux/slab.h:typedef struct { unsigned long v; } freeptr_t;
>>>>
>>>> It's not, it's struct io_kiocb->work, as per the stack trace in this
>>>> email.
>>>
>>> Sorry, I was falling out of thin air into this thread...
>>>
>>> linux-next/master:io_uring/io_uring.c:          .freeptr_offset =
>>> offsetof(struct io_kiocb, work),
>>> linux-next/master:io_uring/io_uring.c:          .use_freeptr_offset = true,
>>>
>>> Apparently io_kiocb.work is of type struct io_wq_work, not freeptr_t?
>>> Isn't that a bit error-prone, as the slab core code expects a freeptr_t?
>>
>> It just needs the space, should not matter otherwise. But may as well
>> just add the union and align the freeptr so it stop complaining on m68k.
> 
> Ala the below, perhaps alignment takes care of itself then?
> 

No, that doesn't work (I tried), at least not on its own, because the pointer
is still unaligned on m68k.

Guenter

> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 593c10a02144..a83ec7f7849d 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -674,7 +674,11 @@ struct io_kiocb {
>   	struct io_kiocb			*link;
>   	/* custom credentials, valid IFF REQ_F_CREDS is set */
>   	const struct cred		*creds;
> -	struct io_wq_work		work;
> +
> +	union {
> +		struct io_wq_work	work;
> +		freeptr_t		freeptr;
> +	};
>   
>   	struct {
>   		u64			extra1;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 73af59863300..86ac7df2a601 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3812,7 +3812,7 @@ static int __init io_uring_init(void)
>   	struct kmem_cache_args kmem_args = {
>   		.useroffset = offsetof(struct io_kiocb, cmd.data),
>   		.usersize = sizeof_field(struct io_kiocb, cmd.data),
> -		.freeptr_offset = offsetof(struct io_kiocb, work),
> +		.freeptr_offset = offsetof(struct io_kiocb, freeptr),
>   		.use_freeptr_offset = true,
>   	};
>   
> 


