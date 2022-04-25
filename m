Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB0950E3B4
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiDYO4J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241240AbiDYO4I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:56:08 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D696333EB1
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:53:03 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z19so11489509iof.12
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wOUGhewTIHx57dR+c6BoneNxu+T9haLPu+D4I0NDkpw=;
        b=QAiTDCvHKGVPYjxVmWl12GM6bCHF8GALttI00bUzR+b5jJfW8mB1TTEN4zjMhiF4Oq
         zCCbF6x463orc5rJdELNynlv0VXjaCyujJUjPy/vnxwPzdQjog093IZI+GJrxSPiMeKB
         qXfpliG90xqFWpJJatsS31KhWbABMuPmgV/iTyErLNioyOiweZZZl1HZGx3Idv+tmetN
         fmyF6bTiLBQI1wcCOvH0XA7V57mYsZ1L6mHKrgAzekH3CiYfHePtCX3t3ZAh20KA96/W
         PGGuykLjEWPcohiaZOkhAleZAVOcS+qhxklai9KXg5wNNqmY287+T2eVwgSwojDIlBtA
         STYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wOUGhewTIHx57dR+c6BoneNxu+T9haLPu+D4I0NDkpw=;
        b=HCfs3vzTmok5bMzQmo8R0Q5lIrtI6B8R92FwkYnJjkR/j18miWRb1RgrxwTokCp+o+
         WytXtH37zipvwOOI7kzPPJBkfPvh3ToEyuCiD8pclLlT+coNkKVzggX6DvX9x6yyvfFc
         KdxvnsdfFIYBlb8Zk0UEF4JKPLFHGkqd3gt+cEFvWKW0uxZmI3n3GDoJmQOL8YI+zR14
         g6WOijC3w/2/GCbaMzWMX9OuuJf3/wCL7mQ4HE6VFZlE7plK2uz4CJki0OsuVAeQFAQX
         CXsQ2tFwVnqbH7KF7jATkPyhAS1URXiUT2EIJv8TUyvLMImQbSbPBY70IF8g8DN/JTth
         1R3g==
X-Gm-Message-State: AOAM532U7CzsW7UDp7VVmOfYGcsfcPCa1sAKe8txiRcmW8Dp6ZTlSRy5
        nqHbgqhQ6hcFz6lvhM9NgmT9bg==
X-Google-Smtp-Source: ABdhPJw0I472Y63M+BTKA1fFdBDiVITgos9NU0Z5t3qL4wM7UOBmYCbH5SwCzb59rVRZRraFVTn3bw==
X-Received: by 2002:a05:6602:1410:b0:657:86b8:e641 with SMTP id t16-20020a056602141000b0065786b8e641mr1596689iov.188.1650898383203;
        Mon, 25 Apr 2022 07:53:03 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m8-20020a92cac8000000b002ca9d826c3fsm6383091ilq.34.2022.04.25.07.53.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Apr 2022 07:53:02 -0700 (PDT)
Message-ID: <0a360d99-a6cf-642a-9873-f779cbbd1f8b@kernel.dk>
Date:   Mon, 25 Apr 2022 08:53:00 -0600
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
 <09b305e7-ff07-ee4e-8603-fddf7931e0a8@kernel.dk>
 <6db369b4e8e0c598ff38d4b91b65004c59637b79.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6db369b4e8e0c598ff38d4b91b65004c59637b79.camel@fb.com>
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

