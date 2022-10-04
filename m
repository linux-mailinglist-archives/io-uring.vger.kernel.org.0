Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62DA05F4510
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 16:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiJDODK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 10:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJDOC7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 10:02:59 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8735D11D
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 07:02:58 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g8so10585606iob.0
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 07:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=veSFG+pE7CS+m2su6zvynMVka/VajDWy7wGltkDD9Hw=;
        b=5k8OKLOhaRINEqqXVDFHhHw3Cg3fjzsUNG4Jg6D4ZKxgDanURG2DpIofyE31j8LwyU
         autyUdXnkuvEH0zn3kJ6CzXZ/z8csKIz1GiSl0vQyD1Y3LVIg/9Gr1SgNDrus4McOBPo
         lHmvQtEDVEZjeEI9uaGFQFV8MxaKvksPqcdi5bZ2snNGEyWYS9FvMVx6BpAFf742qGfa
         DP6Bs56DzGl0K+nk3gGbGm2NBCdaOJcnTuoeL2eBofPq7Le3jc0FaAoYjLu+pXSBwOBP
         T6XATYQnyYtU7PhRnZAHyO07YwnTaKLbFDg8Bp5Y2jCfMK6oa51IDlNd0CU0lFE/QlNq
         JVFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=veSFG+pE7CS+m2su6zvynMVka/VajDWy7wGltkDD9Hw=;
        b=UWqiWeEb9oy/Y5Q8xvF+itRQY7P56OI0sJ6jeeyKwiGyjPdAGQ/MksoSOkh2Xdk5Zx
         CydrfaUvWemVf1mfIQiUxosXzFOT5ZyV5/oFOcYS4EuepYmf1GIBuK7APTmY2hQGym8/
         YDT0iblyJUk0s3Nn6tQhUnXDCwxD/empkt8hQB1/U+i0O8X27GMH9e73+gjgqg3Mmyg5
         isvHIsnpvDqHVHhU9jrmKhZuGRTp8JpDMaJgUmLcBekpV1o5LdR7RBjGw2wnTbLjEOwo
         DE9hnNJ1XALgexVbkKR9I48gppHVOaqZasiSWrt7d3YITAQN9OxTFjaukAbrWwbqbPr4
         Y0mA==
X-Gm-Message-State: ACrzQf0IN0h8a8VrRodJmedeH1Cu9HDWPMdUK3wHWOpkMv4Ggyrz3rUG
        c8diYuThMojxhqWYnX6iWdLXFg==
X-Google-Smtp-Source: AMsMyM6uOsQrfCyDCCifEw4umZBjYyOgxegmWSmdP/kxMzjPUvZJ55XcduxvG3uythvzhqWmfBChTw==
X-Received: by 2002:a05:6638:262:b0:363:375e:4fdd with SMTP id x2-20020a056638026200b00363375e4fddmr4182199jaq.213.1664892177438;
        Tue, 04 Oct 2022 07:02:57 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id a5-20020a92a305000000b002f64fe8eb62sm4848785ili.45.2022.10.04.07.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 07:02:56 -0700 (PDT)
Message-ID: <feadeb4b-4ad8-7d7e-b78e-44300dbdcc93@kernel.dk>
Date:   Tue, 4 Oct 2022 08:02:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: Problematic interaction of io_uring and CIFS
Content-Language: en-US
To:     Fiona Ebner <f.ebner@proxmox.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>
Cc:     io-uring@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
 <20220708174815.3g4atpcu6u6icrhp@cyberdelia>
 <CANT5p=rSKRe_EXFmKS+qRyBo4i9Ko1pcgwxy-B1gugJtKjVAMA@mail.gmail.com>
 <CANT5p=qxYh+VxXpVGd2GO=WJoZ5J_p0oodN+wcFqC43t49pRqA@mail.gmail.com>
 <560586b2-8cd6-7a62-86f2-90e8968d0ad4@proxmox.com>
 <3ea2a6b3-d64d-744f-894b-66fee1242597@proxmox.com>
 <94ff5098-dd66-3c83-0810-d65c7153984d@proxmox.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <94ff5098-dd66-3c83-0810-d65c7153984d@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/4/22 2:59 AM, Fiona Ebner wrote:
