Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9D68ADE8
	for <lists+io-uring@lfdr.de>; Sun,  5 Feb 2023 02:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjBEBUE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Feb 2023 20:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjBEBUE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Feb 2023 20:20:04 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54E626CDE
        for <io-uring@vger.kernel.org>; Sat,  4 Feb 2023 17:19:34 -0800 (PST)
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.234])
        by gnuweeb.org (Postfix) with ESMTPSA id AA3E381F44;
        Sun,  5 Feb 2023 01:18:32 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1675559914;
        bh=l/DJfoi8K+d2hbKh98qoULkwilwP4zhB8Rv99ZYrr4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3IM5MoZZ5R+thzapfDNyYktRJP0LcXBiijR3OnVZ6mxNVAbgCx5TqIHgF+uEKrMK
         zlp+h5raSuVuORKFh5B2ZnLRUPLMuryiYgC+SwC5Zm9Ho4Wt6hZYurH5PmGugXZGDE
         6YBI2h5EmUmBnnNnP3d0WkNUynrf3QDsDbAO1ET+nDsTUmX+IZWhnqXy1wYihvzIXu
         1vLRwOcOeW1PnXl2Cbdi0onqqgKJIVlCNY65fMsMrxllJpoi42VpZcrMhdu0Bz+WB1
         dbveZm+6kE6YyX1vZ5f03XA0VipOMKRdZaKGKR4gLX/euUPL5far4LgEurd5zAVnC8
         1NinRrnFGgQ0w==
Date:   Sun, 5 Feb 2023 08:18:29 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Stefan Roesch <shr@devkernel.io>
Cc:     Facebook Kernel Team <kernel-team@fb.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v7 4/4] liburing: update changelog with new feature
Message-ID: <Y98D5QxKyl2r6Uhc@biznet-home.integral.gnuweeb.org>
References: <20230205002424.102422-1-shr@devkernel.io>
 <20230205002424.102422-5-shr@devkernel.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230205002424.102422-5-shr@devkernel.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Feb 04, 2023 at 04:24:24PM -0800, Stefan Roesch wrote:
> Add a new entry to the changelog file for the napi busy poll feature.
> 
> Signed-off-by: Stefan Roesch <shr@devkernel.io>

Acked-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

-- 
Ammar Faizi

