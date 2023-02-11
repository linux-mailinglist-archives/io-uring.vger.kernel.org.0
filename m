Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6780F693173
	for <lists+io-uring@lfdr.de>; Sat, 11 Feb 2023 15:13:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjBKONx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Feb 2023 09:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBKONv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Feb 2023 09:13:51 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E272C67E
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 06:13:47 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id b5so9427223plz.5
        for <io-uring@vger.kernel.org>; Sat, 11 Feb 2023 06:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oqGRKzSo6E4/f+woXcOCjpwjArDsyHYfDxL4HTg7iio=;
        b=wCNiYJcLkvEUpEZHzCL9RSSTZah20e3Vx5u3HSFTxE8bpS6ViAr7yu2nh6p7lms2yc
         yOAKa9NxNMFxnywW9IFuGVT0q1LbIqUR9FQgUsxxKG31pWabOZ5AxPL4nn2Eak6eBUFy
         z9kShKrMpIJtUnj5hM/0l2fqIh8uVfF/GjluWOL0mUT0gf0a49ylXOVttlcfR+bB7PC3
         GyAHRdXjdOPP7uzT3iNyZ4YznGS5MkfCepIrwxKiMOQ+SktVrYhDDeKcrgl50xxID1bi
         32NrSPKIGD0eBfPDf3QV9+Hss3B8PpPqCifUU0VKfGtwDAHQrDhNqYh5ouBiCy0xt09G
         ynvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oqGRKzSo6E4/f+woXcOCjpwjArDsyHYfDxL4HTg7iio=;
        b=QiDutob7bdwliuVTSqY1ydqCC5T06309uyW0k4hq55rEeMqDpEdW3EdLkP34lQrtzB
         IAnEXfgF4kPoVj0/fMMjU3g6gRprVnOz3VIWDKCzfAOq+v645LGoe4VTadC9UPApY6Ae
         DhIOezeIPB6h6CgU49wdOcG23UVxLfGbSvT+9glSxAP1p0Hf2mOuedv9eZ6gt04AnL3r
         wygqhhHEcXwkL2NfYEhWdE3JuaDtY7+cX960EKNk/nPjK7iYE24o3eCXsnCuqi+HdAwn
         VDQJSPpX30CuSYW0BHhicXIxLvgfzSv+Gumih8RCryzTeD/gvrEeK3jNJ5qodIAh9XyF
         pwHQ==
X-Gm-Message-State: AO0yUKUE0g0+TKqPuMxgv1AUujgUsLy0gnf0CetUJ1siZrNG6qQWzK47
        Aa8o4R9xteFu6UmbMg/5fdhxyA==
X-Google-Smtp-Source: AK7set/LnVAtiy5TUkkuzhteoCRyrs4pqpY8XSDBYd/FSNwWtCjGA99X1ZzvEOtfDL0WSzAPF6ud0g==
X-Received: by 2002:a17:902:680b:b0:199:3f82:ef62 with SMTP id h11-20020a170902680b00b001993f82ef62mr15067071plk.5.1676124826228;
        Sat, 11 Feb 2023 06:13:46 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q10-20020a170902b10a00b00174f61a7d09sm5015531plr.247.2023.02.11.06.13.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Feb 2023 06:13:45 -0800 (PST)
Message-ID: <55eaac9e-0d77-1fa2-df27-4d64e123177e@kernel.dk>
Date:   Sat, 11 Feb 2023 07:13:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: copy on write for splice() from file to pipe?
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@infradead.org>,
        Stefan Metzmacher <metze@samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux API Mailing List <linux-api@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Samba Technical <samba-technical@lists.samba.org>
References: <CAHk-=wgA=rB=7M_Fe3n9UkoW_7dqdUT2D=yb94=6GiGXEuAHDA@mail.gmail.com>
 <1dd85095-c18c-ed3e-38b7-02f4d13d9bd6@kernel.dk>
 <CAHk-=wiszt6btMPeT5UFcS=0=EVr=0injTR75KsvN8WetwQwkA@mail.gmail.com>
 <fe8252bd-17bd-850d-dcd0-d799443681e9@kernel.dk>
 <CAHk-=wiJ0QKKiORkVr8n345sPp=aHbrLTLu6CQ-S0XqWJ-kJ1A@mail.gmail.com>
 <7a2e5b7f-c213-09ff-ef35-d6c2967b31a7@kernel.dk>
 <CALCETrVx4cj7KrhaevtFN19rf=A6kauFTr7UPzQVage0MsBLrg@mail.gmail.com>
 <b44783e6-3da2-85dd-a482-5d9aeb018e9c@kernel.dk>
 <2bb12591-9d24-6b26-178f-05e939bf3251@kernel.dk>
 <CAHk-=wjzqrD5wrfeaU390bXEEBY2JF-oKmFN4fREzgyXsbQRTQ@mail.gmail.com>
 <Y+cJDnnMuirSjO3E@T590>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+cJDnnMuirSjO3E@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/23 8:18?PM, Ming Lei wrote:
> On Fri, Feb 10, 2023 at 02:08:35PM -0800, Linus Torvalds wrote:
>> On Fri, Feb 10, 2023 at 1:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> Speaking of splice/io_uring, Ming posted this today:
>>>
>>> https://lore.kernel.org/io-uring/20230210153212.733006-1-ming.lei@redhat.com/
>>
>> Ugh. Some of that is really ugly. Both 'ignore_sig' and
>> 'ack_page_consuming' just look wrong. Pure random special cases.
>>
>> And that 'ignore_sig' is particularly ugly, since the only thing that
>> sets it also sets SPLICE_F_NONBLOCK.
>>
>> And the *only* thing that actually then checks that field is
>> 'splice_from_pipe_next()', where there are exactly two
>> signal_pending() checks that it adds to, and
>>
>>  (a) the first one is to protect from endless loops
>>
>>  (b) the second one is irrelevant when  SPLICE_F_NONBLOCK is set
>>
>> So honestly, just NAK on that series.
>>
>> I think that instead of 'ignore_sig' (which shouldn't exist), that
>> first 'signal_pending()' check in splice_from_pipe_next() should just
>> be changed into a 'fatal_signal_pending()'.
> 
> Good point, here the signal is often from task_work_add() called by
> io_uring.

Usually you'd use task_sigpending() to distinguis the two, but
fatal_signal_pending() as Linus suggests would also work. The only
concern here is that since you'll be potentially blocking on waiting for
the pipe to be readable - if task does indeed have task_work pending and
that very task_work is the one that will ensure that the pipe is now
readable, then you're waiting condition will never be satisfied.

-- 
Jens Axboe

