Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C509B4D924E
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 02:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237890AbiCOBrn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 21:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235808AbiCOBrn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 21:47:43 -0400
X-Greylist: delayed 6453 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 14 Mar 2022 18:46:31 PDT
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F1717AAD
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 18:46:31 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:44796)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nTuaW-002q7m-4N; Mon, 14 Mar 2022 17:58:56 -0600
Received: from ip68-227-174-4.om.om.cox.net ([68.227.174.4]:37744 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1nTuaU-005KY7-2l; Mon, 14 Mar 2022 17:58:55 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
        <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
        <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
        <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
        <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
Date:   Mon, 14 Mar 2022 18:58:28 -0500
In-Reply-To: <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com> (Pavel
        Begunkov's message of "Tue, 28 Dec 2021 11:24:56 +0000")
Message-ID: <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1nTuaU-005KY7-2l;;;mid=<87ilsg13yz.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.174.4;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/LDPq3+2z3H5H31TkqwIyz8Jul6I65E2g=
X-SA-Exim-Connect-IP: 68.227.174.4
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Pavel Begunkov <asml.silence@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1454 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 11 (0.8%), b_tie_ro: 10 (0.7%), parse: 1.07
        (0.1%), extract_message_metadata: 13 (0.9%), get_uri_detail_list: 2.2
        (0.1%), tests_pri_-1000: 6 (0.4%), tests_pri_-950: 1.37 (0.1%),
        tests_pri_-900: 1.09 (0.1%), tests_pri_-90: 61 (4.2%), check_bayes: 59
        (4.1%), b_tokenize: 8 (0.6%), b_tok_get_all: 10 (0.7%), b_comp_prob:
        2.9 (0.2%), b_tok_touch_all: 35 (2.4%), b_finish: 0.84 (0.1%),
        tests_pri_0: 1343 (92.4%), check_dkim_signature: 0.63 (0.0%),
        check_dkim_adsp: 2.4 (0.2%), poll_dns_idle: 0.45 (0.0%), tests_pri_10:
        2.3 (0.2%), tests_pri_500: 11 (0.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> writes:

> On 12/24/21 19:52, Eric W. Biederman wrote:
>> Pavel Begunkov <asml.silence@gmail.com> writes:
> [...]
>>> FWIW, I worked it around in io_uring back then by breaking the
>>> dependency.
>> I am in the middle of untangling the dependencies between ptrace,
>> coredump, signal handling and maybe a few related things.
>
> Sounds great
>
>> Do folks have a reproducer I can look at?  Pavel especially if you have
>> something that reproduces on the current kernels.
>
> A syz reproducer was triggering it reliably, I'd try to revert the
> commit below and test:
> https://syzkaller.appspot.com/text?tag=ReproC&x=15d3600cb00000
>
> It should hung a task. Syzbot report for reference:
> https://syzkaller.appspot.com/bug?extid=27d62ee6f256b186883e
>
>
> commit 1d5f5ea7cb7d15b9fb1cc82673ebb054f02cd7d2
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Fri Oct 29 13:11:33 2021 +0100
>
>     io-wq: remove worker to owner tw dependency
>
>     INFO: task iou-wrk-6609:6612 blocked for more than 143 seconds.
>           Not tainted 5.15.0-rc5-syzkaller #0
>     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>     task:iou-wrk-6609    state:D stack:27944 pid: 6612 ppid:  6526 flags:0x00004006
>     Call Trace:
>      context_switch kernel/sched/core.c:4940 [inline]
>      __schedule+0xb44/0x5960 kernel/sched/core.c:6287
>      schedule+0xd3/0x270 kernel/sched/core.c:6366
>      schedule_timeout+0x1db/0x2a0 kernel/time/timer.c:1857
>      do_wait_for_common kernel/sched/completion.c:85 [inline]
>      __wait_for_common kernel/sched/completion.c:106 [inline]
>      wait_for_common kernel/sched/completion.c:117 [inline]
>      wait_for_completion+0x176/0x280 kernel/sched/completion.c:138
>      io_worker_exit fs/io-wq.c:183 [inline]
>      io_wqe_worker+0x66d/0xc40 fs/io-wq.c:597
>      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295
>      ...

Thank you very much for this.  There were some bugs elsewhere I had to
deal with so I am slower looking at this part of the code than I was
expecting.

I have now reproduced this with the commit reverted on current kernels
and the repro.c from the syzcaller report.  I am starting to look into
how this interacts with my planned code changes in this area.

In combination with my other planned changes I think all that needs to
happen in do_coredump is to clear TIF_NOTIFY_SIGNAL along with
TIF_SIGPENDING to prevent io_uring interaction problems.  But we will
see.

The deadlock you demonstrate here shows that it is definitely not enough
to clear TIF_NOTIFY_SIGNAL (without other changes) so that
signal_pending returns false, which I was hoping was be the case.

Eric
