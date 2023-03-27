Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B6E76CAE84
	for <lists+io-uring@lfdr.de>; Mon, 27 Mar 2023 21:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjC0TZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Mar 2023 15:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC0TZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Mar 2023 15:25:17 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E23ECF
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:25:16 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h11so5164049ild.11
        for <io-uring@vger.kernel.org>; Mon, 27 Mar 2023 12:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679945115; x=1682537115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyk2W940sqvmOOAE7vtylepXCeMfS8C/RkY9WHJ9hX0=;
        b=ri4COfEetEUMaBpjoPzVZ1cntn00ltloaLu5i1Nq0kZsaF7msSIsOmo1RgUH/DY574
         JEiTSFAYz/hhejg7wy5t04kLe36wkkGtZmnsYcb7fc0OOExdpWLuSaUg76lNeKXcVwGT
         7LyoQdvQmGG4aXUkJ2HXi2OYkXwHo75qXL3LeMum+IXAaacLmcoNOmIXlzaXKFBVpDm1
         zXS/gxyhXXgs8JagcuOy/vkmLUz20N1Xjrj4qupLHIdRrwuOvnmNNCt8iZVhAEGhlMic
         Yq5n2RebkiFH1err/5+ssHK0dsJU9irhYlTzArT2eDdu0qw8CDfX2z/PtojZEL357uJV
         3xkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679945115; x=1682537115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uyk2W940sqvmOOAE7vtylepXCeMfS8C/RkY9WHJ9hX0=;
        b=oWil8okMAUw/acrM6z0K2A8z9uX6aTzED7fbXH8FCTfuJazRSlyV50OWmQO6XFG9Qb
         BJ3dgln9J9BdDKe+SWaoiHdSfFu8rbvaYIGdxDQ9c1tuj1DfeztN95ck/2eNvVkRPviT
         1Ek9VOZaQ2HMQGh99llJVGAQzrlQHNcaKOwE+PUe5qbqWHOrY9RlxPr/rbcyB5WFAXkX
         yabYfjetB5+fkdg+p0fVieZyPJMqRcCZLSEypby/RbgHypDUT2LEammOKRRPbpCc0H6x
         nc5FHWWa/na8fTuGSQVYPBVOCJVQMOskKkTSZMsQdZ/gO6+/pVM2oU0R0LnGaPnrt3Hx
         9prg==
X-Gm-Message-State: AAQBX9cjnZQ7jcTeBkyZf4Aodv5qbO2Voh63DYTrJ+T+y73sJa0aam7k
        GChZzNygIiVrwv4HDt23H9k4hA==
X-Google-Smtp-Source: AKy350YAvHqYDnEv/3siWCqUnn00znahiZRHe/iCPjgc4m6/7hEPNSLtWC0wMysnl5L3/GYTpYzUhA==
X-Received: by 2002:a05:6e02:88c:b0:325:c88b:79b6 with SMTP id z12-20020a056e02088c00b00325c88b79b6mr6999792ils.2.1679945115460;
        Mon, 27 Mar 2023 12:25:15 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p11-20020a92b30b000000b00325daf836fdsm2779865ilh.17.2023.03.27.12.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 12:25:15 -0700 (PDT)
Message-ID: <4045f952-0756-5b04-8c60-6eed241a52fe@kernel.dk>
Date:   Mon, 27 Mar 2023 13:25:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [syzbot] Monthly io-uring report
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot <syzbot+lista29bb0eabb2ddbae6f4a@syzkaller.appspotmail.com>
References: <000000000000bb028805f7dfab35@google.com>
 <20230327192158.GF73752@sol.localdomain>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230327192158.GF73752@sol.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/27/23 1:21?PM, Eric Biggers wrote:
> On Mon, Mar 27, 2023 at 04:01:54AM -0700, syzbot wrote:
>> Hello io-uring maintainers/developers,
>>
>> This is a 30-day syzbot report for the io-uring subsystem.
>> All related reports/information can be found at:
>> https://syzkaller.appspot.com/upstream/s/io-uring
>>
>> During the period, 5 new issues were detected and 0 were fixed.
>> In total, 49 issues are still open and 105 have been fixed so far.
>>
>> Some of the still happening issues:
>>
>> Crashes Repro Title
>> 3393    Yes   WARNING in io_ring_exit_work
>>               https://syzkaller.appspot.com/bug?extid=00e15cda746c5bc70e24
>> 3241    Yes   general protection fault in try_to_wake_up (2)
>>               https://syzkaller.appspot.com/bug?extid=b4a81dc8727e513f364d
>> 1873    Yes   WARNING in split_huge_page_to_list (2)
>>               https://syzkaller.appspot.com/bug?extid=07a218429c8d19b1fb25
>> 772     Yes   INFO: task hung in io_ring_exit_work
>>               https://syzkaller.appspot.com/bug?extid=93f72b3885406bb09e0d
>> 718     Yes   KASAN: use-after-free Read in io_poll_remove_entries
>>               https://syzkaller.appspot.com/bug?extid=cd301bb6523ea8cc8ca2
>> 443     Yes   KMSAN: uninit-value in io_req_cqe_overflow
>>               https://syzkaller.appspot.com/bug?extid=12dde80bf174ac8ae285
>> 73      Yes   INFO: task hung in io_wq_put_and_exit (3)
>>               https://syzkaller.appspot.com/bug?extid=adb05ed2853417be49ce
>> 38      Yes   KASAN: use-after-free Read in nfc_llcp_find_local
>>               https://syzkaller.appspot.com/bug?extid=e7ac69e6a5d806180b40
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> Thanks for getting syzbot to classify reports by subsystem and send these
> reminders!  These should be very helpful over time.
> 
> One thing that is missing in these reminders is a mention of how to change the
> subsystem of miscategorized bugs.  Yes, it's in https://goo.gl/tpsmEJ halfway
> down the page, but it's not obvious.
> 
> I think adding something like "See https://goo.gl/tpsmEJ#subsystems for how to
> change the subsystem of miscategorized reports" would be helpful.  Probably not
> in all syzbot emails, but just in these remainder emails.

I did go poke, it is listed off the reports too. But it'd be really
handy if you could do this on the web page. When I see a report like
that that's not for me, I just archive it. And like any chatter with
syzbot, I have to look up what to reply to it every time. It'd be a lot
easy if I could just click on that page to either mark as invalid
(providing the info there) or move it to another subsystem.

-- 
Jens Axboe

