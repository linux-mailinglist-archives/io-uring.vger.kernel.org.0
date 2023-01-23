Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47317677D90
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjAWOGK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjAWOGJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:06:09 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F3F7DBC
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:06:06 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 78so9028731pgb.8
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:06:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0egl4NYAO7rVmnE2EXjJeBI896dh9QcUs4z+fm4Ipkg=;
        b=ZsktSLSA6nfpwo/QEXAf5I+mgYFHb5jiQXhYBcwgX4tw3wPcO3bq91whdRZ+kZTwuC
         G2e7UAmmmD5NTQcKmEk0udbPNSgnK9snD1Odcj/MzRENceOx3hjL4Tpoc9LJm4eyJYTP
         zdsf2zQGcZWnZl+sZTIeB+9SgIIrthFGJE8Sug1QB5a4LcN6tVH9YvrsA3L/3WK+mnT0
         v4OfAdSPo+2rJ5VwDvnt31KsZg+xd/d7iJrYlNbxff0sGju4WVLlkwP1+LmyGx07gZgr
         1bRXlT2OAXd834idDNZVb2ICQhKIfrT3ir3g3jWGvAe7Bm0me8WHTF1r5r24PDCigGpl
         +vug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0egl4NYAO7rVmnE2EXjJeBI896dh9QcUs4z+fm4Ipkg=;
        b=6mHs8oUaIISFyaPDzTV9PkD6sZ7vaM2+ZPMnO05wwO82sJIAtCshxyTTKcMzKwEyxm
         UtHXUPWKcKPREBefCIhcK82knijFP4XVlle+hMBYX2ug05FHxn78gQXnh0JM7DJcTha3
         YM1JzHGVIU9t1bkgAp/+H49/lGCxu9lhxbXXJUww6pHfAmvoFyRxgU/eTFjRwF/gODLG
         JHJpyWvlyQyrfKaFZ9ODOoze4qHNXVlB3ZQ8s4YFOaf6cn03LP47TpTEGhfRh6+TL71N
         bqr+YeEcICwV0MrkTq4NSIU0zEBC+hNC2v4w4KkSX3Al6dnNO1582pw6e3Bg8MAO/5S/
         dhiA==
X-Gm-Message-State: AFqh2kqPhHvwIvcrd/UXxPsO8YY/qEovNnAHym0E/FO/a+qNDH7pQCXd
        jK/ygI8MGg5tA4dp0cbLZv0QxIS/koYLj413
X-Google-Smtp-Source: AMrXdXvlXhbJgbw8BS/4NgfwxzRBT/t55xthyrCG3sNqOIRBE1/F+bnNJ6SRXUcJ6Ptoeoxp9Bc4Lw==
X-Received: by 2002:a05:6a00:27a4:b0:58d:fc29:430c with SMTP id bd36-20020a056a0027a400b0058dfc29430cmr3575310pfb.1.1674482765638;
        Mon, 23 Jan 2023 06:06:05 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y30-20020aa793de000000b00589d8cbd882sm25893574pff.150.2023.01.23.06.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 06:06:05 -0800 (PST)
Message-ID: <0a6ef4bb-58fc-2139-8387-a46673386dca@kernel.dk>
Date:   Mon, 23 Jan 2023 07:06:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] io_uring/net: cache provided buffer group value for
 multishot receives
Content-Language: en-US
To:     Dylan Yudaken <dylany@meta.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <3627b18d-92b0-394e-4d39-6e0807aa417c@kernel.dk>
 <842b838f529636435dd4408989f7b03de4a9e0ca.camel@meta.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <842b838f529636435dd4408989f7b03de4a9e0ca.camel@meta.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 1/23/23 7:04 AM, Dylan Yudaken wrote:
> On Sun, 2023-01-22 at 10:13 -0700, Jens Axboe wrote:
>> If we're using ring provided buffers with multishot receive, and we
>> end
>> up doing an io-wq based issue at some points that also needs to
>> select
>> a buffer, we'll lose the initially assigned buffer group as
>> io_ring_buffer_select() correctly clears the buffer group list as the
>> issue isn't serialized by the ctx uring_lock. This is fine for normal
>> receives as the request puts the buffer and finishes, but for
>> multishot,
>> we will re-arm and do further receives. On the next trigger for this
>> multishot receive, the receive will try and pick from a buffer group
>> whose value is the same as the buffer ID of the las receive. That is
>> obviously incorrect, and will result in a premature -ENOUFS error for
>> the receive even if we had available buffers in the correct group.
>>
>> Cache the buffer group value at prep time, so we can restore it for
>> future receives. This only needs doing for the above mentioned case,
>> but
>> just do it by default to keep it easier to read.
>>
>> Cc: stable@vger.kernel.org
>> Fixes: b3fdea6ecb55 ("io_uring: multishot recv")
>> Fixes: 9bb66906f23e ("io_uring: support multishot in recvmsg")
>> Cc: Dylan Yudaken <dylany@meta.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> diff --git a/io_uring/net.c b/io_uring/net.c
>> index fbc34a7c2743..07a6aa39ab6f 100644
>> --- a/io_uring/net.c
>> +++ b/io_uring/net.c
>> @@ -62,6 +62,7 @@ struct io_sr_msg {
>>         u16                             flags;
>>         /* initialised and used only by !msg send variants */
>>         u16                             addr_len;
>> +       u16                             buf_group;
>>         void __user                     *addr;
>>         /* used only for send zerocopy */
>>         struct io_kiocb                 *notif;
>> @@ -580,6 +581,15 @@ int io_recvmsg_prep(struct io_kiocb *req, const
>> struct io_uring_sqe *sqe)
>>                 if (req->opcode == IORING_OP_RECV && sr->len)
>>                         return -EINVAL;
>>                 req->flags |= REQ_F_APOLL_MULTISHOT;
>> +               /*
>> +                * Store the buffer group for this multishot receive
>> separately,
>> +                * as if we end up doing an io-wq based issue that
>> selects a
>> +                * buffer, it has to be committed immediately and
>> that will
>> +                * clear ->buf_list. This means we lose the link to
>> the buffer
>> +                * list, and the eventual buffer put on completion
>> then cannot
>> +                * restore it.
>> +                */
>> +               sr->buf_group = req->buf_index;
>>         }
>>  
>>  #ifdef CONFIG_COMPAT
>> @@ -816,8 +826,10 @@ int io_recvmsg(struct io_kiocb *req, unsigned
>> int issue_flags)
>>         if (kmsg->msg.msg_inq)
>>                 cflags |= IORING_CQE_F_SOCK_NONEMPTY;
>>  
>> -       if (!io_recv_finish(req, &ret, cflags, mshot_finished,
>> issue_flags))
>> +       if (!io_recv_finish(req, &ret, cflags, mshot_finished,
>> issue_flags)) {
>> +               req->buf_index = sr->buf_group;
> 
> I think this is better placed in io_recv_prep_retry()? It would remove
> the duplicated logic below

True, let's move it there instead, and then perhaps also add a comment.
I'll make that change.

-- 
Jens Axboe


