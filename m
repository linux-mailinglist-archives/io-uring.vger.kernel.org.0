Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817C2217DBA
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 05:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgGHDqu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 23:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728369AbgGHDqu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 23:46:50 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 545CCC061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 20:46:50 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d194so17632292pga.13
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 20:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=HWj2QWRUoRtz1QSAn6X6k7GbjEy0Xl8DwBBJa28pckA=;
        b=O+Anm5Bghaza4AyLjb2fqKh/NvpJAZAv2HSN6Y7agVQh3m66ubkAYx3HC5aQnYyKco
         vnSEmhx+N00cXe22oQelmnSRcgHm43PF1ys8z3WxsNAse7Cz338aCbgldkWXcsTr38L8
         x96BDqnBC0E1EEEdTC2D1l+ALPiqlNqd33eOyUESyxlzvsoBxHExZCPp4ub6dLUe55qD
         y3dxWBbDZvO1rqHEnclNxSnk7FK+XAWF/VeFsl9E9JKDgjiE83bTMhkMR/U2c2RG8qKD
         5543CDdpySZZYCPuLjx58REMoHXH5G2VC0lZCsyNfONAh+8zS9jPfzACeXeRN6VQv70I
         YKNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=HWj2QWRUoRtz1QSAn6X6k7GbjEy0Xl8DwBBJa28pckA=;
        b=qYu7HUDQKrFF3gj7RM7VqIm3xTlajxlR4yu6JL1JD9Pe2pbW0JNPncNKegkxcMGNhI
         8qKCzOdeP616dCKdIZ+XRHw7nAvD2rTh+OgiMOoxBcumWTqHG1x+ep2Vum6oRoC5He3O
         gigQJD8P9V2gCmroxBT9QGJKjmfo4UH3uwSGxFrEnpZ/jUEuVKdqt+dY0HYpEwowLiCk
         QObGi2J/cmX4f0ZHwbiPgUpplky9zBHVR3S/AWSOkr29RB/OHCFpUAlsb8Ji3GZ3qwJn
         pnAvFaYUDPn0qWi+7n0xL1DElM6z8Gr840z85AhCr/+Oos2E05T2W8aZcuxcrMJWkwR0
         YHjA==
X-Gm-Message-State: AOAM533GVqHoODZdPq+kKXt6J8GvB27SXUHC3sdQoDObZh3IUNHGsaaW
        /aQsLVZ38DTOS9EilIHUjoLRaSrQVlDcEw==
X-Google-Smtp-Source: ABdhPJwUOg8tztWU7goL+5M8CYYrAIzcFbVkFnQfVwA5iGmzejY/F/aOzF+LZ6Sgfi2Gije5Y0i1kQ==
X-Received: by 2002:a63:215e:: with SMTP id s30mr35628077pgm.87.1594180009758;
        Tue, 07 Jul 2020 20:46:49 -0700 (PDT)
Received: from [192.168.1.205] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v11sm13895348pfc.108.2020.07.07.20.46.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 20:46:48 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Jens Axboe <axboe@kernel.dk>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] io_uring: export cq overflow status to userspace
Date:   Tue, 7 Jul 2020 21:46:47 -0600
Message-Id: <D59FC4AE-8D3B-44F4-A6AA-91722D97E202@kernel.dk>
References: <c4e40cba-4171-a253-8813-ca833c8ce575@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, joseph.qi@linux.alibaba.com
In-Reply-To: <c4e40cba-4171-a253-8813-ca833c8ce575@linux.alibaba.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
X-Mailer: iPhone Mail (17F80)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


