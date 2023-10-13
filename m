Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19AE67C7B15
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 03:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjJMBNY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Oct 2023 21:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjJMBNX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Oct 2023 21:13:23 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D57CCC
        for <io-uring@vger.kernel.org>; Thu, 12 Oct 2023 18:13:21 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6b390036045so4503b3a.1
        for <io-uring@vger.kernel.org>; Thu, 12 Oct 2023 18:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697159601; x=1697764401; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AMJnEzubrAnZX3cVNcFw4aHCDFoa3PCcaOxjV6VRS+0=;
        b=HS+h4Wa+IMVdFNCYi7/E0nXCEJ1TZmq/beUe+MUTtTEz9k+LNI72O23j3yAqrIGCAk
         eGlTxrVhgYNU6P3aiD++90HTaT+0JCZp4hiF4npfLZBUZ13gtjjbqS2a5gKqJ9/x/Kk4
         eRfTTZNZQfB70JGf+/YVk4v8k3kj/Vc07za/DukVP3HDPBaw39Fyb/F4EYpxJIGpgVWw
         F0E4vzTHXTUqISzY8Fk8WrmEn7Z2PCml5eqxiWBzZg2zx5M69ZIbGTnL/rDTHLbU4x0H
         vio3fLQYqttWGLtq0m9AvOgact3R7wNBIuxc7PYawZ3k0W88kCq3c7dybu118RTTBMkQ
         OFlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697159601; x=1697764401;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AMJnEzubrAnZX3cVNcFw4aHCDFoa3PCcaOxjV6VRS+0=;
        b=tdFSZSGWyCWiNnkE23CFcrXcMrspYcjQhDBQ+HuB8s4eZDMtbFPiJhe6eHAB7PthBr
         REv5CGGbAESKvnLpSQREB5phCXgLYw2QhjypJoiveIXNZmfpctrU2gXQnm7a7z+LW2hK
         nO6P2kK4bwKV0suV6LyGLRfVxRvr8wGjEqnoiKyaAagwTJP3DAE7XWzEGBBUg4u+krvL
         N07d+ui27jT2XIXakF+Km/jfkx0Dwimc4R90ntvIqLDOmubw4KYOqFExEozleuxhcHx1
         rpzH6P1Tx+I8tkbeyw+NCi1ky2v8BqrHi/xzc58HFgFmFI1JmV3EgA50l878kNunI4Dc
         TGaw==
X-Gm-Message-State: AOJu0YwUAmO5kZE3NZutbI59/bTObwJQ7YWDVvhVhz8bPguQEHN0T/Q2
        QY2TTzOIf7AydI4hbeIA1ZPn8A==
X-Google-Smtp-Source: AGHT+IGc+d2JugU+MHcVUHJCaPcCzHDdV/urgEHeZ1XguR5+TY2m8N4g6nJqszpdq75fyut+u173Ew==
X-Received: by 2002:a05:6a20:7d85:b0:163:57ba:2ad4 with SMTP id v5-20020a056a207d8500b0016357ba2ad4mr30560645pzj.2.1697159600617;
        Thu, 12 Oct 2023 18:13:20 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id jj3-20020a170903048300b001c9cc44eb60sm2610748plb.201.2023.10.12.18.13.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 18:13:19 -0700 (PDT)
Message-ID: <8b200d4c-6c28-47f6-b43d-98ed10a9b4f5@kernel.dk>
Date:   Thu, 12 Oct 2023 19:13:18 -0600
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
 <d729781a-3d12-423b-973e-c16fdbcbb60b@kernel.dk>
 <20231012133407.GA3359458@pengutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20231012133407.GA3359458@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/12/23 7:34 AM, Sascha Hauer wrote:
