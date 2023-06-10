Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AA072A979
	for <lists+io-uring@lfdr.de>; Sat, 10 Jun 2023 08:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbjFJGtM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Jun 2023 02:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjFJGtL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Jun 2023 02:49:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8123A89;
        Fri,  9 Jun 2023 23:49:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2026468C4E; Sat, 10 Jun 2023 08:49:06 +0200 (CEST)
Date:   Sat, 10 Jun 2023 08:49:05 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@meta.com>
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@lst.de, axboe@kernel.dk,
        sagi@grimberg.me, joshi.k@samsung.com,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv2 1/2] block: add request polling helper
Message-ID: <20230610064905.GA2131@lst.de>
References: <20230609204517.493889-1-kbusch@meta.com> <20230609204517.493889-2-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609204517.493889-2-kbusch@meta.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
