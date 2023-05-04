Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DF46F6489
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 07:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229470AbjEDFvj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 01:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjEDFvf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 01:51:35 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543B11732
        for <io-uring@vger.kernel.org>; Wed,  3 May 2023 22:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1683179493;
        bh=A/Mlx0uOnQn6/ijU5uoDbkVo+jOvTwNWxis13jQvsb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=UfiE9A4Yu1lgDEJ0Nf2PE+Lsaz+km5f2aUjp0YhJS4EkujTVe66itjJZdztSMOmCn
         VDa7zEBJlo4BLR1W2bAQRxxJFQqyFph6RuQOkguhKA8CIki68dB6/0jcNDmwOiWqgC
         vojH9AoQCdDn9Si9ZsLBkzmTgw6/NctLg1Ad6yzXVGnmvCO5yWmfCMGXR62CLa/yTw
         jmYqwE1piOYP2+gbSW+0rixlB4m8/MNvNug1hLmGWMs1g2Cxwk+fKXHMDgnujmube0
         NFOs8c5QvWmaqUAISZKxMAKiATpkgalCf6ETww8ZUWR608mpbqTz5OCscp/G3H+l02
         xeXmBP6H2HcXA==
Received: from biznet-home.integral.gnuweeb.org (unknown [128.199.192.202])
        by gnuweeb.org (Postfix) with ESMTPSA id 42395245BED;
        Thu,  4 May 2023 12:51:32 +0700 (WIB)
Date:   Thu, 4 May 2023 12:51:28 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH liburing v1] .gitignore: Add `examples/rsrc-update-bench`
Message-ID: <ZFNH4PGCN1OiFaXk@biznet-home.integral.gnuweeb.org>
References: <20230504053835.118208-1-haiyue.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504053835.118208-1-haiyue.wang@intel.com>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 04, 2023 at 01:38:35PM +0800, Haiyue Wang wrote:
> The commit c0940508607f ("examples: add rsrc update benchmark") didn't
> add the built example binary into `.gitignore` file.
> 
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

