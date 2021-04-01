Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D25D351989
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhDARyE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236375AbhDARsZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:48:25 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4399FC00F7C9;
        Thu,  1 Apr 2021 08:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=9An728KlZVjFf0+wENS6eedafMqAahJG4Eij/X4oC/A=; b=qsotVAOsAg8OcFq9zC5lgMb9GG
        MurbuwzIaErbn6IKjPavhYlcQzwF3VkGyyEeE5qZ7Z5Rh1nT2gqMB3fe6VIe4jGiTxGk2Hb2jrMxY
        TPd0KHj+62YMLei1/cpln9i8/osy4zGPYFVH5/ZXKBmuvpJXGE18p3jHCV0ouuRcdEX91zs8mZMLB
        B5Yjzj6ZgxySQMFUEW1q9361RLEtX5Nxsw8GzqhM0Yu8F6R8HtME2Wl9w4xYxFytlYeEqE+tmsBsi
        JQsEirprZ0bVIRYgnWSX/fE/+Rpc6MmMW+uCodPy0fLyD4qEwkFhUcTB+fKeBoOcULcE0yp/Ohy5m
        Dj4jlWmc6rk4anGQsw/kDht1WQwF0Qpe5T1G8r4ts4yK9ROwpfmo7x015b4OYbuuhT9hXxm+J5LDU
        ARXpwmeARIXcuUP8/ktzb9754M3xWrfplDaBqnd1EWZ6qHjpbB81AOSKiAAuW6IAbvxQw9/Pd1JIU
        teYLJXz18h/IPJJHsgm+UNcO;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lRysz-0007XZ-En; Thu, 01 Apr 2021 15:05:29 +0000
To:     Alexey Dobriyan <adobriyan@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, fw@deneb.enyo.de,
        io-uring <io-uring@vger.kernel.org>
References: <YFYjOB1jpbqyNPAp@localhost.localdomain>
 <CALCETrUPAvUOr8V5db0gu5RKVftKFwbBEkh6Aob57v+D-xdEig@mail.gmail.com>
 <20210322075310.GA1946905@infradead.org>
 <YGTMTJ7h5aspTQ5M@localhost.localdomain>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] Document that PF_KTHREAD _is_ ABI
Message-ID: <5992461c-1aad-3ba4-47d6-4dad10b6903a@samba.org>
Date:   Thu, 1 Apr 2021 17:05:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YGTMTJ7h5aspTQ5M@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 31.03.21 um 21:23 schrieb Alexey Dobriyan:
> On Mon, Mar 22, 2021 at 07:53:10AM +0000, Christoph Hellwig wrote:
>> On Sat, Mar 20, 2021 at 10:23:12AM -0700, Andy Lutomirski wrote:
>>>> https://github.com/systemd/systemd/blob/main/src/basic/process-util.c#L354
>>>> src/basic/process-util.c:is_kernel_thread()
>>>
>>> Eww.
>>>
>>> Could we fix it differently and more permanently by modifying the proc
>>> code to display the values systemd expects?
>>
>> Yes, do_task_stat needs a mapping from kernel flags to UABI flags.  And
>> we should already discard everything we think we can from the UABI
>> now, and only add the ones back that are required to not break
>> userspace.
> 
> Sure we do. Who is going to find all the flags? I found PF_KTHREAD. :^)
> 
> More seriously,
> 
> /proc/$pid/stat was expanded to include tsk->flags in 0.99.1 (!!!)
> 
> Developers kept adding and shuffling flags probably not even realising
> what's going on. The last incident happened at 5.10 when PF_IO_WORKER
> was exchanged with PF_VCPU for smaller codegen.

With the create_io_thread(), the impact of PF_IO_WORKER becomes more broadly
visible and userspace might start to look at it in order to find the difference
between userspace and kernel io threads. (I also think it should actually be renamed to
PF_IO_THREAD...)

Jens, what do you think about that?

metze
