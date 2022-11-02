Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBDD6172E3
	for <lists+io-uring@lfdr.de>; Thu,  3 Nov 2022 00:40:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbiKBXkZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Nov 2022 19:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKBXj7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Nov 2022 19:39:59 -0400
Received: from smtp4.emailarray.com (smtp4.emailarray.com [65.39.216.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A121B2AEA
        for <io-uring@vger.kernel.org>; Wed,  2 Nov 2022 16:33:15 -0700 (PDT)
Received: (qmail 29932 invoked by uid 89); 2 Nov 2022 23:33:14 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuOA==) (POLARISLOCAL)  
  by smtp4.emailarray.com with SMTP; 2 Nov 2022 23:33:14 -0000
Date:   Wed, 2 Nov 2022 16:33:12 -0700
From:   Jonathan Lemon <jlemon@flugsvamp.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: Re: [RFC PATCH v2 00/13] zero-copy RX for io_uring
Message-ID: <20221102233312.pibzwdgytrvpkg72@bsd-mbp.dhcp.thefacebook.com>
References: <20221018191602.2112515-1-jonathan.lemon@gmail.com>
 <500982a6-da38-0d8c-dc5d-e08787362d71@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500982a6-da38-0d8c-dc5d-e08787362d71@linux.alibaba.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 20, 2022 at 11:35:14AM +0800, Ziyang Zhang wrote:
> Hi, Jonathan
> 
> We are interested in your work, too. I think the API is better than V1.
> I have a question: Is this patchset still incomplete? We'd like to know how to
> split msg header and body by XDP with io_uring ZC_RECV. Or could you please
> share one runnable demo which could run with your previous liburing patch.

It seems my earlier reply to this didn't go to the list, so retrying.

I just posted RFC v3, which is just about complete.  The cover letter
also has the location of a github repo which has a simple example
showing the operation.  I'm in the process of updating iperf3 as another
sample application.

The packet splitting is done by the NIC hardware.  There are Broadcom
and nVidia NICs which have these feature sets.  One of my testbeds is
set up and working with Broadcom.
-- 
Jonathan
