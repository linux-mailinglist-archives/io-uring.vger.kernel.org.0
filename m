Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F506DE303
	for <lists+io-uring@lfdr.de>; Tue, 11 Apr 2023 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbjDKRqp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Apr 2023 13:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjDKRqc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Apr 2023 13:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA756A7F;
        Tue, 11 Apr 2023 10:46:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 333F362A31;
        Tue, 11 Apr 2023 17:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5719CC433EF;
        Tue, 11 Apr 2023 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681235176;
        bh=+KwAX5jvhr8OZFxH2Ho3mZVxPLvKchdh8zwtFvTu3bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hIA74WpO3nlSIHGYDKgAvn00Y7DrZF18Ee7jLN1maDVdy55Ra+zKLSV0tcPyYD/iS
         3BnE923JR7q9lN+K9q1sAM+PkseTcTGGsmmQ/Jglw5We4I5yO1L2GQPCCmwrmEHip5
         z8yYINC4Bp6PQcwc5Y7AudEpq16NQZ/RCWTn7/g+7vHd9T8Md6a/zmQSzLL0r5+FmE
         F8OuCbkaogR+ageptS1irNh5atdKzEnhbOLBU8QLX3kdfpuA1maPCFucviw1shMqYO
         7qN9Tk3qBaUh/nmc1ZHa++bvktaXNuksJUhbpC0ttZlQzYY5IqlYC8HZMIuzYJx/4S
         0Fefvg41+aQxw==
Date:   Tue, 11 Apr 2023 10:46:14 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     Keith Busch <kbusch@meta.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, sagi@grimberg.me
Subject: Re: [PATCHv2 2/5] nvme: simplify passthrough bio cleanup
Message-ID: <ZDWc5iavegZADUyY@kbusch-mbp>
References: <20230407191636.2631046-1-kbusch@meta.com>
 <CGME20230407191711epcas5p3b9b27aa2477b12ec116b85ea3c7d54b7@epcas5p3.samsung.com>
 <20230407191636.2631046-3-kbusch@meta.com>
 <20230410112503.GA16047@green5>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410112503.GA16047@green5>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Apr 10, 2023 at 04:55:03PM +0530, Kanchan Joshi wrote:
> On Fri, Apr 07, 2023 at 12:16:33PM -0700, Keith Busch wrote:
> > +static void nvme_uring_bio_end_io(struct bio *bio)
> > +{
> > +	blk_rq_unmap_user(bio);
> > +}
> > +
> > static int nvme_map_user_request(struct request *req, u64 ubuffer,
> > 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
> > 		u32 meta_seed, void **metap, struct io_uring_cmd *ioucmd,
> > @@ -204,6 +209,7 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
> > 		*metap = meta;
> > 	}
> > 
> > +	bio->bi_end_io = nvme_uring_bio_end_io;
> > 	return ret;
> > 
> > out_unmap:
> > @@ -249,8 +255,6 @@ static int nvme_submit_user_cmd(struct request_queue *q,
> > 	if (meta)
> > 		ret = nvme_finish_user_metadata(req, meta_buffer, meta,
> > 						meta_len, ret);
> > -	if (bio)
> > -		blk_rq_unmap_user(bio);
> 
> Is it safe to call blk_rq_unamp_user in irq context?

Doh! I boxed my thinking into the polling mode that completely neglected the
more common use case. Thanks, now back to the drawing board for me...
