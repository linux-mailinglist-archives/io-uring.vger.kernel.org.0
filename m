Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D22391B81
	for <lists+io-uring@lfdr.de>; Wed, 26 May 2021 17:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbhEZPTW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 May 2021 11:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbhEZPTV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 May 2021 11:19:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2416C061574;
        Wed, 26 May 2021 08:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=co12ff4tTNF+KNx1GGZqG+qS13NxRQukgTFUVlXw18g=; b=X3ttPkyMClgHXbWUbhqY0orK7W
        +6CUwKmekqBcBBt5U7jQbifCtm+WLLTrIPj9aUbT/zsDFP/Beynzw0xsp8TCNDBpdtHxmZBqV0ir5
        S/kGWSFAr+x/4174GRohYjk+RznlTyb1Gj8eN7bqYt6yANCDpGoLCWi1SJSEa9qQd1byheeC/sEoK
        lq88911kkgSJS7hBg0OdN/nGwOs+60RqZVu6SNctSJLKKqE/gkYlJ8BVVuljAZCbZD+CUzwLEifH/
        LXohvn2xUHot/oO1kA/fK1nmEFZ43dKaXiIU8o0LbEW7uTcIe/z+6i9Y+xXRZzf9DqUITyo7hkFcW
        JJL+HTjDOhHzNb0HSP3mVT/8EGnM+scPgnaIEluhFqXwejnLMB8dAzqwTX8YQ4va+ihQedmFKhzo1
        iNfRJAc6IaaRIxta9zxy4amEMgROIBYD2IsWkFqnv+iaVc2RHXm9TxEYp2F6u3IbZPRT+NPOBH3pC
        FCG8fDjgLqB19X7KT8rwoI9a;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1llvI3-0000gU-9J; Wed, 26 May 2021 15:17:47 +0000
To:     Paul Moore <paul@paul-moore.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
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
 <0a668302-b170-31ce-1651-ddf45f63d02a@gmail.com>
 <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH 2/9] audit,io_uring,io-wq: add some basic audit
 support to io_uring
