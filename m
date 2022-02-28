Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2BC44C7BBF
	for <lists+io-uring@lfdr.de>; Mon, 28 Feb 2022 22:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiB1VU4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Feb 2022 16:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiB1VUz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Feb 2022 16:20:55 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592D7EF0A4;
        Mon, 28 Feb 2022 13:20:16 -0800 (PST)
Received: from [45.44.224.220] (port=57034 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nOnRG-0004kq-Up; Mon, 28 Feb 2022 16:20:14 -0500
Message-ID: <1b6439ba29a3725ed041bfb8040c6b667cc4898a.camel@trillion01.com>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Mon, 28 Feb 2022 16:20:14 -0500
In-Reply-To: <9954b806-c4a0-2448-1eac-c8fc5cf2ca2c@linux.alibaba.com>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
         <aee0e905-7af4-332c-57bc-ece0bca63ce2@linux.alibaba.com>
         <f84f59e3edd9b4973ea2013b2893d4394a7bdb61.camel@trillion01.com>
         <2cedc9f21a1c89aa9fe1fa4dffc2ebeabeb761f5.camel@trillion01.com>
         <9954b806-c4a0-2448-1eac-c8fc5cf2ca2c@linux.alibaba.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.42.4 
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

On Tue, 2022-03-01 at 02:34 +0800, Hao Xu wrote:
> 
> On 2/25/22 23:32, Olivier Langlois wrote:
> > On Fri, 2022-02-25 at 00:32 -0500, Olivier Langlois wrote:
> > > > > +#ifdef CONFIG_NET_RX_BUSY_POLL
> > > > > +static void io_adjust_busy_loop_timeout(struct timespec64
> > > > > *ts,
> > > > > +                                       struct io_wait_queue
> > > > > *iowq)
> > > > > +{
> > > > > +       unsigned busy_poll_to =
> > > > > READ_ONCE(sysctl_net_busy_poll);
> > > > > +       struct timespec64 pollto = ns_to_timespec64(1000 *
> > > > > (s64)busy_poll_to);
> > > > > +
> > > > > +       if (timespec64_compare(ts, &pollto) > 0) {
> > > > > +               *ts = timespec64_sub(*ts, pollto);
> > > > > +               iowq->busy_poll_to = busy_poll_to;
> > > > > +       } else {
> > > > > +               iowq->busy_poll_to = timespec64_to_ns(ts) /
> > > > > 1000;
> > > > How about timespec64_tons(ts) >> 10, since we don't need
> > > > accurate
> > > > number.
> > > Fantastic suggestion! The kernel test robot did also detect an
> > > issue
> > > with that statement. I did discover do_div() in the meantime but
> > > what
> > > you suggest is better, IMHO...
> > After having seen Jens patch (io_uring: don't convert to jiffies
> > for
> > waiting on timeouts), I think that I'll stick with do_div().
> > 
> > I have a hard time considering removing timing accuracy when effort
> > is
> > made to make the same function more accurate...
> 
> 
> I think they are different things. Jens' patch is to resolve the
> problem
> 
> that jiffies possibly can not stand for time < 1ms (when HZ is 1000).
> 
> For example, a user assigns 10us, turn out to be 1ms, it's big
> difference.
> 
> But divided by 1000 or 1024 is not that quite different in this case.
> 
> > 
idk... For every 100uSec slice, dividing by 1024 will introduce a
~2.4uSec error. I didn't dig enough the question to figure out if the
error was smaller than the used clock accuracy.

but even if the error is small, why letting it slip in when 100%
accurate value is possible?

Beside, making the painfully picky do_div() macro for some platforms
happy, I fail to understand the problem with doing a division to get an
accurate value.

let me reverse the question. Even if the bit shifting is a bit faster
than doing the division, would the code be called often enough to make
a significant difference?

