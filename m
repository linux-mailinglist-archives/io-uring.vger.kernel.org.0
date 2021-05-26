Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C201D391E29
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234292AbhEZRdX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 13:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232674AbhEZRdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 13:33:22 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42CE3C061756
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 10:31:50 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id h11so1602551ili.9
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 10:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Etrixapv/R6Rcj/Np/+Qg5GvytKXovl2zBgc4RqlA0E=;
        b=pB+DPGVhnju74C1I0EyGqfCq0IEfo8CMhf5yCGyfiUXs6MpBSLvtxc1NKxFihHN4zS
         yr/f8N2b0ofjvXSfs7+xdUMVgqZEgSQXhRfSQO69j50EzekfyEixtBVrI3QXJQLT0+Hb
         02wbogfsbSpbCNnzssieF+/26Tr0X3sbIk+m8r/hchZd9TvtIgZeGZHWdY5ujMG5s0gQ
         mPu+4zTY/rIRT0Ropb/QUMN9sw54RJlA+ofLmctDEf0YJUpvmcKDfOXpSpT6o6Ojpu5G
         KmzkZoGG8WHWoK2gBr9EAB+X8bSgchYvwZTaKqoRVG1Of4/4Ttxq8FECyPKU1hgUnrnn
         mgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Etrixapv/R6Rcj/Np/+Qg5GvytKXovl2zBgc4RqlA0E=;
        b=hmoaC2Yy7HibNUNjDn9klPFfmnB8cuyQXUp454yWHjz5vC3jxtxAOJLt24l4h9e6w1
         wmAMvMlNjkbipCAYlcLRdONWdByOyXXu87M1qRzRoDG2wPqaj/GYgo6jJMz14LxgPpbI
         CHcqf4eOiCVhwtNPf6tAhGS0KRmUMG63CZ2SOWEXRcobpNFeKcxXU+vfM6SteoW1MVyn
         Z1/5tTDWmPIR8Qhggy/PDAGyHVqPI6s7+Dej3O1TL+TX9XoH/TS6U1xB0RyZ86ufadn+
         NsY66wsftHux3QxuOtOqin8FU0AdPnUG79G7iyHeIq7khGt+t5F3RqSx+K8b30fTt47z
         3+Ug==
X-Gm-Message-State: AOAM5327a7r2kgvQE96AYyKbkcs4utkep4lPI6apZiRDxi2UHDwNqXR+
        7GtKpPTmboFFWz6eyMKjc8mS0PP1Qqy/z6cp
X-Google-Smtp-Source: ABdhPJxNJsPLGlcXbIPir4ynnoULu5HhB+8xHm6TXHvdvu4x1wIBmypakB517HmqsJt2BiTNv6QivQ==
X-Received: by 2002:a05:6e02:218f:: with SMTP id j15mr27118305ila.249.1622050309494;
        Wed, 26 May 2021 10:31:49 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a17sm881234ilq.77.2021.05.26.10.31.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 10:31:49 -0700 (PDT)
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
From:   Jens Axboe <axboe@kernel.dk>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
 <162163379461.8379.9691291608621179559.stgit@sifl>
 <f07bd213-6656-7516-9099-c6ecf4174519@gmail.com>
 <CAHC9VhRjzWxweB8d8fypUx11CX6tRBnxSWbXH+5qM1virE509A@mail.gmail.com>
 <162219f9-7844-0c78-388f-9b5c06557d06@gmail.com>
 <CAHC9VhSJuddB+6GPS1+mgcuKahrR3UZA=1iO8obFzfRE7_E0gA@mail.gmail.com>
 <8943629d-3c69-3529-ca79-d7f8e2c60c16@kernel.dk>
 <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
 <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
