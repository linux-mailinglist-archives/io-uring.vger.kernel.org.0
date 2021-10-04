Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770A5421253
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 17:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235547AbhJDPJi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 11:09:38 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:40536 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbhJDPJi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 11:09:38 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:53586 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mXPZE-0001VZ-L7; Mon, 04 Oct 2021 11:07:48 -0400
Message-ID: <18229fc80d15c9c8a963cf1b206bf12a2c7ea4a7.camel@trillion01.com>
Subject: Re: [PATCH] liburing: Add io_uring_submit_and_wait_timeout function
 in API
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Date:   Mon, 04 Oct 2021 11:07:48 -0400
In-Reply-To: <ae2fbe14-052e-748c-d187-9021a06790b0@kernel.dk>
References: <86271fc62d96470896b9edc88036072f051a788f.1633354465.git.olivier@trillion01.com>
         <ae2fbe14-052e-748c-d187-9021a06790b0@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

On Mon, 2021-10-04 at 08:38 -0600, Jens Axboe wrote:
> 
> I'd get rid of the likely/unlikely, imho it just hinders readability
> and for some cases they may end up being wrong. You also don't need
> an
> else when there's a return, and if you use braces on one condition,
> use
> it for all. IOW, something like:
> 
>         if (ts) {
>                 if (ring->features & IORING_FEAT_EXT_ARG) {
>                         struct io_uring_getevents_arg arg = {
>                                 .sigmask        = (unsigned long)
> sigmask,
>                                 .sigmask_sz     = _NSIG / 8,
>                                 .ts             = (unsigned long) ts
>                         };
>                         struct get_data data = {
>                                 .submit         =
> __io_uring_flush_sq(ring),
>                                 .wait_nr        = wait_nr,
>                                 .get_flags      =
> IORING_ENTER_EXT_ARG,
>                                 .sz             = sizeof(arg),
>                                 .arg            = &arg
>                         };
> 
>                         return _io_uring_get_cqe(ring, cqe_ptr,
> &data);
>                 }
>                 return io_uring_wait_cqes(ring, cqe_ptr, wait_nr, ts,
> sigmask);
>         }
> 
>         return __io_uring_get_cqe(ring, cqe_ptr,
> __io_uring_flush_sq(ring),
>                                           wait_nr, sigmask);
> 
> which is a lot more readable too.
> 

ok. I will do as you suggest. I agree with the readability argument.

However, I believe that the likely events were correctly identified as
if ts is NULL, you should be calling io_uring_submit_and_wait() instead
of this new function.

and the second condition as no other choice to become more and more
likely as the time pass.

That being said, out of my old memories, I remember that if you want to
optimize code manually to help x86 branch prediction algo, you can do
so by crafting the conditional expression to be true for the most
likely case so what you propose still keep the same flow implicitly
(with better readability).

Since submission, I got another improvement idea that I will integrate
in v2.

I am leveraging io_uring_wait_cqes() code for the case where the kernel
is old and timeout must be passed as an extra sqe.

1. It is brittle. If someone change that part of io_uring_wait_cqes(),
he could unknowingly break io_uring_submit_and_wait_timeout().
2. The intent behind calling io_uring_wait_cqes from
io_uring_submit_and_wait_timeout isn't 100% clear IMHO.

I am thinking factoring out the common code into a static function.
Considering that running over an old kernel should, hopefully, become a
rare event, the extra function call shouldn't be a too big issue to
reach a better readability.


