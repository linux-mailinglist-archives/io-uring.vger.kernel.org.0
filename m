Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B9632014E
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 23:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbhBSWWt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 17:22:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:51432 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhBSWWs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 17:22:48 -0500
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lDEA2-0059tB-3C; Fri, 19 Feb 2021 15:22:06 -0700
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=fess.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lDEA0-00C4tq-Az; Fri, 19 Feb 2021 15:22:05 -0700
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org,
        Christian Brauner <christian.brauner@ubuntu.com>
References: <20210219171010.281878-1-axboe@kernel.dk>
        <20210219171010.281878-8-axboe@kernel.dk>
Date:   Fri, 19 Feb 2021 16:21:48 -0600
In-Reply-To: <20210219171010.281878-8-axboe@kernel.dk> (Jens Axboe's message
        of "Fri, 19 Feb 2021 10:09:59 -0700")
Message-ID: <m14ki7og03.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lDEA0-00C4tq-Az;;;mid=<m14ki7og03.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+dDGo1xznR1fA2AzBrDHdDU9iDTrSforE=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: ***
X-Spam-Status: No, score=3.4 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        XMNoVowels,XMSubLong,XM_B_SpammyWords autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ***;Jens Axboe <axboe@kernel.dk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1112 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (1.0%), b_tie_ro: 9 (0.8%), parse: 1.32 (0.1%),
         extract_message_metadata: 21 (1.9%), get_uri_detail_list: 8 (0.7%),
        tests_pri_-1000: 6 (0.5%), tests_pri_-950: 1.23 (0.1%),
        tests_pri_-900: 1.00 (0.1%), tests_pri_-90: 120 (10.8%), check_bayes:
        118 (10.6%), b_tokenize: 28 (2.5%), b_tok_get_all: 12 (1.1%),
        b_comp_prob: 2.8 (0.3%), b_tok_touch_all: 72 (6.5%), b_finish: 0.75
        (0.1%), tests_pri_0: 930 (83.6%), check_dkim_signature: 0.88 (0.1%),
        check_dkim_adsp: 3.0 (0.3%), poll_dns_idle: 0.55 (0.0%), tests_pri_10:
        2.5 (0.2%), tests_pri_500: 14 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 07/18] arch: setup PF_IO_WORKER threads like PF_KTHREAD
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> PF_IO_WORKER are kernel threads too, but they aren't PF_KTHREAD in the
> sense that we don't assign ->set_child_tid with our own structure. Just
> ensure that every arch sets up the PF_IO_WORKER threads like kthreads.

I think it is worth calling out that this is only for the arch
implementation of copy_thread.

This looks good for now.  But I am wondering if eventually we want to
refactor the copy_thread interface to more cleanly handle the
difference between tasks that only run in the kernel and userspace
tasks.

Eric

> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  arch/alpha/kernel/process.c      | 2 +-
>  arch/arc/kernel/process.c        | 2 +-
>  arch/arm/kernel/process.c        | 2 +-
>  arch/arm64/kernel/process.c      | 2 +-
>  arch/c6x/kernel/process.c        | 2 +-
>  arch/csky/kernel/process.c       | 2 +-
>  arch/h8300/kernel/process.c      | 2 +-
>  arch/hexagon/kernel/process.c    | 2 +-
>  arch/ia64/kernel/process.c       | 2 +-
>  arch/m68k/kernel/process.c       | 2 +-
>  arch/microblaze/kernel/process.c | 2 +-
>  arch/mips/kernel/process.c       | 2 +-
>  arch/nds32/kernel/process.c      | 2 +-
>  arch/nios2/kernel/process.c      | 2 +-
>  arch/openrisc/kernel/process.c   | 2 +-
>  arch/riscv/kernel/process.c      | 2 +-
>  arch/s390/kernel/process.c       | 2 +-
>  arch/sh/kernel/process_32.c      | 2 +-
>  arch/sparc/kernel/process_32.c   | 2 +-
>  arch/sparc/kernel/process_64.c   | 2 +-
>  arch/um/kernel/process.c         | 2 +-
>  arch/x86/kernel/process.c        | 2 +-
>  arch/xtensa/kernel/process.c     | 2 +-
>  23 files changed, 23 insertions(+), 23 deletions(-)
>
> diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
> index 6c71554206cc..5112ab996394 100644
> --- a/arch/alpha/kernel/process.c
> +++ b/arch/alpha/kernel/process.c
> @@ -249,7 +249,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
>  	childti->pcb.ksp = (unsigned long) childstack;
>  	childti->pcb.flags = 1;	/* set FEN, clear everything else */
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* kernel thread */
>  		memset(childstack, 0,
>  			sizeof(struct switch_stack) + sizeof(struct pt_regs));
> diff --git a/arch/arc/kernel/process.c b/arch/arc/kernel/process.c
> index 37f724ad5e39..d838d0d57696 100644
> --- a/arch/arc/kernel/process.c
> +++ b/arch/arc/kernel/process.c
> @@ -191,7 +191,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
>  	childksp[0] = 0;			/* fp */
>  	childksp[1] = (unsigned long)ret_from_fork; /* blink */
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(c_regs, 0, sizeof(struct pt_regs));
>  
>  		c_callee->r13 = kthread_arg;
> diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
> index ee3aee69e444..5199a2bb4111 100644
> --- a/arch/arm/kernel/process.c
> +++ b/arch/arm/kernel/process.c
> @@ -243,7 +243,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  	thread->cpu_domain = get_domain();
>  #endif
>  
> -	if (likely(!(p->flags & PF_KTHREAD))) {
> +	if (likely(!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))) {
>  		*childregs = *current_pt_regs();
>  		childregs->ARM_r0 = 0;
>  		if (stack_start)
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 6616486a58fe..05f001b401a5 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -398,7 +398,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  
>  	ptrauth_thread_init_kernel(p);
>  
> -	if (likely(!(p->flags & PF_KTHREAD))) {
> +	if (likely(!(p->flags & (PF_KTHREAD | PF_IO_WORKER)))) {
>  		*childregs = *current_pt_regs();
>  		childregs->regs[0] = 0;
>  
> diff --git a/arch/c6x/kernel/process.c b/arch/c6x/kernel/process.c
> index 9f4fd6a40a10..403ad4ce3db0 100644
> --- a/arch/c6x/kernel/process.c
> +++ b/arch/c6x/kernel/process.c
> @@ -112,7 +112,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
>  
>  	childregs = task_pt_regs(p);
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* case of  __kernel_thread: we return to supervisor space */
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		childregs->sp = (unsigned long)(childregs + 1);
> diff --git a/arch/csky/kernel/process.c b/arch/csky/kernel/process.c
> index 69af6bc87e64..3d0ca22cd0e2 100644
> --- a/arch/csky/kernel/process.c
> +++ b/arch/csky/kernel/process.c
> @@ -49,7 +49,7 @@ int copy_thread(unsigned long clone_flags,
>  	/* setup thread.sp for switch_to !!! */
>  	p->thread.sp = (unsigned long)childstack;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		childstack->r15 = (unsigned long) ret_from_kernel_thread;
>  		childstack->r10 = kthread_arg;
> diff --git a/arch/h8300/kernel/process.c b/arch/h8300/kernel/process.c
> index bc1364db58fe..46b1342ce515 100644
> --- a/arch/h8300/kernel/process.c
> +++ b/arch/h8300/kernel/process.c
> @@ -112,7 +112,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
>  
>  	childregs = (struct pt_regs *) (THREAD_SIZE + task_stack_page(p)) - 1;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		childregs->retpc = (unsigned long) ret_from_kernel_thread;
>  		childregs->er4 = topstk; /* arg */
> diff --git a/arch/hexagon/kernel/process.c b/arch/hexagon/kernel/process.c
> index 6a980cba7b29..c61165c99ae0 100644
> --- a/arch/hexagon/kernel/process.c
> +++ b/arch/hexagon/kernel/process.c
> @@ -73,7 +73,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  						    sizeof(*ss));
>  	ss->lr = (unsigned long)ret_from_fork;
>  	p->thread.switch_sp = ss;
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		/* r24 <- fn, r25 <- arg */
>  		ss->r24 = usp;
> diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
> index 4ebbfa076a26..7e1a1525e202 100644
> --- a/arch/ia64/kernel/process.c
> +++ b/arch/ia64/kernel/process.c
> @@ -338,7 +338,7 @@ copy_thread(unsigned long clone_flags, unsigned long user_stack_base,
>  
>  	ia64_drop_fpu(p);	/* don't pick up stale state from a CPU's fph */
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		if (unlikely(!user_stack_base)) {
>  			/* fork_idle() called us */
>  			return 0;
> diff --git a/arch/m68k/kernel/process.c b/arch/m68k/kernel/process.c
> index 08359a6e058f..da83cc83e791 100644
> --- a/arch/m68k/kernel/process.c
> +++ b/arch/m68k/kernel/process.c
> @@ -157,7 +157,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  	 */
>  	p->thread.fs = get_fs().seg;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* kernel thread */
>  		memset(frame, 0, sizeof(struct fork_frame));
>  		frame->regs.sr = PS_S;
> diff --git a/arch/microblaze/kernel/process.c b/arch/microblaze/kernel/process.c
> index 657c2beb665e..62aa237180b6 100644
> --- a/arch/microblaze/kernel/process.c
> +++ b/arch/microblaze/kernel/process.c
> @@ -59,7 +59,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  	struct pt_regs *childregs = task_pt_regs(p);
>  	struct thread_info *ti = task_thread_info(p);
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* if we're creating a new kernel thread then just zeroing all
>  		 * the registers. That's OK for a brand new thread.*/
>  		memset(childregs, 0, sizeof(struct pt_regs));
> diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
> index d7e288f3a1e7..f69434015be7 100644
> --- a/arch/mips/kernel/process.c
> +++ b/arch/mips/kernel/process.c
> @@ -135,7 +135,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
>  	/*  Put the stack after the struct pt_regs.  */
>  	childksp = (unsigned long) childregs;
>  	p->thread.cp0_status = (read_c0_status() & ~(ST0_CU2|ST0_CU1)) | ST0_KERNEL_CUMASK;
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* kernel thread */
>  		unsigned long status = p->thread.cp0_status;
>  		memset(childregs, 0, sizeof(struct pt_regs));
> diff --git a/arch/nds32/kernel/process.c b/arch/nds32/kernel/process.c
> index e01ad5d17224..c1327e552ec6 100644
> --- a/arch/nds32/kernel/process.c
> +++ b/arch/nds32/kernel/process.c
> @@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flags, unsigned long stack_start,
>  
>  	memset(&p->thread.cpu_context, 0, sizeof(struct cpu_context));
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		/* kernel thread fn */
>  		p->thread.cpu_context.r6 = stack_start;
> diff --git a/arch/nios2/kernel/process.c b/arch/nios2/kernel/process.c
> index 50b4eb19a6cc..c5f916ca6845 100644
> --- a/arch/nios2/kernel/process.c
> +++ b/arch/nios2/kernel/process.c
> @@ -109,7 +109,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  	struct switch_stack *childstack =
>  		((struct switch_stack *)childregs) - 1;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childstack, 0,
>  			sizeof(struct switch_stack) + sizeof(struct pt_regs));
>  
> diff --git a/arch/openrisc/kernel/process.c b/arch/openrisc/kernel/process.c
> index 3c98728cce24..83fba4ee4453 100644
> --- a/arch/openrisc/kernel/process.c
> +++ b/arch/openrisc/kernel/process.c
> @@ -167,7 +167,7 @@ copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  	sp -= sizeof(struct pt_regs);
>  	kregs = (struct pt_regs *)sp;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(kregs, 0, sizeof(struct pt_regs));
>  		kregs->gpr[20] = usp; /* fn, kernel thread */
>  		kregs->gpr[22] = arg;
> diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
> index dd5f985b1f40..06d326caa7d8 100644
> --- a/arch/riscv/kernel/process.c
> +++ b/arch/riscv/kernel/process.c
> @@ -112,7 +112,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  	struct pt_regs *childregs = task_pt_regs(p);
>  
>  	/* p->thread holds context to be restored by __switch_to() */
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* Kernel thread */
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		childregs->gp = gp_in_global;
> diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
> index bc3ca54edfb4..ac7a06d5e230 100644
> --- a/arch/s390/kernel/process.c
> +++ b/arch/s390/kernel/process.c
> @@ -114,7 +114,7 @@ int copy_thread(unsigned long clone_flags, unsigned long new_stackp,
>  	frame->sf.gprs[9] = (unsigned long) frame;
>  
>  	/* Store access registers to kernel stack of new process. */
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		/* kernel thread */
>  		memset(&frame->childregs, 0, sizeof(struct pt_regs));
>  		frame->childregs.psw.mask = PSW_KERNEL_BITS | PSW_MASK_DAT |
> diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
> index 80a5d1c66a51..1aa508eb0823 100644
> --- a/arch/sh/kernel/process_32.c
> +++ b/arch/sh/kernel/process_32.c
> @@ -114,7 +114,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp, unsigned long arg,
>  
>  	childregs = task_pt_regs(p);
>  	p->thread.sp = (unsigned long) childregs;
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		p->thread.pc = (unsigned long) ret_from_kernel_thread;
>  		childregs->regs[4] = arg;
> diff --git a/arch/sparc/kernel/process_32.c b/arch/sparc/kernel/process_32.c
> index a02363735915..0f9c606e1e78 100644
> --- a/arch/sparc/kernel/process_32.c
> +++ b/arch/sparc/kernel/process_32.c
> @@ -309,7 +309,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>  	ti->ksp = (unsigned long) new_stack;
>  	p->thread.kregs = childregs;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		extern int nwindows;
>  		unsigned long psr;
>  		memset(new_stack, 0, STACKFRAME_SZ + TRACEREG_SZ);
> diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
> index 6f8c7822fc06..7afd0a859a78 100644
> --- a/arch/sparc/kernel/process_64.c
> +++ b/arch/sparc/kernel/process_64.c
> @@ -597,7 +597,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>  				       sizeof(struct sparc_stackf));
>  	t->fpsaved[0] = 0;
>  
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(child_trap_frame, 0, child_stack_sz);
>  		__thread_flag_byte_ptr(t)[TI_FLAG_BYTE_CWP] = 
>  			(current_pt_regs()->tstate + 1) & TSTATE_CWP;
> diff --git a/arch/um/kernel/process.c b/arch/um/kernel/process.c
> index 81d508daf67c..c5011064b5dd 100644
> --- a/arch/um/kernel/process.c
> +++ b/arch/um/kernel/process.c
> @@ -157,7 +157,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
>  		unsigned long arg, struct task_struct * p, unsigned long tls)
>  {
>  	void (*handler)(void);
> -	int kthread = current->flags & PF_KTHREAD;
> +	int kthread = current->flags & (PF_KTHREAD | PF_IO_WORKER);
>  	int ret = 0;
>  
>  	p->thread = (struct thread_struct) INIT_THREAD;
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 145a7ac0c19a..9c214d7085a4 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -161,7 +161,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>  #endif
>  
>  	/* Kernel thread ? */
> -	if (unlikely(p->flags & PF_KTHREAD)) {
> +	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		kthread_frame_init(frame, sp, arg);
>  		return 0;
> diff --git a/arch/xtensa/kernel/process.c b/arch/xtensa/kernel/process.c
> index 397a7de56377..9534ef515d74 100644
> --- a/arch/xtensa/kernel/process.c
> +++ b/arch/xtensa/kernel/process.c
> @@ -217,7 +217,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp_thread_fn,
>  
>  	p->thread.sp = (unsigned long)childregs;
>  
> -	if (!(p->flags & PF_KTHREAD)) {
> +	if (!(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>  		struct pt_regs *regs = current_pt_regs();
>  		unsigned long usp = usp_thread_fn ?
>  			usp_thread_fn : regs->areg[1];
