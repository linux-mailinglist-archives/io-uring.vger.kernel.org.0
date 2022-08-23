Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E862959EC59
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 21:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbiHWTcN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 15:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiHWTby (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 15:31:54 -0400
Received: from out01.mta.xmission.com (out01.mta.xmission.com [166.70.13.231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817F9BF68;
        Tue, 23 Aug 2022 11:23:23 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:60738)
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oQYYb-0041Dr-Vo; Tue, 23 Aug 2022 12:23:22 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:37014 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oQYYa-00GUYx-1U; Tue, 23 Aug 2022 12:23:21 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Olivier Langlois <olivier@trillion01.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
        <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
        <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
        <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
        <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
        <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
        <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
        <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
        <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
        <87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>
        <61abfb5a517e0ee253b0dc7ba9cd32ebd558bcb0.camel@trillion01.com>
        <bb423622f97826f483100a1a7f20ce10a9090158.camel@trillion01.com>
Date:   Tue, 23 Aug 2022 13:22:53 -0500
In-Reply-To: <bb423622f97826f483100a1a7f20ce10a9090158.camel@trillion01.com>
        (Olivier Langlois's message of "Mon, 22 Aug 2022 23:35:37 -0400")
Message-ID: <875yiisttu.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oQYYa-00GUYx-1U;;;mid=<875yiisttu.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/GeEI4Y8IQexfRUNq3YWki9SJ3OxiLRg4=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Olivier Langlois <olivier@trillion01.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1387 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 11 (0.8%), b_tie_ro: 10 (0.7%), parse: 0.86
        (0.1%), extract_message_metadata: 11 (0.8%), get_uri_detail_list: 1.19
        (0.1%), tests_pri_-1000: 9 (0.6%), tests_pri_-950: 1.18 (0.1%),
        tests_pri_-900: 0.96 (0.1%), tests_pri_-90: 72 (5.2%), check_bayes: 70
        (5.1%), b_tokenize: 6 (0.4%), b_tok_get_all: 6 (0.4%), b_comp_prob:
        2.0 (0.1%), b_tok_touch_all: 53 (3.8%), b_finish: 0.79 (0.1%),
        tests_pri_0: 1254 (90.4%), check_dkim_signature: 0.50 (0.0%),
        check_dkim_adsp: 2.7 (0.2%), poll_dns_idle: 0.42 (0.0%), tests_pri_10:
        2.3 (0.2%), tests_pri_500: 21 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] coredump: Allow coredumps to pipes to work with
 io_uring
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Olivier Langlois <olivier@trillion01.com> writes:

> On Mon, 2022-08-22 at 17:16 -0400, Olivier Langlois wrote:
>> 
>> What is stopping the task calling do_coredump() to be interrupted and
>> call task_work_add() from the interrupt context?
>> 
>> This is precisely what I was experiencing last summer when I did work
>> on this issue.
>> 
>> My understanding of how async I/O works with io_uring is that the
>> task
>> is added to a wait queue without being put to sleep and when the
>> io_uring callback is called from the interrupt context,
>> task_work_add()
>> is called so that the next time io_uring syscall is invoked, pending
>> work is processed to complete the I/O.
>> 
>> So if:
>> 
>> 1. io_uring request is initiated AND the task is in a wait queue
>> 2. do_coredump() is called before the I/O is completed
>> 
>> IMHO, this is how you end up having task_work_add() called while the
>> coredump is generated.
>> 
> I forgot to add that I have experienced the issue with TCP/IP I/O.
>
> I suspect that with a TCP socket, the race condition window is much
> larger than if it was disk I/O and this might make it easier to
> reproduce the issue this way...

I was under the apparently mistaken impression that the io_uring
task_work_add only comes from the io_uring userspace helper threads.
Those are definitely suppressed by my change.

Do you have any idea in the code where io_uring code is being called in
an interrupt context?  I would really like to trace that code path so I
have a better grasp on what is happening.

If task_work_add is being called from interrupt context then something
additional from what I have proposed certainly needs to be done.

Eric
