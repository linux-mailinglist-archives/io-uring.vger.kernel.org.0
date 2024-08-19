Return-Path: <io-uring+bounces-2832-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2A8957528
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 22:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F6DCB26399
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 20:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5EE1DC49E;
	Mon, 19 Aug 2024 20:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kWAgMPt3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A8F1553BC
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 20:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724097687; cv=none; b=eUEPjAvoc7T2fTbtjFN7HKQUBWXhD3YdsyDzoGc2CZZL7MME/ekGzCllwiNRzU1bd/vZUFfJpqRWc+wecoqkmeLUdgvjKCWmAQFh/tgSeSnB6xiXh4d2zvld/ClsURliylhuHHVSHqMDNhjr4UKQ9CQapFmbCRep+dY/V7f13Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724097687; c=relaxed/simple;
	bh=2ZE45+cgUIuyQJkodXhsuEckR1niX26Fn0JyzWLTMpE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5hxvIBUVs5kQ7njha+rE4IFwl1PVDGcZZcbxF8ZKzjpNXMllrsWPRWrNLB4u1+a8hGfeoiS8QiH9BInS6+lbGTw/vAC76+7JFI7WSZrEffHvXkfJtPgQy9dJAQsw8C/hAfCgjY0GompGfSLecj0BhW4rhHAF6wMu8bThVcnLCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kWAgMPt3; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7b5aacae4f0so496467a12.2
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 13:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724097683; x=1724702483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H2mIXT54Vz7IA9OZ4shkVd+tu83njeLY/qswpba/Pp4=;
        b=kWAgMPt38yxiDMcRQRfVLTddXqiX+l4gjyfVpSy8OH4X97n5p7rntF5WiADDBQ8k9R
         sT4TBVOQSJGyq0zSh2d4UCOTy75Fr8/YuPnBp2bhcy+/ijaSQu/HRUuGkPs2cuJwVhjT
         hokyuoyn0/6c9CHT4uv3E8q6ZgRFyiPNHMmDSKVnOsfaWPK/yFR6gM5HrT8O2nOwXxiG
         8tncyZ8moH8tTocc4Tsmt1eeGFQehComfZhVzig6X72yj/2MQyAN5BOQiu+XrGXF674e
         3E70tgqfEIiJGjlTdowgDypxJ6bsxPUVQJTama4OnAUuuEoxlDjFLd4BhzV4UR+I/jgZ
         h8UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724097683; x=1724702483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H2mIXT54Vz7IA9OZ4shkVd+tu83njeLY/qswpba/Pp4=;
        b=vdTIVMHCTe5V3ZkT5AZ2daRmj0h+bOze8rhRoncfxpOYDeggx9b/MAJekOQUnACmv0
         Ie3wmzOUf7nLpc3WmK+EBuLgSq1W8tURkI416VuamFCX3TKzHheHatHpK4gqn6K2u83n
         b21Y+r1iZ1YfwAiHzrLMmwTnPlkeKkLNyvzf4WQv6QKyKTHSoitZ2T7NIH7w6STD6Aj3
         7ZFVGv11Te6l/p7FqFZCCXfOMBFgchzFXRSdNwHaWrOclKk2CL/6D9KDgKgdz8lq5okt
         ijZzveSKZgT0Lr79ync3bviHEFufgct2H7Sr7bV3LLJ6+yaPihl2QpdVst00zRNrNVwz
         igoQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3XBftCzWLFFc4haZMthVmZXn0zoYRs6e0avpTE/zOMz92rSBC/qAZN4xvEvnD7wzgT+yrlPqEnw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzBCcf+tg0kMtZv8imTsjeTTsq1Ow9wmJvufkLXNqZt89l+Gv2d
	BBPBdg3uP//bR0gpzygdog/2XtdS8RgYvnI4ZgNM6NhI2YnddHmwUdPyEZdlFYI=
X-Google-Smtp-Source: AGHT+IGxK0714j0qnuBA0v3/eGwfOW/pLE6uS1AGzxKfJHOdxJfoqgI1eCAmaWhTaP21fMWQQG51Eg==
X-Received: by 2002:a17:902:d492:b0:202:371c:3331 with SMTP id d9443c01a7336-202371c3702mr44311775ad.9.1724097683015;
        Mon, 19 Aug 2024 13:01:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a7a6sm66237685ad.195.2024.08.19.13.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Aug 2024 13:01:22 -0700 (PDT)
Message-ID: <e9562cf8-9cf1-409e-8fbd-546d11fcba93@kernel.dk>
Date: Mon, 19 Aug 2024 14:01:21 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Ming Lei <ming.lei@redhat.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 Conrad Meyer <conradmeyer@meta.com>, linux-block@vger.kernel.org,
 linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
 <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
 <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
 <e06fd325-f20f-44d8-8f72-89b97cf4186f@gmail.com> <Zr6S4sHWtdlbl/dd@fedora>
 <4d016a30-d258-4d0e-b3bc-18bf0bd48e32@kernel.dk> <Zr6vIt1uSe9/xguH@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zr6vIt1uSe9/xguH@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/24 7:45 PM, Ming Lei wrote:
