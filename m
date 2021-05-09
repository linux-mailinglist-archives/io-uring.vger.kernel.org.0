Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E08377516
	for <lists+io-uring@lfdr.de>; Sun,  9 May 2021 06:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhEIENO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 9 May 2021 00:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbhEIENO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 9 May 2021 00:13:14 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9257C061573
        for <io-uring@vger.kernel.org>; Sat,  8 May 2021 21:12:11 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b3so7530264plg.11
        for <io-uring@vger.kernel.org>; Sat, 08 May 2021 21:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RM2bChj9pn0yMcc/ie5wMlfs+0sO0si/PPTnJpYgDVg=;
        b=pDLOpuut/6EkoSk2QmjOaNXY4jBv02lpaWTB9MC2rJmtzaXoAlDJ1+wz27dxFBbQ22
         CG6NWgarhHUy0pEwb0FBKHU3OZYoOT805BZ75Nb1gWLxCGX1HEOpREcKpp1575Db1ey+
         b/NjZ7sI/dbFKZP+dgUDGvrAuy6fg1ta8nGTT9ut/y5Uew77b2FjtC+vJHNPzhk6zRpn
         tp/SDL5KJuD25X0YvRdVhihvkHtW/KPegEPPG0TJPzyPjR5XatAvkGILZSSM0Qu0qo+U
         PRKdjz9UHwU1d7ANb2NfhBWr/tzq1H3osbn1sqddMsxjBRj7gdfPmdEChVwX2BTVI51K
         HeAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RM2bChj9pn0yMcc/ie5wMlfs+0sO0si/PPTnJpYgDVg=;
        b=WQ8lbL8VszxiYcGvYRHTD7X01x+Vjjc1aViIR6RSYzRTJKbuNjmz4MoUjXdDrg02sI
         YZNRHiOyWbz3BKBfewRzxZChzMTfLrnqwZaI0OC8dSc7tFdmFeolUF55swMnjXZW3o8L
         ZIuyUuZKZTwsR7ajql3mZNMgMB6jczMUXXslZnEidRBujF/MSpIB7m+m1PujLg8pFG+7
         Y+nxju+dCUrGR8tGSkzPHJ1egwQ9/Qpav4banm3a6h4ZdSNeNQx5T7mNsoCMi+0TjjaN
         +lw5WT9wVe57dYJqCAG2nUv9RkysRqdsUy4fxGF8fz7DukUU+Y+V2XFj251CAfjigFfy
         tdFw==
X-Gm-Message-State: AOAM531BvqFEspS34Bi1JZkZM/Gn9m4lr6U0VhpQlEms8GyP1d5bxvEQ
        HZ5YbeUPiZZFoSjML1/jSY9mv+EUu4AcWQ==
X-Google-Smtp-Source: ABdhPJzF5BpWpJvdrlrN7yCsXWPL2hOTfhLqiQLR04Xi0wYp9oXwFgALCpI47xEqbYFBc/xS13T/hw==
X-Received: by 2002:a17:90a:c08c:: with SMTP id o12mr6104403pjs.108.1620533530788;
        Sat, 08 May 2021 21:12:10 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x19sm5052603pgk.88.2021.05.08.21.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 21:12:10 -0700 (PDT)
Subject: Re: [PATCH 1/1] io_uring: fix link timeout refs
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <cbc5ae0e-8c1f-aa32-ee94-2f65788abbe5@kernel.dk>
Date:   Sat, 8 May 2021 22:12:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ff51018ff29de5ffa76f09273ef48cb24c720368.1620417627.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/7/21 2:06 PM, Pavel Begunkov wrote:
> WARNING: CPU: 0 PID: 10242 at lib/refcount.c:28 refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> RIP: 0010:refcount_warn_saturate+0x15b/0x1a0 lib/refcount.c:28
> Call Trace:
>  __refcount_sub_and_test include/linux/refcount.h:283 [inline]
>  __refcount_dec_and_test include/linux/refcount.h:315 [inline]
>  refcount_dec_and_test include/linux/refcount.h:333 [inline]
>  io_put_req fs/io_uring.c:2140 [inline]
>  io_queue_linked_timeout fs/io_uring.c:6300 [inline]
>  __io_queue_sqe+0xbef/0xec0 fs/io_uring.c:6354
>  io_submit_sqe fs/io_uring.c:6534 [inline]
>  io_submit_sqes+0x2bbd/0x7c50 fs/io_uring.c:6660
>  __do_sys_io_uring_enter fs/io_uring.c:9240 [inline]
>  __se_sys_io_uring_enter+0x256/0x1d60 fs/io_uring.c:9182
> 
> io_link_timeout_fn() should put only one reference of the linked timeout
> request, however in case of racing with the master request's completion
> first io_req_complete() puts one and then io_put_req_deferred() is
> called.

Applied, thanks.

-- 
Jens Axboe

