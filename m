Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3418879D
	for <lists+io-uring@lfdr.de>; Tue, 17 Mar 2020 15:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgCQOii (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Mar 2020 10:38:38 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35301 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQOii (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Mar 2020 10:38:38 -0400
Received: by mail-pj1-f65.google.com with SMTP id mq3so10603104pjb.0
        for <io-uring@vger.kernel.org>; Tue, 17 Mar 2020 07:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WtjYCeGPQQyAZr/zbYm5iDLBdWjScLmFOpQ7q5zGmOA=;
        b=AwozBdwikyVkdTvI7RmdK/6+7bF+1pWx1dakToP9d0ZWjCuNYa/1GyQ1/MK/4jJ011
         PVfDVf9aHW/cmb0s74vuN/ujcs5mLCSRo2wsotpYfLfN6Z0Kf9xVwXkDxE9KtMPVmpI8
         iitB4vxAlkHfP6x5SEMZXPXZK3IeZD3FfLxsl9Ugn/3tzTkOMlqveZ2sQ32DQqvNHFal
         rp/pTBQFIo3w1HOiTX6rGQIasRxLFWJv+7X9LZryPed1WRUr3brO3cwAiWxEfl5BMVEq
         TeMOfBsw1D+F9GpKCFoO/SiyK3dzZtXhS8ZWOM6Pd5tEare4GbIXR+VgkFHjezbZr0Ig
         xK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WtjYCeGPQQyAZr/zbYm5iDLBdWjScLmFOpQ7q5zGmOA=;
        b=YgnbKmg53LdcDA+S38srj6MAbLr0jnaurfB4tccwXOfS8FGDOTvV/Vw8mXTxq6GKmP
         v7p5XMU6+MxEa0SewqKvsV6yqcG6yVnQ54heAf8s6EE7a7FNhYPE+MoVtUBEIL10SQwy
         U9R5UvK2udLEyOITVS36epur4ylJ9WUua6BOKgUnm+3PgNKJHLc7C9TeupIU/LHHzB3I
         t6uZ0Ulgj+6bRhqbKgu8csawQKGgxCIzF1Y70vGSHjywqkslUi3Jw4CG0kYT84CGkObE
         sw53lbvFDK2CCoO2e0ZplwUe3ERtePIz/Dr5NaaHebl2YMdNKEN2ADHoOBzskzuXVzRy
         hzZw==
X-Gm-Message-State: ANhLgQ2OCohh1XNE5NiNS47zFXe7HuYhM4mf8ps9CioAt2hSF7mDj9ek
        o9eaXRkjD/r6tUfBOh4a4/pKUx//0ynVOA==
X-Google-Smtp-Source: ADFU+vsy8/Ja8faDzmWk7bsT7xbSK+t9Bhk35pdz3vycS/Z9dpQ4INiVBBz0gOCD00lN5VH/AGcD6A==
X-Received: by 2002:a17:90a:2149:: with SMTP id a67mr5686792pje.190.1584455914780;
        Tue, 17 Mar 2020 07:38:34 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id b24sm3389236pfi.52.2020.03.17.07.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 07:38:34 -0700 (PDT)
Subject: Re: bug report about patch "io_uring: avoid ring quiesce for fixed
 file set unregister and update"
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     joseph qi <joseph.qi@linux.alibaba.com>
References: <2b1834e3-1870-66a4-bbf4-70ab8a5109a6@linux.alibaba.com>
 <c5ef8351-359e-2730-7bd6-5a3be3f23f94@kernel.dk>
 <78180591-3f3e-f4e8-7618-de7250b479f0@linux.alibaba.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6234a93d-aaf2-9d40-6e51-b751ac4076af@kernel.dk>
Date:   Tue, 17 Mar 2020 08:38:32 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <78180591-3f3e-f4e8-7618-de7250b479f0@linux.alibaba.com>
Content-Type: text/plain; charset=gbk
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/17/20 6:13 AM, Xiaoguang Wang wrote:
> hi,
> 
>> On 3/16/20 6:14 AM, Xiaoguang Wang wrote:
>>> hi,
>>>
>>> While diving into iouring file register/unregister/update codes, seems that
>>> there is one bug in __io_sqe_files_update():
>>>       if (ref_switch)
>>>           percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
>>>
>>> The initial fixed_file_data's refs is 1, assume there are no requests
>>> to get/put this refs, and we firstly register 10 files and later update
>>> these 10 files, and no memory allocations fails, then above two line of
>>> codes in __io_sqe_files_update() will be called, before entering
>>> percpu_ref_switch_to_atomic(), the count of refs is still one, and
>>> |--> percpu_ref_switch_to_atomic
>>> |----> __percpu_ref_switch_mode
>>> |------> __percpu_ref_switch_to_atomic
>>> |-------- > percpu_ref_get(ref), # now the count of refs will be 2.
>>>
>>> a while later
>>> |--> percpu_ref_switch_to_atomic_rcu
>>> |----> percpu_ref_call_confirm_rcu
>>> |------ > confirm_switch(), # calls io_atomic_switch, note that the count of refs is 2.
>>> |------ > percpu_ref_put # drop one ref
>>>
>>> static void io_atomic_switch(struct percpu_ref *ref)
>>> {
>>> 	struct fixed_file_data *data;
>>>
>>> 	/*
>>> 	 * Juggle reference to ensure we hit zero, if needed, so we can
>>> 	 * switch back to percpu mode
>>> 	 */
>>> 	data = container_of(ref, struct fixed_file_data, refs);
>>> 	percpu_ref_put(&data->refs);
>>> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> After this operation, the count of refs is 1 now, still not zero, so
>>> io_file_data_ref_zero won't be called, then io_ring_file_ref_flush()
>>> won't be called, this fixed_file_data's refs will always be in atomic mode,
>>> which is bad.
>>>
>>> 	percpu_ref_get(&data->refs);
>>> }
>>>
>>> To confirm this bug, I did a hack to kernel:
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -5812,7 +5812,10 @@ static bool io_queue_file_removal(struct fixed_file_data *data,
>>>            * If we fail allocating the struct we need for doing async reomval
>>>            * of this file, just punt to sync and wait for it.
>>>            */
>>> +       /*
>>>           pfile = kzalloc(sizeof(*pfile), GFP_KERNEL);
>>> +       */
>>> +       pfile = NULL;
>>>           if (!pfile) {
>>>                   pfile = &pfile_stack;
>>>                   pfile->done = &done;
>>> To simulate memory allocation failures, then run liburing/test/file-update,
>>>
>>> [lege@localhost test]$ sudo cat /proc/2091/stack
>>> [sudo] password for lege:
>>> [<0>] __io_sqe_files_update.isra.85+0x175/0x330
>>> [<0>] __io_uring_register+0x178/0xe20
>>> [<0>] __x64_sys_io_uring_register+0xa0/0x160
>>> [<0>] do_syscall_64+0x55/0x1b0
>>> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>>
>>> (gdb) list * __io_sqe_files_update+0x175
>>> 0xffffffff812ec255 is in __io_sqe_files_update (fs/io_uring.c:5830).
>>> 5825            llist_add(&pfile->llist, &data->put_llist);
>>> 5826
>>> 5827            if (pfile == &pfile_stack) {
>>> 5828                    percpu_ref_switch_to_atomic(&data->refs, io_atomic_switch);
>>> 5829                    wait_for_completion(&done);
>>> 5830                    flush_work(&data->ref_work);
>>> 5831                    return false;
>>>
>>> file-update will always hang in wait_for_completion(&done), it's because
>>> io_ring_file_ref_flush never has a chance to run.
>>>
>>> I think how to fix this issue a while, doesn't find a elegant method yet.
>>> And applications may issue requests continuously, then fixed_file_data's refs
>>> may never have a chance to reach zero, refs will always be in atomic mode.
>>> Or the simplest method is to use percpu_ref per registered file :)
>>
>> For the "oh crap I can't allocate data" stack path, I think the below
>> should fix it. Might not be a bad idea to re-think the live updates in
>> general, though.
>
> I'm not a native english speaker and afraid that I may misread your
> replies :) So I'd like to confirm that do you mind that I implement a
> percpu_ref per registered file to track every registered file's
> status?

That'd be great, as long as we're ensuring that memory bloat doesn't
become a problem. But never doubt that you can send patches to improve
things - even if they sometimes don't get applied, they may help spark
discussion that will end up leading to a great fix.

-- 
Jens Axboe

