Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F00A6EC701
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 09:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjDXHYe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Apr 2023 03:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjDXHYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Apr 2023 03:24:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F57D10CC;
        Mon, 24 Apr 2023 00:24:00 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EBC3168BEB; Mon, 24 Apr 2023 09:23:57 +0200 (CEST)
Date:   Mon, 24 Apr 2023 09:23:57 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Breno Leitao <leitao@debian.org>
Cc:     io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        asml.silence@gmail.com, axboe@kernel.dk, leit@fb.com,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org,
        ming.lei@redhat.com
Subject: Re: [PATCH v2 3/3] io_uring: Remove unnecessary BUILD_BUG_ON
Message-ID: <20230424072357.GC13287@lst.de>
References: <20230421114440.3343473-1-leitao@debian.org> <20230421114440.3343473-4-leitao@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421114440.3343473-4-leitao@debian.org>
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
