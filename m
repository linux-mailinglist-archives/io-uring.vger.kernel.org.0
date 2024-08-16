Return-Path: <io-uring+bounces-2783-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C1098953EE3
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 03:24:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79EB42828E1
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 01:24:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0F838472;
	Fri, 16 Aug 2024 01:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oI1Chdqc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973831EB39
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 01:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723771462; cv=none; b=of78qURrG1dJqz3euMW9hclwpW3NylDo4swq+CAYLXLQs+cEcxOUzrCk7ECPBMzNA31oth+YbsGDtusS0ftc9RfY0LP8FwnQnB5VgcufNvJ5hLwdj9Hx7bnezwI8ANwMVL6aQAS64v/B/H/LHoTy/t1L+gIhuXy1WaM6RHl6BAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723771462; c=relaxed/simple;
	bh=t5G81b5AX+fvsJongVsz52cwp90Zh+239ScXKavUnA0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ci6cOdeP0nnaaOI86SkOf6tkmp+8B/gvIlyqFEWSOuoSpyQ6xrPhFMD0uTisBzqF4/k0gjSaaA6x7HgK5DkcWvzs16q/1dO3F129nh9GL4+XCQjJA2I4F22JOkWvadCQWb1M0QhvETgXUUPbZVPWHIxod/ezmb6aJRyoeIaiqww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oI1Chdqc; arc=none smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-268d0979e90so186481fac.3
        for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 18:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723771459; x=1724376259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wS7/+wdQvlwCW86C+NC+Kxgz7DJypNgq3andC6NteXI=;
        b=oI1ChdqclFnSp0KgaYHOoisNPECyTrydWY9Buvl8D4nYYDCC3aUVFsYk06CveeukVa
         LwttkPHbc0xev5F4n8d21WWZkdqFb6XauibClN5O0Nbax29CHX9w7gPuGnlfgOOnk7ar
         W74/RxxVIrTAvpVIE6lDvN0R7SZR/d23sCM66a1806a0BuT4NoD7LlAJ/kkAM2GdkSs0
         ZmE8sorH0fJwcFiR9HqYlnCzNwjo7V2OGmK91TRH6xUyJ9cUVmIKow+WT/VeD+rd8RA+
         4b3dl7Ciif8M8ioBOxTtxCfoOgYSKvlDRrqJTWuWttp8RK0Jqb2eDxWPHBouoVtwXqWw
         L1mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723771459; x=1724376259;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wS7/+wdQvlwCW86C+NC+Kxgz7DJypNgq3andC6NteXI=;
        b=U2bfMiCu+Wa/T7mKjnxPVtJa8aeLHt2A7g2hP/LUykbdI9c7TICUJASspEqbf46qnP
         FldKcPbiDTG1M2HtkL3x7HBOUxjWZSxYULSK8rnnFzY1NFISxra6UuiIgJeelOPCoCvB
         xyVvZrJ25tCEZGMDYg/88p3QXTX9XuWDijW/ZG8FPP+SnZ1mVL3+JlyNNpFrmDDMfz6q
         /2oXtAAglJQcxjZDo3J2zqVd3zNNnBtkyK7tuc1aA5HREBbzDHy13jCKk8Z9KEWjgOcs
         /RN8GX1mf7//7wKNua1PtS7NiWuxUuuXSKL0t01MTX7JyCz+muSfC2YEYKgDQVcvc04B
         TvSw==
X-Gm-Message-State: AOJu0YwWQbyF1d0hoPuRdTaLGJRbkEduoZ/IHvaloQ6qDBA3RZsx7h37
	prA18jBLM7ty3qljWIWRnEIFeyPgwo5M2jklWP4xN5t5c3xkrYZAYKM+Rvu5fiVPCh8sm6uisPu
	h
X-Google-Smtp-Source: AGHT+IHZeP+Bz6KlOUnnumj1Ayg3CCjn6iyNDDoVptcwAhUO55T+8Zj2OLZIXa9i4NCwfnFqKkCfTQ==
X-Received: by 2002:a05:6870:fb8c:b0:25e:44b9:b2ee with SMTP id 586e51a60fabf-2701c346756mr943721fac.2.1723771458703;
        Thu, 15 Aug 2024 18:24:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b6356ad2sm1792656a12.69.2024.08.15.18.24.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 18:24:17 -0700 (PDT)
