Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BCD450E31B
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbiDYOcV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbiDYOcU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:32:20 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE2734BB2
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:29:16 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id r17so9432024iln.9
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IKk6n1gYMLxlBGA44G1P2h8tTbb9OL7WUqSJZxOLr/A=;
        b=gvwaVBUP7YiAwkYS46h791OXGZXp1Rgh7O6zwkmwdAVYu3lDfXPDO3mImVNXNQ07og
         8tJy2MBPRH7fhckuNGbu6w/GX8+CbCuRrl4G3yN0W8cqATYspDv/4MACxj9LB92FgHyC
         4nKxIbFVlJi8sS3NNRbIZlQuE3g3j0UFvSycUhoWf4pYPt9tZ2GobfQ7/5ZwWmeUT3CO
         cSxdhOQ9bmgskqkXWrnoQjq0DYVi+3/LXQExh9EeJPUgP/c74U4+e5Cj7lHJth3WsGQ0
         4OgXc1iwQYipQpgUxeodGGQoviGUYSTBQCCAaEaoWYezdPxIOdTGHTXf7sJMRU/zMtaE
         Y30A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IKk6n1gYMLxlBGA44G1P2h8tTbb9OL7WUqSJZxOLr/A=;
        b=Vj+9zkp5jx4Oagt7e6YSOlg6uLxBIcm8kvwFk07tTqq01pChiOEFKprb2uW3/LWb95
         EtT/vtiL9k1A7dYL+jyexyhtUv5rBeBTLa82I+mqZhMYPI9ReuDiuikwcJll+JyppBHi
         PN7CDRMsla5mTuEYdJBD4aByZFU4C/TAu7ZyZGrM4P1k9Q3+77OYmQ3C/FHAr7mLhnVe
         TmT3L1/ldUKKUFIKpBQoJFfxXlUAZrFcCmW5K1GyGuR1eSb/FlfPs226qkM2ESu8GNUF
         nWzIk11kZytD3WnMzlk+lY5m48ntyGVkxPAqQS25TATU7xSakLhMDSS1l0jS6BaORCU4
         A9Ag==
X-Gm-Message-State: AOAM532mKbvPBhWOA1Pjn3uvTlthV+rgEV1b+sCb3ppdd/ZxdaqKQ/t8
        66aUzeGfiFku+IK7nGdWmkbmuw==
X-Google-Smtp-Source: ABdhPJxofRdQndL5yh+psnkfGJUgH5AldxQhI506IOErpwI+e+pG4aG+yqqgksVh3+iuGpr/G8VqHg==
X-Received: by 2002:a92:c54b:0:b0:2cc:3de1:ae5b with SMTP id a11-20020a92c54b000000b002cc3de1ae5bmr6774945ilj.288.1650896956190;
        Mon, 25 Apr 2022 07:29:16 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e17-20020a056602045100b006538224d4ccsm7467292iov.25.2022.04.25.07.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 07:29:15 -0700 (PDT)
Message-ID: <09b305e7-ff07-ee4e-8603-fddf7931e0a8@kernel.dk>
Date:   Mon, 25 Apr 2022 08:29:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/3] io_uring: add io_uring_get_opcode
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>
References: <20220425093613.669493-1-dylany@fb.com>
 <20220425093613.669493-2-dylany@fb.com>
 <5e09c3ea-8d72-5984-8c9e-9eec14567393@kernel.dk>
 <911a8804fbaa3a564214971e9a3e5b19ddd227db.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <911a8804fbaa3a564214971e9a3e5b19ddd227db.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/25/22 7:21 AM, Dylan Yudaken wrote:
