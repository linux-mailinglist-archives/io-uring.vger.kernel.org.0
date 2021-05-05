Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0633746E7
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 19:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236555AbhEERcW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 13:32:22 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:54840 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240424AbhEERVJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 13:21:09 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:34470 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1leLC0-0005A1-8j
        for io-uring@vger.kernel.org; Wed, 05 May 2021 13:20:12 -0400
Message-ID: <be598e94e5acee2fd7d2dfff7fb31302de8c8525.camel@trillion01.com>
Subject: Re: IORING_OP_POLL_ADD/IORING_OP_POLL_REMOVE questions
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring <io-uring@vger.kernel.org>
Date:   Wed, 05 May 2021 13:20:11 -0400
In-Reply-To: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
References: <8992f5f989808798ad2666b0a3ef8ae8d777b7de.camel@trillion01.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 2021-05-04 at 14:06 -0400, Olivier Langlois wrote:
> 
> 1. 195 is the cqe result for a successful IORING_OP_POLL_ADD
> submission. I only check the POLLIN|POLLOUT bits. What is the meaning
> of the other bits?

I did answer myself for question #1:

fs/io_uring.c:
static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int
error)
{
        struct io_ring_ctx *ctx = req->ctx;

        io_poll_remove_double(req);
        req->poll.done = true;
        io_cqring_fill_event(req, error ? error : mangle_poll(mask));
        io_commit_cqring(ctx);
}

include/linux/poll.h:
#define __MAP(v, from, to) \
        (from < to ? (v & from) * (to/from) : (v & from) / (from/to))

static inline __u16 mangle_poll(__poll_t val)
{
        __u16 v = (__force __u16)val;
#define M(X) __MAP(v, (__force __u16)EPOLL##X, POLL##X)
        return M(IN) | M(OUT) | M(PRI) | M(ERR) | M(NVAL) |
                M(RDNORM) | M(RDBAND) | M(WRNORM) | M(WRBAND) |
                M(HUP) | M(RDHUP) | M(MSG);
#undef M
}

=195
=0xC3
=1100 0011
// from bits/poll.h:
=POLLIN|POLLPRI|POLLRDNORM|POLLRDBAND

The fd for which I get this result is a TCP socket on which the
WebSocket protocol over SSL is implemented.

Does anyone knows if WebSocket and/or TLS/SSL protocols are using TCP
out-of-band?

AFAIK (but I don't much), they don't...

Or maybe Linux poll implementation simply turns on these bits all the
time...

Bottomline, it is unrelated with io_uring but help for my 2 other
questions is still welcomed.

Greetings,
> 
> 2. I don't understand what I am looking at. Why am I receiving a
> completion notification for a POLL request that has just been
> cancelled? What is the logic behind silently discarding a
> IORING_OP_POLL_ADD sqe meant to replace an existing one?
> 
> 3. As I am writing this email, I have just noticed that it was possible
> to update an existing POLL entry with IORING_OP_POLL_REMOVE through
> io_uring_prep_poll_update(). Is this what I should do to eliminate my
> problems? What are the possible race conditions scenarios that I should
> be prepared to handle by using io_uring_prep_poll_update() (ie:
> completion of the poll entry to update while my process is inside
> io_uring_enter() to update it...)?
> 
> thx a lot for your guidance in my io_uring journey!
> Olivier
> 
> 


