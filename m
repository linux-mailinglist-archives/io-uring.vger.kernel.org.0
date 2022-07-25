Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1721A57FEE2
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 14:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiGYMWE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 08:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbiGYMWA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 08:22:00 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920421AD8E
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 05:21:59 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 0DB537E328;
        Mon, 25 Jul 2022 12:21:57 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658751719;
        bh=QsDY/YPjarBuN8OjLrDcNpRwFRScV2ZunQnU3PT8iXc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Rr1XHKmU1oI5zyD+W83cLQpJ7fyU0CAJb77GKc/7iL3AVakZNLyMbxMG+FpbawLf2
         D3tW/ZusYcNPBTSU8uJxRI8Arx95jnngN4ktXVjf3h98retPZRZV6oIenNnTMMZ/Ks
         LVnyZ2VEk7xMz4tkuqYUfP7se1XLy4VaF3wlQasZHg19LHjrXeGsAjwOmrPwF8/ER/
         Cnux5yHZVVMZ2DEQYEzYMHeiF9tQNkgsgK7erGrrS+vAwwclas0+CJURnqZCE/6aTx
         XS8Ipfb89qmdwAnPRiIJksRxJuvjiERe34YxoHTZzOpQG+cUvlARk2KKDA6mfrpakg
         YaFZbPybHO17Q==
Message-ID: <66044140-0ac5-ad3d-11bf-97b2bf70ceeb@gnuweeb.org>
Date:   Mon, 25 Jul 2022 19:21:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing v2 5/5] liburing: improve fallocate typecasting
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>
References: <cover.1658748623.git.asml.silence@gmail.com>
 <bbcd93f438c60073bb06ae7ab02f6ebd770ecdcb.1658748624.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <bbcd93f438c60073bb06ae7ab02f6ebd770ecdcb.1658748624.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 6:33 PM, Pavel Begunkov wrote:
> Don't double cast int -> ptr -> int in io_uring_prep_fallocate(), assign
> len directly.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   src/include/liburing.h | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
[...]
>   	io_uring_prep_rw(IORING_OP_FALLOCATE, sqe, fd,
> -			(const uintptr_t *) (unsigned long) len,
> -			(unsigned int) mode, (__u64) offset);
> +			0, (unsigned int) mode, (__u64) offset);

nit: instead of 0 it's better to use NULL. No?

> +	sqe->addr = (__u64) len;

This one looks simpler than a double cast.

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

