Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C521558A1B
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 22:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiFWUcN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 16:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbiFWUcM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 16:32:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0565954BFE;
        Thu, 23 Jun 2022 13:32:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B0141B82524;
        Thu, 23 Jun 2022 20:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1DFC341C0;
        Thu, 23 Jun 2022 20:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656016329;
        bh=Clr2VKSEJiMP39AvV+ufw35sqUO2mGVCAlbFyCZMF84=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cAV4S2Ey/Bb99XrMESIg7GqUjLxCEVunSVQ/EpY7iMGhE5pLQ8qqdsGpH/Y0GXk9Q
         MrlG8X8VYEp1GVmihq6kQGdPl/Xj6nClTXc1fTLzM/UcDH1KmujuDcXqsKwQQ6NShD
         f8/T6A00hHgGAk0phcB+iS3IBbRsc36iMjTV9ILXpFooO8P3+Gkk4yENJC62pfpane
         fN33EjeOjA2NOloy6gxYHk2Emsa6tBsYU0cD8lXAuXHibAK2KjJAiR9NN45kFrIVSD
         AnoxC7QgA34ouBbdbi1zR3qWiU8XOvlc42YVkUy7w5bjtHEgVmJ8NohNxK/9EVANOY
         NPl3mCNbxillw==
Date:   Thu, 23 Jun 2022 13:32:08 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk, willy@infradead.org
Subject: Re: [RESEND PATCH v9 06/14] iomap: Return -EAGAIN from
 iomap_write_iter()
Message-ID: <YrTNyJDBmb9kfvSd@magnolia>
References: <20220623175157.1715274-1-shr@fb.com>
 <20220623175157.1715274-7-shr@fb.com>
 <YrTKnzpfaaExxXAS@magnolia>
 <1f121d1e-8a50-5152-d984-c9299ced1491@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f121d1e-8a50-5152-d984-c9299ced1491@fb.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 23, 2022 at 01:23:02PM -0700, Stefan Roesch wrote:
> 
> 
> On 6/23/22 1:18 PM, Darrick J. Wong wrote:
> > On Thu, Jun 23, 2022 at 10:51:49AM -0700, Stefan Roesch wrote:
> >> If iomap_write_iter() encounters -EAGAIN, return -EAGAIN to the caller.
> >>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> ---
> >>  fs/iomap/buffered-io.c | 8 +++++++-
> >>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> >> index 83cf093fcb92..f2e36240079f 100644
> >> --- a/fs/iomap/buffered-io.c
> >> +++ b/fs/iomap/buffered-io.c
> >> @@ -830,7 +830,13 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
> >>  		length -= status;
> >>  	} while (iov_iter_count(i) && length);
> >>  
> >> -	return written ? written : status;
> >> +	if (status == -EAGAIN) {
> >> +		iov_iter_revert(i, written);
> >> +		return -EAGAIN;
> >> +	}
> >> +	if (written)
> >> +		return written;
> >> +	return status;
> > 
> > Any particular reason for decomposing the ternary into this?  It still
> > looks correct, but it doesn't seem totally necessary...
> >
> 
> Do you prefer this version?
> 
> +	if (status == -EAGAIN) {
> +		iov_iter_revert(i, written);
> +		return -EAGAIN;
> +	}
> 	return written ? written : status;

Yes, because it /does/ make it a lot more obvious that the only change
is intercepting EAGAIN to rewind the iov_iter. :)

--D

> 
>  
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > --D
> > 
> >>  }
> >>  
> >>  ssize_t
> >> -- 
> >> 2.30.2
> >>
