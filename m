Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 000F968A496
	for <lists+io-uring@lfdr.de>; Fri,  3 Feb 2023 22:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbjBCVUZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Feb 2023 16:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjBCVUY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Feb 2023 16:20:24 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0134E1CAFC
        for <io-uring@vger.kernel.org>; Fri,  3 Feb 2023 13:20:23 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id A3C9383000;
        Fri,  3 Feb 2023 21:20:21 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675459223;
        bh=DMzAomegAlFb16dLAqwI22Y5SKyyQGFRkrCntvWwQl4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O59k7W2OlwZSg2/vq0KJdWB9H+EZbG/+DmmUmMCg7yLhZ6h6TDpeURfCHE6cWCOVU
         Wvky0t7/NQKVmdCCWbAdr4pkE2EvgKlEDc/1yU+KbLnSnUitl4Ehyq8Hfh21PZvEyd
         Sn+bULK3xVS/YaqcL6lYtWNDZZ+Gh7gveSE7pQyfJicheexZlF4uqIwPO/KzxCqws9
         aPEPAF1ikt6gHLTXEOoAZlof9hX24hz56F3qmDAlBxk58ZdsA/wk7TdiBGQ1mTEfZ+
         VK/XGqv15lplPJIE2LZZnwhi8I2PYgWlQSYW4lIB35bo89S4DGzKq4TlZTyXX4U88G
         Wc4z/MnwbVz4Q==
Date:   Sat, 4 Feb 2023 04:20:17 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v6 3/4] liburing: add example programs for napi busy poll
Message-ID: <Y916kQ1SSZwVREoG@biznet-home.integral.gnuweeb.org>
References: <20230203190310.2900766-1-shr@devkernel.io>
 <20230203190310.2900766-4-shr@devkernel.io>
 <Y91yCGR0mQkZC+TS@biznet-home.integral.gnuweeb.org>
 <qvqwh6w2pi1d.fsf@dev0134.prn3.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <qvqwh6w2pi1d.fsf@dev0134.prn3.facebook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 03, 2023 at 01:14:30PM -0800, Stefan Roesch wrote:
> Do you happen to know which compiler and what settings are used in the
> CI environment? I don't see these warnings in my local environment.

GCC and Clang, both are not happy. Here is the build result of your
patch series:

   https://github.com/ammarfaizi2/liburing/actions/runs/4087640126/jobs/7048391772

liburing's upstream CI config file can be found here:

   https://github.com/axboe/liburing/blob/master/.github/workflows/build.yml

-- 
Ammar Faizi

