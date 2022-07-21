Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3402757CFC4
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiGUPjx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbiGUPjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:39:19 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F20889665
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:37:43 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 88F7E68AFE; Thu, 21 Jul 2022 17:37:40 +0200 (CEST)
Date:   Thu, 21 Jul 2022 17:37:40 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org
Subject: __io_file_supports_nowait for regular files
Message-ID: <20220721153740.GA5900@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Jens,

is there any good reason __io_file_supports_nowait checks the
blk_queue_nowait flag for regular files?  The FMODE_NOWAIT is set
for regular files that support nowait I/O, and should be all that
is needed.  Even with a block device that does not nonblocking
I/O some thing like reading from the page cache can be done
non-blocking.
