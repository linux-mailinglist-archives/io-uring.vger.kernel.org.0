Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72622391DAC
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 19:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234257AbhEZRQ7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 13:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234188AbhEZRQ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 13:16:58 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11FB3C061574
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 10:15:27 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id h15so1580218ilr.2
        for <io-uring@vger.kernel.org>; Wed, 26 May 2021 10:15:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aYKMuSKZVVdni+NfNKkXv3BlEOKam17qC1VvXW9yFpQ=;
        b=a79j6AZMQTm+qQYGqVhkjMfcARroJ37lEZmgKGSigQBNpJHMY+kK9LW9RAn4voppaq
         XtqQNIQWw7a2tOKPDT4Mxt6E335/aEB7eO0w6OPzc2J6+6K2PBWJbCLCXX+nDNmMl7YF
         roHuhUXs9sl/DW+BRZ2GlTgnlGrgqfsmRi+s6jBud8GGbh0Z4xeLMSRgr8r2Lj+RhRnn
         gsnnvEedrEEqBoAI4iERcpp90OL3eX+lTL6c5MRkP8Iy355puOTWM1/yPL07wsR4nyNf
         iWkW5CFUozrq9C5DWCO5OxmfT95+mTuym2psTB5xtsMze3LPCoLEU/s519mp8zc9pqlj
         nnzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aYKMuSKZVVdni+NfNKkXv3BlEOKam17qC1VvXW9yFpQ=;
        b=N7mAtJqhEEUyCZvvoAsCtktbodndDyIE57QfDITdPZMysz2QwNlmFgHGABLzHkjKnM
         WmAPaoeF1GhNnhTYiao5lNPlmUtC2za/r3q4ahipQZgeFIbJ6dvNTBRVPzxEYOJTO8w+
         0o8B7/3bYXnHDsEh8EHO8iTt+BqN1VzeaUh3fp0EtGQ7hsk9VGULhEz9fqs7dvW4T7I5
         I836xWqwwpsf4BCUU8Ult+sFfmvF8qRepjTtL8jJhkicUsScqMsLsrARatz0/amtaaoh
         9545IMKv6b3+Je0ho/UeBPebFM8uwSvG/2hLht7C6OpZkPv9+AbvKf+8+ixYJHB+pq3b
         Bs8w==
X-Gm-Message-State: AOAM532hPW2KeUKXJ3ckbLk8mgS+ZmE3ODI01kvhQJiVz52uNhlf7OdP
        ph/wB6LPYZJ0zU6sYQFwLcKqrQ==
X-Google-Smtp-Source: ABdhPJziYu08DO0Qp7L+9EYTQPjE1ppNL7H8P/SYVnqtm1MiORyY5E/g7M4RCyWBvbIGB5hTfGUucA==
X-Received: by 2002:a92:d24d:: with SMTP id v13mr27737100ilg.174.1622049326279;
        Wed, 26 May 2021 10:15:26 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id c11sm15132793ilo.61.2021.05.26.10.15.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 10:15:25 -0700 (PDT)
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9e69e4b6-2b87-a688-d604-c7f70be894f5@kernel.dk>
Date:   Wed, 26 May 2021 11:15:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTYBsh4JHhqV0Uyz=H5cEYQw48xOo=CUdXV0gDvyifPOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/25/21 8:04 PM, Paul Moore wrote:
> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 5/24/21 1:59 PM, Paul Moore wrote:
>>> That said, audit is not for everyone, and we have build time and
>>> runtime options to help make life easier.  Beyond simply disabling
>>> audit at compile time a number of Linux distributions effectively
>>> shortcut audit at runtime by adding a "never" rule to the audit
>>> filter, for example:
>>>
>>>  % auditctl -a task,never
>>
>> As has been brought up, the issue we're facing is that distros have
>> CONFIG_AUDIT=y and hence the above is the best real world case outside
>> of people doing custom kernels. My question would then be how much
>> overhead the above will add, considering it's an entry/exit call per op.
>> If auditctl is turned off, what is the expectation in turns of overhead?
> 
> I commented on that case in my last email to Pavel, but I'll try to go
> over it again in a little more detail.
> 
> As we discussed earlier in this thread, we can skip the req->opcode
> check before both the _entry and _exit calls, so we are left with just
> the bare audit calls in the io_uring code.  As the _entry and _exit
> functions are small, I've copied them and their supporting functions
> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
> "task,never" case.
> 
> +  static inline struct audit_context *audit_context(void)
> +  {
> +    return current->audit_context;
> +  }
> 
> +  static inline bool audit_dummy_context(void)
> +  {
> +    void *p = audit_context();
> +    return !p || *(int *)p;
> +  }
> 
> +  static inline void audit_uring_entry(u8 op)
> +  {
> +    if (unlikely(audit_enabled && audit_context()))
> +      __audit_uring_entry(op);
> +  }
> 
> We have one if statement where the conditional checks on two
> individual conditions.  The first (audit_enabled) is simply a check to
> see if anyone has "turned on" auditing at runtime; historically this
> worked rather well, and still does in a number of places, but ever
> since systemd has taken to forcing audit on regardless of the admin's
> audit configuration it is less useful.  The second (audit_context())
> is a check to see if an audit_context has been allocated for the
> current task.  In the case of "task,never" current->audit_context will
> be NULL (see audit_alloc()) and the __audit_uring_entry() slowpath
> will never be called.
> 
> Worst case here is checking the value of audit_enabled and
> current->audit_context.  Depending on which you think is more likely
> we can change the order of the check so that the
> current->audit_context check is first if you feel that is more likely
> to be NULL than audit_enabled is to be false (it may be that way now).
> 
> +  static inline void audit_uring_exit(int success, long code)
> +  {
> +    if (unlikely(!audit_dummy_context()))
> +      __audit_uring_exit(success, code);
> +  }
> 
> The exit call is very similar to the entry call, but in the
> "task,never" case it is very simple as the first check to be performed
> is the current->audit_context check which we know to be NULL.  The
> __audit_uring_exit() slowpath will never be called.

