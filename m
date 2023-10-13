Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32207C8E20
	for <lists+io-uring@lfdr.de>; Fri, 13 Oct 2023 22:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231902AbjJMUGU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Oct 2023 16:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231707AbjJMUGT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Oct 2023 16:06:19 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7D60B7;
        Fri, 13 Oct 2023 13:06:17 -0700 (PDT)
Received: from [192.168.7.187] (pool-72-77-59-129.pitbpa.fios.verizon.net [72.77.59.129])
        by linux.microsoft.com (Postfix) with ESMTPSA id B2B8120B74C0;
        Fri, 13 Oct 2023 13:06:16 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B2B8120B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1697227577;
        bh=xoKklGFnQggRTNMZpyLB1ZexVKJ4U9krNfxQ+3+ZUhI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=TS7ygbJ/cMYAAjVfnFfnImCzrYQ6bGVzRBm+P0Dsk6O3F3u9VTdbcvygJKNlUsTi+
         ouyT+c6gfLKbOlD0JEkfNDGsaW6DRnQusYCBu5xJzzeLzmsN3xXSyp/jHJGXzl8DRP
         0OGHC554QkXuyNxP6qsBvbJpHeGzcQMu5OK4Bdgw=
Message-ID: <19d3cb0b-e5ec-4a35-9ec5-06522903a80c@linux.microsoft.com>
Date:   Fri, 13 Oct 2023 16:06:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] audit,io_uring: io_uring openat triggers audit reference
 count underflow
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Christian Brauner <brauner@kernel.org>, audit@vger.kernel.org,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.clash@microsoft.com
References: <20231012215518.GA4048@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20231013-insofern-gegolten-75ca48b24cf5@brauner>
 <672d257e-e28f-42bc-8ac7-253d20fe187c@kernel.dk>
 <CAHC9VhQcSY9q=wVT7hOz9y=o3a67BVUnVGNotgAvE6vK7WAkBw@mail.gmail.com>
