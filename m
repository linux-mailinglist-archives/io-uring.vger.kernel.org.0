Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364E053AC40
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 19:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356479AbiFAR4q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 13:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356484AbiFAR4j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 13:56:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDCD9C2C4;
        Wed,  1 Jun 2022 10:56:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 19BEBB81806;
        Wed,  1 Jun 2022 17:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10F7C385A5;
        Wed,  1 Jun 2022 17:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654106187;
        bh=5rCSgi5B7s546iDUg/FGz27j5Ykan4/jwu+PQ2y0Emk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J3NkZAgk9CcW5kc1N6TE8dB8uPamSLV49ZxIRXRLEYbCs1flaOpxyx/tcRXMfGURC
         h8buw6lTX1IQBR3N5nKEJg1TP4fx+FWH7JWMRPIWqD7VHeBro+KzSZbiBd31u7/MIM
         9m5XHJx8Y+vX/IQpkNNMF02/ElHjgjtR+8lkWN1MfASAPlmgJ1+WtT7oTDkZuQmTwd
         krAhnwy5IbiefBURs8yagojsGWsaZuMDXR0Z4he3hpy2H1/pg0JG+AInz8ZIObW/LE
         k5Rvda11meXsqYW+Zq1LOPS40RFF+O2UHLFWFhmhSRY7P8caxMFZmL/c/HXTyg0zXa
         v3pLP3i8roCYQ==
Date:   Wed, 1 Jun 2022 10:56:27 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     Christoph Hellwig <hch@infradead.org>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <YpeoS90UUOF7IAhH@magnolia>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-5-shr@fb.com>
 <YpW7nKoUB9dJk3ee@infradead.org>
 <a2d5f74f-b354-6590-9910-82c3beca5c88@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d5f74f-b354-6590-9910-82c3beca5c88@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 31, 2022 at 11:12:38AM -0700, Stefan Roesch wrote:
> 
> 
> On 5/30/22 11:54 PM, Christoph Hellwig wrote:
> > On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
> >> Add the kiocb flags parameter to the function iomap_page_create().
> >> Depending on the value of the flags parameter it enables different gfp
> >> flags.
> >>
> >> No intended functional changes in this patch.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> Reviewed-by: Jan Kara <jack@suse.cz>
> >> ---
> >>  fs/iomap/buffered-io.c | 19 +++++++++++++------
> >>  1 file changed, 13 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> >> index 8ce8720093b9..d6ddc54e190e 100644
> >> --- a/fs/iomap/buffered-io.c
> >> +++ b/fs/iomap/buffered-io.c
> >> @@ -44,16 +44,21 @@ static inline struct iomap_page *to_iomap_page(struct folio *folio)
> >>  static struct bio_set iomap_ioend_bioset;
> >>  
> >>  static struct iomap_page *
> >> -iomap_page_create(struct inode *inode, struct folio *folio)
> >> +iomap_page_create(struct inode *inode, struct folio *folio, unsigned int flags)
> >>  {
> >>  	struct iomap_page *iop = to_iomap_page(folio);
> >>  	unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> >> +	gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
> >>  
> >>  	if (iop || nr_blocks <= 1)
> >>  		return iop;
> >>  
> >> +	if (flags & IOMAP_NOWAIT)
> >> +		gfp = GFP_NOWAIT;
> >> +
> > 
> > Maybe this would confuse people less if it was:
> > 
> > 	if (flags & IOMAP_NOWAIT)
> > 		gfp = GFP_NOWAIT;
> > 	else
> > 		gfp = GFP_NOFS | __GFP_NOFAIL;
> > 
> 
> I made the above change.

Thanks.  I misread all the gfp handling as:

	gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;

	if (flags & IOMAP_NOWAIT)
		gfp |= GFP_NOWAIT;

Which was why my question did not make sense.  Sorry about that. :(

--D

> 
> > but even as is it is perfectly fine (and I tend to write these kinds of
> > shortcuts as well).
> > 
> > Looks good either way:
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
