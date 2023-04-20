Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B98C6E8761
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 03:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbjDTBV2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 21:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbjDTBV1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 21:21:27 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB5049DB;
        Wed, 19 Apr 2023 18:21:25 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f176a16c03so1773715e9.2;
        Wed, 19 Apr 2023 18:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681953684; x=1684545684;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WUN6XokhMco8R1MkndUTrZgbr76wv2mMBzKNedq/oUA=;
        b=gRLI9Edae0hVH3FpMfbxKcw+TOYp71C846wntDG1BR89i2+nJXifud8U29umJp0wAo
         ynWMnNNEN8VBn5goPhEDls/iVZZQ/LLmZP3CIRbOlzplfeRLADLmUfK9QWE72mRhmUwA
         yCj5WSLneUv3HsJgjRaNnqCBOVWQM6Se1UGNEx3FEMqsf6X0iigpe1r7RCnkG3HYi/eP
         V6WUKRWy+vQw8/scEqIFDo02NsrbAcMa3EWsYT46ycRMosKWiUu1M/u4xx22VX7Gb37T
         9N4jaEQKKprECsLcY46Qb43Z4TgTP6eNQaXDTZdVtCrxgXqkaZ/93uuoMq+TzOCFJGu8
         +wyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681953684; x=1684545684;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WUN6XokhMco8R1MkndUTrZgbr76wv2mMBzKNedq/oUA=;
        b=iVJ9uQbt37DUdrwQ8NvKUpyalGE+l8r3avtUj7IdBJVE+PygVzpguh+nqZhV5VG5hT
         Yy8bKqb0HsxUWAVazzM1Q3t59Jc/FlUJ1dk4Qh2bn3Hpy/ZLOCc+wpQ7afpGzXvSRZQG
         SF8vHfON+MuSPJOou7SgS2Q8h9b9wFFdIvgLQE1/W7/hTwHqfYGps4I9bOAE+1K6a8rn
         hLWWCGJw1SNiP2JtCYha4dK1lB7/RqOfO1CT80LcBopC/fWRzTioIoBm90zbS6dI9sDy
         89azi/YWABmX3X3TRBWaJ1DL1gi5umG39N5DH3OpXwuQS20BV6lQVMBB06V47wL37ova
         rAoQ==
X-Gm-Message-State: AAQBX9eHaB+hcUS60NloRKAFpl/qdoZJKwtgKcEuY3cm4xHDWnGJkPDT
        O9xhM6H9OUq/nYpP6eLvvLbsjCH3zYs=
X-Google-Smtp-Source: AKy350bH2QS1qbMRigFZRbJL3t5b1IVOINWl+BtnAr5FPwGsK2XEB2lll0gSzTZWcxIS4aIdOEV8zA==
X-Received: by 2002:a5d:6a11:0:b0:2cb:2775:6e6 with SMTP id m17-20020a5d6a11000000b002cb277506e6mr6064123wru.45.1681953683700;
        Wed, 19 Apr 2023 18:21:23 -0700 (PDT)
Received: from [192.168.8.100] (188.28.97.56.threembb.co.uk. [188.28.97.56])
        by smtp.gmail.com with ESMTPSA id l7-20020a5d4bc7000000b002fefe2edb72sm532772wrt.17.2023.04.19.18.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 18:21:23 -0700 (PDT)
Message-ID: <91a8f4d6-3518-c0e0-a2c5-f9886d675249@gmail.com>
Date:   Thu, 20 Apr 2023 02:18:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V6 00/17] io_uring/ublk: add generic IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Bernd Schubert <bschubert@ddn.com>, Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Amir Goldstein <amir73il@gmail.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
 <78fe6617-2f5e-3e8e-d853-6dc8ffb5f82c@ddn.com>
 <ZD9JI/JlwrzXQPZ7@ovpn-8-18.pek2.redhat.com>
 <b6188050-1b12-703c-57e8-67fd27adb85c@ddn.com>
 <ZD/ONON4AzwvtlLB@ovpn-8-18.pek2.redhat.com>
 <6ed5c6f4-6abe-3eff-5a36-b1478a830c49@ddn.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6ed5c6f4-6abe-3eff-5a36-b1478a830c49@ddn.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/19/23 16:42, Bernd Schubert wrote:
