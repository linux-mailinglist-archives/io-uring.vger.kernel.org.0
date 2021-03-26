Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAC034B21E
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 23:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhCZWYh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 18:24:37 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45548 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhCZWYK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 18:24:10 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPusC-000XAB-LB; Fri, 26 Mar 2021 16:24:08 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lPusB-00BL1H-2w; Fri, 26 Mar 2021 16:24:08 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, torvalds@linux-foundation.org,
        metze@samba.org, oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326155128.1057078-1-axboe@kernel.dk>
        <20210326155128.1057078-3-axboe@kernel.dk>
        <m1wntty7yn.fsf@fess.ebiederm.org>
        <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk>
Date:   Fri, 26 Mar 2021 17:23:08 -0500
In-Reply-To: <106a38d3-5a5f-17fd-41f7-890f5e9a3602@kernel.dk> (Jens Axboe's
        message of "Fri, 26 Mar 2021 16:14:48 -0600")
Message-ID: <m1k0ptv9kj.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lPusB-00BL1H-2w;;;mid=<m1k0ptv9kj.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/shYyeRWs6JVLWuaWNXtLje+PNW5eZ8CQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4999]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1081 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 18 (1.6%), b_tie_ro: 16 (1.4%), parse: 2.1 (0.2%),
         extract_message_metadata: 16 (1.5%), get_uri_detail_list: 1.79 (0.2%),
         tests_pri_-1000: 6 (0.5%), tests_pri_-950: 1.54 (0.1%),
        tests_pri_-900: 1.13 (0.1%), tests_pri_-90: 60 (5.5%), check_bayes: 58
        (5.4%), b_tokenize: 8 (0.7%), b_tok_get_all: 8 (0.7%), b_comp_prob:
        2.6 (0.2%), b_tok_touch_all: 36 (3.3%), b_finish: 1.32 (0.1%),
        tests_pri_0: 231 (21.3%), check_dkim_signature: 0.68 (0.1%),
        check_dkim_adsp: 2.5 (0.2%), poll_dns_idle: 710 (65.6%), tests_pri_10:
        3.1 (0.3%), tests_pri_500: 738 (68.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/7] io_uring: handle signals for IO threads like a normal thread
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 3/26/21 2:29 PM, Eric W. Biederman wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> We go through various hoops to disallow signals for the IO threads, but
>>> there's really no reason why we cannot just allow them. The IO threads
>>> never return to userspace like a normal thread, and hence don't go through
>>> normal signal processing. Instead, just check for a pending signal as part
>>> of the work loop, and call get_signal() to handle it for us if anything
>>> is pending.
>>>
>>> With that, we can support receiving signals, including special ones like
>>> SIGSTOP.
>>>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>  fs/io-wq.c    | 24 +++++++++++++++++-------
>>>  fs/io_uring.c | 12 ++++++++----
>>>  2 files changed, 25 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index b7c1fa932cb3..3e2f059a1737 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -16,7 +16,6 @@
>>>  #include <linux/rculist_nulls.h>
>>>  #include <linux/cpu.h>
>>>  #include <linux/tracehook.h>
>>> -#include <linux/freezer.h>
>>>  
>>>  #include "../kernel/sched/sched.h"
>>>  #include "io-wq.h"
>>> @@ -503,10 +502,16 @@ static int io_wqe_worker(void *data)
>>>  		if (io_flush_signals())
>>>  			continue;
>>>  		ret = schedule_timeout(WORKER_IDLE_TIMEOUT);
>>> -		if (try_to_freeze() || ret)
>>> +		if (signal_pending(current)) {
>>> +			struct ksignal ksig;
>>> +
>>> +			if (fatal_signal_pending(current))
>>> +				break;
>>> +			if (get_signal(&ksig))
>>> +				continue;
>>                         ^^^^^^^^^^^^^^^^^^^^^^
>> 
>> That is wrong.  You are promising to deliver a signal to signal
>> handler and them simply discarding it.  Perhaps:
>> 
>> 			if (!get_signal(&ksig))
>>                         	continue;
>> 			WARN_ON(!sig_kernel_stop(ksig->sig));
>>                         break;
>
> Thanks, updated.

Gah.  Kill the WARN_ON.

I was thinking "WARN_ON(!sig_kernel_fatal(ksig->sig));"
The function sig_kernel_fatal does not exist.

Fatal is the state that is left when a signal is neither
ignored nor a stop signal, and does not have a handler.

The rest of the logic still works.

Eric

