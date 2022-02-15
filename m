Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B894B75CE
	for <lists+io-uring@lfdr.de>; Tue, 15 Feb 2022 21:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbiBOSFW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Feb 2022 13:05:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiBOSFW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Feb 2022 13:05:22 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9288BC1146
        for <io-uring@vger.kernel.org>; Tue, 15 Feb 2022 10:05:11 -0800 (PST)
Received: from [45.44.224.220] (port=44310 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nK2CM-0004B7-K3; Tue, 15 Feb 2022 13:05:10 -0500
Message-ID: <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Tue, 15 Feb 2022 13:05:09 -0500
In-Reply-To: <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
         <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
         <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
         <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
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

On Tue, 2022-02-15 at 03:37 -0500, Olivier Langlois wrote:
> 
> That being said, I have not been able to make it work yet. For some
> unknown reasons, no valid napi_id is extracted from the sockets added
> to the context so the net_busy_poll function is never called.
> 
> I find that very strange since prior to use io_uring, my code was
> using
> epoll and the busy polling was working fine with my application
> sockets. Something is escaping my comprehension. I must tired and
> this
> will become obvious...
> 
The napi_id values associated with my sockets appear to be in the range
0 < napi_id < MIN_NAPI_ID

from busy_loop.h:
/*		0 - Reserved to indicate value not set
 *     1..NR_CPUS - Reserved for sender_cpu
 *  NR_CPUS+1..~0 - Region available for NAPI IDs
 */
#define MIN_NAPI_ID ((unsigned int)(NR_CPUS + 1))

I have found this:
https://lwn.net/Articles/619862/

hinting that busy_poll may be incompatible with RPS
(Documentation/networking/scaling.rst) that I may have discovered
*AFTER* my epoll -> io_uring transition (I don't recall exactly the
sequence of my learning process).

With my current knowledge, it makes little sense why busy polling would
not be possible with RPS. Also, what exactly is a NAPI device is quite
nebulous to me... Looking into the Intel igb driver code, it seems like
1 NAPI device is created for each interrupt vector/Rx buffer of the
device.

Bottomline, it seems like I have fallen into a new rabbit hole. It may
take me a day or 2 to figure it all... you are welcome to enlight me if
you know a thing or 2 about those topics... I am kinda lost right
now...

