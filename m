Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1BA324308
	for <lists+io-uring@lfdr.de>; Wed, 24 Feb 2021 18:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233315AbhBXRQR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Feb 2021 12:16:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35282 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbhBXRQQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Feb 2021 12:16:16 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212])
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lExl7-0004I4-2X; Wed, 24 Feb 2021 17:15:33 +0000
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
From:   Colin Ian King <colin.king@canonical.com>
Subject: re: io_uring: defer flushing cached reqs
Message-ID: <92a9a01a-561d-1d72-61c6-a68842364227@canonical.com>
Date:   Wed, 24 Feb 2021 17:15:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Static analysis on linux-next with Coverity has detected a potential
issue with the following commit:

commit e5d1bc0a91f16959aa279aa3ee9fdc246d4bb382
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Wed Feb 10 00:03:23 2021 +0000

    io_uring: defer flushing cached reqs


The analysis is as follows:

1679 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
1680 {
1681        struct io_submit_state *state = &ctx->submit_state;
1682
    1. Condition 0 /* !!(8 > sizeof (state->reqs) / sizeof
(state->reqs[0]) + (int)sizeof (struct io_alloc_req::[unnamed type]))
*/, taking false branch.

1683        BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
1684

    2. Condition !state->free_reqs, taking true branch.
    3. cond_const: Checking state->free_reqs implies that
state->free_reqs is 0 on the false branch.

1685        if (!state->free_reqs) {
1686                gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
1687                int ret;
1688

    4. Condition io_flush_cached_reqs(ctx), taking true branch.

1689                if (io_flush_cached_reqs(ctx))

    5. Jumping to label got_req.

1690                        goto got_req;
1691
1692                ret = kmem_cache_alloc_bulk(req_cachep, gfp,
IO_REQ_ALLOC_BATCH,
1693                                            state->reqs);
1694
1695                /*
1696                 * Bulk alloc is all-or-nothing. If we fail to get a
batch,
1697                 * retry single alloc to be on the safe side.
1698                 */
1699                if (unlikely(ret <= 0)) {
1700                        state->reqs[0] =
kmem_cache_alloc(req_cachep, gfp);
1701                        if (!state->reqs[0])
1702                                return NULL;
1703                        ret = 1;
1704                }
1705                state->free_reqs = ret;
1706        }
1707got_req:

    6. decr: Decrementing state->free_reqs. The value of
state->free_reqs is now 4294967295.

1708        state->free_reqs--;

Out-of-bounds read (OVERRUN)
    7. overrun-local: Overrunning array state->reqs of 32 8-byte
elements at element index 4294967295 (byte offset 34359738367) using
index state->free_reqs (which evaluates to 4294967295).

1709        return state->reqs[state->free_reqs];
1710}

If state->free_reqs is zero and io_flush_cached_reqs(ctx) is true, then
we end up on line 1708 decrementing the unsigned int state->free_reqs so
this wraps around to 4294967295 causing an out of bounds read on
state->reqs[].

Colin
