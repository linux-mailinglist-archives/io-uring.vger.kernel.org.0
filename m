Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8C4764180
	for <lists+io-uring@lfdr.de>; Wed, 26 Jul 2023 23:55:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjGZVzz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 26 Jul 2023 17:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjGZVzx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 26 Jul 2023 17:55:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8961BD5
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 14:55:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1b9cdef8619so2013875ad.0
        for <io-uring@vger.kernel.org>; Wed, 26 Jul 2023 14:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1690408551; x=1691013351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DvC3igRV4YTXQiSMuZGivvLQo35sXz6p3cb7NoZpRUQ=;
        b=n7g084pwzA+H7izfOTByHdvBzgtiuGiBWNolkwp70Ht/8WnAqIpX40pJ1yIWpg/nub
         qtIufgiVyqhShikuIgAOm1UrMD20TVCKmIk6sLvP9xpDbNoq5XKcAdg4uTjOhtOdV20X
         O4I/fr+Iv44A8X9Qancb9dQ1828/NrRG3cmdaovzriM4x7V6mUDBt+Vy612rmJodnVPO
         tVYga5Ql6uys3v2K6Xt21JNBtM0xutOl9/pjPfJe1YqXUeu6vghbWk02Q4eFkF7GuiL1
         Kj7KAFzo2ZsDdsdK7T43+25Pj4Y/fNL6H/eBF2eeq26fwwCUoc0WomnAmPkfdcD0GC2w
         u6/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690408551; x=1691013351;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvC3igRV4YTXQiSMuZGivvLQo35sXz6p3cb7NoZpRUQ=;
        b=H/WhLT8aasEFZQTNPzX7I98aKje9TCplKkpmA0QcKucng4BTeONujAk3IBCogyvfdq
         MZG9Q7MaZB9KsFE8afs/mUxQ5HqDtms/ppoRborv69+4/G/VyXU0RHRUEmx5s9LqqRJH
         iITC/WTjY7G33NIZAJC3IzAW0mrEzb8oDsH4e598sqDFeWrR7nc/Foqd2NEP/k9VhwRV
         oAvgvpzx5msTI7lzj/eTWYm1pc8kwpEYmZY5o51OjYFUMn/KxHFM0W12jU0h2/amh6m1
         Xrs16zkbqwFJLxJw0FvlGxvatKppMKyoYiO5QurUEroe6HBUPOmbaQ4caZO5QxpThUKs
         69Aw==
X-Gm-Message-State: ABy/qLZ7XGdmPMZR7jy75q46PGgUAdgtD2O3SskygDjJj4pXUYsHaWiy
        fOEfzcSekwGXRpoGlStu8WoMUg0RDtCxcnv/rIw=
X-Google-Smtp-Source: APBJJlGPWzsCfvBj4M7X28jk3hk4oNPO9K8LjNTuDevb9ETbrXoAqG8j6va+DXqvvd0Xlpt9jBwWtw==
X-Received: by 2002:a17:90a:f40d:b0:263:4e41:bdb4 with SMTP id ch13-20020a17090af40d00b002634e41bdb4mr2563386pjb.33.1690408551589;
        Wed, 26 Jul 2023 14:55:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-119-116.pa.vic.optusnet.com.au. [49.186.119.116])
        by smtp.gmail.com with ESMTPSA id ne11-20020a17090b374b00b00268160c6bb8sm59906pjb.31.2023.07.26.14.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jul 2023 14:55:51 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qOmTz-00AuLH-3B;
        Thu, 27 Jul 2023 07:55:48 +1000
Date:   Thu, 27 Jul 2023 07:55:47 +1000
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
        linux-ext4@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 2/7] xfs: add nowait support for xfs_seek_iomap_begin()
Message-ID: <ZMGWYyNz6SUTdRef@dread.disaster.area>
References: <20230726102603.155522-1-hao.xu@linux.dev>
 <20230726102603.155522-3-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726102603.155522-3-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 26, 2023 at 06:25:58PM +0800, Hao Xu wrote:
> From: Hao Xu <howeyxu@tencent.com>
> 
> To support nowait llseek(), IOMAP_NOWAIT semantics should be respected.
> In xfs, xfs_seek_iomap_begin() is the only place which may be blocked
> by ilock and extent loading. Let's turn it into trylock logic just like
> what we've done in xfs_readdir().
> 
> Signed-off-by: Hao Xu <howeyxu@tencent.com>
> ---
>  fs/xfs/xfs_iomap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 18c8f168b153..bbd7c6b27701 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1294,7 +1294,9 @@ xfs_seek_iomap_begin(
>  	if (xfs_is_shutdown(mp))
>  		return -EIO;
>  
> -	lockmode = xfs_ilock_data_map_shared(ip);
> +	lockmode = xfs_ilock_data_map_shared_generic(ip, flags & IOMAP_NOWAIT);

What does this magic XFS function I can't find anywhere in this
patch set do?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
