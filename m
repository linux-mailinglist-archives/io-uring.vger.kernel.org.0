Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9CDF41956E
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 15:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbhI0Nxl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 09:53:41 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57116 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234589AbhI0Nxl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 09:53:41 -0400
Received: from in01.mta.xmission.com ([166.70.13.51]:45182)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mUr33-00HJEH-LZ; Mon, 27 Sep 2021 07:52:01 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95]:53126 helo=email.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1mUr32-003njm-Gz; Mon, 27 Sep 2021 07:52:01 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
        <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
        <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk>
Date:   Mon, 27 Sep 2021 08:51:37 -0500
In-Reply-To: <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk> (Jens Axboe's
        message of "Sat, 25 Sep 2021 19:20:52 -0600")
Message-ID: <87lf3iazyu.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mUr32-003njm-Gz;;;mid=<87lf3iazyu.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18DcecB42oMyQcRqO5QuJrJGzTZHwZBVak=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.3 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,XMSubMetaSxObfu_03,XMSubMetaSx_00,XM_B_SpammyWords
        autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
        *  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  1.0 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 377 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 3.6 (0.9%), b_tie_ro: 2.5 (0.7%), parse: 0.63
        (0.2%), extract_message_metadata: 8 (2.2%), get_uri_detail_list: 0.86
        (0.2%), tests_pri_-1000: 12 (3.3%), tests_pri_-950: 0.99 (0.3%),
        tests_pri_-900: 0.82 (0.2%), tests_pri_-90: 139 (36.8%), check_bayes:
        137 (36.5%), b_tokenize: 4.2 (1.1%), b_tok_get_all: 6 (1.6%),
        b_comp_prob: 1.41 (0.4%), b_tok_touch_all: 123 (32.8%), b_finish: 0.63
        (0.2%), tests_pri_0: 201 (53.3%), check_dkim_signature: 0.59 (0.2%),
        check_dkim_adsp: 2.4 (0.6%), poll_dns_idle: 0.97 (0.3%), tests_pri_10:
        1.76 (0.5%), tests_pri_500: 7 (1.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 9/25/21 5:05 PM, Linus Torvalds wrote:
>> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> - io-wq core dump exit fix (me)
>> 
>> Hmm.
>> 
>> That one strikes me as odd.
>> 
>> I get the feeling that if the io_uring thread needs to have that
>> signal_group_exit() test, something is wrong in signal-land.
>> 
>> It's basically a "fatal signal has been sent to another thread", and I
>> really get the feeling that "fatal_signal_pending()" should just be
>> modified to handle that case too.
>
> It did surprise me as well, which is why that previous change ended up
> being broken for the coredump case... You could argue that the io-wq
> thread should just exit on signal_pending(), which is what we did
> before, but that really ends up sucking for workloads that do use
> signals for communication purposes. postgres was the reporter here.

The primary function get_signal is to make signals not pending.  So I
don't understand any use of testing signal_pending after a call to
get_signal.

My confusion doubles when I consider the fact io_uring threads should
only be dequeuing SIGSTOP and SIGKILL.

I am concerned that an io_uring thread that dequeues SIGKILL won't call
signal_group_exit and thus kill the other threads in the thread group.

What motivated removing the break and adding the fatal_signal_pending
test?

Eric

