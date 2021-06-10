Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD433A328E
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 19:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhFJR6x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 13:58:53 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:51810 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhFJR6x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 13:58:53 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51978 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lrOvG-0000o2-5S; Thu, 10 Jun 2021 13:56:54 -0400
Message-ID: <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 10 Jun 2021 13:56:53 -0400
In-Reply-To: <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
         <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
         <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
         <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
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

On Thu, 2021-06-10 at 16:51 +0100, Pavel Begunkov wrote:
> Right, but it still stalls other requests and IIRC there are people
> not liking the syscall already taking too long. Consider
> io_req_task_queue(), adds more overhead but will delay execution
> to the syscall exit.
> 
> In any case, would be great to have numbers, e.g. to see if
> io_req_task_queue() is good enough, how often your problem
> takes places and how much it gives us.
> 
I will get you more more data later but I did run a fast test that
lasted 81 seconds with a single TCP connection.

The # of times that the sqe got reissued is 57.

I'll intrumentalize a bit the code to answer the following questions:

1. What is the ratio of reissued read sqe/total read sqe
2. Average exec time of __io_queue_sqe() for a read sqe when data is
already available vs avg exec time when sqe is reissued
3. average exec time when the sqe is pushed to async when it could have
been reissued.

With that info, I think that we will be in better position to evaluate
whether or not the patch is good or not.

Can you think of other numbers that would be useful to know to evaluate
the patch performance?


