Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B3324080C
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbgHJPBI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 11:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgHJPBH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 11:01:07 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D10C061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:01:04 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m8so5529602pfh.3
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 08:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GfUx51xfMGW5OOLl4q0UPbTgyJ9pLYSMdxkPGfEZlsg=;
        b=OihTmU6bdPQ4PImM9CMYaD8W2LQ7jtVAsLl1CbEK7Jgn6BrQubpuH7DJc8Wxq7YvtC
         rv3uL2qe/IfgfNRS1C/wD9YQonOIy09gwQ6gErzp45TNsmg+Vw26jAZe9B7mgLfszTuq
         UvoKb2nkkXfhS5WoraLawuQFI2YzNFfMp6n66ALDzxmDDvJiAanBtgdA+blFb1tyMv1S
         spf6EyZ4cvNdrD7qv++R1wZrOeSWsheYRlTQon9l1fTiraSGfbv2bxMxzwj2Kx8Vwn+P
         cHX83+3LvWPEHPr0seIRKOklW+Iu30mtt3eYJririNAbqeYZaD3wuqFhBQzKvZf2K1qK
         SNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GfUx51xfMGW5OOLl4q0UPbTgyJ9pLYSMdxkPGfEZlsg=;
        b=dvCTKz14NyCkyq0iRk+VHA2SJjBVJRgIQk1kySEG4erUkP3Y8XFTYgjfOiN0K8YXx3
         81MDT7XbHs5AzUjqvdlPGcQpgvjMfUr5c6dnabcaVjOwGNPP0X3KfuGW07RznGaenT/Q
         3da4Rz5NbF3Ox6HQIns5aixc776mdnV8e78Dj1hqu4U4gLufkhCyR4VZfON8SCWazIRZ
         Ss6KwtG4c4zY75VVU4R/Y8cYQ+8BrWg6Ml7a4E373lTeTg3UZktPDDP5Dy8bXiSjNJah
         gF8rRtIiMKxbsSyz+6d5uCHuYpw9BdNcEZhieGmmM0MiEOqXE85iJv/CflYJ8WlJCTX2
         skjw==
X-Gm-Message-State: AOAM533mvwhSs2xTBBapKQ5eY0mZrSeS68Fbppe6FZuzx9gD6TReXbZ1
        1t8/UZPpo4XwdEJnG+bvBpzYIQ==
X-Google-Smtp-Source: ABdhPJweVyScWcnciWzYLIaFGvA5JmXYXiLe0anwzV5DYH0YlL+2g+AH4cIiLi5phgZP7VUmIFdnGQ==
X-Received: by 2002:a05:6a00:44:: with SMTP id i4mr1457762pfk.276.1597071663852;
        Mon, 10 Aug 2020 08:01:03 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id gj2sm19566998pjb.21.2020.08.10.08.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 08:01:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] kernel: split task_work_add() into two separate
 helpers
To:     peterz@infradead.org
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-2-axboe@kernel.dk>
 <20200810113740.GR2674@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ae401501-ede0-eb08-12b7-1d50f6b3eaa5@kernel.dk>
Date:   Mon, 10 Aug 2020 09:01:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810113740.GR2674@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 5:37 AM, peterz@infradead.org wrote:
> On Sat, Aug 08, 2020 at 12:34:38PM -0600, Jens Axboe wrote:
>> Some callers may need to make signaling decisions based on the state
>> of the targeted task, and that can only safely be done post adding
>> the task_work to the task. Split task_work_add() into:
>>
>> __task_work_add()	- adds the work item
>> __task_work_notify()	- sends the notification
>>
>> No functional changes in this patch.
> 
> Might be nice to mention __task_work_add() is now inline.

OK, will mention that.

>> Cc: Peter Zijlstra <peterz@infradead.org>
>> Cc: stable@vger.kernel.org # v5.7+
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  include/linux/task_work.h | 19 ++++++++++++++++
>>  kernel/task_work.c        | 48 +++++++++++++++++++++------------------
>>  2 files changed, 45 insertions(+), 22 deletions(-)
> 
> 
> 
>> +struct callback_head work_exited = {
>> +	.next = NULL	/* all we need is ->next == NULL */
>> +};
> 
> Would it make sense to make this const ? Esp. with the thing exposed,
> sticking it in R/O memory might avoid a mistake somewhere.

That was my original intent, but that makes 'head' in task_work_run()
const as well, and cmpxchg() doesn't like that:

kernel/task_work.c: In function ‘task_work_run’:
./arch/x86/include/asm/cmpxchg.h:89:29: warning: initialization discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
   89 |  __typeof__(*(ptr)) __new = (new);    \
      |                             ^
./arch/x86/include/asm/cmpxchg.h:134:2: note: in expansion of macro ‘__raw_cmpxchg’
  134 |  __raw_cmpxchg((ptr), (old), (new), (size), LOCK_PREFIX)
      |  ^~~~~~~~~~~~~
./arch/x86/include/asm/cmpxchg.h:149:2: note: in expansion of macro ‘__cmpxchg’
  149 |  __cmpxchg(ptr, old, new, sizeof(*(ptr)))
      |  ^~~~~~~~~
./include/asm-generic/atomic-instrumented.h:1685:2: note: in expansion of macro ‘arch_cmpxchg’
 1685 |  arch_cmpxchg(__ai_ptr, __VA_ARGS__);    \
      |  ^~~~~~~~~~~~
kernel/task_work.c:126:12: note: in expansion of macro ‘cmpxchg’
  126 |   } while (cmpxchg(&task->task_works, work, head) != work);
      |            ^~~~~~~

which is somewhat annoying. Because there's really no good reason why it
can't be const, it'll just require the changes to dig a bit deeper.

-- 
Jens Axboe

