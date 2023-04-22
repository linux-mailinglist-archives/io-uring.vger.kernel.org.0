Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1F46EB6BF
	for <lists+io-uring@lfdr.de>; Sat, 22 Apr 2023 04:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjDVCNu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Apr 2023 22:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjDVCNt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Apr 2023 22:13:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F6F1FFD
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 19:13:48 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-63f167e4be1so391861b3a.1
        for <io-uring@vger.kernel.org>; Fri, 21 Apr 2023 19:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682129628; x=1684721628;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PYtFCmZv2O4roT2wxMg0u8pCdTWXFIQFlx7TWJwEdK4=;
        b=uxyFPyl/UzLCc2iIYAtE3+I3v8O9noMN0qpCimkPhAfL45OVZvDTpAJl0vZr9m/3gh
         Gg0IdcQsdwIYE9V1zngypPqNHXXRUhp92+f6OIobt8t6UnjVxknjFbjvSFUidk2COyq1
         cJCWJNenZd1tWB0APmhqReEiD3N7433FVuePU8yh5ETwWAqAJw7L+r451ODSd3poUkPa
         g1RpYg9un8dJV4xTT1LYjvwOXkLgQpzBWoQislsbiHKuOm5wM2QqbzSAUgSKmRj9gd3/
         fsJq1Vpl2RPMUaRA2blzQfKDQliS+fceJdXq5WsvUTlno04cDn45rGkWlJXOP9S532HV
         3nfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682129628; x=1684721628;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYtFCmZv2O4roT2wxMg0u8pCdTWXFIQFlx7TWJwEdK4=;
        b=jMXWYWS+iJIeX23eoMgwvvkJ7zrMkwUyuBzQMp5jXbALdxeTwrE5sA3Is/deZlEVy9
         L3z4kPwirf201sro8VlLBmWLHRYRS3zpGWsHh5s73YzM8vcCTh04gap6hdTjkcJUdYue
         APquBqrRQpxJKB+uKr/hfwveclDCg+RbVJUvDT0kR6UnSC06+2780nzNr2qUqinz8ouB
         L7LHjBE/XFbhRO2M5GEJ+q4ceVT+KoVtuBjJzppbtub56eg3Q9h7+O47NriQj3856E+T
         UpQIEyZzfjQDrClAh9tFWx3ZEaZHb3WWHEBEJmV3WJY/gRP8anLjfdM47RqJtJ9XO3ZQ
         zHLw==
X-Gm-Message-State: AAQBX9fBbMPFOOcYvZ8987KmEpkjjGHX1GIkK4PnLCyHtOn89iJOV0H5
        wf8hX9OuZDSD33S7k50sWYyGzjS7LhYwAspQMjo=
X-Google-Smtp-Source: AKy350Yr1uRNK2wgaH9SSUn1c9sMVubiNjGMGTkui+2fOeya6I5c4kI3479udRlcAnCSiYQSiawA4g==
X-Received: by 2002:a05:6a00:1496:b0:63a:fb57:63c5 with SMTP id v22-20020a056a00149600b0063afb5763c5mr7409613pfu.3.1682129627519;
        Fri, 21 Apr 2023 19:13:47 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c11-20020a056a00248b00b00634a96493f7sm3575703pfv.128.2023.04.21.19.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 19:13:47 -0700 (PDT)
Message-ID: <749cda6f-9e64-f89b-9d1d-e1943d7b339a@kernel.dk>
Date:   Fri, 21 Apr 2023 20:13:46 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: SQPOLL / uring_cmd_iopoll
Content-Language: en-US
To:     Bernd Schubert <bschubert@ddn.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Ming Lei <ming.lei@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cbfa6c3f-11bd-84f7-bdb0-4342f8fd38f3@ddn.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/21/23 4:09?PM, Bernd Schubert wrote:
> Hello,
> 
> I was wondering if I could set up SQPOLL for fuse/IORING_OP_URING_CMD 
> and what would be the latency win. Now I get a bit confused what the 
> f_op->uring_cmd_iopoll() function is supposed to do.

Certainly, you can use SQPOLL with anything. Whether or not it'd be a
win depends a lot on what you're doing, rate of IO, etc.

IOPOLL and SQPOLL are two different things. SQPOLL has a kernel side
submission thread that polls for new SQ entries and submits them when it
sees them. IOPOLL is a method for avoiding sleeping on waiting on CQ
entries, where it will instead poll the target for completion instead.
That's where ->uring_cmd_iopoll() comes in, that's the hook for polling
for uring commands. For normal fs path read/write requests,
->uring_iopoll() is the hook that performs the same kind of action.

> Is it just there to check if SQEs are can be completed as CQE? In rw.c 

Not sure I follow what you're trying to convey here, maybe you can
expand on that? And maybe some of the confusion here is because of
mixing up SQPOLL and IOPOLL?

> io_do_iopoll() it looks like this. I don't follow all code paths in 
> __io_sq_thread yet, but it looks a like it already checks if the ring 
> has new entries
> 
> to_submit = io_sqring_entries(ctx);
> ...
> ret = io_submit_sqes(ctx, to_submit);
> 
>    --> it will eventually call into ->uring_cmd() ?

The SQPOLL thread will pull off new SQEs, and those will then at some
point hit ->issue() which is an opcode dependent method for issuing the
actual request. Once it's been issued, if the ring is IOPOLL, then
io_iopoll_req_issued() will get called which adds the request to an
internal poll list. When someone does io_uring_enter(2) to wait for
events on a ring with IOPOLL, it will iterate that list and call
->uring_cmd_iopoll() for uring_cmd requests, and ->uring_iopoll() for
"normal" requests.

If the ring is using SQPOLL|IOPOLL, then the SQPOLL thread is also the
one that does the polling. See __io_sq_thread() -> io_do_iopoll().

> And then io_do_iopoll ->  file->f_op->uring_cmd_iopoll is supposed to 
> check for available cq entries and will submit these? I.e. I just return 
> 1 if when the request is ready? And also ensure that 
> req->iopoll_completed is set?

The callback polls for a completion on the target side, which will mark
is as ->iopoll_completed = true. That still leaves them on the iopoll
list, and io_do_iopoll() will spot that and post CQEs for them.

> I'm also not sure what I should do with struct io_comp_batch * - I don't 
> have struct request *req_list anywhere in my fuse-uring changes, seems 
> to be blk-mq specific? So I should just ignore that parameter?

Hard to say since the above is a bit confusing and I haven't seen your
code, but you can always start off just passing NULL. That's fine and
just doesn't do any completion batching. The latter may or may not be
useful for your case, but in any case, it's fine to pass NULL.

> Btw, this might be useful for ublk as well?

Not sure what "this" is :-)

-- 
Jens Axboe

