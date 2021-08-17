Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9C13EF564
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 00:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235360AbhHQWGV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Aug 2021 18:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234106AbhHQWGV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Aug 2021 18:06:21 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92747C0613C1
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 15:05:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 7so122633pfl.10
        for <io-uring@vger.kernel.org>; Tue, 17 Aug 2021 15:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jjzVwaNL+v4kngg4YNK2zb91Ab2Svz6N2NTcUnOnK9A=;
        b=SGcDFtlgtFCnLVqYQr5ehe+6RIHMf5bXnfOXaHxu5WzGCtMnmcc3mD+WNqH2JWSNPW
         jq/5pRGPdYBX4GoNYQ4Nx8OGvzhknjU9kvfdRtWYTD7SvgjKSBNza3fmzSjKv5IQ/0G1
         Oy4LQPbABIYHd2rWHzEHBivPtiJt/Ik/iC3NMCnRGtilQz8YKKbhWI9TRPA1ahhoRN3v
         mnJZUtEyZO6siRFF6ky3n1/hbcpkw5iJVptrKk4CV0Xp5oxGu0jEEAYZg57nD/R5I67l
         RjZA4kLvISweqdPeBpH57kTCjHFQnhm2JoyQ804kUitUmChAn9lzUkwvbmYqnsY/aqse
         U5VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jjzVwaNL+v4kngg4YNK2zb91Ab2Svz6N2NTcUnOnK9A=;
        b=q5zdG22FAO1iCg3Vw8AMcCE92IxOMyXmSFtbfT0S3b2I6I2Iv8zWkl76vj9kjBob1Y
         Yb+Xyt9p6HimSY+obRnD4gkarNZtB+nsHw7XYcxD6YsD+hZa4NKHEu8/y3JNGG6P+FxV
         U44J7vQ+iC7zGA5632upu/KY1q7npIEb40ACSNEpvgDijqxAAOHrtHkrVzKxL4wOc/uf
         WAxNpjOxLV64FNaIPsvT+2KqymNGqmJvHgZ8jJ2wtMfVa5g3ap+XadZdAWkqvwbKLzmH
         rxXWJMcVY5WRMOwEUPjps3NeHPY9apjWKfnWinKmt0NekZQ6ZwGKdBWuuzsiu1B1jWUf
         D5aA==
X-Gm-Message-State: AOAM531rdr++irz26Vv2Eata5WIlSzeMjZM6bbsSrMcFrLOLv7MopHxf
        Pw0NpA5vLH3aaeLSNgrSb6SVUQ==
X-Google-Smtp-Source: ABdhPJynIhDp6CbwLDea4vkQBRzwSgYZsxVIpXM5FoQZ1pKUnfTD4bCHUiJk8yT5GUxuc6WAOM9UiQ==
X-Received: by 2002:a63:a4c:: with SMTP id z12mr5525190pgk.185.1629237946938;
        Tue, 17 Aug 2021 15:05:46 -0700 (PDT)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id j6sm3368881pfn.107.2021.08.17.15.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 15:05:46 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
To:     Tony Battersby <tonyb@cybernetics.com>,
        Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
 <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
 <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
 <87y2bh4jg5.fsf@disp2133>
 <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
 <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
 <87pmwmn5m0.fsf@disp2133>
 <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
 <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
 <9d194813-ecb1-2fe4-70aa-75faf4e144ad@kernel.dk>
 <b36eb4a26b6aff564c6ef850a3508c5b40141d46.camel@trillion01.com>
 <0bc38b13-5a7e-8620-6dce-18731f15467e@kernel.dk>
 <24c795c6-4ec4-518e-bf9b-860207eee8c7@kernel.dk>
 <05c0cadc-029e-78af-795d-e09cf3e80087@cybernetics.com>
 <b5ab8ca0-cef5-c9b7-e47f-21c0d395f82e@kernel.dk>
 <84640f18-79ee-d8e4-5204-41a2c2330ed8@kernel.dk>
 <3168284a-0b52-7845-07b1-a72bdfed915c@cybernetics.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a56b633c-b88b-dfe8-11da-fcb3853a2edf@kernel.dk>
