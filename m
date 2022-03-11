Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6804D5BC1
	for <lists+io-uring@lfdr.de>; Fri, 11 Mar 2022 07:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346856AbiCKGuc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Mar 2022 01:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346580AbiCKGub (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Mar 2022 01:50:31 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04F117776C;
        Thu, 10 Mar 2022 22:49:28 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CF83168AFE; Fri, 11 Mar 2022 07:49:25 +0100 (CET)
Date:   Fri, 11 Mar 2022 07:49:25 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Keith Busch <kbusch@kernel.org>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, sbates@raithlin.com,
        logang@deltatee.com, Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Adam Manzanares <a.manzanares@samsung.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [PATCH 13/17] nvme: allow user passthrough commands to poll
Message-ID: <20220311064925.GB17728@lst.de>
References: <20220308152105.309618-1-joshi.k@samsung.com> <CGME20220308152720epcas5p19653942458e160714444942ddb8b8579@epcas5p1.samsung.com> <20220308152105.309618-14-joshi.k@samsung.com> <20220308170857.GA3501708@dhcp-10-100-145-180.wdc.com> <CA+1E3rLEJ49jp678Us1C3ux2iu4KWT9FF+iMjY5_Ug2MAU1q7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rLEJ49jp678Us1C3ux2iu4KWT9FF+iMjY5_Ug2MAU1q7w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 09, 2022 at 12:33:33PM +0530, Kanchan Joshi wrote:
> Would it be better if we don't try to pass NVME_HIPRI by any means
> (flags or rsvd1/rsvd2), and that means not enabling sync-polling and
> killing this patch.
> We have another flag "IO_URING_F_UCMD_POLLED" in ioucmd->flags, and we
> can use that instead to enable only the async polling. What do you
> think?

Yes, polling should be a io_uring level feature.
