Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D48FE33FF0A
	for <lists+io-uring@lfdr.de>; Thu, 18 Mar 2021 06:49:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCRFsi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Mar 2021 01:48:38 -0400
Received: from verein.lst.de ([213.95.11.211]:40083 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229512AbhCRFsK (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 18 Mar 2021 01:48:10 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6B9C668C65; Thu, 18 Mar 2021 06:48:07 +0100 (CET)
Date:   Thu, 18 Mar 2021 06:48:07 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Subject: Re: [RFC PATCH v3 1/3] io_uring: add helper for uring_cmd
 completion in submitter-task
Message-ID: <20210318054807.GA28576@lst.de>
References: <20210316140126.24900-1-joshi.k@samsung.com> <CGME20210316140233epcas5p372405e7cb302c61dba5e1094fa796513@epcas5p3.samsung.com> <20210316140126.24900-2-joshi.k@samsung.com> <05a91368-1ba8-8583-d2ab-8db70b92df76@kernel.dk> <CA+1E3r+Mt7KKeFeYf7WY3CoKwnkXT-jE2EgJSTE6zaAfJX0dzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+Mt7KKeFeYf7WY3CoKwnkXT-jE2EgJSTE6zaAfJX0dzQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 18, 2021 at 10:55:55AM +0530, Kanchan Joshi wrote:
> I started with that, but the problem was implementing the driver callback .
> The callbacks receive only one argument which is "struct callback_head
> *", and the driver needs to extract "io_uring_cmd *" out of it.
> This part -
> +static void uring_cmd_work(struct callback_head *cb)
> +{
> +     struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
> +     struct io_uring_cmd *cmd = &req->uring_cmd;
> 
> If the callback has to move to the driver (nvme), the driver needs
> visibility to "struct io_kiocb" which is uring-local.
> Do you see a better way to handle this?

Can't you just add a helper in io_uring.c that does something like this:

struct io_uring_cmd *callback_to_io_uring_cmd(struct callback_head *cb)
{
	return &container_of(cb, struct io_kiocb, task_work)->uring_cmd;
}
EXPORT_SYMBOL_GPL(callback_to_io_uring_cmd);
