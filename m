Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60427890CD
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 23:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjHYVyZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Aug 2023 17:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbjHYVx6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Aug 2023 17:53:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64E126B8
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 14:53:54 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-2680eee423aso841484a91.2
        for <io-uring@vger.kernel.org>; Fri, 25 Aug 2023 14:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1693000434; x=1693605234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EA93GbJhFaX1RD1S1v1NWvgWKkuCopUaLEmO6z67OS0=;
        b=cH08dFt6/4c3wH/stFXC+uGu5D8z0Csp+c9btLL74n40FUQC+soJCMHngcXZEBLgzm
         qybrDAhkHNIQidm6McS9k7OAisvjKsYcisQszCCpar5CuSiRIpSFGB178B7PZGJmjIVI
         4C//pqzQHhkBzMUsweM/Ox4iwIPKOu4SLlyG1BwihVAd4isMoJvmKve8ppg0AFR80Lm5
         +9HwDLBwFdO48zPf3pAy2OfApTkcKybUvjmHUA0hm0UnLP/VyyPd03hkf4rprWixbIcJ
         VF2B37IJ0D+t2NzeGs35vYm6/AeFMMVd3Duqbo/sN/EdZ49iAcVRSUTD7gvcubzYge+h
         CorA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693000434; x=1693605234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EA93GbJhFaX1RD1S1v1NWvgWKkuCopUaLEmO6z67OS0=;
        b=CvaGGn39Yc0TXAB7LzJ0RcnSDdeSkZx5ZxgnfyACgE+VfvfChLro215F1yYGQHtq28
         m4Kc9mi5SAvXzHUQW49EPDqDKIxNz3ZAqQG+CgHkJFOthlHsNSO+6KM58fb5JewNnS/y
         0dtMPIXTbhgk3chdZ1wyo9HkJtki4eowdO09Xptr6OXHdowBMvlT31pgHl78dt5HRARH
         NMGodvTIg/CveEsoPuqWsbS5XmlYpAKZ/X62pw6tD4LuSgS0tfyPB3aBFBw/vGhlqQpD
         w2KhZmqSS1q+hNboV1+3a+5ZN7bdm0TzQL4jEWwSldkGdsQu3YR9ROGEHi2nDWlTHMfh
         AbGg==
X-Gm-Message-State: AOJu0YzRaTIuboO02qj0/ND3MgpXXf2Lp7emafj/19ur3YwcW3/MipQQ
        aXgvCQyMWv5QpYH/zYhvBPK5Lg==
X-Google-Smtp-Source: AGHT+IGuXiZpaiaSoWbg0vAVB9MheRguVETxlh6z74Aponrqbg78kQHVeidygYbMeETEncHmOPB93Q==
X-Received: by 2002:a17:90a:bf88:b0:263:5d25:150c with SMTP id d8-20020a17090abf8800b002635d25150cmr15563047pjs.29.1693000434105;
        Fri, 25 Aug 2023 14:53:54 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id fz23-20020a17090b025700b0026b4decfe59sm2177778pjb.31.2023.08.25.14.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 14:53:53 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qZekY-006V5n-1X;
        Sat, 26 Aug 2023 07:53:50 +1000
Date:   Sat, 26 Aug 2023 07:53:50 +1000
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
Subject: Re: [PATCH 24/29] xfs: support nowait for xfs_buf_read_map()
Message-ID: <ZOki7u/zJGmZtL6g@dread.disaster.area>
References: <20230825135431.1317785-1-hao.xu@linux.dev>
 <20230825135431.1317785-25-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230825135431.1317785-25-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 25, 2023 at 09:54:26PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> This causes xfstests generic/232 hung in umount process, waiting for ail
> push, so I comment it for now, need some hints from xfs folks.
> Not a real patch.
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_buf.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index cdad80e1ae25..284962a9f31a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -828,6 +828,13 @@ xfs_buf_read_map(
>  	trace_xfs_buf_read(bp, flags, _RET_IP_);
>  
>  	if (!(bp->b_flags & XBF_DONE)) {
> +//		/*
> +//		 * Let's bypass the _xfs_buf_read() for now
> +//		 */
> +//		if (flags & XBF_NOWAIT) {
> +//			xfs_buf_relse(bp);
> +//			return -EAGAIN;
> +//		}

This is *fundamentally broken*, and apart from anything else breaks
readahead.

IF we asked for a read, we cannot instantiate the buffer and then
*not issue any IO on it* and release it. That leaves an
uninitialised buffer in memory, and there's every chance that
something then trips over it and bad things happen.

A buffer like this *must* be errored out and marked stale so that
the next access to it will then re-initialise the buffer state and
trigger any preparatory work that needs to be done for the new
operation.

This comes back to my first comments that XBF_TRYLOCK cannot simpy
be replaced with XBF_NOWAIT semantics...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
