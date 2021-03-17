Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2451D33F26D
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 15:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhCQORz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 10:17:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231814AbhCQORc (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 17 Mar 2021 10:17:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 924C764F26;
        Wed, 17 Mar 2021 14:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615990652;
        bh=5rxJMptHstMrIpXi8pkDZiHwDhBN/cQxg6prU85MNc4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d8MQQLruQzpH2Wx1Fl22m1PfTVtm/UHF1CmcL2kn9FI04mo0mGNYzVH70mIJl1/3S
         5mvEP5/fHkS4zo5t4pXxUlsWqMF3qS93bLT1jCRpq/vJ4n9JbYfIlsBW/Fmxg9z4oR
         3pPHE5wuhgyzsvYKlQSXoY1Fa7StlFYL49KumOfBklQoAqkVKNUmml1/QabY7xIxFs
         cXk87Fhx9vlJWTToUt3L+ZvFxNc3WmtvAkt7co6eCXuoq08T4d41cOf/0jEW1sWeIh
         MKCewQ5gX7lIk3frxAENg9mhzgonpd2qK+yZuOisc4UwY0yRH1nBPYxs24cpRZ29AZ
         0shKMT9BuT2tA==
Date:   Wed, 17 Mar 2021 23:17:28 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        anuj20.g@samsung.com, Javier Gonzalez <javier.gonz@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Selvakumar S <selvakuma.s1@samsung.com>
Subject: Re: [RFC PATCH v3 2/3] nvme: keep nvme_command instead of pointer to
 it
Message-ID: <20210317141728.GC26641@redsun51.ssa.fujisawa.hgst.com>
References: <20210316140126.24900-1-joshi.k@samsung.com>
 <CGME20210316140236epcas5p4de087ee51a862402146fbbc621d4d4c6@epcas5p4.samsung.com>
 <20210316140126.24900-3-joshi.k@samsung.com>
 <20210316171628.GA4161119@dhcp-10-100-145-180.wdc.com>
 <CA+1E3r+vddNqqPh5=+U0v_mLA4=gUdJVhtv3PJzwXXtrfr2xCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3r+vddNqqPh5=+U0v_mLA4=gUdJVhtv3PJzwXXtrfr2xCA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 17, 2021 at 03:08:09PM +0530, Kanchan Joshi wrote:
> On Tue, Mar 16, 2021 at 10:53 PM Keith Busch <kbusch@kernel.org> wrote:
> >
> > On Tue, Mar 16, 2021 at 07:31:25PM +0530, Kanchan Joshi wrote:
> > > nvme_req structure originally contained a pointer to nvme_command.
> > > Change nvme_req structure to keep the command itself.
> > > This helps in avoiding hot-path memory-allocation for async-passthrough.
> >
> > I have a slightly different take on how to handle pre-allocated
> > passthrough commands. Every transport except PCI already preallocates a
> > 'struct nvme_command' within the pdu, so allocating another one looks
> > redundant. Also, it does consume quite a bit of memory for something
> > that is used only for the passthrough case.
> >
> > I think we can solve both concerns by always using the PDU nvme_command
> > rather than have the transport drivers provide it. I just sent the patch
> > here if you can take a look. It tested fine on PCI and loop (haven't
> > tested any other transports).
> >
> >  http://lists.infradead.org/pipermail/linux-nvme/2021-March/023711.html
> 
> Sounds fine, thanks for the patch, looking at it.
> Which kernel you used for these. 'Patch 2' doesn't  apply cleanly.

I used nvme-5.13 as my starting point.

 http://git.infradead.org/nvme.git/shortlog/refs/heads/nvme-5.13
