Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23B23316A1
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 19:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbhCHSwA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 13:52:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhCHSvc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 13:51:32 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9040C06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 10:51:31 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id f20so11062262ioo.10
        for <io-uring@vger.kernel.org>; Mon, 08 Mar 2021 10:51:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=6hTPRoU779Sf5U+vET4Z99rUbo6jtKFpBFNt5MLrH1w=;
        b=Xpb6DkAcyVSjdcnzdMO/isyNt/nxSnJ5/bhvcOHKZoyc+7vFLUJncahCsMKdn7Zh5N
         giZ8Si1/h5JTG30eNW8Hj2/mylZK64PZvCxp9Qcq4DB7xsjv7wTf5r06vBLzs6NCPm3u
         Tui354qlwqX3MxnBxvAd3kCcrIvlx4s113r7lY7I7sE1sp1xtYpYKp+PHaO1rhShgWkp
         u3oADO8ac8+Zjm5er/aOK1/st6cNl3hvc4NPVELg8qqvUBhSo+/X2RvKMuXCNC1ITE2a
         9EQM7tAKvI17bIpHaHrfB8oA39L1LshuqJVxUOll2pzP8hvG0Kgx2/C0YGrD8ix+ZMAD
         Tcdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6hTPRoU779Sf5U+vET4Z99rUbo6jtKFpBFNt5MLrH1w=;
        b=qza8h2Bk9Uk4EsUNJ3Aqzxp2J5jx/sTA6SIoXb0XvObkFbiOUj+rwSmjKXexbmgzlm
         UoqZXuzUBqFcHTfViRiSSsraWvdaww17FFr0rifTGCSZ1OJol9CltjkBmG9lkk4BZ4HM
         7AHmzs4L5D1z2lqCcFZHxWUAsNu0mSscPfOJJaXKR/oWHLUPScSdM0ZyVcShqp7i7uiY
         U7ik8P2TtncqQuEFUQYU0EJANXWUOO2jT7QIwitiHTrCZ5k1JqpSHWhmC4YCr2lW3PPV
         Pr3KqPdsLa4ggclwPJWJcElpQE+xHKz1j4FiGyv961PAJopkDDPie2x+ZUVfp31cTmHi
         Ou/w==
X-Gm-Message-State: AOAM533DVtuBUMRXfbKBWIO1Itda1jk2O6W5NJrfPy9nzElpvUCe5y3b
        hLLMgqa8ThD2DlTWjsYKaZ+ThViU0P3OQw==
X-Google-Smtp-Source: ABdhPJztWbq2U3VGBYtXlae6xxGHx/hIbcWT9FTsufnFKRh2LSAhjMMClZU5ApKbvfnDru6Z1sgRkQ==
X-Received: by 2002:a6b:b304:: with SMTP id c4mr20088681iof.139.1615229491115;
        Mon, 08 Mar 2021 10:51:31 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w1sm6287815ilv.52.2021.03.08.10.51.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 10:51:30 -0800 (PST)
Subject: Re: [PATCH 5.12] io_uring: fix io_sq_offload_create error handling
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <fd95d5cfe8fd8dada11ed009678fc2304d5d3f64.1615224628.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <dbd29153-ab25-4592-a190-f22ff67eebbb@kernel.dk>
Date:   Mon, 8 Mar 2021 11:51:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <fd95d5cfe8fd8dada11ed009678fc2304d5d3f64.1615224628.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 10:30 AM, Pavel Begunkov wrote:
> Don't set IO_SQ_THREAD_SHOULD_STOP when io_sq_offload_create() has
> failed on io_uring_alloc_task_context() but leave everything to
> io_sq_thread_finish(), because currently io_sq_thread_finish()
> hangs on trying to park it. That's great it stalls there, because
> otherwise the following io_sq_thread_stop() would be skipped on
> IO_SQ_THREAD_SHOULD_STOP check and the sqo would race for sqd with
> freeing ctx.
> 
> A simple error injection gives something like this.
> 
> [  245.463955] INFO: task sqpoll-test-hang:523 blocked for more than 122 seconds.
> [  245.463983] Call Trace:
> [  245.463990]  __schedule+0x36b/0x950
> [  245.464005]  schedule+0x68/0xe0
> [  245.464013]  schedule_timeout+0x209/0x2a0
> [  245.464032]  wait_for_completion+0x8b/0xf0
> [  245.464043]  io_sq_thread_finish+0x44/0x1a0
> [  245.464049]  io_uring_setup+0x9ea/0xc80
> [  245.464058]  __x64_sys_io_uring_setup+0x16/0x20
> [  245.464064]  do_syscall_64+0x38/0x50
> [  245.464073]  entry_SYSCALL_64_after_hwframe+0x44/0xae

Applied, thanks.

-- 
Jens Axboe

