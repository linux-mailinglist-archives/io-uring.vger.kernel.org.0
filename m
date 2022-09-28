Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509B25EE03E
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 17:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234335AbiI1PZY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 11:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiI1PYr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 11:24:47 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630DB5C9C6
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 08:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=wEFaQL1IVgRK5SMizJhfLK5HnMNoWpFzBlYtumOd/iQ=; b=ly3GjMjatafQ+dzH6ZhVRk0XlZ
        fpm7EiiNPO4H2ile7u6qyWIH7KpHmtn6qpFP4N+cRolo9RGveBgSL4ubJVLPh8ZL2+MeLGeWdZQrt
        0sDusJh2GS/M9V/uLTg0ek+JzGKG6k/suv4IqDz4TJZFzbqBiBvISPO4Mb9owe0wpochRfATo9o3w
        6nNqt45gEoaosjWmGlplyJGFpk56mVJBvM9GS44ROfcKSasPFBaIdh/AWpEo5DajMGpZkr3svigCE
        yJfgOGWfy3iXWMO4PnAPdkwPaenUZbPPvFizbhgasx4dhFdHpnOb2i77t782XyJmgerniz9m3LG0o
        FNojSyrJDieuBQC7LWXo/TXTHsB9xw4hwHyCoiDXE65twbWPe8C5Gjyj9uSnDgnFUo72641EuCYp9
        8dKFFsCC2AKKeFMpn40j7xuwuxBCgAH57PHoZWkXB021mQ1HHF0RaRSE9u26II7bGQO+pjGU78hM4
        lFVBPb4OSeAwHo62xe9gZ398;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1odYuX-002F6r-1S; Wed, 28 Sep 2022 15:23:45 +0000
Message-ID: <ba8eafce-c4cb-6993-7902-1db17168d37b@samba.org>
Date:   Wed, 28 Sep 2022 17:23:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.1] io_uring/net: don't skip notifs for failed
 requests
In-Reply-To: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Pavel,

> We currently only add a notification CQE when the send succeded, i.e.
> cqe.res >= 0. However, it'd be more robust to do buffer notifications
> for failed requests as well in case drivers decide do something fanky.
> 
> Always return a buffer notification after initial prep, don't hide it.
> This behaviour is better aligned with documentation and the patch also
> helps the userspace to respect it.

Just as reference, this was the version I was testing with:
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=7ffb896cdb8ccd55065f7ffae9fb8050e39211c7

>   void io_sendrecv_fail(struct io_kiocb *req)
>   {
>   	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
> -	int res = req->cqe.res;
>   
>   	if (req->flags & REQ_F_PARTIAL_IO)
> -		res = sr->done_io;
> +		req->cqe.res = sr->done_io;
> +
>   	if ((req->flags & REQ_F_NEED_CLEANUP) &&
> -	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
> -		/* preserve notification for partial I/O */
> -		if (res < 0)
> -			sr->notif->flags |= REQ_F_CQE_SKIP;
> -		io_notif_flush(sr->notif);
> -		sr->notif = NULL;

Here we rely on io_send_zc_cleanup(), correct?

Note that I hit a very bad problem during my tests of SENDMSG_ZC.
BUG(); in first_iovec_segment() triggered very easily.
The problem is io_setup_async_msg() in the partial retry case,
which seems to happen more often with _ZC.

        if (!async_msg->free_iov)
                async_msg->msg.msg_iter.iov = async_msg->fast_iov;

Is wrong it needs to be something like this:

+       if (!kmsg->free_iov) {
+               size_t fast_idx = kmsg->msg.msg_iter.iov - kmsg->fast_iov;
+               async_msg->msg.msg_iter.iov = &async_msg->fast_iov[fast_idx];
+       }

As iov_iter_iovec_advance() may change i->iov in order to have i->iov_offset
being only relative to the first element.

I'm not sure about the 'kmsg->free_iov' case, do we reuse the
callers memory or should we make a copy?
I initially used this
https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=e1d3a9f5c7708a37172d258753ed7377eaac9e33
But I didn't test with the non-fast_iov case.

BTW: I tested with 5 vectors with length like this 4, 0, 64, 32, 8388608
and got a short write with about ~ 2000000.

I'm not sure if it was already a problem before:

commit 257e84a5377fbbc336ff563833a8712619acce56
io_uring: refactor sendmsg/recvmsg iov managing

But I guess it was a potential problem before starting with
7ba89d2af17aa879dda30f5d5d3f152e587fc551 where io_net_retry()
was introduced.

metze
