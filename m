Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1700419665
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbhI0Ob0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 10:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234841AbhI0ObZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 10:31:25 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E4C0C061575
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 07:29:47 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i62so7013991ioa.6
        for <io-uring@vger.kernel.org>; Mon, 27 Sep 2021 07:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z6YqpvzQipk7G8h3r71aqTiA12ZVkdETw8MLPMHxnzg=;
        b=6GtpbiPl9w+HaDrTzODEG664GqfWgXNY9e9bpopVnAkxXi+XIcdQGdKCtS8zxibfpn
         na7L6TS67SvEXZzKhVY8KzWC1kSRqsQ3PmBrMIbRwEOU7JczGiULvyrUR4TYge8xJbdZ
         Hsi79L82i9nOngT8LzxAMvTlcO6n/UrgRM4171q9Kg4zp5XVzW534Bzf3c65vsKayjEf
         ARPAkC4kqe01IBkP4i2miNTLL6WZqZmlPfjI78sO8QrPyUyyo4ICmq51Jb4hO8jgEHNV
         fw+1FcwdxexmsNOVLcN8YIC7bt2bVD56HjoJKF/1SLmR5/x/6Dv+Ox7BNuk6qxuRow9o
         LFSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z6YqpvzQipk7G8h3r71aqTiA12ZVkdETw8MLPMHxnzg=;
        b=q0yFHMBHa1uOCRpk7Utfcoa097+yto2Q45Y3sf9NBIySC+UNgCu7aa7nWTtwlvzyOl
         cXRP4elYp+nxY8irXj8r7D4heHCiSI18reppeR3VvlkV3SOP/55iixVC/2ghlYMQnRh8
         tZ/nvo3VhkdqRT2faD6fM2eu3TlDOCCXHIZBIG5Sb13TjmILEp3hDFDV3k82m6D4Yi7L
         fljKEW1cBGOF+Vp6ZLZYhshJnaZ0qgWFeMv44QErStsNgwxba+aH/+MDlloRd+i36at2
         aIwFEZMe9A/cRk9ciTniObXCAoMqmMln9SQ86/JLfuIGmTme/EJCWjqPwzBrMt4JfTQO
         QPvw==
X-Gm-Message-State: AOAM532etPiqwUqISRbcm6G+sRM3hd1uc1s1b/SDi7cxFyNCCRj1EDXs
        vYWHeUH7jdlJmjxDTE3N2gKtJbujPOmp8DzJutE=
X-Google-Smtp-Source: ABdhPJxpv0BEK07QwuoITlaobZS7PeTBh6A2KcQFFNmRjADipLLFs9ymvrpXIgeys3p/TddiNdHejg==
X-Received: by 2002:a05:6638:f12:: with SMTP id h18mr177564jas.107.1632752986432;
        Mon, 27 Sep 2021 07:29:46 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k6sm3800423ilh.55.2021.09.27.07.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 07:29:46 -0700 (PDT)
Subject: Re: [GIT PULL] io_uring fixes for 5.15-rc3
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>
References: <fb81a0f6-0a9d-6651-88bc-d22e589de0ee@kernel.dk>
 <CAHk-=whi3UxvY1C1LQNCO9d2xzX5A69qfzNGbBVGpRE_6gv=9Q@mail.gmail.com>
 <0eeefd32-f322-1470-9bcf-0f415be517bd@kernel.dk> <87lf3iazyu.fsf@disp2133>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <feb00062-647c-1c74-dbe1-a7729ca49d7d@kernel.dk>
Date:   Mon, 27 Sep 2021 08:29:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87lf3iazyu.fsf@disp2133>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/27/21 7:51 AM, Eric W. Biederman wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
>> On 9/25/21 5:05 PM, Linus Torvalds wrote:
>>> On Sat, Sep 25, 2021 at 1:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> - io-wq core dump exit fix (me)
>>>
>>> Hmm.
>>>
>>> That one strikes me as odd.
>>>
>>> I get the feeling that if the io_uring thread needs to have that
>>> signal_group_exit() test, something is wrong in signal-land.
>>>
>>> It's basically a "fatal signal has been sent to another thread", and I
>>> really get the feeling that "fatal_signal_pending()" should just be
>>> modified to handle that case too.
>>
>> It did surprise me as well, which is why that previous change ended up
>> being broken for the coredump case... You could argue that the io-wq
>> thread should just exit on signal_pending(), which is what we did
>> before, but that really ends up sucking for workloads that do use
>> signals for communication purposes. postgres was the reporter here.
> 
> The primary function get_signal is to make signals not pending.  So I
> don't understand any use of testing signal_pending after a call to
> get_signal.
> 
> My confusion doubles when I consider the fact io_uring threads should
> only be dequeuing SIGSTOP and SIGKILL.
> 
> I am concerned that an io_uring thread that dequeues SIGKILL won't call
> signal_group_exit and thus kill the other threads in the thread group.
> 
> What motivated removing the break and adding the fatal_signal_pending
> test?

I played with this a bit this morning, and I agree it doesn't seem to be
needed at all. The original issue was with postgres, I'll give that a
whirl as well and see if we run into any unwarranted exits. My simpler
test case did not.

-- 
Jens Axboe

