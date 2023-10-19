Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BA37CEF1E
	for <lists+io-uring@lfdr.de>; Thu, 19 Oct 2023 07:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbjJSFkc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 Oct 2023 01:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjJSFkb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 Oct 2023 01:40:31 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB39FAB;
        Wed, 18 Oct 2023 22:40:29 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8A63867373; Thu, 19 Oct 2023 07:40:26 +0200 (CEST)
Date:   Thu, 19 Oct 2023 07:40:26 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        joshi.k@samsung.com, martin.petersen@oracle.com,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/4] nvme: use bio_integrity_map_user
Message-ID: <20231019054026.GD14346@lst.de>
References: <20231018151843.3542335-1-kbusch@meta.com> <20231018151843.3542335-3-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231018151843.3542335-3-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Oct 18, 2023 at 08:18:41AM -0700, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Map user metadata buffers directly instead of maintaining a complicated
> copy buffer.
> 
> Now that the bio tracks the metadata through its bip, nvme doesn't need
> special metadata handling, callbacks, or additional fields in the pdu.
> This greatly simplifies passthrough handling and avoids a "might_fault"
> copy_to_user in the completion path. This also creates pdu space to
> track the original request separately from its bio, further simplifying
> polling without relying on special iouring fields.
> 
> The downside is that nvme requires the metadata buffer be physically
> contiguous, so user space will need to utilize huge pages if the buffer
> needs to span multiple pages. In practice, metadata payload sizes are a
> small fraction of the main payload, so this shouldn't be a problem.

We can't just remove the old path.  We might still need bounce
buffering to due misalignment and/or because it is notcontiguous.
Same as we have a direct map and a copy path for data.

