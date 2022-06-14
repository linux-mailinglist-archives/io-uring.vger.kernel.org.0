Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BCE54B892
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 20:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238534AbiFNS0n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 14:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237013AbiFNS0n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 14:26:43 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051F72D1F3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:26:42 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w21so9344243pfc.0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 11:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=UOw00K6/gw7jR7FfdMb+Bo3WSshPOh0PKwF1ptA8pKk=;
        b=KxCjGyv1oYulToYIhBPaNsqfg1L1zPsgEZ3wDvZx0nJWPUQqQ3r3YqDIkkIVXjlW0P
         aYEZQCMtSjol7ju18kbs7Vsrxry6ZTjflH/5frCfAl7AG/tXUvxsiPg5YUJ7HYuLSlik
         bFam1Y4aALs4hK26XvBg6EjIB0fPCk70dQlNR3uplnzSChR9t4/CvHS/vUSOOp5CQKz9
         Ad44h9NDN+FVfwHk4Pevs1gVDyUFeeQWOpYNvlPgxcWxsuOpL80MTHoExx0zilTWcc6P
         gWhrZZMKAqiq4bdVNgz5Qe0MJfbbsS8wip+gxYAc06D+RXGXjCyAiva5UiSpg1QnVcwH
         Pm1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UOw00K6/gw7jR7FfdMb+Bo3WSshPOh0PKwF1ptA8pKk=;
        b=HpiIh1AJaHE9l/fJiwlZZzPqPy7kGo9XQObuw5YTR4FgeR2TtGrQVCeaYd40HZC3Kc
         UmLd0UqoRS7qoVRw2hGB3+MVwQ7WenJdxGXCDCBjWIe/6gS1OKKikQeRYyLBcldwEW7e
         Ldw5SWXJiLrZk5lSD7GBvsV3UpYN3Nvn9/QaqCMY05moc4ssPPqTDmNqbJUI7b4fGMh6
         rp7JAbrr/gCINoYO69By7L3obBHpYQCw/ER/ov1uVg1OJAj8ZlCpVYNjK5rbVcbf9Qfy
         kvZqVnrfhrtNYM6v0E/ogiURhUuzIimffoWmFbTXluAXWRw7T99LaapZjbbQ7CSq5zht
         S80A==
X-Gm-Message-State: AOAM531o20Fu5SWb8r2lYFVy19VxUI/eIfU/ZDzmtQcHuYzMF/sRzwDx
        ST1W5Ets9Lhczflv01n+enPXWw==
X-Google-Smtp-Source: ABdhPJwVOhOxmG0LHQOxmopTfpbR4d6Fm5CFs4bC6RY+6ort5uff0QLo/WtFtgRjHvwDUMfChCI11g==
X-Received: by 2002:a63:e45:0:b0:401:9f3e:9a6c with SMTP id 5-20020a630e45000000b004019f3e9a6cmr5402432pgo.395.1655231201354;
        Tue, 14 Jun 2022 11:26:41 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id fy2-20020a17090b020200b001e880972840sm9806052pjb.29.2022.06.14.11.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 11:26:40 -0700 (PDT)
Message-ID: <417f842f-0204-0f16-4355-edf7cc75dcaa@kernel.dk>
Date:   Tue, 14 Jun 2022 12:26:39 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 5.19 2/3] Revert "io_uring: add buffer selection support
 to IORING_OP_NOP"
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <cover.1655224415.git.asml.silence@gmail.com>
 <c5012098ca6b51dfbdcb190f8c4e3c0bf1c965dc.1655224415.git.asml.silence@gmail.com>
 <477e92153bbfa3620c801dd58e8625281988ef49.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <477e92153bbfa3620c801dd58e8625281988ef49.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/22 12:21 PM, Dylan Yudaken wrote:
> On Tue, 2022-06-14 at 17:51 +0100, Pavel Begunkov wrote:
>> This reverts commit 3d200242a6c968af321913b635fc4014b238cba4.
>>
>> Buffer selection with nops was used for debugging and benchmarking
>> but
>> is useless in real life. Let's revert it before it's released.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 15 +--------------
>>  1 file changed, 1 insertion(+), 14 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index bf556f77d4ab..1b95c6750a81 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1114,7 +1114,6 @@ static const struct io_op_def io_op_defs[] = {
>>         [IORING_OP_NOP] = {
>>                 .audit_skip             = 1,
>>                 .iopoll                 = 1,
>> -               .buffer_select          = 1,
>>         },
>>         [IORING_OP_READV] = {
>>                 .needs_file             = 1,
>> @@ -5269,19 +5268,7 @@ static int io_nop_prep(struct io_kiocb *req,
>> const struct io_uring_sqe *sqe)
>>   */
>>  static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
>>  {
>> -       unsigned int cflags;
>> -       void __user *buf;
>> -
>> -       if (req->flags & REQ_F_BUFFER_SELECT) {
>> -               size_t len = 1;
>> -
>> -               buf = io_buffer_select(req, &len, issue_flags);
>> -               if (!buf)
>> -                       return -ENOBUFS;
>> -       }
>> -
>> -       cflags = io_put_kbuf(req, issue_flags);
>> -       __io_req_complete(req, issue_flags, 0, cflags);
>> +       __io_req_complete(req, issue_flags, 0, 0);
>>         return 0;
>>  }
>>  
> 
> The liburing test case I added in "buf-ring: add tests that cycle
> through the provided buffer ring" relies on this.

Good point.

> I don't mind either way if this is kept or that liburing patch is
> reverted, but it should be consistent. What do you think?

It was useful for benchmarking as well, but it'd be a trivial patch to
do for targeted testing.

I'm fine with killing it, but can also be persuaded not to ;-)

-- 
Jens Axboe

