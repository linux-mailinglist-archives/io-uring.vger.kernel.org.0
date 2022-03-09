Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A0A4D2882
	for <lists+io-uring@lfdr.de>; Wed,  9 Mar 2022 06:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiCIFh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 00:37:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiCIFhs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 00:37:48 -0500
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452E414F280;
        Tue,  8 Mar 2022 21:36:50 -0800 (PST)
Received: from [45.44.224.220] (port=34370 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1nRp0C-0007Rd-NM; Wed, 09 Mar 2022 00:36:48 -0500
Message-ID: <36cd0f716bda419f477c3256769f382a31461481.camel@trillion01.com>
Subject: Re: [PATCH v5 1/2] io_uring: minor io_cqring_wait() optimization
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        io-uring <io-uring@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Wed, 09 Mar 2022 00:36:47 -0500
In-Reply-To: <7f39095c-1070-7a70-91a0-b0ccb33c368b@kernel.dk>
References: <cover.1646777484.git.olivier@trillion01.com>
         <84513f7cc1b1fb31d8f4cb910aee033391d036b4.1646777484.git.olivier@trillion01.com>
         <7f39095c-1070-7a70-91a0-b0ccb33c368b@kernel.dk>
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

On Tue, 2022-03-08 at 17:54 -0700, Jens Axboe wrote:
> On 3/8/22 3:17 PM, Olivier Langlois wrote:
> > Move up the block manipulating the sig variable to execute code
> > that may encounter an error and exit first before continuing
> > executing the rest of the function and avoid useless computations
> 
> I don't think this is worthwhile doing. If you're hitting an error
> in any of them, it's by definition not the fast path.
> 
Well, by itself it is not a big improvement but it is still an
improvement.

but most importantly, it has to be considered in the context of the
current patchset because in patch #2, the following step is to

1. acquire the napi spin lock
2. splice the context napi list into a local one.
3. release the lock

If this patch is not in place before patch #2, you would need undo all
that before returning from the sig block which would make the function
bigger when all that is completely avoidable by accepting this patch...

Both patches were together in v1 but I decided to break them apart
thinking that this was the right thing to do...

