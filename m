Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9453F6CAF50
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjC0UAd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 16:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC0UAc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 16:00:32 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80912CC
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 13:00:31 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id q6so4420596iot.2
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 13:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679947231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=11bvFWDugzPlA3+YQ9yGap9EgCbK+PilbMpBkuMW1F8=;
        b=RaEJYMgGGqoa0yxbnuRNhs/oDZAitr2nbSNm8IqTBeAQ9sLkiu1ijzvpT1lNBMkhR4
         1g9fgT54xMkBSi+0kv5FITBclhL79ELUWYQS1G4D33K3bojkQJ9yGbMkkGzUpKfFsV7R
         SGbvWivaEu7lebv000QEouQYum+fWajV5xHmhMgTT/mY6i9mFH3xR6qhS7SRu48QcFUQ
         NMhZE8FSkdV8k47GtWsG7gykKfsdoJiv46agI9pWSKSyX7L5ajzMcBqbt3Vax833lbSB
         A34eKp+5yddghrGUsQeEshSFvgumZoa5V9hUXmKJsHCfWtwu+QU/4EmxfSZXgxsw9js9
         42Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679947231;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11bvFWDugzPlA3+YQ9yGap9EgCbK+PilbMpBkuMW1F8=;
        b=5Q3O/Su9bpZ0SKzyyPUqMt0aTihwa96ZuiaILyJQXHmgN9exGLiF8S57DnuPx42rzi
         1zEt71ukg9Hu75p+5iDoUzVBr3gl/B9ZEr9JsdGIcwpmgjQjsoG38H2RToNF/eWnRXO3
         NAebPcfgJltSE1aukskixpp4XMke2ZPj12jj1gNabPbfV8/6EJi6+qgufZKy7p1CXsk+
         w5R/leRPdvhqkCF1GwkX58L0Bi8H2azEumG281oxNVYFlpwU55BmGstQKxT1l01nh0Q6
         NJs8WwZhtHgDrzKdLi4JjFL7jtAMO+2zz8I4VOC0W4NX5Qeh1F62REIMidBJpCZAriSk
         YeMQ==
X-Gm-Message-State: AO0yUKU+Qb8yKJ4P6Cktq9XnPh5uPrZz2YUaDaO0jYeUEXDTdUdaZnbe
        Lzd3sexxHjZG3ofwC94sjdCLZw==
X-Google-Smtp-Source: AK7set/B5PMW4tALmwUQyWGfTT8NjPzW4MsBaJpS0tp7v/YuWVcv5sKRSQO9Gbqtozcd8Y4kJfC+3w==
X-Received: by 2002:a05:6602:395:b0:758:5653:353a with SMTP id f21-20020a056602039500b007585653353amr7735614iov.0.1679947230770;
        Mon, 27 Mar 2023 13:00:30 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n4-20020a056638110400b00400d715c57dsm9322718jal.29.2023.03.27.13.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 13:00:30 -0700 (PDT)
Message-ID: <11ccf63c-2822-1e1e-6f4b-833136d46628@kernel.dk>
Date:   Mon, 27 Mar 2023 14:00:29 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] Monthly io-uring report
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Aleksandr Nogikh <nogikh@google.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+lista29bb0eabb2ddbae6f4a@syzkaller.appspotmail.com>
References: <000000000000bb028805f7dfab35@google.com>
 <20230327192158.GF73752@sol.localdomain>
 <4045f952-0756-5b04-8c60-6eed241a52fe@kernel.dk> <ZCH02Fp0YAhrLnug@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZCH02Fp0YAhrLnug@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/23 1:56 PM, Eric Biggers wrote:
> On Mon, Mar 27, 2023 at 01:25:14PM -0600, Jens Axboe wrote:
>> On 3/27/23 1:21?PM, Eric Biggers wrote:
>>> On Mon, Mar 27, 2023 at 04:01:54AM -0700, syzbot wrote:
>>>> Hello io-uring maintainers/developers,
>>>>
>>>> This is a 30-day syzbot report for the io-uring subsystem.
>>>> All related reports/information can be found at:
>>>> https://syzkaller.appspot.com/upstream/s/io-uring
>>>>
>>>> During the period, 5 new issues were detected and 0 were fixed.
>>>> In total, 49 issues are still open and 105 have been fixed so far.
>>>>
>>>> Some of the still happening issues:
>>>>
>>>> Crashes Repro Title
>>>> 3393    Yes   WARNING in io_ring_exit_work
>>>>               https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
>>>> 3241    Yes   general protection fault in try_to_wake_up (2)
>>>>               https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
>>>> 1873    Yes   WARNING in split_huge_page_to_list (2)
>>>>               https://syzkaller.appspot.com/bug?extid=07a218429c8d19b1fb25
>>>> 772     Yes   INFO: task hung in io_ring_exit_work
>>>>               https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
>>>> 718     Yes   KASAN: use-after-free Read in io_poll_remove_entries
>>>>               https://syzkaller.appspot.com/bug?extid=cd301bb6523ea8cc8ca2
>>>> 443     Yes   KMSAN: uninit-value in io_req_cqe_overflow
>>>>               https://syzkaller.appspot.com/bug?extid=12dde80bf174ac8ae285
>>>> 73      Yes   INFO: task hung in io_wq_put_and_exit (3)
>>>>               https://syzkaller.appspot.com/bug?extid=adb05ed2853417be49ce
>>>> 38      Yes   KASAN: use-after-free Read in nfc_llcp_find_local
>>>>               https://syzkaller.appspot.com/bug?extid=e7ac69e6a5d806180b40
>>>>
>>>> ---
>>>> This report is generated by a bot. It may contain errors.
>>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> Thanks for getting syzbot to classify reports by subsystem and send these
>>> reminders!  These should be very helpful over time.
>>>
>>> One thing that is missing in these reminders is a mention of how to change the
>>> subsystem of miscategorized bugs.  Yes, it's in https://goo.gl/tpsmEJ halfway
>>> down the page, but it's not obvious.
>>>
>>> I think adding something like "See https://goo.gl/tpsmEJ#subsystems for how to
>>> change the subsystem of miscategorized reports" would be helpful.  Probably not
>>> in all syzbot emails, but just in these remainder emails.
>>
>> I did go poke, it is listed off the reports too. But it'd be really
>> handy if you could do this on the web page. When I see a report like
>> that that's not for me, I just archive it. And like any chatter with
>> syzbot, I have to look up what to reply to it every time. It'd be a lot
>> easy if I could just click on that page to either mark as invalid
>> (providing the info there) or move it to another subsystem.
>>
> 
> Well, one problem that syzbot has to deal with is that to meet the kernel
> community's needs, it can't require authentication to issue commands.
> 
> I understand that the current email-only interface, where all commands are Cc'ed
> to the syzkaller-bug mailing list, makes that not a complete disaster currently.
> 
> I'd imagine that if anyone could just go to a web page and mess around with bug
> statuses with no authentication, that might be more problematic.

What prevents anyone from just sending an email to the syzbot issue email
and modifying it?

I love using email as it's easier when you're replying anyway, but the
problem is that I can never remember the magic incantations that I need
to send it. So I invariably click the link ANYWAY to find out what to
reply, and now it's more hassle using email. Maybe we can solve this by
making the email footer actually contain the common responses? Then
I would not have to click, switch desktops, scroll to find, copy part
of it, switch desktops, paste into email, open terminal to generate
the rest, switch back to email, paste in, click send. It really isn't
a very pleasurable experience.

-- 
Jens Axboe


