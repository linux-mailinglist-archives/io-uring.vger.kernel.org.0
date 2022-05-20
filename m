Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2368C52ECB1
	for <lists+io-uring@lfdr.de>; Fri, 20 May 2022 14:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349583AbiETMxI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 May 2022 08:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235951AbiETMxH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 May 2022 08:53:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D877DE29
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 05:53:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id bh5so7278748plb.6
        for <io-uring@vger.kernel.org>; Fri, 20 May 2022 05:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=K48joKWWADzr7Z35QkCVv+Jn/yutrM6gsvgQnkpKmgg=;
        b=nunV+LdbUf7j720DSbCSghOqk0h+xc/4NNS65gbBL3kzNHxP4rcBJuOI0Fm6k93XMR
         Zt/SOAvlU791zjrXyYI7u5SRT5mvnnkwwfqwVPPPUehWRgVdGfNucC5jOeT1OyWeWv75
         Hs7IPHPKhtUj8ewpZgV8cvgu8L9nXEev/IyjhCYGjBhkUbTLJRO+Q1tYGFfOmiLM+Hft
         YRT/YgmLj6weisreBPK5SkasAVgDI7vMXvwFDrCxSRsdksTGgU+sQj6lH0ShrHVNxO6q
         n4zICyhRJZYdtbs4eN6ek8bIPIjZu9FqGfodRtxmqOjiJJhxCGS2L+gFVIJ/c1VGeEbV
         x3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=K48joKWWADzr7Z35QkCVv+Jn/yutrM6gsvgQnkpKmgg=;
        b=kmb1W9pSn/hbnoaOC07y1dPDTH8D/ynGeXTiMkYYiXqOlzt7DAPKfLVwIBGWHXBxap
         8S6KkHWl9Leqwz/PJjIZ+CmkvBAMm55SqzNPbwGWcPRPpMObmu3s7mWL07vmZ8CvXKxd
         LQ5kloyurfH/UtxFd84KxRmVh3vVEtnCc8RzptL++bQN50aR/tN5AijW5qmNZMaxy8Bw
         L7ssPz/r7kVOq8V/LgvoGQlmW1ECDB9AJMLuhcliVlY2V6KSKSRinS0kqPPG4hnt6P0z
         b9HQy01TgNHbovJ1Ya8zCTn/hHov1C2otw//lnmtlvU3ooTjuepeginvBJpA+lDchlFo
         U+Fg==
X-Gm-Message-State: AOAM531m3SFXk9i9dmt8ykEBzYmZAA8HZvky7Q1LSYHjHZqreNgTGFek
        9zYflGEf1FFAtwgYWC1dB+LvEEWv45Dwxw==
X-Google-Smtp-Source: ABdhPJyQUNHYw3StmP6ROMA2KN4boEIOCXmFcfjjUEFxR1dMLAzShchPWcCuIDfUGlArqKDrHBVuVQ==
X-Received: by 2002:a17:90b:1d0c:b0:1dd:220b:bac9 with SMTP id on12-20020a17090b1d0c00b001dd220bbac9mr11603896pjb.36.1653051186006;
        Fri, 20 May 2022 05:53:06 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016189ed82c4sm5543374plk.79.2022.05.20.05.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 05:53:05 -0700 (PDT)
Message-ID: <eded9b07-24b4-8060-7e84-8f44ad2e379a@kernel.dk>
Date:   Fri, 20 May 2022 06:53:03 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [syzbot] general protection fault in __io_arm_poll_handler
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzkaller <syzkaller@googlegroups.com>
References: <000000000000f0da6305cb1feacb@google.com>
 <15a67989-9ad7-11ef-9472-8e16ca6ec11a@kernel.dk>
 <CACT4Y+bNGPfF-z-9fxCXQO7huMJ=yCknWm_-H=7CJNvKOne3qA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACT4Y+bNGPfF-z-9fxCXQO7huMJ=yCknWm_-H=7CJNvKOne3qA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/22 2:41 AM, Dmitry Vyukov wrote:
> On Sat, 4 Sept 2021 at 02:49, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 9/3/21 5:47 PM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot has tested the proposed patch and the reproducer did not trigger any issue:
>>>
>>> Reported-and-tested-by: syzbot+ba74b85fa15fd7a96437@syzkaller.appspotmail.com
>>>
>>> Tested on:
>>>
>>> commit:         31efe48e io_uring: fix possible poll event lost in mul..
>>> git tree:       git://git.kernel.dk/linux-block for-5.15/io_uring
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=914bb805fa8e8da9
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=ba74b85fa15fd7a96437
>>> compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.1
>>>
>>> Note: testing is done by a robot and is best-effort only.
>>
>> Dmitry, I wonder if there's a way to have syzbot know about what it's
>> testing and be able to run the pending patches for that tree? I think
>> we're up to 4 reports now that are all just fallout from the same bug,
>> and where a patch has been queued up for a few days. Since they all look
>> different, I can't fault syzbot for thinking they are different, even if
>> they have the same root cause.
>>
>> Any way we can make this situation better? I can't keep replying that we
>> should test the current branch, and it'd be a shame to have a ton of
>> dupes.
> 
> Hi Jens,
> 
> This somehow fell through the cracks, but better late than never.
> 
> We could set up a syzbot instance for the io-uring tree.
> It won't solve the problem directly, but if the branch contains both
> new development ("for-next") and fixes, it will have good chances of
> discovering issues before they reach mainline and spread to other
> trees.
> Do you think it's a good idea? Is there a branch that contains new
> development and fixes?

My for-next stuff is always in linux-next, so I think as long as that is
tested, that should be quite fine. It's _usually_ not a problem, it just
sometimes happens that a broken patch ends up triggering a bunch of
different things. And then we don't get them all attributed in a fix, or
perhaps the patch itself is fixed up (or removed) and pushed out, then
leaving the syzbot reports in limbo.

In short, I don't think we need to do anything special here for now.

-- 
Jens Axboe

