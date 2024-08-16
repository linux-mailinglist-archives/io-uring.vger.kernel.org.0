Return-Path: <io-uring+bounces-2787-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E1574953F6D
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 04:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9938A28392E
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 02:16:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24632250EC;
	Fri, 16 Aug 2024 02:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R8LFMS+Q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CAB1EA91;
	Fri, 16 Aug 2024 02:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723774572; cv=none; b=oFefooIuIVh/pOONZFehpoNtz/pp+iaCRO1aAvPquGxXJQQMyKTW/HIdjn/JZghKqUW3Q5HnVPTWd0P/sThu+p9iUWzZrrZ80PKvlHlJeL8fZRLXEUrjXWflHBXEQ5DFdmo3soC8Wzjmt900bFSUlxvJDTZxPQTZ/sg7ql0HFbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723774572; c=relaxed/simple;
	bh=wSIUf+lAGL8NXm+2YhOMU74/VwWt6bUYo+tnlo0exyI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ugte4ls2xUdkRDMbAiEh520QN39mXj9ENu97MGegBfEP3xcrrCmZpUx6NnZMg+2T4d/lRyxgXqVFk7ENS5eqnn6R7FLJwjjI44duI0Tq4zAA+WUMoCEZUCQr4uqy7roPBE4sWnFqmyogzvCkGEu4QqamfYsn3jjwKmwA3H8kLPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R8LFMS+Q; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2f3bfcc2727so5802151fa.0;
        Thu, 15 Aug 2024 19:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723774567; x=1724379367; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=poPIHMhE7auc6vPsKFHl1HlM8rO8Tq50d7kZO6/TfLc=;
        b=R8LFMS+Qht6qS0e2ESpzDXv7e6zuMGedHfTGg6piXwWk8dSvleFdWVpZ5ghL4y4fnS
         dckH8Ud0+8hjeYbfnVsTW0e4pS6I9eySN0xUheMthb6g86sZnS256zIbYHE7X8e7GJOV
         pqc8azJQeUDrnu+ygU+bsJ7WydfbxYcoH1zrG/o1BAbbxmFxmFzA8vBDzvI+L4ITigLB
         SWQ7i7lIib9VsjUJZk6A+g1vfHlOaeaCmPxr2KhdFxJPwtvzXs86hkWANFmXKaDq3uBu
         /xj9VbsGNQOHIb1j4h6ZnpFwTce/AvGW9ExXlAPP0iT17GWajOq+saXn1z2RtHJgfY00
         2Zlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723774567; x=1724379367;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=poPIHMhE7auc6vPsKFHl1HlM8rO8Tq50d7kZO6/TfLc=;
        b=i84rjts6+qTjjQT95APx28UzNnqq2FxsHtP35zxGdcPkaIXHb+fzgIccWi2tXSWs9T
         5MuPQ9nTEhtcDjTBfbZMRi5uuE1KzOeAqu4RW0BP7QYxrTHGyNGDerHC7WQegz0obXZo
         cwgY5GLB7H+Q/nHDoIbcCe+On5k0lOxmwLkBD+u9F375UlW+KbF9SvOC62e46W8BxO41
         ebCY4ndj3Ds00Z4tzmyzj0IkXPt/9j8RHm1CG1QhcxEmK28HJw+MelTLCXxqOx2sQ9xt
         W3ESXATalZwwQnMFly5o6zETyanhMBKZyA4BOs3Lp1id0wv+yfkquzRiHLm9KNmBFs2D
         Mf1w==
X-Forwarded-Encrypted: i=1; AJvYcCW1c2yQpNbMk0TVTEySRL07WCcKfItjqu26ZYc4JpCsd0jktPvNqeOhJFk5ym76I6d3Dq4sBtBufHktxIBIEFbSrVi7F7JF74UvowKsVzSAGi7sIpAbAbzrOtwKd4h5CTGB1h61uA==
X-Gm-Message-State: AOJu0Yy5zysp3PRD1M62A/M9/KmUDIYTZODehYMKGvRjjQtc+hKgaOOW
	hzNt2tluh8cmo8nm8ijKtOkxbseoDZxiRbGT4TqSJPZr4GmUkr+b
X-Google-Smtp-Source: AGHT+IFcsPo0SUnsY2RA54cVGAUBSpKjFIs/ZlXkiXOl9/L3tALE7i16sJb0MaFGuh05X7Klxu56vA==
X-Received: by 2002:a05:6512:ad0:b0:52c:83c7:936a with SMTP id 2adb3069b0e04-5331c6dbb04mr1196300e87.42.1723774566707;
        Thu, 15 Aug 2024 19:16:06 -0700 (PDT)
