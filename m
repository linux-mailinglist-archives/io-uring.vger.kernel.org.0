Return-Path: <io-uring+bounces-2772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3F5953515
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 16:33:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C0BB01F20FAB
	for <lists+io-uring@lfdr.de>; Thu, 15 Aug 2024 14:33:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DABF19FA7A;
	Thu, 15 Aug 2024 14:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FKl1OVJw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AEC663D5
	for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 14:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732419; cv=none; b=UtyP4PwlKmG4nFG/r5Sx/y1NwPaVQBPJuMtbDmB24++K405NGwA5oqvxRWMb8CcxFPOkZfD3ppc4dmhLUg/PVFMZXIHoaU6UT7ipEJT+UcVvwGsbT28xiHL0Q+dQLF9pVMrfU+EaiI2Q/HyWDfvGcfRPpOtZTkUG3Sg7vSG7w20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732419; c=relaxed/simple;
	bh=DSUGtq/9K941kinoQIx3PPemHfZMHkN9rIaiuu2LfGQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M3Kzl2d9m0TDrG8GAHQ4/knog7ar7MejVG0xDB2X57M9xlBR1W7X3l+UjFsTg+8u5jZVayA4fXo3wkt8et8gRdB871T2qygqvTpsYtXfwCveno+uHSrX2OOvb/Zy37KF+1+Qa3/4p+163LdWyWsnk1Q3BsMr3ap0eCChAQsQll8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FKl1OVJw; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-81f902e94e6so3523539f.0
        for <io-uring@vger.kernel.org>; Thu, 15 Aug 2024 07:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723732416; x=1724337216; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6rICprDujQR2UM4HfjMuX0CO7+q7wHZGrKy7Agwu530=;
        b=FKl1OVJwAR1kZuBLBeUXm1I2Pj9nn+wI4xSPZWhpWnYc5wTSn6U4qU/zl21sMBWGlG
         5rJVOGvq6Ws4Nqc6Ppp5jLVjgLkd568kTW3q91duWRM0zIFPZ9roLnwLI59sMmnRIXRJ
         7b/nmDFbPemPGm/zcmSfvOPGnGMnTes4tvtCwAs9LVv4N9VY1xgMmBMk5rzLlsnUUPOr
         Z1LOyWOQshsScLd3wrec6ABcmTahHO+FnwFR3dfecSS4rWzWv34H0MNR1b3IReIh4Ola
         kKfmjGMtZ8byxyhRksWgjcQuIkVA5Lvc9akLRCaoCGLrb0qo3dIfCv6NYUPqAHKwkmAE
         TJEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723732416; x=1724337216;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6rICprDujQR2UM4HfjMuX0CO7+q7wHZGrKy7Agwu530=;
        b=MOBhLN40WTyF1IAYfjcKS4k9rdp+gU0plwD9x9Li14+nWWBhwF3ViGNVBa1hgoFe0o
         6a7KcysUVAl9JQZL0WAvdsONZ06+kOuB650irGT33iHqZfrlpm8omcL2fJzLMLLs+kNV
         O7088/5oeNImfEVjGKKHNiD+icT2SbXrZLwlV7a25ZyyUOb1lsA+YoyQWvmoW4gkLkrC
         BhI+1W2Inn7avnZaNq4nnibru9kyOX7xLrDbVm0xm0Nn7OOjfAJZwtgz9CFxID67Gpwa
         CbiXA14CbgTdIo94837iJhL0mGYs2Ib+gr1Z5K3g4kzMJG+6IKJn+j7tJ7t2OMroNxhH
         iXBg==
X-Gm-Message-State: AOJu0YzMGHuhebHteLpRFiPuHWP5IeZRwdzY0VMv3gu27spuualXIUlw
	kgOz/Hm0XE/U4o7USAsOZVjNeMG+t3k2h7vioN41nm9PK/xWT8KzBVSaQbM5lHY=
X-Google-Smtp-Source: AGHT+IGvpiwXjlJpt5son2O8gjjV3rFX1h5+5bydBPLKRSpEg1HWIUur+IBQ2exWat+kjseYTgNOvQ==
X-Received: by 2002:a6b:6305:0:b0:7f6:85d1:f81a with SMTP id ca18e2360f4ac-824e86c307dmr186663439f.2.1723732416308;
        Thu, 15 Aug 2024 07:33:36 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-824e98eda17sm52953239f.6.2024.08.15.07.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 07:33:35 -0700 (PDT)
Message-ID: <fd357721-7ba7-4321-88da-28651754f8a4@kernel.dk>
Date: Thu, 15 Aug 2024 08:33:34 -0600
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
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAFj5m9+CXS_b5kgFioFHTWivb6O+R9HytsSQEHcEzUM5SqHfgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/14/24 7:42 PM, Ming Lei wrote:
> On Wed, Aug 14, 2024 at 6:46?PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> Add ->uring_cmd callback for block device files and use it to implement
>> asynchronous discard. Normally, it first tries to execute the command
>> from non-blocking context, which we limit to a single bio because
>> otherwise one of sub-bios may need to wait for other bios, and we don't
>> want to deal with partial IO. If non-blocking attempt fails, we'll retry
>> it in a blocking context.
>>
>> Suggested-by: Conrad Meyer <conradmeyer@meta.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  block/blk.h             |  1 +
>>  block/fops.c            |  2 +
>>  block/ioctl.c           | 94 +++++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/fs.h |  2 +
>>  4 files changed, 99 insertions(+)
>>
>> diff --git a/block/blk.h b/block/blk.h
>> index e180863f918b..5178c5ba6852 100644
>> --- a/block/blk.h
>> +++ b/block/blk.h
>> @@ -571,6 +571,7 @@ blk_mode_t file_to_blk_mode(struct file *file);
>>  int truncate_bdev_range(struct block_device *bdev, blk_mode_t mode,
>>                 loff_t lstart, loff_t lend);
>>  long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>> +int blkdev_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>  long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
>>
>>  extern const struct address_space_operations def_blk_aops;
>> diff --git a/block/fops.c b/block/fops.c
>> index 9825c1713a49..8154b10b5abf 100644
>> --- a/block/fops.c
>> +++ b/block/fops.c
>> @@ -17,6 +17,7 @@
>>  #include <linux/fs.h>
>>  #include <linux/iomap.h>
>>  #include <linux/module.h>
>> +#include <linux/io_uring/cmd.h>
>>  #include "blk.h"
>>
>>  static inline struct inode *bdev_file_inode(struct file *file)
>> @@ -873,6 +874,7 @@ const struct file_operations def_blk_fops = {
>>         .splice_read    = filemap_splice_read,
>>         .splice_write   = iter_file_splice_write,
>>         .fallocate      = blkdev_fallocate,
>> +       .uring_cmd      = blkdev_uring_cmd,
> 
> Just be curious, we have IORING_OP_FALLOCATE already for sending
> discard to block device, why is .uring_cmd added for this purpose?

I think wiring up a bdev uring_cmd makes sense, because:

1) The existing FALLOCATE op is using vfs_fallocate, which is inherently
   sync and hence always punted to io-wq.

2) There will most certainly be other async ops that would be
   interesting to add, at which point we'd need it anyway.

3) It arguably makes more sense to have a direct discard op than use
   fallocate for this, if working on a raw bdev.

And probably others...

-- 
Jens Axboe


