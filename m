Return-Path: <io-uring+bounces-2777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 37CC79538CA
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 19:10:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C7297B2160C
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 17:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A55DF1B1517;
	Thu, 15 Aug 2024 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LZQQYKFo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA8221105;
	Thu, 15 Aug 2024 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723741844; cv=none; b=jQHz05Jy9CqOAc8O+1Ep9YZy08LRnXnQorXvSAs1E+qMWyiZEcXa8h7PI1U2J+fee4dsFz8ZCarHAxNBuiJK0R1m9XzNM1tNOyYE/PP3Vzvc2m0AwTP0c2I+GYoe7g4ecdSS00wjwyDYmNQHGVTKIK1KkP3TUqGJCsvnTloihXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723741844; c=relaxed/simple;
	bh=NtJVyhxihv71sabWxqHvw7hGwho1C57Fnh4pWaymN+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iuktb8HDzjva4O/QkIBQL8E9C/ZXZK4/kN0kNKiSymAYZMS41EOkV6k9aJpOjtEVsjuLAXfWVduCRebki9yHMhaHtx9TCJ3osnYJim9y+1Nf7QNkH3J7kOB0pXKodDQfc8IZ3Y3kRTm8BWds/tiRo+Sg9+P3ynCyN2vbw0R04IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LZQQYKFo; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a7a81bd549eso111622466b.3;
        Thu, 15 Aug 2024 10:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723741841; x=1724346641; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WFfhhKmG7FhdO965mMa/VXQpMbla35Yaq9l0tLryaQQ=;
        b=LZQQYKFotiiQDtQP+ZEvhVq/BwW+VQY5MQ4gZAe3pyXUKiIeh9FFRQYjaM/5GxV0HK
         GfKCnAGw9MqvTG++SUhDn5uAREU3A6hhit3v8VCwNIBjQQdrk72PYYA6r/uPJXlvQmIz
         NwWWIjdEzEw7v8OW/bgIn5Rhj9b3V53dk+th8ry2Yc9xlJODSOr4wGVtoYA9dWoeS6at
         I/8tIR8Uwu818N6e4uvCSVWHvJyNE+1Tw+v7bLZ3rxpp1d5CKWYKIB01m6SYvpfa2vRt
         YV+BC/lymTHtsk2fLNQNNWsg48fKfc6TtaB3t9ZYJ4gfGJbsU+jq+gOYReY3lvkB2zJC
         nmew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723741841; x=1724346641;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WFfhhKmG7FhdO965mMa/VXQpMbla35Yaq9l0tLryaQQ=;
        b=oV11wahGdhl7bzGFiafg0u5iW4TCRQKJ6wjc9VEsv5g/paRYm2oqwhYaq2OIXnWZsq
         MTCXg1419lLwggnMBswXkr+uoyHDJfjLiii21XMSeSxQbq5UApAYV5tcF2m3aZDxR53H
         U/Uz6XLC+6AjLYbR1tZNXVNMkfNVsG/kkMauDKRzRLYJxgDa2sqXkO0g91E5vrfDuuRc
         j09TaHiGVxq8i2nnu4Fm1zwcAa0P8SXEt5tO8gz6DB5egnuQUTjXpoaSDHGkiNhGAZSS
         bRlAjazgg+GXdAgzajKuH6vkcuHVitidvAzcYyqaHy1mOAJkUopK87nDxSFEBMxaaJvr
         FkOQ==
X-Forwarded-Encrypted: i=1; AJvYcCUCHHgz85xO9N915l/HKphqg/EJb9H3QaEHdAri9VkON3OW4D8XL1LcCeiHSQ7k8p5iXfadZ7y1TCGZNEoZYlyEBkK7DpU4pAsvgo0=
X-Gm-Message-State: AOJu0YznH8pe5tzLnZIViHo7t+6JfPcPNOkzTDcpuYu9MTtupFXp9iAl
	v7q/oaCboRccjRtukN3JWrS+l14EL+Teu1pKroI4PToepk0g7hkw6a0LmE6s