On 4/25/22 8:48 AM, Dylan Yudaken wrote:
> On Mon, 2022-04-25 at 08:29 -0600, Jens Axboe wrote:
>> On 4/25/22 7:21 AM, Dylan Yudaken wrote:
>>> On Mon, 2022-04-25 at 06:38 -0600, Jens Axboe wrote:
>>>> On 4/25/22 3:36 AM, Dylan Yudaken wrote:
>>>>> In some debug scenarios it is useful to have the text
>>>>> representation
>>>>> of
>>>>> the opcode. Add this function in preparation.
>>>>>
>>>>> Signed-off-by: Dylan Yudaken <dylany@fb.com>
>>>>> ---
>>>>>  fs/io_uring.c            | 91
>>>>> ++++++++++++++++++++++++++++++++++++++++
>>>>>  include/linux/io_uring.h |  5 +++
>>>>>  2 files changed, 96 insertions(+)
>>>>>
>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>>>> index e57d47a23682..326695f74b93 100644
>>>>> --- a/fs/io_uring.c
>>>>> +++ b/fs/io_uring.c
>>>>> @@ -1255,6 +1255,97 @@ static struct kmem_cache *req_cachep;
>>>>>  
>>>>>  static const struct file_operations io_uring_fops;
>>>>>  
>>>>> +const char *io_uring_get_opcode(u8 opcode)
>>>>> +{
>>>>> +       switch (opcode) {
>>>>> +       case IORING_OP_NOP:
>>>>> +               return "NOP";
>>>>> +       case IORING_OP_READV:
>>>>> +               return "READV";
>>>>> +       case IORING_OP_WRITEV:
>>>>> +               return "WRITEV";
>>>>> +       case IORING_OP_FSYNC:
>>>>> +               return "FSYNC";
>>>>> +       case IORING_OP_READ_FIXED:
>>>>> +               return "READ_FIXED";
>>>>> +       case IORING_OP_WRITE_FIXED:
>>>>> +               return "WRITE_FIXED";
>>>>> +       case IORING_OP_POLL_ADD:
>>>>> +               return "POLL_ADD";
>>>>> +       case IORING_OP_POLL_REMOVE:
>>>>> +               return "POLL_REMOVE";
>>>>> +       case IORING_OP_SYNC_FILE_RANGE:
>>>>> +               return "SYNC_FILE_RANGE";
>>>>> +       case IORING_OP_SENDMSG:
>>>>> +               return "SENDMSG";
>>>>> +       case IORING_OP_RECVMSG:
>>>>> +               return "RECVMSG";
>>>>> +       case IORING_OP_TIMEOUT:
>>>>> +               return "TIMEOUT";
>>>>> +       case IORING_OP_TIMEOUT_REMOVE:
>>>>> +               return "TIMEOUT_REMOVE";
>>>>> +       case IORING_OP_ACCEPT:
>>>>> +               return "ACCEPT";
>>>>> +       case IORING_OP_ASYNC_CANCEL:
>>>>> +               return "ASYNC_CANCEL";
>>>>> +       case IORING_OP_LINK_TIMEOUT:
>>>>> +               return "LINK_TIMEOUT";
>>>>> +       case IORING_OP_CONNECT:
>>>>> +               return "CONNECT";
>>>>> +       case IORING_OP_FALLOCATE:
>>>>> +               return "FALLOCATE";
>>>>> +       case IORING_OP_OPENAT:
>>>>> +               return "OPENAT";
>>>>> +       case IORING_OP_CLOSE:
>>>>> +               return "CLOSE";
>>>>> +       case IORING_OP_FILES_UPDATE:
>>>>> +               return "FILES_UPDATE";
>>>>> +       case IORING_OP_STATX:
>>>>> +               return "STATX";
>>>>> +       case IORING_OP_READ:
>>>>> +               return "READ";
>>>>> +       case IORING_OP_WRITE:
>>>>> +               return "WRITE";
>>>>> +       case IORING_OP_FADVISE:
>>>>> +               return "FADVISE";
>>>>> +       case IORING_OP_MADVISE:
>>>>> +               return "MADVISE";
>>>>> +       case IORING_OP_SEND:
>>>>> +               return "SEND";
>>>>> +       case IORING_OP_RECV:
>>>>> +               return "RECV";
>>>>> +       case IORING_OP_OPENAT2:
>>>>> +               return "OPENAT2";
>>>>> +       case IORING_OP_EPOLL_CTL:
>>>>> +               return "EPOLL_CTL";
>>>>> +       case IORING_OP_SPLICE:
>>>>> +               return "SPLICE";
>>>>> +       case IORING_OP_PROVIDE_BUFFERS:
>>>>> +               return "PROVIDE_BUFFERS";
>>>>> +       case IORING_OP_REMOVE_BUFFERS:
>>>>> +               return "REMOVE_BUFFERS";
>>>>> +       case IORING_OP_TEE:
>>>>> +               return "TEE";
>>>>> +       case IORING_OP_SHUTDOWN:
>>>>> +               return "SHUTDOWN";
>>>>> +       case IORING_OP_RENAMEAT:
>>>>> +               return "RENAMEAT";
>>>>> +       case IORING_OP_UNLINKAT:
>>>>> +               return "UNLINKAT";
>>>>> +       case IORING_OP_MKDIRAT:
>>>>> +               return "MKDIRAT";
>>>>> +       case IORING_OP_SYMLINKAT:
>>>>> +               return "SYMLINKAT";
>>>>> +       case IORING_OP_LINKAT:
>>>>> +               return "LINKAT";
>>>>> +       case IORING_OP_MSG_RING:
>>>>> +               return "MSG_RING";
>>>>> +       case IORING_OP_LAST:
>>>>> +               return "LAST";
>>>>> +       }
>>>>> +       return "UNKNOWN";
>>>>> +}
>>>>
>>>> My only worry here is that it's another place to touch when
>>>> adding an
>>>> opcode. I'm assuming the compiler doesn't warn if you're missing
>>>> one
>>>> since it's not strongly typed?
>>>
>>> It doesn't complain, but we could strongly type it to get it to? I
>>> don't think it will break anything (certainly does not locally).
>>> What
>>> about something like this:
>>
>> I think this would be fine. Would probably be cleaner if you just
>> make
>> io_uring_get_opcode() take an enum io_uring_op and just fwd declare
>> it
>> in io_uring.h?
> 
> I cannot do that bit, as there is a separate function for
> CONFIG_IO_URING=n. That would either require different signatures (u8
> vs enum io_uring_op) or including the enum even when not enabled in
> config. Both of these feel ugly.
> 
> I'll send a new series giving the enum a type.

Agree, let's keep the cast then.

-- 
Jens Axboe

