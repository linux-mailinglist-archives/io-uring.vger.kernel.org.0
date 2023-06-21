Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36787382A8
	for <lists+io-uring@lfdr.de>; Wed, 21 Jun 2023 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbjFULeY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 07:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjFULeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 07:34:22 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C847BE57
        for <io-uring@vger.kernel.org>; Wed, 21 Jun 2023 04:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:To:Date:Message-ID:CC;
        bh=Ld4mAdjxUPIVzi7HAhOLnfIdAvuiBM5QSPkqga+6eBY=; b=wVv1tnvjEAkaa1B/jwUNGzDorR
        OX6wdQ2yKQppym1RWDoJpp0vooIik1Ns8Z0ouAOOKkD+DkGsZYZQeCG6r6wgwxRqdPqxoy0FCHZ5Q
        giGv9xbpX9qpUJn6je+C/eNFgRYxBNvRZYYtUmM4QkAzWZ8n5Pt8xx5w8/LdZ1KIH6iWoCIwnAvcb
        n7Ga1l/dNfHOvsk0sSacB/QhmAshrSlZbKGCRIy9+lHullJwg2Kpvahd7ANJvmNTA8fpzM7OuRFO+
        cKY20RBYhTbIHSeFsFfhTYh5JfprYKnbnkByy6iai42w6bcDpC0W2iChRMCo7jHSVWOuDlXFWyhjM
        57PYWIgYZGLkDKWqTgFIQ+2G33cYt1UxIIrHoyrPZ1HsB50mE7nkhAAyOe12yx4cYd1jGlUntXMyL
        u0cPMPEeNa6dptuICrUmZjehgPOxcnzFAXbVfM1T8uux8ft7IcLWOBIAh4kLAxI6KUWkXSd2AHOE1
        oKc+SJRxJACE5BTJm9Y3qJcw;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1qBw6O-003Vt9-0C;
        Wed, 21 Jun 2023 11:34:20 +0000
Message-ID: <406ba804-1ef0-b0c1-2d91-e2c560d7ceae@samba.org>
Date:   Wed, 21 Jun 2023 13:34:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] io_uring/net: clear msg_controllen on partial sendmsg
 retry
Content-Language: en-US, de-DE
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <312cc2b7-8229-c167-e230-bc1d7d0ed61b@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <312cc2b7-8229-c167-e230-bc1d7d0ed61b@kernel.dk>
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
> If we have cmsg attached AND we transferred partial data at least, clear
> msg_controllen on retry so we don't attempt to send that again.
> 
> Cc: stable@vger.kernel.org # 5.10+
> Fixes: cac9e4418f4c ("io_uring/net: save msghdr->msg_control for retries")
> Reported-by: Stefan Metzmacher <metze@samba.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Also Reviewed-by: Stefan Metzmacher <metze@samba.org>

> ---
> 
> v2: clear msg_control as well
> 
>   io_uring/net.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/io_uring/net.c b/io_uring/net.c
> index 51b0f7fbb4f5..c0924ab1ea11 100644
> --- a/io_uring/net.c
> +++ b/io_uring/net.c
> @@ -326,6 +326,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
>   		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
>   			return io_setup_async_msg(req, kmsg, issue_flags);
>   		if (ret > 0 && io_net_retry(sock, flags)) {
> +			kmsg->msg.msg_controllen = 0;
> +			kmsg->msg.msg_control = NULL;
>   			sr->done_io += ret;
>   			req->flags |= REQ_F_PARTIAL_IO;
>   			return io_setup_async_msg(req, kmsg, issue_flags);

