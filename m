Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D37D4C95AE
	for <lists+io-uring@lfdr.de>; Tue,  1 Mar 2022 21:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbiCAUQC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Mar 2022 15:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbiCAUP6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Mar 2022 15:15:58 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEACD79C6D;
        Tue,  1 Mar 2022 12:15:01 -0800 (PST)
Received: from [45.44.224.220] (port=57050 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nP8tg-0006kw-90; Tue, 01 Mar 2022 15:15:00 -0500
Message-ID: <628f7ac96c15b0a3d5f2ddcdf4df79a03950b17e.camel@trillion01.com>
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Tue, 01 Mar 2022 15:14:58 -0500
In-Reply-To: <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
References: <cover.1646142288.git.olivier@trillion01.com>
         <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
         <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
         <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
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

On Tue, 2022-03-01 at 15:06 -0500, Olivier Langlois wrote:
> On Wed, 2022-03-02 at 02:31 +0800, Hao Xu wrote:
> > 
> > 
> > How about:
> > 
> > if (list is singular) {
> > 
> >      do something;
> > 
> >      return;
> > 
> > }
> > 
> > while (!io_busy_loop_end() && io_napi_busy_loop())
> > 
> >      ;
> > 
> 
> is there a concern with the current code?
> What would be the benefit of your suggestion over current code?
> 
> To me, it seems that if io_blocking_napi_busy_loop() is called, a
> reasonable expectation would be that some busy looping is done or
> else
> you could return the function without doing anything which would,
> IMHO,
> be misleading.
> 
> By definition, napi_busy_loop() is not blocking and if you desire the
> device to be in busy poll mode, you need to do it once in a while or
> else, after a certain time, the device will return back to its
> interrupt mode.
> 
> IOW, io_blocking_napi_busy_loop() follows the same logic used by
> napi_busy_loop() that does not call loop_end() before having perform
> 1
> loop iteration.
> 
> > Btw, start_time seems not used in singular branch.
> 
> I know. This is why it is conditionally initialized.
> 
> Greetings,
> 
Another argument for not touching the code the way that it is:
io_napi_busy_loop() has another function on top of iterating the
napi_list and calling napi_busy_loop() for each of them.

The function also check the list entries validity and frees them when
they time out. Not calling io_napi_busy_loop() you would bypass this
check and that could result in timed out entries to never be disposed.

