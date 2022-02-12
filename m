Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9D24B37B9
	for <lists+io-uring@lfdr.de>; Sat, 12 Feb 2022 20:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiBLTvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Feb 2022 14:51:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbiBLTvV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Feb 2022 14:51:21 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B26606D5
        for <io-uring@vger.kernel.org>; Sat, 12 Feb 2022 11:51:13 -0800 (PST)
Received: from [45.44.224.220] (port=44248 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nIyQF-0006gY-3H; Sat, 12 Feb 2022 14:51:07 -0500
Message-ID: <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Sat, 12 Feb 2022 14:51:06 -0500
In-Reply-To: <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2022-02-09 at 11:34 +0800, Hao Xu wrote:
> 在 2022/2/9 上午1:05, Jens Axboe 写道:
> > On 2/8/22 7:58 AM, Olivier Langlois wrote:
> > > Hi,
> > > 
> > > I was wondering if integrating the NAPI busy poll for socket fds
> > > into
> > > io_uring like how select/poll/epoll are doing has ever been
> > > considered?
> > > 
> > > It seems to me that it could be an awesome feature when used
> > > along with
> > > a io_qpoll thread and something not too difficult to add...
> > 
> > Should be totally doable and it's been brought up before, just
> > needs
> > someone to actually do it... Would love to see it.
> > 
> We've done some investigation before, would like to have a try.
> 
Hao,

Let me know if I can help you with coding or testing. I have done very
preliminary investigation too. It doesn't seem like it would be very
hard to implement but I get confused with small details.

For instance, the epoll implementation, unless there is something that
I don't understand, appears to have a serious limitation. It seems like
it would not work correctly if there are sockets associated to more
than 1 NAPI device in the fd set. As far as I am concerned, that
limitation would be ok since in my setup I only use 1 device but if it
was necessary to be better than the epoll implementation, I am not sure
at all how this could be addressed. I do not have enough kernel dev
experience to find easy solutions to those type of issues...

Worse case scenario, I guess that I could give it a shot creating a
good enough implementation for my needs and show it to the list to get
feedback...

Greetings,
Olivier

