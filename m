Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4439E539AB6
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 03:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbiFABYS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Tue, 31 May 2022 21:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231534AbiFABYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 May 2022 21:24:17 -0400
X-Greylist: delayed 2991 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 31 May 2022 18:24:16 PDT
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A71948CB21;
        Tue, 31 May 2022 18:24:16 -0700 (PDT)
Received: from [45.44.224.220] (port=40386 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <olivier@olivierlanglois.net>)
        id 1nwCJa-0005jM-Mx;
        Tue, 31 May 2022 20:34:22 -0400
Message-ID: <12a76c029e9f3cac279c025776dfb2f59331dca0.camel@olivierlanglois.net>
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
From:   Olivier Langlois <olivier@olivierlanglois.net>
To:     "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, jack@suse.cz, hch@infradead.org
Date:   Tue, 31 May 2022 20:34:20 -0400
In-Reply-To: <Yo/GIF1EoK7Acvmy@magnolia>
References: <20220526173840.578265-1-shr@fb.com>
         <20220526173840.578265-5-shr@fb.com> <Yo/GIF1EoK7Acvmy@magnolia>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - olivierlanglois.net
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@olivierlanglois.net
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@olivierlanglois.net
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 2022-05-26 at 11:25 -0700, Darrick J. Wong wrote:
> On Thu, May 26, 2022 at 10:38:28AM -0700, Stefan Roesch wrote:
> > 
> >  static struct iomap_page *
> > -iomap_page_create(struct inode *inode, struct folio *folio)
> > +iomap_page_create(struct inode *inode, struct folio *folio,
> > unsigned int flags)
> >  {
> >         struct iomap_page *iop = to_iomap_page(folio);
> >         unsigned int nr_blocks = i_blocks_per_folio(inode, folio);
> > +       gfp_t gfp = GFP_NOFS | __GFP_NOFAIL;
> >  
> >         if (iop || nr_blocks <= 1)
> >                 return iop;
> >  
> > +       if (flags & IOMAP_NOWAIT)
> > +               gfp = GFP_NOWAIT;
> 
> Hmm.  GFP_NOWAIT means we don't wait for reclaim or IO or filesystem
> callbacks, and NOFAIL means we retry indefinitely.  What happens in
> the
> NOWAIT|NOFAIL case?  Does that imply that the kzalloc loops without
> triggering direct reclaim until someone else frees enough memory?
> 
> --D

I have a question that is a bit offtopic but since it is concerning GFP
flags and this is what is discussed here maybe a participant will
kindly give me some hints about this mystery that has burned me for so
long...

Why does out_of_memory() requires GFP_FS to kill a process? AFAIK, no
filesystem-dependent operations are needed to kill a process...