> On Thu, Aug 15, 2024 at 07:24:16PM -0600, Jens Axboe wrote:
>> On 8/15/24 5:44 PM, Ming Lei wrote:
>>> On Thu, Aug 15, 2024 at 06:11:13PM +0100, Pavel Begunkov wrote:
>>>> On 8/15/24 15:33, Jens Axboe wrote:
>>>>> On 8/14/24 7:42 PM, Ming Lei wrote:
>>>>>> On Wed, Aug 14, 2024 at 6:46?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>>>
>>>>>>> Add ->uring_cmd callback for block device files and use it to implement
>>>>>>> asynchronous discard. Normally, it first tries to execute the command
>>>>>>> from non-blocking context, which we limit to a single bio because
>>>>>>> otherwise one of sub-bios may need to wait for other bios, and we don't
>>>>>>> want to deal with partial IO. If non-blocking attempt fails, we'll retry
>>>>>>> it in a blocking context.
>>>>>>>
>>>>>>> Suggested-by: Conrad Meyer <conradmeyer@meta.com>
>>>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>>>> ---
>>>>>>>   block/blk.h             |  1 +
>>>>>>>   block/fops.c            |  2 +
>>>>>>>   block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>>>>>>>   include/uapi/linux/fs.h |  2 +
>>>>>>>   4 files changed, 99 insertions(+)
>>>>>>>
>>>>>>> diff --git a/block/blk.h b/block/blk.h
>>>>>>> index e180863f918b..5178c5ba6852 100644
>>>>>>> --- a/block/blk.h
>>>>>>> +++ b/block/blk.h
>>>>>>> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>>>>>>>   int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>>>>>>>                  loff_t lstart, loff_t lend);
>>>>>>>   long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>>> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>>>>>>   long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>>>
>>>>>>>   extern const struct address_space_operations def_blk_aops;
>>>>>>> diff --git a/block/fops.c b/block/fops.c
>>>>>>> index 9825c1713a49..8154b10b5abf 100644
>>>>>>> --- a/block/fops.c
>>>>>>> +++ b/block/fops.c
>>>>>>> @@ -17,6 +17,7 @@
>>>>>>>   #include <linux/fs.h>
>>>>>>>   #include <linux/iomap.h>
>>>>>>>   #include <linux/module.h>
>>>>>>> +#include <linux/io_uring/cmd.h>
>>>>>>>   #include "blk.h"
>>>>>>>
>>>>>>>   static inline struct inode *bdev_file_inode(struct file *file)
>>>>>>> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
>>>>>>>          .splice_read    = filemap_splice_read,
>>>>>>>          .splice_write   = iter_file_splice_write,
>>>>>>>          .fallocate      = blkdev_fallocate,
>>>>>>> +       .uring_cmd      = blkdev_uring_cmd,
>>>>>>
>>>>>> Just be curious, we have IORING_OP_FALLOCATE already for sending
>>>>>> discard to block device, why is .uring_cmd added for this purpose?
>>>>
>>>> Which is a good question, I haven't thought about it, but I tend to
>>>> agree with Jens. Because vfs_fallocate is created synchronous
>>>> IORING_OP_FALLOCATE is slow for anything but pretty large requests.
>>>> Probably can be patched up, which would  involve changing the
>>>> fops->fallocate protot, but I'm not sure async there makes sense
>>>> outside of bdev (?), and cmd approach is simpler, can be made
>>>> somewhat more efficient (1 less layer in the way), and it's not
>>>> really something completely new since we have it in ioctl.
>>>
>>> Yeah, we have ioctl(DISCARD), which acquires filemap_invalidate_lock,
>>> same with blkdev_fallocate().
>>>
>>> But this patch drops this exclusive lock, so it becomes async friendly,
>>> but may cause stale page cache. However, if the lock is required, it can't
>>> be efficient anymore and io-wq may be inevitable, :-)
>>
>> If you want to grab the lock, you can still opportunistically grab it.
>> For (by far) the common case, you'll get it, and you can still do it
>> inline.
> 
> If the lock is grabbed in the whole cmd lifetime, it is basically one sync
> interface cause there is at most one async discard cmd in-flight for each
> device.

Oh for sure, you could not do that anyway as you'd be holding a lock
across the syscall boundary, which isn't allowed.

> Meantime the handling has to move to io-wq for avoiding to block current
> context, the interface becomes same with IORING_OP_FALLOCATE?

I think the current truncate is overkill, we should be able to get by
without. And no, I will not entertain an option that's "oh just punt it
to io-wq".

-- 
Jens Axboe


