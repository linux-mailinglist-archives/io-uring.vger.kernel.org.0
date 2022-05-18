Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D63052B837
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 12:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235181AbiERKvJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 06:51:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiERKu4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 06:50:56 -0400
Received: from pv50p00im-ztbu10011701.me.com (pv50p00im-ztbu10011701.me.com [17.58.6.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1452560057
        for <io-uring@vger.kernel.org>; Wed, 18 May 2022 03:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com;
        s=1a1hai; t=1652871048;
        bh=+qm1MqLgKkBdPLtQ7R8PF1Eh+8KolyhopeaXWhCKUJA=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=t6f/nwDcGawG1Z6tsHzqDh1XDClOyeT9fnVQGIzwgcfw7zqp4FwvIXwS9yZhM8faf
         BxSuX1/vNZu20AgwXYtjzt/7nfoAJ2vlwCZK//SEAxLHjtJxveEp56N5KdIZ/PW5zS
         bcGJB2e1w3EJAvHqORW3p+/OPrDW9uFwMOXnPNIKaRT6mDfi6Sg0P6xYM0cagwb6yq
         5FrWFDSf98Q6KvIRBz2Bvk1mIODtaCLqGYtnxTfi9lpiPmEsvynWnHu5N1MYah4HdW
         T99olMGgEHHnsUedDyAhqODLOOdlCzdemS40uXD6fGkV1/zk3W/2BEwinpovmMxrmk
         2LUqECPdx97zA==
Received: from [10.97.63.88] (pv50p00im-dlb-asmtp-mailmevip.me.com [17.56.9.10])
        by pv50p00im-ztbu10011701.me.com (Postfix) with ESMTPSA id 9A3CEB40131;
        Wed, 18 May 2022 10:50:46 +0000 (UTC)
Message-ID: <f1c6963f-9a53-db2c-3166-180800f14723@icloud.com>
Date:   Wed, 18 May 2022 18:50:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 3/3] io_uring: add support for ring mapped supplied
 buffers
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Dylan Yudaken <dylany@fb.com>
References: <20220516162118.155763-1-axboe@kernel.dk>
 <20220516162118.155763-4-axboe@kernel.dk>
 <131d7543-b3bd-05e5-1a4c-e386368374ac@icloud.com>
 <8394fddb-ef44-b591-2654-2737219d2b8a@kernel.dk>
From:   Hao Xu <haoxu.linux@icloud.com>
In-Reply-To: <8394fddb-ef44-b591-2654-2737219d2b8a@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-18_04:2022-05-17,2022-05-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-2009150000 definitions=main-2205180062
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/17/22 23:46, Jens Axboe wrote:
> On 5/17/22 8:18 AM, Hao Xu wrote:
>> Hi All,
>>
>> On 5/17/22 00:21, Jens Axboe wrote:
>>> Provided buffers allow an application to supply io_uring with buffers
>>> that can then be grabbed for a read/receive request, when the data
>>> source is ready to deliver data. The existing scheme relies on using
>>> IORING_OP_PROVIDE_BUFFERS to do that, but it can be difficult to use
>>> in real world applications. It's pretty efficient if the application
>>> is able to supply back batches of provided buffers when they have been
>>> consumed and the application is ready to recycle them, but if
>>> fragmentation occurs in the buffer space, it can become difficult to
>>> supply enough buffers at the time. This hurts efficiency.
>>>
>>> Add a register op, IORING_REGISTER_PBUF_RING, which allows an application
>>> to setup a shared queue for each buffer group of provided buffers. The
>>> application can then supply buffers simply by adding them to this ring,
>>> and the kernel can consume then just as easily. The ring shares the head
>>> with the application, the tail remains private in the kernel.
>>>
>>> Provided buffers setup with IORING_REGISTER_PBUF_RING cannot use
>>> IORING_OP_{PROVIDE,REMOVE}_BUFFERS for adding or removing entries to the
>>> ring, they must use the mapped ring. Mapped provided buffer rings can
>>> co-exist with normal provided buffers, just not within the same group ID.
>>>
>>> To gauge overhead of the existing scheme and evaluate the mapped ring
>>> approach, a simple NOP benchmark was written. It uses a ring of 128
>>> entries, and submits/completes 32 at the time. 'Replenish' is how
>>> many buffers are provided back at the time after they have been
>>> consumed:
>>>
>>> Test            Replenish            NOPs/sec
>>> ================================================================
>>> No provided buffers    NA                ~30M
>>> Provided buffers    32                ~16M
>>> Provided buffers     1                ~10M
>>> Ring buffers        32                ~27M
>>> Ring buffers         1                ~27M
>>>
>>> The ring mapped buffers perform almost as well as not using provided
>>> buffers at all, and they don't care if you provided 1 or more back at
>>> the same time. This means application can just replenish as they go,
>>> rather than need to batch and compact, further reducing overhead in the
>>> application. The NOP benchmark above doesn't need to do any compaction,
>>> so that overhead isn't even reflected in the above test.
>>>
>>> Co-developed-by: Dylan Yudaken <dylany@fb.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> ---
>>>    fs/io_uring.c                 | 233 ++++++++++++++++++++++++++++++++--
>>>    include/uapi/linux/io_uring.h |  36 ++++++
>>>    2 files changed, 257 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index 5867dcabc73b..776a9f5e5ec7 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -285,9 +285,26 @@ struct io_rsrc_data {
>>>        bool                quiesce;
>>>    };
>>>    +#define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
>>>    struct io_buffer_list {
>>> -    struct list_head buf_list;
>>> +    /*
>>> +     * If ->buf_nr_pages is set, then buf_pages/buf_ring are used. If not,
>>> +     * then these are classic provided buffers and ->buf_list is used.
>>> +     */
>>> +    union {
>>> +        struct list_head buf_list;
>>> +        struct {
>>> +            struct page **buf_pages;
>>> +            struct io_uring_buf_ring *buf_ring;
>>> +        };
>>> +    };
>>>        __u16 bgid;
>>> +
>>> +    /* below is for ring provided buffers */
>>> +    __u16 buf_nr_pages;
>>> +    __u16 nr_entries;
>>> +    __u32 tail;
>>> +    __u32 mask;
>>>    };
>>>      struct io_buffer {
>>> @@ -804,6 +821,7 @@ enum {
>>>        REQ_F_NEED_CLEANUP_BIT,
>>>        REQ_F_POLLED_BIT,
>>>        REQ_F_BUFFER_SELECTED_BIT,
>>> +    REQ_F_BUFFER_RING_BIT,
>>>        REQ_F_COMPLETE_INLINE_BIT,
>>>        REQ_F_REISSUE_BIT,
>>>        REQ_F_CREDS_BIT,
>>> @@ -855,6 +873,8 @@ enum {
>>>        REQ_F_POLLED        = BIT(REQ_F_POLLED_BIT),
>>>        /* buffer already selected */
>>>        REQ_F_BUFFER_SELECTED    = BIT(REQ_F_BUFFER_SELECTED_BIT),
>>> +    /* buffer selected from ring, needs commit */
>>> +    REQ_F_BUFFER_RING    = BIT(REQ_F_BUFFER_RING_BIT),
>>>        /* completion is deferred through io_comp_state */
>>>        REQ_F_COMPLETE_INLINE    = BIT(REQ_F_COMPLETE_INLINE_BIT),
>>>        /* caller should reissue async */
>>> @@ -979,6 +999,12 @@ struct io_kiocb {
>>>              /* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
>>>            struct io_buffer    *kbuf;
>>> +
>>> +        /*
>>> +         * stores buffer ID for ring provided buffers, valid IFF
>>> +         * REQ_F_BUFFER_RING is set.
>>> +         */
>>> +        struct io_buffer_list    *buf_list;
>>>        };
>>>          union {
>>> @@ -1470,8 +1496,14 @@ static inline void io_req_set_rsrc_node(struct io_kiocb *req,
>>>      static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
>>>    {
>>> -    req->flags &= ~REQ_F_BUFFER_SELECTED;
>>> -    list_add(&req->kbuf->list, list);
>>> +    if (req->flags & REQ_F_BUFFER_RING) {
>>> +        if (req->buf_list)
>>> +            req->buf_list->tail++;
>>
>> This confused me for some time..seems [tail, head) is the registered
>> bufs that kernel space can leverage? similar to what pipe logic does.
>> how about swaping the name of head and tail, this way setting the kernel
>> as a consumer. But this is just my personal  preference..
> 
> No agree, I'll make that change. That matches the sq ring as well, which
> is the same user producer, kernel consumer setup.
> 
>>> +    tail &= bl->mask;
>>> +    if (tail < IO_BUFFER_LIST_BUF_PER_PAGE) {
>>> +        buf = &br->bufs[tail];
>>> +    } else {
>>> +        int off = tail & (IO_BUFFER_LIST_BUF_PER_PAGE - 1);
>>> +        int index = tail / IO_BUFFER_LIST_BUF_PER_PAGE - 1;
>>
>> Could we do some bitwise trick with some compiler check there since for
>> now IO_BUFFER_LIST_BUF_PER_PAGE is a power of 2.
> 
> This is known at compile time, so the compiler should already be doing
> that as it's a constant.
> 
>>> +        buf = page_address(bl->buf_pages[index]);
>>> +        buf += off;
>>> +    }
>>
>> I'm not familiar with this part, allow me to ask, is this if else
>> statement for efficiency? why choose one page as the dividing line
> 
> We need to index at the right page granularity.

Sorry, I didn't get it, why can't we just do buf = &br->bufs[tail];
It seems something is beyond my knowledge..

> 

