Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AECC44023E1
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 09:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbhIGHLn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 03:11:43 -0400
Received: from verein.lst.de ([213.95.11.211]:34853 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237574AbhIGHLn (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Sep 2021 03:11:43 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 41CC867373; Tue,  7 Sep 2021 09:10:35 +0200 (CEST)
Date:   Tue, 7 Sep 2021 09:10:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk
Cc:     kbusch@kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, hare@suse.de
Subject: Re: [RFC PATCH 0/6] Fixed-buffers io_uring passthrough over
 nvme-char
Message-ID: <20210907071035.GA29874@lst.de>
References: <CGME20210805125910epcas5p1100e7093dd2b1ac5bbb751331e2ded23@epcas5p1.samsung.com> <20210805125539.66958-1-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805125539.66958-1-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Sorry for taking so long to get back to this, the previous merge
window has been a little busy.

On Thu, Aug 05, 2021 at 06:25:33PM +0530, Kanchan Joshi wrote:
> The work is on top of  Jens' branch (which is 5.14-rc1 based):
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-fops.v5

I think we need to have this reviewed on the list as well.
