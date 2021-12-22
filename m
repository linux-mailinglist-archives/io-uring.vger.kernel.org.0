Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6CE47CDCC
	for <lists+io-uring@lfdr.de>; Wed, 22 Dec 2021 09:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239426AbhLVICY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Dec 2021 03:02:24 -0500
Received: from verein.lst.de ([213.95.11.211]:49553 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239373AbhLVICY (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 22 Dec 2021 03:02:24 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id BB02268AFE; Wed, 22 Dec 2021 09:02:20 +0100 (CET)
Date:   Wed, 22 Dec 2021 09:02:20 +0100
From:   "hch@lst.de" <hch@lst.de>
To:     Clay Mayers <Clay.Mayers@kioxia.com>
Cc:     "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "javier@javigon.com" <javier@javigon.com>,
        "anuj20.g@samsung.com" <anuj20.g@samsung.com>,
        "joshiiitr@gmail.com" <joshiiitr@gmail.com>,
        "pankydev8@gmail.com" <pankydev8@gmail.com>
Subject: Re: [RFC 02/13] nvme: wire-up support for async-passthru on
Message-ID: <20211222080220.GA21346@lst.de>
References: <2da62822fd56414d9893b89e160ed05c@kioxia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2da62822fd56414d9893b89e160ed05c@kioxia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Dec 21, 2021 at 09:16:27PM +0000, Clay Mayers wrote:
> Message-ID: <20211220141734.12206-3-joshi.k@samsung.com>
> 
> On 12/20/21 19:47:23 +0530, Kanchan Joshi wrote:
> > Introduce handlers for fops->async_cmd(), implementing async passthru on
> > char device (including the multipath one).
> > The handlers supports NVME_IOCTL_IO64_CMD.
> >
> I commented on these two issues below in more detail at
> https://github.com/joshkan/nvme-uring-pt/issues

If you want people to read your comments send them here and not on some
random website no one is reading.
