Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653845EE2C4
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 19:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234574AbiI1RNi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 13:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234607AbiI1RNG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 13:13:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20B7EEB45;
        Wed, 28 Sep 2022 10:12:48 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id B979668BEB; Wed, 28 Sep 2022 19:12:44 +0200 (CEST)
Date:   Wed, 28 Sep 2022 19:12:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com
Subject: Re: [PATCH for-next v10 0/7] Fixed-buffer for uring-cmd/passthru
Message-ID: <20220928171244.GA16907@lst.de>
References: <CGME20220927174622epcas5p1685c0f97a7ee2ee13ba25f5fb58dff00@epcas5p1.samsung.com> <20220927173610.7794-1-joshi.k@samsung.com> <96154f6c-c02a-4364-c2a8-c714d79806d3@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96154f6c-c02a-4364-c2a8-c714d79806d3@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 28, 2022 at 08:28:02AM -0600, Jens Axboe wrote:
> Christoph, are you happy with the changes at this point?

I'll look at it now.  Too much on my plate for less than 24 hour turn
around times..
