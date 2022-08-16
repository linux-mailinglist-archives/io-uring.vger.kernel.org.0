Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC2F59584D
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 12:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234337AbiHPKam (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Aug 2022 06:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiHPKaU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Aug 2022 06:30:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3A0BC89
        for <io-uring@vger.kernel.org>; Tue, 16 Aug 2022 01:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=9AHcbkjTJ4YE9F//kh2cXtHtZvI3rvYIdI+NGzmE4qY=; b=oWkuIhoc7QM3yW08NbSvYcZpGm
        PBd2I93afvY7EV9TZr8kmsCc6/hExwGSXPvzbyFYjLkNMUh+XnCrlKK6kSkzEtsLymlzdefCkg5UD
        lthFUIikSzd+qk7knaIPzKtEf5jx8B5FiFvYW3OSPrylLgwh3amv4BX6Sr3JDHD+41iAzxbWEFt6F
        BLZ2SrX2A2iV4UNyjdEvUKDCloeu66XgMS02KbjKGs/nB3RX6hnhxRT4GiJUFTvKIK6sCeqesmcXE
        I/aa9Lu7O3JIYDY3awTNS6bzrpy8vzPWEYAjG7uX9glixH6xKI+1orCqqPeLgjLVr0hR/wuyicmxM
        Rd7claPmE/Sa1viPVTVnmhwuOgJ43MoicK0/w5wchJVZAxVSKYi4OOiBTc0m+vq9vjwjUDavkBzSt
        aNajrjlWq9qEF9p9misIN1ENiQIX4WScvowWV89AKwkSnAcSeA97GsGMSJTTEM7REyk7sdIYOGrpP
        W4HUK2xIxnTWX2Qa0rC6Jk+p;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oNriF-000N7x-DY; Tue, 16 Aug 2022 08:14:11 +0000
Message-ID: <ca9902d4-1623-a080-91c5-3935a38c0003@samba.org>
Date:   Tue, 16 Aug 2022 10:14:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dylan Yudaken <dylany@fb.com>
References: <cover.1660635140.git.asml.silence@gmail.com>
 <1ef0d539e1eb74d9aa0456d07198ecaadaf1b6a4.1660635140.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC 1/2] io_uring/notif: change notif CQE uapi format
In-Reply-To: <1ef0d539e1eb74d9aa0456d07198ecaadaf1b6a4.1660635140.git.asml.silence@gmail.com>
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
> Change the notification CQE layout while we can, put the seq number into
> cqe->res so we can cqe->flags to mark notification CQEs with
> IORING_CQE_F_NOTIF and add other flags in the future if needed. This
> will be needed to distinguish notifications from send completions when
> they use the same user_data.
> 
> Also, limit the sequence number to u16 and reserve upper 16 bits for the
> future. We also want it to mask out the sign bit for userspace
> convenience as it's easier to test for (cqe->res < 0).
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   include/uapi/linux/io_uring.h | 6 ++++++
>   io_uring/notif.c              | 4 ++--
>   2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 1463cfecb56b..20368394870e 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -286,6 +286,9 @@ enum io_uring_op {
>   #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
>   #define IORING_RECVSEND_NOTIF_FLUSH	(1U << 3)
>   
> +/* cqe->res mask for extracting the notification sequence number */
> +#define IORING_NOTIF_SEQ_MASK		0xFFFFU
> +
>   /*
>    * accept flags stored in sqe->ioprio
>    */
> @@ -337,10 +340,13 @@ struct io_uring_cqe {
>    * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
>    * IORING_CQE_F_MORE	If set, parent SQE will generate more CQE entries
>    * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
> + * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
> + *			them from sends.
>    */
>   #define IORING_CQE_F_BUFFER		(1U << 0)
>   #define IORING_CQE_F_MORE		(1U << 1)
>   #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
> +#define IORING_CQE_F_NOTIF		(1U << 3)
>   
>   enum {
>   	IORING_CQE_BUFFER_SHIFT		= 16,
> diff --git a/io_uring/notif.c b/io_uring/notif.c
> index 714715678817..6e17d1ae5a0d 100644
> --- a/io_uring/notif.c
> +++ b/io_uring/notif.c
> @@ -60,8 +60,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx,
>   	notif->rsrc_node = NULL;
>   	io_req_set_rsrc_node(notif, ctx, 0);
>   	notif->cqe.user_data = slot->tag;
> -	notif->cqe.flags = slot->seq++;
> -	notif->cqe.res = 0;
> +	notif->cqe.flags = IORING_CQE_F_NOTIF;
> +	notif->cqe.res = slot->seq++ & IORING_NOTIF_SEQ_MASK;
>   
>   	nd = io_notif_to_data(notif);
>   	nd->account_pages = 0;

This looks good.

metze
