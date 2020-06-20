Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED40D202702
	for <lists+io-uring@lfdr.de>; Sun, 21 Jun 2020 00:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728082AbgFTWY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Jun 2020 18:24:27 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:50217 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727930AbgFTWY1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Jun 2020 18:24:27 -0400
Received: by mail-pj1-f68.google.com with SMTP id jz3so6032240pjb.0
        for <io-uring@vger.kernel.org>; Sat, 20 Jun 2020 15:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P9EdZwoUEilaaPaGt0yypx7kTpXDDqj3Kgwr/bPqk7o=;
        b=Kl71IwJs+ideoSH3nqgj8jrMe6Jfdx0K2je852O6qqFazclzXg4htFP3SM6ALiaG+K
         5MnlGKLQO+HFuRCh+bbQ7fMPa31C16a/3EXr6RvMvuf/fRRrJ4HDbHn+2fg9i0YKB7MZ
         1648IWDeMByjE1Qkb1qjJR0b9sDjrtxM4pOgShCHjhfGa23wxxm5jsK/m1Gp98W+FVwp
         cqC42Lu9zSDxbcDqH7wysJ9eTbynScEsr2YtcbT/aoxbK8g6VLU/nMil+cN0/vr/EnRM
         FXsDI55QzSldPJX0gLVI5MpSS2l6s6AhHgexgXeveXETJ5Z43ix/LmwrM9H5dw5Z6Xtf
         Er0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P9EdZwoUEilaaPaGt0yypx7kTpXDDqj3Kgwr/bPqk7o=;
        b=Ym/+mzDooTVE7+w0PeqQaEt2X8bOV1DkedCr65QtcK+KH4HDUrG8CmfGfXmWBkYFRh
         xIkZwzfsW4FXNnWTatlVxvugdxIdqYLhbRhu0FcN4NPPj1d1zNaV7ZIgnHp7+3xzCGj2
         5k3DiBiLT4UfLf/MnjLEZLlAFo2OH8Wh27AoZzRlviMopR0W5lp2L3a/0Ti6K4cm21uj
         ZtIBGc4RUcy+aAwcIsIqDTnlNFz/lILXGZoAFo7n95er97P9hmHTxOZFIFfRQ+KbYoCR
         pkVAYlHtHB87hPAM4qZX6MSmGh3vcU8txkvhJz2XNhxe5hVL3v1lhM8vGoyuFGyyWyUz
         eZAA==
X-Gm-Message-State: AOAM5310agp/eYEu1EAmCQvego0DSJWKUdiJA+otlKk0QCw0eBPb1GSs
        sdfFLMZMCktQTXg+84V2rUkzKO1krCQ=
X-Google-Smtp-Source: ABdhPJwSgeQ3S43UbD0A3W3VNIjr7gbcUOtVKvvIOE+pdBPa46T6ZMFu24cTwG5pc9PGcnCQUt8PJw==
X-Received: by 2002:a17:902:8346:: with SMTP id z6mr13938964pln.27.1592691806039;
        Sat, 20 Jun 2020 15:23:26 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id g84sm10203618pfb.113.2020.06.20.15.23.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2020 15:23:25 -0700 (PDT)
Subject: Re: [RFC 0/1] io_uring: use valid mm in io_req_work_grab_env() in
 SQPOLL mode
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring@vger.kernel.org
References: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <51d367a0-9520-e319-359b-7c191c2d911c@kernel.dk>
Date:   Sat, 20 Jun 2020 16:23:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1592611064-35370-1-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/19/20 5:57 PM, Bijan Mottahedeh wrote:
> The liburing read-write test crashes with the strack trace below.
> 
> The problem is NULL current->mm dereference in io_req_work_grab_env().
> 
> Sending this as RFC since I'm not sure about any personality implications
> of unconditionally using sqo_mm, and the proper way of failing the
> request if no valid mm is found.
> 
> [  227.308192] BUG: kernel NULL pointer dereference, address: 0000000000000060
> [  227.310320] #PF: supervisor write access in kernel mode
> [  227.311789] #PF: error_code(0x0002) - not-present page
> [  227.313170] PGD 8000000f951e7067 P4D 8000000f951e7067 PUD f9768d067 PMD 0
> [  227.314918] Oops: 0002 [#1] SMP DEBUG_PAGEALLOC PTI
> [  227.316094] CPU: 4 PID: 6209 Comm: io_uring-sq Not tainted 5.8.0-rc1-next-203
> [  227.318050] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-4
> [  227.319964] RIP: 0010:__io_queue_sqe+0x503/0x790
> [  227.320706] Code: 68 00 00 00 01 49 83 be c8 00 00 00 00 75 2d 42 f6 04 bd 60
> [  227.323688] RSP: 0018:ffffc90001297db8 EFLAGS: 00010202
> [  227.324520] RAX: ffff888f9aa90040 RBX: ffff888f98dc8af8 RCX: 0000000000000000
> [  227.325644] RDX: 0000000000000000 RSI: 0000000000001000 RDI: ffff888f98dc8b28
> [  227.326767] RBP: ffffc90001297e38 R08: ffffc90001297c18 R09: 0000000000000001
> [  227.327929] R10: 00000000ffffffeb R11: ffff888facb3b800 R12: 0000000000000000
> [  227.329042] R13: ffff888facb3b800 R14: ffff888f98dc8a40 R15: 0000000000000001
> [  227.330155] FS:  0000000000000000(0000) GS:ffff888ff0e00000(0000) knlGS:00000
> [  227.331419] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  227.332338] CR2: 0000000000000060 CR3: 0000000f97bbc002 CR4: 0000000000160ee0
> [  227.333449] Call Trace:
> [  227.333864]  ? kvm_sched_clock_read+0xd/0x20
> [  227.334537]  ? task_work_run+0x61/0x80
> [  227.335151]  io_async_buf_retry+0x3b/0x50
> [  227.335760]  task_work_run+0x6a/0x80
> [  227.336356]  io_sq_thread+0x14e/0x320

Ah I missed you're running for-next, the next update should work for you,
the io_async_buf_retry() got fixed with the necessary mm grab for SQPOLL
a few days ago:

https://git.kernel.dk/cgit/linux-block/commit/?h=async-buffered.8&id=3ad1d68c04bf9555942b63b5aba31e446fdcf355

-- 
Jens Axboe

