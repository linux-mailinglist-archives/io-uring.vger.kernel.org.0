Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB096EC2F2
	for <lists+io-uring@lfdr.de>; Mon, 24 Apr 2023 00:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbjDWWkw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Apr 2023 18:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbjDWWkv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Apr 2023 18:40:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCE610D2
        for <io-uring@vger.kernel.org>; Sun, 23 Apr 2023 15:40:50 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1a516fb6523so43333335ad.3
        for <io-uring@vger.kernel.org>; Sun, 23 Apr 2023 15:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682289649; x=1684881649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qJoCBx/Q1jcOUgMkdf7CgZKmWWzrWmg6H8ECnSNWR6E=;
        b=O6P/FSq/dKnDznNwJVyruTFlIBEnMURUSwEPSWxnSHC9QwV5oes7jlBoSIyiRxaGrO
         buwvmBiN0QHxcMDNzk9R5XVt7LT/v5URSVNroRV7nUwSOf9xdbuE1AKhJIRQqdeTPWgs
         twPEQh0nx910UgY+jkTocIwc6fuI2vjl5mBwalV4IuYtTEyruQ9G3EZk/ARN9lc3kCk7
         w8ShIneCGU72JzB1uMKOr19iMxrImtzcYnmxoeDfpdiExjOLAxkQvOgChXariYl73+1n
         Jylkibmxc0W4IOgMQh6daFeW3a5srjN3l3ibIr+wZXYcmf3ETXSk+RQo7qNcovyq4kQh
         IcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682289649; x=1684881649;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJoCBx/Q1jcOUgMkdf7CgZKmWWzrWmg6H8ECnSNWR6E=;
        b=V3564MgQdL0lc40tnaE5y0mKIca7Dceyd72m51OHpdeL+pI5xh8AJPn/7wfq6mWL/Y
         bZNpxbmiXECuNKwx6fZi9sPhZBG5jt3Z4Sv4Fv4+VNk8KlVHCIXZtGsriDcAkXCKI9Xs
         YNku2as4OmNjz2zrCe1sB8t/lSSKyWI5JjzdglqqGAmRx9DJExYGxjRSoaMfv/xD1MmI
         FqgJFPZ6/tlG80bUhC6sBLZlJjzEOf9aNceBW4UP25zVPX8O7dKfNeLFD5gaQeIkXMn6
         oR029L3bmGo6ooWPSUVrP6qLdecMzqfNtGiQlNH1FkphTRmSOEXKhsUbjN3KP0kJiJIK
         dpBg==
X-Gm-Message-State: AAQBX9doGQ4nb/ujrntB+j0f5shNVkXf5FMlqcPJM2kHqmXGkLn5Hs32
        dzue1tSMLGrCEzTGHeAgmgXeQw==
X-Google-Smtp-Source: AKy350ZnbBgNeV+rH8qoJGNZ9POws03uX0vApyqN0AX018wsPSVkBYMUNOyfT6DwyD74cjdktp3BRA==
X-Received: by 2002:a17:903:2446:b0:1a8:1e8c:95f5 with SMTP id l6-20020a170903244600b001a81e8c95f5mr15852463pls.69.1682289648991;
        Sun, 23 Apr 2023 15:40:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id jw20-20020a170903279400b001a525b082a5sm5433199plb.199.2023.04.23.15.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 15:40:48 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pqiNx-0074Qh-RX; Mon, 24 Apr 2023 08:40:45 +1000
Date:   Mon, 24 Apr 2023 08:40:45 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <20230423224045.GS447837@dread.disaster.area>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Apr 22, 2023 at 05:40:19PM +0900, Dominique Martinet wrote:
> This add support for getdents64 to io_uring, acting exactly like the
> syscall: the directory is iterated from it's current's position as
> stored in the file struct, and the file's position is updated exactly as
> if getdents64 had been called.
> 
> Additionally, since io_uring has no way of issuing a seek, a flag
> IORING_GETDENTS_REWIND has been added that will seek to the start of the
> directory like rewinddir(3) for users that might require such a thing.
> This will act exactly as if seek then getdents64 have been called
> sequentially with no atomicity guarantee:
> if this wasn't clear it is the responsibility of the caller to not use
> getdents multiple time on a single file in parallel if they want useful
> results, as is currently the case when using the syscall from multiple
> threads.
> 
> Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
> ---
>  include/uapi/linux/io_uring.h |  7 ++++++
>  io_uring/fs.c                 | 51 +++++++++++++++++++++++++++++++++++++++++++
>  io_uring/fs.h                 |  3 +++
>  io_uring/opdef.c              |  8 +++++++
>  4 files changed, 69 insertions(+)

This doesn't actually introduce non-blocking getdents operations, so
what's the point? If it just shuffles the getdents call off to a
background thread, why bother with io_uring in the first place?

Filesystems like XFS can easily do non-blocking getdents calls - we
just need the NOWAIT plumbing (like we added to the IO path with
IOCB_NOWAIT) to tell the filesystem not to block on locks or IO.
Indeed, filesystems often have async readahead built into their
getdents paths (XFS does), so it seems to me that we really want
non-blocking getdents to allow filesystems to take full advantage of
doing work without blocking and then shuffling the remainder off to
a background thread when it actually needs to wait for IO....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
