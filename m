Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E25E751645E
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 14:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234166AbiEAM3R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 08:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347025AbiEAM3Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 08:29:16 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3FD13F47
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 05:25:49 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g8so8013040pfh.5
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 05:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=qgln9uVwh5Nt+TnhammyAxaf9MAWlTbjGIRyzgYL0dU=;
        b=zv3Gn+IJ/yuvbuH2nY733YiAC/LpmVywzZWD8hIHRUanFJ15YSpNR3Sjmo+FtCltu+
         plzw7lh5ytnjyXTG+AdSoI0fGM/RgSi8vIxKBQFHUnm3skgIeGxyLlemOwQExq6c+VpX
         QQydgn7k1ueMvnk6pDrUIMJlm9rgujXYr5KsZPb2K6e+Hl/7dHt0YzRYepdDnjh+84NX
         1OLHvSgckETPvojCIRDLpgr7vPN/b29UrK8F1YGRkt4zTT7KLvLV29etYTI2ETgFkwiD
         fiuDLrjCI+lm5YLbXwkIze5OeYAw2sz9YgnPHuMrl8vVD4oU891awTF5VblvIe9Q+29G
         4b2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qgln9uVwh5Nt+TnhammyAxaf9MAWlTbjGIRyzgYL0dU=;
        b=t+ng5v6uyTf0uOR4nZdPEmASqVZM7b3DNZT1ptkYAx8zJpTV17Cf0Ukef4HqAKHTmx
         ADRDFm5urQdIGVQeX1KXdpJmk0gXtcV27YoMV/Axiiiu8dkzpWIreNTJ907MpK+LnjRj
         1gUJkGlfbp298wGAyA2dMFjrxB9noCidtuQPkeKEV1i+ORWlQPKMoCbL3rK/UedykRQs
         2kbBlGyZAoiL5UGqsRfcMKsDYCxsBEV8jXa5Xp+aGDGizDCg0br+b2ntjxKbr+FS54Jb
         qM+6fGEKnO/AnwPXKj+2VxBUPS3/62zJHQulXvgYuA4IvViI+kOZgdkZN0NuGflP+27m
         4Vtg==
X-Gm-Message-State: AOAM533oflBRRYuQFqUCdfGmsrA1fx6OmhS2FLxX+rXtaZ7Ii8hwb6YX
        fjDtNftzGzh8nWaS1BVLbDsU6rmKQccHmCMw
X-Google-Smtp-Source: ABdhPJx5UE+eWLglTYYmcBNykpd9Jvbu1TLuji8ruCYmNJKxL2aRhS3AJIgphSkGzBBvFKXj3ysECg==
X-Received: by 2002:a63:8549:0:b0:3ab:3197:3efc with SMTP id u70-20020a638549000000b003ab31973efcmr5945902pgd.137.1651407949168;
        Sun, 01 May 2022 05:25:49 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u19-20020a170902a61300b0015e8d4eb1f7sm2832576plq.65.2022.05.01.05.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 May 2022 05:25:48 -0700 (PDT)
Message-ID: <3fbf89e6-f656-4c51-2273-6aab46214dd7@kernel.dk>
Date:   Sun, 1 May 2022 06:25:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 12/12] io_uring: add support for ring mapped supplied
 buffers
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
References: <20220430205022.324902-1-axboe@kernel.dk>
 <20220430205022.324902-13-axboe@kernel.dk>
 <604a172092b18514b325d809f641c988a9f6184e.camel@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <604a172092b18514b325d809f641c988a9f6184e.camel@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/1/22 4:28 AM, Dylan Yudaken wrote:
