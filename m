Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C373F3A1E84
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 23:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFIVHf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 17:07:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46516 "EHLO
        out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhFIVHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 17:07:34 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out02.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lr5ON-0049fj-1f; Wed, 09 Jun 2021 15:05:39 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lr5OL-000F8v-4H; Wed, 09 Jun 2021 15:05:38 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov\>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
        <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
Date:   Wed, 09 Jun 2021 16:05:29 -0500
In-Reply-To: <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
        (Olivier Langlois's message of "Wed, 09 Jun 2021 17:02:05 -0400")
Message-ID: <87eeda7nqe.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lr5OL-000F8v-4H;;;mid=<87eeda7nqe.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/SZKsQtgDKCsReGzr60p+CHQwK8l82Kxw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Olivier Langlois <olivier@trillion01.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1340 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 10 (0.7%), b_tie_ro: 8 (0.6%), parse: 0.76 (0.1%),
         extract_message_metadata: 11 (0.8%), get_uri_detail_list: 0.95 (0.1%),
         tests_pri_-1000: 9 (0.6%), tests_pri_-950: 1.25 (0.1%),
        tests_pri_-900: 1.01 (0.1%), tests_pri_-90: 111 (8.3%), check_bayes:
        105 (7.8%), b_tokenize: 6 (0.4%), b_tok_get_all: 7 (0.5%),
        b_comp_prob: 1.94 (0.1%), b_tok_touch_all: 87 (6.5%), b_finish: 0.92
        (0.1%), tests_pri_0: 1185 (88.4%), check_dkim_signature: 0.56 (0.0%),
        check_dkim_adsp: 3.0 (0.2%), poll_dns_idle: 0.96 (0.1%), tests_pri_10:
        2.2 (0.2%), tests_pri_500: 7 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Olivier Langlois <olivier@trillion01.com> writes:

> On Wed, 2021-06-09 at 13:33 -0700, Linus Torvalds wrote:
>> Now, the fact that we haven't cleared TIF_NOTIFY_SIGNAL for the first
>> signal is clearly the immediate cause of this, but at the same time I
>> really get the feeling that that coredump aborting code should always
>> had used fatal_signal_pending().
>
> I need clarify what does happen with the io_uring situation. If
> somehow, TIF_NOTIFY_SIGNAL wasn't cleared, I would get all the time a 0
> byte size core dump because do_coredump() does check if the dump is
> interrupted before writing a single byte.
>
> io_uring is quite a strange animal. AFAIK, the common pattern to use a
> wait_queue is to insert a task into it and then put that task to sleep
> until the waited event occur.
>
> io_uring place tasks into wait queues and then let the the task return
> to user space to do some other stuff (like core dumping). I would guess
> that it is the main reason for it using the task_work feature.
>
> So the TIF_NOTIFY_SIGNAL does get set WHILE the core dump is written.

Did you mean?

So the TIF_NOTIFY_SIGNAL does _not_ get set WHILE the core dump is written.

Eric
