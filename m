Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07AF26C6F4
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 20:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgIPSM6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 14:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgIPSMy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 14:12:54 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B30C061756
        for <io-uring@vger.kernel.org>; Wed, 16 Sep 2020 11:12:52 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id u126so9098249oif.13
        for <io-uring@vger.kernel.org>; Wed, 16 Sep 2020 11:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q8JqmRXfCEzzBTUwxRJ4JDVMKyc+q/iGHLSVKM7GCd8=;
        b=UY6SkYvZ6n2kzBUbHshy2ytOTW0KCRfXMJJPn9/L7fMov1wNUErCNMQwldbSHaPSZr
         Msh2YKHi81IJT8hjK84Bdx+luk/HHQ99IgCOzuo9c8gE5Zv3xBgr9NX6Z/4pD3XMkOPX
         l68z0o5PSwzFghP80FcPuy7Z2sLBC63oFgcOQszv6+j9TgaJlxpeStL+UufW6jwp2h5d
         +Gkj8hkfpIlbzBg7xMQGRYAP170On8Or79775TvHJKnQfrG7XYurXLB7d3+DxeFMoXeB
         8jWG6XcqaaPfgOAYuYDyYa/qda+tQS22JIlorg7CDWwA+TdyyllnDpeM4taYgO4hUu5k
         pjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q8JqmRXfCEzzBTUwxRJ4JDVMKyc+q/iGHLSVKM7GCd8=;
        b=orkbOsJ8cpN3CF5EiUd30W3uija6vNgaaOGcsIjQrgNmhUT/KShxAIf3o4QKtUfWQK
         Hfq+4cK8/IQxwbBR4FH5W/CVjkvFGWKl5k1X/sC2BAMtaElzGXjTwqdwwM7sQoJ8n8Lg
         pQ07poKgSjefETnmHqU2lHrv823E55V2PD3RnJTLfH2tkiAkkW4C2dL1/wjupqsnef8N
         y7jjHUAcKrsPqRv/H8VM8RXu4/32O+vMqoEuQYHheT7BLQ+bMXiiNIzrBc3IyI4L4NOV
         Lxo5I63ToqvgihOK/5dc8D7asrq2VjbSFaL/zUsd3ePONw2G+5e0kX+1bHxJjyHUg2Sg
         MtVQ==
X-Gm-Message-State: AOAM533k/Y4OGiDgosQKC/hyKIhAupu8Lp5ITt406DCHFp2lLUKFnnwe
        dbQRKMdbeNe/svywjFCsQ5Zp7W3daETZ9Lvt
X-Google-Smtp-Source: ABdhPJxremX4JE+9hDeQ7AcQsaYym2VgREU+oX0qRb5YsN3wlaSJpaCFijD6V5/cIVLs/uFrlsbx0w==
X-Received: by 2002:aca:220e:: with SMTP id b14mr3803325oic.97.1600279971620;
        Wed, 16 Sep 2020 11:12:51 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m184sm9985622oig.29.2020.09.16.11.12.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 11:12:50 -0700 (PDT)
Subject: Re: occasional metadata I/O errors (-EOPNOTSUPP) on XFS + io_uring
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, io-uring@vger.kernel.org
References: <20200915113327.GA1554921@bfoster>
 <20200916131957.GB1681377@bfoster>
 <0b6da658-54b1-32ea-b172-981c67aaf29e@kernel.dk>
 <20200916180539.GC1681377@bfoster>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b8fd5ba4-342a-8feb-4eb0-7e6f92081a82@kernel.dk>
