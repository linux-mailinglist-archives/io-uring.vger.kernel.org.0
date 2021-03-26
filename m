Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD6334AA95
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 15:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCZOzs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Mar 2021 10:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhCZOzp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Mar 2021 10:55:45 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B42DC0613AA
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:55:45 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id w2so4786345ilj.12
        for <io-uring@vger.kernel.org>; Fri, 26 Mar 2021 07:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ShOD9ANK+k5zonsBbQI1RoVppoAyPVg9mfaoGxQR9eU=;
        b=GO1oyAFDNMwSU4xCrtFjN3Y2rI1BLjkYdaQo4XiiNvhy03JIhN2vsLZv32tA9ZPHrC
         G0Ku6NBbJq0UA1twegAxAomeJmaPu7GUzxuTv53PhIQAU2poxrTa0k8PnHtdmZpItGrf
         ybUDroiYIZlGg8uLtQ96Jn3DJHybJZIECUxFVronQAs1mnDX8WnGv/h82GXybUXtR+WB
         kcKC+hG3G7IpOJ+I9gLqN9XRaWNI+D7LQlcEgtZ0qPAH5O5vjfZhgQIqf6XyxFHvJcha
         mfcxXMUi+MIawEuBSbI5olQ/Q6oVK1/XJYJ2/t+pgd4K16ze5rFE/V4ZmNlM6xf/7kAx
         9GmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ShOD9ANK+k5zonsBbQI1RoVppoAyPVg9mfaoGxQR9eU=;
        b=ueXETktBlazBYs39g+vdjIxIgpyjSuJBoSvK+ZrNjSSH97u0t048iC7gVb6tzQTut0
         4vkT+A/juB7+eYd7PaaV8rGsrSuj743+mAoa4kzzbZDQxsJKDVvi7OtNtNdtDgLgsRGr
         DVBkLDfTOkYamt5hHpHi7IdNTnSoJKie/DdKbH2xtMYABhcf30WT8dBZW5CE7kj7Uxav
         99As+4MNMuSge5fXluFEPgiD+IqnAb5DMPvAzBYGq+ENG51LYrZC0A2C3D9EAK/bLeZT
         b3rm0G6r/TxEb/ziUnMIh07xNHgwWs7kGUzmBu/aGC47Kcs6K0KEIOs7AUs9ssvMAazv
         4P0w==
X-Gm-Message-State: AOAM531aOJ6Kxy9fVqn9WoWtIwgBU7KzsVlEZNgX3KkJXSUtdhNIuX9u
        cDImhA5Gfub8NlXDTlsV/6GlOg==
X-Google-Smtp-Source: ABdhPJx8GoZAb06zYZhZWKCAzh39CvH3mJP+f3t0zhDQw8tiX/iOr4TJhZGR6imLGWgNpkyPj03v2Q==
X-Received: by 2002:a05:6e02:4a4:: with SMTP id e4mr10298335ils.114.1616770544540;
        Fri, 26 Mar 2021 07:55:44 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j6sm4090911ila.31.2021.03.26.07.55.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Mar 2021 07:55:44 -0700 (PDT)
Subject: Re: [PATCH 0/6] Allow signals for IO threads
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     torvalds@linux-foundation.org, ebiederm@xmission.com,
        oleg@redhat.com, linux-kernel@vger.kernel.org
References: <20210326003928.978750-1-axboe@kernel.dk>
 <e6de934a-a794-f173-088d-a140d0645188@samba.org>
 <f2c93b75-a18b-fc2c-7941-9208c19869c1@kernel.dk>
 <8efd9977-003b-be65-8ae2-4b04d8dd1224@samba.org>
 <0c91d9e7-82cd-bec2-19ae-cc592ec757c6@kernel.dk>
 <bfaae5fd-5de9-bae4-89b6-2d67bbfb86c6@kernel.dk>
 <66fa3cfc-4161-76fe-272e-160097f32a53@kernel.dk>
 <67a83ad5-1a94-39e5-34c7-6b2192eb7edb@samba.org>
 <ac807735-53d0-0c9e-e119-775e5e01d971@samba.org>
 <0396df33-7f91-90c8-6c0d-8a3afd3fff3c@kernel.dk>
Message-ID: <1304f480-a8db-44cf-5d89-aa9b99efdcd7@kernel.dk>
Date:   Fri, 26 Mar 2021 08:55:43 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0396df33-7f91-90c8-6c0d-8a3afd3fff3c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/26/21 8:53 AM, Jens Axboe wrote:
> On 3/26/21 8:45 AM, Stefan Metzmacher wrote:
>> Am 26.03.21 um 15:43 schrieb Stefan Metzmacher:
>>> Am 26.03.21 um 15:38 schrieb Jens Axboe:
>>>> On 3/26/21 7:59 AM, Jens Axboe wrote:
>>>>> On 3/26/21 7:54 AM, Jens Axboe wrote:
>>>>>>> The KILL after STOP deadlock still exists.
>>>>>>
>>>>>> In which tree? Sounds like you're still on the old one with that
>>>>>> incremental you sent, which wasn't complete.
>>>>>>
>>>>>>> Does io_wq_manager() exits without cleaning up on SIGKILL?
>>>>>>
>>>>>> No, it should kill up in all cases. I'll try your stop + kill, I just
>>>>>> tested both of them separately and didn't observe anything. I also ran
>>>>>> your io_uring-cp example (and found a bug in the example, fixed and
>>>>>> pushed), fwiw.
>>>>>
>>>>> I can reproduce this one! I'll take a closer look.
>>>>
>>>> OK, that one is actually pretty straight forward - we rely on cleaning
>>>> up on exit, but for fatal cases, get_signal() will call do_exit() for us
>>>> and never return. So we might need a special case in there to deal with
>>>> that, or some other way of ensuring that fatal signal gets processed
>>>> correctly for IO threads.
>>>
>>> And if (fatal_signal_pending(current)) doesn't prevent get_signal() from being called?
>>
>> Ah, we're still in the first get_signal() from SIGSTOP, correct?
> 
> Yes exactly, we're waiting in there being stopped. So we either need to
> check to something ala:
> 
> relock:
> +	if (current->flags & PF_IO_WORKER && fatal_signal_pending(current))
> +		return false;
> 
> to catch it upfront and from the relock case, or add:
> 
> 	fatal:
> +		if (current->flags & PF_IO_WORKER)
> +			return false;
> 
> to catch it in the fatal section.

Can you try this? Not crazy about adding a special case, but I don't
think there's any way around this one. And should be pretty cheap, as
we're already pulling in ->flags right above anyway.

diff --git a/kernel/signal.c b/kernel/signal.c
index 5ad8566534e7..5b75fbe3d2d6 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2752,6 +2752,15 @@ bool get_signal(struct ksignal *ksig)
 		 */
 		current->flags |= PF_SIGNALED;
 
+		/*
+		 * PF_IO_WORKER threads will catch and exit on fatal signals
+		 * themselves. They have cleanup that must be performed, so
+		 * we cannot call do_exit() on their behalf. coredumps also
+		 * do not apply to them.
+		 */
+		if (current->flags & PF_IO_WORKER)
+			return false;
+
 		if (sig_kernel_coredump(signr)) {
 			if (print_fatal_signals)
 				print_fatal_signal(ksig->info.si_signo);

-- 
Jens Axboe