From:   Dan Clash <daclash@linux.microsoft.com>
In-Reply-To: <CAHC9VhQcSY9q=wVT7hOz9y=o3a67BVUnVGNotgAvE6vK7WAkBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,SPF_HELO_PASS,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2023-10-13 11:43, Paul Moore wrote:
> On Fri, Oct 13, 2023 at 10:21 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/13/23 2:24 AM, Christian Brauner wrote:
>>> On Thu, Oct 12, 2023 at 02:55:18PM -0700, Dan Clash wrote:
>>>> An io_uring openat operation can update an audit reference count
>>>> from multiple threads resulting in the call trace below.
>>>>
>>>> A call to io_uring_submit() with a single openat op with a flag of
>>>> IOSQE_ASYNC results in the following reference count updates.
>>>>
>>>> These first part of the system call performs two increments that do not race.
>>>>
>>>> do_syscall_64()
>>>>    __do_sys_io_uring_enter()
>>>>      io_submit_sqes()
>>>>        io_openat_prep()
>>>>          __io_openat_prep()
>>>>            getname()
>>>>              getname_flags()       /* update 1 (increment) */
>>>>                __audit_getname()   /* update 2 (increment) */
>>>>
>>>> The openat op is queued to an io_uring worker thread which starts the
>>>> opportunity for a race.  The system call exit performs one decrement.
>>>>
>>>> do_syscall_64()
>>>>    syscall_exit_to_user_mode()
>>>>      syscall_exit_to_user_mode_prepare()
>>>>        __audit_syscall_exit()
>>>>          audit_reset_context()
>>>>             putname()              /* update 3 (decrement) */
>>>>
>>>> The io_uring worker thread performs one increment and two decrements.
>>>> These updates can race with the system call decrement.
>>>>
>>>> io_wqe_worker()
>>>>    io_worker_handle_work()
>>>>      io_wq_submit_work()
>>>>        io_issue_sqe()
>>>>          io_openat()
>>>>            io_openat2()
>>>>              do_filp_open()
>>>>                path_openat()
>>>>                  __audit_inode()   /* update 4 (increment) */
>>>>              putname()             /* update 5 (decrement) */
>>>>          __audit_uring_exit()
>>>>            audit_reset_context()
>>>>              putname()             /* update 6 (decrement) */
>>>>
>>>> The fix is to change the refcnt member of struct audit_names
>>>> from int to atomic_t.
>>>>
>>>> kernel BUG at fs/namei.c:262!
>>>> Call Trace:
>>>> ...
>>>>   ? putname+0x68/0x70
>>>>   audit_reset_context.part.0.constprop.0+0xe1/0x300
>>>>   __audit_uring_exit+0xda/0x1c0
>>>>   io_issue_sqe+0x1f3/0x450
>>>>   ? lock_timer_base+0x3b/0xd0
>>>>   io_wq_submit_work+0x8d/0x2b0
>>>>   ? __try_to_del_timer_sync+0x67/0xa0
>>>>   io_worker_handle_work+0x17c/0x2b0
>>>>   io_wqe_worker+0x10a/0x350
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>> Link: https://lore.kernel.org/lkml/MW2PR2101MB1033FFF044A258F84AEAA584F1C9A@MW2PR2101MB1033.namprd21.prod.outlook.com/
>>>> Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
>>>> Signed-off-by: Dan Clash <daclash@linux.microsoft.com>
>>>> ---
>>>>   fs/namei.c         | 9 +++++----
>>>>   include/linux/fs.h | 2 +-
>>>>   kernel/auditsc.c   | 8 ++++----
>>>>   3 files changed, 10 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/fs/namei.c b/fs/namei.c
>>>> index 567ee547492b..94565bd7e73f 100644
>>>> --- a/fs/namei.c
>>>> +++ b/fs/namei.c
>>>> @@ -188,7 +188,7 @@ getname_flags(const char __user *filename, int flags, int *empty)
>>>>               }
>>>>       }
>>>>
>>>> -    result->refcnt = 1;
>>>> +    atomic_set(&result->refcnt, 1);
>>>>       /* The empty path is special. */
>>>>       if (unlikely(!len)) {
>>>>               if (empty)
>>>> @@ -249,7 +249,7 @@ getname_kernel(const char * filename)
>>>>       memcpy((char *)result->name, filename, len);
>>>>       result->uptr = NULL;
>>>>       result->aname = NULL;
>>>> -    result->refcnt = 1;
>>>> +    atomic_set(&result->refcnt, 1);
>>>>       audit_getname(result);
>>>>
>>>>       return result;
>>>> @@ -261,9 +261,10 @@ void putname(struct filename *name)
>>>>       if (IS_ERR(name))
>>>>               return;
>>>>
>>>> -    BUG_ON(name->refcnt <= 0);
>>>> +    if (WARN_ON_ONCE(!atomic_read(&name->refcnt)))
>>>> +            return;
>>>>
>>>> -    if (--name->refcnt > 0)
>>>> +    if (!atomic_dec_and_test(&name->refcnt))
>>>>               return;
>>>
>>> Fine by me. I'd write this as:
>>>
>>> count = atomic_dec_if_positive(&name->refcnt);
>>> if (WARN_ON_ONCE(unlikely(count < 0))
>>>        return;
>>> if (count > 0)
>>>        return;
>>
>> Would be fine too, my suspicion was that most archs don't implement a
>> primitive for that, and hence it might be more expensive than
>> atomic_read()/atomic_dec_and_test() which do. But I haven't looked at
>> the code generation. The dec_if_positive degenerates to a atomic cmpxchg
>> for most cases.
> 
> I'm not too concerned, either approach works for me, the important bit
> is moving to an atomic_t/refcount_t so we can protect ourselves
> against the race.  The patch looks good to me and I'd like to get this
> fix merged.
> 
> Dan, barring any further back-and-forth on the putname() change, I
> would say to go ahead and make the change Christian suggested and
> repost the patch.  Based on Jens comment above it seems safe to
> preserve his 'Reviewed-by:' tag on the next revision.  Assuming there
> are no objections posted in the meantime, I'll plan to merge the next
> revision into the audit/stable-6.6 branch and get that up to Linus
> (likely next week since it's Friday).

I did not see many arch implementations of atomic_dec_if_positive.
The x86_64 generated code looks like arch_atomic_dec_unless_positive()
in atomic-arch-fallback.h with a loop around lock cmpxchg.

I did not want to compound the email race so I did not send patch v2 but 
I can if desired.


devvm2 ~/linux $ sysctl kernel.arch
kernel.arch = x86_64

devvm2 ~/linux $ cat -n ./fs/namei.c | grep -B 7 -A 4 atomic_dec_if_positive
    259  void putname(struct filename *name)
    260  {
    261          int count;
    262
    263          if (IS_ERR(name))
    264                  return;
    265
    266          count = atomic_dec_if_positive(&name->refcnt);
    267          if (WARN_ON_ONCE(unlikely(count < 0)))
    268                  return;
    269          if (count > 0)
    270                  return;

devvm2 ~/linux $ objdump --disassemble --line-numbers ./fs/namei.o | \
grep -B 8 -A 12 atomic_dec_if_positive
/home/daclash/linux/fs/namei.c:260
      22e:       55                      push   %rbp
      22f:       48 89 e5                mov    %rsp,%rbp
      232:       41 54                   push   %r12
arch_atomic_read():
/home/daclash/linux/./arch/x86/include/asm/atomic.h:23
      234:       8b 47 10                mov    0x10(%rdi),%eax
      237:       49 89 fc                mov    %rdi,%r12
raw_atomic_dec_if_positive():
/home/daclash/linux/./include/linux/atomic/atomic-arch-fallback.h:2535
      23a:       89 c2                   mov    %eax,%edx
      23c:       83 ea 01                sub    $0x1,%edx
      23f:       78 50                   js     291 <putname+0x71>
arch_atomic_try_cmpxchg():
/home/daclash/linux/./arch/x86/include/asm/atomic.h:115
      241:       f0 41 0f b1 54 24 10    lock cmpxchg %edx,0x10(%r12)
      248:       75 f0                   jne    23a <putname+0x1a>
putname():
/home/daclash/linux/fs/namei.c:269
      24a:       85 d2                   test   %edx,%edx
      24c:       75 22                   jne    270 <putname+0x50>

