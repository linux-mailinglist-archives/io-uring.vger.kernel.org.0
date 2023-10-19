Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26F17CEF2D
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 07:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232890AbjJSFmK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 01:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbjJSFlc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 01:41:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1DD1AE;
        Wed, 18 Oct 2023 22:41:09 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 47B3567373; Thu, 19 Oct 2023 07:41:06 +0200 (CEST)
Date:   Thu, 19 Oct 2023 07:41:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        joshi.k@samsung.com, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/4] iouring: remove IORING_URING_CMD_POLLED
Message-ID: <20231019054105.GE14346@lst.de>
References: <20231018151843.3542335-1-kbusch@meta.com> <20231018151843.3542335-4-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018151843.3542335-4-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good and should probably go straight to the io_uring tree
instead of being mixed up with the metadata changes.

Reviewed-by: Christoph Hellwig <hch@lst.de>
