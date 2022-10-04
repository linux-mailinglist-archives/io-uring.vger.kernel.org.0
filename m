Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B83EA5F3F28
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 11:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbiJDJGw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 05:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJDJGu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 05:06:50 -0400
X-Greylist: delayed 427 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 02:06:49 PDT
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68F3C2E6BE;
        Tue,  4 Oct 2022 02:06:48 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id D59CB4477E;
        Tue,  4 Oct 2022 10:59:38 +0200 (CEST)
Message-ID: <94ff5098-dd66-3c83-0810-d65c7153984d@proxmox.com>
Date:   Tue, 4 Oct 2022 10:59:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: Problematic interaction of io_uring and CIFS
Content-Language: en-US
From:   Fiona Ebner <f.ebner@proxmox.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, CIFS <linux-cifs@vger.kernel.org>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
References: <af573afc-8f6a-d69e-24ab-970b33df45d9@proxmox.com>
 <20220708174815.3g4atpcu6u6icrhp@cyberdelia>
 <CANT5p=rSKRe_EXFmKS+qRyBo4i9Ko1pcgwxy-B1gugJtKjVAMA@mail.gmail.com>
 <CANT5p=qxYh+VxXpVGd2GO=WJoZ5J_p0oodN+wcFqC43t49pRqA@mail.gmail.com>
 <560586b2-8cd6-7a62-86f2-90e8968d0ad4@proxmox.com>
 <3ea2a6b3-d64d-744f-894b-66fee1242597@proxmox.com>
In-Reply-To: <3ea2a6b3-d64d-744f-894b-66fee1242597@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.08.22 um 10:21 schrieb Fiona Ebner:
> Am 11.07.22 um 15:40 schrieb Fabian Ebner:
>> Am 09.07.22 um 05:39 schrieb Shyam Prasad N:
>>> On Sat, Jul 9, 2022 at 9:00 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>>>>
>>>> On Fri, Jul 8, 2022 at 11:22 PM Enzo Matsumiya <ematsumiya@suse.de> wrote:
>>>>>
>>>>> On 07/08, Fabian Ebner wrote:
>>>>>> (Re-sending without the log from the older kernel, because the mail hit
>>>>>> the 100000 char limit with that)
>>>>>>
>>>>>> Hi,
>>>>>> it seems that in kernels >= 5.15, io_uring and CIFS don't interact
>>>>>> nicely sometimes, leading to IO errors. Unfortunately, my reproducer is
>>>>>> a QEMU VM with a disk on CIFS (original report by one of our users [0]),
>>>>>> but I can try to cook up something simpler if you want.
>>>>>>
>>>>>> Bisecting got me to 8ef12efe26c8 ("io_uring: run regular file
>>>>>> completions from task_work") being the first bad commit.
>>>>>>
> 
> I finally got around to taking another look at this issue (still present
> in 5.19.3) and I think I've finally figured out the root cause:
> 
> After commit 8ef12efe26c8, for my reproducer, the write completion is
> added to task_work with notify_method being TWA_SIGNAL and thus
> TIF_NOTIFY_SIGNAL is set for the task.
> 
> After that, if we end up in sk_stream_wait_memory() via sock_sendmsg(),
> signal_pending(current) will evaluate to true and thus -EINTR is
> returned all the way up to sock_sendmsg() in smb_send_kvec().
> 
> Related: in __smb_send_rqst() there too is a signal_pending(current)
> check leading to the -ERESTARTSYS return value.
> 
> To verify that this is the cause, I wasn't able to trigger the issue
> anymore with this hack applied (i.e. excluding the TIF_NOTIFY_SIGNAL check):
> 
>> diff --git a/net/core/stream.c b/net/core/stream.c
>> index 06b36c730ce8..58e3825930bb 100644
>> --- a/net/core/stream.c
>> +++ b/net/core/stream.c
>> @@ -134,7 +134,7 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
>>                         goto do_error;
>>                 if (!*timeo_p)
>>                         goto do_eagain;
>> -               if (signal_pending(current))
>> +               if (task_sigpending(current))
>>                         goto do_interrupted;
>>                 sk_clear_bit(SOCKWQ_ASYNC_NOSPACE, sk);
>>                 if (sk_stream_memory_free(sk) && !vm_wait)
> 
> 
> In __cifs_writev() we have
> 
>>     /*
>>      * If at least one write was successfully sent, then discard any rc
>>      * value from the later writes. If the other write succeeds, then
>>      * we'll end up returning whatever was written. If it fails, then
>>      * we'll get a new rc value from that.
>>      */
> 
> so it can happen that collect_uncached_write_data() will (correctly)
> report a short write when calling ctx->iocb->ki_complete().
> 
> But QEMU's io_uring backend treats a short write as an -ENOSPC error,
> which also is a bug? Or does the kernel give any guarantees in that
> direction?
> 
> Still, it doesn't seem ideal that the "interrupt" happens and in fact
> __smb_send_rqst() tries to avoid it, but fails to do so, because of the
> unexpected TIF_NOTIFY_SIGNAL:
>>     /*
>>      * We should not allow signals to interrupt the network send because
>>      * any partial send will cause session reconnects thus increasing
>>      * latency of system calls and overload a server with unnecessary
>>      * requests.
>>      */
>>
>>     sigfillset(&mask);
>>     sigprocmask(SIG_BLOCK, &mask, &oldmask);
> 
> Do you have any suggestions for how to proceed?
> 

Ping. The issue is still present in Linux 6.0. Does it make sense to
also temporarily unset the task's TIF_NOTIFY_SIGNAL here or is that a
bad idea?

Best Regards,
Fiona

