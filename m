Return-Path: <io-uring+bounces-2785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A3D953F2F
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 03:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 889501F21050
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 01:59:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AABA29CFE;
	Fri, 16 Aug 2024 01:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJccSDHZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A2AB664;
	Fri, 16 Aug 2024 01:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723773558; cv=none; b=QzWR2pLbgz9DFis2v9A3cSGxg0IISseaxc+XPH88+7cIOTNZYRS9rGXaIvjZ0LPun57datxZuw+ppJSKPtgt+pBgIj/q+4Q4oDaiNJ9SeYgYA0+wtpuRe5exqTDWPyDESnUXMcKtmXvAXIEesLigPjIBIfbr0QIJ1sMuJMCxTCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723773558; c=relaxed/simple;
	bh=ezu1PnWP4QfW+Dw5Aaw9FtIdWsaaVPg+IoG7VN50FQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R5gnYro+pDIuUtINM0MC5XcNFwWkUT7LT3Qlp+hqXxlo7IsTCE5/GOdRPSIt4xAgiFVDxP9lvHiTDkxYbXPXzNVh8rCsEBxPQQxvg6RMg90sUc6uonYgkuYYrquCinuT4H/O7REWebVfphC/fbjcBKcop88p9ATccZtEaZ0GRLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LJccSDHZ; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5bd1a9bdce4so1990085a12.3;
        Thu, 15 Aug 2024 18:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723773555; x=1724378355; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o/Y3G2OoO96Bba31b8hkBVJ7gM7C216dPhBHBIsl3B8=;
        b=LJccSDHZ9cXC7922AjO2v9aDCA/8by0Hf1OP17SeTQUKguhIPAxiMxLTwpx0KP0zbD
         yClu+Ec8zL0WB9cwPTM/8Un/iays/gc6pGKVKj0aZ2gZZXmwt+m4d54D6pPY5LTLDOqO
         x5YrwtD9HO24lvm7cSQI3N3bFRGAQSVHeeloeA5Nz3hBm8P7QiIMU/UfqhCp+A15ekob
         V/ZkvgKBYz5jcqUqjinvdoxZZQFSaVUVrjBjeS1MCYRIeBavx3yjjrQ+TAM1jl1mDi/f
         pl8HHSsGmGAEb5MlCMRLUO7TpSxCgTofFBk5ADtlgiIsLQvRUgnfAWPXJG6q4hEEo494
         YHdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723773555; x=1724378355;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/Y3G2OoO96Bba31b8hkBVJ7gM7C216dPhBHBIsl3B8=;
        b=Z8mQ2MXojY4wQ50WSuS7JHkn1ooZtT/Fzsb7H7KzgoL+rs0EJk8wuB8gyXHBe9Mls7
         +5RxrzKByfNU0GlGQ6pQxoiBcpd8lgcmlF6pRzdf4QJJWLy23B9L2+mLOvFqzsCMoPR9
         Ru7QI5Ch3P/0uwWvUNRhGO5r13anqLVP+z4gBv7bDVOWuGOH5WiO25NQTvMKCM7675jS
         iYOzFQZpya+EaUusWsecHBcCY7457yc7pRunJnxs5Iu8B4kRr+9ZMT30ps2cZm2boSpP
         TsQzMebUWvfGgcimkAFN5rmNPHNuxw2QcEFr79Rf3yUc26gq1WJzvn5/OFchILy4NbFy
         TaoQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJ01HtmtYfDeSCElvcDTG/xoqPhV0lNkhEfN7YPZuKFOYu/2NFmN50akiBI0vRED6zcgYsVpHYxvmKYrHh9er8WllMyIwB+Rzws8Q=
X-Gm-Message-State: AOJu0YzbiFR1TsvCnrO4GLAw7aFVr2S3BLHqSjKrVKhiOocW7zLe/Ncd
	RM8XwG/fvlbjGI3b951gFhawjw3ZgERA2LpAEiMTsB6w9bbcJsY4
X-Google-Smtp-Source: AGHT+IH7VivWEMfJjLw8o+JCpPIz2lu4p/Ahpn2HRkkwPnYwU4Bt3SrSZk04yLy5L1SVs/jbT0zn4w==
X-Received: by 2002:a17:907:f1e8:b0:a6f:e47d:a965 with SMTP id a640c23a62f3a-a8392941bd2mr102098966b.41.1723773554539;
        Thu, 15 Aug 2024 18:59:14 -0700 (PDT)
Received: from [192.168.42.136] ([85.255.234.87])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a83838cfe58sm180471266b.62.2024.08.15.18.59.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 18:59:14 -0700 (PDT)
Message-ID: <df7c7a6c-3d6f-459b-a7c4-3c105c7b67c5@gmail.com>
Date: Fri, 16 Aug 2024 02:59:49 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Conrad Meyer <conradmeyer@meta.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
 <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
 <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
 <e06fd325-f20f-44d8-8f72-89b97cf4186f@gmail.com> <Zr6S4sHWtdlbl/dd@fedora>
 <4d016a30-d258-4d0e-b3bc-18bf0bd48e32@kernel.dk> <Zr6vIt1uSe9/xguH@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Zr6vIt1uSe9/xguH@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 02:45, Ming Lei wrote:
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
>>>>>>>    block/blk.h             |  1 +
>>>>>>>    block/fops.c            |  2 +
>>>>>>>    block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>>>>>>>    include/uapi/linux/fs.h |  2 +
>>>>>>>    4 files changed, 99 insertions(+)
>>>>>>>
>>>>>>> diff --git a/block/blk.h b/block/blk.h
>>>>>>> index e180863f918b..5178c5ba6852 100644
>>>>>>> --- a/block/blk.h
>>>>>>> +++ b/block/blk.h
>>>>>>> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>>>>>>>    int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>>>>>>>                   loff_t lstart, loff_t lend);
>>>>>>>    long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>>> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>>>>>>    long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>>>
>>>>>>>    extern const struct address_space_operations def_blk_aops;
>>>>>>> diff --git a/block/fops.c b/block/fops.c
>>>>>>> index 9825c1713a49..8154b10b5abf 100644
>>>>>>> --- a/block/fops.c
>>>>>>> +++ b/block/fops.c
>>>>>>> @@ -17,6 +17,7 @@
>>>>>>>    #include <linux/fs.h>
>>>>>>>    #include <linux/iomap.h>
>>>>>>>    #include <linux/module.h>
>>>>>>> +#include <linux/io_uring/cmd.h>
>>>>>>>    #include "blk.h"
>>>>>>>
>>>>>>>    static inline struct inode *bdev_file_inode(struct file *file)
>>>>>>> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
>>>>>>>           .splice_read    = filemap_splice_read,
>>>>>>>           .splice_write   = iter_file_splice_write,
>>>>>>>           .fallocate      = blkdev_fallocate,
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
> 
> Meantime the handling has to move to io-wq for avoiding to block current
> context, the interface becomes same with IORING_OP_FALLOCATE?

Right, and agree that we can't trylock because we'd need to keep it
locked until IO completes, at least the sync versions does that.

But I think *invalidate_pages() in the patch should be enough. That's
what the write path does, so it shouldn't cause any problem to the
kernel. As for user space, that'd be more relaxed than the ioctl,
just as writes are, so nothing new to the user. I hope someone with
better filemap understanding can confirm it (or not).

-- 
Pavel Begunkov

