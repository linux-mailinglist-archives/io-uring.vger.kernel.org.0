Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44550736575
	for <lists+io-uring@lfdr.de>; Tue, 20 Jun 2023 09:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbjFTH5b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Jun 2023 03:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231702AbjFTH5M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Jun 2023 03:57:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E771E6E
        for <io-uring@vger.kernel.org>; Tue, 20 Jun 2023 00:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=a+tC7aN3X7ynVxe8iBkMD7RVegogeufLwdaSxaIgZUA=; b=uPOe8KcBvadayQQW/edsOVvnwB
        r6eLXt30k53ls3y8vMccBBde6yN3QmFj9o/d25qgR89ChDAhWuUDw+0w9HzSSAlgMO20t47CiYraH
        zRAFLLYLzgYqu5skqkjgmHy9Ji0SW9tuM6Jh3trUk45m1QrmjzHTQCe3D+CJX5JxtMSk6OQoJg2AC
        73BPuEUqDq0d2aRNVUuKqnX0tS81P55gHvNcuBpnqPnvXr/IMMzzNO9KNg/TMt9JBw1RgVOrkJfnX
        9MpA3PFo1/itEizcycSmByWe+e4luIoolepT5JvT+9xvone5vCNqySxItHzrijs8cpu5+/f4OQuj2
        oHNT9+HjpaWrkrd0hihwmvrNgjP464fZ9y8bzfAR6tE32Bj77bHnP+RB3O3G/LGQu5Us8oah0RNtA
        19Wt1Ng05lWBxdcx8qZzhYzAXfoP380BlQz26X6LE1em0UgxW7Ttefm3rRakInxFsZKf3R6Vs8Dec
        P6dSpD2O1GHpuURov88xf57i;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBWDl-003CUY-1I;
        Tue, 20 Jun 2023 07:56:16 +0000
Message-ID: <1c63c371-b5cd-b6ec-33eb-2e0c61cc59ea@samba.org>
Date:   Tue, 20 Jun 2023 09:56:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/net: clear msg_controllen on partial sendmsg
 retry
Content-Language: en-US, de-DE
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <0fd9ed30-c542-fc18-cc4c-140890da5db4@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <0fd9ed30-c542-fc18-cc4c-140890da5db4@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

> If we have cmsg attached AND we transferred partial data at least, clear
> msg_controllen on retry so we don't attempt to send that again.
> 
> Cc: stable@vger.kernel.org # 5.10+
> Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 51b0f7fbb4f5..fe1c478c7dec 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -326,6 +326,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>   		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>   			return io_setup_async_msg(req, kmsg, issue_flags);
>   		if (ret > 0 && io_net_retry(sock, flags)) {
> +			kmsg->msg.msg_controllen = 0;
>   			sr->done_io += ret;
>   			req->flags |= REQ_F_PARTIAL_IO;
>   			return io_setup_async_msg(req, kmsg, issue_flags);
> 

Should we also set 'kmsg->msg.msg_control' to NULL?

metze
