Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B464BAD35
	for <lists+io-uring@lfdr.de>; Fri, 18 Feb 2022 00:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiBQXXn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Feb 2022 18:23:43 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiBQXXn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Feb 2022 18:23:43 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387604C41C
        for <io-uring@vger.kernel.org>; Thu, 17 Feb 2022 15:23:19 -0800 (PST)
Received: from [45.44.224.220] (port=44638 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nKq2p-0000n5-2W; Thu, 17 Feb 2022 18:18:39 -0500
Message-ID: <0a9c1bdcedac611518e4a90c1921d1f7657c2248.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Thu, 17 Feb 2022 18:18:38 -0500
In-Reply-To: <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
         <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
         <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
         <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
         <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
         <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
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

On Wed, 2022-02-16 at 20:14 +0800, Hao Xu wrote:
> 
> > 
> Hi Olivier,
> I've write something to express my idea, it would be great if you can
> try it.
> It's totally untested and only does polling in sqthread, won't be
> hard
> to expand it to cqring_wait. My original idea is to poll all the napi
> device but seems that may be not efficient. so for a request, just
> do napi polling for one napi.
> There is still one problem: when to delete the polled NAPIs.
> 
I think that I have found an elegant solution to the remaining problem!

Are you ok if I send out a patch to Jens that contains your code if I
put your name as a co-author?
> 
> 
> +       ne = kmalloc(sizeof(*ne), GFP_KERNEL);
> +       if (!ne)
> +               return;
> +
> +       list_add_tail(&ne->list, &ctx->napi_list);
> +}
ne->napi_id is not initialized before returning from the function!


