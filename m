Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92C54C9CF3
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 06:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiCBFNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 00:13:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237334AbiCBFNT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 00:13:19 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B98E5C;
        Tue,  1 Mar 2022 21:12:34 -0800 (PST)
Received: from [45.44.224.220] (port=57058 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nPHHt-0004WT-2C; Wed, 02 Mar 2022 00:12:33 -0500
Message-ID: <d5c162c93cf269d2f94cd0ae8c5d9cd0cd55c265.camel@trillion01.com>
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 02 Mar 2022 00:12:32 -0500
In-Reply-To: <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
References: <cover.1646142288.git.olivier@trillion01.com>
         <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
         <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
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

On Wed, 2022-03-02 at 02:31 +0800, Hao Xu wrote:
> > +static void io_blocking_napi_busy_loop(struct list_head
> > *napi_list,
> > +                                      struct io_wait_queue *iowq)
> > +{
> > +       unsigned long start_time =
> > +               list_is_singular(napi_list) ? 0 :
> > +               busy_loop_current_time();
> > +
> > +       do {
> > +               if (list_is_singular(napi_list)) {
> > +                       struct napi_entry *ne =
> > +                               list_first_entry(napi_list,
> > +                                                struct napi_entry,
> > list);
> > +
> > +                       napi_busy_loop(ne->napi_id,
> > io_busy_loop_end, iowq,
> > +                                      true, BUSY_POLL_BUDGET);
> > +                       io_check_napi_entry_timeout(ne);
> > +                       break;
> > +               }
> > +       } while (io_napi_busy_loop(napi_list) &&
> > +                !io_busy_loop_end(iowq, start_time));
> > +}
> > +
> 
> How about:
> 
> if (list is singular) {
> 
>      do something;
> 
>      return;
> 
> }
> 
> while (!io_busy_loop_end() && io_napi_busy_loop())
> 
>      ;
> 
> 
> Btw, start_time seems not used in singular branch.

Hao,

it takes me few readings before being able to figure out the idea
behind your suggestions. Sorry about that!

So, if I get it correctly, you are proposing extract out the singular
block out of the while loop...

IMHO, this is not a good idea because you could start iterating the
do/while loop with a multiple entries list that ends up becoming a
singular list after one or few iterations.

Check what io_napi_busy_loop() is doing...

It does not look like that but a lot thoughts have been put into
writing io_blocking_napi_busy_loop()...

