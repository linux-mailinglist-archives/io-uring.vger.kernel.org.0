Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456A742420A
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 18:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbhJFQCv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 12:02:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231267AbhJFQCv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 12:02:51 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B581C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 09:00:59 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id h189so512372iof.1
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 09:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2FS4nSJzQqOYh0reoNhy2zN6tIGomM2XaFkQsCyCnds=;
        b=q6QDPR2lZbiQmSmT2852CE/IgW3WcxTkai6Np6yEnFwxJvKJQhTYBLKeL2PPlX5y53
         zBoqoHUB9OJGkuu0h7KpWQrQB1ZyTpSN5P3SBAX/H9LXi6J0TGQYJYTcPhDIsJI658np
         Pg/nJ0uEgAda4q5jL45HtqnaIo3/rrm8JySMhV7n4KibeAgDgJLYA/bwjl4arp/4nT6D
         rpgVSh9synSz8ryXiUztvK3T5MAH7iHa7QX8jvyfwrzs+qsNsfb4o7PnBPfy2t/9JlE0
         OKDqly0WSfDyuKMihDPhhWXDpoBRXvA6/HZifmo6UXuBrjlwSbEvgNj0kuN5hzdvRzL9
         5khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2FS4nSJzQqOYh0reoNhy2zN6tIGomM2XaFkQsCyCnds=;
        b=5MVR4NVpvSnMO47nDE0xVEVCVO5c5Mqz+F6nWWqDRC5a7Ib3lHutW0X6C+5woyOa7S
         e8mIXFiQNicF1/CAA+Kz7l/IITHG8rKSHG4ALNtT+deX0gD2+P59KtjZpRNchhHFEIcG
         G7sKGROADykpbpxk+No6jvS4HsdVdZ0NXt6VgQioUn+lBXO+K3jcPz50oe4AZgFSULVY
         5AvklosuKVkKVbLFNW8VoKd42DlwwAe4BrPSIiq22ahavXg27x+isKXGFlWe0zem74Dq
         mwLNf3cPIOkZrWPsTPw1BXKZ2wzI0U0vJbzATlGXM7L8LeUTcPsoaaaB0h+UPORrTtUa
         dYdw==
X-Gm-Message-State: AOAM530bxyg4rPbVuDANEK7y8zgqwvQZ6EU5Ccxj6afzl2H7rg38MV4X
        ypZZP3lEUGqG43zs3TzKtzEysyK1ltxV8i8N08k=
X-Google-Smtp-Source: ABdhPJy58t2MTgVFrsOHAkYX3heQAekMVW/B35vzdvukQ2MUr78J4DO+RkjR6n24XQZsEHZkWmhGtQ==
X-Received: by 2002:a05:6602:3311:: with SMTP id b17mr7005595ioz.47.1633536058345;
        Wed, 06 Oct 2021 09:00:58 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d1sm12427818ion.47.2021.10.06.09.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 09:00:58 -0700 (PDT)
Subject: Re: [RFC] io_uring: print COMM on ctx_exit hang
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <77c68af25c707073c2708465ae576f1a231cf961.1633533200.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <af016bf7-b953-21fb-a7ed-eccb32f84517@kernel.dk>
Date:   Wed, 6 Oct 2021 10:00:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <77c68af25c707073c2708465ae576f1a231cf961.1633533200.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/6/21 9:15 AM, Pavel Begunkov wrote:
> io_ring_exit_work() hangs are hard to debug partly because there is not
> much information of who created the ctx by the time it's exiting, and
> the function is running in a wq context, so the task name tells us
> nothing. Save creator's task comm and print it when it hangs.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
> 
> Just for discussion, I hope there are better ways of doing it.
> 
> It leaves out the second wait_for_completion() in io_ring_exit_work(),
> which is of interest, so would be great to cover the case as well.

I've done identical patches in the past myself, and I don't think
there's a better way to do this. The task may be long gone, so we have
to capture it upfront.

-- 
Jens Axboe

