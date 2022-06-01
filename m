Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A9B539F45
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 10:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350570AbiFAIVl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Jun 2022 04:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348724AbiFAIVi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 04:21:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 222638BD09;
        Wed,  1 Jun 2022 01:21:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A0F1E1F8C2;
        Wed,  1 Jun 2022 08:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1654071692; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFW9bTmKBS2+gHojijvkjkqL/6eg0hnOyIs9tcdOTgY=;
        b=rzKGxBWKlTdfgQJeou5aTTP3eotyRDYh0h5IgTWh9X3T+mol14UPDdeW5WuJUV+JsJB05q
        hg+x/HZjYhAN/WUl3jiDHvDs2Sp7G+waBsH5Ktd5/7foaZIrGmYPyuC8Kw3lap9xjfIzXe
        iSUu/C/rSN/RCW9CWT4kmiOirvokkyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1654071692;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qFW9bTmKBS2+gHojijvkjkqL/6eg0hnOyIs9tcdOTgY=;
        b=8O8b/MlDnnsYqt5E0buDIbYgfGJz2wStygFZ2QukhPHcEQ55VrhQiN9iweqFDlO2zvWGOr
        lRTj5r4fXMNxE4BA==
Received: from quack3.suse.cz (unknown [10.163.28.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 6A6D42C141;
        Wed,  1 Jun 2022 08:21:32 +0000 (UTC)
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id 08F35A0633; Wed,  1 Jun 2022 10:21:32 +0200 (CEST)
Date:   Wed, 1 Jun 2022 10:21:31 +0200
From:   Jan Kara <jack@suse.cz>
To:     Olivier Langlois <olivier@olivierlanglois.net>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
Message-ID: <20220601082131.rem4qaqabu4ktofl@quack3.lan>
References: <20220526173840.578265-1-shr@fb.com>
 <20220526173840.578265-5-shr@fb.com>
 <Yo/GIF1EoK7Acvmy@magnolia>
 <12a76c029e9f3cac279c025776dfb2f59331dca0.camel@olivierlanglois.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12a76c029e9f3cac279c025776dfb2f59331dca0.camel@olivierlanglois.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue 31-05-22 20:34:20, Olivier Langlois wrote:
> On Thu, 2022-05-26 at 11:25 -0700, Darrick J. Wong wrote:
> > On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
> > > 
> > >  static struct iomap_page *
> > > -iomap_page_create(struct inode *inode, struct folio *folio)
> > > +iomap_page_create(struct inode *inode, struct folio *folio,
> > > unsigned int flags)
> > >  {
> > >         struct iomap_page *iop = to_iomap_page(folio);
> > >         unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> > > +       gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
> > >  
> > >         if (iop || nr_blocks <= 1)
> > >                 return iop;
> > >  
> > > +       if (flags & IOMAP_NOWAIT)
> > > +               gfp = GFP_NOWAIT;
> > 
> > Hmm.  GFP_NOWAIT means we don't wait for reclaim or IO or filesystem
> > callbacks, and NOFAIL means we retry indefinitely.  What happens in
> > the
> > NOWAIT|NOFAIL case?  Does that imply that the kzalloc loops without
> > triggering direct reclaim until someone else frees enough memory?
> > 
> > --D
> 
> I have a question that is a bit offtopic but since it is concerning GFP
> flags and this is what is discussed here maybe a participant will
> kindly give me some hints about this mystery that has burned me for so
> long...
> 
> Why does out_of_memory() requires GFP_FS to kill a process? AFAIK, no
> filesystem-dependent operations are needed to kill a process...

AFAIK it is because without GFP_FS, the chances for direct reclaim are
fairly limited so we are not sure whether the machine is indeed out of
memory or whether it is just that we need to reclaim from fs pools to free
up memory.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
