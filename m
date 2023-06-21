Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEC8D738322
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 14:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjFULdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 07:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjFULdg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 07:33:36 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B5B4E6C
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 04:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=nwyW0JfoDdaJih542wGF1O//tSqQSrfKRIR2LOKxscs=; b=wFeUAb6dBV9I5BtiZ4jxJZEpHa
        jTqTBljhxb1dvzNiysPAjCAMxmHUafrz0sTZRlPT0iRnSy4dDGxX1he4xCR/RGFmI7/9Q+fUHWEHu
        TSMVj9JLGNL432FIUolH5QA+7ruovZ4v/QWx80zkiE5IFRRUUHF4Z/vhfzf7y8XDRQjIdsuqmgLEQ
        V/3CdAZLoOFr8Sq9Xsj749B8M1AvpaCs8ZRwYu4KXTsRHC3RmscjupGRqIJElR/hcV0JY3cTKMmAL
        abVsPm051CCn8HnK4tgc/TkEgMRBG4auZhh8kAPH0UQMkfWpvM98Vkd8a4wdby+l4GF0pqLSqHu7n
        kq1BME/7VN2/8I12aavIynkqOVcn4q0/lIUmKnERqiZ4KzefT9SaqKPyHcuYEUYJ/C7XRSxh11x6Q
        QI1+603+JvHSO74PsNtDizhsmkG2makEB0OPKTXWOW/Hb1zpzxTj4sEMgkmrb9Oatc+ikkKyGZc0C
        2xYghuwik7hhnZuIZ88xEJbL;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBw5c-003Vsj-2e;
        Wed, 21 Jun 2023 11:33:32 +0000
Message-ID: <1aeace5d-e474-353b-d240-d17c5dc12622@samba.org>
Date:   Wed, 21 Jun 2023 13:34:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] io_uring/net: disable partial retries for recvmsg with
 cmsg
Content-Language: en-US, de-DE
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <7e16d521-7c8a-3ac7-497a-04e69fee1afe@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <7e16d521-7c8a-3ac7-497a-04e69fee1afe@kernel.dk>
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

Am 20.06.23 um 15:19 schrieb Jens Axboe:
> We cannot sanely handle partial retries for recvmsg if we have cmsg
> attached. If we don't, then we'd just be overwriting the initial cmsg
> header on retries. Alternatively we could increment and handle this
> appropriately, but it doesn't seem worth the complication.
> 
> Move the MSG_WAITALL check into the non-multishot case while at it,
> since MSG_WAITALL is explicitly disabled for multishot anyway.
> 
> Link: https://lore.kernel.org/io-uring/0b0d4411-c8fd-4272-770b-e030af6919a0@kernel.dk/
> Cc: stable@vger.kernel.org # 5.10+
> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Also Reviewed-by: Stefan Metzmacher <metze@samba.org>

> ---
> 
> v2: correct msg_controllen check and move into non-mshot branch
> 
>   io_uring/net.c | 11 +++++++----
>   1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index c0924ab1ea11..2bc2cb2f4d6c 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -789,16 +789,19 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
>   	flags = sr->msg_flags;
>   	if (force_nonblock)
>   		flags |= MSG_DONTWAIT;
> -	if (flags & MSG_WAITALL)
> -		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
>   
>   	kmsg->msg.msg_get_inq = 1;
> -	if (req->flags & REQ_F_APOLL_MULTISHOT)
> +	if (req->flags & REQ_F_APOLL_MULTISHOT) {
>   		ret = io_recvmsg_multishot(sock, sr, kmsg, flags,
>   					   &mshot_finished);
> -	else
> +	} else {
> +		/* disable partial retry for recvmsg with cmsg attached */
> +		if (flags & MSG_WAITALL && !kmsg->msg.msg_controllen)
> +			min_ret = iov_iter_count(&kmsg->msg.msg_iter);
> +
>   		ret = __sys_recvmsg_sock(sock, &kmsg->msg, sr->umsg,
>   					 kmsg->uaddr, flags);
> +	}
>   
>   	if (ret < min_ret) {
>   		if (ret == -EAGAIN && force_nonblock) {

