Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8FF331039
	for <lists+io-uring@lfdr.de>; Mon,  8 Mar 2021 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbhCHN6R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Mar 2021 08:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhCHN57 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Mar 2021 08:57:59 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54DAC06174A
        for <io-uring@vger.kernel.org>; Mon,  8 Mar 2021 05:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=tP2rQWsowyaryoX8mX2RLsPe4tlmF+ZPuEoX+XLXe6c=; b=FjHPDToZFkgcIR4I4K+WGj6k6D
        qOHodYw/j0mXV6kgCAYZa57WU9bzJ3J8qqujW/fpbS6l5CO3KB8SojBFzaQXmILHQKKOVXSePDYgA
        XTiMamKw3Y2yJfbj2fEWVQM5SabQ3zIFTKYsQXXo4eNQtfE5Edbah2fuvxFBbW6YxVv5/i7+PdYpd
        yW2Mwv6w+l/B0ldu3NlJ1Jjn/yM4Hr+be+4k2LmdohvgFPonIK12A5m1Cw6gafZrMo/H+AAAKQ2m7
        oe4Q3g7n1w1yes6gJBeJwDRXRSjzy4izVjT+k2N9SutNYWC/EEvzF7U1Gaua3MT6J0TfGdH2khJD0
        7b8QMp4Kz8CC9F7kDGVd/zyJjJdH0G7+cqIX5ASNw+/KnLaoetkdAtIPgUp+dA7Yzkstzolyh8jlH
        n+qy/0nyfofjl5zFgvFH7b9gZ25mDVP6/3sFy+rUzeGUVeWxXfP6BQvfu/To26S6pPX9hrYTzblFN
        rIKSpcriaYyRWKP+mX624YNV;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1lJGOP-0001gK-G9; Mon, 08 Mar 2021 13:57:53 +0000
Subject: Re: [PATCH 1/2] io_uring: fix UAF for personality_idr
To:     Matthew Wilcox <willy@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     yangerkun <yangerkun@huawei.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org, yi.zhang@huawei.com
References: <20210308065903.2228332-1-yangerkun@huawei.com>
 <e4b79f4d-c777-103d-e87e-d72dc49cb440@gmail.com>
 <20210308132001.GA3479805@casper.infradead.org>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <6c7a534e-6823-eb70-8788-0cb48eab10d6@samba.org>
Date:   Mon, 8 Mar 2021 14:57:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210308132001.GA3479805@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Matthew,

> -	ret = idr_alloc_cyclic(&ctx->personality_idr, (void *) creds, 1,
> -				USHRT_MAX, GFP_KERNEL);
> -	if (ret < 0)
> -		put_cred(creds);
> +	ret = xa_alloc_cyclic(&ctx->personalities, &id, (void *)creds,
> +			XA_LIMIT(0, USHRT_MAX), &ctx->pers_next, GFP_KERNEL);
> +	if (!ret)
> +		return id;
> +	put_cred(creds);
>  	return ret;

I guess this should be XA_LIMIT(1, USHRT_MAX) instead?
'0' should not be a valid id.

metze