Received: from [192.168.42.136] ([85.255.234.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838c652asm185210966b.12.2024.08.15.19.16.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 19:16:06 -0700 (PDT)
Message-ID: <dbfd1a3f-a8b6-4d05-943e-4a1387c9d03a@gmail.com>
Date: Fri, 16 Aug 2024 03:16:41 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
 <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
 <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
 <e06fd325-f20f-44d8-8f72-89b97cf4186f@gmail.com> <Zr6S4sHWtdlbl/dd@fedora>
 <4d016a30-d258-4d0e-b3bc-18bf0bd48e32@kernel.dk> <Zr6vIt1uSe9/xguH@fedora>
 <df7c7a6c-3d6f-459b-a7c4-3c105c7b67c5@gmail.com> <Zr60qvr5u1Z4/aZC@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zr60qvr5u1Z4/aZC@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 03:08, Ming Lei wrote:
> On Fri, Aug 16, 2024 at 02:59:49AM +0100, Pavel Begunkov wrote:
>> On 8/16/24 02:45, Ming Lei wrote:
>>> On Thu, Aug 15, 2024 at 07:24:16PM -0600, Jens Axboe wrote:
>>>> On 8/15/24 5:44 PM, Ming Lei wrote:
>>>>> On Thu, Aug 15, 2024 at 06:11:13PM +0100, Pavel Begunkov wrote:
>>>>>> On 8/15/24 15:33, Jens Axboe wrote:
>>>>>>> On 8/14/24 7:42 PM, Ming Lei wrote:
>>>>>>>> On Wed, Aug 14, 2024 at 6:46?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>>>>
>>>>>>>>> Add ->uring_cmd callback for block device files and use it to implement
>>>>>>>>> asynchronous discard. Normally, it first tries to execute the command
>>>>>>>>> from non-blocking context, which we limit to a single bio because
>>>>>>>>> otherwise one of sub-bios may need to wait for other bios, and we don't
>>>>>>>>> want to deal with partial IO. If non-blocking attempt fails, we'll retry
>>>>>>>>> it in a blocking context.
>>>>>>>>>
>>>>>>>>> Suggested-by: Conrad Meyer <conradmeyer@meta.com>
>>>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>>>> ---
>>>>>>>>>     block/blk.h             |  1 +
>>>>>>>>>     block/fops.c            |  2 +
>>>>>>>>>     block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>>>>>>>>>     include/uapi/linux/fs.h |  2 +
>>>>>>>>>     4 files changed, 99 insertions(+)
>>>>>>>>>
>>>>>>>>> diff --git a/block/blk.h b/block/blk.h
>>>>>>>>> index e180863f918b..5178c5ba6852 100644
>>>>>>>>> --- a/block/blk.h
>>>>>>>>> +++ b/block/blk.h
>>>>>>>>> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>>>>>>>>>     int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>>>>>>>>>                    loff_t lstart, loff_t lend);
>>>>>>>>>     long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>>>>> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>>>>>>>>     long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>>>>>
>>>>>>>>>     extern const struct address_space_operations def_blk_aops;
>>>>>>>>> diff --git a/block/fops.c b/block/fops.c
>>>>>>>>> index 9825c1713a49..8154b10b5abf 100644
>>>>>>>>> --- a/block/fops.c
>>>>>>>>> +++ b/block/fops.c
>>>>>>>>> @@ -17,6 +17,7 @@
>>>>>>>>>     #include <linux/fs.h>
>>>>>>>>>     #include <linux/iomap.h>
>>>>>>>>>     #include <linux/module.h>
>>>>>>>>> +#include <linux/io_uring/cmd.h>
>>>>>>>>>     #include "blk.h"
>>>>>>>>>
>>>>>>>>>     static inline struct inode *bdev_file_inode(struct file *file)
>>>>>>>>> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
>>>>>>>>>            .splice_read    = filemap_splice_read,
>>>>>>>>>            .splice_write   = iter_file_splice_write,
>>>>>>>>>            .fallocate      = blkdev_fallocate,
>>>>>>>>> +       .uring_cmd      = blkdev_uring_cmd,
>>>>>>>>
>>>>>>>> Just be curious, we have IORING_OP_FALLOCATE already for sending
>>>>>>>> discard to block device, why is .uring_cmd added for this purpose?
>>>>>>
>>>>>> Which is a good question, I haven't thought about it, but I tend to
>>>>>> agree with Jens. Because vfs_fallocate is created synchronous
>>>>>> IORING_OP_FALLOCATE is slow for anything but pretty large requests.
>>>>>> Probably can be patched up, which would  involve changing the
>>>>>> fops->fallocate protot, but I'm not sure async there makes sense
>>>>>> outside of bdev (?), and cmd approach is simpler, can be made
>>>>>> somewhat more efficient (1 less layer in the way), and it's not
>>>>>> really something completely new since we have it in ioctl.
>>>>>
>>>>> Yeah, we have ioctl(DISCARD), which acquires filemap_invalidate_lock,
>>>>> same with blkdev_fallocate().
>>>>>
>>>>> But this patch drops this exclusive lock, so it becomes async friendly,
>>>>> but may cause stale page cache. However, if the lock is required, it can't
>>>>> be efficient anymore and io-wq may be inevitable, :-)
>>>>
>>>> If you want to grab the lock, you can still opportunistically grab it.
>>>> For (by far) the common case, you'll get it, and you can still do it
>>>> inline.
>>>
>>> If the lock is grabbed in the whole cmd lifetime, it is basically one sync
>>> interface cause there is at most one async discard cmd in-flight for each
>>> device.
>>>
>>> Meantime the handling has to move to io-wq for avoiding to block current
>>> context, the interface becomes same with IORING_OP_FALLOCATE?
>>
>> Right, and agree that we can't trylock because we'd need to keep it
>> locked until IO completes, at least the sync versions does that.
>>
>> But I think *invalidate_pages() in the patch should be enough. That's
>> what the write path does, so it shouldn't cause any problem to the
>> kernel. As for user space, that'd be more relaxed than the ioctl,
>> just as writes are, so nothing new to the user. I hope someone with
>> better filemap understanding can confirm it (or not).
> 
> I may not be familiar with filemap enough, but looks *invalidate_pages()
> is only for removing pages from the page cache range, and the lock is added
> for preventing new page cache read from being started, so stale data read
> can be avoided when DISCARD is in-progress.

Sounds like it, but the point is it's the same data race for the
user as if it would've had a write in progress.

-- 
Pavel Begunkov

