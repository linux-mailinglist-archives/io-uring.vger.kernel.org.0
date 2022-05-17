Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C1952A74C
	for <lists+io-uring@lfdr.de>; Tue, 17 May 2022 17:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348825AbiEQPq0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 May 2022 11:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350955AbiEQPqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 May 2022 11:46:18 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E045045C
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 08:46:12 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id d3so12861846ilr.10
        for <io-uring@vger.kernel.org>; Tue, 17 May 2022 08:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Pm3hm1HZUZpVFZ/vUjhB7yGbOQaTiv2gZ0RhJgC3GO0=;
        b=Df2Ui/Yt5CsYC+2A8qvF/u61ILjqmZNmnpCQHom/E2wrrQxVL5Grc7TNvHbKR4vUo/
         VhyWKOoJ7W5Sf4Ry4HicYDlR4f6babzMb0GrjXrXx16OLVQ3DMu5Nu0BECJ7uibg0lgM
         9IvqzeG5wBBl3ZIlY70IMFVHlxN86UCSZiMoJ4L48ClRLxT88UaTnPD3i3VoqA8T3Vms
         MaOCIp1nqIzp3e3rqCP91kALzNAGcuwZGI0xXf67CF3XMu+toxkjmcJTzxXs6vTizybt
         Mn1AXVYKp6bQJtfvibCrr9YwgdvND71b/NG1XpWyHgwW4cQ1+Aox33j7BMRxqRDYWd/f
         kJPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pm3hm1HZUZpVFZ/vUjhB7yGbOQaTiv2gZ0RhJgC3GO0=;
        b=ev34217vjh8iLMcKN0go5tNlW+4YYuTyZtNZvPTJmEMt1LCIvJKsC41h6k9ZlyB5hA
         gbipS/7bXH271Syo8/U+zXN0i3LTwGHj6G5ok5VUOsq0IKZglAQH5GUFc+eiau1eo5RG
         yUgY4rX3QdpYqv2J0Fo1yNfKsEGzDvtU3rVKlPwxX8dVSkmJJ5F5uCxYP5XM6p2vE82v
         kavJNKpkp+2Qyyvqem7FKezNa4sGR+U/H8nck4oYeWidu5jObD+gC7NrKU8bSjav0GfX
         FmkFHI7LE7r7nlDkRKPOJ58JyFmPJcocir/XFzBniTjqm5ODXxY5HB6WK2ib1Zf2IHl4
         tXTw==
X-Gm-Message-State: AOAM532hPyeQ8cWXllKhy++0mexlf36mSLZCr4eRRdpFTeMKUMGdehlA
        zryIOnablkUwv+YyAORaDbruVA==
X-Google-Smtp-Source: ABdhPJwzaDHPNpGghmRrIvVfAXBuY/SBn6CSYAVIii0o9E6CXGN5H47Gq99DEmn5g5ZBOEx6rrgEJQ==
X-Received: by 2002:a05:6e02:1a27:b0:2cf:91e3:362f with SMTP id g7-20020a056e021a2700b002cf91e3362fmr11524773ile.124.1652802371883;
        Tue, 17 May 2022 08:46:11 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id n8-20020a056e02100800b002cde6e352bdsm715522ilj.7.2022.05.17.08.46.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 08:46:10 -0700 (PDT)
Message-ID: <8394fddb-ef44-b591-2654-2737219d2b8a@kernel.dk>
Date:   Tue, 17 May 2022 09:46:08 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/3] io_uring: add support for ring mapped supplied
 buffers
Content-Language: en-US
To:     Hao Xu <haoxu.linux@icloud.com>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Dylan Yudaken <dylany@fb.com>
References: <20220516162118.155763-1-axboe@kernel.dk>
 <20220516162118.155763-4-axboe@kernel.dk>
 <131d7543-b3bd-05e5-1a4c-e386368374ac@icloud.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <131d7543-b3bd-05e5-1a4c-e386368374ac@icloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 8:18 AM, Hao Xu wrote:
