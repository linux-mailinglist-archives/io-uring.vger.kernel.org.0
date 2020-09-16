Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B23C26CC0F
	for <lists+io-uring@lfdr.de>; Wed, 16 Sep 2020 22:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgIPUiq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Sep 2020 16:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbgIPRHz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Sep 2020 13:07:55 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CC2C02C2A9
        for <io-uring@vger.kernel.org>; Wed, 16 Sep 2020 09:55:13 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id m7so8930851oie.0
        for <io-uring@vger.kernel.org>; Wed, 16 Sep 2020 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qziD80+3yMPY6N3ieS9kUVQGUHrCR+TyhU1kuZRn8ug=;
        b=OqoBjfs8rO7Af3t0ecA1nZZHf2+27mXKGfPMRthnBvIndRIA93qknLOob6r2PMsEph
         EZl8grJlukA7b5bNpmLXTFTgMnAnVSsX6rE/Vm8h2/vZM1uAr5azOuxLVB/ERCrpEZEC
         hHcakEIjSRWDy+2N9GTxiZsqK6cw2pFM9XGhh2n37/gxq37MEOahl1mj45geboHujWun
         5DNdH9fDNeIDPDYBpn7+nmlHaZkc89ljoS+DEWHlQTCyLr0DODUrxm3FlewOEmDBqXdg
         FP3GNLv90EBOt6QjXNNXH28RNo6uHpf8H5c81J584mRkk2bbd/hLUuSMYz7sZbRQGj2E
         R0ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qziD80+3yMPY6N3ieS9kUVQGUHrCR+TyhU1kuZRn8ug=;
        b=c/8tPlW29CtHN5bK0lUqOIQBP30ASw4vl2MOIaKWtu7NMUp8WN7S/r2oGx5s55O5uF
         nHr+W9vVnc1IkXx1dvSFimVNRKM8QLHPV5B0/WTgwadhMHFew55NfilZ5zgrH/kvnnBu
         BjT+o6qbYc6ZgGfclvV3/+fsYckJa4rPXiDd24LQyIzxyoOdd3J12yuLsMaLsJDwxskG
         vqP+Zd0jdhZ8BIaCVbOXTNGfHgVpDY7CefoEH7CFQcAZ15Wl3YMXpu1GEetgJ21svMsT
         h+d1dyxGXoafvRtfonRbYryXE96eSQ3i/bSNGgubFgzFNO/GKWzUqqOnpTaJdOaxksZP
         pWgA==
X-Gm-Message-State: AOAM5339pU8fQ1wtytduxmqDhQ3BJlNBoGklYMr9P7RNB+crZrpS8AVb
        3u5oTpB5HUWB1nSdCGIQPPBN1zdjMCwyY0Xs
X-Google-Smtp-Source: ABdhPJwyy8X3oyKHbBasQ4BP9MBdAvvi77/SkAShqpXrzWESE810ovpS6kxTF4EhgRtRK6aGiaiZFQ==
X-Received: by 2002:aca:48cc:: with SMTP id v195mr3941331oia.57.1600275310152;
        Wed, 16 Sep 2020 09:55:10 -0700 (PDT)
Received: from [192.168.1.10] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r21sm9489292oie.15.2020.09.16.09.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2020 09:55:09 -0700 (PDT)
Subject: Re: occasional metadata I/O errors (-EOPNOTSUPP) on XFS + io_uring
To:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Cc:     io-uring@vger.kernel.org
References: <20200915113327.GA1554921@bfoster>
 <20200916131957.GB1681377@bfoster>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <0b6da658-54b1-32ea-b172-981c67aaf29e@kernel.dk>
Date:   Wed, 16 Sep 2020 10:55:08 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200916131957.GB1681377@bfoster>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/16/20 7:19 AM, Brian Foster wrote:
> On Tue, Sep 15, 2020 at 07:33:27AM -0400, Brian Foster wrote:
>> Hi Jens,
>>
>> I'm seeing an occasional metadata (read) I/O error (EOPNOTSUPP) when
>> running Zorro's recent io_uring enabled fsstress on XFS (fsstress -d
>> <mnt> -n 99999999 -p 8). The storage is a 50GB dm-linear device on a
>> virtio disk (within a KVM guest). The full callstack of the I/O
>> submission path is appended below [2], acquired via inserting a
>> WARN_ON() in my local tree.
>>
>> From tracing around a bit, it looks like what happens is that fsstress
>> calls into io_uring, the latter starts a plug and sets plug.nowait =
>> true (via io_submit_sqes() -> io_submit_state_start()) and eventually
>> XFS needs to read an inode cluster buffer in the context of this task.
>> That buffer read ultimately fails due to submit_bio_checks() setting
>> REQ_NOWAIT on the bio and the following logic in the same function
>> causing a BLK_STS_NOTSUPP status:
>>
>> 	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
>> 		goto not_supported;
>>
>> In turn, this leads to the following behavior in XFS:
>>
>> [ 3839.273519] XFS (dm-2): metadata I/O error in "xfs_imap_to_bp+0x116/0x2c0 [xfs]" at daddr 0x323a5a0 len 32 error 95
>> [ 3839.303283] XFS (dm-2): log I/O error -95
>> [ 3839.321437] XFS (dm-2): xfs_do_force_shutdown(0x2) called from line 1196 of file fs/xfs/xfs_log.c. Return address = ffffffffc12dea8a
>> [ 3839.323554] XFS (dm-2): Log I/O Error Detected. Shutting down filesystem
>> [ 3839.324773] XFS (dm-2): Please unmount the filesystem and rectify the problem(s)
>>
>> I suppose it's possible fsstress is making an invalid request based on
>> my setup, but I find it a little strange that this state appears to leak
>> into filesystem I/O requests. What's more concerning is that this also
>> seems to impact an immediately subsequent log write submission, which is
>> a fatal error and causes the filesystem to shutdown.
>>
>> Finally, note that I've seen your patch associated with Zorro's recent
>> bug report [1] and that does seem to prevent the problem. I'm still
>> sending this report because the connection between the plug and that
>> change is not obvious to me, so I wanted to 1.) confirm this is intended
>> to fix this problem and 2.) try to understand whether this plugging
>> behavior introduces any constraints on the fs when invoked in io_uring
>> context. Thoughts? Thanks.
>>
> 
> To expand on this a bit, I was playing more with the aforementioned fix
> yesterday while waiting for this email's several hour trip to the
> mailing list to complete and eventually realized that I don't think the
> plug.nowait thing properly accommodates XFS' use of multiple devices. A
> simple example is XFS on a data device with mq support and an external
> log device without mq support. Presumably io_uring requests could thus
> enter XFS with plug.nowait set to true, and then any log bio submission
> that happens to occur in that context is doomed to fail and shutdown the
> fs.

Do we ever read from the logdev? It'll only be a concern on the read
side. And even from there, you'd need nested reads from the log device.

In general, the 'can async' check should be advisory, the -EAGAIN
or -EOPNOTSUPP should be caught and reissued. The failure path was
just related to this happening off the retry path on arming for the
async buffered callback.

-- 
Jens Axboe