> On 4/19/23 13:19, Ming Lei wrote:
>> On Wed, Apr 19, 2023 at 09:56:43AM +0000, Bernd Schubert wrote:
>>> On 4/19/23 03:51, Ming Lei wrote:
>>>> On Tue, Apr 18, 2023 at 07:38:03PM +0000, Bernd Schubert wrote:
>>>>> On 3/30/23 13:36, Ming Lei wrote:
>>>>> [...]
>>>>>> V6:
>>>>>> 	- re-design fused command, and make it more generic, moving sharing buffer
>>>>>> 	as one plugin of fused command, so in future we can implement more plugins
>>>>>> 	- document potential other use cases of fused command
>>>>>> 	- drop support for builtin secondary sqe in SQE128, so all secondary
>>>>>> 	  requests has standalone SQE
>>>>>> 	- make fused command as one feature
>>>>>> 	- cleanup & improve naming
>>>>>
>>>>> Hi Ming, et al.,
>>>>>
>>>>> I started to wonder if fused SQE could be extended to combine multiple
>>>>> syscalls, for example open/read/close.  Which would be another solution
>>>>> for the readfile syscall Miklos had proposed some time ago.
>>>>>
>>>>> https://lore.kernel.org/lkml/CAJfpegusi8BjWFzEi05926d4RsEQvPnRW-w7My=ibBHQ8NgCuw@mail.gmail.com/
>>>>>
>>>>> If fused SQEs could be extended, I think it would be quite helpful for
>>>>> many other patterns. Another similar examples would open/write/close,
>>>>> but ideal would be also to allow to have it more complex like
>>>>> "open/write/sync_file_range/close" - open/write/close might be the
>>>>> fastest and could possibly return before sync_file_range. Use case for
>>>>> the latter would be a file server that wants to give notifications to
>>>>> client when pages have been written out.
>>>>
>>>> The above pattern needn't fused command, and it can be done by plain
>>>> SQEs chain, follows the usage:
>>>>
>>>> 1) suppose you get one command from /dev/fuse, then FUSE daemon
>>>> needs to handle the command as open/write/sync/close
>>>> 2) get sqe1, prepare it for open syscall, mark it as IOSQE_IO_LINK;
>>>> 3) get sqe2, prepare it for write syscall, mark it as IOSQE_IO_LINK;
>>>> 4) get sqe3, prepare it for sync file range syscall, mark it as IOSQE_IO_LINK;
>>>> 5) get sqe4, prepare it for close syscall
>>>> 6) io_uring_enter();	//for submit and get events
>>>
>>> Oh, I was not aware that IOSQE_IO_LINK could pass the result of open
>>> down to the others. Hmm, the example I find for open is
>>> io_uring_prep_openat_direct in test_open_fixed(). It probably gets off
>>> topic here, but one needs to have ring prepared with
>>> io_uring_register_files_sparse, then manually manages available indexes
>>> and can then link commands? Interesting!
>>
>> Yeah,  see test/fixed-reuse.c of liburing
>>
>>>
>>>>
>>>> Then all the four OPs are done one by one by io_uring internal
>>>> machinery, and you can choose to get successful CQE for each OP.
>>>>
>>>> Is the above what you want to do?
>>>>
>>>> The fused command proposal is actually for zero copy(but not limited to zc).
>>>
>>> Yeah, I had just thought that IORING_OP_FUSED_CMD could be modified to
>>> support generic passing, as it kind of hands data (buffers) from one sqe
>>> to the other. I.e. instead of buffers it would have passed the fd, but
>>> if this is already possible - no need to make IORING_OP_FUSED_CMD more
>>> complex.man
>>
>> The way of passing FD introduces other cost, read op running into async,
>> and adding it into global table, which introduces runtime cost.
> 
> Hmm, question from my side is why it needs to be in the global table,
> when it could be just passed to the linked or fused sqe?

Because for every such type of state you need to write custom code,
it's not scalable, not to say that it usually can't be kept to a
specific operation and leaks into generic paths / other requests.

Some may want to pass a file or a buffer, there might be a need
to pass a result in some specific way (e.g. nr = recv(); send(nr)),
and the list continues...

I tried adding BPF in the middle ~2y ago, but it was no
different in perf than returning to the userspace, and gets
worse with higher submission batching. Maybe I need to test
it again.

>> That is the reason why fused command is designed in the following way:
>>
>> - link can be avoided, so OPs needn't to be run in async
>> - no need to add buffer into global table
>>
>> Cause it is really in fast io path.
>>
-- 
Pavel Begunkov