> Hi All,
> 
> On 5/17/22 00:21, Jens Axboe wrote:
>> Provided buffers allow an application to supply io_uring with buffers
>> that can then be grabbed for a read/receive request, when the data
>> source is ready to deliver data. The existing scheme relies on using
>> IORING_OP_PROVIDE_BUFFERS to do that, but it can be difficult to use
>> in real world applications. It's pretty efficient if the application
>> is able to supply back batches of provided buffers when they have been
>> consumed and the application is ready to recycle them, but if
>> fragmentation occurs in the buffer space, it can become difficult to
>> supply enough buffers at the time. This hurts efficiency.
>>
>> Add a register op, IORING_REGISTER_PBUF_RING, which allows an application
>> to setup a shared queue for each buffer group of provided buffers. The
>> application can then supply buffers simply by adding them to this ring,
>> and the kernel can consume then just as easily. The ring shares the head
>> with the application, the tail remains private in the kernel.
>>
>> Provided buffers setup with IORING_REGISTER_PBUF_RING cannot use
>> IORING_OP_{PROVIDE,REMOVE}_BUFFERS for adding or removing entries to the
>> ring, they must use the mapped ring. Mapped provided buffer rings can
>> co-exist with normal provided buffers, just not within the same group ID.
>>
>> To gauge overhead of the existing scheme and evaluate the mapped ring
>> approach, a simple NOP benchmark was written. It uses a ring of 128
>> entries, and submits/completes 32 at the time. 'Replenish' is how
>> many buffers are provided back at the time after they have been
>> consumed:
>>
>> Test            Replenish            NOPs/sec
>> ================================================================
>> No provided buffers    NA                ~30M
>> Provided buffers    32                ~16M
>> Provided buffers     1                ~10M
>> Ring buffers        32                ~27M
>> Ring buffers         1                ~27M
>>
>> The ring mapped buffers perform almost as well as not using provided
>> buffers at all, and they don't care if you provided 1 or more back at
>> the same time. This means application can just replenish as they go,
>> rather than need to batch and compact, further reducing overhead in the
>> application. The NOP benchmark above doesn't need to do any compaction,
>> so that overhead isn't even reflected in the above test.
>>
>> Co-developed-by: Dylan Yudaken <dylany@fb.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>   fs/io_uring.c                 | 233 ++++++++++++++++++++++++++++++++--
>>   include/uapi/linux/io_uring.h |  36 ++++++
>>   2 files changed, 257 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 5867dcabc73b..776a9f5e5ec7 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -285,9 +285,26 @@ struct io_rsrc_data {
>>       bool                quiesce;
>>   };
>>   +#define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
>>   struct io_buffer_list {
>> -    struct list_head buf_list;
>> +    /*
>> +     * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
>> +     * then these are classic provided buffers and ->buf_list is used.
>> +     */
>> +    union {
>> +        struct list_head buf_list;
>> +        struct {
>> +            struct page **buf_pages;
>> +            struct io_uring_buf_ring *buf_ring;
>> +        };
>> +    };
>>       __u16 bgid;
>> +
>> +    /* below is for ring provided buffers */
>> +    __u16 buf_nr_pages;
>> +    __u16 nr_entries;
>> +    __u32 tail;
>> +    __u32 mask;
>>   };
>>     struct io_buffer {
>> @@ -804,6 +821,7 @@ enum {
>>       REQ_F_NEED_CLEANUP_BIT,
>>       REQ_F_POLLED_BIT,
>>       REQ_F_BUFFER_SELECTED_BIT,
>> +    REQ_F_BUFFER_RING_BIT,
>>       REQ_F_COMPLETE_INLINE_BIT,
>>       REQ_F_REISSUE_BIT,
>>       REQ_F_CREDS_BIT,
>> @@ -855,6 +873,8 @@ enum {
>>       REQ_F_POLLED        = BIT(REQ_F_POLLED_BIT),
>>       /* buffer already selected */
>>       REQ_F_BUFFER_SELECTED    = BIT(REQ_F_BUFFER_SELECTED_BIT),
>> +    /* buffer selected from ring, needs commit */
>> +    REQ_F_BUFFER_RING    = BIT(REQ_F_BUFFER_RING_BIT),
>>       /* completion is deferred through io_comp_state */
>>       REQ_F_COMPLETE_INLINE    = BIT(REQ_F_COMPLETE_INLINE_BIT),
>>       /* caller should reissue async */
>> @@ -979,6 +999,12 @@ struct io_kiocb {
>>             /* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
>>           struct io_buffer    *kbuf;
>> +
>> +        /*
>> +         * stores buffer ID for ring provided buffers, valid IFF
>> +         * REQ_F_BUFFER_RING is set.
>> +         */
>> +        struct io_buffer_list    *buf_list;
>>       };
>>         union {
>> @@ -1470,8 +1496,14 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
>>     static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
>>   {
>> -    req->flags &= ~REQ_F_BUFFER_SELECTED;
>> -    list_add(&req->kbuf->list, list);
>> +    if (req->flags & REQ_F_BUFFER_RING) {
>> +        if (req->buf_list)
>> +            req->buf_list->tail++;
> 
> This confused me for some time..seems [tail, head) is the registered
> bufs that kernel space can leverage? similar to what pipe logic does.
> how about swaping the name of head and tail, this way setting the kernel
> as a consumer. But this is just my personal  preference..

No agree, I'll make that change. That matches the sq ring as well, which
is the same user producer, kernel consumer setup.

>> +    tail &= bl->mask;
>> +    if (tail < IO_BUFFER_LIST_BUF_PER_PAGE) {
>> +        buf = &br->bufs[tail];
>> +    } else {
>> +        int off = tail & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
>> +        int index = tail / IO_BUFFER_LIST_BUF_PER_PAGE - 1;
> 
> Could we do some bitwise trick with some compiler check there since for
> now IO_BUFFER_LIST_BUF_PER_PAGE is a power of 2.

This is known at compile time, so the compiler should already be doing
that as it's a constant.

>> +        buf = page_address(bl->buf_pages[index]);
>> +        buf += off;
>> +    }
> 
> I'm not familiar with this part, allow me to ask, is this if else
> statement for efficiency? why choose one page as the dividing line

We need to index at the right page granularity.

-- 
Jens Axboe

