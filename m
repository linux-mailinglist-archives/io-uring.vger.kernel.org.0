Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8454C7B38
	for <lists+io-uring@lfdr.de>; Mon, 28 Feb 2022 22:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiB1VCL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Feb 2022 16:02:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiB1VCK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Feb 2022 16:02:10 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3164DD7603;
        Mon, 28 Feb 2022 13:01:30 -0800 (PST)
Received: from [45.44.224.220] (port=57032 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nOn97-0003rK-1O; Mon, 28 Feb 2022 16:01:29 -0500
Message-ID: <f84e9ab7d61aef6bf58d602a466a806193f3abbc.camel@trillion01.com>
Subject: Re: [PATCH v1] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Mon, 28 Feb 2022 16:01:27 -0500
In-Reply-To: <c8083ad8-076b-2f2d-4c80-fc9f75d9fcd8@linux.alibaba.com>
References: <d11e31bd59c75b2cce994dd90a07e769d4e039db.1645257310.git.olivier@trillion01.com>
         <aee0e905-7af4-332c-57bc-ece0bca63ce2@linux.alibaba.com>
         <f84f59e3edd9b4973ea2013b2893d4394a7bdb61.camel@trillion01.com>
         <c8083ad8-076b-2f2d-4c80-fc9f75d9fcd8@linux.alibaba.com>
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

On Tue, 2022-03-01 at 02:26 +0800, Hao Xu wrote:
> 
> On 2/25/22 13:32, Olivier Langlois wrote:
> > On Mon, 2022-02-21 at 13:23 +0800, Hao Xu wrote:
> > > > @@ -5776,6 +5887,7 @@ static int __io_arm_poll_handler(struct
> > > > io_kiocb *req,
> > > >                  __io_poll_execute(req, mask);
> > > >                  return 0;
> > > >          }
> > > > +       io_add_napi(req->file, req->ctx);
> > > I think this may not be the right place to do it. the process
> > > will
> > > be:
> > > arm_poll sockfdA--> get invalid napi_id from sk->napi_id -->
> > > event
> > > triggered --> arm_poll for sockfdA again --> get valid napi_id
> > > then why not do io_add_napi() in event
> > > handler(apoll_task_func/poll_task_func).
> > You have a valid concern that the first time a socket is passed to
> > io_uring that napi_id might not be assigned yet.
> > 
> > OTOH, getting it after data is available for reading does not help
> > neither since busy polling must be done before data is received.
> > 
> > for both places, the extracted napi_id will only be leveraged at
> > the
> > next polling.
> 
> Hi Olivier,
> 
> I think we have some gap here. AFAIK, it's not 'might not', it is
> 
> 'definitely not', the sk->napi_id won't be valid until the poll
> callback.
> 
> Some driver's code FYR:
> (drivers/net/ethernet/intel/e1000/e1000_main.c)
> 
> e1000_receive_skb-->napi_gro_receive-->napi_skb_finish--
> >gro_normal_one
> 
> and in gro_normal_one(), it does:
> 
>            if (napi->rx_count >= gro_normal_batch)
>                    gro_normal_list(napi);
> 
> 
> The gro_normal_list() delivers the info up to the specifical network 
> protocol like tcp.
> 
> And then sk->napi_id is set, meanwhile the poll callback is
> triggered.
> 
> So that's why I call the napi polling technology a 'speculation'.
> It's 
> totally for the
> 
> future data. Correct me if I'm wrong especially for the poll callback
> triggering part.
> 
When I said 'might not', I was meaning that from the io_uring point of
view, it has no idea what is the previous socket usage. If it has been
used outside io_uring, the napi_id could available on the first call.

If it is really read virgin socket, neither my choosen call site or
your proposed sites will make the napi busy poll possible for the first
poll.

I feel like there is not much to gain to argue on this point since I
pretty much admitted that your solution was most likely the only call
site making MULTIPOLL requests work correctly with napi busy poll as
those requests could visit __io_arm_poll_handler only once (Correct me
if my statement is wrong).

The only issue was that I wasn't sure is how using your calling sites
would make locking work.

I suppose that adding a dedicated spinlock for protecting napi_list
instead of relying on uring_lock could be a solution. Would that work?

