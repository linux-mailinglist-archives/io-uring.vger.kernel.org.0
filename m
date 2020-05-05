Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526831C5F03
	for <lists+io-uring@lfdr.de>; Tue,  5 May 2020 19:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbgEERjS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 May 2020 13:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729697AbgEERjS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 May 2020 13:39:18 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCA3C061A0F
        for <io-uring@vger.kernel.org>; Tue,  5 May 2020 10:39:17 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id w6so1297622ilg.1
        for <io-uring@vger.kernel.org>; Tue, 05 May 2020 10:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mNMeuqX5zgMTKRs/WZQqg3t0HAvJDcV8C9Td3WhDFv0=;
        b=1nVxJEr63Y51ka41TimeuxHTehOWizJAI0fWNHkKEC/xt0MWhOVEfSo1ZSUh5SMaVB
         1TAJ1y4O+mrS3ngpIYkszCWOZj/nbaEjFPD9XmKHORPiobdDV3l3hE7k4v/MJCVk7pFU
         ZWuGyK6lPrQr6QaXmcLie95LSofwMLbCqZTiB0wUk/MEqmBuCwtLVu5k7PG8PTTr/CXW
         iPy2wwBlqBZCP+apleQnLGg/DCHEAtAua4v5Xg0kdv/op+VM4HwuEsvrBQcItRNXK+Mv
         d0AnzcVFYDWBp9pL4GcVlNyaM4nQYGy4jWnTuouRzHlojVBj4P18UXoaXcItz+CvczOS
         jjKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mNMeuqX5zgMTKRs/WZQqg3t0HAvJDcV8C9Td3WhDFv0=;
        b=DJdwiuhFff7o0QyC3UNA0bG9OOPEe7ZM5K2YcXtgQ77FzPCzEBHji65hU9lrgRpWxT
         Zg58FGqLTN3ORwm4JsVSMjPQUlrmXJV24mGtgjNv7iUIFnlQqf5gn/t+52jmn/KQQ909
         rilxVuKn/ktTGv4DqJaMhrz+EuBzaAsPf6sbCHEvMlgFjW4aRSTXS8S+d3ZCdvtVCpoa
         o1FjQB5ncaO6T++hPwHqWZcnKXAz2YzlachtIjSRh7jh73nRvtCVU5IWS+6bkD2NGCT6
         dyNwUGeQFukgyJYuN+ofPf9ZX4/x9aZTtIXqQzq2e/2BLNMQ5wSaB8jmziCoOKGoXZJx
         Um5Q==
X-Gm-Message-State: AGi0PuaCBJROqxDXAY94InczjKuW92NteQXQCpJxrt49tak3OTSMG9gv
        Ri/n0JdEZU5hzG5ZaOBPDH9IIg==
X-Google-Smtp-Source: APiQypIBL/yVm7qPtGf4a1GzxqPikWoe+EF5NyHDtcSCqfq7TN3KsfNcbS5fNuxYqzCRJxBSFjrd3A==
X-Received: by 2002:a92:3652:: with SMTP id d18mr4809033ilf.212.1588700356398;
        Tue, 05 May 2020 10:39:16 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id k18sm2070509ili.77.2020.05.05.10.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:39:15 -0700 (PDT)
Subject: Re: Data Corruption bug with Samba's vfs_iouring and Linux
 5.6.7/5.7rc3
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Samba Technical <samba-technical@lists.samba.org>,
        Jeremy Allison <jra@samba.org>
References: <0009f6b7-9139-35c7-c0b1-b29df2a67f70@samba.org>
 <102c824b-b2f5-bbb1-02da-d2a78c3ff460@kernel.dk>
 <7ed7267d-a0ae-72ac-2106-2476773f544f@kernel.dk>
 <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
Message-ID: <f782fc6d-0f89-dca7-3bb0-58ef8f662392@kernel.dk>
Date:   Tue, 5 May 2020 11:39:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <cd53de09-5f4c-f2f0-41ef-9e0bfca9a37d@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/20 10:53 AM, Jens Axboe wrote:
> On 5/5/20 9:44 AM, Jens Axboe wrote:
>> On 5/5/20 8:41 AM, Jens Axboe wrote:
>>> On 5/5/20 4:04 AM, Stefan Metzmacher wrote:
>>>> Hi Jens,
>>>>
>>>> we currently have a bug report [1][2] regarding a data corruption with
>>>> Samba's vfs_io_uring.c [3].
>>>>
>>>> Is there're a know problem in newer kernels? It seems the 5.3 Kernel
>>>> doesn't have the problem (at least Jeremy wasn't able to reproduce it
>>>> on the Ubuntu 5.3 kernel).
>>>>
>>>> Do you have any hints how to track that down?
>>>
>>> I'll take a look at this! Any chance Jeremy can try 5.4 and 5.5 as well,
>>> just to see where we're at, roughly? That might be very helpful.
>>
>> Trying to setup samba in a vm here to attempt to reproduce. I'm a major
>> samba noob, running with the smb.conf from the reporters email, I get:
>>
>> [2020/05/05 15:43:07.126674,  0] ../../source4/smbd/server.c:629(binary_smbd_main)
>>   samba version 4.12.2 started.
>>   Copyright Andrew Tridgell and the Samba Team 1992-2020
>> [2020/05/05 15:43:07.152828,  0] ../../source4/smbd/server.c:826(binary_smbd_main)
>>   At this time the 'samba' binary should only be used for either:
>>   'server role = active directory domain controller' or to access the ntvfs file server with 'server services = +smb' or the rpc proxy with 'dcerpc endpoint servers = remote'
>>   You should start smbd/nmbd/winbindd instead for domain member and standalone file server tasks
>> [2020/05/05 15:43:07.152937,  0] ../../lib/util/become_daemon.c:121(exit_daemon)
>>   exit_daemon: daemon failed to start: Samba detected misconfigured 'server role' and exited. Check logs for details, error code 22
>>
>> Clue bat appreciated.
> 
> Got it working, but apparently the arch samba doesn't come with io_uring...
> One question, though, from looking at the source:
> 
> static ssize_t vfs_io_uring_pread_recv(struct tevent_req *req,
> 				  struct vfs_aio_state *vfs_aio_state)
> {
> [...]
> 	if (state->ur.cqe.res < 0) {
> 		vfs_aio_state->error = -state->ur.cqe.res;
> 		ret = -1;
> 	} else {
> 		vfs_aio_state->error = 0;
> 		ret = state->ur.cqe.res;
> 	}
> 
> 	tevent_req_received(req);
> [...]
> 
> I'm assuming this is dealing with short reads?
> 
> I'll try and see if I can get an arch binary build that has the
> vfs_io_uring module and reproduce.

Got that done, and I can now mount it on Linux. Been trying pretty
hard to trigger any corruptions on reads, but it works for me. Checked
that we see short reads, and we do, and that it handles it just fine.
So pretty blank right now on what this could be.

FWIW, I'm mounting on Linux as:

# mount -t cifs -o ro,guest //arch/data /smb

-- 
Jens Axboe