> Am 26.08.22 um 10:21 schrieb Fiona Ebner:
>> Am 11.07.22 um 15:40 schrieb Fabian Ebner:
>>> Am 09.07.22 um 05:39 schrieb Shyam Prasad N:
>>>> On Sat, Jul 9, 2022 at 9:00 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>>
>>>>> On Fri, Jul 8, 2022 at 11:22 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>>>>>
>>>>>> On 07/08, Fabian Ebner wrote:
>>>>>>> (Re-sending without the log from the older kernel, because the mail hit
>>>>>>> the 100000 char limit with that)
>>>>>>>
>>>>>>> Hi,
>>>>>>> it seems that in kernels >= 5.15, io_uring and CIFS don't interact
>>>>>>> nicely sometimes, leading to IO errors. Unfortunately, my reproducer is
>>>>>>> a QEMU VM with a disk on CIFS (original report by one of our users [0]),
>>>>>>> but I can try to cook up something simpler if you want.
>>>>>>>
>>>>>>> Bisecting got me to 8ef12efe26c8 ("io_uring: run regular file
>>>>>>> completions from task_work") being the first bad commit.
>>>>>>>
>>
>> I finally got around to taking another look at this issue (still present
>> in 5.19.3) and I think I've finally figured out the root cause:
>>
>> After commit 8ef12efe26c8, for my reproducer, the write completion is
>> added to task_work with notify_method being TWA_SIGNAL and thus
>> TIF_NOTIFY_SIGNAL is set for the task.
>>
>> After that, if we end up in sk_stream_wait_memory() via sock_sendmsg(),
>> signal_pending(current) will evaluate to true and thus -EINTR is
>> returned all the way up to sock_sendmsg() in smb_send_kvec().
>>
>> Related: in __smb_send_rqst() there too is a signal_pending(current)
>> check leading to the -ERESTARTSYS return value.
>>
>> To verify that this is the cause, I wasn't able to trigger the issue
>> anymore with this hack applied (i.e. excluding the TIF_NOTIFY_SIGNAL check):
>>
>>> diff --git a/net/core/stream.c b/net/core/stream.c
>>> index 06b36c730ce8..58e3825930bb 100644
>>> --- a/net/core/stream.c
>>> +++ b/net/core/stream.c
>>> @@ -134,7 +134,7 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>>>                         goto do_error;
>>>                 if (!*timeo_p)
>>>                         goto do_eagain;
>>> -               if (signal_pending(current))
>>> +               if (task_sigpending(current))
>>>                         goto do_interrupted;
>>>                 sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
>>>                 if (sk_stream_memory_free(sk) && !vm_wait)
>>
>>
>> In __cifs_writev() we have
>>
>>>     /*
>>>      * If at least one write was successfully sent, then discard any rc
>>>      * value from the later writes. If the other write succeeds, then
>>>      * we'll end up returning whatever was written. If it fails, then
>>>      * we'll get a new rc value from that.
>>>      */
>>
>> so it can happen that collect_uncached_write_data() will (correctly)
>> report a short write when calling ctx->iocb->ki_complete().
>>
>> But QEMU's io_uring backend treats a short write as an -ENOSPC error,
>> which also is a bug? Or does the kernel give any guarantees in that
>> direction?
>>
>> Still, it doesn't seem ideal that the "interrupt" happens and in fact
>> __smb_send_rqst() tries to avoid it, but fails to do so, because of the
>> unexpected TIF_NOTIFY_SIGNAL:
>>>     /*
>>>      * We should not allow signals to interrupt the network send because
>>>      * any partial send will cause session reconnects thus increasing
>>>      * latency of system calls and overload a server with unnecessary
>>>      * requests.
>>>      */
>>>
>>>     sigfillset(&mask);
>>>     sigprocmask(SIG_BLOCK, &mask, &oldmask);
>>
>> Do you have any suggestions for how to proceed?
>>
> 
> Ping. The issue is still present in Linux 6.0. Does it make sense to
> also temporarily unset the task's TIF_NOTIFY_SIGNAL here or is that a
> bad idea?

You could try setting up with ring with IORING_SETUP_COOP_TASKRUN,
that'll avoid the TIF_NOTIFY_SIGNAL bits.

-- 
Jens Axboe


