Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71F36D81E5
	for <lists+io-uring@lfdr.de>; Wed,  5 Apr 2023 17:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjDEPaW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 Apr 2023 11:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238367AbjDEPaP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 Apr 2023 11:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF7C711C
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 08:30:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B829623C3
        for <io-uring@vger.kernel.org>; Wed,  5 Apr 2023 15:30:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6901FC4339B;
        Wed,  5 Apr 2023 15:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680708602;
        bh=LeMKsBCVGhK0MI4/E8VrsHhqZf3Xhzs6ITLdf0ftaFU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNuxiewJOHwA189SknqRmyy9Bb7uDtGn+4VBc4AJZviZOaFLN2rFpqhgGeTsiKCCq
         6DRxsRtmN/iVWdSJCBaFo7FPvbOUGxf8kaHwoACcMyy7yinjQ/taTQ8687qPGCAQeu
         K9AKLOziTgt180WwvmxNZ3k6S5bT6ixc7q9HVbXMISedPvtvYHfculAD0NmTTk64of
         OWKzmFAOZ7Cn11BnPj/rO6rtvQM8XzMMpoM3fu3VwUUUucMraSOpL+/TSDNeh9ccA5
         WD9+/UpE006EMK5HU3941+UVhPmCzYw0l5g6w6PgKF4BJ93H8t+jT5TwrxvFqm+5w8
         Nh9bDwmf8qiMQ==
Date:   Wed, 5 Apr 2023 09:29:59 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH] io_uring/uring_cmd: assign ioucmd->cmd at async prep time
Message-ID: <ZC2T92J9h5dxC/Ui@kbusch-mbp.dhcp.thefacebook.com>
References: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <863daab3-c397-85fc-4db5-b61e02ced047@kernel.dk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 05, 2023 at 08:23:15AM -0600, Jens Axboe wrote:
> Rather than check this in the fast path issue, it makes more sense to
> just assign the copy of the data when we're setting it up anyway. This
> makes the code a bit cleaner, and removes the need for this check in
> the issue path.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
