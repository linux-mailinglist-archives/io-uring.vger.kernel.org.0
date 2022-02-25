Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67CAA4C3D61
	for <lists+io-uring@lfdr.de>; Fri, 25 Feb 2022 05:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiBYEnG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Feb 2022 23:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbiBYEnE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Feb 2022 23:43:04 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4421148910
        for <io-uring@vger.kernel.org>; Thu, 24 Feb 2022 20:42:31 -0800 (PST)
Received: from [45.44.224.220] (port=57020 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nNSR4-0000TO-7Q; Thu, 24 Feb 2022 23:42:30 -0500
Message-ID: <b4b1c0744e40d7ec8e885dbc8dbe0590d17b977a.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Thu, 24 Feb 2022 23:42:29 -0500
In-Reply-To: <b4440070-e255-9107-4214-1b00ee84ac47@linux.alibaba.com>
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
         <085cb98e6136fc4874b6311ac2e4b78f5a6ef86d.camel@trillion01.com>
         <b4440070-e255-9107-4214-1b00ee84ac47@linux.alibaba.com>
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

On Mon, 2022-02-21 at 13:03 +0800, Hao Xu wrote:
> > 
> > but I think that there is a possible race condition where the
> > napi_list
> > could be used from io_cqring_wait() while another thread modify the
> > list. This is NOT done in my testing scenario but definitely
> > something
> > that could happen somewhere in the real world...
> 
> Will there be any issue if we do the access with
> list_for_each_entry_safe? I think it is safe enough.

Hi Hao,

If napi_busy_poll is exclusively done from the sqpoll thread, all is
good because all the napi_list manipulations are performed from the
sqpoll thread.

The issue is if we want to offer napi_busy_poll for a task calling
io_uring_enter(). If the busy_poll is performed from io_cqring_wait()
as I propose in my patch, the napi_list could be updated by a different
thread calling io_uring_enter() to submit other requests.

This is an issue that v2 is addressing. This makes the code uglier. The
strategy being to splice the context napi_list into a local list in
io_cqring_wait() and assume that the most likely outcome when the
busy_poll will be over the only thing that will be needed is to move
back the local list into the context. If in the meantime, the context
napi_list has been updated, the lists are going to be merged. This
appears to be the approach minimizing the amount of memory allocations.

Creating a benchmark program took more time than I originally expected.
I am going to run it and if gains from napi_polling from
io_cqring_wait() aren't that good... maybe ditching napi_busy_poll()
support from io_cqring_wait() and that way, locking the lock before
adding napi ids will not be required anymore...

Here is what will be added in v2:
- Evaluate list_empty(&ctx->napi_list) outside io_napi_busy_loop() to
keep __io_sq_thread() execution as fast as possible
- In io_cqring_wait(), move up the sig block to avoid needless
computation if the block exits the function
- In io_cqring_wait(), protect ctx->napi_list from race condition by
splicing it into a local list
- In io_cqring_wait(), allow busy polling when uts is missing
- Fix kernel test robot issues

