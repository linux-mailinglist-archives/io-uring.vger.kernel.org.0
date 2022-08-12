Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36DCD591775
	for <lists+io-uring@lfdr.de>; Sat, 13 Aug 2022 00:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbiHLWzL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 18:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWzK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 18:55:10 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FBB8E452
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:55:09 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bh13so1925598pgb.4
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 15:55:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=fxyjRrOWDFaCzM3SsYuwWv2ZMBEXJGpiN+i0BjAc5II=;
        b=IhvLPqXGmBaW6lQCS1oX0qIiYYBvPHw302gyTkUHR0zjcw9oZpgKX36+LEmbdpRijq
         /7+sYQex+5qbFI0NxdB7In4QPijGsp00+Hk49DYAW/8pI7d7P8I9i2zYGuRoRtMwZUUW
         LzmdkJVfkf9Eg0gBtS+bW0zSMCoEh8ApZnUwBjo2FhZ/hIbxJmJP+YDJYM3XLyofiu/M
         k7TZ75JXHm4i8p/XCsP3dIkbdsC5ORIzXmbh16L4rneZLHBPyySCARcP7nG1rMrYaw64
         MYyYYBv8tmtkl0f+2BIlxA/cDlSpRgKP6muzI1WAjJPgMhfRstavniQesPHAU12ixg0E
         5z4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fxyjRrOWDFaCzM3SsYuwWv2ZMBEXJGpiN+i0BjAc5II=;
        b=n7Zyxd3Q+wK1zp5MBneQ0xeCe0c8yTAafootmpWX+ETRyfPjdAxuopEA0hg4AB5f0Y
         cJzKTwjaSKiSkSjm6DLtJmvesDjZayO0h7q+GJkuITjZSMq81pgLRqjgtbrwi44c8CyO
         NehoKmZKQeL2+VG1OAFl2qgJnMt0O6UIMPUmr3022He5xewYWDnln0RaltjCU0Gd+cOT
         rd2mmLloBzjfdkeD//dHsf92tnWcXXkv/aiESlkHX4TBRCiWiXPLUlN7hKY/425Mr/VV
         jupX+NkB2L1kx6XYTEjIWpFYAlHWcpEz98BSOSLCUKtsL4me3TWHu7olcxtXLCGfehUO
         6APQ==
X-Gm-Message-State: ACgBeo26F6VAdSmjdKTaSZ6giOWTk5B3v7eeuN0HQVWQBN3aeWjIF/bx
        xtFBrwuhRq0AcamqqUaeggpLgw==
X-Google-Smtp-Source: AA6agR4q0OXl3r4mjka7rN3crzHEPWSGARJ0Z5G98bDTKjyTGnQcxYf8eIx45QBMAyt4NZoAn5AkOg==
X-Received: by 2002:a65:6b95:0:b0:420:2cb1:68e5 with SMTP id d21-20020a656b95000000b004202cb168e5mr4745874pgw.220.1660344909072;
        Fri, 12 Aug 2022 15:55:09 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e24-20020a635458000000b0041c04286010sm1808836pgm.83.2022.08.12.15.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 15:55:08 -0700 (PDT)
Message-ID: <90781707-08af-ae90-1fab-7e7f60b60821@kernel.dk>
Date:   Fri, 12 Aug 2022 16:55:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Keith Busch <kbusch@kernel.org>,
        io-uring <io-uring@vger.kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
 <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
 <433f4500-427d-8581-b852-fbe257aa6120@kernel.dk>
 <CAHk-=wi_oveXZexeUuxpJZnMLhLJWC=biyaZ8SoiNPd2r=6iUg@mail.gmail.com>
 <CAHk-=wj_2autvtY36nGbYYmgrcH4T+dW8ee1=6mV-rCXH7UF-A@mail.gmail.com>
 <bb3d5834-ebe2-a82d-2312-96282b5b5e2e@kernel.dk>
 <e9747e47-3b2a-539c-c60b-fd9ccfe5c5e4@kernel.dk>
 <YvbS/OHMJowdz+X3@kbusch-mbp.dhcp.thefacebook.com>
 <CAHk-=wg0CjDftjxVDGGwfA+rrBsg-nSOsMRS59fAw54W9N53Pw@mail.gmail.com>
 <d5ac5dc5-e477-073d-82cc-a02804c0c827@kernel.dk>
 <CAHk-=wh+8cWCY5axj6VguzuNKgKN0t3u=0h5=OCf9U+cyuhVBQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wh+8cWCY5axj6VguzuNKgKN0t3u=0h5=OCf9U+cyuhVBQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/22 4:52 PM, Linus Torvalds wrote:
> On Fri, Aug 12, 2022 at 3:38 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 8/12/22 4:35 PM, Linus Torvalds wrote:
>>> Honestly, I think maybe we should just stop randomizing kiocb.
>>
>> That'd obviously solve it... Do you want to commit something like that?
>> Or would you prefer a patch to do so?
> 
> Please send an updated io_uring pull with that included,

OK will do, I'll reorder to avoid the breakage too.

-- 
Jens Axboe

