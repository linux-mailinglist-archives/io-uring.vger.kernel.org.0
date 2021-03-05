Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3744732F1AB
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 18:47:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhCERqh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 12:46:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230046AbhCERqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 12:46:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614966392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2mNrC0Eq4RRwqxhwpA3GPSQmWFWAXRl4b39T5Sq16P4=;
        b=N7IPlkyCUEo7hlaf0unWEOimvwlLEZ5fhT4z9NDpAGUICX9bbj8FJAXBWsaMfU7wvhQBPd
        4F7Pqiyfg6bCCdE91PVVvUEYWyjDJcGMjQedMK6O7PjP6g77VHoHzLFw3ek9kQmHJs65hu
        EcdesWZcDYzatDHyS1fQ9KwExCVM3LQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-qRldupvZN2aG-LMF1Fax0g-1; Fri, 05 Mar 2021 12:46:29 -0500
X-MC-Unique: qRldupvZN2aG-LMF1Fax0g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E81538015A1;
        Fri,  5 Mar 2021 17:46:27 +0000 (UTC)
Received: from [192.168.1.10] (ovpn-114-106.ams2.redhat.com [10.36.114.106])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A1A05D6B1;
        Fri,  5 Mar 2021 17:46:25 +0000 (UTC)
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
From:   Heinz Mauelshagen <heinzm@redhat.com>
Message-ID: <bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
Date:   Fri, 5 Mar 2021 18:46:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/5/21 10:52 AM, JeffleXu wrote:
>
> On 3/3/21 6:09 PM, Mikulas Patocka wrote:
>>
>> On Wed, 3 Mar 2021, JeffleXu wrote:
>>
>>>
>>> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
>>>
>>>> Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
>>>> cookie.
>>>>
>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>>
>>>> ---
>>>>   drivers/md/dm.c |    5 +++++
>>>>   1 file changed, 5 insertions(+)
>>>>
>>>> Index: linux-2.6/drivers/md/dm.c
>>>> ===================================================================
>>>> --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>>>> +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>>>> @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>>>>   		}
>>>>   	}
>>>>   
>>>> +	if (ci.poll_cookie != BLK_QC_T_NONE) {
>>>> +		while (atomic_read(&ci.io->io_count) > 1 &&
>>>> +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>>> +	}
>>>> +
>>>>   	/* drop the extra reference count */
>>>>   	dec_pending(ci.io, errno_to_blk_status(error));
>>>>   }
>>> It seems that the general idea of your design is to
>>> 1) submit *one* split bio
>>> 2) blk_poll(), waiting the previously submitted split bio complets
>> No, I submit all the bios and poll for the last one.
>>
>>> and then submit next split bio, repeating the above process. I'm afraid
>>> the performance may be an issue here, since the batch every time
>>> blk_poll() reaps may decrease.
>> Could you benchmark it?
> I only tested dm-linear.
>
> The configuration (dm table) of dm-linear is:
> 0 1048576 linear /dev/nvme0n1 0
> 1048576 1048576 linear /dev/nvme2n1 0
> 2097152 1048576 linear /dev/nvme5n1 0
>
>
> fio script used is:
> ```
> $cat fio.conf
> [global]
> name=iouring-sqpoll-iopoll-1
> ioengine=io_uring
> iodepth=128
> numjobs=1
> thread
> rw=randread
> direct=1
> registerfiles=1
> hipri=1
> runtime=10
> time_based
> group_reporting
> randrepeat=0
> filename=/dev/mapper/testdev
> bs=4k
>
> [job-1]
> cpus_allowed=14
> ```
>
> IOPS (IRQ mode) | IOPS (iopoll mode (hipri=1))
> --------------- | --------------------
>             213k |		   19k
>
> At least, it doesn't work well with io_uring interface.
>
>


Jeffe,

I ran your above fio test on a linear LV split across 3 NVMes to second your split mapping
(system: 32 core Intel, 256GiB RAM) comparing io engines sync, libaio and io_uring,
the latter w/ and w/o hipri (sync+libaio obviously w/o registerfiles and hipri) which resulted ok:



sync  |  libaio  |  IRQ mode (hipri=0) | iopoll (hipri=1) 
------|----------|---------------------|----------------- 56.3K |    
290K  |                329K |             351K I can't second your 
drastic hipri=1 drop here...
Heinz

