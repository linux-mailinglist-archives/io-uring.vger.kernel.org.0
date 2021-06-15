Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC20D3A7C5E
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 12:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFOKt5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Jun 2021 06:49:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55678 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbhFOKt5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Jun 2021 06:49:57 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lt6bn-0003hN-Qd; Tue, 15 Jun 2021 10:47:51 +0000
Subject: Re: [PATCH][next] io_uring: Fix incorrect sizeof operator for
 copy_from_user call
From:   Colin Ian King <colin.king@canonical.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210615104541.50529-1-colin.king@canonical.com>
Message-ID: <3dcc6900-8361-d52c-003d-21318aa80156@canonical.com>
Date:   Tue, 15 Jun 2021 11:47:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210615104541.50529-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 15/06/2021 11:45, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Static analysis is warning that the sizeof being used is should be
> of *data->tags[i] and not data->tags[i]. Although these are the same
> size on 64 bit systems it is not a portable assumption to assume
> this is true for all cases.
> 
> Addresses-Coverity: ("Sizeof not portable")
> Fixes: d878c81610e1 ("io_uring: hide rsrc tag copy into generic helpers")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  fs/io_uring.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index d665c9419ad3..6b1a70449749 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7231,7 +7231,7 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
>  		ret = -EFAULT;
>  		for (i = 0; i < nr; i++) {
>  			if (copy_from_user(io_get_tag_slot(data, i), &utags[i],
> -					   sizeof(data->tags[i])))
> +					   sizeof(*data->tags[i])))
>  				goto fail;
>  		}
>  	}
> 

Actually, I think there is also an issue on line 7220 too, I'll fix that
and re-send.
