Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54420563CE2
	for <lists+io-uring@lfdr.de>; Sat,  2 Jul 2022 01:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiGAXtG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 19:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbiGAXtG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 19:49:06 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 398583AA6A
        for <io-uring@vger.kernel.org>; Fri,  1 Jul 2022 16:49:05 -0700 (PDT)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 8A15120CEF
        for <io-uring@vger.kernel.org>; Sat,  2 Jul 2022 08:49:04 +0900 (JST)
Received: by mail-pl1-f197.google.com with SMTP id u13-20020a170902e5cd00b0016a53274671so2129278plf.15
        for <io-uring@vger.kernel.org>; Fri, 01 Jul 2022 16:49:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LSJ3PXNbjfPuNCs9zB53If0JZ50L8HtGybH/fHIylFg=;
        b=5/mti0hGsdW6C3ikmPivWh36Bon6mogwAnkcQenoLUXwWQNptbQ8ugeYqsPct44Hez
         eN/83kI7zyXyPS2PLclAQaeGP6+LZEhcrKFwOs8xNZQvPgPMWEvnP07QnY7YJnSGtAdW
         HfpOs9cDsM1iuEZE3MLzoPNSMFZt0V7tRnG61mU/Tn4io+BdOV1kkD15Df0VnGPmrBPw
         27+KCrppImhMytXzGJXAd0ONQ+g2OD6l4c44+Ufkn3NM82Y4+F+e+ZPDV34G6OwkOtLW
         DCTCeQD1RZbyN7XSY0ICzqtWwi1B2sWEZK3gOz3sq/OVAMyeNvKMFxHXrEUaJFZMeb0l
         BjdQ==
X-Gm-Message-State: AJIora8vS3fZydg6ncoqjHLxq9ITxwAT0oU6bImIY7cfCMJoPEqV++Lz
        WBPZyo3aYibWPbyb/NrVgBVYtL21713aOTrnpx/d78l/HejzdqJxjMDgWPJDiai/tbn6JUgcl1/
        UukwAZtqiNPXMXA3aeZuj
X-Received: by 2002:a17:902:cec9:b0:16a:416c:3d27 with SMTP id d9-20020a170902cec900b0016a416c3d27mr23600849plg.107.1656719343616;
        Fri, 01 Jul 2022 16:49:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1t24xm/saXDVdTU339pirGwPhG1TYMSSgsSiNSXwcWt6iYPii6OI8spYIMjJfkGLSdGcUIVJw==
X-Received: by 2002:a17:902:cec9:b0:16a:416c:3d27 with SMTP id d9-20020a170902cec900b0016a416c3d27mr23600832plg.107.1656719343274;
        Fri, 01 Jul 2022 16:49:03 -0700 (PDT)
Received: from pc-zest.atmarktech (117.209.187.35.bc.googleusercontent.com. [35.187.209.117])
        by smtp.gmail.com with ESMTPSA id a3-20020aa780c3000000b0050dc76281f8sm16140626pfn.210.2022.07.01.16.49.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Jul 2022 16:49:02 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o7QNh-001Bed-0v;
        Sat, 02 Jul 2022 08:49:01 +0900
Date:   Sat, 2 Jul 2022 08:48:51 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <Yr+H45k56ZonFuus@atmark-techno.com>
References: <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
 <Yr2ItqlxeII0sReD@atmark-techno.com>
 <20220630125124.GA446657@falcondesktop>
 <Yr2gQh5GaVmTEDW2@atmark-techno.com>
 <20220630151038.GA459423@falcondesktop>
 <Yr5NJnyKoWqAHsad@atmark-techno.com>
 <20220701084504.GA493565@falcondesktop>
 <20220701103329.GA503971@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220701103329.GA503971@falcondesktop>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Filipe Manana wrote on Fri, Jul 01, 2022 at 11:33:29AM +0100:
> > I'll give it some more testing here along with other minor fixes I have for
> > other scenarios. I'll submit a patchset, with this fix included, on monday.
> 
> In the meanwhile, I've left the patches staging here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/fdmanana/linux.git/log/?h=dio_fixes

Thanks!

Just a small typo in commit message for 'return -EAGAIN for NOWAIT' patch:
> After having read the first extent, when we find the compressed extent we
> eturn -ENOTBLK from btrfs_dio_iomap_begin(), which results in iomap to

return at start of second line missing its r

rest looks good to me, thank you for the fixes :)
-- 
Dominique
