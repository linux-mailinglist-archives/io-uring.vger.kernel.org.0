Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F874B910F
	for <lists+io-uring@lfdr.de>; Wed, 16 Feb 2022 20:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238054AbiBPTTm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Feb 2022 14:19:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiBPTTl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Feb 2022 14:19:41 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB572AEDBB
        for <io-uring@vger.kernel.org>; Wed, 16 Feb 2022 11:19:28 -0800 (PST)
Received: from [45.44.224.220] (port=44342 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nKPpm-0000rH-Ng; Wed, 16 Feb 2022 14:19:26 -0500
Message-ID: <e0f54d9aabcfbdf605856608a30b64ad8a8842aa.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Wed, 16 Feb 2022 14:19:26 -0500
In-Reply-To: <4d889559-9268-7948-eb6b-1cb60d90016f@linux.alibaba.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
         <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
         <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
         <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
         <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
         <4d889559-9268-7948-eb6b-1cb60d90016f@linux.alibaba.com>
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

On Wed, 2022-02-16 at 11:12 +0800, Hao Xu wrote:
> 
> > 
> I read your code, I guess the thing is the sk->napi_id is set from
> skb->napi_id and the latter is set when the net device received some
> packets.
> > With my current knowledge, it makes little sense why busy polling
> > would
> > not be possible with RPS. Also, what exactly is a NAPI device is
> > quite
> > nebulous to me... Looking into the Intel igb driver code, it seems
> > like
> > 1 NAPI device is created for each interrupt vector/Rx buffer of the
> > device.
> AFAIK, yes, each Rx ring has its own NAPI.
> > 
> > Bottomline, it seems like I have fallen into a new rabbit hole. It
> > may
> > take me a day or 2 to figure it all... you are welcome to enlight
> > me if
> > you know a thing or 2 about those topics... I am kinda lost right
> > now...
> > 
> 
My dive into the net/core code has been beneficial!

I have found out that the reason why I did not have napi_id for my
sockets is because I have introduced a local SOCKS proxy into my setup.
By using the loopback device, this is de facto removing NAPI out of the
picture.

After having fixed this issue, I have started to test my code.

The modified io_cqring_wait() code does not work. With a pending recv()
request, the moment napi_busy_loop() is called, the recv() request
fails with an EFAULT error.

I suspect this might be because io_busy_loop_end() is doing something
that is not allowed while inside napi_busy_loop().

The simpler code change inside __io_sq_thread() might work but I still
have to validate.

I'll update later today or tomorrow with the latest result and
discovery!

Greetings,

