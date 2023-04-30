Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808DB6F2B80
	for <lists+io-uring@lfdr.de>; Mon,  1 May 2023 01:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjD3XPh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 30 Apr 2023 19:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232066AbjD3XPg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 30 Apr 2023 19:15:36 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F0B3E59
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 16:15:34 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b52ad6311so2327271b3a.2
        for <io-uring@vger.kernel.org>; Sun, 30 Apr 2023 16:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682896533; x=1685488533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9Q+s0+OnCUoBcBsQ1mgXKk3XZ2rrrwexNiNcndLPg90=;
        b=tols+8W6zRiyPxwuLq+ysjSxa8Z5Vds12VagJFIgXb0n2SIbS7/wL194NjCDUjVk14
         YueyHl8D4LDNHPo7y4+5fYIkRuSk184yRqhjhSuXMP/qd5Va99CMVsFE3XXxVtqzXT4c
         D4G7j2iUQw2lLX/rrS2LedRUlPswiQe1hp/xQMd92J53se0PZcYVRHztQkLbgmBPhw1p
         m2FYjRCOIZT5fCUhyc3Ao4gpO8QsNb3DO0sCsFlWQGjeGLAzUvsWUZ6v/bO2tkmO6gu/
         dU8AmUyp4/Pl5FY3kK9EKaw5/2+P71fPSNHFN1Kx/UEcCPcwrxNAdeOyEeUjgQrS0lEC
         l6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682896533; x=1685488533;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Q+s0+OnCUoBcBsQ1mgXKk3XZ2rrrwexNiNcndLPg90=;
        b=cY11fPQ8LjXkGkNBaiIWtaQ4pd7enVE4nd5xR/dW8vyx6YU/Fd8CD4op/JA/mWGEH1
         Wo61C0OUimlO/Qm00XQaAcf21THDxnVqiztqYypWRJ47XovPNhBIJ9eCskNL8vYYq72y
         OvBNYR+kPRERHd1ivMCcIt8Vl3jmPtNv0FeLAD06OB1w4Wk3IWe70kJ33CqlweHOv2OF
         AuKznq9/ARI5OdXj+vfQtgJfbFCiqroErQcFzyrwgFRut6lRKCONwixBEP8+lZVvnX0I
         vka9TSg5jT9qZLAGlZ5BpyrIDHrhupDS1RNTSwf5NG0qHhYii3CQ1KZn9Mi8SncuUDZG
         BqCw==
X-Gm-Message-State: AC+VfDzjvnPqUxDvgRge9tG5Uzeyuv0xOHJEGhmcUZze5t9cWRhdMjsp
        XLabDPLhobLPk7kjpGeRXweXTN25RSk8aldxw0E=
X-Google-Smtp-Source: ACHHUZ4l5lvMLooEkU/SgTGTY9YcOj9P/BpERpngajzPsAEdBbKE6JKOYJXsobK0yIvz6R5DNgA84g==
X-Received: by 2002:a05:6a20:42a8:b0:f3:a3b7:ae37 with SMTP id o40-20020a056a2042a800b000f3a3b7ae37mr16150170pzj.29.1682896533439;
        Sun, 30 Apr 2023 16:15:33 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id f7-20020a056a00228700b0062d7c0ccb3asm18748660pfe.103.2023.04.30.16.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Apr 2023 16:15:32 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptGGP-009qCC-0L; Mon, 01 May 2023 09:15:29 +1000
Date:   Mon, 1 May 2023 09:15:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Dominique Martinet <asmadeus@codewreck.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Roesch <shr@fb.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] io_uring: add support for getdents
Message-ID: <20230430231528.GB2155823@dread.disaster.area>
References: <20230422-uring-getdents-v1-0-14c1db36e98c@codewreck.org>
 <20230422-uring-getdents-v1-2-14c1db36e98c@codewreck.org>
 <20230423224045.GS447837@dread.disaster.area>
 <ZEXChAJfCRPv9vbs@codewreck.org>
 <20230428050640.GA1969623@dread.disaster.area>
 <ZEtkXJ1vMsFR3tkN@codewreck.org>
 <ZEutuerMIcKpWAfP@codewreck.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEutuerMIcKpWAfP@codewreck.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Apr 28, 2023 at 08:27:53PM +0900, Dominique Martinet wrote:
> Dominique Martinet wrote on Fri, Apr 28, 2023 at 03:14:52PM +0900:
> > > We already pass a struct dir_context to ->iterate_shared(), so we
> > > have a simple way to add context specific flags down the filesystem
> > > from iterate_dir(). This is similar to the iocb for file data IO
> > > that contains the flags field that holds the IOCB_NOWAIT context for
> > > io_uring based IO. So the infrastructure to plumb it all the way
> > > down the fs implementation of ->iterate_shared is already there.
> > 
> > Sure, that sounds like a good approach that isn't breaking the API (not
> > breaking iterate/iterate_shared implementations that don't look at the
> > flags and allowing the fs that want to look at it to do so)
> 
> Hmm actually I said that, but io_getdents() needs to know if the flag
> will be honored or not (if it will be honored, we can call this when
> issue_flags & IO_URING_F_NONBLOCK but if we're not sure the fs handles
> it then we risk blocking)

See the new FMODE_DIO_PARALLEL_WRITE flag for triggering filesystem
specific non-blocking io_uring behaviour....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
