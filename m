Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8248653ABE3
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355752AbiFARaM convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 1 Jun 2022 13:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356319AbiFARaD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 13:30:03 -0400
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CF0F78EFD
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 10:30:00 -0700 (PDT)
Received: from [45.44.224.220] (port=40682 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <olivier@trillion01.com>)
        id 1nwSAP-000142-Ov;
        Wed, 01 Jun 2022 13:29:57 -0400
Message-ID: <32fa2fa1db1adcc3c60974fa84a88c74aad82cae.camel@trillion01.com>
Subject: Re: [PATCH v6 04/16] iomap: Add flags parameter to
 iomap_page_create()
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jan Kara <jack@suse.cz>
Cc:     "Darrick J. Wong" <djwong@kernel.org>, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org, kernel-team@fb.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 01 Jun 2022 13:29:55 -0400
In-Reply-To: <20220601082131.rem4qaqabu4ktofl@quack3.lan>
References: <20220526173840.578265-1-shr@fb.com>
         <20220526173840.578265-5-shr@fb.com> <Yo/GIF1EoK7Acvmy@magnolia>
         <12a76c029e9f3cac279c025776dfb2f59331dca0.camel@olivierlanglois.net>
         <20220601082131.rem4qaqabu4ktofl@quack3.lan>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
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

On Wed, 2022-06-01 at 10:21 +0200, Jan Kara wrote:
> > I have a question that is a bit offtopic but since it is concerning
> > GFP
> > flags and this is what is discussed here maybe a participant will
> > kindly give me some hints about this mystery that has burned me for
> > so
> > long...
> > 
> > Why does out_of_memory() requires GFP_FS to kill a process? AFAIK,
> > no
> > filesystem-dependent operations are needed to kill a process...
> 
> AFAIK it is because without GFP_FS, the chances for direct reclaim
> are
> fairly limited so we are not sure whether the machine is indeed out
> of
> memory or whether it is just that we need to reclaim from fs pools to
> free
> up memory.
> 
>                                                                 Honza
Jan,

thx a lot for this lead. I will study it further. Your answer made me
realized that the meaning of direct reclaim was not crystal clear to
me. I'll return to my Bovet & Cesati book to clear that out (That is
probably the book in my bookshelf that I have read the most).

After having sending out my question, I have came up with another
possible explanation...

Maybe it is not so much to send the killing signal to the oom victim
that requires GFP_FS but maybe the trouble the condition is avoiding is
the oom victim process trying to return memory to VFS as it exits while
VFS is busy waiting for its allocation request to succeed...

