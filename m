Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746F6419845
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 17:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhI0PyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 11:54:18 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:37860 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235307AbhI0PyR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 11:54:17 -0400
Received: from in02.mta.xmission.com ([166.70.13.52]:33456)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mUsvm-00HYwN-GR; Mon, 27 Sep 2021 09:52:38 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:56866 helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mUsvl-00ElU9-Ao; Mon, 27 Sep 2021 09:52:38 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
        <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
        <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk>
        <87lf3iazyu.fsf@disp2133>
        <feb00062-647c-1c74-dbe1-a7729ca49d7d@kernel.dk>
        <521162e9-c7e4-284e-e575-51c503c51793@kernel.dk>
        <878rzi831l.fsf@disp2133>
        <f49ac7d4-d0a1-d05e-804b-f784a2ee028d@kernel.dk>
Date:   Mon, 27 Sep 2021 10:52:03 -0500
In-Reply-To: <f49ac7d4-d0a1-d05e-804b-f784a2ee028d@kernel.dk> (Jens Axboe's
        message of "Mon, 27 Sep 2021 09:41:48 -0600")
Message-ID: <87wnn26mos.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mUsvl-00ElU9-Ao;;;mid=<87wnn26mos.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/DPov77KEizP5m4Wxy4XhQGizZZYZrjnw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubMetaSxObfu_03,XMSubMetaSx_00,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4989]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
        *  1.0 XMSubMetaSx_00 1+ Sexy Words
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 491 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 12 (2.4%), b_tie_ro: 10 (2.1%), parse: 1.18
        (0.2%), extract_message_metadata: 15 (3.0%), get_uri_detail_list: 3.2
        (0.6%), tests_pri_-1000: 18 (3.7%), tests_pri_-950: 1.33 (0.3%),
        tests_pri_-900: 1.01 (0.2%), tests_pri_-90: 78 (15.9%), check_bayes:
        76 (15.6%), b_tokenize: 10 (2.0%), b_tok_get_all: 9 (1.9%),
        b_comp_prob: 3.1 (0.6%), b_tok_touch_all: 50 (10.2%), b_finish: 1.17
        (0.2%), tests_pri_0: 345 (70.2%), check_dkim_signature: 0.77 (0.2%),
        check_dkim_adsp: 3.3 (0.7%), poll_dns_idle: 0.87 (0.2%), tests_pri_10:
        3.9 (0.8%), tests_pri_500: 12 (2.4%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 9/27/21 9:13 AM, Eric W. Biederman wrote:
>> Jens Axboe <axboe@kernel.dk> writes:
>> 
>>> On 9/27/21 8:29 AM, Jens Axboe wrote:
>>>> On 9/27/21 7:51 AM, Eric W. Biederman wrote:
>>>>> Jens Axboe <axboe@kernel.dk> writes:
>>>>>
>>>>>> On 9/25/21 5:05 PM, Linus Torvalds wrote:
>>>>>>> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>
>>>>>>>> - io-wq core dump exit fix (me)
>>>>>>>
>>>>>>> Hmm.
>>>>>>>
>>>>>>> That one strikes me as odd.
>>>>>>>
>>>>>>> I get the feeling that if the io_uring thread needs to have that
>>>>>>> signal_group_exit() test, something is wrong in signal-land.
>>>>>>>
>>>>>>> It's basically a "fatal signal has been sent to another thread", and I
>>>>>>> really get the feeling that "fatal_signal_pending()" should just be
>>>>>>> modified to handle that case too.
>>>>>>
>>>>>> It did surprise me as well, which is why that previous change ended up
>>>>>> being broken for the coredump case... You could argue that the io-wq
>>>>>> thread should just exit on signal_pending(), which is what we did
>>>>>> before, but that really ends up sucking for workloads that do use
>>>>>> signals for communication purposes. postgres was the reporter here.
>>>>>
>>>>> The primary function get_signal is to make signals not pending.  So I
>>>>> don't understand any use of testing signal_pending after a call to
>>>>> get_signal.
>>>>>
>>>>> My confusion doubles when I consider the fact io_uring threads should
>>>>> only be dequeuing SIGSTOP and SIGKILL.
>>>>>
>>>>> I am concerned that an io_uring thread that dequeues SIGKILL won't call
>>>>> signal_group_exit and thus kill the other threads in the thread group.
>>>>>
>>>>> What motivated removing the break and adding the fatal_signal_pending
>>>>> test?
>>>>
>>>> I played with this a bit this morning, and I agree it doesn't seem to be
>>>> needed at all. The original issue was with postgres, I'll give that a
>>>> whirl as well and see if we run into any unwarranted exits. My simpler
>>>> test case did not.
>>>
>>> Ran the postgres test, and we get tons of io-wq exiting on get_signal()
>>> returning true. Took a closer look, and it actually looks very much
>>> expected, as it's a SIGKILL to the original task.
>>>
>>> So it looks like I was indeed wrong, and this probably masked the
>>> original issue that was fixed in that series. I've been running with
>>> this:
>>>
>>> diff --git a/fs/io-wq.c b/fs/io-wq.c
>>> index c2360cdc403d..afd1db8e000d 100644
>>> --- a/fs/io-wq.c
>>> +++ b/fs/io-wq.c
>>> @@ -584,10 +584,9 @@ static int io_wqe_worker(void *data)
>>>  
>>>  			if (!get_signal(&ksig))
>>>  				continue;
>>> -			if (fatal_signal_pending(current) ||
>>> -			    signal_group_exit(current->signal))
>>> -				break;
>>> -			continue;
>>> +			if (ksig.sig != SIGKILL)
>>> +				printk("exit on sig! fatal? %d, sig=%d\n", fatal_signal_pending(current), ksig.sig);
>>> +			break;
>>>  		}
>>>  		last_timeout = !ret;
>>>  	}
>>>
>>> and it's running fine and, as expected, we don't generate any printk
>>> activity as these are all fatal deliveries to the parent.
>> 
>> Good.  So just a break should be fine.
>
> Indeed, I'll send out a patch for that.
>
>> A little bit of me is concerned about not calling do_group_exit in this
>> case.  Fortunately it is not a problem as complete_signal kills all of
>> the threads in a signal_group when SIGKILL is delivered.
>> 
>> So at least until something else is refactored and io_uring threads
>> unblock another fatal signal all is well.
>
> Should we put a comment in io-wq to that effect? I don't see why we'd
> ever unblock other signals there, but...

I suspect rather we should update this comment in get_signal
instead.

		/*
		 * PF_IO_WORKER threads will catch and exit on fatal signals
		 * themselves. They have cleanup that must be performed, so
		 * we cannot call do_exit() on their behalf.
		 */
		if (current->flags & PF_IO_WORKER)
			goto out;


Although I would not mind updating io-wq.c and io_uring.c where
they call get_signal as well. 

Eric


