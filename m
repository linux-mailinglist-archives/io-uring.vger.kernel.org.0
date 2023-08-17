Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4EF77FFD8
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 23:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237060AbjHQV0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 17:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355365AbjHQV0D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 17:26:03 -0400
Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B4935B6
        for <io-uring@vger.kernel.org>; Thu, 17 Aug 2023 14:25:37 -0700 (PDT)
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
        by cmsmtp with ESMTP
        id We1vq0CC3QFHRWkUTqnn2O; Thu, 17 Aug 2023 21:25:14 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTPS
        id WkUTqY98KDHerWkUTqlJUP; Thu, 17 Aug 2023 21:25:13 +0000
X-Authority-Analysis: v=2.4 cv=MN5zJeVl c=1 sm=1 tr=0 ts=64de9039
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=WzbPXH4gqzPVN0x6HrNMNA==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=UttIx32zK-AA:10 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8
 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8 a=8-QigG1ummv6mNus-HEA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=e8YoEXhrx8Kg5FTV+4AZj/HZVi/cqxAEu7i4SHZBseI=; b=JoiqbaIXFh10f+1xFU+cs1CRjL
        0wTnLOsSGUeDQLQDPn+PGp+gXAy/cj49WRuOduSrBAMXhYCqTOPm/ZR+ddowmNvOtb7okaLl+51pR
        Tb//b1dP1FFWN1CxkC/Mv/rZq4hNp86dxlEK9Zet3fWeFWtGEmiNim0TkmfLPRvhkq60n45UPWchJ
        NKTEqZ9dB7xR4H/CrCEArePagfgyf27UomxCzlqqZJf9dXviDD6YuXNswEehdHDFKkay/hlnZ5LcO
        /pK1W9Uz8flUiCTbcMOuOqT8aVFKDOUbDIzJES9+y1ixWY80iYccC4Ss7h8XNPaHZ27KIrM2CZdCu
        7xv0MRxQ==;
Received: from 187-162-21-192.static.axtel.net ([187.162.21.192]:49904 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.96)
        (envelope-from <gustavo@embeddedor.com>)
        id 1qWkUS-001nHK-13;
        Thu, 17 Aug 2023 16:25:12 -0500
Message-ID: <656be1ad-d2f2-91c5-b250-436699d8513b@embeddedor.com>
Date:   Thu, 17 Aug 2023 15:26:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] io_uring/rsrc: Annotate struct io_mapped_ubuf with
 __counted_by
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
References: <20230817212146.never.853-kees@kernel.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20230817212146.never.853-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.21.192
X-Source-L: No
X-Exim-ID: 1qWkUS-001nHK-13
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-21-192.static.axtel.net ([192.168.15.8]) [187.162.21.192]:49904
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 152
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfE6/GtcW9KjWQQj0eTiyfjpmoZmavNbq/tLRunUayeanD/ILvCxXN+HqknFMukWckQcDxjWcURjahKglEesyjmuvkmPqz4y79HfnPtoslfGXARy7OfDl
 5PkA6BiAGedCQAKPvPq/siLXl1l9lgWVpSM4fKEb+IF1FkYwaE4w8rsCWmyAclQPTYr0M4GN5w0ixTKNhF1fcRPbX0HHqV+NQW8=
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 8/17/23 15:21, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct io_mapped_ubuf.
> 
> [1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci
> 
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Cc: io-uring@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>   io_uring/rsrc.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 8afa9ec66a55..8625181fb87a 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -54,7 +54,7 @@ struct io_mapped_ubuf {
>   	u64		ubuf_end;
>   	unsigned int	nr_bvecs;
>   	unsigned long	acct_pages;
> -	struct bio_vec	bvec[];
> +	struct bio_vec	bvec[] __counted_by(nr_bvecs);
>   };
>   
>   void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
