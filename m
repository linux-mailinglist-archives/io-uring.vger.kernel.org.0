Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E61F4E5EB2
	for <lists+io-uring@lfdr.de>; Thu, 24 Mar 2022 07:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232166AbiCXGdy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Mar 2022 02:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiCXGdx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Mar 2022 02:33:53 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9009972BD;
        Wed, 23 Mar 2022 23:32:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9AC0068B05; Thu, 24 Mar 2022 07:32:18 +0100 (CET)
Date:   Thu, 24 Mar 2022 07:32:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 17/17] nvme: enable non-inline passthru commands
Message-ID: <20220324063218.GC12660@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152729epcas5p17e82d59c68076eb46b5ef658619d65e3@epcas5p1.samsung.com> <20220308152105.309618-18-joshi.k@samsung.com> <20220310083652.GF26614@lst.de> <CA+1E3rLaQstG8LWUyJrbK5Qz+AnNpOnAyoK-7H5foFm67BJeFA@mail.gmail.com> <20220310141945.GA890@lst.de> <CA+1E3rL3Q2noHW-cD20SZyo9EqbzjF54F6TgZoUMMuZGkhkqnw@mail.gmail.com> <20220311062710.GA17232@lst.de> <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rLGwHFbdbSTJBfWrw6RLErwcT2zPxGmmWbcLUj2y=16Qg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 22, 2022 at 10:40:27PM +0530, Kanchan Joshi wrote:
> On Fri, Mar 11, 2022 at 11:57 AM Christoph Hellwig <hch@lst.de> wrote:
> > > And that's because this ioctl requires additional "__u64 result;" to
> > > be updated within "struct nvme_passthru_cmd64".
> > > To update that during completion, we need, at the least, the result
> > > field to be a pointer "__u64 result_ptr" inside the struct
> > > nvme_passthru_cmd64.
> > > Do you see that is possible without adding a new passthru ioctl in nvme?
> >
> > We don't need a new passthrough ioctl in nvme.
> Right. Maybe it is easier for applications if they get to use the same
> ioctl opcode/structure that they know well already.

I disagree.  Reusing the same opcode and/or structure for something
fundamentally different creates major confusion.  Don't do it.

> >From all that we discussed, maybe the path forward could be this:
> - inline-cmd/big-sqe is useful if paired with big-cqe. Drop big-sqe
> for now if we cannot go the big-cqe route.
> - use only indirect-cmd as this requires nothing special, just regular
> sqe and cqe. We can support all passthru commands with a lot less
> code. No new ioctl in nvme, so same semantics. For common commands
> (i.e. read/write) we can still avoid updating the result (put_user
> cost will go).
> 
> Please suggest if we should approach this any differently in v2.

Personally I think larger SQEs and CQEs are the only sensible interface
here.  Everything else just fails like a horrible hack I would not want
to support in NVMe.
