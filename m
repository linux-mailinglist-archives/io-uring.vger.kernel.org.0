Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1A07BFF45
	for <lists+io-uring@lfdr.de>; Tue, 10 Oct 2023 16:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjJJO2X (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Oct 2023 10:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233146AbjJJO2T (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Oct 2023 10:28:19 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C406D7
        for <io-uring@vger.kernel.org>; Tue, 10 Oct 2023 07:28:16 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id ca18e2360f4ac-79fc70bf3d5so24177239f.0
        for <io-uring@vger.kernel.org>; Tue, 10 Oct 2023 07:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1696948095; x=1697552895; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dx7+LG7mYX9BTitvmIG4HE31VO7H02xUOTQXSaCvMEk=;
        b=v/TQlyIm1c05rSyHGYW/7Ic+rCNk2jY9j8FfKmu7j/WfWkOTwhp2vn6ycfgWSDDZje
         0HGuo+yiiFxfMWEbof60l1WE7pivWZb9x77VpHog7dly/TaQSgVm5oUz63hY2xV3AvGu
         rZla9/aqCLpvLbfyxAuBa+1quqQDbHZFupaad0igDVEW+ay9GFP6PJ8G/RmxR0iqAXsy
         PWwsQ5Lu227siyWiaXaYKF5J8CDPHccIsjA3ylBJZ0S9ybzQXcPpAr8qbu2aAGw1vNMF
         dH89c0MjNbJBc6T4c5tWCVSEcAFSUhMSDYKr5HmWJEUN3R3yq9UTl6hJJ7c71rj9sVi2
         brnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696948095; x=1697552895;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dx7+LG7mYX9BTitvmIG4HE31VO7H02xUOTQXSaCvMEk=;
        b=RNM1WWplVtIhxlL/SLfmFDXjZQvW0ZkEU7P2aNybGWel+dgjxdXqXSJRZDxZUAMWF7
         Cf+f0aBdyIVCRXqa2/MZEhNoEtQZF7xb8W/VWLW8ws6ABnAyj9QVYYkT3gExVUTpggbZ
         UIMlcVxp0p6PDArGR6+/mu9YnidzIxKdMHMTE6Jn8ALHSR/tD5l6Hxn/24BoUCscqHbi
         d0OeOvkuq7oizGm+oJFTgDnajrFSdb1jXHvWelm/YluQTFNiPOsAWHkF1DQv/1UMt+BO
         If1Sl0RQ+0NS7dPapOF5lzq9JClaAySbkUAnIZsB82C2DigY/urlJqOO0atXjyyK/5OG
         51fA==
X-Gm-Message-State: AOJu0Yx9P8VMRV0uTofeanuAIMC+6PtFvFIfOumId/6rqdDv1pJEjxOW
        cMWczkKFbktjJMM9eUeYMIduXA==
X-Google-Smtp-Source: AGHT+IGUXsKo6cw/Nkug7kahpa7eJEYtxewAvsi0Qgz43q8Y8SZV9Nkx+1sErVqFM5swJaP0uwKpXw==
X-Received: by 2002:a05:6602:2e03:b0:792:6068:dcc8 with SMTP id o3-20020a0566022e0300b007926068dcc8mr24180152iow.2.1696948095409;
        Tue, 10 Oct 2023 07:28:15 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k23-20020a5e8917000000b0077e3acd5ea1sm2933821ioj.53.2023.10.10.07.28.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Oct 2023 07:28:14 -0700 (PDT)
Message-ID: <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
Date:   Tue, 10 Oct 2023 08:28:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problem with io_uring splice and KTLS
Content-Language: en-US
To:     Sascha Hauer <sha@pengutronix.de>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20231010141932.GD3114228@pengutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231010141932.GD3114228@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/10/23 8:19 AM, Sascha Hauer wrote:
> Hi,
> 
> I am working with a webserver using io_uring in conjunction with KTLS. The
> webserver basically splices static file data from a pipe to a socket which uses
> KTLS for encryption. When splice is done the socket is closed. This works fine
> when using software encryption in KTLS. Things go awry though when the software
> encryption is replaced with the CAAM driver which replaces the synchronous
> encryption with a asynchronous queue/interrupt/completion flow.
> 
> So far I have traced it down to tls_push_sg() calling tcp_sendmsg_locked() to
> send the completed encrypted messages. tcp_sendmsg_locked() sometimes waits for
> more memory on the socket by calling sk_stream_wait_memory(). This in turn
> returns -ERESTARTSYS due to:
> 
>         if (signal_pending(current))
>                 goto do_interrupted;
> 
> The current task has the TIF_NOTIFY_SIGNAL set due to:
> 
> io_req_normal_work_add()
> {
>         ...
>         /* This interrupts sk_stream_wait_memory() (notify_method == TWA_SIGNAL) */
>         task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
> }
> 
> The call stack when sk_stream_wait_memory() fails is as follows:
> 
> [ 1385.428816]  dump_backtrace+0xa0/0x128
> [ 1385.432568]  show_stack+0x20/0x38
> [ 1385.435878]  dump_stack_lvl+0x48/0x60
> [ 1385.439539]  dump_stack+0x18/0x28
> [ 1385.442850]  tls_push_sg+0x100/0x238
> [ 1385.446424]  tls_tx_records+0x118/0x1d8
> [ 1385.450257]  tls_sw_release_resources_tx+0x74/0x1a0
> [ 1385.455135]  tls_sk_proto_close+0x2f8/0x3f0
> [ 1385.459315]  inet_release+0x58/0xb8
> [ 1385.462802]  inet6_release+0x3c/0x60
> [ 1385.466374]  __sock_release+0x48/0xc8
> [ 1385.470035]  sock_close+0x20/0x38
> [ 1385.473347]  __fput+0xbc/0x280
> [ 1385.476399]  ____fput+0x18/0x30
> [ 1385.479537]  task_work_run+0x80/0xe0
> [ 1385.483108]  io_run_task_work+0x40/0x108
> [ 1385.487029]  __arm64_sys_io_uring_enter+0x164/0xad8
> [ 1385.491907]  invoke_syscall+0x50/0x128
> [ 1385.495655]  el0_svc_common.constprop.0+0x48/0xf0
> [ 1385.500359]  do_el0_svc_compat+0x24/0x40
> [ 1385.504279]  el0_svc_compat+0x38/0x108
> [ 1385.508026]  el0t_32_sync_handler+0x98/0x140
> [ 1385.512294]  el0t_32_sync+0x194/0x198
> 
> So the socket is being closed and KTLS tries to send out the remaining
> completed messages.  From a splice point of view everything has been sent
> successfully, but not everything made it through KTLS to the socket and the
> remaining data is sent while closing the socket.
> 
> I vaguely understand what's going on here, but I haven't got the
> slightest idea what to do about this. Any ideas?

Two things to try:

1) Depending on how you use the ring, set it up with
IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN. The latter will
avoid using signal based task_work notifications, which may be messing
you up here.

2) io_uring will hold a reference to the file/socket. I'm unsure if this
is a problem in the above case, but sometimes it'll prevent the final
flush.

Do you have a reproducer that could be run to test? Sometimes easier to
see what's going on when you can experiment, it'll save some time.

-- 
Jens Axboe

