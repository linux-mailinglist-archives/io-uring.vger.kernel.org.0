Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA3B59FDF4
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 17:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbiHXPME (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 11:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238039AbiHXPMD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 11:12:03 -0400
Received: from out03.mta.xmission.com (out03.mta.xmission.com [166.70.13.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2945392F67;
        Wed, 24 Aug 2022 08:12:03 -0700 (PDT)
Received: from in01.mta.xmission.com ([166.70.13.51]:46614)
        by out03.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oQs2y-00CHHk-TK; Wed, 24 Aug 2022 09:12:01 -0600
Received: from ip68-110-29-46.om.om.cox.net ([68.110.29.46]:36266 helo=email.froward.int.ebiederm.org.xmission.com)
        by in01.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1oQs2w-001mpu-Q3; Wed, 24 Aug 2022 09:12:00 -0600
From:   "Eric W. Biederman" <ebiederm@xmission.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Olivier Langlois <olivier@trillion01.com>,
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
        <875yiisttu.fsf@email.froward.int.ebiederm.org>
        <654cb5de-a563-b812-a435-d9b435cee334@kernel.dk>
Date:   Wed, 24 Aug 2022 10:11:23 -0500
In-Reply-To: <654cb5de-a563-b812-a435-d9b435cee334@kernel.dk> (Jens Axboe's
        message of "Tue, 23 Aug 2022 12:27:06 -0600")
Message-ID: <87lerdr810.fsf@email.froward.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1oQs2w-001mpu-Q3;;;mid=<87lerdr810.fsf@email.froward.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.110.29.46;;;frm=ebiederm@xmission.com;;;spf=softfail
X-XM-AID: U2FsdGVkX1/zIi/Z3JzOwDc+HihlayO1DxAMK324r+c=
X-SA-Exim-Connect-IP: 68.110.29.46
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *****;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1537 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 13 (0.9%), b_tie_ro: 12 (0.8%), parse: 1.25
        (0.1%), extract_message_metadata: 17 (1.1%), get_uri_detail_list: 2.2
        (0.1%), tests_pri_-1000: 7 (0.5%), tests_pri_-950: 1.63 (0.1%),
        tests_pri_-900: 1.59 (0.1%), tests_pri_-90: 120 (7.8%), check_bayes:
        104 (6.8%), b_tokenize: 15 (1.0%), b_tok_get_all: 10 (0.7%),
        b_comp_prob: 4.6 (0.3%), b_tok_touch_all: 70 (4.6%), b_finish: 1.09
        (0.1%), tests_pri_0: 1361 (88.5%), check_dkim_signature: 0.98 (0.1%),
        check_dkim_adsp: 4.3 (0.3%), poll_dns_idle: 0.50 (0.0%), tests_pri_10:
        2.2 (0.1%), tests_pri_500: 8 (0.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 2/2] coredump: Allow coredumps to pipes to work with
 io_uring
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 8/23/22 12:22 PM, Eric W. Biederman wrote:
>> Olivier Langlois <olivier@trillion01.com> writes:
>> 
>>> On Mon, 2022-08-22 at 17:16 -0400, Olivier Langlois wrote:
>>>>
>>>> What is stopping the task calling do_coredump() to be interrupted and
>>>> call task_work_add() from the interrupt context?
>>>>
>>>> This is precisely what I was experiencing last summer when I did work
>>>> on this issue.
>>>>
>>>> My understanding of how async I/O works with io_uring is that the
>>>> task
>>>> is added to a wait queue without being put to sleep and when the
>>>> io_uring callback is called from the interrupt context,
>>>> task_work_add()
>>>> is called so that the next time io_uring syscall is invoked, pending
>>>> work is processed to complete the I/O.
>>>>
>>>> So if:
>>>>
>>>> 1. io_uring request is initiated AND the task is in a wait queue
>>>> 2. do_coredump() is called before the I/O is completed
>>>>
>>>> IMHO, this is how you end up having task_work_add() called while the
>>>> coredump is generated.
>>>>
>>> I forgot to add that I have experienced the issue with TCP/IP I/O.
>>>
>>> I suspect that with a TCP socket, the race condition window is much
>>> larger than if it was disk I/O and this might make it easier to
>>> reproduce the issue this way...
>> 
>> I was under the apparently mistaken impression that the io_uring
>> task_work_add only comes from the io_uring userspace helper threads.
>> Those are definitely suppressed by my change.
>> 
>> Do you have any idea in the code where io_uring code is being called in
>> an interrupt context?  I would really like to trace that code path so I
>> have a better grasp on what is happening.
>> 
>> If task_work_add is being called from interrupt context then something
>> additional from what I have proposed certainly needs to be done.
>
> task_work may come from the helper threads, but generally it does not.
> One example would be doing a read from a socket. There's no data there,
> poll is armed to trigger a retry. When we get the poll notification that
> there's now data to be read, then we kick that off with task_work. Since
> it's from the poll handler, it can trigger from interrupt context. See
> the path from io_uring/poll.c:io_poll_wake() -> __io_poll_execute() ->
> io_req_task_work_add() -> task_work_add().

But that is a task_work to the helper thread correct?

> It can also happen for regular IRQ based reads from regular files, where
> the completion is actually done via task_work added from the potentially
> IRQ based completion path.

I can see that.

Which leaves me with the question do these task_work's directly wake up
the thread that submitted the I/O request?   Or is there likely to be
something for an I/O thread to do before an ordinary program thread is
notified.

I am asking because it is only the case of notifying ordinary program
threads that is interesting in the case of a coredump.  As I understand
it a data to read notification would typically be handled by the I/O
uring worker thread to trigger reading the data before letting userspace
know everything it asked to be done is complete.

Eric
