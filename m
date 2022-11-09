Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD25E622F09
	for <lists+io-uring@lfdr.de>; Wed,  9 Nov 2022 16:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiKIP1L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Nov 2022 10:27:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiKIP1H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Nov 2022 10:27:07 -0500
Received: from smtp8.emailarray.com (smtp8.emailarray.com [65.39.216.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736E7D45
        for <io-uring@vger.kernel.org>; Wed,  9 Nov 2022 07:27:02 -0800 (PST)
Received: (qmail 57622 invoked by uid 89); 9 Nov 2022 15:27:01 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21ANzEuMjEyLjEzMS44MA==) (POLARISLOCAL)  
  by smtp8.emailarray.com with SMTP; 9 Nov 2022 15:27:01 -0000
Date:   Wed, 9 Nov 2022 07:27:00 -0800
From:   Jonathan Lemon <jlemon@flugsvamp.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v1 00/15] zero-copy RX for io_uring
Message-ID: <20221109152700.syfhhmkdloi5gmas@bsd-mbp.local>
References: <20221108050521.3198458-1-jonathan.lemon@gmail.com>
 <20221109063742.GI56517@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109063742.GI56517@linux.alibaba.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 09, 2022 at 02:37:42PM +0800, Dust Li wrote:
> 
> Haven't dive into your test case yet, but the performance data
> looks disappointing
> 
> I don't know why we need zerocopy if we can't get a big performance
> gain.

The cited numbers are intended to show that there is no network
bandwidth performance drop from using RECV_ZC.  For the systems under
test (25Gb, 50Gb), we are getting linerate already, so there wouldn't be
any BW improvement.

The zerocopy gains come from a reduction in memory bandwith, removing
the user memcpy overhead, reducing the CPU usage.  This is why I put up
the changes for iperf3, so cpu and membw usage metrics can be collected
while under network load.

> Have you tested large messages with jumbo or LRO enabled ?

Haven't tested jumbo frames, but these are with GRO support.
-- 
Jonathan
