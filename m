Return-Path: <io-uring+bounces-4284-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD5B89B828D
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 19:26:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 688171F22845
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 18:26:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8D51C57AD;
	Thu, 31 Oct 2024 18:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mfUPPNPB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6194BECF;
	Thu, 31 Oct 2024 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730399156; cv=none; b=StTEaDlhKs1a67oJ16UEDqX4jyXV0ToY18JPHq9/g03SjOGh3OaqOBLV1Fmsmg8Maq7qlNx8kuo2IueQaGwDiiq2zPo44O1yoMefZEO6AG5H5mgjNYCTogTyJu+iaE0wBVMM85T4uxxixdgBrX4yCf7WtVRzcLz/uoPYZ0J2+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730399156; c=relaxed/simple;
	bh=AhY6d4Mww3sZhpDrfAu9tYQBx1ULanuYD6CAOvfp9/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aEiYYZwRsUmk/XrwrAIu6egO/DQXwg8qPR6v1JEvKzpp8Lc/5/ARoaibB8DyWx18r0kLW7mnX9VqJg+UOWsPvl70OyQEfgdeTjaHkAet9f9SxlqKQ9FSQBDUIP055gPYstMwoDMpQeI1uow6wQwS680t7TxI2b+VdLnAoG0WeCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mfUPPNPB; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a99f646ff1bso150013866b.2;
        Thu, 31 Oct 2024 11:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730399153; x=1731003953; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bgxmxzIovDLOUycrc9UMIVdVx3QmZlDRnF4E1HfSqPA=;
        b=mfUPPNPB9Eg3Xs7u7y7H4JwefvBT8TQKipG62BeXP+hzqL7693a6lrFWkThj981Au/
         9WW6MiM7eE/XepOh9ady2yMZlodtrtE5e0rSfLf4yKu9CKSr9eW2aLEOC6Y55rooqnS2
         4c6qfpky5QMoKukiQHenoGe7JKIm3HFigzemaDQnhrjpx9qfPWtxdAeU24mNANZbDTxU
         CWuuo3xb0v26iEW35ccjeOC6930hXSxLTnocMkhUJr9HGFDIScnxaJN6UCbMMMuQKyfy
         BFmlGgNCkD12lIM93+1DplIuplOzN1RuSO2ZgFh+fQpp15E/MQKtMHMYUmy1u+ZitCZw
         +aow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730399153; x=1731003953;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bgxmxzIovDLOUycrc9UMIVdVx3QmZlDRnF4E1HfSqPA=;
        b=aGlYVlTRIJZv3uzCNOMWwUnNcNkcU3+suSNrQi9Q98cqhjVWhQ36xqHAjJIwS/j7kM
         OgN5hKfYfDm0CyiKxrJmZPxB1ps1reI38LXcNbUPudjz6ZtsQnWcgbbWF4kY53Bglwo/
         6yaiq0tMywer2fSUfKFEbDDu5h29Gf5UU3zeWhwm8eaByvwjm2nUL8yVq7aVNCy+tNGz
         3flTu5tWFynTywPHHp9thT6LOo905m7XdOZILIJEnDVJD8a2bMeGwdl0GI9fclnV0E5o
         w4ycORW+O3jI9lxKoE81NEDuNgmRyA7/Fno/+uW/aYEgGil6Z3jJvhyQyrn9pm/hHblH
         h7Sg==
X-Forwarded-Encrypted: i=1; AJvYcCUBUpSoHD/XhbY2S0G6WNw1Pdk+Be8zuqvG4d/zGA+jyKimU1lLTo7sXUQsxQ/mDK7Hd+JMgHbknACRDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyYHVbeJ+vrYnYojJwu7LoTlbjPX7a0Mff5WexckuEaduBjuMta
	Eyt+yGIaIszcr5p2ghUeTX0+hLMrgOlDu53D+v7g+neSfxS0cDAcgcKftg==
X-Google-Smtp-Source: AGHT+IGQ8XbY662szyYfx+s4/CYow/Hh3WOqH9vbOz4ioV4bmXMVsduAReZt71BDP3wm5MKaFznjUQ==
X-Received: by 2002:a17:907:94cb:b0:a9a:6b4c:9d2c with SMTP id a640c23a62f3a-a9e3a7f4453mr872727766b.59.1730399152269;
        Thu, 31 Oct 2024 11:25:52 -0700 (PDT)
Received: from [192.168.42.203] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e565f9b63sm92033066b.110.2024.10.31.11.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Oct 2024 11:25:51 -0700 (PDT)
Message-ID: <fad6bb86-0646-4039-b234-5752f3f833f0@gmail.com>
Date: Thu, 31 Oct 2024 18:26:03 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/5] btrfs: add io_uring command for encoded reads
To: Mark Harmstone <maharmstone@meta.com>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Cc: "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20241022145024.1046883-1-maharmstone@fb.com>
 <20241022145024.1046883-6-maharmstone@fb.com>
 <63db1884-3170-499d-87c8-678923320699@gmail.com>
 <46aa1f2a-d0c6-429e-a862-1b3b8c37c109@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <46aa1f2a-d0c6-429e-a862-1b3b8c37c109@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/31/24 17:08, Mark Harmstone wrote:
> Thanks Pavel.
> 
...
>> If that's an iovec backed iter that might fail, you'd need to
>> steal this patch
>>
>> https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-12-9739c753666e@ddn.com/
>>
>> and fail if "issue_flags & IO_URING_F_TASK_DEAD", see
>>
>> https://lore.kernel.org/all/20241016-fuse-uring-for-6-10-rfc4-v4-13-9739c753666e@ddn.com/
> 
> Thanks, I've sent a patchset including your patch. Does it make a
> difference, though? If the task has died, presumably copy_page_to_iter
> can't copy to another process' memory...?

