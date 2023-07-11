Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F322F74FBE3
	for <lists+io-uring@lfdr.de>; Wed, 12 Jul 2023 01:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjGKXmA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 11 Jul 2023 19:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjGKXl7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 11 Jul 2023 19:41:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ABD10DD
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:41:57 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso4629408a12.1
        for <io-uring@vger.kernel.org>; Tue, 11 Jul 2023 16:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1689118917; x=1691710917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GhImaNl/vKHPtVga17uLuAvCpKdFtQ64MDoZGFNWBmM=;
        b=ybIXeyB0/gJrva9FKRyyXGhv/3WM69tFf1wgKILc6MjPhwzq6g8oAIIVu3gIRgn2Dl
         Km23ZhmjbM38tM9YzGdNtmPH9SP1qtgl8M/6ywC3K19s3IAme+SxA8juyUtpx/gX525z
         i//p+Ot3yd3HKs+oOQfoeGamGPf4Fh9ACTY8eUPFCdPhERjdckiWVSi6OxbMQqQEF0U9
         O9UlQaKyYI7xxP+nFbORM2TzKvHtmWSTcVa26NIvZsf8wLfcW1j2mAahnlGHffxpEnUZ
         8aF1EBJ7pZ1NaUZ41yAlEDKYTb4lJUVY8lHIVgevENE+gWlpp8eUvtUo4q0Kr57zVtOT
         2CMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689118917; x=1691710917;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhImaNl/vKHPtVga17uLuAvCpKdFtQ64MDoZGFNWBmM=;
        b=hDCCChkznargZMGQvJnLFv6moSIYZHMW7/PPhI6pG0wQOfBqjrzUIzp5wj0mZlVek5
         3Zl+iifu0aKDCXIX9zFYUG/lIIirJmWALCq2UJg3R54rFb/5SwMU3osnWdRphA9aS00n
         kBmJkgvvql5JBjZ3y9UxgIt42F69ioIPiT6m/vf1SmCe+fp1xJD4ZdHt4WaMCxDLviZp
         Frm/U1gYAHQh2TgsVI9LfdQgKs7HnLNo+fqywvsErghBq3ttuNGeduJPEFT7dGBkAwUW
         L1gmlpUX7sP0rO96n+o9uMgbPiokGWkCxKFojYEnXNkNrz4JljJqzSUjcF80WGylgo9x
         TuEQ==
X-Gm-Message-State: ABy/qLbGry/EtWnZolVb6CgXJgyAfce8rmjnr3ofdoIahhUrVL4pNqYs
        x8lQzDj/dHoVUqSUPoTDU/Qq6PpG/HI1Evdw2eA=
X-Google-Smtp-Source: APBJJlEmD1r1dg17f2KeI30J+UZXtfiU6A5/KzXIFvhXS3WoylOAKqaoncyUP6zWnydZMZFjPlfZSQ==
X-Received: by 2002:a17:90b:958:b0:263:f72f:491 with SMTP id dw24-20020a17090b095800b00263f72f0491mr7006850pjb.43.1689118917391;
        Tue, 11 Jul 2023 16:41:57 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-246-40.pa.nsw.optusnet.com.au. [49.180.246.40])
        by smtp.gmail.com with ESMTPSA id i12-20020a633c4c000000b0050f85ef50d1sm2154615pgn.26.2023.07.11.16.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jul 2023 16:41:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qJMzR-004yVu-1Y;
        Wed, 12 Jul 2023 09:41:53 +1000
Date:   Wed, 12 Jul 2023 09:41:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Hao Xu <hao.xu@linux.dev>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christian Brauner <brauner@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Stefan Roesch <shr@fb.com>, Clay Harris <bugs@claycon.org>,
        linux-fsdevel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>
Subject: Re: [PATCH 1/3] fs: split off vfs_getdents function of getdents64
 syscall
Message-ID: <ZK3owSS5eENdH7YZ@dread.disaster.area>
References: <20230711114027.59945-1-hao.xu@linux.dev>
 <20230711114027.59945-2-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711114027.59945-2-hao.xu@linux.dev>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 11, 2023 at 07:40:25PM +0800, Hao Xu wrote:
> From: Dominique Martinet <asmadeus@codewreck.org>
> 
> This splits off the vfs_getdents function from the getdents64 system
> call.
> This will allow io_uring to call the vfs_getdents function.
> 
> Co-developed-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  fs/internal.h |  8 ++++++++
>  fs/readdir.c  | 34 ++++++++++++++++++++++++++--------
>  2 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index f7a3dc111026..b1f66e52d61b 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -304,3 +304,11 @@ ssize_t __kernel_write_iter(struct file *file, struct iov_iter *from, loff_t *po
>  struct mnt_idmap *alloc_mnt_idmap(struct user_namespace *mnt_userns);
>  struct mnt_idmap *mnt_idmap_get(struct mnt_idmap *idmap);
>  void mnt_idmap_put(struct mnt_idmap *idmap);
> +
> +/*
> + * fs/readdir.c
> + */
> +struct linux_dirent64;
> +
> +int vfs_getdents(struct file *file, struct linux_dirent64 __user *dirent,
> +		 unsigned int count);

Uh...

Since when have we allowed code outside fs/ to use fs/internal.h?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
