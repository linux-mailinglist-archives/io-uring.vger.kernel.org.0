Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED633F636
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbhCQRC0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 13:02:26 -0400
Received: from verein.lst.de ([213.95.11.211]:38069 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232698AbhCQRCP (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Mar 2021 13:02:15 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4935068BEB; Wed, 17 Mar 2021 18:02:12 +0100 (CET)
Date:   Wed, 17 Mar 2021 18:02:12 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, axboe@kernel.dk, hch@lst.de,
        chaitanya.kulkarni@wdc.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, anuj20.g@samsung.com,
        javier.gonz@samsung.com, nj.shetty@samsung.com,
        selvakuma.s1@samsung.com
Subject: Re: [RFC PATCH v3 3/3] nvme: wire up support for async passthrough
Message-ID: <20210317170212.GB25097@lst.de>
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140240epcas5p3e71bfe2afecd728c5af60056f21cc9b7@epcas5p3.samsung.com> <20210316140126.24900-4-joshi.k@samsung.com> <20210317164550.GA4162742@dhcp-10-100-145-180.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317164550.GA4162742@dhcp-10-100-145-180.wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 09:45:50AM -0700, Keith Busch wrote:
> > +	if (ioucmd) { /* async handling */
> > +		u32 effects;
> > +
> > +		effects = nvme_command_effects(ns->ctrl, ns, cmd->common.opcode);
> > +		/* filter commands with non-zero effects, keep it simple for now*/
> 
> You shouldn't need to be concerned with this. You've wired up the ioucmd
> only to the NVME_IOCTL_IO_CMD, and nvme_command_effects() can only
> return 0 for that.
> 
> It would be worth adding support for NVME_IOCTL_IO_CMD64 too, though,
> and that doesn't change the effects handling either.

There is no good reason to support the non-64 structure in new code.
And we really should support the admin command submission (on the char
device node) as well.
