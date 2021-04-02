Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2DD352BEB
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 18:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbhDBOoe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 10:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhDBOoc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 10:44:32 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E06C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 07:44:30 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id i18so1480566wrm.5
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 07:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aOP542p1Ew/7BAUldTdg5cwr5a18t+wqGohgb0Ioa5o=;
        b=nmegAHghC4Z724tnVcSD1TIvhsQQs1jPRkXoYeZAQG1P9/rOuMiRxeO1+fRlfi7K2m
         y5FvWMROLLuhtGLGE9z/ASVHI97LpVNvV9vnHbzPmSixfpP1nPAySQLoaZZNrp6Yq/gv
         Io1czDXLAtserDLb7Leg+t0ERRs93Q0KFpBxC4xva+KBnItt5rjqO/ll5kCdHXiq7Vp/
         sFrvf5dAhMK3FLZq0R9+mNMjYMYJxXoaIMlT2BHv9cT4XfJuXHM8yr0xdyym/zBjtXrh
         gkabFfM/R7e+Eii02a7h4UodHk6Yld4rF0wCM3p+XcgglvOzwz+VGiXibTg3h/mNKpnt
         efgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=aOP542p1Ew/7BAUldTdg5cwr5a18t+wqGohgb0Ioa5o=;
        b=AvTkMFe4j/pOXw5DJID9oLVZVJAo4+bWqHhu5eDYVz8RQbr8NbM6Kp8wM2x7vTe1Xq
         XJYEl8p45qqmtdxWNv8/GtRmMbj4QCUZsoMURoQeikLxNXVFikni4ZyqbEcLW3nSbc3t
         e1LZqZoOQVkS4h4TOMjYdk8bhIf9TmmHoG9B5q19AuRRkF1XRKOsY+fRTXzdRB6jZupm
         btpDSQ6MMcAdUipQkTlFXpReG4yEKAOBviSXUf2Vp8rHjvesvDRb080wQu7Wn45kWdv1
         t5g643duq+7BMzcMpFQpHgK+eh8wph/IIXUyX7gGtI50B0klTwaZMCNH7MjuOM/0Yin9
         +b5Q==
X-Gm-Message-State: AOAM533+y0gsjbPJptiGefj5kMMR5QQ7BzD+OWu6tyE86OFuFXVHpR4u
        44t5KmTN3K7HAQWQf+SguoM=
X-Google-Smtp-Source: ABdhPJxhWQ8Ij5AZ/G0X0u9N2hdd636JK2gsjLLKjE1menVvM4YrVs6zLN8pg2IUdK8oSW6SW6lohQ==
X-Received: by 2002:a5d:5291:: with SMTP id c17mr3611336wrv.110.1617374669621;
        Fri, 02 Apr 2021 07:44:29 -0700 (PDT)
Received: from [192.168.8.131] ([148.252.129.229])
        by smtp.gmail.com with ESMTPSA id o24sm2227298wmr.26.2021.04.02.07.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 07:44:29 -0700 (PDT)
Subject: Re: [PATCH] io_uring: support multiple rings to share same poll
 thread by specifying same cpu
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
References: <20210331155926.22913-1-xiaoguang.wang@linux.alibaba.com>
 <0e7acba9-1e45-2891-3461-42ca1485ac61@gmail.com>
 <a9c49559-0e94-7244-9d00-c50b537c2118@linux.alibaba.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <e4a37514-ab6c-6798-80cb-de9833123fee@gmail.com>
Date:   Fri, 2 Apr 2021 15:40:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <a9c49559-0e94-7244-9d00-c50b537c2118@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/04/2021 15:38, Xiaoguang Wang wrote:
> hi,
> 
>> On 31/03/2021 16:59, Xiaoguang Wang wrote:
>>> We have already supported multiple rings to share one same poll thread
>>> by passing IORING_SETUP_ATTACH_WQ, but it's not that convenient to use.
>>> IORING_SETUP_ATTACH_WQ needs users to ensure that a parent ring instance
>>> has beed created firstly, that means it will require app to regulate the
>>> creation oder between uring instances.
>>>
>>> Currently we can make this a bit simpler, for those rings which will
>>> have SQPOLL enabled and are willing to be bound to one same cpu, add a
>>> capability that these rings can share one poll thread by specifying
>>> a new IORING_SETUP_SQPOLL_PERCPU flag, then we have 3 cases
>>>    1, IORING_SETUP_ATTACH_WQ: if user specifies this flag, we'll always
>>> try to attach this ring to an existing ring's corresponding poll thread,
>>> no matter whether IORING_SETUP_SQ_AFF or IORING_SETUP_SQPOLL_PERCPU is
>>> set.
>>>    2, IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU are both enabled,
>>> for this case, we'll create a single poll thread to be shared by rings
>>> rings which have same sq_thread_cpu.
>>>    3, for any other cases, we'll just create one new poll thread for the
>>> corresponding ring.
>>>
>>> And for case 2, don't need to regulate creation oder of multiple uring
>>> instances, we use a mutex to synchronize creation, for example, say five
>>> rings which all have IORING_SETUP_SQ_AFF & IORING_SETUP_SQPOLL_PERCPU
>>> enabled, and are willing to be bound same cpu, one ring that gets the
>>> mutex lock will create one poll thread, the other four rings will just
>>> attach themselves to the previous created poll thread once they get lock
>>> successfully.
>>>
>>> To implement above function, define below data structs:
>>>    struct percpu_sqd_entry {
>>>          struct list_head        node;
>>>          struct io_sq_data       *sqd;
>>>          pid_t                   tgid;
>>>    };
>>>
>>>    struct percpu_sqd_list {
>>>          struct list_head        head;
>>>          struct mutex            lock;
>>>    };
>>>
>>>    static struct percpu_sqd_list __percpu *percpu_sqd_list;
>>>
>>> sqthreads that have same sq_thread_cpu will be linked together in a percpu
>>> percpu_sqd_list's head. When IORING_SETUP_SQ_AFF and IORING_SETUP_SQPOLL_PERCPU
>>> are both enabled, we will use struct io_uring_params' sq_thread_cpu and
>>> current-tgid locate corresponding sqd.
>>
>> I can't help myself but wonder why not something in the userspace like
>> a pseudo-coded snippet below?
> Yes, agree with you, this feature can be done in userspace. Indeed I also don't
> have a much strong preference that this patch is merged into mainline codes, but it's
> really convenient for usrs who want to make multiple rings share one same sqthread
> by specifying cpu id.
> 
>>
>> BTW, don't think "pid_t tgid" will work with namespaces/cgroups.
> In copy_process():
>     /* ok, now we should be set up.. */
>     p->pid = pid_nr(pid);
>     if (clone_flags & CLONE_THREAD) {
>         p->group_leader = current->group_leader;
>         p->tgid = current->tgid;
>     } else {
>         p->group_leader = p;
>         p->tgid = p->pid;
>     }
> 
> current->tgid comes form pid_nr(pid), pid_nr() returns a global id seen from
> the init namespace, seems that this id is unique. I'll try to confirm this
> assumption more, thanks.

Ah, could be, we definitely need to take a closer look :)

-- 
Pavel Begunkov
