Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8C0A3257D6
	for <lists+io-uring@lfdr.de>; Thu, 25 Feb 2021 21:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbhBYUjA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Feb 2021 15:39:00 -0500
Received: from raptor.unsafe.ru ([5.9.43.93]:47106 "EHLO raptor.unsafe.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234690AbhBYUiC (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 25 Feb 2021 15:38:02 -0500
Received: from example.org (ip-94-113-225-162.net.upcbroadband.cz [94.113.225.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by raptor.unsafe.ru (Postfix) with ESMTPSA id 54A7A209D4;
        Thu, 25 Feb 2021 20:37:07 +0000 (UTC)
Date:   Thu, 25 Feb 2021 21:36:57 +0100
From:   Alexey Gladkov <gladkov.alexey@gmail.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
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
Subject: Re: d28296d248:  stress-ng.sigsegv.ops_per_sec -82.7% regression
Message-ID: <20210225203657.mjhaqnj5vszna5xw@example.org>
References: <20210224051845.GB6114@xsang-OptiPlex-9020>
 <m1czwpl83q.fsf@fess.ebiederm.org>
 <20210224183828.j6uut6sholeo2fzh@example.org>
 <m17dmxl2qa.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17dmxl2qa.fsf@fess.ebiederm.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Thu, 25 Feb 2021 20:37:16 +0000 (UTC)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Feb 24, 2021 at 12:50:21PM -0600, Eric W. Biederman wrote:
> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
> 
> > On Wed, Feb 24, 2021 at 10:54:17AM -0600, Eric W. Biederman wrote:
> >> kernel test robot <oliver.sang@intel.com> writes:
> >> 
> >> > Greeting,
> >> >
> >> > FYI, we noticed a -82.7% regression of stress-ng.sigsegv.ops_per_sec due to commit:
> >> >
> >> >
> >> > commit: d28296d2484fa11e94dff65e93eb25802a443d47 ("[PATCH v7 5/7] Reimplement RLIMIT_SIGPENDING on top of ucounts")
> >> > url: https://github.com/0day-ci/linux/commits/Alexey-Gladkov/Count-rlimits-in-each-user-namespace/20210222-175836
> >> > base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next
> >> >
> >> > in testcase: stress-ng
> >> > on test machine: 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory
> >> > with following parameters:
> >> >
> >> > 	nr_threads: 100%
> >> > 	disk: 1HDD
> >> > 	testtime: 60s
> >> > 	class: interrupt
> >> > 	test: sigsegv
> >> > 	cpufreq_governor: performance
> >> > 	ucode: 0x42e
> >> >
> >> >
> >> > In addition to that, the commit also has significant impact on the
> >> > following tests:
> >> 
> >> Thank you.  Now we have a sense of where we need to test the performance
> >> of these changes carefully.
> >
> > One of the reasons for this is that I rolled back the patch that changed
> > the ucounts.count type to atomic_t. Now get_ucounts() is forced to use a
> > spin_lock to increase the reference count.
> 
> Which given the hickups with getting a working version seems justified.
> 
> Now we can add incremental patches on top to improve the performance.

I'm not sure that get_ucounts() should be used in __sigqueue_alloc() [1].
I tried removing it and running KASAN tests that were failing before. So
far, I have not found any problems.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/legion/linux.git/tree/kernel/signal.c?h=patchset/per-userspace-rlimit/v7.1&id=2d4a2e2be7db42c95acb98abfc2a9b370ddd0604#n428

-- 
Rgrds, legion

