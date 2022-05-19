Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC2CE52CEBC
	for <lists+io-uring@lfdr.de>; Thu, 19 May 2022 10:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiESIyP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 19 May 2022 04:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231418AbiESIyO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 19 May 2022 04:54:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB4BB9CF5C;
        Thu, 19 May 2022 01:54:13 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 87D632190C;
        Thu, 19 May 2022 08:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652950452; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fcqmrpxaer0Q0d9KKEW1aRv2ycWgGPdWyzaSn+WUbBk=;
        b=MCqflNXNG3ngH2MmJW00KgKiExOrIVLN0FjbU1tW/EjTGsQoOt4VFLU44GX9dgv4k0vDWj
        oiGvElYDh1fZtGPXkj4GrjWCc4A2LzW2xS7tI5XSE5jLbx9+Qaj+1ajb/FG1EX2xEp6VHy
        /TTH4BL7tSch0QManLpc1RCH/PFlWkY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652950452;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fcqmrpxaer0Q0d9KKEW1aRv2ycWgGPdWyzaSn+WUbBk=;
        b=CSE0dPEFDF1WBQ1nOUVh0VvJ3pzuB+V0rQ9k1XNYeePdsxTD4zd1GicWO9Gw9VSL9LgghM
        lUuBj/2cI6p+HwBg==
Received: from quack3.suse.cz (unknown [10.100.224.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 76B932C143;
        Thu, 19 May 2022 08:54:12 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 17A81A062F; Thu, 19 May 2022 10:54:12 +0200 (CEST)
Date:   Thu, 19 May 2022 10:54:12 +0200
From:   Jan Kara <jack@suse.cz>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com, jack@suse.cz
Subject: Re: [RFC PATCH v3 15/18] mm: Add
 balance_dirty_pages_ratelimited_async() function
Message-ID: <20220519085412.ngnnhsf6iy35vqn3@quack3.lan>
References: <20220518233709.1937634-1-shr@fb.com>
 <20220518233709.1937634-16-shr@fb.com>
 <YoX/4fwQOYyTL34a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoX/4fwQOYyTL34a@infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu 19-05-22 01:29:21, Christoph Hellwig wrote:
> > +static int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
> > +						bool no_wait)
> >  {
> 
> This doesn't actully take flags, but a single boolean argument.  So
> either it needs a new name, or we actually pass a descriptiv flag.
>
> > +/**
> > + * balance_dirty_pages_ratelimited_async - balance dirty memory state
> > + * @mapping: address_space which was dirtied
> > + *
> > + * Processes which are dirtying memory should call in here once for each page
> > + * which was newly dirtied.  The function will periodically check the system's
> > + * dirty state and will initiate writeback if needed.
> > + *
> > + * Once we're over the dirty memory limit we decrease the ratelimiting
> > + * by a lot, to prevent individual processes from overshooting the limit
> > + * by (ratelimit_pages) each.
> > + *
> > + * This is the async version of the API. It only checks if it is required to
> > + * balance dirty pages. In case it needs to balance dirty pages, it returns
> > + * -EAGAIN.
> > + */
> > +int  balance_dirty_pages_ratelimited_async(struct address_space *mapping)
> > +{
> > +	return balance_dirty_pages_ratelimited_flags(mapping, true);
> > +}
> > +EXPORT_SYMBOL(balance_dirty_pages_ratelimited_async);
> 
> I'd much rather export the underlying
> balance_dirty_pages_ratelimited_flags helper than adding a pointless
> wrapper here.  And as long as only iomap is supported there is no need
> to export it at all.

This was actually my suggestion so I take the blame ;) I have suggested
this because I don't like non-static functions with bool arguments (it is
unnecessarily complicated to understand what the argument means or grep for
it etc.). If you don't like the wrapper, creating

int balance_dirty_pages_ratelimited_flags(struct address_space *mapping,
					  unsigned int flags)

and have something like:

#define BDP_NOWAIT 0x0001

is fine with me as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
