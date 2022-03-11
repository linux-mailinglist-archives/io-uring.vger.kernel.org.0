Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443384D5BAB
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 07:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236431AbiCKGjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 01:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232756AbiCKGjM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 01:39:12 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D947D3EF13;
        Thu, 10 Mar 2022 22:38:09 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D09D668AFE; Fri, 11 Mar 2022 07:38:05 +0100 (CET)
Date:   Fri, 11 Mar 2022 07:38:05 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 04/17] nvme: modify nvme_alloc_request to take an
 additional parameter
Message-ID: <20220311063805.GB17232@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152700epcas5p4130d20119a3a250a2515217d6552f668@epcas5p4.samsung.com> <20220308152105.309618-5-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-5-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:50:52PM +0530, Kanchan Joshi wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> This is a prep patch. It modifies nvme_alloc_request to take an
> additional parameter, allowing request flags to be passed.

I don't think we need more paramters to nvme_alloc_request.
In fact I think we're probably better over removing nvme_alloc_request
as a prep cleanup given that is is just two function calls anyway.