> On Sat, 2022-04-30 at 14:50 -0600, Jens Axboe wrote:
>> Provided buffers allow an application to supply io_uring with buffers
>> that can then be grabbed for a read/receive request, when the data
>> source is ready to deliver data. The existing scheme relies on using
>> IORING_OP_PROVIDE_BUFFERS to do that, but it can be difficult to use
>> in real world applications. It's pretty efficient if the application
>> is able to supply back batches of provided buffers when they have
>> been
>> consumed and the application is ready to recycle them, but if
>> fragmentation occurs in the buffer space, it can become difficult to
>> supply enough buffers at the time. This hurts efficiency.
>>
>> Add a register op, IORING_REGISTER_PBUF_RING, which allows an
>> application
>> to setup a shared queue for each buffer group of provided buffers.
>> The
>> application can then supply buffers simply by adding them to this
>> ring,
>> and the kernel can consume then just as easily. The ring shares the
>> head
>> with the application, the tail remains private in the kernel.
>>
>> Provided buffers setup with IORING_REGISTER_PBUF_RING cannot use
>> IORING_OP_{PROVIDE,REMOVE}_BUFFERS for adding or removing entries to
>> the
>> ring, they must use the mapped ring. Mapped provided buffer rings can
>> co-exist with normal provided buffers, just not within the same group
>> ID.
>>
>> To gauge overhead of the existing scheme and evaluate the mapped ring
>> approach, a simple NOP benchmark was written. It uses a ring of 128
>> entries, and submits/completes 32 at the time. 'Replenish' is how
>> many buffers are provided back at the time after they have been
>> consumed:
>>
>> Test                    Replenish                       NOPs/sec
>> ================================================================
>> No provided buffers     NA                              ~30M
>> Provided buffers        32                              ~16M
>> Provided buffers         1                              ~10M
>> Ring buffers            32                              ~27M
>> Ring buffers             1                              ~27M
>>
>> The ring mapped buffers perform almost as well as not using provided
>> buffers at all, and they don't care if you provided 1 or more back at
>> the same time. This means application can just replenish as they go,
>> rather than need to batch and compact, further reducing overhead in
>> the
>> application. The NOP benchmark above doesn't need to do any
>> compaction,
>> so that overhead isn't even reflected in the above test.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  fs/io_uring.c                 | 227 +++++++++++++++++++++++++++++++-
>> --
>>  include/uapi/linux/io_uring.h |  26 ++++
>>  2 files changed, 238 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 3d5d02b40347..a9691727652c 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -285,7 +285,16 @@ struct io_rsrc_data {
>>  struct io_buffer_list {
>>         struct list_head list;
>>         struct list_head buf_list;
>> +       struct page **buf_pages;
>>         __u16 bgid;
>> +
>> +       /* below is for ring provided buffers */
>> +       __u16 buf_nr_pages;
>> +       __u16 nr_entries;
>> +       __u16 buf_per_page;
>> +       struct io_uring_buf_ring *buf_ring;
>> +       __u32 tail;
>> +       __u32 mask;
>>  };
>>  
>>  struct io_buffer {
>> @@ -815,6 +824,7 @@ enum {
>>         REQ_F_NEED_CLEANUP_BIT,
>>         REQ_F_POLLED_BIT,
>>         REQ_F_BUFFER_SELECTED_BIT,
>> +       REQ_F_BUFFER_RING_BIT,
>>         REQ_F_COMPLETE_INLINE_BIT,
>>         REQ_F_REISSUE_BIT,
>>         REQ_F_CREDS_BIT,
>> @@ -865,6 +875,8 @@ enum {
>>         REQ_F_POLLED            = BIT(REQ_F_POLLED_BIT),
>>         /* buffer already selected */
>>         REQ_F_BUFFER_SELECTED   = BIT(REQ_F_BUFFER_SELECTED_BIT),
>> +       /* buffer selected from ring, needs commit */
>> +       REQ_F_BUFFER_RING       = BIT(REQ_F_BUFFER_RING_BIT),
>>         /* completion is deferred through io_comp_state */
>>         REQ_F_COMPLETE_INLINE   = BIT(REQ_F_COMPLETE_INLINE_BIT),
>>         /* caller should reissue async */
>> @@ -984,6 +996,15 @@ struct io_kiocb {
>>  
>>                 /* stores selected buf, valid IFF
>> REQ_F_BUFFER_SELECTED is set */
>>                 struct io_buffer        *kbuf;
>> +
>> +               /*
>> +                * stores buffer ID for ring provided buffers, valid
>> IFF
>> +                * REQ_F_BUFFER_RING is set.
>> +                */
>> +                struct {
>> +                        struct io_buffer_list  *buf_list;
>> +                        __u32                  bid;
>> +                };
>>         };
>>  
>>         union {
>> @@ -1564,21 +1585,30 @@ static inline void
>> io_req_set_rsrc_node(struct io_kiocb *req,
>>  
>>  static unsigned int __io_put_kbuf(struct io_kiocb *req, struct
>> list_head *list)
>>  {
>> -       struct io_buffer *kbuf = req->kbuf;
>>         unsigned int cflags;
>>  
>> -       cflags = IORING_CQE_F_BUFFER | (kbuf->bid <<
>> IORING_CQE_BUFFER_SHIFT);
>> -       req->flags &= ~REQ_F_BUFFER_SELECTED;
>> -       list_add(&kbuf->list, list);
>> -       req->kbuf = NULL;
>> -       return cflags;
>> +       if (req->flags & REQ_F_BUFFER_RING) {
>> +               if (req->buf_list)
>> +                       req->buf_list->tail++;
> 
> does this need locking? both on buf_list being available or atomic
> increment on tail.

This needs some comments and checks around the expectation. But the idea
is that the fast path will invoke eg the recv with the uring_lock
already held, and we'll hold it until we complete it.

Basically we have two cases:

1) Op invoked with uring_lock held. Either the request completes
   successfully in this invocation, and we put the kbuf with it still
   held. The completion just increments the tail, buf now consumed. Or
   we need to retry somehow, and we can just clear REQ_F_BUFFER_RING to
   recycle the buf, that's it.

2) Op invoked without uring_lock held. We get a buf and increment the
   tail, as we'd otherwise need to grab it again for the completion.
   We're now stuck with the buf, hold it until the request completes.

#1 is the above code, just need some checks and safe guards to ensure
that if ->buf_list is still set, we are still holding the lock.

>> +
>> +               cflags = req->bid << IORING_CQE_BUFFER_SHIFT;
>> +               req->flags &= ~REQ_F_BUFFER_RING;
>> +       } else {
>> +               struct io_buffer *kbuf = req->kbuf;
>> +
>> +               cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
>> +               list_add(&kbuf->list, list);
>> +               req->kbuf = NULL;
> 
> I wonder if this is not necessary? we don't do it above to buf_list and
> it seems to work? For consistency though maybe better to pick one
> approach?

You mean clearing ->kbuf? Yes that's not needed, we're clearing
REQ_F_BUFFER_SELECTED anyway, it's more of a belt and suspenders thing.
I just left the original code alone here, we can remove the NULL
separately.

>> +       /*
>> +        * If we came in unlocked, we have no choice but to
>> +        * consume the buffer here. This does mean it'll be
>> +        * pinned until the IO completes. But coming in
>> +        * unlocked means we're in io-wq context, hence there
> 
> I do not know if this matters here, but task work can also run unlocked
> operations.

As long as the issue_flags are correct, then we should be fine.

>> @@ -423,6 +427,28 @@ struct io_uring_restriction {
>>         __u32 resv2[3];
>>  };
>>  
>> +struct io_uring_buf {
>> +       __u64   addr;
>> +       __u32   len;
>> +       __u32   bid;
>> +};
> 
> I believe bid is 16 bits due to the way it comes back in CQE flags

That is correctl it's limited to 64K on each. We can make this __u16
and add some reserved field. Ditto for the io_uring_buf_reg as well.

-- 
Jens Axboe

