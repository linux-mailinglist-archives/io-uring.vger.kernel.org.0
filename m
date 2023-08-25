Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 802D8789210
	for <lists+io-uring@lfdr.de>; Sat, 26 Aug 2023 00:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjHYWyG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 18:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbjHYWxs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 18:53:48 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979962724
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:53:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68c0d4cc3a4so714033b3a.1
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 15:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693004012; x=1693608812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pUz0mvDJOC9uQjgg5Uba361PK/6ticcfnjAOo3qTtYA=;
        b=F6apRE+SrZTqCeuN1zLMRosK5ge3rhNKZnpOWKEqEdWDSsGDK7EQGyDQsb6/5NjMZA
         3YMPbcTJ/D3BMiY5oD/xtnLm9pzhShZ6+Y7oDMWnO0DfFEZbieWLXokCpFNjeT5nfH1C
         s22NB1Wf7ErFiXowqbOOitIpN8YQ6wn+7f9hHAh/AXrGUdDwlOs/O2qrqcuv4RSpXcnU
         GbrxFepvZAk5VQgoyCmH+APqoM+wo3KvR0eb+zB1BsLvnPOQaJNrJEZsuvoY9FN/6wnP
         PBrjyNBdKOdo0Hj7mZUOQ9904vJZldE2dQql827LKN+udL2AKxU33q1Q1ADVqqMaFs/v
         qugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693004012; x=1693608812;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUz0mvDJOC9uQjgg5Uba361PK/6ticcfnjAOo3qTtYA=;
        b=lmP4IdUpt2Pqkqq089QRikLh06njNr/r0NUTlLikQcjsUVuU2c44RfqczP79y5ZOXQ
         cen410sGJ07bdNCic+zit4YD/ZiT94cEReq8aznrGyaOoFftT7sqeXuRgs+uZ1NVBTAl
         oLyWoyc6gH+5cH6Bw1oDn6MMVQuZS25iwNuywS2UyoytqSDq2ajE0yw3SKzEISNipB1U
         n++1fN7xvgpaEw5TOaWSVDRkgGMFuOenXLQtMPKe5WCSyvK+9p4JkD3xy07RnD4KJltv
         b9fsGqxUJ41eVkh+mJMvwrbiCLz54vNxE8s7Lo+755u0T1dVgNczo/0gOcnfcYrOeXhx
         Yx6g==
X-Gm-Message-State: AOJu0YxrFix8u/6/kK0szvEXqFtZsAK5mY6YBKD2woVCs7zRqZL8RfQs
        FFzsdR5QpQ9L3UkooJI/qlxJkQ==
X-Google-Smtp-Source: AGHT+IF7qLruqklxY40yAH4SKvsJCnFBTQ8pg1x9p8DXB9ryPTSvbA4aGhPPBTQdBXYgxxyeFGZdhA==
X-Received: by 2002:a05:6a20:7354:b0:13d:5b8e:db83 with SMTP id v20-20020a056a20735400b0013d5b8edb83mr20399311pzc.9.1693004012072;
        Fri, 25 Aug 2023 15:53:32 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id u15-20020a62ed0f000000b006887be16675sm2060364pfh.205.2023.08.25.15.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 15:53:31 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZfgG-006WDY-1c;
        Sat, 26 Aug 2023 08:53:28 +1000
Date:   Sat, 26 Aug 2023 08:53:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        "Darrick J . Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-cachefs@redhat.com,
        ecryptfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-unionfs@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-btrfs@vger.kernel.org, codalist@coda.cs.cmu.edu,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-nilfs@vger.kernel.org,
        devel@lists.orangefs.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-mtd@lists.infradead.org,
        Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH RFC v5 00/29] io_uring getdents
Message-ID: <ZOkw6KkdP1UWPNBW@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825135431.1317785-1-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 25, 2023 at 09:54:02PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This series introduce getdents64 to io_uring, the code logic is similar
> with the snychronized version's. It first try nowait issue, and offload
> it to io-wq threads if the first try fails.
> 
> Patch1 and Patch2 are some preparation
> Patch3 supports nowait for xfs getdents code
> Patch4-11 are vfs change, include adding helpers and trylock for locks
> Patch12-29 supports nowait for involved xfs journal stuff
> note, Patch24 and 27 are actually two questions, might be removed later.
> an xfs test may come later.

You need to drop all the XFS journal stuff. It's fundamentally
broken as it stands, and we cannot support non-blocking
transactional changes without first putting a massive investment in
transaction and intent chain rollback to allow correctly undoing
partially complete modifications.

Regardless, non-blocking transactions are completely unnecessary for
a non-blocking readdir implementation. readdir should only be
touching atime, and with relatime it should only occur once every 24
hours per inode. If that's a problem, then we have noatime mount
options. Hence I just don't see any point in worrying about having a
timestamp update block occasionally...

I also don't really don't see why you need to fiddle with xfs buffer
cache semantics - it already has the functionality "nowait" buffer
reads require (i.e.  XBF_INCORE|XBF_TRYLOCK).

However, the readahead IO that the xfs readdir code issues cannot
use your defined NOWAIT semantics - it must be able to allocate
memory and issue IO. Readahead already avoids blocking on memory
allocation and blocking on IO via the XBF_READ_AHEAD flag. This sets
__GFP_NORETRY for buffer allocation and REQ_RAHEAD for IO. Hence
readahead only needs the existing XBF_TRYLOCK flag to be set to be
compatible with the required NOWAIT semantics....

As for the NOIO memory allocation restrictions io_uring requires,
that should be enforced at the io_uring layer before calling into
the VFS using memalloc_noio_save/restore.  At that point no memory
allocation will trigger IO and none of the code running under NOWAIT
conditions even needs to be aware that io_uring has a GFP_NOIO
restriction on memory allocation....

Please go back to the simple "do non-blocking buffer IO"
implementation we started with and don't try to solve every little
blocking problem that might exist in the VFS and filesystems...

-Dave
-- 
Dave Chinner
david@fromorbit.com
