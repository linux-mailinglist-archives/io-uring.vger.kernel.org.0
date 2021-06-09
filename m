Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B4C3A1FA3
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 00:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhFIWDv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 18:03:51 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:51678 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhFIWDv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 18:03:51 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:51960 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lr6Gp-00032j-5k
        for io-uring@vger.kernel.org; Wed, 09 Jun 2021 18:01:55 -0400
Message-ID: <6941451d3471effb5b5b7038164fe6b9c1a6b5a2.camel@trillion01.com>
Subject: Re: Possible unneccessary IORING_OP_READs executed in Async
From:   Olivier Langlois <olivier@trillion01.com>
To:     io-uring@vger.kernel.org
Date:   Wed, 09 Jun 2021 18:01:54 -0400
In-Reply-To: <439fa5114eb2bf0914e11c2a0c97798885c7d83f.camel@trillion01.com>
References: <439fa5114eb2bf0914e11c2a0c97798885c7d83f.camel@trillion01.com>
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

On Mon, 2021-06-07 at 16:26 -0400, Olivier Langlois wrote:
> In __io_queue_sqe():
> a) io_issue_sqe() returns EAGAIN
> b) in between io_issue_sqe() call and vfs_poll() call done inside
> io_arm_poll_handler(), data becomes available
> c) io_arm_poll_handler() returns false because vfs_poll() did return
> an
> non-empty mask.
> 
> I am throwing this idea to the group.
> Would it be a good idea to detect that situation and recall
> io_issue_sqe() in that case instead of pushing the request to the io-
> wq?
> 
> On busy TCP sockets, this scenario seems to happen very often (ie:
> few
> times every second)

I didn't wait for an answer and I went straight to trying out an
io_uring modification.

It works like a charm. My code is using io_uring like a maniac and with
the modification, zero io worker threads get created.

That means a definite gain in terms of latency...

I will send out a patch soon to share this discovery with io_uring
devs.

Greetings,


