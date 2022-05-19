Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FD752CC5B
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 09:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiESHDL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 03:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiESHDK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 03:03:10 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84540275;
        Thu, 19 May 2022 00:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7u2c7SfZw4F2WE/l0TOBqN1etCbMDPzaGXFTwtFLUR4=; b=AozOtmYYEJqF6EhHgojTQIbAQ+
        p4IjDmwTWU9+pgZ6DB8MVOw/rbIOQCCOaHvHL2taHp0oJjgTNG8OEo9S0iC+9jT90vFelThaNKpca
        S1jtSV3FfNZCatApiHLF4UwsoZz/Upju/uMnezte0iIWzC/RUQVJhDKeTKeI1dpA1VerZpDJIZGrj
        QGkzfk6zSr3L9nLOtiOXHtGziqiVAjw286fOk70iEwYEDlZTW2EUAiKF59gGCshI21dMM9zODBa3e
        7Wfb6EnmcPgFm4V0xQuEnFiouW4IvqU4VCVlTJi6ifnm3HHOdiluCVCeypiP6WdNFTzU8lDrNP2IZ
        fRyVRfow==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nraBf-005Pls-LU; Thu, 19 May 2022 07:03:07 +0000
Date:   Thu, 19 May 2022 00:03:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>, kernel@openvz.org,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, io-uring@vger.kernel.org
Subject: Re: [PATCH v2] io_uring: fix sparce warnings about __kernel_rwf_t
 casts
Message-ID: <YoXrq23tjl1v3YD0@infradead.org>
References: <YoHu+HvaDcIpC7gI@infradead.org>
 <7de7721b-d090-6400-9a74-30ecb696761b@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7de7721b-d090-6400-9a74-30ecb696761b@openvz.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 18, 2022 at 12:20:46PM +0300, Vasily Averin wrote:
> __kernel_rwf_t type is bitwise and requires __force attribute for casts.
> 
> To fix the warnings, the patch changes the type of fields in the
> corresponding structures: poll32_events and rw_flags are neighbours
> in the same union.

Jens actually picked up a series from me that picked up most of this,
except for this hunk:

> index cddf5b6fbeb4..34839f30caee 100644
> --- a/include/trace/events/io_uring.h
> +++ b/include/trace/events/io_uring.h
> @@ -520,7 +520,7 @@ TRACE_EVENT(io_uring_req_failed,
>  		__entry->off		= sqe->off;
>  		__entry->addr		= sqe->addr;
>  		__entry->len		= sqe->len;
> -		__entry->op_flags	= sqe->rw_flags;
> +		__entry->op_flags	= sqe->poll32_events;
>  		__entry->buf_index	= sqe->buf_index;
>  		__entry->personality	= sqe->personality;
>  		__entry->file_index	= sqe->file_index;

For which I did not see a warning even if it looks real to me.
But this union with basically a lot of __u32s here looks pretty
strange to start with to me.
