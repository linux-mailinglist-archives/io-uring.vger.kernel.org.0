Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA35288C50
	for <lists+io-uring@lfdr.de>; Fri,  9 Oct 2020 17:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389157AbgJIPN3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Oct 2020 11:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388579AbgJIPNZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Oct 2020 11:13:25 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60ABEC0613D5
        for <io-uring@vger.kernel.org>; Fri,  9 Oct 2020 08:13:23 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id r21so4052743pgj.5
        for <io-uring@vger.kernel.org>; Fri, 09 Oct 2020 08:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P3EEJJLJ/verJEGRdvaJ2KnxeQYT1zbm9oj10l9KKMM=;
        b=uvs+DRT+1drkaoBt+5R0BfZLL2xUY7deivzJ3UTiekTD++FvHEh3lG0o42imiO2D0R
         kiN8r7QmRtyBHnJlkPyKqIq8DW7dIweVPHkWwD/GDi7aCMZWj8CYWuTLdq2zwY2Owsfd
         65vBwYC5Jg9Uw30+T4mHrPSRUrTIDUNLzeHhTysRimNabdO7mCi924NMyYREzMQ0IAYT
         KaSvXA9Tzq/QtjUx1yRdiG8u9k80YvnDvdXdYYUQOuIccGY9yyi6BmwRHgkH9N2dLiO5
         ajh9WleY6z1ycHrh9z9lLhLhLXjIIZWAmTOLgEVBBXZrPu56Qh42K/d2EvHjP11nqGD8
         dZsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P3EEJJLJ/verJEGRdvaJ2KnxeQYT1zbm9oj10l9KKMM=;
        b=Yvws+T28zs8+EaRFKV8Mk78igxDEjWLXzLBb6Y2xGk5+1ZFOT6HpTbIzwZU7jgKxCz
         6o/BP8haAGbrnSsaxaOvrJ2p7yH0gP85Hp42N9yhTUvSw1ITcfFCs2yxYEBVQy+KiG1s
         U0/PVx9Jal2+iI7qS2B2AvgnbBSsRb5k52ss/KbU02sJiyqB7LYR+/wnsyzjJ0sg2zRo
         7rSOPLb5bJQK+aljO0kcDNOBi0+iVLkpFhOEAZZilI3bSicyGfyc9KK9O2eTR8R6x8ss
         gszr2hSlu0gl8zbfUdYJilrfvjN7iqNemytxe2NpHgVZE8IDWCUefOi+CHFyjT98ziBA
         jckQ==
X-Gm-Message-State: AOAM532ijC5zt9X2ap35RCw2aZkOPqrn6Pbx8tbPOQzpmU3GFlnrLHGb
        W8KwIjJJaiAXJJzvszFKj/DFSQ==
X-Google-Smtp-Source: ABdhPJyiqCw2IEyao5rpIRwyNSsnH9JhOjkb4jV2Sg0HTZ8/sfmCdF7MizowbS9JjovHaMrhfZsajg==
X-Received: by 2002:a17:90b:312:: with SMTP id ay18mr5045299pjb.17.1602256402618;
        Fri, 09 Oct 2020 08:13:22 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id na9sm3736613pjb.45.2020.10.09.08.13.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 08:13:21 -0700 (PDT)
Subject: Re: [PATCH 3/4] kernel: add support for TIF_NOTIFY_SIGNAL
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
References: <20201008152752.218889-1-axboe@kernel.dk>
 <20201008152752.218889-4-axboe@kernel.dk> <20201009144328.GB14523@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e8319a4c-334a-e888-7d31-f43b4ae6822a@kernel.dk>
Date:   Fri, 9 Oct 2020 09:13:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201009144328.GB14523@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/9/20 8:43 AM, Oleg Nesterov wrote:
> Once again, I am fine with this patch, just a minor comment...
> 
> On 10/08, Jens Axboe wrote:
>>
>> --- a/arch/x86/kernel/signal.c
>> +++ b/arch/x86/kernel/signal.c
>> @@ -808,7 +808,10 @@ void arch_do_signal(struct pt_regs *regs)
>>  {
>>  	struct ksignal ksig;
>>
>> -	if (get_signal(&ksig)) {
>> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>> +		tracehook_notify_signal();
>> +
>> +	if (task_sigpending(current) && get_signal(&ksig)) {
> 
> I suggested to change arch_do_signal() because somehow I like it this way ;)
> 
> And because we can easily pass the "ti_work" mask to arch_do_signal() and
> avoid test_thread_flag/task_sigpending.
> 
> Hmm. I just noticed that only x86 uses arch_do_signal(), so perhaps you can
> add this change to this patch right now? Up to you.

Sure, we can do that. Incremental on top then looks like the below. I don't
feel that strongly about it, but it is nice to avoid re-testing the flags.


diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index cd140bbf8520..ec6490e53dc3 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -804,14 +804,14 @@ static inline unsigned long get_nr_restart_syscall(const struct pt_regs *regs)
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-void arch_do_signal(struct pt_regs *regs)
+void arch_do_signal(struct pt_regs *regs, unsigned long ti_work)
 {
 	struct ksignal ksig;
 
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+	if (ti_work & _TIF_NOTIFY_SIGNAL)
 		tracehook_notify_signal();
 
-	if (task_sigpending(current) && get_signal(&ksig)) {
+	if ((ti_work & _TIF_SIGPENDING) && get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(&ksig, regs);
 		return;
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index f4234aaac36c..0360b7e4e39a 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -265,10 +265,11 @@ static __always_inline void arch_exit_to_user_mode(void) { }
 /**
  * arch_do_signal -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
+ * @ti_work	task thread info work flags
  *
  * Invoked from exit_to_user_mode_loop().
  */
-void arch_do_signal(struct pt_regs *regs);
+void arch_do_signal(struct pt_regs *regs, unsigned long ti_work);
 
 /**
  * arch_syscall_exit_tracehook - Wrapper around tracehook_report_syscall_exit()
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 89a068252897..bd3cf6279e94 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -135,7 +135,7 @@ static __always_inline void exit_to_user_mode(void)
 }
 
 /* Workaround to allow gradual conversion of architecture code */
-void __weak arch_do_signal(struct pt_regs *regs) { }
+void __weak arch_do_signal(struct pt_regs *regs, unsigned long ti_work) { }
 
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
@@ -158,7 +158,7 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 			klp_update_patch_state(current);
 
 		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
-			arch_do_signal(regs);
+			arch_do_signal(regs, ti_work);
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
 			tracehook_notify_resume(regs);

-- 
Jens Axboe