IIRC copy_to_user will crash without mm set, not sure about
copy_page_to_iter(). Regardless, when the original task has dies
and it gets run from io_uring's fallback path, you shouldn't
make any assumptions about the current task.

>>> +            ret = -EFAULT;
>>> +            goto out;
>>> +        }
>>> +
>>> +        i++;
>>> +        cur += bytes;
>>> +        page_offset = 0;
>>> +    }
>>> +    ret = priv->count;
>>> +
>>> +out:
>>> +    unlock_extent(io_tree, priv->start, priv->lockend,
>>> &priv->cached_state);
>>> +    btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>>
>> When called via io_uring_cmd_complete_in_task() this function might
>> not get run in any reasonable amount of time. Even worse, a
>> misbehaving user can block it until the task dies.
>>
>> I don't remember if rwsem allows unlock being executed in a different
>> task than the pairing lock, but blocking it for that long could be a
>> problem. I might not remember it right but I think Boris meantioned
>> that the O_DIRECT path drops the inode lock right after submission
>> without waiting for bios to complete. Is that right? Can we do it
>> here as well?
> 
> We can't release the inode lock until we've released the extent lock. I
> do intend to look into reducing the amount of time we hold the extent
> lock, if we can, but it's not trivial to do this in a safe manner.

I lack the btrfs knowledge, but sounds like it can be done the
same way the async dio path works.

> We could perhaps move the unlocking to btrfs_uring_read_extent_endio
> instead, but it looks unlocking an rwsem in a different context might
> cause problems with PREEMPT_RT(?).

At least from a quick glance it doesn't seem that locks in
__clear_extent_bit are [soft]irq protected. Would be a good
idea to give it a run with lockdep enabled.


...
>>> +    ret = btrfs_encoded_read_regular_fill_pages(inode, disk_bytenr,
>>> +                            disk_io_size, pages,
>>> +                            priv);
>>> +    if (ret && ret != -EIOCBQUEUED)
>>> +        goto fail;
>>
>> Turning both into return EIOCBQUEUED is a bit suspicious, but
>> I lack context to say. Might make sense to return ret and let
>> the caller handle it.
> 
> btrfs_encoded_read_regular_fill_pages returns 0 if the bio completes
> before the function can finish, -EIOCBQUEUED otherwise. In either case
> the behaviour of the calling function will be the same.

Ok

...
>>> +    if (copy_to_user(sqe_addr + copy_end, (char *)&args +
>>> copy_end_kernel,
>>> +             sizeof(args) - copy_end_kernel)) {
>>> +        if (ret == -EIOCBQUEUED) {
>>> +            unlock_extent(io_tree, start, lockend, &cached_state);
>>> +            btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>>> +        }
>>> +        ret = -EFAULT;
>>> +        goto out_free;
>>
>> It seems we're saving iov in the priv structure, who can access the iovec
>> after the request is submitted? -EIOCBQUEUED in general means that the
>> request is submitted and will get completed async, e.g. via callback, and
>> if the bio callback can use the iov maybe via the iter, this goto will be
>> a use after free.
>>
>> Also, you're returning -EFAULT back to io_uring, which will kill the
>> io_uring request / cmd while there might still be in flight bios that
>> can try to access it.
>>
>> Can you inject errors into the copy and test please?
> 
> The bio hasn't been submitted at this point, that happens in
> btrfs_uring_read_extent. So far all we've done is read the metadata from
> the page cache. The copy_to_user here is copying the metadata info to
> the userspace structure.

I see, in this case it should be fine, but why is it -EIOCBQUEUED
then? It always meant that it queued up the request and will
complete it asynchronously, and that's where the confusion sprouted
from. Not looking deeper but sounds more like -EAGAIN? Assuming it's
returned because we can't block

>>> +    }
>>> +
>>> +    if (ret == -EIOCBQUEUED) {
>>> +        u64 count;
>>> +
>>> +        /*
>>> +         * If we've optimized things by storing the iovecs on the stack,
>>> +         * undo this.
>>> +         */> +        if (!iov) {
>>> +            iov = kmalloc(sizeof(struct iovec) * args.iovcnt,
>>> +                      GFP_NOFS);
>>> +            if (!iov) {
>>> +                unlock_extent(io_tree, start, lockend,
>>> +                          &cached_state);
>>> +                btrfs_inode_unlock(inode, BTRFS_ILOCK_SHARED);
>>> +                ret = -ENOMEM;
>>> +                goto out_acct;
>>> +            }
>>> +
>>> +            memcpy(iov, iovstack,
>>> +                   sizeof(struct iovec) * args.iovcnt);

As an optimisation in the future you can allocate it
together with the btrfs_priv structure.

>>> +        }
>>> +
>>> +        count = min_t(u64, iov_iter_count(&iter), disk_io_size);
>>> +
>>> +        /* Match ioctl by not returning past EOF if uncompressed */
>>> +        if (!args.compression)
>>> +            count = min_t(u64, count, args.len);
>>> +
>>> +        ret = btrfs_uring_read_extent(&kiocb, &iter, start, lockend,
>>> +                          cached_state, disk_bytenr,
>>> +                          disk_io_size, count,
>>> +                          args.compression, iov, cmd);

So that's the only spot where asynchronous code branches off
in this function? Do I read you right?

>>> +
>>> +        goto out_acct;
>>> +    }
>>> +
>>> +out_free:
>>> +    kfree(iov);
>>> +
>>> +out_acct:
>>> +    if (ret > 0)
>>> +        add_rchar(current, ret);
>>> +    inc_syscr(current);
>>> +
>>> +    return ret;
>>> +}

-- 
Pavel Begunkov

