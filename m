Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E8C4CB1B0
	for <lists+io-uring@lfdr.de>; Wed,  2 Mar 2022 23:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242430AbiCBWEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Mar 2022 17:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238838AbiCBWEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Mar 2022 17:04:44 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9100CC9920;
        Wed,  2 Mar 2022 14:04:00 -0800 (PST)
Received: from [45.44.224.220] (port=57060 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nPX4h-000136-2O; Wed, 02 Mar 2022 17:03:59 -0500
Message-ID: <a549f23857b327131c621dbc9a029a91401967c8.camel@trillion01.com>
Subject: Re: [PATCH v4 2/2] io_uring: Add support for napi_busy_poll
From:   Olivier Langlois <olivier@trillion01.com>
To:     Hao Xu <haoxu@linux.alibaba.com>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 02 Mar 2022 17:03:58 -0500
In-Reply-To: <81a915d3-cf5f-a884-4649-704a5cf26835@linux.alibaba.com>
References: <cover.1646142288.git.olivier@trillion01.com>
         <aa38a667ef28cce54c08212fdfa1e2b3747ad3ec.1646142288.git.olivier@trillion01.com>
         <29bad95d-06f8-ea7c-29fe-81e52823c90a@linux.alibaba.com>
         <4f01857ca757ab4f0995420e6b1a6e3668a40da5.camel@trillion01.com>
         <4af380e8-796b-2dd6-4ebc-e40e7fa51ce1@linux.alibaba.com>
         <81a915d3-cf5f-a884-4649-704a5cf26835@linux.alibaba.com>
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

On Wed, 2022-03-02 at 14:38 +0800, Hao Xu wrote:
> > > 
> > > 
> > > If that is what you suggest, what would this info do for the
> > > caller?
> > > 
> > > IMHO, it wouldn't help in any way...
> > 
> > Hmm, I'm not sure, you're probably right based on that ENOMEM here 
> > shouldn't
> > 
> > fail the arm poll, but we wanna do it, we can do something like
> > what 
> > we do for
>                              ^---but if we wanna do it
My position is that being able to perform busy poll is a nice to have
feature if the necessary resources are available. If not the request
will still be handled correctly so nothing special should be done in
case of mem alloc problem.

but fair enough, lets wait for Jens and Pavel to chime him if they
would like to see something to be done here.

Beside that, all I need to know is if napi_list needs to be protected
in __io_sq_thread with regards to io worket threads to start working on
a v5.

I'll look into this question too...

