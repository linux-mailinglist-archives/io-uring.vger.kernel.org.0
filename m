Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAAA3539B84
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 05:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349275AbiFADQF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 May 2022 23:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbiFADQC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 23:16:02 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE94991594
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 20:16:00 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id d26so451311wrb.13
        for <io-uring@vger.kernel.org>; Tue, 31 May 2022 20:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XrsyQG46hfKFpC/n788dnmSF1KyRFNfE0olCI8xti3o=;
        b=Z8C8H3Bcb4sw+hLnFm6ELYF7JkRtcmHt94DEDN9dw/uoIgceQeex8GVkcxd/4b8Jr0
         ZBlku+irMR14iNI4YO1P/E0Mw2/KX0ckK6Lf5w7U6QAG93USFKlNKX6g9LOnhVgAeCGd
         cmpw0kGdcUh0zptQ/Bt1Lxxj1M//ah60M1kUrRDe52J428k3Y06m6zKcYlJExYsEuwCc
         I/4Ib6mvkU4psj4mKfBpDsb85NaTdJb8LlJO8clLZZAWHyi3/gSSv+PfI9k8ssXhQYf0
         3HJgPtPawFixAjMDjj7/GLWtnhrmsfZMJv4Qx7rSxZmiyhzrUnS3KHGlE3XdW5/ZQG21
         nlmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XrsyQG46hfKFpC/n788dnmSF1KyRFNfE0olCI8xti3o=;
        b=y/yJd9bTot7JPmEGkE+qDlEvFabdvpdPcUO68Lpvn9+Xri534qlilTybftY/gc7+NN
         x79JgcE/p69y6Sf3kj9/bhbRjpWqSCv7mnThmfNCLdVjqGHqY89YHvK2ySX8LXCV9a4K
         73lJI28Qar9L1hJvXgY/dMTDSUirgFCgcyNLF7mk3wr6A1R9R0gDry4ufLyjuWx9fR4P
         I8E9T/jAewGtvvku2aY8753sC2U6mNKNGE+mitFHsFfKtmYdf8tp2TLEvJ1zMSWNLmjg
         ZL+SxgWYP5ktoibwYgDzY0Kq76ykEQDjaa21eNobOtp+oldw+9giEncCl6XA9ATZ3+bD
         OIWw==
X-Gm-Message-State: AOAM532CEA0PlmcpMaCwkqM6uyJT/nOwxx/eBZ3PsaZUMLweR3ZH2MN0
        6RomOiZ5b32Fo82I6gLcBZXccg==
X-Google-Smtp-Source: ABdhPJzVqSzsO85fNJucH4i22uc4bYFUP8VAEP9et8+fEFwPeeaTZAcOP4+UZPL5mR4op3rPe3foYg==
X-Received: by 2002:a5d:64e6:0:b0:20f:a608:9af9 with SMTP id g6-20020a5d64e6000000b0020fa6089af9mr48500273wri.171.1654053359412;
        Tue, 31 May 2022 20:15:59 -0700 (PDT)
Received: from [10.188.163.71] (cust-east-parth2-46-193-73-98.wb.wifirst.net. [46.193.73.98])
        by smtp.gmail.com with ESMTPSA id k27-20020a05600c1c9b00b0039750c39fc5sm4588644wms.3.2022.05.31.20.15.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 May 2022 20:15:58 -0700 (PDT)
Message-ID: <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
Date:   Tue, 31 May 2022 21:15:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [RFC] coredump: Do not interrupt dump for TIF_NOTIFY_SIGNAL
Content-Language: en-US
To:     Olivier Langlois <olivier@trillion01.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
 <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
 <87h7i694ij.fsf_-_@disp2133> <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
 <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
 <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
 <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
 <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
 <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
 <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
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

On 5/31/22 2:06 PM, Olivier Langlois wrote:
> On Mon, 2022-03-14 at 18:58 -0500, Eric W. Biederman wrote:
>>
>> Thank you very much for this.  There were some bugs elsewhere I had
>> to
>> deal with so I am slower looking at this part of the code than I was
>> expecting.
>>
>> I have now reproduced this with the commit reverted on current
>> kernels
>> and the repro.c from the syzcaller report.  I am starting to look
>> into
>> how this interacts with my planned code changes in this area.
>>
>> In combination with my other planned changes I think all that needs
>> to
>> happen in do_coredump is to clear TIF_NOTIFY_SIGNAL along with
>> TIF_SIGPENDING to prevent io_uring interaction problems.  But we will
>> see.
>>
>> The deadlock you demonstrate here shows that it is definitely not
>> enough
>> to clear TIF_NOTIFY_SIGNAL (without other changes) so that
>> signal_pending returns false, which I was hoping was be the case.
>>
>> Eric
> 
> I have been away for some time but if this is not resoved yet, I just
> want to remind that clearing TIF_NOTIFY_SIGNAL along with
> TIF_SIGPENDING won't do it because io_uring may set them asynchronously
> to report some io completion while do_coredump() is executing.
> 
> IMHO, just calling io_uring_task_cancel() from do_coredump() before
> actually writing the dump, while maybe not the perfect solution, is the
> simplest one.
> 
> Otherwise, maybe masking interrupts locally could work but I wouldn't
> dare to explore this option personally...

Eric, are you fine with doing the cancelation based patch for now? IMHO
it's not the ideal approach, but it will resolve the issue. And it'd
honestly be great to get some closure on this so we don't have truncated
core dumps if they are interrupted by task_work.

The best solution would be to make the core dumps resilient to
task_work, but a workable solution would be nice at this point...

-- 
Jens Axboe

