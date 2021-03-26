Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 186BD34AB68
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 16:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhCZPXx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 11:23:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhCZPXl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 11:23:41 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7827C0613AA;
        Fri, 26 Mar 2021 08:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=g2ov54Wvo719yXCzrq89z7p3cmF5FT7ALxcJeE1hBUY=; b=jpEeDMsPWOwCg4VMrXNgjU7A+I
        B2cqHaZxWCmb4BVbKEW2NC60WH8DoH3fWQ6/HBxhNNr+v8m4en3kxjaaDw+Phqk6dWjdCubNnAUdc
        97bD4zPs9wOiyiv1dFscVZ/tGUHj4icowgl0NXSOWEx3heIAtWQn3iVYCd9OrXufJyCqOV6+MfDh2
        7SjyG9vItBPfFR3MekyT16iznp+CechmpcCNHNHISd7sgK64u2Tc7dkYamoILEJaFoC4gLS5VlO/N
        jCgfS1PcEJr5YoiFRXeU+J0C3Uxqm3K0TZ6S4hlHeG3BYwQ8rVZ3auJa30vq4gNwVGYGv4A0V6vtb
        1eUKo25DDqxCrF0PL8c0Bx2ML//bneHPHSmg4+KFgNJ5upZpr280tU+3ADPYW70oedh9EZRKpHbGp
        k0ToLT1HxPhXRwWpuhNt5Zq9VXb5fhLizPvUx6ty1yzTf7hUR16PqYKgb9gmjUoxr3rq4fHkOpYSH
        eXrPmAUBR9tSaAKYIJ0wuI+B;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lPoJF-0003W2-Ge; Fri, 26 Mar 2021 15:23:37 +0000
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        ebiederm@xmission.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <20210326003928.978750-3-axboe@kernel.dk> <20210326134840.GA1290@redhat.com>
 <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH 2/8] kernel: unmask SIGSTOP for IO threads
Message-ID: <8f2a4b48-77c9-393f-5194-100ed63c05fc@samba.org>
Date:   Fri, 26 Mar 2021 16:23:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <a179ad33-5656-b644-0d92-e74a6bd26cc8@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 26.03.21 um 16:01 schrieb Jens Axboe:
> On 3/26/21 7:48 AM, Oleg Nesterov wrote:
>> Jens, sorry, I got lost :/
> 
> Let's bring you back in :-)
> 
>> On 03/25, Jens Axboe wrote:
>>>
>>> With IO threads accepting signals, including SIGSTOP,
>>
>> where can I find this change? Looks like I wasn't cc'ed...
> 
> It's this very series.
> 
>>> unmask the
>>> SIGSTOP signal from the default blocked mask.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  kernel/fork.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/fork.c b/kernel/fork.c
>>> index d3171e8e88e5..d5a40552910f 100644
>>> --- a/kernel/fork.c
>>> +++ b/kernel/fork.c
>>> @@ -2435,7 +2435,7 @@ struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
>>>  	tsk = copy_process(NULL, 0, node, &args);
>>>  	if (!IS_ERR(tsk)) {
>>>  		sigfillset(&tsk->blocked);
>>> -		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL));
>>> +		sigdelsetmask(&tsk->blocked, sigmask(SIGKILL)|sigmask(SIGSTOP));
>>
>> siginitsetinv(blocked, sigmask(SIGKILL)|sigmask(SIGSTOP)) but this is minor.
> 
> Ah thanks.
> 
>> To remind, either way this is racy and can't really help.
>>
>> And if "IO threads accepting signals" then I don't understand why. Sorry,
>> I must have missed something.
> 
> I do think the above is a no-op at this point, and we can probably just
> kill it. Let me double check, hopefully we can just remove this blocked
> part.

Is this really correct to drop in your "kernel: stop masking signals in create_io_thread()"
commit?

I don't assume signals wanted by userspace should potentially handled in an io_thread...
e.g. things set with fcntl(fd, F_SETSIG,) used together with F_SETLEASE?

metze

