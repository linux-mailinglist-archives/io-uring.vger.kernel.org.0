Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D4D39E864
	for <lists+io-uring@lfdr.de>; Mon,  7 Jun 2021 22:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhFGU2l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 16:28:41 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:38868 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFGU2l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 16:28:41 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:53870 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lqLph-0005j6-EN
        for io-uring@vger.kernel.org; Mon, 07 Jun 2021 16:26:49 -0400
Message-ID: <439fa5114eb2bf0914e11c2a0c97798885c7d83f.camel@trillion01.com>
Subject: Possible unneccessary IORING_OP_READs executed in Async
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring@vger.kernel.org
Date:   Mon, 07 Jun 2021 16:26:49 -0400
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
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

Hi,

I was trying to understand why I was ending up with io worker threads
when io_uring fast polling should have been enough to manage my read
operations.

I have found 2 possible scenarios:

1. Concurrent read requests on the same socket fd.

I have documented this scenario here:
https://github.com/axboe/liburing/issues/351

In a nutshell, the idea is if 2 read operations on the same fd are
queued in io_uring fast poll, on the next io_uring_cqring_wait() call
if events become available on the fd, the first serviced request will
grab all the available data and this will push the second request in
the io-wq because when it will be serviced, the read will return EAGAIN
and req->flags will have REQ_F_POLLED set.

I was supposed to investigate my application to find out why it is
doing that but I have put the investigation on hold to fix the core
dump generation problem that I was experiencing with io_uring. I did
solve that mystery BTW.

io_uring interrupts the core generation by setting TIF_NOTIFY_SIGNAL
through calling task_work_add().
(I have sent out a patch last week that seems to have fallen in
/dev/null. I need resend it...)

Now that I am back to my io worker threads creation concern, I am not
able to recreate scenario #1 but I have found a second way that io-
workers can be spawned:

2.

In __io_queue_sqe():
a) io_issue_sqe() returns EAGAIN
b) in between io_issue_sqe() call and vfs_poll() call done inside
io_arm_poll_handler(), data becomes available
c) io_arm_poll_handler() returns false because vfs_poll() did return an
non-empty mask.

I am throwing this idea to the group.
Would it be a good idea to detect that situation and recall
io_issue_sqe() in that case instead of pushing the request to the io-
wq?

On busy TCP sockets, this scenario seems to happen very often (ie: few
times every second)

Greetings,
Olivier

