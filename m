Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCB632F1F8
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 18:57:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCER44 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 12:56:56 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:50894 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhCER4t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 12:56:49 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lIEgu-004e9i-VG; Fri, 05 Mar 2021 10:56:45 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lIEgt-004li8-IX; Fri, 05 Mar 2021 10:56:44 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Alexey Gladkov <gladkov.alexey@gmail.com>
Cc:     kernel test robot <oliver.sang@intel.com>,
        0day robot <lkp@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@lists.01.org,
        ying.huang@intel.com, feng.tang@intel.com, zhengjun.xing@intel.com,
        io-uring@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
        Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
References: <20210224051845.GB6114@xsang-OptiPlex-9020>
        <m1czwpl83q.fsf@fess.ebiederm.org>
        <20210224183828.j6uut6sholeo2fzh@example.org>
        <m17dmxl2qa.fsf@fess.ebiederm.org>
        <20210225203657.mjhaqnj5vszna5xw@example.org>
Date:   Fri, 05 Mar 2021 11:56:44 -0600
In-Reply-To: <20210225203657.mjhaqnj5vszna5xw@example.org> (Alexey Gladkov's
        message of "Thu, 25 Feb 2021 21:36:57 +0100")
Message-ID: <m1czwd32n7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lIEgt-004li8-IX;;;mid=<m1czwd32n7.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+QpJmPwGjQCYsOz8d21ibu8x9BhUmL7YA=
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
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 870 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.2%), b_tie_ro: 9 (1.1%), parse: 1.35 (0.2%),
         extract_message_metadata: 20 (2.3%), get_uri_detail_list: 4.5 (0.5%),
        tests_pri_-1000: 19 (2.2%), tests_pri_-950: 1.80 (0.2%),
        tests_pri_-900: 1.52 (0.2%), tests_pri_-90: 101 (11.6%), check_bayes:
        99 (11.4%), b_tokenize: 13 (1.5%), b_tok_get_all: 9 (1.0%),
        b_comp_prob: 3.5 (0.4%), b_tok_touch_all: 70 (8.0%), b_finish: 0.88
        (0.1%), tests_pri_0: 694 (79.8%), check_dkim_signature: 0.81 (0.1%),
        check_dkim_adsp: 3.2 (0.4%), poll_dns_idle: 0.23 (0.0%), tests_pri_10:
        2.9 (0.3%), tests_pri_500: 13 (1.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: d28296d248:  stress-ng.sigsegv.ops_per_sec -82.7% regression
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Wed, Feb 24, 2021 at 12:50:21PM -0600, Eric W. Biederman wrote:
>> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>> 
>> > On Wed, Feb 24, 2021 at 10:54:17AM -0600, Eric W. Biederman wrote:
>> >> kernel test robot <oliver.sang@intel.com> writes:
>> >> 
>> >> > Greeting,
>> >> >
>> >> > FYI, we noticed a -82.7% regression of stress-ng.sigsegv.ops_per_sec due to commit:
>> >> >
>> >> >
>> >> > commit: d28296d2484fa11e94dff65e93eb25802a443d47 ("[PATCH v7 5/7] Reimplement RLIMIT_SIGPENDING on top of ucounts")
>> >> > url: https://github.com/0day-ci/linux/commits/Alexey-Gladkov/Count-rlimits-in-each-user-namespace/20210222-175836
>> >> > base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next
>> >> >
>> >> > in testcase: stress-ng
>> >> > on test machine: 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory
>> >> > with following parameters:
>> >> >
>> >> > 	nr_threads: 100%
>> >> > 	disk: 1HDD
>> >> > 	testtime: 60s
>> >> > 	class: interrupt
>> >> > 	test: sigsegv
>> >> > 	cpufreq_governor: performance
>> >> > 	ucode: 0x42e
>> >> >
>> >> >
>> >> > In addition to that, the commit also has significant impact on the
>> >> > following tests:
>> >> 
>> >> Thank you.  Now we have a sense of where we need to test the performance
>> >> of these changes carefully.
>> >
>> > One of the reasons for this is that I rolled back the patch that changed
>> > the ucounts.count type to atomic_t. Now get_ucounts() is forced to use a
>> > spin_lock to increase the reference count.
>> 
>> Which given the hickups with getting a working version seems justified.
>> 
>> Now we can add incremental patches on top to improve the performance.
>
> I'm not sure that get_ucounts() should be used in __sigqueue_alloc() [1].
> I tried removing it and running KASAN tests that were failing before. So
> far, I have not found any problems.
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/legion/linux.git/tree/kernel/signal.c?h=patchset/per-userspace-rlimit/v7.1&id=2d4a2e2be7db42c95acb98abfc2a9b370ddd0604#n428

Hmm.  The code you posted still seems to include the get_ucounts.

I like the idea of not needing to increment and decrement the ucount
reference count every time a signal is sent, unfortunately there is a
problem.  The way we have implemented setresuid allows different threads
in a threaded application to have different cred->user values.

That is actually an extension of what posix supports and pthreads will
keep the creds of a process in sync.  Still I recall looking into this a
few years ago and there were a few applications that take advantage of
the linux behavior.

In principle I think it is possible to hold a ucount reference in
somewhere such as task->signal.  In practice there are enough
complicating factors I don't immediately see how to implement that.

If the creds were stored in signal_struct instead of in task_struct
we could simply move the sigpending counts in set_user, when the uid
of a process changed.

With the current state I don't know how to pick which is the real user.

Eric
