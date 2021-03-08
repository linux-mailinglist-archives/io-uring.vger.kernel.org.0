Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C803306AB
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 04:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhCHDzc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Mar 2021 22:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234099AbhCHDzZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Mar 2021 22:55:25 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7D8C06175F
        for <io-uring@vger.kernel.org>; Sun,  7 Mar 2021 19:55:17 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id h4so5576012pgf.13
        for <io-uring@vger.kernel.org>; Sun, 07 Mar 2021 19:55:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VvRbjq0mrkefdd7O/F3HULQqRDNy+fW1K5pYetgWW0g=;
        b=vJFqYaN8ffoB4X+tdlcLBi+UCqaPaloeNCLLrPBEUh4JWN055kLIrN69c8zLC/UDMn
         tqwvNoBEHnB9mzSghJMtVUr+Sr4EtAudkjaJEGqit0s5YAUNQ9uSA6wzWIPM28DF5Nn+
         Jf/Lm+i4aHEYDwb6H5tuUyVcD6Z6NaYrWY35QeKIBy/at/RO4HQOXHE+EH5xlwD+JpeH
         /EH6XME3SmSCWGdFxvr5UpKUsA03w2pv4se7q7/hucvRJtjPmCxgqQit0+hNt4MEBG6W
         tJWkzcenzu5Ea7qEhtui8w2t/d9dLCWnFUtBbGxMiecIay1h7HHGNuesOzBzT/SCOyeM
         DhMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VvRbjq0mrkefdd7O/F3HULQqRDNy+fW1K5pYetgWW0g=;
        b=DON4+1pdb3VcjxlHsj0iRcuxp5roZBk9/dUHMASXN4B17M/S6Frm8QIMve3UNLdvue
         4Md1iFBkzXaoCHna145PXC25CyIZ6XErDs57aGV8w/oeT5SXrq0JxgzGIJUXf5Te7RoZ
         bKiTYNibiD2iRJp7zBcJyLjsrM9ddxG3Q0ZPCQbHGxx4INkGxrlQBGrhlw/iHt8Tncur
         fb5Fvs2BHO2Mpg3rDAEIcm0M1FxUeqRn9xIbWPUttncvvistLszz6dEFL2C0DLlIHBe4
         R+VRtavobKd2WfK1kL+J1dbjveeaMyNV0EK4CtvJYmT+9HWD8X7vv1UX4rZGXl4pCa70
         +Fcw==
X-Gm-Message-State: AOAM5311cPPMMo4gOgkkysr704YefEGI4l3MIsZ1YWjITSZZNRsDiZaV
        0lAsl00gT0s/BaIvJFZAoFhwk17zDSZvCw==
X-Google-Smtp-Source: ABdhPJzJIXCz62D8J+cVfkO4/8FhMxNYso7SgK4dKCjzP4vTw9PW0t0PR3sRftYXwfotEngqe86yZA==
X-Received: by 2002:a63:534f:: with SMTP id t15mr19641380pgl.126.1615175716895;
        Sun, 07 Mar 2021 19:55:16 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id p25sm5159674pfe.100.2021.03.07.19.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Mar 2021 19:55:16 -0800 (PST)
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
To:     JeffleXu <jefflexu@linux.alibaba.com>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     Mike Snitzer <msnitzer@redhat.com>, caspar@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
References: <20210302190555.201228400@debian-a64.vm>
 <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
 <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
 <157a750d-3d58-ae2e-07f1-b677c1b471c7@linux.alibaba.com>
 <bd447632-f174-e6f2-ddf8-d5385da13f6b@redhat.com>
 <fc9707dc-0a21-90d3-ed4f-e201406c50eb@redhat.com>
 <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <000ca63a-46a7-3c93-9b6b-e04bebc971cc@kernel.dk>
Date:   Sun, 7 Mar 2021 20:55:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <06d17f27-c043-f69c-eeef-f6df714c1764@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/7/21 8:54 PM, JeffleXu wrote:
> 
> 
> On 3/6/21 1:56 AM, Heinz Mauelshagen wrote:
>>
>> On 3/5/21 6:46 PM, Heinz Mauelshagen wrote:
>>> On 3/5/21 10:52 AM, JeffleXu wrote:
>>>>
>>>> On 3/3/21 6:09 PM, Mikulas Patocka wrote:
>>>>>
>>>>> On Wed, 3 Mar 2021, JeffleXu wrote:
>>>>>
>>>>>>
>>>>>> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
>>>>>>
>>>>>>> Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
>>>>>>> cookie.
>>>>>>>
>>>>>>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>>>>>>
>>>>>>> ---
>>>>>>>   drivers/md/dm.c |    5 +++++
>>>>>>>   1 file changed, 5 insertions(+)
>>>>>>>
>>>>>>> Index: linux-2.6/drivers/md/dm.c
>>>>>>> ===================================================================
>>>>>>> --- linux-2.6.orig/drivers/md/dm.c    2021-03-02
>>>>>>> 19:26:34.000000000 +0100
>>>>>>> +++ linux-2.6/drivers/md/dm.c    2021-03-02 19:26:34.000000000 +0100
>>>>>>> @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>>>>>>>           }
>>>>>>>       }
>>>>>>>   +    if (ci.poll_cookie != BLK_QC_T_NONE) {
>>>>>>> +        while (atomic_read(&ci.io->io_count) > 1 &&
>>>>>>> +               blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>>>>>>> +    }
>>>>>>> +
>>>>>>>       /* drop the extra reference count */
>>>>>>>       dec_pending(ci.io, errno_to_blk_status(error));
>>>>>>>   }
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
>>>>             213k |           19k
>>>>
>>>> At least, it doesn't work well with io_uring interface.
>>>>
>>>>
>>>
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
> 
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

That would be my guess too, and the patches also have a very suspicious
clear of HIPRI which shouldn't be there (which would let that fly through).

-- 
Jens Axboe

