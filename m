Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D028433244E
	for <lists+io-uring@lfdr.de>; Tue,  9 Mar 2021 12:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhCILn3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Mar 2021 06:43:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35869 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229881AbhCILnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Mar 2021 06:43:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615290181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZiyY19GCsUbfic9JgXHPjlAqbux8h++RemzkQScjlxY=;
        b=anFPrqdBpTB8XxChcQkH9buhuDb0/Kz/s8LT335ueg9XBEfi4L+CC7BA6wkIMuxOyHsN2m
        w5rb90uxPc3fsfOEzxNrWC5xC5HjnmmpXeLkQyGNfXGoj997xIUVhOTMjk7No3oJCc2PSE
        GTErzGz5SZxOsrlt35cOLiqFWDCQtC0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-376-dNdDl4_KMtOsyweYpcsang-1; Tue, 09 Mar 2021 06:42:57 -0500
X-MC-Unique: dNdDl4_KMtOsyweYpcsang-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEA4219057A0;
        Tue,  9 Mar 2021 11:42:55 +0000 (UTC)
Received: from [192.168.1.10] (ovpn-115-45.ams2.redhat.com [10.36.115.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B31C660C04;
        Tue,  9 Mar 2021 11:42:50 +0000 (UTC)
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
To:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     axboe@kernel.dk, Mike Snitzer <msnitzer@redhat.com>,
        caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        io-uring@vger.kernel.org
References: <20210302190555.201228400@debian-a64.vm>
 <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
 <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
 <157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
 <bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
 <fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
 <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
From:   Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <bc0cdc50-22c9-031f-2ebf-3c8b0879eeb5@redhat.com>
Date:   Tue, 9 Mar 2021 12:42:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/8/21 4:54 AM, JeffleXu wrote:
>
> On 3/6/21 1:56 AM, Heinz Mauelshagen wrote:
>> On 3/5/21 6:46 PM, Heinz Mauelshagen wrote:
>>> On 3/5/21 10:52 AM, JeffleXu wrote:
>>>> On 3/3/21 6:09 PM, Mikulas Patocka wrote:
>>>>> On Wed, 3 Mar 2021, JeffleXu wrote:
>>>>>
>>>>>> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
>>>>>>
>>>>>>> Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
>>>>>>> cookie.
>>>>>>>
>>>>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>>>>>
>>>>>>> ---
>>>>>>>    drivers/md/dm.c |    5 +++++
>>>>>>>    1 file changed, 5 insertions(+)
>>>>>>>
>>>>>>> Index: linux-2.6/drivers/md/dm.c
>>>>>>> ===================================================================
>>>>>>> --- linux-2.6.orig/drivers/md/dm.c    2021-03-02
>>>>>>> 19:26:34.000000000 +0100
>>>>>>> +++ linux-2.6/drivers/md/dm.c    2021-03-02 19:26:34.000000000 +0100
>>>>>>> @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>>>>>>>            }
>>>>>>>        }
>>>>>>>    +    if (ci.poll_cookie != BLK_QC_T_NONE) {
>>>>>>> +        while (atomic_read(&ci.io->io_count) > 1 &&
>>>>>>> +               blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>>>>>> +    }
>>>>>>> +
>>>>>>>        /* drop the extra reference count */
>>>>>>>        dec_pending(ci.io, errno_to_blk_status(error));
>>>>>>>    }
>>>>>> It seems that the general idea of your design is to
>>>>>> 1) submit *one* split bio
>>>>>> 2) blk_poll(), waiting the previously submitted split bio complets
>>>>> No, I submit all the bios and poll for the last one.
>>>>>
>>>>>> and then submit next split bio, repeating the above process. I'm
>>>>>> afraid
>>>>>> the performance may be an issue here, since the batch every time
>>>>>> blk_poll() reaps may decrease.
>>>>> Could you benchmark it?
>>>> I only tested dm-linear.
>>>>
>>>> The configuration (dm table) of dm-linear is:
>>>> 0 1048576 linear /dev/nvme0n1 0
>>>> 1048576 1048576 linear /dev/nvme2n1 0
>>>> 2097152 1048576 linear /dev/nvme5n1 0
>>>>
>>>>
>>>> fio script used is:
>>>> ```
>>>> $cat fio.conf
>>>> [global]
>>>> name=iouring-sqpoll-iopoll-1
>>>> ioengine=io_uring
>>>> iodepth=128
>>>> numjobs=1
>>>> thread
>>>> rw=randread
>>>> direct=1
>>>> registerfiles=1
>>>> hipri=1
>>>> runtime=10
>>>> time_based
>>>> group_reporting
>>>> randrepeat=0
>>>> filename=/dev/mapper/testdev
>>>> bs=4k
>>>>
>>>> [job-1]
>>>> cpus_allowed=14
>>>> ```
>>>>
>>>> IOPS (IRQ mode) | IOPS (iopoll mode (hipri=1))
>>>> --------------- | --------------------
>>>>              213k |           19k
>>>>
>>>> At least, it doesn't work well with io_uring interface.
>>>>
>>>>
>>>
>>> Jeffle,
>>>
>>> I ran your above fio test on a linear LV split across 3 NVMes to
>>> second your split mapping
>>> (system: 32 core Intel, 256GiB RAM) comparing io engines sync, libaio
>>> and io_uring,
>>> the latter w/ and w/o hipri (sync+libaio obviously w/o registerfiles
>>> and hipri) which resulted ok:
>>>
>>>
>>>
>>> sync  |  libaio  |  IRQ mode (hipri=0) | iopoll (hipri=1)
>>> ------|----------|---------------------|----------------- 56.3K |
>>> 290K  |                329K |             351K I can't second your
>>> drastic hipri=1 drop here...
>>
>> Sorry, email mess.
>>
>>
>> sync   |  libaio  |  IRQ mode (hipri=0) | iopoll (hipri=1)
>> -------|----------|---------------------|-----------------
>> 56.3K  |    290K  |                329K |             351K
>>
>>
>>
>> I can't second your drastic hipri=1 drop here...
>>
> Hummm, that's indeed somewhat strange...
>
> My test environment:
> - CPU: 128 cores, though only one CPU core is used since
> 'cpus_allowed=14' in fio configuration
> - memory: 983G memory free
> - NVMe: Huawai ES3510P (HWE52P434T0L005N), with 'nvme.poll_queues=3'
>
> Maybe you didn't specify 'nvme.poll_queues=XXX'? In this case, IO still
> goes into IRQ mode, even you have specified 'hipri=1'?
>
Jeffle,

nvme.poll_queues was zero indeed.

At 3 results are hipri=0 / hipri=1 : 1699K / 1702K IOPS (all cores)

Single core results : 315K / 329K

Still no extreme drop...

FWIW:

Thanks,
Heinz