> On Tue, Oct 10, 2023 at 08:28:13AM -0600, Jens Axboe wrote:
>> On 10/10/23 8:19 AM, Sascha Hauer wrote:
>>> Hi,
>>>
>>> I am working with a webserver using io_uring in conjunction with KTLS. The
>>> webserver basically splices static file data from a pipe to a socket which uses
>>> KTLS for encryption. When splice is done the socket is closed. This works fine
>>> when using software encryption in KTLS. Things go awry though when the software
>>> encryption is replaced with the CAAM driver which replaces the synchronous
>>> encryption with a asynchronous queue/interrupt/completion flow.
>>>
>>> So far I have traced it down to tls_push_sg() calling tcp_sendmsg_locked() to
>>> send the completed encrypted messages. tcp_sendmsg_locked() sometimes waits for
>>> more memory on the socket by calling sk_stream_wait_memory(). This in turn
>>> returns -ERESTARTSYS due to:
>>>
>>>         if (signal_pending(current))
>>>                 goto do_interrupted;
>>>
>>> The current task has the TIF_NOTIFY_SIGNAL set due to:
>>>
>>> io_req_normal_work_add()
>>> {
>>>         ...
>>>         /* This interrupts sk_stream_wait_memory() (notify_method == TWA_SIGNAL) */
>>>         task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
>>> }
>>>
>>> The call stack when sk_stream_wait_memory() fails is as follows:
>>>
>>> [ 1385.428816]  dump_backtrace+0xa0/0x128
>>> [ 1385.432568]  show_stack+0x20/0x38
>>> [ 1385.435878]  dump_stack_lvl+0x48/0x60
>>> [ 1385.439539]  dump_stack+0x18/0x28
>>> [ 1385.442850]  tls_push_sg+0x100/0x238
>>> [ 1385.446424]  tls_tx_records+0x118/0x1d8
>>> [ 1385.450257]  tls_sw_release_resources_tx+0x74/0x1a0
>>> [ 1385.455135]  tls_sk_proto_close+0x2f8/0x3f0
>>> [ 1385.459315]  inet_release+0x58/0xb8
>>> [ 1385.462802]  inet6_release+0x3c/0x60
>>> [ 1385.466374]  __sock_release+0x48/0xc8
>>> [ 1385.470035]  sock_close+0x20/0x38
>>> [ 1385.473347]  __fput+0xbc/0x280
>>> [ 1385.476399]  ____fput+0x18/0x30
>>> [ 1385.479537]  task_work_run+0x80/0xe0
>>> [ 1385.483108]  io_run_task_work+0x40/0x108
>>> [ 1385.487029]  __arm64_sys_io_uring_enter+0x164/0xad8
>>> [ 1385.491907]  invoke_syscall+0x50/0x128
>>> [ 1385.495655]  el0_svc_common.constprop.0+0x48/0xf0
>>> [ 1385.500359]  do_el0_svc_compat+0x24/0x40
>>> [ 1385.504279]  el0_svc_compat+0x38/0x108
>>> [ 1385.508026]  el0t_32_sync_handler+0x98/0x140
>>> [ 1385.512294]  el0t_32_sync+0x194/0x198
>>>
>>> So the socket is being closed and KTLS tries to send out the remaining
>>> completed messages.  From a splice point of view everything has been sent
>>> successfully, but not everything made it through KTLS to the socket and the
>>> remaining data is sent while closing the socket.
>>>
>>> I vaguely understand what's going on here, but I haven't got the
>>> slightest idea what to do about this. Any ideas?
>>
>> Two things to try:
>>
>> 1) Depending on how you use the ring, set it up with
>> IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN. The latter will
>> avoid using signal based task_work notifications, which may be messing
>> you up here.
>>
>> 2) io_uring will hold a reference to the file/socket. I'm unsure if this
>> is a problem in the above case, but sometimes it'll prevent the final
>> flush.
>>
>> Do you have a reproducer that could be run to test? Sometimes easier to
>> see what's going on when you can experiment, it'll save some time.
> 
> Okay, here is a reproducer:
> 
> https://github.com/saschahauer/webserver-uring-test.git
> 
> Execute ./prepare.sh in that repository, it will compile the webserver,
> generate cert.pem/key.pem and generate some testfile to download. If the
> meson build doesn't work for you then you can compile the program by
> hand with something like:
> 
> gcc -O3 -Wall -o webserver webserver_liburing.c -lcrypto -lssl -luring
> 
> When the webserver is started you can get a file from it with:
> 
> curl -k https://<ipaddr>:8443/foo -o foo
> 
> or:
> 
> while true; do curl -k https://<ipaddr>:8443/foo -o foo; if [ $? != 0 ]; then break; fi; done
> 
> This should run without problems as by default likely the encryption
> requests are running synchronously.
> 
> In case you don't have encryption hardware you can create an
> asynchronous encryption module using cryptd. Compile a kernel with
> CONFIG_CRYPTO_USER_API_AEAD and CONFIG_CRYPTO_CRYPTD and start the
> webserver with the '-c' option. /proc/crypto should then contain an
> entry with:
> 
>  name         : gcm(aes)
>  driver       : cryptd(gcm_base(ctr(aes-generic),ghash-generic))
>  module       : kernel
>  priority     : 150
> 
> Make sure there is no other module providing gcm(aes) with a priority higher
> than 150 so that this one is actually used.
> 
> With that the while true loop above should break out with a short read
> fairly fast. Passing IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN
> to io_uring_queue_init() makes it harder to reproduce for me. With that
> I need multiple shells in parallel running the above loop.
> 
> The repository also contains a kernel patch which will provide you a
> stack dump when KTLS gets an error from tcp_sendmsg_locked().
> 
> Now I hope I haven't done anything silly in the webserver ;)

Perfect! Thanks a lot for preparing all of that. Not sure I'll get to it
tomorrow, but if not, then definitely on Monday.

-- 
Jens Axboe

