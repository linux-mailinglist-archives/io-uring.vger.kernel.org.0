Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B02A3A3374
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 20:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhFJSoG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 14:44:06 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:38922 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhFJSoF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 14:44:05 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51980 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lrPd2-0003Bq-Vn
        for io-uring@vger.kernel.org; Thu, 10 Jun 2021 14:42:09 -0400
Message-ID: <2b29a1ceb81ec91371fb1835eec4471c7254402e.camel@trillion01.com>
Subject: Re: IOSQE_BUFFER_SELECT buffer returned even in case of failure?
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring@vger.kernel.org
Date:   Thu, 10 Jun 2021 14:42:08 -0400
In-Reply-To: <57ba227ebda93e653854d272d288cd65a57dd127.camel@trillion01.com>
References: <57ba227ebda93e653854d272d288cd65a57dd127.camel@trillion01.com>
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

On Wed, 2021-06-09 at 15:19 -0400, Olivier Langlois wrote:
> the man page says the following:
> 
>     If succesful, the resulting CQE will have IORING_CQE_F_BUFFER set
> in the flags part of the struct, and the upper
> IORING_CQE_BUFFER_SHIFT
> bits will contain the ID of the selected buffers.
> 
> based on my understanding of the kernel code (it could wrong. testing
> is still ongoing to be 100% sure), the buffer will be returned even
> if
> the underlying syscall fails. (I have only checked io_read() for
> IORING_OP_READ).
> 
> At the minimum, the man page should be clarified to better reflect
> the
> code behavior. (and there is a missing 's' in succesful)
> 
> ideally, imho, I believe the code should be modified to do what the
> man
> page says because:
> 
> 1. doing otherwise is counter-intuitive and error-prone (I cannot
> think
> of a single example of a syscall failing and still require the user
> to
> free the allocated resources)
> 
> 2. it is inefficient because the buffer is unneeded since there is no
> data to transfer back to the user and the buffer will need to be
> returned back to io_uring to avoid a leak.
> 
I have confirmed that a buffer was returned and needed to be provided
back io_uring even when read() syscall was failing.

It failed with ECONNRESET with obviously no data and I still had to
return back the buffer to avoid a leak (which my app was suffering of).

Unless someone says that it works as designed, I'll figure out a way to
fix that with a patch. It should be trivial to do.

Greetings,
Olivier


