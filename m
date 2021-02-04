Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D4630F186
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 12:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbhBDLEw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 06:04:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbhBDLEm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 06:04:42 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07567C061786
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 03:04:02 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 190so2754958wmz.0
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 03:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NpfGcECI8Ufex/AG35t3VfKC6jRSs/vdtcnRxjn2nXo=;
        b=eiHKdLshKzYt0V3WD8Y9SYLuokLiq3d8zaDGEtNrEcvGni4cE5bVu5Co6xxb3QHlHA
         34zEO83H7Phr4weW9/g4fQ9ztXVYbyIkZ4YW0wev/P8lqj1BduZEplf8JHM9/zOekvem
         mDgZU/BmslZ86nYm4qzUMO7kCH9t25DvhP46pj91iIdTw/4eWB6UKP7800ARZsXIfVtI
         zH+Fyr/6ZehS79mIXFEwnOEjIpLIXx2/suPrKd2PenpXQFmaGKjNS0WGlQimwGvkSl5e
         JACRQrr0F/Bg9GQ9DxT/u5Tke9ZI6ILv4BAU1etOM4vY21pff4FrrV960V09uhyXi7RU
         hKAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NpfGcECI8Ufex/AG35t3VfKC6jRSs/vdtcnRxjn2nXo=;
        b=VQtn37lU5dg4FAhOMXs2DK2hBB03Th11qFwTaVE83swOp7pN3dUQ3kBQpfU2GETv1v
         qPD0MoHxNtcwi+BohP5QDGdMQEIkVIEbQeafBwsX2vhmtEE4fevGVY5wne47MK6daClY
         wRoix8U3l2OIGq5thzg4hRH77gRHzfwlo/yQ/OqMvF+wy6rMvKupe4Xpn1XinitMWy2a
         0/hsFiY7S2sTVAlEqvRqJHGSSTdhq9p7tVZrg/DA1KV2x8kLVYJMGV0NUMIjI6QIA3aB
         yNHEYDFEbcgba8pcRAHwlcSN6/2+SSDuVxpJdbD2G9zCYL5cQT0Nty7Si3sr6WX3H4CJ
         CeeQ==
X-Gm-Message-State: AOAM530HKhqeyyd50XEbHpu/5lYZ6r/zs+Wc9eS59H4i/54/8saemz7H
        0e3sabDse8XFfmNC7zSdSZRyq0n8Ms0MAg==
X-Google-Smtp-Source: ABdhPJxZwkZTWAsnW7fesAvwlZAz3AcUV+P4TubXhbatLcJZJPoCR4n8iAgWy59IW8ZWfyDN9hW8kw==
X-Received: by 2002:a1c:2ec2:: with SMTP id u185mr6874238wmu.83.1612436640811;
        Thu, 04 Feb 2021 03:04:00 -0800 (PST)
Received: from [192.168.8.171] ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id o14sm7088960wri.48.2021.02.04.03.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 03:04:00 -0800 (PST)
To:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <63d16aae-1ca7-8939-1c8a-89c600be8462@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Queston about io_uring_flush
Message-ID: <51499dcc-5991-e177-98c4-8cc8a909da70@gmail.com>
Date:   Thu, 4 Feb 2021 11:00:16 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <63d16aae-1ca7-8939-1c8a-89c600be8462@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/02/2021 09:31, Hao Xu wrote:
> Hi all,
> Sorry for disturb all of you. Here comes my question.
> When we close a uring file, we go into io_uring_flush(),
> there is codes at the end:
> 
> if (!(ctx->flags & IORING_SETUP_SQPOLL) || ctx->sqo_task == current)
>    io_uring_del_task_file(file);
> 
> My understanding, this is to delete the ctx(associated with the uring
> file) from current->io_uring->xa.
> I'm thinking of this scenario: the task to close uring file is not the
> one which created the uring file.
> Then it doesn't make sense to delete the uring file from current->io_uring->xa. It should be "delete uring file from
> ctx->sqo_task->io_uring->xa" instead.

1. It's not only about created or not, look for
io_uring_add_task_file() call sites.

2. io_uring->xa is basically a map from task to used by it urings.
Every user task should clean only its own context (SQPOLL task is
a bit different), it'll be hell bunch of races otherwise.

3. If happens that it's closed by a task that has nothing to do
with this ctx, then it won't find anything in its
task->io_uring->xa, and so won't delete anything, and that's ok.
io_uring->xa of sqo_task will be cleaned by sqo_task, either
on another close() or on exit() (see io_uring_files_cancel).

4. There is a bunch of cases where that scheme doesn't behave
nice, but at least should not leak/fault when all related tasks
are killed.

-- 
Pavel Begunkov
