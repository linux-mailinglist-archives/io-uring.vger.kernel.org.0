Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624D1538D48
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 10:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245006AbiEaI5C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 04:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245023AbiEaI5A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 04:57:00 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A397BF41
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:56:49 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k16so13371776wrg.7
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 01:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HgvSkaz2FuWSd/vi2YSVeb+lmMXTx/j35bYriHV9OxE=;
        b=CREHGaKstjNogJznHmWAIZNbrWaTcNE4Ru4s2PowqiinEyXhLbbW/PUkq6Lqn8Gy4M
         ifY/tA+RPJfHyrJR5DvydTDr++woNyydw8+NCfiiZR+XlsuPyN/BSSGIZoEzXjRJ9Wf8
         vj6DtQPWKdN5kZ9c88/vH2WwY36hVGaU32jIZmsIdDgRkJcRspn0bQLj6B7OwV9HwfTN
         hTo050PDtpMstOPly/KAboCpwTx5fyLb7znd5VJz4nMdeC4LnVXdv4BOXnWEh3D3Zf/Z
         Pmx+VCoc/7/bRlvtWCtMno/v7N+znhO8w5UWSHGr3QIZN+3xc5c4fRhRdOVWUTjVvRKL
         yRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HgvSkaz2FuWSd/vi2YSVeb+lmMXTx/j35bYriHV9OxE=;
        b=1uAN3F15/AoENvdfYnWGov2iuQT7FvlltT8b1OsKQKge6VCa/HT80XKJkg/86Dtd1G
         Z9ZEGO5XbyB6urONiQ9TaHLCvoumYP+nJEvI1w4kh45jUozbO5CLR6tHibGiZAgxWlpZ
         OI5bjLaoT/9weihAIeGdKc3h2P11rYqeT1JUMKv2HhuYqx/DXhRtLbvfi0vAeI7BRHdv
         6joc8Fkkzo2kU+Sq++AoHRtjxLAgexbueXSSjIMRrIm0RSkuova7Q8nuKCOOjqu/NTsr
         8qOiJMo824n5pFBAN+g0toecVi47gu3EdXH2wprUxbClgU+MfV97wTV4c7QIJ0yo8z3R
         16HQ==
X-Gm-Message-State: AOAM533htBDutXISdfiQ+oNO6pn3nZHMPkCLhfnea9L2PuvB+L8xsMoU
        ZcPdIe5BF5buhWezNhj1Eausnw==
X-Google-Smtp-Source: ABdhPJwBWrGDf51sIDo6aZvJh9cwlaQHAjExAupNYrvwXZv3Z4QCsCyhWlJ0JPDKWElrHm7M6DGxYw==
X-Received: by 2002:a05:6000:1887:b0:20f:e0c4:1eca with SMTP id a7-20020a056000188700b0020fe0c41ecamr33587323wri.465.1653987408247;
        Tue, 31 May 2022 01:56:48 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id t1-20020adfe101000000b0020d110bc39esm11037444wrz.64.2022.05.31.01.56.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 01:56:47 -0700 (PDT)
Message-ID: <1c5f149c-f7d0-e8be-d236-f0089d36ca60@kernel.dk>
Date:   Tue, 31 May 2022 02:56:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
Content-Language: en-US
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000f0b26205e04a183b@google.com>
 <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
 <CACT4Y+ah2r5AVDSyDoz=VA_GO6gtp77JfOqc3RjVzLe3DfRAMw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACT4Y+ah2r5AVDSyDoz=VA_GO6gtp77JfOqc3RjVzLe3DfRAMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/31/22 2:52 AM, Dmitry Vyukov wrote:
> On Tue, 31 May 2022 at 10:45, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/31/22 1:55 AM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
>>> git tree:       linux-next
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>
>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
>>>
>>> ================================================================================
>>> ================================================================================
>>> UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
>>> index 75 is out of range for type 'io_op_def [47]'
>>
>> 'def' is just set here, it's not actually used after 'opcode' has been
>> verified.
> 
> An interesting thing about C is that now the compiler is within its
> rights to actually remove the check that is supposed to validate the
> index because indexing io_op_defs[opcode] implies that opcode is
> already within bounds, otherwise the program already has undefined
> behavior, so removing the check is that case is also OK ;)

I did fix this up as I think it's just a bug waiting to happen anyway.

-- 
Jens Axboe

