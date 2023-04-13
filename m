Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA8606E03F3
	for <lists+io-uring@lfdr.de>; Thu, 13 Apr 2023 04:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjDMCDu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 Apr 2023 22:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjDMCDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 Apr 2023 22:03:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFB32708
        for <io-uring@vger.kernel.org>; Wed, 12 Apr 2023 19:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681351381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Pvltjpy791f0nMBvxCKQ6mkDCt9yk1e1NqNm5L8RGk=;
        b=EW63L9CYhQNs8ba/kRQQV0lpSi59mYoL6lQw3dSRjNh1hpRP92tQMJ7NKzy4xQMMnMpPk9
        4niN34YalUG2q+jIH3AhWhPtcIjAFK2RdYapRO0xhLMXo+yaKG9iV4AXjpCUKl4sByCMuf
        TaX2NVPrVOFaCEBtUyLyNnM3YRT16RI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-335-kWQW0BjLMKKDqKmQUCFiqg-1; Wed, 12 Apr 2023 22:02:57 -0400
X-MC-Unique: kWQW0BjLMKKDqKmQUCFiqg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 85F2D3C02B62;
        Thu, 13 Apr 2023 02:02:57 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BF8F91121320;
        Thu, 13 Apr 2023 02:02:54 +0000 (UTC)
Date:   Thu, 13 Apr 2023 10:02:48 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>, ming.lei@redhat.com
Subject: Re: [PATCH] io_uring/uring_cmd: take advantage of completion batching
Message-ID: <ZDdiyMMxtTZL9iPj@ovpn-8-18.pek2.redhat.com>
References: <bbcdf761-e6f2-c2c5-dfb7-4579124a8fd5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbcdf761-e6f2-c2c5-dfb7-4579124a8fd5@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 12, 2023 at 12:09:18PM -0600, Jens Axboe wrote:
> We know now what the completion context is for the uring_cmd completion
> handling, so use that to have io_req_task_complete() decide what the
> best way to complete the request is. This allows batching of the posted
> completions if we have multiple pending, rather than always doing them
> one-by-one.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index f7a96bc76ea1..5113c9a48583 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -54,11 +54,15 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2,
>  	io_req_set_res(req, ret, 0);
>  	if (req->ctx->flags & IORING_SETUP_CQE32)
>  		io_req_set_cqe32_extra(req, res2, 0);
> -	if (req->ctx->flags & IORING_SETUP_IOPOLL)
> +	if (req->ctx->flags & IORING_SETUP_IOPOLL) {
>  		/* order with io_iopoll_req_issued() checking ->iopoll_complete */
>  		smp_store_release(&req->iopoll_completed, 1);
> -	else
> -		io_req_complete_post(req, issue_flags);
> +	} else {
> +		struct io_tw_state ts = {
> +			.locked = !(issue_flags & IO_URING_F_UNLOCKED),
> +		};
> +		io_req_task_complete(req, &ts);
> +	}

Looks fine,

Reviewed-by: Ming Lei <ming.lei@redhat.com>

BTW, looks a little IOPS improvement is observed when running t/io_uring
on ublk/null with two queues, but not very obvious.

Thanks,
Ming