Date:   Wed, 16 Sep 2020 12:12:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916180539.GC1681377@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/16/20 12:05 PM, Brian Foster wrote:
> On Wed, Sep 16, 2020 at 10:55:08AM -0600, Jens Axboe wrote:
>> On 9/16/20 7:19 AM, Brian Foster wrote:
>>> On Tue, Sep 15, 2020 at 07:33:27AM -0400, Brian Foster wrote:
>>>> Hi Jens,
>>>>
>>>> I'm seeing an occasional metadata (read) I/O error (EOPNOTSUPP) when
>>>> running Zorro's recent io_uring enabled fsstress on XFS (fsstress -d
>>>> <mnt> -n 99999999 -p 8). The storage is a 50GB dm-linear device on a
>>>> virtio disk (within a KVM guest). The full callstack of the I/O
>>>> submission path is appended below [2], acquired via inserting a
>>>> WARN_ON() in my local tree.
>>>>
>>>> From tracing around a bit, it looks like what happens is that fsstress
>>>> calls into io_uring, the latter starts a plug and sets plug.nowait =
>>>> true (via io_submit_sqes() -> io_submit_state_start()) and eventually
>>>> XFS needs to read an inode cluster buffer in the context of this task.
>>>> That buffer read ultimately fails due to submit_bio_checks() setting
>>>> REQ_NOWAIT on the bio and the following logic in the same function
>>>> causing a BLK_STS_NOTSUPP status:
>>>>
>>>> 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
>>>> 		goto not_supported;
>>>>
>>>> In turn, this leads to the following behavior in XFS:
>>>>
>>>> [ 3839.273519] XFS (dm-2): metadata I/O error in "xfs_imap_to_bp+0x116/0x2c0 [xfs]" at daddr 0x323a5a0 len 32 error 95
>>>> [ 3839.303283] XFS (dm-2): log I/O error -95
>>>> [ 3839.321437] XFS (dm-2): xfs_do_force_shutdown(0x2) called from line 1196 of file fs/xfs/xfs_log.c. Return address = ffffffffc12dea8a
>>>> [ 3839.323554] XFS (dm-2): Log I/O Error Detected. Shutting down filesystem
>>>> [ 3839.324773] XFS (dm-2): Please unmount the filesystem and rectify the problem(s)
>>>>
>>>> I suppose it's possible fsstress is making an invalid request based on
>>>> my setup, but I find it a little strange that this state appears to leak
>>>> into filesystem I/O requests. What's more concerning is that this also
>>>> seems to impact an immediately subsequent log write submission, which is
>>>> a fatal error and causes the filesystem to shutdown.
>>>>
>>>> Finally, note that I've seen your patch associated with Zorro's recent
>>>> bug report [1] and that does seem to prevent the problem. I'm still
>>>> sending this report because the connection between the plug and that
>>>> change is not obvious to me, so I wanted to 1.) confirm this is intended
>>>> to fix this problem and 2.) try to understand whether this plugging
>>>> behavior introduces any constraints on the fs when invoked in io_uring
>>>> context. Thoughts? Thanks.
>>>>
>>>
>>> To expand on this a bit, I was playing more with the aforementioned fix
>>> yesterday while waiting for this email's several hour trip to the
>>> mailing list to complete and eventually realized that I don't think the
>>> plug.nowait thing properly accommodates XFS' use of multiple devices. A
>>> simple example is XFS on a data device with mq support and an external
>>> log device without mq support. Presumably io_uring requests could thus
>>> enter XFS with plug.nowait set to true, and then any log bio submission
>>> that happens to occur in that context is doomed to fail and shutdown the
>>> fs.
>>
>> Do we ever read from the logdev? It'll only be a concern on the read
>> side. And even from there, you'd need nested reads from the log device.
>>
> 
> We only read from the log device on log recovery (during filesystem
> mount), but I don't follow why that matters since log writes originate
> within XFS (not userspace). Do you mean to ask whether we access the log
> in the context of userspace reads.. ?
> 
> We currently write to the log from various runtime contexts. I don't
> _think_ that we currently ever do so during a file read, but log forces
> can be async and buried under layers of indirection which makes it
> difficult to reason about (and prevent in the future, if necessary). For
> example, attempting to lock a stale buffer can issue an async log force.
> 
> FWIW and to confirm the above, a simple experiment to issue a log force
> in XFS' read_iter() does reproduce the same shutdown condition described
> above when XFS is mounted with a mq data device and !mq external log
> device. That may or may not be a theoretical condition at the moment,
> but it kind of looks like a landmine to me. Perhaps we'll need to come
> up with a more explicit way of ensuring we never submit log bios from a
> context where we know the block subsystem will swat them away...
> 
>> In general, the 'can async' check should be advisory, the -EAGAIN
>> or -EOPNOTSUPP should be caught and reissued. The failure path was
>> just related to this happening off the retry path on arming for the
>> async buffered callback.
>>
> 
> I think the issue here is that io_uring is not in the path between XFS
> and the log device. Therefore, XFS receives the log I/O error directly
> and shuts down. I do think it's fair to argue that io_uring should not
> be setting task level context that enforces strict device specific
> requirements on I/O submission and then call into subsystems that can
> submit I/O to disparate/unrelated devices. That said, I'm not intimately
> familiar with the problem this is trying to solve...

I agree (with both this and the above), we should make this stronger.
I'll take a look.

-- 
Jens Axboe

