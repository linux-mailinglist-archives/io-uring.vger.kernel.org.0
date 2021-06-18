Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8B3AD47A
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 23:38:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFRVkX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 17:40:23 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:54136 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230399AbhFRVkW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 17:40:22 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33082 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1luMBo-0003I9-9r; Fri, 18 Jun 2021 17:38:12 -0400
Message-ID: <489a3a2ded1daf962b8bfa3c936e20526b975d1a.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 18 Jun 2021 17:38:11 -0400
In-Reply-To: <ff0aab90-9aef-4ec6-f00f-89d4ffa21ef6@kernel.dk>
References: <60c13bec.1c69fb81.f2c1e.6444SMTPIN_ADDED_MISSING@mx.google.com>
         <ff0aab90-9aef-4ec6-f00f-89d4ffa21ef6@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
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

On Wed, 2021-06-16 at 06:48 -0600, Jens Axboe wrote:
> On 6/9/21 4:08 PM, Olivier Langlois wrote:
> > It is quite frequent that when an operation fails and returns
> > EAGAIN,
> > the data becomes available between that failure and the call to
> > vfs_poll() done by io_arm_poll_handler().
> > 
> > Detecting the situation and reissuing the operation is much faster
> > than going ahead and push the operation to the io-wq.
> 
> I think this is obviously the right thing to do, but I'm not too
> crazy
> about the 'ret' pointer passed in. We could either add a proper
> return
> type instead of the bool and use that, or put the poll-or-queue-async
> into a helper that then only needs a bool return, and use that return
> value for whether to re-issue or not.
> 
> Care to send an updated variant?
> 
No problem!

It is going to be pleasure to send an updated version with the
requested change!

I will take that opportunity to try out my new patch sending setup ;-)


