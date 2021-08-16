Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E7E3ED547
	for <lists+io-uring@lfdr.de>; Mon, 16 Aug 2021 15:11:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhHPNKh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Aug 2021 09:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbhHPNKL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Aug 2021 09:10:11 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D52C8C0363C7;
        Mon, 16 Aug 2021 06:06:54 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k29so23513670wrd.7;
        Mon, 16 Aug 2021 06:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wvgUJiUW1naT+DW3zwINBggYbB2TOutmBqo2wsEseRc=;
        b=RVvoxPfmnySYBMjI9Cezd0eFLQChKRbGoquGQX5qUMaWQmbVUAuxX47eS8VxSteK2B
         SlO9hiqXPPNn+f9E57VKNQgofCUnd93kmzOEOHBz7YD7g+3n4MAjTs75vi4SKFSpD0lR
         gyvE70oDZ3JoCW16C8lV1fOBWBlNG4pKlk6+9kP0qTE7kKoqERZVOzoiHIi+zFNG3Lqt
         nqgXCNqRHo0G3nrNZBQUnsGfzFdgiaMIuTQKCGLtmV2RXqgFZvj/CvPHuXlQ/fgzFs1p
         fVROVCa6MY2a42zj3ysZVkHqo01J9OO9rZZouu6hayzG4Tkl+rgjWpr4JTrRvICJ3wA6
         p10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wvgUJiUW1naT+DW3zwINBggYbB2TOutmBqo2wsEseRc=;
        b=QZh0iO8XdrC6nwk8562F1ixCtm/XK3t9MTloLKEAl30ChaQLkERwgpIOXF/owZf6Gd
         GRUDChiBFXKBnLquQKiRHIE6PZ1GIIgHFLKbzC1sIM7YdtGXY4dZomg2GXGlLcz5msJs
         xIoaqSb0DuxRCfzg0TsdU9/ba1BeLb36CkpuvRMW/JZ6/12SCT1fIuWr1wyauWCJnYZw
         4ZAw5ptaUSJ9tgpANlnBTbDLW6wEClS10qaBTMK+p8u6nL+EdoIJ96n25vJ8mqG4RSJH
         CgCTP6+zA7owdtKQALPN2AUsIrRdMytxyjYO0sHtNpDIQJF0RlUmtITO0d7mD2+vtfrM
         jzzg==
X-Gm-Message-State: AOAM530rI7bwUjNZIAXeONiiBwvBkDuFqmvY5SElXAdtxhI/2sOqy28Y
        FcP8idQRQba9kjZ3e8gu99Q=
X-Google-Smtp-Source: ABdhPJzKZKjj43V9XRQbHEbi60duXuEN1+dtYpRGC1ZWcSynKPZSLcKV+hwZra34/G6oAiqsZQuscA==
X-Received: by 2002:a5d:4442:: with SMTP id x2mr18266693wrr.60.1629119213515;
        Mon, 16 Aug 2021 06:06:53 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.233.12])
        by smtp.gmail.com with ESMTPSA id p4sm13354694wrq.81.2021.08.16.06.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Aug 2021 06:06:53 -0700 (PDT)
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Olivier Langlois <olivier@trillion01.com>,
        Jens Axboe <axboe@kernel.dk>,
        Tony Battersby <tonyb@cybernetics.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
 <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
 <87eeda7nqe.fsf@disp2133>
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
 <b9f92bf3-77aa-8cdd-6db7-95c86e5a6946@gmail.com>
Message-ID: <ca4008f6-91f7-7623-7d15-7d5ef5363cd6@gmail.com>
Date:   Mon, 16 Aug 2021 14:06:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b9f92bf3-77aa-8cdd-6db7-95c86e5a6946@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/21 2:02 PM, Pavel Begunkov wrote:
> On 8/15/21 9:42 PM, Olivier Langlois wrote:
> [...]
>> When I have first encountered the issue, the very first thing that I
>> did try was to create a simple test program that would synthetize the
>> problem.
>>
>> After few time consumming failed attempts, I just gave up the idea and
>> simply settle to my prod program that showcase systematically the
>> problem every time that I kill the process with a SEGV signal.
>>
>> In a nutshell, all the program does is to issue read operations with
>> io_uring on a TCP socket on which there is a constant data stream.
>>
>> Now that I have a better understanding of what is going on, I think
>> that one way that could reproduce the problem consistently could be
>> along those lines:
>>
>> 1. Create a pipe
>> 2. fork a child
>> 3. Initiate a read operation on the pipe with io_uring from the child
>> 4. Let the parent kill its child with a core dump generating signal.
>> 5. Write something in the pipe from the parent so that the io_uring
>> read operation completes while the core dump is generated.
>>
>> I guess that I'll end up doing that if I cannot fix the issue with my
>> current setup but here is what I have attempted so far:
>>
>> 1. Call io_uring_files_cancel from do_coredump
>> 2. Same as #1 but also make sure that TIF_NOTIFY_SIGNAL is cleared on
>> returning from io_uring_files_cancel
>>
>> Those attempts didn't work but lurking in the io_uring dev mailing list
>> is starting to pay off. I thought that I did reach the bottom of the
>> rabbit hole in my journey of understanding io_uring but the recent
>> patch set sent by Hao Xu
>>
>> https://lore.kernel.org/io-uring/90fce498-968e-6812-7b6a-fdf8520ea8d9@kernel.dk/T/#t
>>
>> made me realize that I still haven't assimilated all the small io_uring
>> nuances...
>>
>> Here is my feedback. From my casual io_uring code reader point of view,
>> it is not 100% obvious what the difference is between
>> io_uring_files_cancel and io_uring_task_cancel
> 
> As you mentioned, io_uring_task_cancel() cancels and waits for all
> requests submitted by current task, used in exec() and SQPOLL because
> of potential races.

Apologies for this draft rumbling...

As you mentioned, io_uring_task_cancel() cancels and waits for all
requests submitted by current task, used in exec() and SQPOLL because
of potential races.

io_uring_task_cancel() cancels only selected ones, e.g. in 5.15
will be only requests operating on io_uring, and used during normal
exit.

Agree that the names may be not too descriptive.

>>
>> It seems like io_uring_files_cancel is cancelling polls only if they
>> have the REQ_F_INFLIGHT flag set.
>>
>> I have no idea what an inflight request means and why someone would
>> want to call io_uring_files_cancel over io_uring_task_cancel.
>>
>> I guess that if I was to meditate on the question for few hours, I
>> would at some point get some illumination strike me but I believe that
>> it could be a good idea to document in the code those concepts for
>> helping casual readers...
>>
>> Bottomline, I now understand that io_uring_files_cancel does not cancel
>> all the requests. Therefore, without fully understanding what I am
>> doing, I am going to replace my call to io_uring_files_cancel from
>> do_coredump with io_uring_task_cancel and see if this finally fix the
>> issue for good.
>>
>> What I am trying to do is to cancel pending io_uring requests to make
>> sure that TIF_NOTIFY_SIGNAL isn't set while core dump is generated.
>>
>> Maybe another solution would simply be to modify __dump_emit to make it
>> resilient to TIF_NOTIFY_SIGNAL as Eric W. Biederman originally
>> suggested.
>>
>> or maybe do both...
>>
>> Not sure which approach is best. If someone has an opinion, I would be
>> curious to hear it.
>>
>> Greetings,
>>
>>
> 

-- 
Pavel Begunkov
