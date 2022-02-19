Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E794BC621
	for <lists+io-uring@lfdr.de>; Sat, 19 Feb 2022 08:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240859AbiBSHCb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Feb 2022 02:02:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230412AbiBSHCb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Feb 2022 02:02:31 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E34CA0D9
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 23:02:12 -0800 (PST)
Received: from [45.44.224.220] (port=44650 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nLJkx-0006Ia-0c; Sat, 19 Feb 2022 02:02:11 -0500
Message-ID: <085cb98e6136fc4874b6311ac2e4b78f5a6ef86d.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Sat, 19 Feb 2022 02:02:10 -0500
In-Reply-To: <44b5cc5e-5417-b766-5d28-15b7bcaaafed@linux.alibaba.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
         <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
         <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
         <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
         <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
         <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
         <51b4d363a9bd926243a2f7928335cdd2ac3f1218.camel@trillion01.com>
         <44b5cc5e-5417-b766-5d28-15b7bcaaafed@linux.alibaba.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.3 
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 2022-02-18 at 15:41 +0800, Hao Xu wrote:
> 
> Hi Oliver,
> 
> Have you tried just issue one recv/pollin request and observe the
> 
> napi_id?

Hi Hao, not precisely but you are 100% right about where the
association is done. It is when a packet is received that the
association is made. This happens in few places but the most likely
place where it can happen with my NIC (Intel igb) is inside
napi_gro_receive().

I do verify the socket napi_id once a WebSocket session is established.
At that point a lot of packets going back and forth have been
exchanged:

TCP handshake
TLS handshake
HTTP request requesting a WS upgrade

At that point, the napi_id has been assigned.

My problem was only that my socket packets were routed on the loopback
interface which has no napi devices associated to it.

I did remove the local SOCKS proxy out of my setup and NAPI ids started
to appear as expected.

>  From my understanding of the network stack, the napi_id
> 
> of a socket won't be valid until it gets some packets. Because before
> 
> that moment, busy_poll doesn't know which hw queue to poll.
> 
> In other words, the idea of NAPI polling is: the packets of a socket
> 
> can be from any hw queue of a net adapter, but we just poll the
> 
> queue which just received some data. So to get this piece of info,
> 
> there must be some data coming to one queue, before doing the
> 
> busy_poll. Correct me if I'm wrong since I'm also a newbie of
> 
> network stuff...

I am now getting what you mean here. So there are 2 possible
approaches. You either:

1. add the napi id when you are sure that it is available after its
setting in the sock layer but you are not sure if it will be needed
again with future requests as it is too late to be of any use for the
current request (unless it is a MULTISHOT poll) (the add is performed
in io_poll_task_func() and io_apoll_task_func()

2. add the napi id when the request poll is armed where this knowledge
could be leveraged to handle the current req knowing that we might fail
getting the id if it is the initial recv request. (the add would be
performed in __io_arm_poll_handler)

TBH, I am not sure if there are arguments in favor of one approach over
the other... Maybe option #1 is the only one to make napi busy poll
work correctly with MULTISHOT requests...

I'll let you think about this point... Your first choice might be the
right one...

the other thing to consider when choosing the call site is locking...
when done from __io_arm_poll_handler(), uring_lock is acquired...

I am not sure that this is always the case with
io_poll_task_func/io_apoll_task_func...

I'll post v1 of the patch. My testing is showing that it works fine.
race condition is not an issue when busy poll is performed by sqpoll
thread because the list modification is exclusivy performed by that
thread too.

but I think that there is a possible race condition where the napi_list
could be used from io_cqring_wait() while another thread modify the
list. This is NOT done in my testing scenario but definitely something
that could happen somewhere in the real world...

> 
> 
> I was considering to poll all the rx rings, but it seemed to be not
> 
> efficient from some tests by my colleague.

This is definitely the simplest implementation but I did not go as far
as testing it. There is too much unknown variables to be viable IMHO. I
am not too sure how many napi devices there can be in a typical server.
I know that in my test machine, it has 2 NICs and one of them is just
unconnected. If we were to loop through all the devices, we would be
polling wastefully at least half of all the devices on the system. That
does not sound like a very good approach.


