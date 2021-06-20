Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8321F3AE086
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 23:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhFTVID (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 17:08:03 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:48598 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbhFTVIC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 17:08:02 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33266 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lv4dZ-0000jM-6S; Sun, 20 Jun 2021 17:05:49 -0400
Message-ID: <86a768ba44d3d2009c313bd2b7ddf25e2a3f4b5e.camel@trillion01.com>
Subject: Re: [PATCH v2] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Jun 2021 17:05:48 -0400
In-Reply-To: <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
References: <e4614f9442d971016f47d69fbcba226f758377a8.1624215754.git.olivier@trillion01.com>
         <61668060-6401-ccc0-06e8-29d6320b720a@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
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

On Sun, 2021-06-20 at 20:56 +0100, Pavel Begunkov wrote:
> On 6/20/21 8:05 PM, Olivier Langlois wrote:
> > 
> >  
> > -static bool io_arm_poll_handler(struct io_kiocb *req)
> > +#define IO_ARM_POLL_OK    0
> > +#define IO_ARM_POLL_ERR   1
> > +#define IO_ARM_POLL_READY 2
> 
> Please add a new line here. Can even be moved somewhere
> to the top, but it's a matter of taste.

If you let me decide, I prefer to let them close to where they are
used. There is so much data definitions in the heading section that I
feel like putting very minor implementation details to it might
overwhelm newcomers instead of helping them to grasp the big picture.

but I will add an extra space as you request
> 
> Also, how about to rename it to apoll? io_uring internal
> rw/send/recv polling is often abbreviated as such around
> io_uring.c
> IO_APOLL_OK and so on.

no problem. I will.
> 
> > +static int io_arm_poll_handler(struct io_kiocb *req)
> >  {
> >         const struct io_op_def *def = &io_op_defs[req->opcode];
> >         struct io_ring_ctx *ctx = req->ctx;
> > @@ -5153,22 +5156,22 @@ static bool io_arm_poll_handler(struct
> > io_kiocb *req)
> >         int rw;
> >  
> >         if (!req->file || !file_can_poll(req->file))
> > -               return false;
> > +               return IO_ARM_POLL_ERR;
> 
> It's not really an error. Maybe IO_APOLL_ABORTED or so?

Ok.


