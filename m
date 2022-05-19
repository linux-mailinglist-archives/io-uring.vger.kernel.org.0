Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BDD52CE0D
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbiESISY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiESIST (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:18:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE40E65D3B;
        Thu, 19 May 2022 01:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vsLx1/spK6mJV5vHHVr4BL4tfcrdDPT/6wGxnfZrwzQ=; b=Nueh0SVjlOcrYRUmlBQHIDStKp
        q/JvdZWEKOA5UXUsvj37TSFUhVV2uWFXDbOuq93KlW5L4pDnA/cTiawA+Lz+Tgd8dPqZg/7bHWYNr
        6cyCAUf7pd93hmnOetbaWxTqMmT5OY7Yz2ylPys5QmGdjNW5lgZKP8vNcKsZxCgEyzV/Sw5k+zmWI
        lhLr1emyyulQrvY0od1NIv1cwaVflU4ZOM6d7hWVTD4iMOPcfbbKn1p0tbSdZ8ntpp54OVilGIA1E
        CeTKwCHoO2IWsMIQwknGmZfRiqycfNxeJ57amsIU/0LIrjtt9Xh/vLHKuNp0DSr6VdJLZ0moyd3xz
        eyiJA/ug==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nrbLR-005kBD-Ai; Thu, 19 May 2022 08:17:17 +0000
Date:   Thu, 19 May 2022 01:17:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 01/18] block: Add check for async buffered writes
 to generic_write_checks
Message-ID: <YoX9DVU5ds+GbKOK@infradead.org>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-2-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518233709.1937634-2-shr@fb.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 18, 2022 at 04:36:52PM -0700, Stefan Roesch wrote:
> @@ -1633,7 +1633,9 @@ int generic_write_checks_count(struct kiocb *iocb, loff_t *count)
>  	if (iocb->ki_flags & IOCB_APPEND)
>  		iocb->ki_pos = i_size_read(inode);
>  
> -	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +		!((iocb->ki_flags & IOCB_DIRECT) ||
> +		  (file->f_mode & FMODE_BUF_WASYNC)))

This is some really odd indentation.  I'd expect something like:

	if ((iocb->ki_flags & IOCB_NOWAIT) &&
	    !((iocb->ki_flags & IOCB_DIRECT) ||
	      (file->f_mode & FMODE_BUF_WASYNC)))

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index bbde95387a23..3b479d02e210 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -177,6 +177,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  /* File supports async buffered reads */
>  #define FMODE_BUF_RASYNC	((__force fmode_t)0x40000000)
>  
> +/* File supports async nowait buffered writes */
> +#define FMODE_BUF_WASYNC	((__force fmode_t)0x80000000)

This is the last available flag in fmode_t.

At some point we should probably move the static capabilities to
a member of file_operations.
