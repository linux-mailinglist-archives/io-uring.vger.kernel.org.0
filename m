Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023EE4F576D
	for <lists+io-uring@lfdr.de>; Wed,  6 Apr 2022 10:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiDFHE6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Apr 2022 03:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiDFGXc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Apr 2022 02:23:32 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 123E81D4C2E
        for <io-uring@vger.kernel.org>; Tue,  5 Apr 2022 22:23:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3389D68AFE; Wed,  6 Apr 2022 07:23:30 +0200 (CEST)
Date:   Wed, 6 Apr 2022 07:23:30 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kanchan Joshi <joshiiitr@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Pankaj Raghav <pankydev8@gmail.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        Anuj Gupta <anuj20.g@samsung.com>
Subject: Re: [RFC 5/5] nvme: wire-up support for async-passthru on
 char-device.
Message-ID: <20220406052330.GA10320@lst.de>
References: <20220401110310.611869-1-joshi.k@samsung.com> <CGME20220401110838epcas5p2c1a2e776923dfe5bf65a3e7946820150@epcas5p2.samsung.com> <20220401110310.611869-6-joshi.k@samsung.com> <20220404072016.GD444@lst.de> <CA+1E3rJ+iWAhUVzVrRDiFTUmp5sNF7wqw_7oVqru2qLCTBQrqQ@mail.gmail.com> <20220405060224.GE23698@lst.de> <CA+1E3rJXrUnmc08Zy3yO=0mGJv1q0CaJez4eUDnTpaJcSh_1FQ@mail.gmail.com> <CA+1E3rK3EzyNVwPEuR3tJfRGvScwwrDhxAc9zs=a5XMc9trpmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1E3rK3EzyNVwPEuR3tJfRGvScwwrDhxAc9zs=a5XMc9trpmg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Apr 06, 2022 at 10:50:14AM +0530, Kanchan Joshi wrote:
> > > Also I think we'll want admin command passthrough on /dev/nvmeX as
> > > well, but I'm fine solving the other items first.
> 
> Sure, will add that in the second round. Should be fairly simple as we
> can reuse io-command work anyway.

Yes, I don't think it is a priority right now.  And I'm actually glad
you did this simple version first as that allows us to get the basics
right first.