I actually ran some numbers this morning. The test base is 5.13+, and
CONFIG_AUDIT=y and CONFIG_AUDITSYSCALL=y is set for both the baseline
test and the test with this series applied. I used your git branch as of
this morning.

The test case is my usual peak perf test, which is random reads at
QD=128 and using polled IO. It's a single core test, not threaded. I ran
two different tests - one was having a thread just do the IO, the other
is using SQPOLL to do the IO for us. The device is capable than more
IOPS than a single core can deliver, so we're CPU limited in this test.
Hence it's a good test case as it does actual work, and shows software
overhead quite nicely. Runs are very stable (less than 0.5% difference
between runs on the same base), yet I did average 4 runs.

Kernel		SQPOLL		IOPS		Perf diff
---------------------------------------------------------
5.13		0		3029872		0.0%
5.13		1		3031056		0.0%
5.13 + audit	0		2894160		-4.5%
5.13 + audit	1		2886168		-4.8%

That's an immediate drop in perf of almost 5%. Looking at a quick
profile of it (nothing fancy, just checking for 'audit' in the profile)
shows this:

+    2.17%  io_uring  [kernel.vmlinux]  [k] __audit_uring_entry
+    0.71%  io_uring  [kernel.vmlinux]  [k] __audit_uring_exit
     0.07%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_entry
     0.02%  io_uring  [kernel.vmlinux]  [k] __audit_syscall_exit

Note that this is with _no_ rules!

>> aio never had any audit logging as far as I can tell. I think it'd make
>> a lot more sense to selectively enable audit logging only for opcodes
>> that we care about. File open/create/unlink/mkdir etc, that kind of
>> thing. File level operations that people would care about logging. Would
>> they care about logging a buffer registration or a polled read from a
>> device/file? I highly doubt it, and we don't do that for alternative
>> methods either. Doesn't really make sense for a lot of the other
>> operations, imho.
> 
> We would need to check with the current security requirements (there
> are distro people on the linux-audit list that keep track of that
> stuff), but looking at the opcodes right now my gut feeling is that
> most of the opcodes would be considered "security relevant" so
> selective auditing might not be that useful in practice.  It would
> definitely clutter the code and increase the chances that new opcodes
> would not be properly audited when they are merged.

We don't audit read/write from aio, as mentioned. In the past two
decades, I take it that hasn't been a concern? I agree that some opcodes
should _definitely_ be audited. Things like opening a file, closing a
file, removing/creating a file, mount, etc. But normal read/write, I
think that's just utter noise and not useful at all. Auditing on a
per-opcode basis is trivial, io_uring already has provisions for
flagging opcode requirements and this would just be another one.

-- 
Jens Axboe