Date:   Tue, 17 Aug 2021 16:05:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3168284a-0b52-7845-07b1-a72bdfed915c@cybernetics.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/17/21 3:39 PM, Tony Battersby wrote:
> On 8/17/21 5:28 PM, Jens Axboe wrote:
>>
>> Another approach - don't allow TWA_SIGNAL task_work to get queued if
>> PF_SIGNALED has been set on the task. This is similar to how we reject
>> task_work_add() on process exit, and the callers must be able to handle
>> that already.
>>
>> Can you test this one on top of your 5.10-stable?
>>
>>
>> diff --git a/fs/coredump.c b/fs/coredump.c
>> index 07afb5ddb1c4..ca7c1ee44ada 100644
>> --- a/fs/coredump.c
>> +++ b/fs/coredump.c
>> @@ -602,6 +602,14 @@ void do_coredump(const kernel_siginfo_t *siginfo)
>>  		.mm_flags = mm->flags,
>>  	};
>>  
>> +	/*
>> +	 * task_work_add() will refuse to add work after PF_SIGNALED has
>> +	 * been set, ensure that we flush any pending TIF_NOTIFY_SIGNAL work
>> +	 * if any was queued before that.
>> +	 */
>> +	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
>> +		tracehook_notify_signal();
>> +
>>  	audit_core_dumps(siginfo->si_signo);
>>  
>>  	binfmt = mm->binfmt;
>> diff --git a/kernel/task_work.c b/kernel/task_work.c
>> index 1698fbe6f0e1..1ab28904adc4 100644
>> --- a/kernel/task_work.c
>> +++ b/kernel/task_work.c
>> @@ -41,6 +41,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
>>  		head = READ_ONCE(task->task_works);
>>  		if (unlikely(head == &work_exited))
>>  			return -ESRCH;
>> +		/*
>> +		 * TIF_NOTIFY_SIGNAL notifications will interfere with
>> +		 * a core dump in progress, reject them.
>> +		 */
>> +		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
>> +			return -ESRCH;
>>  		work->next = head;
>>  	} while (cmpxchg(&task->task_works, head, work) != head);
>>  
>>
> Doesn't compile.  5.10 doesn't have TIF_NOTIFY_SIGNAL.

Oh right... Here's one hacked up for the 5.10 TWA_SIGNAL setup. Totally
untested...

diff --git a/fs/coredump.c b/fs/coredump.c
index c6acfc694f65..9e899ce67589 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -603,6 +603,19 @@ void do_coredump(const kernel_siginfo_t *siginfo)
 		.mm_flags = mm->flags,
 	};
 
+	/*
+	 * task_work_add() will refuse to add work after PF_SIGNALED has
+	 * been set, ensure that we flush any pending TWA_SIGNAL work
+	 * if any was queued before that.
+	 */
+	if (signal_pending(current) && (current->jobctl & JOBCTL_TASK_WORK)) {
+		task_work_run();
+		spin_lock_irq(&current->sighand->siglock);
+		current->jobctl &= ~JOBCTL_TASK_WORK;
+		recalc_sigpending();
+		spin_unlock_irq(&current->sighand->siglock);
+	}
+
 	audit_core_dumps(siginfo->si_signo);
 
 	binfmt = mm->binfmt;
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 8d6e1217c451..93b3f262eb4a 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -39,6 +39,12 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		head = READ_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
 			return -ESRCH;
+		/*
+		 * TWA_SIGNAL notifications will interfere with
+		 * a core dump in progress, reject them.
+		 */
+		if ((task->flags & PF_SIGNALED) && notify == TWA_SIGNAL)
+			return -ESRCH;
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
 

-- 
Jens Axboe

