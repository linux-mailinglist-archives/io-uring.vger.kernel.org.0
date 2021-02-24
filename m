Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DD5324366
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 18:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbhBXR5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 12:57:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbhBXR5D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 12:57:03 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36ECC06174A
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 09:56:22 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id u187so625779wmg.4
        for <io-uring@vger.kernel.org>; Wed, 24 Feb 2021 09:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VAgNlmQtHCYjmLgn2pEgy2YlSInYFUbWfB7WCus+Hno=;
        b=KIY0IJSC6dO6hBGVXThIK6ZuP4G4dlBmUuPpSrn+3V3bEnhmHpRRyWUjX6QROCVtrN
         pHJo3DW5yScei/3hiOH0ZRwnlk7NDe8UjhDmUv2+thiILiKa/uGlfcMHB98vRMFoQ3KQ
         qH64yhBACeEJK/EzDNjiemZbYXmsz2mrPn7RPc5wjyN/CFNBKhlSaisJPbVnKZgiKpHx
         cNVImH3YlWzyBogu0LBfRJ+vBUzqO3CcqFwpR0ygmxnNfsXkwTCd5eHrL9ET+BZLIf1s
         PgkYDOM8artPop5XFu4eg3tJc6PJxA+3vLEEl8TWiDd+sRF3MxB5z+NLVec6TISr827E
         vYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VAgNlmQtHCYjmLgn2pEgy2YlSInYFUbWfB7WCus+Hno=;
        b=mpLd/9jPRGJ9k+UUguZXvWWrLyloR9eDCqtrehjW2OHPjhgKds+Yw71DRhN/3qLJko
         CoeiPUtA4ZDNvOA6zksIMvDgC7W+H7xcIB+sRFESPvEM1kBKiI7vvrAcwFEWgPKTe34Q
         +bqW96iX7zbCM1CTRBwjK7DGoJjgGlj9d1KzYuA8VCbCgrymd31GJtdbEQ6S9VfmwRYC
         zSosHIZpo30GnpvTAVHssQ3VpbRNYeaCC4vspwSPPQXZwS5DQIAQcosQoJBt5oyJJ9/G
         RgznsRXMJU/J7vpO+FH4pQEqkCzJ861//zFN07SXo1iXvXcvIO9LDbOpG+a345yBaG0N
         fYug==
X-Gm-Message-State: AOAM5314lrJjIE2Vzvvzq+JuxuddhzVGAVFZdUGXbpDm+6N357+oVkX1
        OUJyf9gMA7eKOMXXRlkOl3p6g5aZwf98XA==
X-Google-Smtp-Source: ABdhPJyqlNqT8eU59wHrhIEwXxJhfBrmKFJd0Dkv4tpoH4D/ad+Anw9S65b1KKUrYaGmT9rmWwCQqg==
X-Received: by 2002:a7b:c249:: with SMTP id b9mr4739186wmj.99.1614189381437;
        Wed, 24 Feb 2021 09:56:21 -0800 (PST)
Received: from [192.168.8.165] ([148.252.129.28])
        by smtp.gmail.com with ESMTPSA id t2sm4763849wrx.23.2021.02.24.09.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 09:56:20 -0800 (PST)
Subject: Re: io_uring: defer flushing cached reqs
To:     Colin Ian King <colin.king@canonical.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <92a9a01a-561d-1d72-61c6-a68842364227@canonical.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <6afb8222-ce8e-5bfa-8684-9380f45c6d7f@gmail.com>
Date:   Wed, 24 Feb 2021 17:52:29 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <92a9a01a-561d-1d72-61c6-a68842364227@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 24/02/2021 17:15, Colin Ian King wrote:
> Hi,
> 
> Static analysis on linux-next with Coverity has detected a potential
> issue with the following commit:
> 
> commit e5d1bc0a91f16959aa279aa3ee9fdc246d4bb382
> Author: Pavel Begunkov <asml.silence@gmail.com>
> Date:   Wed Feb 10 00:03:23 2021 +0000
> 
>     io_uring: defer flushing cached reqs
> 
> 
> The analysis is as follows:
> 
> 1679 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
> 1680 {
> 1681        struct io_submit_state *state = &ctx->submit_state;
> 1682
>     1. Condition 0 /* !!(8 > sizeof (state->reqs) / sizeof
> (state->reqs[0]) + (int)sizeof (struct io_alloc_req::[unnamed type]))
> */, taking false branch.
> 
> 1683        BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
> 1684
> 
>     2. Condition !state->free_reqs, taking true branch.
>     3. cond_const: Checking state->free_reqs implies that
> state->free_reqs is 0 on the false branch.
> 
> 1685        if (!state->free_reqs) {
> 1686                gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
> 1687                int ret;
> 1688
> 
>     4. Condition io_flush_cached_reqs(ctx), taking true branch.
> 
> 1689                if (io_flush_cached_reqs(ctx))
> 
>     5. Jumping to label got_req.
> 
> 1690                        goto got_req;
> 1691
> 1692                ret = kmem_cache_alloc_bulk(req_cachep, gfp,
> IO_REQ_ALLOC_BATCH,
> 1693                                            state->reqs);
> 1694
> 1695                /*
> 1696                 * Bulk alloc is all-or-nothing. If we fail to get a
> batch,
> 1697                 * retry single alloc to be on the safe side.
> 1698                 */
> 1699                if (unlikely(ret <= 0)) {
> 1700                        state->reqs[0] =
> kmem_cache_alloc(req_cachep, gfp);
> 1701                        if (!state->reqs[0])
> 1702                                return NULL;
> 1703                        ret = 1;
> 1704                }
> 1705                state->free_reqs = ret;
> 1706        }
> 1707got_req:
> 
>     6. decr: Decrementing state->free_reqs. The value of
> state->free_reqs is now 4294967295.
> 
> 1708        state->free_reqs--;
> 
> Out-of-bounds read (OVERRUN)
>     7. overrun-local: Overrunning array state->reqs of 32 8-byte
> elements at element index 4294967295 (byte offset 34359738367) using
> index state->free_reqs (which evaluates to 4294967295).
> 
> 1709        return state->reqs[state->free_reqs];
> 1710}
> 
> If state->free_reqs is zero and io_flush_cached_reqs(ctx) is true, then

It returns true IFF it incremented state->free_reqs, so should be
a false positive. I'll clean the function up a bit for next, might
help the tool.


> we end up on line 1708 decrementing the unsigned int state->free_reqs so
> this wraps around to 4294967295 causing an out of bounds read on
> state->reqs[].
> 
> Colin
> 

-- 
Pavel Begunkov
