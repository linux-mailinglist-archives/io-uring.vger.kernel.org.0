Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEBA4D288D
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 06:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiCIFsg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 00:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiCIFse (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 00:48:34 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3595280;
        Tue,  8 Mar 2022 21:47:32 -0800 (PST)
Received: from [45.44.224.220] (port=34372 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nRpAZ-0007ll-Bp; Wed, 09 Mar 2022 00:47:31 -0500
Message-ID: <b0b2c07eb3b7acad02159e0db145a5b4e825b026.camel@trillion01.com>
Subject: Re: [PATCH v5 0/2] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 09 Mar 2022 00:47:30 -0500
In-Reply-To: <612546a3-5630-f1d4-f455-ef2bf564c83e@kernel.dk>
References: <cover.1646777484.git.olivier@trillion01.com>
         <612546a3-5630-f1d4-f455-ef2bf564c83e@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.4 
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

On Tue, 2022-03-08 at 17:54 -0700, Jens Axboe wrote:
> On 3/8/22 3:17 PM, Olivier Langlois wrote:
> > The sqpoll thread can be used for performing the napi busy poll in
> > a
> > similar way that it does io polling for file systems supporting
> > direct
> > access bypassing the page cache.
> > 
> > The other way that io_uring can be used for napi busy poll is by
> > calling io_uring_enter() to get events.
> > 
> > If the user specify a timeout value, it is distributed between
> > polling
> > and sleeping by using the systemwide setting
> > /proc/sys/net/core/busy_poll.
> 
> I think we should get this queued up, but it doesn't apply to
> for-5.18/io_uring at all. I can fix it up, but just curious what you
> tested against?
> 
Hi Jens,

I did wrote the patch from
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

My testing systems are based on 5.16. I have backported the patch and
compiled 5.16.12 with the patch for my testing.

sorry if I didn't use the right repo...


