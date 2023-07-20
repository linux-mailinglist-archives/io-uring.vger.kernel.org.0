Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D764175A53E
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 06:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjGTEzF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 00:55:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjGTEzD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 00:55:03 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1A11FCB;
        Wed, 19 Jul 2023 21:55:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2B7A167373; Thu, 20 Jul 2023 06:54:59 +0200 (CEST)
Date:   Thu, 20 Jul 2023 06:54:59 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
Subject: Re: [PATCH 3/6] iomap: treat a write through cache the same as FUA
Message-ID: <20230720045459.GC1811@lst.de>
References: <20230719195417.1704513-1-axboe@kernel.dk> <20230719195417.1704513-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230719195417.1704513-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 19, 2023 at 01:54:14PM -0600, Jens Axboe wrote:
> Whether we have a write back cache and are using FUA or don't have
> a write back cache at all is the same situation. Treat them the same.

This looks correct, but I think the IOMAP_DIO_WRITE_FUA is rather
misnamed now which could lead to confusion.  The comment in
__iomap_dio_rw when checking the flag and clearing IOMAP_DIO_NEED_SYNC
also needs a little update to talk about writethrough semantics and
not just FUA now.
