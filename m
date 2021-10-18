Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E78943191C
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 14:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhJRMd2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 08:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231615AbhJRMd2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 08:33:28 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACA3C06161C
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:31:16 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id a140-20020a1c7f92000000b0030d8315b593so10183039wmd.5
        for <io-uring@vger.kernel.org>; Mon, 18 Oct 2021 05:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=g9fbek1cwvxne5p5ULk6BZ8lH6Jbj56STRDyTqbr+EA=;
        b=c1QEI/o0SlmtEEZe8Y1xOIG2X+WzjH2w/d9/qsUCRl1OjHCfvJ1FxG1E1rgG1kZY4u
         7M3Sxm/1h1I/Unx5x7jOtKQVUMM9zWMzLn9kYJEX/TueCMj8CDedrIiXzJYMZSPZpKwe
         HHBMmtRmdqfSJH5SvxJA/luzWcrwXMlxkA8l4unVCWym2BjExiAN+dB1SkoVpmiKXXba
         IPgIW6KYkM1GvsorKJZi6vn6+ERzLnSAvyfTehyLWZubIJAMt0jHdpIOReMSsJUrmjph
         R0OHuUPTavm9iUWpvXcNjqn5Q8SixUwMBPiiFz5O0WGm+UKVq6FNzC0tC3PeGgTQx7Oh
         FdxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=g9fbek1cwvxne5p5ULk6BZ8lH6Jbj56STRDyTqbr+EA=;
        b=AyX+0Gz3brNBgz4/mTfj7ZDSHkoTyJyNuxqg3hVxMnz13dXfeB7Zleko9EyvwDexwZ
         e9Gb+P8N9KJLLZ4oCoYbjkoQCb2U2zuECPj5W6S5hs26pXyXm608f8fgYIFFuZdHnzu4
         nwr5BBOMRxUxJxuRUGpSnCNIllszzts5vLNDiFLWfFC2W4hFnh77BBqvkt3fd/0cgRQz
         Yv2jVL+zUC8PIpMkaBZG49bPNWfUS3FTVMuBZLu/I8mjKnXQrQWL7+X1Ac3DUv9Hh0E/
         B0chsPZei1o3YYgbRPxot384hz71UwukPrIjzFgqRU351HY/PFghNRQ/mujnwvgY7MJh
         WAsw==
X-Gm-Message-State: AOAM5303JUoH+WsNIbCVjdVPRBagU9vIAc2TBJG6tsmUPguN6TGpboZ7
        m128LH18QPZtC+sw0kzLx4w=
X-Google-Smtp-Source: ABdhPJwWHM7C5igm3N+2IEX2AHpwG1tq/oa+9h1hrYlWiY1mNXZzarkooSw0EIAnsn+Ya3Tk5vTXOg==
X-Received: by 2002:a7b:c0d6:: with SMTP id s22mr30832093wmh.135.1634560275611;
        Mon, 18 Oct 2021 05:31:15 -0700 (PDT)
Received: from [192.168.43.77] (82-132-230-135.dab.02.net. [82.132.230.135])
        by smtp.gmail.com with ESMTPSA id l13sm12401316wrn.79.2021.10.18.05.31.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 05:31:15 -0700 (PDT)
Message-ID: <7a0d4182-6e08-99b9-ffca-483023f7a15f@gmail.com>
Date:   Mon, 18 Oct 2021 12:31:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 0/2] async hybrid for pollable requests
Content-Language: en-US
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Joseph Qi <joseph.qi@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211018112923.16874-1-haoxu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/18/21 11:29, Hao Xu wrote:
> 1/2 is a prep patch. 2/2 is the main one.
> The good thing: see commit message.
> the side effect: for normal io-worker path, added two if and two local
> variables. for FORCE_ASYNC path, added three if and several dereferences
> 
> I think it is fine since the io-worker path is not the fast path, and
> the benefit of this patchset is worth it.

We don't care about overhead in iowq, but would be better to get rid
of the in_worker in io_read(). See comments to 1/2.

Btw, you told that it performs better comparing to normal
IOSQE_ASYNC. I'm confused, didn't we agree that it can be
merged into IOSQE_ASYNC without extra flags?

> 
> Btw, we need to tweak the io-cancel.c a bit, not a big problem.
> liburing tests will come later.
> 
> v1-->v2:
>   - split logic of force_nonblock
>   - tweak added code in io_wq_submit_work to reduce overhead
>   from Pavel's commments.
> 
> Hao Xu (2):
>    io_uring: split logic of force_nonblock
>    io_uring: implement async hybrid mode for pollable requests
> 
>   fs/io_uring.c                 | 85 ++++++++++++++++++++++++++---------
>   include/uapi/linux/io_uring.h |  4 +-
>   2 files changed, 66 insertions(+), 23 deletions(-)
> 

-- 
Pavel Begunkov
