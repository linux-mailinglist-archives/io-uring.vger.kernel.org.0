Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CECA543C5A
	for <lists+io-uring@lfdr.de>; Wed,  8 Jun 2022 21:06:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbiFHTGH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jun 2022 15:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbiFHTF4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jun 2022 15:05:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF4A43EC9;
        Wed,  8 Jun 2022 12:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lKNuhahX7MpW+BqerUiiqsAbQFI1rN+WZNKVSeWbP9U=; b=FvxJJOVVniWXVrz5zIIvPNBea1
        ZZ7ymXS+CzkoRp3+RjNcXodDDTao0Dm2C6CFN1vL3QtaeanLXsUBf6zq5JpFMGjOJutuwWGHs/ANo
        IRe1IQ1cgJUyDmAU3xjvSXgYkeY7COH8TfGDUSKsTR6tNHDBu8GNcm36cIo5ejJdx60PdPYsaQz0U
        99QhXS0V6tvSy3gjlCoUS2uIimyr6vjl94HS8lSUZFSqec7G1sN97NbirURfBgENunQyQmicYZizC
        U9/dTJNyHUB99XGF2jNPRU010AXDs3/yY6hlVHpZ/ERln6fJCIxFxPBFc3O4BZdNPGAmA6CkqKxXh
        x//wkGWA==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nz0wx-00CtOa-Ta; Wed, 08 Jun 2022 19:02:39 +0000
Date:   Wed, 8 Jun 2022 20:02:39 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v8 06/14] iomap: Return -EAGAIN from iomap_write_iter()
Message-ID: <YqDyT7uSd0vv15aL@casper.infradead.org>
References: <20220608171741.3875418-1-shr@fb.com>
 <20220608171741.3875418-7-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608171741.3875418-7-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 08, 2022 at 10:17:33AM -0700, Stefan Roesch wrote:
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index b06a5c24a4db..f701dcb7c26a 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -829,7 +829,13 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
>  		length -= status;
>  	} while (iov_iter_count(i) && length);
>  
> -	return written ? written : status;
> +	if (status == -EAGAIN) {
> +		iov_iter_revert(i, written);
> +		return -EAGAIN;
> +	}
> +	if (written)
> +		return written;
> +	return status;
>  }

I still don't understand how this can possibly work.  Walk me through it.

Let's imagine we have a file laid out such that extent 1 is bytes
0-4095 of the file and extent 2 is extent 4096-16385 of the file.
We do a write of 5000 bytes starting at offset 4000 of the file.

iomap_iter() tells us about the first extent and we write the first
96 bytes of our data to the first extent, returning 96.  iomap_iter()
tells us about the second extent, and we write the next 4000 bytes to
the second extent.  Then we get a page fault and get to the -EAGAIN case.
We rewind the iter 4000 bytes.

How do we not end up writing garbage when the kworker does the retry?
I'd understand if we rewound the iter all the way to the start.  Or if
we didn't rewind the iter at all and were able to pick up partway through
the write.  But rewinding to the start of the extent feels like it can't
possibly work.
