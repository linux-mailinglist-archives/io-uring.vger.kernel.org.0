Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA534D96DB
	for <lists+io-uring@lfdr.de>; Tue, 15 Mar 2022 09:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346269AbiCOI5h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Mar 2022 04:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346276AbiCOI52 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Mar 2022 04:57:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07504D9CB;
        Tue, 15 Mar 2022 01:56:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 96D8468AA6; Tue, 15 Mar 2022 09:56:14 +0100 (CET)
Date:   Tue, 15 Mar 2022 09:56:14 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk,
        kbusch@kernel.org, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, pankydev8@gmail.com, javier@javigon.com,
        mcgrof@kernel.org, a.manzanares@samsung.com, joshiiitr@gmail.com,
        anuj20.g@samsung.com
Subject: Re: [PATCH 09/17] io_uring: plug for async bypass
Message-ID: <20220315085614.GC4132@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152711epcas5p31de5d63f5de91fae94e61e5c857c0f13@epcas5p3.samsung.com> <20220308152105.309618-10-joshi.k@samsung.com> <20220310083303.GC26614@lst.de> <Yi9SVXAs8TlIcIkU@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi9SVXAs8TlIcIkU@T590>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Mar 14, 2022 at 10:33:57PM +0800, Ming Lei wrote:
> Plug support for passthrough rq is added in the following patch, so
> this one may be put after patch 'block: wire-up support for plugging'.

Yes.  And as already mentioned early that other patch really needs
a much better title and description.