> On Mon, 2022-04-25 at 06:38 -0600, Jens Axboe wrote:
>> On 4/25/22 3:36 AM, Dylan Yudaken wrote:
>>> In some debug scenarios it is useful to have the text representation
>>> of
>>> the opcode. Add this function in preparation.
>>>
>>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>>> ---
>>>  fs/io_uring.c            | 91
>>> ++++++++++++++++++++++++++++++++++++++++
>>>  include/linux/io_uring.h |  5 +++
>>>  2 files changed, 96 insertions(+)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index e57d47a23682..326695f74b93 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1255,6 +1255,97 @@ static struct kmem_cache *req_cachep;
>>>  
>>>  static const struct file_operations io_uring_fops;
>>>  
>>> +const char *io_uring_get_opcode(u8 opcode)
>>> +{
>>> +       switch (opcode) {
>>> +       case IORING_OP_NOP:
>>> +               return "NOP";
>>> +       case IORING_OP_READV:
>>> +               return "READV";
>>> +       case IORING_OP_WRITEV:
>>> +               return "WRITEV";
>>> +       case IORING_OP_FSYNC:
>>> +               return "FSYNC";
>>> +       case IORING_OP_READ_FIXED:
>>> +               return "READ_FIXED";
>>> +       case IORING_OP_WRITE_FIXED:
>>> +               return "WRITE_FIXED";
>>> +       case IORING_OP_POLL_ADD:
>>> +               return "POLL_ADD";
>>> +       case IORING_OP_POLL_REMOVE:
>>> +               return "POLL_REMOVE";
>>> +       case IORING_OP_SYNC_FILE_RANGE:
>>> +               return "SYNC_FILE_RANGE";
>>> +       case IORING_OP_SENDMSG:
>>> +               return "SENDMSG";
>>> +       case IORING_OP_RECVMSG:
>>> +               return "RECVMSG";
>>> +       case IORING_OP_TIMEOUT:
>>> +               return "TIMEOUT";
>>> +       case IORING_OP_TIMEOUT_REMOVE:
>>> +               return "TIMEOUT_REMOVE";
>>> +       case IORING_OP_ACCEPT:
>>> +               return "ACCEPT";
>>> +       case IORING_OP_ASYNC_CANCEL:
>>> +               return "ASYNC_CANCEL";
>>> +       case IORING_OP_LINK_TIMEOUT:
>>> +               return "LINK_TIMEOUT";
>>> +       case IORING_OP_CONNECT:
>>> +               return "CONNECT";
>>> +       case IORING_OP_FALLOCATE:
>>> +               return "FALLOCATE";
>>> +       case IORING_OP_OPENAT:
>>> +               return "OPENAT";
>>> +       case IORING_OP_CLOSE:
>>> +               return "CLOSE";
>>> +       case IORING_OP_FILES_UPDATE:
>>> +               return "FILES_UPDATE";
>>> +       case IORING_OP_STATX:
>>> +               return "STATX";
>>> +       case IORING_OP_READ:
>>> +               return "READ";
>>> +       case IORING_OP_WRITE:
>>> +               return "WRITE";
>>> +       case IORING_OP_FADVISE:
>>> +               return "FADVISE";
>>> +       case IORING_OP_MADVISE:
>>> +               return "MADVISE";
>>> +       case IORING_OP_SEND:
>>> +               return "SEND";
>>> +       case IORING_OP_RECV:
>>> +               return "RECV";
>>> +       case IORING_OP_OPENAT2:
>>> +               return "OPENAT2";
>>> +       case IORING_OP_EPOLL_CTL:
>>> +               return "EPOLL_CTL";
>>> +       case IORING_OP_SPLICE:
>>> +               return "SPLICE";
>>> +       case IORING_OP_PROVIDE_BUFFERS:
>>> +               return "PROVIDE_BUFFERS";
>>> +       case IORING_OP_REMOVE_BUFFERS:
>>> +               return "REMOVE_BUFFERS";
>>> +       case IORING_OP_TEE:
>>> +               return "TEE";
>>> +       case IORING_OP_SHUTDOWN:
>>> +               return "SHUTDOWN";
>>> +       case IORING_OP_RENAMEAT:
>>> +               return "RENAMEAT";
>>> +       case IORING_OP_UNLINKAT:
>>> +               return "UNLINKAT";
>>> +       case IORING_OP_MKDIRAT:
>>> +               return "MKDIRAT";
>>> +       case IORING_OP_SYMLINKAT:
>>> +               return "SYMLINKAT";
>>> +       case IORING_OP_LINKAT:
>>> +               return "LINKAT";
>>> +       case IORING_OP_MSG_RING:
>>> +               return "MSG_RING";
>>> +       case IORING_OP_LAST:
>>> +               return "LAST";
>>> +       }
>>> +       return "UNKNOWN";
>>> +}
>>
>> My only worry here is that it's another place to touch when adding an
>> opcode. I'm assuming the compiler doesn't warn if you're missing one
>> since it's not strongly typed?
> 
> It doesn't complain, but we could strongly type it to get it to? I
> don't think it will break anything (certainly does not locally). What
> about something like this:

I think this would be fine. Would probably be cleaner if you just make
io_uring_get_opcode() take an enum io_uring_op and just fwd declare it
in io_uring.h?

-- 
Jens Axboe

