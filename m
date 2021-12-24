Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F4447EE4A
	for <lists+io-uring@lfdr.de>; Fri, 24 Dec 2021 11:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344118AbhLXKiK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Dec 2021 05:38:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343932AbhLXKiK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Dec 2021 05:38:10 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81EEC061401;
        Fri, 24 Dec 2021 02:38:09 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id i22so16680146wrb.13;
        Fri, 24 Dec 2021 02:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XjBGi+dJXXQnmTq7rq+KjohVrDPP5Z8h7UOS9LTpl7A=;
        b=Rj37lDjhRFUc7q2M+C6fi9hbOPuyZjdMGbHyY4K6HHo3T1eJHJGMoM/400ZwXdh9sB
         ltN6Zd82Ah1EEaxr+ol7thpVVvDzlZKSDrTC4QgoT3mkjKRc5wAFPRVV5hPf/UjNqdYl
         I8D5Ou9/Ofl56PLVyO+s2wNMP+TLGZkvvGYPx6yDoiPM7iYCgbFhXHwUoB/73pjTSz8k
         pPZTQ4BuDb+if26Rp2Hb4ItZOQZH++3kuu8SxXIVnLD36SlAMyp/E3V94KBPYPBzgJr0
         5oi5+oTPgs8ujfXKyZhDhTsAyPyx9C6GK8w1cYr+bedjnMAMVNj/8xLQOLUkPxRFmrik
         d6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XjBGi+dJXXQnmTq7rq+KjohVrDPP5Z8h7UOS9LTpl7A=;
        b=Zhzxpo8z6PSuun6bneeo+evkMMhf8RapTv4Vo0ZhjvGNqCWffIzYZVJZHvTZ/DlC6/
         vpJZwJg6O22+G0wjYkXiwgUrgLw7fiICubG/TPiQBKiOSQn46iI/j+kiOgY0T/J3Z+xH
         TvPtDROcEHPzh2IFmHKqBFbV1Gb308fFbkgGN4CLFVd3Gfl3xPLlsJwXVkWjnE4gQ0+7
         1ObmRFexBB8IMy0nKNpXttoRhZ9XFGvZM08JxnxcSJyFCMwjOmE+agqIT3fVSIUFRxE8
         R9ewkmVCNZRaRSNhaoBEL0VJmjtSnU8UtBMsL6OtEXMzwx3W+dBxhAB8JAh0tDakmmFi
         Vvog==
X-Gm-Message-State: AOAM531VwKj+YCX0Qp977lH5/Syndz9tH0DpXPsjwY9CdKvsX4hsa/TQ
        iEcoxCWHhE7+zTcuXT3jQrGOUajnMlM=
X-Google-Smtp-Source: ABdhPJys90a3kGzt+UsOHuNN9q/es+YbAMysaOzL5WhNevcs2Vf/ooc2d4G0kjBwoGEKL3i9w4pl7Q==
X-Received: by 2002:a5d:6049:: with SMTP id j9mr4166002wrt.332.1640342288320;
        Fri, 24 Dec 2021 02:38:08 -0800 (PST)
Received: from [192.168.8.198] ([148.252.132.189])
        by smtp.gmail.com with ESMTPSA id a1sm7598466wru.113.2021.12.24.02.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Dec 2021 02:38:07 -0800 (PST)
Message-ID: <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
Date:   Fri, 24 Dec 2021 10:37:31 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
 <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 12/24/21 01:34, Olivier Langlois wrote:
> On Fri, 2021-10-22 at 15:13 +0100, Pavel Begunkov wrote:
>> On 6/9/21 21:17, Eric W. Biederman wrote:
>> In short, a task creates an io_uring worker thread, then the worker
>> submits a task_work item to the creator task and won't die until
>> the item is executed/cancelled. And I found that the creator task is
>> sleeping in do_coredump() -> wait_for_completion()
>>
[...]
>> A hack executing tws there helps (see diff below).
>> Any chance anyone knows what this is and how to fix it?
>>
[...]
> Pavel,
> 
> I cannot comment on the merit of the proposed hack but my proposed
> patch to fix the coredump truncation issue when a process using
> io_uring core dumps that I submitted back in August is still
> unreviewed!

That's unfortunate. Not like I can help in any case, but I assumed
it was dealt with by

commit 06af8679449d4ed282df13191fc52d5ba28ec536
Author: Eric W. Biederman <ebiederm@xmission.com>
Date:   Thu Jun 10 15:11:11 2021 -0500

     coredump: Limit what can interrupt coredumps
     
     Olivier Langlois has been struggling with coredumps being incompletely written in
     processes using io_uring.
     ...

> https://lore.kernel.org/lkml/1625bc89782bf83d9d8c7c63e8ffcb651ccb15fa.1629655338.git.olivier@trillion01.com/
> 
> I have been using it since then I must have generated many dozens of
> perfect core dump files with it and I have not seen a single truncated
> core dump files like I used to have prior to the patch.
> 
> I am bringing back my patch to your attention because one nice side
> effect of it is that it would have avoided totally the problem that you
> have encountered in coredump_wait() since it does cancel io_uring
> resources before calling coredump_wait()!

FWIW, I worked it around in io_uring back then by breaking the
dependency.

-- 
Pavel Begunkov
