Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD3EE530190
	for <lists+io-uring@lfdr.de>; Sun, 22 May 2022 09:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiEVH3s (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 May 2022 03:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbiEVH3r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 May 2022 03:29:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A50C39BBE;
        Sun, 22 May 2022 00:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=D1vgKQCOzr8tyZxaNlssCNMEHDUpeBSFVtYkj+gPkKo=; b=PNFXKND4Tu3bYjfu6ohPH+JHPw
        HoifqEgG0ytQiNWIjiUNRqJsunMjfOzIG7F4goa4LwPPTJh7kwM1Q8cb8G6Ll2FHcSlxj8qrud2AI
        z3mWEnzytmgL23fMC18zOeXO3MRdaT+CZdTeBFFLDuqK24qO0DvsGJCuKNP19bM7l9r8/X9Xmn7fm
        BOgOVvnbclbNNClRfGsHXpIzABAQxFlJi0e/Ej6N0TncvnPw4wxHwW0z+EF+fmzUdgZVgzPcg2cL+
        3ilsr+ax/vbY08zh7k8Pz1J9nS7LT0X1ihOKJouOM2aeiJcBTNzBRjylw/3hRlMtXmtcs1v8gG6A3
        P1SBgCYg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nsg25-000nUK-BE; Sun, 22 May 2022 07:29:45 +0000
Date:   Sun, 22 May 2022 00:29:45 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [RFC PATCH v4 10/17] fs: Split off file_needs_update_time and
 __file_update_time
Message-ID: <YonmadckyAqakY7d@infradead.org>
References: <20220520183646.2002023-1-shr@fb.com>
 <20220520183646.2002023-11-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520183646.2002023-11-shr@fb.com>
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

On Fri, May 20, 2022 at 11:36:39AM -0700, Stefan Roesch wrote:
> +static int file_needs_update_time(struct inode *inode, struct file *file,
> +				struct timespec64 *now)
>  {
>  	int sync_it = 0;

No need to pass both and inode and a file as the former can be trivially
derived from the latter.  But if I'm not misreading the patch, file is
entirely unused here anyway, so can't we just drop it and rename the
function to inode_needs_update_time?

> +static int __file_update_time(struct inode *inode, struct file *file,
> +			struct timespec64 *now, int sync_mode)
> +{
> +	int ret = 0;
>  
> +	/* try to update time settings */
> +	if (!__mnt_want_write_file(file)) {
> +		ret = inode_update_time(inode, now, sync_mode);
> +		__mnt_drop_write_file(file);
> +	}

I'd be tempted to just open code this in the two callers, but either
way works for me.  If we keep the function please don't pass the
inode separately.