X-Google-Smtp-Source: AGHT+IGGb/jWJQ/vB1ycj475VfAt2DYJmXOpBIVMSV5/HH7G6bXsH5yiIVN61ohuq27CGOs8cJrOtQ==
X-Received: by 2002:a17:907:94d4:b0:a7a:9171:88f4 with SMTP id a640c23a62f3a-a8392a48ebdmr14703066b.68.1723741840818;
        Thu, 15 Aug 2024 10:10:40 -0700 (PDT)
Received: from [192.168.42.192] ([85.255.234.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a838394725bsm126342266b.168.2024.08.15.10.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 10:10:40 -0700 (PDT)
Message-ID: <e06fd325-f20f-44d8-8f72-89b97cf4186f@gmail.com>
Date: Thu, 15 Aug 2024 18:11:13 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, Conrad Meyer <conradmeyer@meta.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
 <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
 <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 15:33, Jens Axboe wrote:
> On 8/14/24 7:42 PM, Ming Lei wrote:
>> On Wed, Aug 14, 2024 at 6:46?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>
>>> Add ->uring_cmd callback for block device files and use it to implement
>>> asynchronous discard. Normally, it first tries to execute the command
>>> from non-blocking context, which we limit to a single bio because
>>> otherwise one of sub-bios may need to wait for other bios, and we don't
>>> want to deal with partial IO. If non-blocking attempt fails, we'll retry
>>> it in a blocking context.
>>>
>>> Suggested-by: Conrad Meyer <conradmeyer@meta.com>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   block/blk.h             |  1 +
>>>   block/fops.c            |  2 +
>>>   block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>>>   include/uapi/linux/fs.h |  2 +
>>>   4 files changed, 99 insertions(+)
>>>
>>> diff --git a/block/blk.h b/block/blk.h
>>> index e180863f918b..5178c5ba6852 100644
>>> --- a/block/blk.h
>>> +++ b/block/blk.h
>>> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>>>   int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>>>                  loff_t lstart, loff_t lend);
>>>   long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>>   long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>
>>>   extern const struct address_space_operations def_blk_aops;
>>> diff --git a/block/fops.c b/block/fops.c
>>> index 9825c1713a49..8154b10b5abf 100644
>>> --- a/block/fops.c
>>> +++ b/block/fops.c
>>> @@ -17,6 +17,7 @@
>>>   #include <linux/fs.h>
>>>   #include <linux/iomap.h>
>>>   #include <linux/module.h>
>>> +#include <linux/io_uring/cmd.h>
>>>   #include "blk.h"
>>>
>>>   static inline struct inode *bdev_file_inode(struct file *file)
>>> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
>>>          .splice_read    = filemap_splice_read,
>>>          .splice_write   = iter_file_splice_write,
>>>          .fallocate      = blkdev_fallocate,
>>> +       .uring_cmd      = blkdev_uring_cmd,
>>
>> Just be curious, we have IORING_OP_FALLOCATE already for sending
>> discard to block device, why is .uring_cmd added for this purpose?

Which is a good question, I haven't thought about it, but I tend to
agree with Jens. Because vfs_fallocate is created synchronous
IORING_OP_FALLOCATE is slow for anything but pretty large requests.
Probably can be patched up, which would  involve changing the
fops->fallocate protot, but I'm not sure async there makes sense
outside of bdev (?), and cmd approach is simpler, can be made
somewhat more efficient (1 less layer in the way), and it's not
really something completely new since we have it in ioctl.


> I think wiring up a bdev uring_cmd makes sense, because:
> 
> 1) The existing FALLOCATE op is using vfs_fallocate, which is inherently
>     sync and hence always punted to io-wq.
> 
> 2) There will most certainly be other async ops that would be
>     interesting to add, at which point we'd need it anyway.
> 
> 3) It arguably makes more sense to have a direct discard op than use
>     fallocate for this, if working on a raw bdev.
> 
> And probably others...
> 

-- 
Pavel Begunkov

