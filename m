Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F547295DB6
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 13:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897475AbgJVLrD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 07:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503040AbgJVLrD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 07:47:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFD6C0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 04:47:02 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h7so1970758wre.4
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 04:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tJN0tRwpz7+Fx7B96HstVd6cbsperXlCbXaBAaOOZXs=;
        b=REN1k93SxnoPJn6pBnVicD4zJ87XZPrxTDyfe/KrNoTB2gD31iTiCpMrztf4WwFzTu
         vKdb8WBllKxdzyQVmEE7xbEIPQ3SYLkqyuDPvtbaV3D1NJ8GUlDQyjXtj2IUkF/YoNmL
         5e+heOpj3pn2m3Yg0fM5zydx2tboviJnVkgz1jFDq2ZCrTxSK5qookWO6CEpbr7Tb1bW
         AF3m9R1Okf+gNhz3Z1djVK0xiUc6Sj9bs7gBllIeDK48a6IBLVBCHadhpgALqGudXs0E
         z4JvIPH8dXu3OGWL5UifAje76FqYFwPEIfAwZngrsQ/RGy50e3xzSTKMqEORfI3Sdi5j
         J7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tJN0tRwpz7+Fx7B96HstVd6cbsperXlCbXaBAaOOZXs=;
        b=P1ZIzU3RONAFCX+JyvgTa6A+nt1vaiOba7sJEGph7csFf+2Vi0rDUj5i1WW7VojH4O
         kxFnkHUeyBOTvWclXmruRC0pUjrwupI3c62jA/IyDpv98TAvVG1N2W5XBA5OW7PNmo4L
         xCW7udckoAYJPc3RFzqZG+3iWXfJRG1m05Flzkq3MAu+i+TvWfA6MHcHsvxS5N8cRes0
         Ah06epSM9oU9ldRBeseGz0cMEtiI8UuyzdfZG3YSwwbOTGZf1ZHEyj+K75BR5TA/Xieb
         sKU9ST3zDhcUpxKhWBI9WeXxje480a6juqvFvVJEvvuW2pzxUGhNxUDLfeNxcWTYsCnw
         lnVA==
X-Gm-Message-State: AOAM5322epWZRQo9ktBLph0wIZpo0QDQrSaC/ubhRDENH3GFMmC2tff4
        kva4NHKON/612oFqyO4ODcIhrfHHd1lTCA==
X-Google-Smtp-Source: ABdhPJyQ8ucs6Bdf/5zQyE5kgVcUuOMLdPGYTluthuHwcDntWGev5CdGDxfcI+po+owQuVPSr8TXBA==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr2407497wru.90.1603367221108;
        Thu, 22 Oct 2020 04:47:01 -0700 (PDT)
Received: from [192.168.1.83] (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id 78sm3116675wmb.32.2020.10.22.04.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2020 04:47:00 -0700 (PDT)
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <21aca47e03c82a06e4ea1140b328a86d04d1f422.1603122023.git.asml.silence@gmail.com>
 <13c73e10-040f-9a0b-5396-b3f2a0c301b0@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH for-5.10] io_uring: remove req cancel in ->flush()
Message-ID: <97c154a6-1020-d5b0-7ff4-9777b6df13c7@gmail.com>
Date:   Thu, 22 Oct 2020 12:44:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <13c73e10-040f-9a0b-5396-b3f2a0c301b0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 22/10/2020 07:42, Xiaoguang Wang wrote:
>> Every close(io_uring) causes cancellation of all inflight requests
>> carrying ->files. That's not nice but was neccessary up until recently.
>> Now task->files removal is handled in the core code, so that part of
>> flush can be removed.
> I don't catch up with newest io_uring codes yet, but have one question about
> the initial implementation "io_uring: io_uring: add support for async work
> inheriting files": https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fcb323cc53e29d9cc696d606bb42736b32dd9825
> There was such comments:
> +static int io_grab_files(struct io_ring_ctx *ctx, struct io_kiocb *req)
> +{
> +       int ret = -EBADF;
> +
> +       rcu_read_lock();
> +       spin_lock_irq(&ctx->inflight_lock);
> +       /*
> +        * We use the f_ops->flush() handler to ensure that we can flush
> +        * out work accessing these files if the fd is closed. Check if
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> I wonder why we only need to flush reqs specifically when they access current->files, are there
> any special reasons?
We could have taken a reference to ->files, so it doesn't get freed
while a request is using it, but that creates a circular dependency.

IIUC, because if there are ->files refs io_uring won't be closed on exit,
but io_uring would be holding ->files refs.

So, it was working without taking ->files references (i.e. weak refs)
on the basis that the files won't be destroyed until the task itself is
gone, and we can *kind of* intercept when task is exiting by ->flush()
and cancel all requests with ->files there.

-- 
Pavel Begunkov
