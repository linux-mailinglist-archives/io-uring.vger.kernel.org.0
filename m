Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D152F34AAFF
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbhCZPJw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhCZPJq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:09:46 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F289FC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:09:45 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id k8so5684101iop.12
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 08:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yP6OHDhbSeieFWj37ROFTSmIaw0l0by0XZBMjaUhKQ8=;
        b=14mOVTn8KQ92NfsMO78jc8gu7ZloMgexH+GnCD8/DY8TQ2TTwWELxQzfmZKNBx7D5n
         BsLkcl8KeLionziIkqLoPZ3fqejS2yqO2ChRDkc2PaLre8A9XvKA04XSzPZi0ltTIF/m
         iNt3jDegKgVloYlcJJrK51Jx5jpGwlgdbRzW/1MwkuIKstEszt+vl2y/rVAKsn0uKFiG
         mD87Ey17L7RpqMxIGwA/xQFbFcl8/bktYO/Wdup3C7X/ld81ew/+QYPmo3qCHDpfrEm9
         P13mnQx13YWN6xT9F/AnirZYdHWRFV7DFxqBt6/zx6OEwNGf43yZPsZtiJeo0ZU1x8ch
         26hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yP6OHDhbSeieFWj37ROFTSmIaw0l0by0XZBMjaUhKQ8=;
        b=qz/yL+NA0SS7lE3aUxslv52vpZecFUgtaR2Cokrm1MZx7Qo/60Ly8WgThnNWG5zPfb
         rUrwWVXq150QiytIXOuznaP75rauf9hoS3WnbJiuD/Ugb0Sfbl2DfRf1j5+2xOtgdlTi
         WaYsAWv5ddkq3x0WRNFh/GMHmcAFZWcJp0zOU+UvQVimWdrCrq0LW58UHBNDbnTCOxrC
         tbxBdp+iWtALwz06pqeyC6Lb3GaNHlIlx07w+/ALSazi7ysQjhDyLs1oGSdvb+eQM2yI
         BJoCYNykfseoAUzi5icZ4wWf+MZh18siOZDWJJ/1VMLEIJgmwqnck4XYjpMtzBV2ceZh
         OiCw==
X-Gm-Message-State: AOAM531sVKwgMs0rvd5CtUeFeReAVdOlCzn5YukHkkQ3lBhHXXCZcJRq
        O8Gm4PVNzS4CvA1fgtwpy3gvew==
X-Google-Smtp-Source: ABdhPJyobLPt/nUU2W/P37eBBjvMMq1tg5kQSmCc1x5C/ZUbcbQoSHkKDXwXDUrvRVLJIG58Cy3/5w==
X-Received: by 2002:a05:6602:2156:: with SMTP id y22mr10863722ioy.10.1616771385434;
        Fri, 26 Mar 2021 08:09:45 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l7sm30761ilk.60.2021.03.26.08.09.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 08:09:45 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
 <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
 <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
 <ac807735-53d0-0c9e-e119-775e5e01d971@samba.org>
 <0396df33-7f91-90c8-6c0d-8a3afd3fff3c@kernel.dk>
 <98c22337-b85e-0316-b446-d4422af45d56@samba.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <30fc7d58-f37f-42b4-e387-34e1cb7d1ee2@kernel.dk>
Date:   Fri, 26 Mar 2021 09:09:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <98c22337-b85e-0316-b446-d4422af45d56@samba.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 9:04 AM, Stefan Metzmacher wrote:
> 
> Am 26.03.21 um 15:53 schrieb Jens Axboe:
>> On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
>>> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>>>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>>>> The KILL after STOP deadlock still exists.
>>>>>>>
>>>>>>> In which tree? Sounds like you're still on the old one with that
>>>>>>> incremental you sent, which wasn't complete.
>>>>>>>
>>>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>>>
>>>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>>>> pushed), fwiw.
>>>>>>
>>>>>> I can reproduce this one! I'll take a closer look.
>>>>>
>>>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>>>> and never return. So we might need a special case in there to deal with
>>>>> that, or some other way of ensuring that fatal signal gets processed
>>>>> correctly for IO threads.
>>>>
>>>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
>>>
>>> Ah, we're still in the first get_signal() from SIGSTOP, correct?
>>
>> Yes exactly, we're waiting in there being stopped. So we either need to
>> check to something ala:
>>
>> relock:
>> +	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
>> +		return false;
>>
>> to catch it upfront and from the relock case, or add:
>>
>> 	fatal:
>> +		if (current->flags & PF_IO_WORKER)
>> +			return false;
>>
>> to catch it in the fatal section.
>>
> 
> Or something like io_uring_files_cancel()
> 
> Maybe change current->pf_io_worker with a generic current->io_thread
> structure which, has exit hooks, as well as
> io_wq_worker_sleeping() and io_wq_worker_running().
> 
> Maybe create_io_thread would take such an structure
> as argument instead of a single function pointer.
> 
> struct io_thread_description {
> 	const char *name;
> 	int (*thread_fn)(struct io_thread_description *);
> 	void (*sleeping_fn)((struct io_thread_description *);
> 	void (*running_fn)((struct io_thread_description *);
> 	void (*exit_fn)((struct io_thread_description *);
> };
> 
> And then
> struct io_wq_manager {
> 	struct io_thread_description description;
> 	... manager specific stuff...
> };

I did consider something like that, but seems a bit over-engineered
just for catching this case. And any kind of logic for PF_EXITING
ends up being a bit tricky for cancelations.

We can look into doing that for 5.13 potentially.

-- 
Jens Axboe

