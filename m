Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64804039F4
	for <lists+io-uring@lfdr.de>; Wed,  8 Sep 2021 14:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236060AbhIHMfp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Sep 2021 08:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbhIHMfo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Sep 2021 08:35:44 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CC8C061575
        for <io-uring@vger.kernel.org>; Wed,  8 Sep 2021 05:34:37 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id g9so2941381ioq.11
        for <io-uring@vger.kernel.org>; Wed, 08 Sep 2021 05:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gjlBaNGKVlbVhDCNUk2JDMe9wx2NO2QVKH1Sf+7SF7k=;
        b=03h8g+HATiSMM8RtTAOvVXLRCat6G8nDan0Wkr76O9crOBstec6a9j9cTI3I2Mwmvz
         qNYfXdsuY9wBJXQL2UFDrVcYuuMWgKP8ndrnXbjtXoV4ofe4atqay6u/cUT9PBn7hKZr
         WoLhuNuCXlJrgRsdoRopm/dPx6Pm4U20hDNXZr0vMKnq3eLNzIcxwZBGRHRjga1vyhp8
         j0AfLtZkzJQ6wdcL98v09opNroGmJ1lTNw7JbvU07IqPK2vU9dFybBU3SsE1bY0oyVwJ
         D4nGb32F+LPhmSo73EBh3jcAeTMnVqVyY9b6cSOV4Eo8hrXUzZZ2GwE6PPXoAJVGzL1b
         0Vng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gjlBaNGKVlbVhDCNUk2JDMe9wx2NO2QVKH1Sf+7SF7k=;
        b=ZKmcw7QCvNuPEBNgZpsCJV9Vxe4Vx3/7nY98GAmhKWcvLGnt+zZAG88a+YMmtZWThI
         2XRcpUygTETVsJBAvmgyYh90H9I6XckL+ocU+ClKjZPVirIrdXjH3f6wnoqEYADuGmFb
         s6BmTAESkCVWirkrlqmLAbsu07mgYHj2sUX7Ml4ZE/JI39GwIRlCunWSf6egVt9lnqTl
         t97RwVeXd1pndTrhsDEXUF3U2zq2J/23yfqNE/P6k0D3tCNjOvbwdO75ifHWMD6dnHx2
         OdtuV+wq29mAqzMoCMPooBbXLKFnF3dVz2wTQ6ojLu4EjqxZi+x2xWTdlxD6OQlkMQ51
         vFnQ==
X-Gm-Message-State: AOAM530IwwPtUY9nMOgeg2yJ0FV9NANnkgHtn+1thTVaTxZUhonbBXoB
        xNUzTNQjQjCZNfU496746rkcOA==
X-Google-Smtp-Source: ABdhPJzZtLYIPK5bU6IdXAl9fsXF3+88KgQ1q8y0ILXUmrCk3nbCAe9BUPiYzAJt3V4OQPkodHpbiQ==
X-Received: by 2002:a6b:7710:: with SMTP id n16mr3047253iom.101.1631104476736;
        Wed, 08 Sep 2021 05:34:36 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id f3sm968149ilu.85.2021.09.08.05.34.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Sep 2021 05:34:36 -0700 (PDT)
Subject: Re: [PATCH] io-wq: fix cancellation on create-worker failure
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Hao Sun <sunhao.th@gmail.com>
References: <93b9de0fcf657affab0acfd675d4abcd273ee863.1631092071.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <8462bdb5-a323-2eb2-ef1c-4e10ac7876dc@kernel.dk>
Date:   Wed, 8 Sep 2021 06:34:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <93b9de0fcf657affab0acfd675d4abcd273ee863.1631092071.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/8/21 3:09 AM, Pavel Begunkov wrote:
> WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151 req_ref_put_and_test
> fs/io_uring.c:1151 [inline]
> WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151 req_ref_put_and_test
> fs/io_uring.c:1146 [inline]
> WARNING: CPU: 0 PID: 10392 at fs/io_uring.c:1151
> io_req_complete_post+0xf5b/0x1190 fs/io_uring.c:1794
> Modules linked in:
> Call Trace:
>  tctx_task_work+0x1e5/0x570 fs/io_uring.c:2158
>  task_work_run+0xe0/0x1a0 kernel/task_work.c:164
>  tracehook_notify_signal include/linux/tracehook.h:212 [inline]
>  handle_signal_work kernel/entry/common.c:146 [inline]
>  exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
>  exit_to_user_mode_prepare+0x232/0x2a0 kernel/entry/common.c:209
>  __syscall_exit_to_user_mode_work kernel/entry/common.c:291 [inline]
>  syscall_exit_to_user_mode+0x19/0x60 kernel/entry/common.c:302
>  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> When io_wqe_enqueue() -> io_wqe_create_worker() fails, we can't just
> call io_run_cancel() to clean up the request, it's already enqueued via
> io_wqe_insert_work() and will be executed either by some other worker
> during cancellation (e.g. in io_wq_put_and_exit()).

Oops yes, that looks better. Thanks, applied.

-- 
Jens Axboe

