Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C30AE538D74
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 11:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245071AbiEaJHY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 05:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245103AbiEaJHR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 05:07:17 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DBB24948
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:07:13 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x17so8686303wrg.6
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Da7CpUzfigAT4CIYpAa4S3dnkp2cNQHn7AtCXpqTizs=;
        b=lIHzKa+jSnfytsD+Mp7xDDDZi7o4cUhwyisi0ts+8d3JRUbjVIV38DYCJHOl8pq2ib
         UB6/+hbLc2Sy2SYynmoqY/YWspccNUcJhI3/Sr2/+C9rg4S+digPGeenGn/SlFQCtKTd
         Gv8Jb+u/6n3HRS+vVcBKXeNKB2B40wlgPmWTbJqat3UipFJjX4oQmjTNENDYcMOvWUoT
         Eps+CWDrirAYSy07eTbSUzozxFjnoTuWQ/RyWsrs3m2UCCUU29fSVVaiJfWmtkAL/bUq
         Km2FcwbmPjMSMDx2wv+6XivFP7x6QJGHUYpyBcr4ouSR3yHAjaFL0T/YPnPy47UxTgIY
         jJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Da7CpUzfigAT4CIYpAa4S3dnkp2cNQHn7AtCXpqTizs=;
        b=KM3mfhTADMRCz72h3UNmNtQir5ti6jrxJtOh7YjnPdfUUQRY/0GZUdOm2usM9ZE1C/
         3cKIyO26u5Tix796Vs8E7XebqcbU77F8daag2YO9MUL3PYr9YwNJQBZPI10cKdwOTiY7
         YBxt2VuOhDimnqrjcH8HQXURyUHYdHchzYOKKTMLvwfes7jGN1tTaOmHX6fXdd/EYpa4
         PFHxuuxoFazKwm1eqCb2n6TaXaegLDvyBo83NVzv1hdTsL0jFqusUs9nZsxftrQ7Yq2v
         OlYlYoHnYKGw52h/MQeeXq00DQG2yXeRM1N3v2Lfv5mMGlhWZtEwkn5xMZRg7BXWlROE
         wqyw==
X-Gm-Message-State: AOAM532qItMtAo+78drYZVXfefhkLWxeVZ9oBzBKTdmJHlGG9q3pH5Eo
        gTwtf43oVsh1Ch9eurotAP8GCQ==
X-Google-Smtp-Source: ABdhPJynCOtAl39IHyypdJg+WREtGlQuCJn0fX9jFpVVRkxUzkTM3i4oHVsc21wrbJlrvrSbtW7hUg==
X-Received: by 2002:a5d:4fc2:0:b0:210:940:b1fd with SMTP id h2-20020a5d4fc2000000b002100940b1fdmr21151584wrw.134.1653988031891;
        Tue, 31 May 2022 02:07:11 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id m10-20020a7bcb8a000000b00397243d3dbcsm1545690wmi.31.2022.05.31.02.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:07:11 -0700 (PDT)
Message-ID: <7c582099-0eef-6689-203a-606cb2f69391@kernel.dk>
Date:   Tue, 31 May 2022 03:07:10 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Hao Xu <haoxu.linux@icloud.com>,
        syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000f0b26205e04a183b@google.com>
 <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
 <e0867860-12c6-e958-07de-cfbcf644b9fe@icloud.com>
 <bcac089a-36e5-0d85-1ec3-b683dac68b4f@kernel.dk>
 <CACT4Y+aqriNp1F5CJofqaxNMM+-3cxNR2nY0tHEtb4YDqDuHtg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACT4Y+aqriNp1F5CJofqaxNMM+-3cxNR2nY0tHEtb4YDqDuHtg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 3:05 AM, Dmitry Vyukov wrote:
> On Tue, 31 May 2022 at 11:01, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/31/22 3:00 AM, Hao Xu wrote:
>>> On 5/31/22 16:45, Jens Axboe wrote:
>>>> On 5/31/22 1:55 AM, syzbot wrote:
>>>>> Hello,
>>>>>
>>>>> syzbot found the following issue on:
>>>>>
>>>>> HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
>>>>> git tree:       linux-next
>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>>>
>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>
>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>> Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
>>>>>
>>>>> ================================================================================
>>>>> ================================================================================
>>>>> UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
>>>>> index 75 is out of range for type 'io_op_def [47]'
>>>>
>>>> 'def' is just set here, it's not actually used after 'opcode' has been
>>>> verified.
>>>>
>>>
>>> Maybe we can move it to be below the opcode check to comfort UBSAN.
>>
>> Yeah that's what I did, just rebased it to get rid of it:
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=fcde59feb1affb6d56aecadc3868df4631480da5
> 
> If you are rebasing it, please add the following tag so that the bug
> is closed later:
> 
> Tested-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com

Sorry, missed that, would be a bit confusing? 5.20 branch is rebased
on top of that too. Can we just do:

#syz fix: io_uring: add io_op_defs 'def' pointer in req init and issue

?

-- 
Jens Axboe

