Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4765353B932
	for <lists+io-uring@lfdr.de>; Thu,  2 Jun 2022 14:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiFBM52 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jun 2022 08:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231722AbiFBM50 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jun 2022 08:57:26 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0A4243ECD;
        Thu,  2 Jun 2022 05:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=JFp6WmIipFimbqeAO2j6Pm5GVuKNfBoT3pvUwbllZnA=; b=EaOwh2x2mocIMqrnZBG42H9vhj
        fFAYFS+ggTcKhu/R2RtmlDR+KMVxQmsqX1pej1AqDXG5+Wc47ebk0leECNPfHABrz4l/c2xKcss+C
        +2Rd+sZKsuf4Qsm/6GwB8t2NJaK4HdlMPHroCIJYeySix5yjlcgRuGOWKA7N2pRjgz0gJYkL95/NF
        KpJSmRlKBoNaRgt/tQrpY2Gjf6FMySseSZBQjJl1tu6PFDHBMBrOORRBnnnsbZn/vHqQBSGTxa0gw
        v1fBZYuwSwLNl+IUoJr3TywjwoLFhA13CKmDcSsTWesLVtg/updwQjCiPm50wQSp5OqH7L/o+S9H5
        ocqNU0OQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nwkO6-0079V8-OD; Thu, 02 Jun 2022 12:57:18 +0000
Date:   Thu, 2 Jun 2022 13:57:18 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org,
        axboe@kernel.dk
Subject: Re: [PATCH v7 09/15] fs: Split off inode_needs_update_time and
 __file_update_time
Message-ID: <YpizrjBiAvMiXduL@casper.infradead.org>
References: <20220601210141.3773402-1-shr@fb.com>
 <20220601210141.3773402-10-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601210141.3773402-10-shr@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 01, 2022 at 02:01:35PM -0700, Stefan Roesch wrote:
> + /**
> +  * file_update_time - update mtime and ctime time
> +  * @file: file accessed
> +  *
> +  * Update the mtime and ctime members of an inode and mark the inode for
> +  * writeback. Note that this function is meant exclusively for usage in
> +  * the file write path of filesystems, and filesystems may choose to
> +  * explicitly ignore updates via this function with the _NOCMTIME inode
> +  * flag, e.g. for network filesystem where these imestamps are handled
> +  * by the server. This can return an error for file systems who need to
> +  * allocate space in order to update an inode.
> +  *
> +  * Return: 0 on success, negative errno on failure.
> +  */

Can you remove the extra leading space from each of these lines?

