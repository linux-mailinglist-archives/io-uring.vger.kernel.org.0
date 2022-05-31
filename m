Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57C3538E0B
	for <lists+io-uring@lfdr.de>; Tue, 31 May 2022 11:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242065AbiEaJxX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 05:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbiEaJxU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 05:53:20 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B2BF65
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:53:18 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id n124-20020a1c2782000000b003972dfca96cso874074wmn.4
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 02:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4rKprNNec0+8a+HzIgH8CQphH+rVeuEGy0qnazrjUTg=;
        b=3Seb/Sz+CcptZDi7CfLb3KgZbKncX0COAHsXhzL6CjsKPWirp71M6Djsn1k5YpLrUG
         VQmKsc7E3EDMcXZEvGY91Q6SictNYrMkxRuIXbyAp1RpudQjeex0/Ieta/SlDbjdVz8J
         SXJMcYiQ6TLjKCNjKMlVSvDXlauq5dZv8FqIKd0MG59IvzGlk5PNPq0raHqwjXYDRavn
         oBYFg14YHtKehznVGuxqRwVAC7AfYV5pnZaCclLqUynw/UBRGBmgd80N1DF4Ec2f07aF
         fxzEaWglThg0celts2sOV2kSSy1+pMH38+LXiHUdZ8lGjwa1EsuOuRLGlARu4mVETmb5
         NdDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4rKprNNec0+8a+HzIgH8CQphH+rVeuEGy0qnazrjUTg=;
        b=vszyQNTPgQLjtucz62W9BXGzANHCbUdhqO0+ZevnIf/mJxFbTTV8/Z7k7AaOHwec8S
         dAgaol2CBDuSfJjsw33BEO0kz8YGixX5uNxJsjdE8xu+4IQCWMJywiwH0MK3XUlfJ/BE
         XpFZP4kg4neIkmTo8Qnc0amS+Urrcz+eDbEIDxDk/k3M8/LllRrtnQlqzbfbyfzuoVgA
         Px7MCuE7xblzTVRrS4BZCgirUgU/DRVGpZ92LAMsXm/kj+RCGLMy+mFk59Za9VIBflyW
         MURlazM/jijEQC6PTMy4gogESUWpRQjBMP7JB83CDCicnRFQNm/49xPdCRi5vQTPx2oK
         0ewQ==
X-Gm-Message-State: AOAM5331eV0mNhOwrQj7bQ4bopHbTCHvCiYyIE6wdavVmK0SojUL12BE
        M5bgF8K5He45AJ213YNLWbA/Xg==
X-Google-Smtp-Source: ABdhPJz4iKVZtuI6VdmVfTbaq3GSasW7F19Y+f9LGbY0oSiZSm87O7p9bz2yRLBqIKan1k/zSSDqmg==
X-Received: by 2002:a05:600c:4f0c:b0:397:6a3a:d3f9 with SMTP id l12-20020a05600c4f0c00b003976a3ad3f9mr22904723wmq.103.1653990796546;
        Tue, 31 May 2022 02:53:16 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id c18-20020a5d5292000000b0020ff3a2a925sm13236509wrv.63.2022.05.31.02.53.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 02:53:15 -0700 (PDT)
Message-ID: <7b07cce6-b8a8-7f0b-f4ab-285a9369ef0a@kernel.dk>
Date:   Tue, 31 May 2022 03:53:14 -0600
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
 <7c582099-0eef-6689-203a-606cb2f69391@kernel.dk>
 <CACT4Y+bEKD7fREyiTst2oA7rjTz3u3LWLe23QmSBAQ=Piir3Ww@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CACT4Y+bEKD7fREyiTst2oA7rjTz3u3LWLe23QmSBAQ=Piir3Ww@mail.gmail.com>
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

On 5/31/22 3:14 AM, Dmitry Vyukov wrote:
> On Tue, 31 May 2022 at 11:07, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 5/31/22 3:05 AM, Dmitry Vyukov wrote:
>>> On Tue, 31 May 2022 at 11:01, Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 5/31/22 3:00 AM, Hao Xu wrote:
>>>>> On 5/31/22 16:45, Jens Axboe wrote:
>>>>>> On 5/31/22 1:55 AM, syzbot wrote:
>>>>>>> Hello,
>>>>>>>
>>>>>>> syzbot found the following issue on:
>>>>>>>
>>>>>>> HEAD commit:    3b46e4e44180 Add linux-next specific files for 20220531
>>>>>>> git tree:       linux-next
>>>>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=16e151f5f00000
>>>>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=ccb8d66fc9489ef
>>>>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=b6c9b65b6753d333d833
>>>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>>>>>>>
>>>>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>>>>>
>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>> Reported-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
>>>>>>>
>>>>>>> ================================================================================
>>>>>>> ================================================================================
>>>>>>> UBSAN: array-index-out-of-bounds in fs/io_uring.c:8860:19
>>>>>>> index 75 is out of range for type 'io_op_def [47]'
>>>>>>
>>>>>> 'def' is just set here, it's not actually used after 'opcode' has been
>>>>>> verified.
>>>>>>
>>>>>
>>>>> Maybe we can move it to be below the opcode check to comfort UBSAN.
>>>>
>>>> Yeah that's what I did, just rebased it to get rid of it:
>>>>
>>>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.19&id=fcde59feb1affb6d56aecadc3868df4631480da5
>>>
>>> If you are rebasing it, please add the following tag so that the bug
>>> is closed later:
>>>
>>> Tested-by: syzbot+b6c9b65b6753d333d833@syzkaller.appspotmail.com
>>
>> Sorry, missed that, would be a bit confusing?
> 
> Why confusing? It tested it, no?

Usually I'd use that tag if it's a separate commit that fixes an issue,
and someone (or a bot) has tested it. I think we both agree that the
change will fix it, but not really tested at that point. Or maybe it is
now :)

> 
>> 5.20 branch is rebased
>> on top of that too. Can we just do:
>>
>> #syz fix: io_uring: add io_op_defs 'def' pointer in req init and issue
>>
>> ?
> 
> In most cases it will work. However, there is no way to distinguish
> unfixed and fixed versions of the patch based on the title.
> So if the unfixed version manages to reach all syzbot builds, it will
> close the bug at that point. And then can start reporting duplicates
> since the bug is still present. But practically unlikely to happen.
> The tag allows to distinguish unfixed and fixed versions of the patch,
> so it will work reliably w/o possible duplicates.

Gotcha. Usually I don't rebase anyway, but easier in this case.

-- 
Jens Axboe

