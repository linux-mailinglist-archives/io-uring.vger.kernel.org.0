Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D03D5230D3
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 12:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239761AbiEKKjL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 06:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239215AbiEKKiv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 06:38:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C2E972EA;
        Wed, 11 May 2022 03:38:21 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 670E41F8BD;
        Wed, 11 May 2022 10:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1652265500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4tTLKw2T1YJw2h64F0XA5FNUzlXdoEokzJSTtL8FUkQ=;
        b=bG8nnKVtGj3yFB2bYY0/5PA5bmjOTJDVIoLqqd9KdpcYSXf8QGJOiTW01XgUBeUAcPWzNE
        Uxl4VehVcjthenpwvwdywRBSOY0/VzQn8O60bjFcdZJ0M/wEK6GL3tP02wHC6GvWVbNA+O
        UygBNsCDCkHg7543KvneMVdPNUdOpXI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1652265500;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4tTLKw2T1YJw2h64F0XA5FNUzlXdoEokzJSTtL8FUkQ=;
        b=iuSY6arEDo71FBr6jsiFeqwbiuG4a9UPmA9hWAbeTep9hfZ0YPmSP45i976ogH11bL7YbT
        ZP2lVpFH6K19Z3Cw==
Received: from quack3.suse.cz (unknown [10.163.43.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 389452C141;
        Wed, 11 May 2022 10:38:20 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E70D3A062A; Wed, 11 May 2022 12:38:19 +0200 (CEST)
Date:   Wed, 11 May 2022 12:38:19 +0200
From:   Jan Kara <jack@suse.cz>
To:     Stefan Roesch <shr@fb.com>
Cc:     Jan Kara <jack@suse.cz>, io-uring@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com
Subject: Re: [RFC PATCH v1 15/18] mm: support write throttling for async
 buffered writes
Message-ID: <20220511103819.e2irxxm2tvb3k7cc@quack3.lan>
References: <20220426174335.4004987-1-shr@fb.com>
 <20220426174335.4004987-16-shr@fb.com>
 <20220428174736.mgadsxfuiwmoxrzx@quack3.lan>
 <88879649-57db-5102-1bed-66f610d13317@fb.com>
 <20220510095036.6tbbwwf5hxcevzkh@quack3.lan>
 <84f8da94-1227-a351-56ba-eabdba91027b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84f8da94-1227-a351-56ba-eabdba91027b@fb.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue 10-05-22 13:16:30, Stefan Roesch wrote:
> On 5/10/22 2:50 AM, Jan Kara wrote:
> > I know that you're using fields in task_struct to propagate the delay info.
> > But IMHO that is unnecessary (although I don't care too much). Instead we
> > could factor out a variant of balance_dirty_pages() that returns 'pause' to
> > sleep, 0 if no sleeping needed. Normal balance_dirty_pages() would use this
> > for pause calculation, places wanting async throttling would only get the
> > pause to sleep. So e.g. iomap_write_iter() would then check and if returned
> > pause is > 0, it would abort the loop similary as we'd abort it for any
> > other reason when NOWAIT write is aborted because we need to sleep. Iouring
> > code then detects short write / EAGAIN and offloads the write to the
> > workqueue where normal balance_dirty_pages() can sleep as needed.
> > 
> > This will make sure dirty limits are properly observed and we don't need
> > that much special handling for it.
> >
> 
> I like the idea of factoring out a function out balance_dirty_pages(), however
> 
> I see two challenges:
> - the write operation has already completed at this point,
> - so we can't really sleep on its completion in the io-worker in io-uring
> - we don't know how long to sleep in io-uring
> 
> Currently balance_dirty_pages_ratelimited() is called at the end of the
> function iomap_write_iter(). If the function
> balance_dirty_pages_ratelimited() would instead be called at the
> beginning of the function iomap_write_iter() we could return -EAGAIN and
> then complete it in the io-worker.

Well, we call balance_dirty_pages_ratelimited() after each page. So it does
not really matter much if the sleep is pushed to happen one page later.
balance_dirty_pages_ratelimited() does ratelimiting of when
balance_dirty_pages() are called so we have to make sure
current->nr_dirtied is not zeroed out before we really do wait (because
that is what determines whether we enter balance_dirty_pages() and how long
we sleep there) but looking at the code that should work out just fine.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
