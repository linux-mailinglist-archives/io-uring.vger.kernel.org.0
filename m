Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39934F0FC9
	for <lists+io-uring@lfdr.de>; Mon,  4 Apr 2022 09:08:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358430AbiDDHJq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Apr 2022 03:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357192AbiDDHJp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Apr 2022 03:09:45 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69C8F381BA
        for <io-uring@vger.kernel.org>; Mon,  4 Apr 2022 00:07:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 386EC68AFE; Mon,  4 Apr 2022 09:07:47 +0200 (CEST)
Date:   Mon, 4 Apr 2022 09:07:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, asml.silence@gmail.com,
        ming.lei@redhat.com, mcgrof@kernel.org, pankydev8@gmail.com,
        javier@javigon.com, joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [RFC 4/5] io_uring: add support for big-cqe
Message-ID: <20220404070747.GA444@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110836epcas5p37bd59ab5a48cf77ca3ac05052a164b0b@epcas5p3.samsung.com> <20220401110310.611869-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401110310.611869-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 01, 2022 at 04:33:09PM +0530, Kanchan Joshi wrote:
> Add IORING_SETUP_CQE32 flag to allow setting up ring with big-cqe which
> is 32 bytes in size. Also modify uring-cmd completion infra to accept
> additional result and fill that up in big-cqe.

This should probably be patch 2 in the series.