Message-ID: <3bef7c8a-ee70-d91d-74db-367ad0137d00@kernel.dk>
Date:   Wed, 26 May 2021 11:31:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/26/21 11:15 AM, Jens Axboe wrote:
> On 5/25/21 8:04 PM, Paul Moore wrote:
>> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>>> On 5/24/21 1:59 PM, Paul Moore wrote:
>>>> That said, audit is not for everyone, and we have build time and
>>>> runtime options to help make life easier.  Beyond simply disabling
>>>> audit at compile time a number of Linux distributions effectively
>>>> shortcut audit at runtime by adding a "never" rule to the audit
>>>> filter, for example:
>>>>
>>>>  % auditctl -a task,never
>>>
>>> As has been brought up, the issue we're facing is that distros have
>>> CONFIG_AUDIT=y and hence the above is the best real world case outside
>>> of people doing custom kernels. My question would then be how much
>>> overhead the above will add, considering it's an entry/exit call per op.
>>> If auditctl is turned off, what is the expectation in turns of overhead?
>>
>> I commented on that case in my last email to Pavel, but I'll try to go
>> over it again in a little more detail.
>>
>> As we discussed earlier in this thread, we can skip the req->opcode
>> check before both the _entry and _exit calls, so we are left with just
>> the bare audit calls in the io_uring code.  As the _entry and _exit
>> functions are small, I've copied them and their supporting functions
>> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
>> "task,never" case.
>>
>> +  static inline struct audit_context *audit_context(void)
>> +  {
>> +    return current->audit_context;
>> +  }
>>
>> +  static inline bool audit_dummy_context(void)
>> +  {
>> +    void *p = audit_context();
>> +    return !p || *(int *)p;
>> +  }
>>
>> +  static inline void audit_uring_entry(u8 op)
>> +  {
>> +    if (unlikely(audit_enabled && audit_context()))
>> +      __audit_uring_entry(op);
>> +  }
>>
>> We have one if statement where the conditional checks on two
>> individual conditions.  The first (audit_enabled) is simply a check to
>> see if anyone has "turned on" auditing at runtime; historically this
>> worked rather well, and still does in a number of places, but ever
>> since systemd has taken to forcing audit on regardless of the admin's
>> audit configuration it is less useful.  The second (audit_context())
>> is a check to see if an audit_context has been allocated for the
>> current task.  In the case of "task,never" current->audit_context will
>> be NULL (see audit_alloc()) and the __audit_uring_entry() slowpath
>> will never be called.
>>
>> Worst case here is checking the value of audit_enabled and
>> current->audit_context.  Depending on which you think is more likely
>> we can change the order of the check so that the
>> current->audit_context check is first if you feel that is more likely
>> to be NULL than audit_enabled is to be false (it may be that way now).
>>
>> +  static inline void audit_uring_exit(int success, long code)
>> +  {
>> +    if (unlikely(!audit_dummy_context()))
>> +      __audit_uring_exit(success, code);
>> +  }
>>
>> The exit call is very similar to the entry call, but in the
>> "task,never" case it is very simple as the first check to be performed
>> is the current->audit_context check which we know to be NULL.  The
>> __audit_uring_exit() slowpath will never be called.
> 
> I actually ran some numbers this morning. The test base is 5.13+, and
> CONFIG_AUDIT=y and CONFIG_AUDITSYSCALL=y is set for both the baseline
> test and the test with this series applied. I used your git branch as of
> this morning.
> 
> The test case is my usual peak perf test, which is random reads at
> QD=128 and using polled IO. It's a single core test, not threaded. I ran
> two different tests - one was having a thread just do the IO, the other
> is using SQPOLL to do the IO for us. The device is capable than more
> IOPS than a single core can deliver, so we're CPU limited in this test.
> Hence it's a good test case as it does actual work, and shows software
> overhead quite nicely. Runs are very stable (less than 0.5% difference
> between runs on the same base), yet I did average 4 runs.
> 
> Kernel		SQPOLL		IOPS		Perf diff
> ---------------------------------------------------------
> 5.13		0		3029872		0.0%
> 5.13		1		3031056		0.0%
> 5.13 + audit	0		2894160		-4.5%
> 5.13 + audit	1		2886168		-4.8%
> 
> That's an immediate drop in perf of almost 5%. Looking at a quick
> profile of it (nothing fancy, just checking for 'audit' in the profile)
> shows this:
> 
> +    2.17%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
> +    0.71%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
>      0.07%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
>      0.02%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit
> 
> Note that this is with _no_ rules!

io_uring also supports a NOP command, which basically just measures
reqs/sec through the interface. Ran that as well:

Kernel		SQPOLL		IOPS		Perf diff
---------------------------------------------------------
5.13		0		31.05M		0.0%
5.13 + audit	0		25.31M		-18.5%

and profile for the latter includes:

+    5.19%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
+    4.31%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
     0.26%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
     0.08%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit

-- 
Jens Axboe