> On Jul 7, 2020, at 9:25 PM, Xiaoguang Wang <xiaoguang.wang@linux.alibaba.c=
om> wrote:
>=20
> =EF=BB=BFhi,
>=20
>>> On 7/7/20 8:28 AM, Jens Axboe wrote:
>>> On 7/7/20 7:24 AM, Xiaoguang Wang wrote:
>>>> For those applications which are not willing to use io_uring_enter()
>>>> to reap and handle cqes, they may completely rely on liburing's
>>>> io_uring_peek_cqe(), but if cq ring has overflowed, currently because
>>>> io_uring_peek_cqe() is not aware of this overflow, it won't enter
>>>> kernel to flush cqes, below test program can reveal this bug:
>>>>=20
>>>> static void test_cq_overflow(struct io_uring *ring)
>>>> {
>>>>         struct io_uring_cqe *cqe;
>>>>         struct io_uring_sqe *sqe;
>>>>         int issued =3D 0;
>>>>         int ret =3D 0;
>>>>=20
>>>>         do {
>>>>                 sqe =3D io_uring_get_sqe(ring);
>>>>                 if (!sqe) {
>>>>                         fprintf(stderr, "get sqe failed\n");
>>>>                         break;;
>>>>                 }
>>>>                 ret =3D io_uring_submit(ring);
>>>>                 if (ret <=3D 0) {
>>>>                         if (ret !=3D -EBUSY)
>>>>                                 fprintf(stderr, "sqe submit failed: %d\=
n", ret);
>>>>                         break;
>>>>                 }
>>>>                 issued++;
>>>>         } while (ret > 0);
>>>>         assert(ret =3D=3D -EBUSY);
>>>>=20
>>>>         printf("issued requests: %d\n", issued);
>>>>=20
>>>>         while (issued) {
>>>>                 ret =3D io_uring_peek_cqe(ring, &cqe);
>>>>                 if (ret) {
>>>>                         if (ret !=3D -EAGAIN) {
>>>>                                 fprintf(stderr, "peek completion failed=
: %s\n",
>>>>                                         strerror(ret));
>>>>                                 break;
>>>>                         }
>>>>                         printf("left requets: %d\n", issued);
>>>>                         continue;
>>>>                 }
>>>>                 io_uring_cqe_seen(ring, cqe);
>>>>                 issued--;
>>>>                 printf("left requets: %d\n", issued);
>>>>         }
>>>> }
>>>>=20
>>>> int main(int argc, char *argv[])
>>>> {
>>>>         int ret;
>>>>         struct io_uring ring;
>>>>=20
>>>>         ret =3D io_uring_queue_init(16, &ring, 0);
>>>>         if (ret) {
>>>>                 fprintf(stderr, "ring setup failed: %d\n", ret);
>>>>                 return 1;
>>>>         }
>>>>=20
>>>>         test_cq_overflow(&ring);
>>>>         return 0;
>>>> }
>>>>=20
>>>> To fix this issue, export cq overflow status to userspace, then
>>>> helper functions() in liburing, such as io_uring_peek_cqe, can be
>>>> aware of this cq overflow and do flush accordingly.
>>>=20
>>> Is there any way we can accomplish the same without exporting
>>> another set of flags? Would it be enough for the SQPOLl thread to set
>>> IORING_SQ_NEED_WAKEUP if we're in overflow condition? That should
>>> result in the app entering the kernel when it's flushed the user CQ
>>> side, and then the sqthread could attempt to flush the pending
>>> events as well.
>>>=20
>>> Something like this, totally untested...
>> OK, took a closer look at this, it's a generic thing, not just
>> SQPOLL related. My bad!
>> Anyway, my suggestion would be to add IORING_SQ_CQ_OVERFLOW to the
>> existing flags, and then make a liburing change almost identical to
>> what you had.
>> Hence kernel side:
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index d37d7ea5ebe5..af9fd5cefc51 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -1234,11 +1234,12 @@ static bool io_cqring_overflow_flush(struct io_ri=
ng_ctx *ctx, bool force)
>>      struct io_uring_cqe *cqe;
>>      struct io_kiocb *req;
>>      unsigned long flags;
>> +    bool ret =3D true;
>>      LIST_HEAD(list);
>>        if (!force) {
>>          if (list_empty_careful(&ctx->cq_overflow_list))
>> -            return true;
>> +            goto done;
>>          if ((ctx->cached_cq_tail - READ_ONCE(rings->cq.head) =3D=3D
>>              rings->cq_ring_entries))
>>              return false;
>> @@ -1284,7 +1285,11 @@ static bool io_cqring_overflow_flush(struct io_rin=
g_ctx *ctx, bool force)
>>          io_put_req(req);
>>      }
>>  -    return cqe !=3D NULL;
>> +    ret =3D cqe !=3D NULL;
>> +done:
>> +    if (ret)
>> +        ctx->rings->sq_flags &=3D ~IORING_SQ_CQ_OVERFLOW;
>> +    return ret;
>>  }
>>    static void __io_cqring_fill_event(struct io_kiocb *req, long res, lon=
g cflags)
>> @@ -5933,10 +5938,13 @@ static int io_submit_sqes(struct io_ring_ctx *ctx=
, unsigned int nr,
>>      int i, submitted =3D 0;
>>        /* if we have a backlog and couldn't flush it all, return BUSY */
>> -    if (test_bit(0, &ctx->sq_check_overflow)) {
>> +    if (unlikely(test_bit(0, &ctx->sq_check_overflow))) {
>>          if (!list_empty(&ctx->cq_overflow_list) &&
>> -            !io_cqring_overflow_flush(ctx, false))
>> +            !io_cqring_overflow_flush(ctx, false)) {
>> +            ctx->rings->sq_flags |=3D IORING_SQ_CQ_OVERFLOW;
>> +            smp_mb();
>>              return -EBUSY;
>> +        }
>>      }
>>        /* make sure SQ entry isn't read before tail */
>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.=
h
>> index 92c22699a5a7..9c7e028beda5 100644
>> --- a/include/uapi/linux/io_uring.h
>> +++ b/include/uapi/linux/io_uring.h
>> @@ -197,6 +197,7 @@ struct io_sqring_offsets {
>>   * sq_ring->flags
>>   */
>>  #define IORING_SQ_NEED_WAKEUP    (1U << 0) /* needs io_uring_enter wakeu=
p */
>> +#define IORING_SQ_CQ_OVERFLOW    (1U << 1) /* app needs to enter kernel *=
/
>>    struct io_cqring_offsets {
>>      __u32 head;
> I think above codes are still not correct, you only set IORING_SQ_CQ_OVERFL=
OW in
> io_submit_sqes, but if cq ring has been overflowed and applications don't d=
o io
> submit anymore, just calling io_uring_peek_cqe continuously, then applicat=
ions
> still won't be aware of the cq ring overflow.

With the associated liburing change in that same email, the peek will enter t=
he kernel just to flush the overflow. So not sure I see your concern?

> We can put the IORING_SQ_CQ_OVERFLOW set in __io_cqring_fill_event() when s=
etting
> cq_check_overflow. In non-sqpoll, this will be safe, but in sqpoll mode, t=
here maybe
> concurrent modifications to sq_flags, which is a race condition and may ne=
ed extral
> lock to protect IORING_SQ_NEED_WAKEP and IORING_SQ_CQ_OVERFLOW.

That=E2=80=99s why I wanted to keep it in the shared submission path, as tha=
t=E2=80=99s properly synchronized.=20


