Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3112774FBEA
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 01:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbjGKXr7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 19:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjGKXr7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 19:47:59 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20D11712
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:47:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-676f16e0bc4so3132191b3a.0
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689119277; x=1691711277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZCay/U1RrEecnRFjhTVjnG65uF6mvqkW/xdC2I0frE4=;
        b=lmvt7ZTI9XgTPI9CU/xbWuKnvnKy0d0muySJbYf6G2fXnXF8KJPoflclfaLKiJGkFP
         HG3C6Epehxl5ZJDeUwWOrA2YE8iG+zamIlg4a+15rRZrIf5nPodEk7NzV4+gF3jeKO2a
         MHDlbARt28rc9H1N3tZSMfU5ylLR7KpLZ70t45Ipbrs8viyQgM17Pn21236khPcIyVpM
         q8vt3teHXqT9uybmv4iUeM0q/3Kr40DspOTJ3s8VwBNcIV1m1merdWsyWO1SV2p6YMUv
         AvLcx2vmCDd7Hi/2dO8MVNbjEcvbnVRQQFtJFAsVM3BsU8p910/rLK2hKgSoGtuxU82I
         oTeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689119277; x=1691711277;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZCay/U1RrEecnRFjhTVjnG65uF6mvqkW/xdC2I0frE4=;
        b=iUcu7hMRKBBP8k74uD6LfmXlfQHsmrbcYVPIkAmEctbOaT/Y1RHm9kk1a6vGJvYX74
         s82Uz16OnTPx8qrpLq8DRmsX+X/2s+kLRzPMLaYRXEuCYiulcla13t/VcaPnF09XkNap
         ZVR8oOdMjWsoadFZCPQe5Rzynx2/H1TK26UCN2EFFyS/od95kDAh4pmMffsXbpj/wDOc
         S2KFN6EHhbDonczabUGxoVVxLEdhTcEdOUqmYw6HfLNWfp1L1iCPt2dWdF5iWHqdbvYz
         GvdeIBk5vjYkD4I4IFopSGKzlYCMcmu4n+i2O3LockYXPOpYL4hb7z4L6mVmBsvyDoOR
         pajw==
X-Gm-Message-State: ABy/qLZJUn2+j49+GAu1YfEth4iyrJCaFQmd5Q6ll3OXvy1UHn4mwfh9
        PGhHVCXv/7cFWiTks1bNW/O37A==
X-Google-Smtp-Source: APBJJlHV6Rle475Ry7ncBqyxCTLlNFLiOaL0axgkatoQ/9FPY4rIHH6lmMoeC9SIK4xxpd/+JjtZBQ==
X-Received: by 2002:a05:6a20:8e25:b0:127:7ea7:e039 with SMTP id y37-20020a056a208e2500b001277ea7e039mr16261637pzj.62.1689119277206;
        Tue, 11 Jul 2023 16:47:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id bd5-20020a170902830500b001b8761c739csm2459281plb.271.2023.07.11.16.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 16:47:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJN5G-004yaH-1D;
        Wed, 12 Jul 2023 09:47:54 +1000
Date:   Wed, 12 Jul 2023 09:47:54 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH v3 0/3] io_uring getdents
Message-ID: <ZK3qKrlOiLxS/ZEK@dread.disaster.area>
References: <20230711114027.59945-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711114027.59945-1-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 07:40:24PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This series introduce getdents64 to io_uring, the code logic is similar
> with the snychronized version's. It first try nowait issue, and offload
> it to io-wq threads if the first try fails.
> 
> 
> v2->v3:
>  - removed the kernfs patches
>  - add f_pos_lock logic
>  - remove the "reduce last EOF getdents try" optimization since
>    Dominique reports that doesn't make difference
>  - remove the rewind logic, I think the right way is to introduce lseek
>    to io_uring not to patch this logic to getdents.
>  - add Singed-off-by of Stefan Roesch for patch 1 since checkpatch
>    complained that Co-developed-by someone should be accompanied with
>    Signed-off-by same person, I can remove them if Stefan thinks that's
>    not proper.
> 
> 
> Dominique Martinet (1):
>   fs: split off vfs_getdents function of getdents64 syscall
> 
> Hao Xu (2):
>   vfs_getdents/struct dir_context: add flags field
>   io_uring: add support for getdents

So what filesystem actually uses this new NOWAIT functionality?
Unless I'm blind (quite possibly) I don't see any filesystem
implementation of this functionality in the patch series.

I know I posted a prototype for XFS to use it, and I expected that
it would become part of this patch series to avoid the "we don't add
unused code to the kernel" problem. i.e. the authors would take the
XFS prototype, make it work, add support into for the new io_uring
operation to fsstress in fstests and then use that to stress test
the new infrastructure before it gets merged....

But I don't see any of this?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
