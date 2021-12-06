Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3DD46A6D5
	for <lists+io-uring@lfdr.de>; Mon,  6 Dec 2021 21:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349521AbhLFU1o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Dec 2021 15:27:44 -0500
Received: from cloud48395.mywhc.ca ([173.209.37.211]:40050 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349484AbhLFU1o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Dec 2021 15:27:44 -0500
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:37824 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1muJvK-000064-6P; Mon, 06 Dec 2021 14:45:18 -0500
Message-ID: <d24e640e0a29c490ae2e875244ee2116c85951b5.camel@trillion01.com>
Subject: Re: [PATCH] Fix typo "timout" -> "timeout"
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Date:   Mon, 06 Dec 2021 14:45:17 -0500
In-Reply-To: <3544387d-1e83-4422-213c-569f4447b3fa@kernel.dk>
References: <cceed63f-aae7-d391-dbc3-776fcac93afe@kernel.dk>
         <20211005223010.741474-1-ammar.faizi@students.amikom.ac.id>
         <3544387d-1e83-4422-213c-569f4447b3fa@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.1 
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

On Tue, 2021-10-05 at 16:41 -0600, Jens Axboe wrote:
> On 10/5/21 4:30 PM, Ammar Faizi wrote:
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Olivier Langlois <olivier@trillion01.com>
> > Fixes: a060c8e55a6116342a16b5b6ac0c4afed17c1cd7 ("liburing: Add
> > io_uring_submit_and_wait_timeout function in API")
> > Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
> > ---
> > 
> > It seems Olivier got rushed a bit when writing this. How did you
> > test this?
> 
> Ugh indeed. Olivier, did you test this at all? I missed this when
> reviewing
> it, but I would assume that writing a separate test would have caught
> it.
> Said test should go into liburing as well, fwiw. Can you please
> submit it?
> 
Jens, Ammar,

I am very sorry for the typo and yes I was in a rush because I have
been in a dev crunch for the last 2 months. I barely start to
resurface.

That beind said, I have been very careful in my testing.

I did run the liburing timeout unittest to make sure that the patch did
not break io_uring_wait_cqes() and I have tested the new function in my
own application where the problem got detected in the first place.

https://github.com/axboe/liburing/issues/429#issuecomment-917331678

I can assure you that the new function works perfectly well despite the
typo.

The silly typo has totally escaped my attention so thank you Ammar to
have spotted it and fixed it.

I should have some time soon to submit an addition to the timeout
unittest to test the new io_uring_submit_and_wait_timeout function. I
have put this small task on my todo list.

Greetings,

