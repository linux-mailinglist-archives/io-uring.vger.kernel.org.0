Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F19794BC69F
	for <lists+io-uring@lfdr.de>; Sat, 19 Feb 2022 08:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241594AbiBSHPT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 19 Feb 2022 02:15:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241605AbiBSHPP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 19 Feb 2022 02:15:15 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB4125A31A
        for <io-uring@vger.kernel.org>; Fri, 18 Feb 2022 23:14:55 -0800 (PST)
Received: from [45.44.224.220] (port=44652 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nLJxG-00075Y-79; Sat, 19 Feb 2022 02:14:54 -0500
Message-ID: <637509b7a91737e8f965841d801583fd4bbb46d7.camel@trillion01.com>
Subject: Re: napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Date:   Sat, 19 Feb 2022 02:14:53 -0500
In-Reply-To: <2ec04f63-7d82-74db-1b59-9629b4d6ca9b@linux.alibaba.com>
References: <21bfe359aa45123b36ee823076a036146d1d9518.camel@trillion01.com>
         <fc9664c4-11db-54e1-d3b6-c35ea345166a@kernel.dk>
         <f408374a-c0aa-1ca0-936a-0bbed68a01f6@linux.alibaba.com>
         <d3412259cb13e9e76d45387e171228655ebe91b0.camel@trillion01.com>
         <0446f39d-f926-0ae4-7ea4-00aff9236322@linux.alibaba.com>
         <995e65ce3d353cacea4d426c9876b2a5e88faa99.camel@trillion01.com>
         <a5e58292ff6207161af287ccd116ebf3c5b8a0fb.camel@trillion01.com>
         <f7f658cd-d76f-26c4-6549-0b3d2008d249@linux.alibaba.com>
         <3dcb591407be5180d7b14c05eceff30a8f990b58.camel@trillion01.com>
         <2ec04f63-7d82-74db-1b59-9629b4d6ca9b@linux.alibaba.com>
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

On Fri, 2022-02-18 at 16:06 +0800, Hao Xu wrote:
> 
> > 
> > Concerning the remaining problem about when to remove the napi_id,
> > I
> > would say that a good place to do it would be when a request is
> > completed and discarded if there was a refcount added to your
> > napi_entry struct.
> > 
> > The only thing that I hate about this idea is that in my scenario,
> > the
> > sockets are going to be pretty much the same for the whole io_uring
> > context existance. Therefore, the whole ref counting overhead is
> > useless and unneeded.
> 
> I remember that now all the completion is in the original task(
> 
> should be confirmed again),
> 
> so it should be ok to just use simple 'unsigned int count' to show
> 
> the number of users of a napi entry. And doing deletion when count
> 
> is 0. For your scenario, which is only one napi in a iouring context,
> 
> This won't be big overhead as well.
> 
> The only thing is we may need to optimize the napi lookup process,
> 
> but I'm not sure if it is necessary.
> 
Hi Hao,

You can forget about the ref count idea. What I hated about it was that
it was incurring a cost to all the io_uring users including the vast
majority of them that won't be using napi_busy_poll...

One thing that I know that Pavel hates is when hot paths are littered
with a bunch of new code. I have been very careful doing that in my
design.

I think that I have found a much better approach to tackle the problem
of when to remove the napi_ids... I'll stop teasing about it... The
code is ready, tested... All I need to do is prepare the patch and send
it to the list for review.

net/core/dev.c is using a hash to store the napi structs. This could
possible be easily replicated in io_uring but for now, imho, this is a
polishing detail only that can be revisited later after the proof of
concept will have been accepted.

So eager to share the patch... This is the next thing that I do before
going to bed once I am done reading my emails...

