Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD24024B2
	for <lists+io-uring@lfdr.de>; Tue,  7 Sep 2021 09:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhIGHtw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Sep 2021 03:49:52 -0400
Received: from verein.lst.de ([213.95.11.211]:34968 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233953AbhIGHtv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 7 Sep 2021 03:49:51 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 66F0568AFE; Tue,  7 Sep 2021 09:48:44 +0200 (CEST)
Date:   Tue, 7 Sep 2021 09:48:44 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, javier.gonz@samsung.com, hare@suse.de
Subject: Re: [RFC PATCH 5/6] io_uring: add support for uring_cmd with
 fixed-buffer
Message-ID: <20210907074844.GD29874@lst.de>
References: <20210805125539.66958-1-joshi.k@samsung.com> <CGME20210805125934epcas5p4ff88e95d558ad9f65d77a888a4211b18@epcas5p4.samsung.com> <20210805125539.66958-6-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805125539.66958-6-joshi.k@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 05, 2021 at 06:25:38PM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add IORING_OP_URING_CMD_FIXED opcode that enables performing the
> operation with previously registered buffers.

We should also pass this information on into ->uring_cmd instead of
needing two ioctl_cmd opcodes.