Message-ID: <18823c99-7d65-0e6f-d508-a487f1b4b9e7@samba.org>
Date:   Wed, 26 May 2021 17:17:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAHC9VhTAvcB0A2dpv1Xn7sa+Kh1n+e-dJr_8wSSRaxS4D0f9Sw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 26.05.21 um 16:38 schrieb Paul Moore:
> On Wed, May 26, 2021 at 6:19 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> On 5/26/21 3:04 AM, Paul Moore wrote:
>>> On Tue, May 25, 2021 at 9:11 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 5/24/21 1:59 PM, Paul Moore wrote:
>>>>> That said, audit is not for everyone, and we have build time and
>>>>> runtime options to help make life easier.  Beyond simply disabling
>>>>> audit at compile time a number of Linux distributions effectively
>>>>> shortcut audit at runtime by adding a "never" rule to the audit
>>>>> filter, for example:
>>>>>
>>>>>  % auditctl -a task,never
>>>>
>>>> As has been brought up, the issue we're facing is that distros have
>>>> CONFIG_AUDIT=y and hence the above is the best real world case outside
>>>> of people doing custom kernels. My question would then be how much
>>>> overhead the above will add, considering it's an entry/exit call per op.
>>>> If auditctl is turned off, what is the expectation in turns of overhead?
>>>
>>> I commented on that case in my last email to Pavel, but I'll try to go
>>> over it again in a little more detail.
>>>
>>> As we discussed earlier in this thread, we can skip the req->opcode
>>> check before both the _entry and _exit calls, so we are left with just
>>> the bare audit calls in the io_uring code.  As the _entry and _exit
>>> functions are small, I've copied them and their supporting functions
>>> below and I'll try to explain what would happen in CONFIG_AUDIT=y,
>>> "task,never" case.
>>>
>>> +  static inline struct audit_context *audit_context(void)
>>> +  {
>>> +    return current->audit_context;
>>> +  }
>>>
>>> +  static inline bool audit_dummy_context(void)
>>> +  {
>>> +    void *p = audit_context();
>>> +    return !p || *(int *)p;
>>> +  }
>>>
>>> +  static inline void audit_uring_entry(u8 op)
>>> +  {
>>> +    if (unlikely(audit_enabled && audit_context()))
>>> +      __audit_uring_entry(op);
>>> +  }
>>
>> I'd rather agree that it's my cycle-picking. The case I care about
>> is CONFIG_AUDIT=y (because everybody enable it), and io_uring
>> tracing _not_ enabled at runtime. If enabled let them suffer
>> the overhead, it will probably dip down the performance
>>
>> So, for the case I care about it's two of
>>
>> if (unlikely(audit_enabled && current->audit_context))
>>
>> in the hot path. load-test-jump + current, so it will
>> be around 7x2 instructions. We can throw away audit_enabled
>> as you say systemd already enables it, that will give
>> 4x2 instructions including 2 conditional jumps.
> 
> We've basically got it down to the equivalent of two
> "current->audit_context != NULL" checks in the case where audit is
> built into the kernel but disabled at runtime, e.g. CONFIG_AUDIT=y and
> "task,never".  I'm at a loss for how we can lower the overhead any
> further, but I'm open to suggestions.
> 
>> That's not great at all. And that's why I brought up
>> the question about need of pre and post hooks and whether
>> can be combined. Would be just 4 instructions and that is
>> ok (ish).
> 
> As discussed previously in this thread that isn't really an option
> from an audit perspective.
> 
>>> We would need to check with the current security requirements (there
>>> are distro people on the linux-audit list that keep track of that
>>> stuff), but looking at the opcodes right now my gut feeling is that
>>> most of the opcodes would be considered "security relevant" so
>>> selective auditing might not be that useful in practice.  It would
>>> definitely clutter the code and increase the chances that new opcodes
>>> would not be properly audited when they are merged.
>>
>> I'm curious, why it's enabled by many distros by default? Are there
>> use cases they use?
> 
> We've already talked about certain users and environments where audit
> is an important requirement, e.g. public sector, health care,
> financial institutions, etc.; without audit Linux wouldn't be an
> option for these users, at least not without heavy modification,
> out-of-tree/ISV patches, etc.  I currently don't have any direct ties
> to any distros, "Enterprise" or otherwise, but in the past it has been
> my experience that distros much prefer to have a single kernel build
> to address the needs of all their users.  In the few cases I have seen
> where a second kernel build is supported it is usually for hardware
> enablement.  I'm sure there are other cases too, I just haven't seen
> them personally; the big distros definitely seem to have a strong
> desire to limit the number of supported kernel configs/builds.
> 
>> Tempting to add AUDIT_IOURING=default N, but won't work I guess
> 
> One of the nice things about audit is that it can give you a history
> of what a user did on a system, which is very important for a number
> of use cases.  If we selectively disable audit for certain subsystems
> we create a blind spot in the audit log, and in the case of io_uring
> this can be a very serious blind spot.  I fear that if we can't come
> to some agreement here we will need to make io_uring and audit
> mutually exclusive at build time which would be awful; forcing many
> distros to either make a hard choice or carry out-of-tree patches.

I'm wondering why it's not enough to have the native auditing just to happen.

E.g. all (I have checked RECVMSG,SENDMSG,SEND and CONNECT) socket related io_uring opcodes
already go via security_socket_{recvmsg,sendmsg,connect}()

IORING_OP_OPENAT* goes via do_filp_open() which is in common with the open[at[2]]() syscalls
and should also trigger audit_inode() and security_file_open().

So why is there anything special needed for io_uring (now that the native worker threads are used)?

Is there really any io_uring opcode that bypasses the security checks the corresponding native syscall
would do? If so, I think that should just be fixed...

Additional LSM based restrictions could be hooked into the io_check_restriction() path
and setup at io_uring_setup() or early io_uring_register() time.

What do you think?

metze
