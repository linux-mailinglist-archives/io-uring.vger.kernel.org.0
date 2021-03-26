Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0957834AE30
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 19:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbhCZSBx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 14:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbhCZSBo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 14:01:44 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F905C0613AA;
        Fri, 26 Mar 2021 11:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=7GniqRgzCLvZmOx96mv2S+cpvm0g0MahWxmtLxbiybw=; b=pWTDbLuQOaerMBtIIHWy8RQFR2
        Ng9qZNkYKCtBIalSGGJrzArqkb3Ljz0EwAbiKOScYmgGhX6cewWoP4GQw411Hq10GVjRapGoOIx/H
        bSH70mlnFG1OYxiHKcva8lgI+ACi8yDCD0DJNIF4ltCRTV9ik7gzh/C7oJfooaR178H24EIGiSux3
        4WkT7XlthfJ1m6PttTiumD4ecycuasRWjtirApecSrzawSHN0RejYHQVFPgY8ZvlhuBKE0gyJDYVI
        bTv1dbGH5s7n7lbnUtXDI8FXJ5cUAI3BzndG49NbmH6xk3xq1Tb5aoOtvWdnxvp5DKpTRq5FP4UpY
        /s5JXGDSN22YaKQVS0HKj6SQOPGQIWzhwlmndi7uO2J54X63CyqsvGvLLSKzaAvtlNJdP3GdVf/FH
        JC6DbVEYPUfphVyrGRYqGwmL73ch9bQ3m9GMOkAI/grcECyhkAdmgw8H5PnXkxr0O9iJhejnsqAC1
        T2G53SYN9i87L9NtgoTzopMy;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPqmA-0004bj-F7; Fri, 26 Mar 2021 18:01:38 +0000
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk> <20210326134840.GA1290@redhat.com>
 <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
 <8f2a4b48-77c9-393f-5194-100ed63c05fc@samba.org>
 <58f67a8b-166e-f19c-ccac-157153e4f17c@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <c61fc5eb-c997-738b-1a60-5e3db2754f49@samba.org>
Date:   Fri, 26 Mar 2021 19:01:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <58f67a8b-166e-f19c-ccac-157153e4f17c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.03.21 um 16:29 schrieb Jens Axboe:
> On 3/26/21 9:23 AM, Stefan Metzmacher wrote:
>> Am 26.03.21 um 16:01 schrieb Jens Axboe:
>>> On 3/26/21 7:48 AM, Oleg Nesterov wrote:
>>>> Jens, sorry, I got lost :/
>>>
>>> Let's bring you back in :-)
>>>
>>>> On 03/25, Jens Axboe wrote:
>>>>>
>>>>> With IO threads accepting signals, including SIGSTOP,
>>>>
>>>> where can I find this change? Looks like I wasn't cc'ed...
>>>
>>> It's this very series.
>>>
>>>>> unmask the
>>>>> SIGSTOP signal from the default blocked mask.
>>>>>
>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>>> ---
>>>>>  kernel/fork.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>>>> index d3171e8e88e5..d5a40552910f 100644
>>>>> --- a/kernel/fork.c
>>>>> +++ b/kernel/fork.c
>>>>> @@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>>>>>  	tsk = copy_process(NULL, 0, node, &args);
>>>>>  	if (!IS_ERR(tsk)) {
>>>>>  		sigfillset(&tsk->blocked);
>>>>> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
>>>>> +		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
>>>>
>>>> siginitsetinv(blocked, sigmask(SIGKILL)|sigmask(SIGSTOP)) but this is minor.
>>>
>>> Ah thanks.
>>>
>>>> To remind, either way this is racy and can't really help.
>>>>
>>>> And if "IO threads accepting signals" then I don't understand why. Sorry,
>>>> I must have missed something.
>>>
>>> I do think the above is a no-op at this point, and we can probably just
>>> kill it. Let me double check, hopefully we can just remove this blocked
>>> part.
>>
>> Is this really correct to drop in your "kernel: stop masking signals in create_io_thread()"
>> commit?
>>
>> I don't assume signals wanted by userspace should potentially handled in an io_thread...
>> e.g. things set with fcntl(fd, F_SETSIG,) used together with F_SETLEASE?
> 
> I guess we do actually need it, if we're not fiddling with
> wants_signal() for them. To quell Oleg's concerns, we can just move it
> to post dup_task_struct(), that should eliminate any race concerns
> there.

If that one is racy, don' we better also want this one?
https://lore.kernel.org/io-uring/438b738c1e4827a7fdfe43087da88bbe17eedc72.1616197787.git.metze@samba.org/T/#u

And clear tsk->pf_io_worker ?

metze
