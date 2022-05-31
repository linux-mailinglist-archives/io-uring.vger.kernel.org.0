Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096FB538D5F
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 11:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245045AbiEaJBw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 05:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245044AbiEaJBu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 05:01:50 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55271D311
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:01:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id e25so7101366wra.11
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ivvYO1sUstCciiWZkswLsyBmaMq3bC7gj08oOv0TolI=;
        b=0O91Vxj1nMXvo9qMNyldMMQ1Ib34fxg70N9h08o/c7hadC8XvZJvsddzYl+C67weBv
         VO+un8Uzc1BCHF+0uIkJ0p/vnx1PDoE35JEVAmCn/BzMq8+nVXiJD3Jbctbbbfc0Q44c
         zKaNoy9cOyjGWnksSd8UD4J1mXeYfOpHE/n0r0DoJynLRM5qKJ/66I1rzGZfkZezSgZT
         ReWtlOaMGKnwAobrfOvjBEZ7NuJ7ohgmvRCcUiy4RmEocdtNqTo2Q5Wa1C941SEn2sqk
         he7/AKxDo7dNKbX9JhbzfT+EPeIiVb9Sz43yoJqjYaB2Y/QRBmwxcGMJrbUbACQM+v7l
         sOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ivvYO1sUstCciiWZkswLsyBmaMq3bC7gj08oOv0TolI=;
        b=K0DISVgyVlzPHS3fRSjJYL8eKg/8v9i3DkZkklobzojMbfrCY5XMcwzxywQ9vb6xqw
         0q+GsjvoE58Kk9+lPMlePQ22wfi+O+PtIW7vtahy9X8+mrtIQirT5OOqc1qsWsV3hajH
         GURiK1fUJsjuAFaQ2KO2pptSL1k1IjMKBME/MuBrj2YZl2UkzNeqxWIF2YXcfIaCiNp2
         GCSABmhfbjAmMWaJi42/fM69Zu38YevG6E1aOZ352Lh4pY3n8uP66XMDHBMUWWI/J0pV
         GfFT2FxEn7b3XY8BC++cKGJbn60V63X160VTzTRx6QA9L5uiHiXnw4Iqhhq5KmHqM8Vo
         3dmg==
X-Gm-Message-State: AOAM533BKX50NvAeCkY7aN3uW8YW547eXXEtF9i07HRx6Ve6bJWrxz7I
        cGOR+CwzGjIP6pUCStWP1T2oeQ==
X-Google-Smtp-Source: ABdhPJwaqyC8uFjcpmNY+2eZkiV29AUkxDcUS4UUo7hRE0u0owQNPd+bQWfr8K7AarJMrn6kVm8l0Q==
X-Received: by 2002:a5d:4344:0:b0:20c:9156:8ec with SMTP id u4-20020a5d4344000000b0020c915608ecmr50065204wrr.71.1653987706038;
        Tue, 31 May 2022 02:01:46 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id o20-20020a05600c379400b0039c18d3fe27sm1533956wmr.19.2022.05.31.02.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:01:45 -0700 (PDT)
Message-ID: <bcac089a-36e5-0d85-1ec3-b683dac68b4f@kernel.dk>
Date:   Tue, 31 May 2022 03:01:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [syzbot] UBSAN: array-index-out-of-bounds in io_submit_sqes
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>,
        syzbot <syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com>,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
References: <000000000000f0b26205e04a183b@google.com>
 <3d3c6b5f-84cd-cb25-812e-dac77e02ddbf@kernel.dk>
 <e0867860-12c6-e958-07de-cfbcf644b9fe@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e0867860-12c6-e958-07de-cfbcf644b9fe@icloud.com>
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

On 5/31/22 3:00 AM, Hao Xu wrote:
> On 5/31/22 16:45, Jens Axboe wrote:
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
>>
> 
> Maybe we can move it to be below the opcode check to comfort UBSAN.

Yeah that's what I did, just rebased it to get rid of it:

https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=fcde59feb1affb6d56aecadc3868df4631480da5

-- 
Jens Axboe