Message-ID: <4d016a30-d258-4d0e-b3bc-18bf0bd48e32@kernel.dk>
Date: Thu, 15 Aug 2024 19:24:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 5/5] block: implement io_uring discard cmd
To: Ming Lei <ming.lei@redhat.com>, Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Conrad Meyer <conradmeyer@meta.com>,
 linux-block@vger.kernel.org, linux-mm@kvack.org
References: <cover.1723601133.git.asml.silence@gmail.com>
 <6ecd7ab3386f63f1656dc766c1b5b038ff5353c2.1723601134.git.asml.silence@gmail.com>
 <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
 <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
 <e06fd325-f20f-44d8-8f72-89b97cf4186f@gmail.com> <Zr6S4sHWtdlbl/dd@fedora>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zr6S4sHWtdlbl/dd@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/15/24 5:44 PM, Ming Lei wrote:
> On Thu, Aug 15, 2024 at 06:11:13PM +0100, Pavel Begunkov wrote:
>> On 8/15/24 15:33, Jens Axboe wrote:
>>> On 8/14/24 7:42 PM, Ming Lei wrote:
>>>> On Wed, Aug 14, 2024 at 6:46?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>>>
>>>>> Add ->uring_cmd callback for block device files and use it to implement
>>>>> asynchronous discard. Normally, it first tries to execute the command
>>>>> from non-blocking context, which we limit to a single bio because
>>>>> otherwise one of sub-bios may need to wait for other bios, and we don't
>>>>> want to deal with partial IO. If non-blocking attempt fails, we'll retry
>>>>> it in a blocking context.
>>>>>
>>>>> Suggested-by: Conrad Meyer <conradmeyer@meta.com>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> ---
>>>>>   block/blk.h             |  1 +
>>>>>   block/fops.c            |  2 +
>>>>>   block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>>>>>   include/uapi/linux/fs.h |  2 +
>>>>>   4 files changed, 99 insertions(+)
>>>>>
>>>>> diff --git a/block/blk.h b/block/blk.h
>>>>> index e180863f918b..5178c5ba6852 100644
>>>>> --- a/block/blk.h
>>>>> +++ b/block/blk.h
>>>>> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>>>>>   int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>>>>>                  loff_t lstart, loff_t lend);
>>>>>   long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>>>>   long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>>>>
>>>>>   extern const struct address_space_operations def_blk_aops;
>>>>> diff --git a/block/fops.c b/block/fops.c
>>>>> index 9825c1713a49..8154b10b5abf 100644
>>>>> --- a/block/fops.c
>>>>> +++ b/block/fops.c
>>>>> @@ -17,6 +17,7 @@
>>>>>   #include <linux/fs.h>
>>>>>   #include <linux/iomap.h>
>>>>>   #include <linux/module.h>
>>>>> +#include <linux/io_uring/cmd.h>
>>>>>   #include "blk.h"
>>>>>
>>>>>   static inline struct inode *bdev_file_inode(struct file *file)
>>>>> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
>>>>>          .splice_read    = filemap_splice_read,
>>>>>          .splice_write   = iter_file_splice_write,
>>>>>          .fallocate      = blkdev_fallocate,
>>>>> +       .uring_cmd      = blkdev_uring_cmd,
>>>>
>>>> Just be curious, we have IORING_OP_FALLOCATE already for sending
>>>> discard to block device, why is .uring_cmd added for this purpose?
>>
>> Which is a good question, I haven't thought about it, but I tend to
>> agree with Jens. Because vfs_fallocate is created synchronous
>> IORING_OP_FALLOCATE is slow for anything but pretty large requests.
>> Probably can be patched up, which would  involve changing the
>> fops->fallocate protot, but I'm not sure async there makes sense
>> outside of bdev (?), and cmd approach is simpler, can be made
>> somewhat more efficient (1 less layer in the way), and it's not
>> really something completely new since we have it in ioctl.
> 
> Yeah, we have ioctl(DISCARD), which acquires filemap_invalidate_lock,
> same with blkdev_fallocate().
> 
> But this patch drops this exclusive lock, so it becomes async friendly,
> but may cause stale page cache. However, if the lock is required, it can't
> be efficient anymore and io-wq may be inevitable, :-)

If you want to grab the lock, you can still opportunistically grab it.
For (by far) the common case, you'll get it, and you can still do it
inline.

Really not that unusual.

-- 
Jens Axboe


