Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF5333FB6A
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbhCQWmw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhCQWmv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:42:51 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A90C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:42:51 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id u10so3087847ilb.0
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:42:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=2aPD0mmmIMzcgYXYl5/1ynYMPLsxJtrI6V7bN8YS/kc=;
        b=mdbaBkTiSOZUjtpcB8BXfxTdVP6vwS0RmQnIcswFsy7kx3xXBbJzOU5z+pvvyGPwO2
         u9i8X24gA0D2GyVJVkkAO1Xoew45J+nDxmNtI3qbiE9CCLyoyXGDthccVRX6s7hJUbRQ
         wo2uygeRJ2vfsAQ3KdFpdTgNKa/fmbT3dgnbOoDTY0G25UB7BGWsMIr/8n2avHC9D3xk
         XSjPKrC0Bdwlt3Gl92V6tVFEM5Du8c9YW8rQB71MeOrzyea+9Bc4YH061fdqC2rxS6jO
         MWORosYqmKj5YDTqjAVZfGNVWtKsy21x2uV01MYBKtkfNXcfcxKugPeKesh6dDoMKbd/
         GMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2aPD0mmmIMzcgYXYl5/1ynYMPLsxJtrI6V7bN8YS/kc=;
        b=OcnyaB9nKdRr2RjX2L+UPrf0uRxGviJQcUV8Zwgb38DMRsSHOQScFn1JZnvrFL1R3H
         Bk3+ZlKLyMejg03D0VtvP5e6teGrx/gFsdT3X+opAziAMI/raujMCk2WbuGnlBRm1O1R
         zcF+HPY64uD54s22cxCXlZTDZUnHqo27PR0Sek7tv3FTRyqujOgKo8uylsX2uhRQ5OqA
         PlfJdLMLk3FYi6MlfrA32GZQIDpRn4WFPFCjVzf9f5mtxfmGrqLLnPh2IaaYTOmALODY
         EAhLcwcSA8RZ8iew0FbmPyq6U+lL97jgum5G11KUjrGH0YJvWaM0MssW8GrHLwJEzgC+
         ZCVA==
X-Gm-Message-State: AOAM531URvz2GQhnwCLY7LF0h2qnqZGMrScGpQ17udmibBpg2dAJT8/e
        c3G9F4BloFJ1S9JRSBN57Q2Q3HrOr/x/Gw==
X-Google-Smtp-Source: ABdhPJzQdGVDlwu3/WRBzdTdFgO5eDPk6OEwl+Lng5lph8xiIYTTEKLdT1P/0r9kW+9UHVbl1nVZHg==
X-Received: by 2002:a92:ce4e:: with SMTP id a14mr9487687ilr.219.1616020970621;
        Wed, 17 Mar 2021 15:42:50 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h12sm201051ilj.41.2021.03.17.15.42.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:42:50 -0700 (PDT)
Subject: Re: [RFC PATCH 00/10] Complete setup before calling
 wake_up_new_task() and improve task->comm
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
References: <cover.1615826736.git.metze@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <60a6919e-259b-fcc8-86fd-d85105545675@kernel.dk>
Date:   Wed, 17 Mar 2021 16:42:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1615826736.git.metze@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/15/21 11:01 AM, Stefan Metzmacher wrote:
> Hi,
> 
> now that we have an explicit wake_up_new_task() in order to start the
> result from create_io_thread(), we should things up before calling
> wake_up_new_task().
> 
> There're also some improvements around task->comm:
> - We return 0 bytes for /proc/<pid>/cmdline
> - We no longer allow a userspace process to change
>   /proc/<pid>/[task/<tid>]/comm
> - We dynamically generate comm names (up to 63 chars)
>   via io_wq_worker_comm(), similar to wq_worker_comm()
> 
> While doing this I noticed a few places we check for
> PF_KTHREAD, but not PF_IO_WORKER, maybe we should
> have something like a PS_IS_KERNEL_THREAD_MASK() macro
> that should be used in generic places and only
> explicitly use PF_IO_WORKER or PF_KTHREAD checks where the
> difference matters.
> 
> There are also quite a number of cases where we use
> same_thread_group(), I guess these need to be checked.
> Should that return true if userspace threads and their iothreds
> are compared?
> 
> I've compiled but didn't test, I hope there's something useful...

Looks pretty good to me. Can I talk you into splitting this into
a series for 5.12, and then a 5.13 on top? It looks a bit mixed
right now. For 5.12, basically just things we absolutely need for
release. Any cleanups or improvements on top should go to 5.13.

-- 
Jens Axboe

