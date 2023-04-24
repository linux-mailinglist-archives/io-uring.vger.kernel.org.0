Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2332E6ED13C
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 17:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbjDXPYg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 11:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjDXPYg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 11:24:36 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3994C19D
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 08:24:35 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id ca18e2360f4ac-760f040ecccso26872539f.1
        for <io-uring@vger.kernel.org>; Mon, 24 Apr 2023 08:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682349874; x=1684941874;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CeThVYcbeB8rCKA4WSHMUOMeX4ixqGjT60Yj8tWuubM=;
        b=r6EQo34La69cqf0ASKDIC6zWQAZrL0tpsuosD63TUEkOSSvsclJhh985A1u6X27rOd
         OmkuKhA33VM3ZoLwmfBZpH4+5KcjXBHEQruXK2VcZfIZ1Gnt6iYPmcvvAZE/Mb5jmrOM
         igL0qO982FZ4EyGPsVJo/iXvBDqd+j+nBxRsPEuhLOk8Vb+3H5eqfWIXqCALkgyRGUpx
         NTjy5jZnxGBgUu2qDl0/O5SPrrRf5VPlUQUT5tSjuDnOdJIfDudwLlPM7fkOTnOxC8OY
         bn3biJFSQg/nggb/GnhcA0l1QajPCahdBfXEiwDAJc3iSwk8ba4kJriugk0E9ZczGJue
         cQtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682349874; x=1684941874;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CeThVYcbeB8rCKA4WSHMUOMeX4ixqGjT60Yj8tWuubM=;
        b=fcORFKVJdXEDMy4zRPt8R0RrHkyukMxC4vB4iejN1/Lt50npVFSHZYjW5AQNBpmnn9
         q9yGQSU6UZvBS/VjMjtcpZVPc6lXOICt+Qm0/ZS/cL5qMA35HApNX63bpRdZTCGZ1Xgd
         6/1F+HuTdYW4pm+Oj7n7yCBGYr5HV0WhPR8pXfwjevD8IGrYhOdso/EewxvIrtXW3mBH
         AD44QB+L5oZpRVjINuwBJpWH1yGZNcBK1+jru7733ovUpl/BqNfnm58jUT8UXXmJOcBq
         xGBUAY+BVq8aJv8s5bHH6hkP3bf2b2PSTrOm1FpEDqF+Ct9PxImUZUYJRjCLiN6IzTdZ
         CdMg==
X-Gm-Message-State: AAQBX9fvNeHsE6VoZkx8lI7dBhkWP5x8F3+85v3E5n5DQMpChO6oQURw
        +Pc+fMAqD3myhX1gHOkdWI/q3ey00GA5Hu+Xink=
X-Google-Smtp-Source: AKy350b18PmnwMyWwcyirL8acsTC9wREbJvL/BQgns3JnK9MW1pkfBGuLiPK+oWd54vZmRv+Jo8OJQ==
X-Received: by 2002:a05:6602:358c:b0:760:ede8:5371 with SMTP id bi12-20020a056602358c00b00760ede85371mr7575493iob.0.1682349874532;
        Mon, 24 Apr 2023 08:24:34 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cz22-20020a0566384a1600b0040fa620e220sm3297634jab.86.2023.04.24.08.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 08:24:34 -0700 (PDT)
Message-ID: <b5e48439-0427-98a8-3288-99426ae36b45@kernel.dk>
Date:   Mon, 24 Apr 2023 09:24:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4/4] io_uring: mark opcodes that always need io-wq punt
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230420183135.119618-1-axboe@kernel.dk>
 <20230420183135.119618-5-axboe@kernel.dk>
 <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEYwAkk7aXKfQKKr@ovpn-8-16.pek2.redhat.com>
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

On 4/24/23 1:30?AM, Ming Lei wrote:
> On Thu, Apr 20, 2023 at 12:31:35PM -0600, Jens Axboe wrote:
>> Add an opdef bit for them, and set it for the opcodes where we always
>> need io-wq punt. With that done, exclude them from the file_can_poll()
>> check in terms of whether or not we need to punt them if any of the
>> NO_OFFLOAD flags are set.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c |  2 +-
>>  io_uring/opdef.c    | 22 ++++++++++++++++++++--
>>  io_uring/opdef.h    |  2 ++
>>  3 files changed, 23 insertions(+), 3 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index fee3e461e149..420cfd35ebc6 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -1948,7 +1948,7 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
>>  		return -EBADF;
>>  
>>  	if (issue_flags & IO_URING_F_NO_OFFLOAD &&
>> -	    (!req->file || !file_can_poll(req->file)))
>> +	    (!req->file || !file_can_poll(req->file) || def->always_iowq))
>>  		issue_flags &= ~IO_URING_F_NONBLOCK;
> 
> I guess the check should be !def->always_iowq?

How so? Nobody that takes pollable files should/is setting
->always_iowq. If we can poll the file, we should not force inline
submission. Basically the ones setting ->always_iowq always do -EAGAIN
returns if nonblock == true.

-- 
Jens Axboe

