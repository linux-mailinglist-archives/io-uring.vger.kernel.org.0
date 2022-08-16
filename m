Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCA7595762
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 12:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiHPKCL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 06:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234198AbiHPKBc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 06:01:32 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB56EE97F8
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 01:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=0SBvBhKAo3CQS+mjwf61NJwY9BZ4GnbX4d6Fr3mbAPY=; b=fVT8HNsy655XyLpsFfN05F3q3r
        x4p6B+OZp2EkNjv9c0U9rAJ+e+gh41ZauauGop7TRX2O/JutYPG+50J2aZbh3WAK+9HZLU0UyYGnI
        5/4YO7qcaQ7jZRMDoFNx1oqulx+6nU4NrYhiVOuxcl+in1ftmOTjLR/6OIOxTdUnfDrWSo6ZlVNOg
        LNs6h+GDc3GxjIvSZ0IFXnXmrf9vgVpwz4gTO7n36AOmlE4Hp1i9/xQX9lB16qCN28kxum02E8vcQ
        5+LD7cT4bf2O0aDbdzRNok0pLH7s2cqedTGq1mZx44FHm98VIQOQDEL7IE6Nv231sQcyZty1m+YOH
        o1YTFYocJpgmRxdyvBHJV9Vixep7d6Kbd+8DhumgBcUQkElVgofLBnRevTWapSnIIGsxZ6kN2BEya
        gVk8eboy49aWwXjSyzZQM2LbxB+PlDwY0kAyVmN4hQiDeKhDZMQUmGxN520puB64n9B5wPBsR0dte
        g6KJcJKBoLoijXWd1e/s+OfF;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oNrrH-000NBA-N1; Tue, 16 Aug 2022 08:23:31 +0000
Message-ID: <bf3d5a0f-c337-f6f3-8bf4-b8665f92acaa@samba.org>
Date:   Tue, 16 Aug 2022 10:23:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC 2/2] io_uring/net: allow to override notification tag
In-Reply-To: <6aa0c662a3fec17a1ade512e7bbb519aa49e6e4d.1660635140.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 16.08.22 um 09:42 schrieb Pavel Begunkov:
> Considering limited amount of slots some users struggle with
> registration time notification tag assignment as it's hard to manage
> notifications using sequence numbers. Add a simple feature that copies
> sqe->user_data of a send(+flush) request into the notification CQE it
> flushes (and only when it's flushes).
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/uapi/linux/io_uring.h | 4 ++++
>   io_uring/net.c                | 6 +++++-
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 20368394870e..91e7944c9c78 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -280,11 +280,15 @@ enum io_uring_op {
>    *
>    * IORING_RECVSEND_NOTIF_FLUSH	Flush a notification after a successful
>    *				successful. Only for zerocopy sends.
> + *
> + * IORING_RECVSEND_NOTIF_COPY_TAG Copy request's user_data into the notification
> + *				  completion even if it's flushed.
>    */
>   #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
>   #define IORING_RECV_MULTISHOT		(1U << 1)
>   #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
>   #define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
> +#define IORING_RECVSEND_NOTIF_COPY_TAG	(1U << 4)
>   
>   /* cqe->res mask for extracting the notification sequence number */
>   #define IORING_NOTIF_SEQ_MASK		0xFFFFU
> diff --git a/io_uring/net.c b/io_uring/net.c
> index bd3fad9536ef..4d271a269979 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -858,7 +858,9 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   
>   	zc->flags = READ_ONCE(sqe->ioprio);
>   	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
> -			  IORING_RECVSEND_FIXED_BUF | IORING_RECVSEND_NOTIF_FLUSH))
> +			  IORING_RECVSEND_FIXED_BUF |
> +			  IORING_RECVSEND_NOTIF_FLUSH |
> +			  IORING_RECVSEND_NOTIF_COPY_TAG))
>   		return -EINVAL;
>   	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
>   		unsigned idx = READ_ONCE(sqe->buf_index);
> @@ -1024,6 +1026,8 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
>   		if (ret == -ERESTARTSYS)
>   			ret = -EINTR;
>   	} else if (zc->flags & IORING_RECVSEND_NOTIF_FLUSH) {
> +		if (zc->flags & IORING_RECVSEND_NOTIF_COPY_TAG)
> +			notif->cqe.user_data = req->cqe.user_data;
>   		io_notif_slot_flush_submit(notif_slot, 0);
>   	}

This would work but it seems to be confusing.

Can't we have a slot-less mode, with slot_idx==U16_MAX,
where we always allocate a new notif for each request,
this would then get the same user_data and would be referenced on the
request in order to reuse the same notif on an async retry after a short send.
And this notif will always be flushed at the end of the request.

This:

struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
                                 struct io_notif_slot *slot)

would change to:

struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
                                 __u64 cqe_user_data,
				__s32 cqe_res)


and:

void io_notif_slot_flush(struct io_notif_slot *slot) __must_hold(&ctx->uring_lock)

(__must_hold looks wrong there...)

could just be:

void io_notif_flush(struct io_notif_*notif)

What do you think? It would remove the whole notif slot complexity
from caller using IORING_RECVSEND_NOTIF_FLUSH for every request anyway.

metze
