Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B36E254868
	for <lists+io-uring@lfdr.de>; Thu, 27 Aug 2020 17:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgH0PG6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Aug 2020 11:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgH0PEa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Aug 2020 11:04:30 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 594F4C061232
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 08:04:18 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id t185so3712537pfd.13
        for <io-uring@vger.kernel.org>; Thu, 27 Aug 2020 08:04:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KtUav8kJRw7NW9MJAIseBMSxLDruLjM6HXWwKu/0M74=;
        b=GQ0jmdkWMjQEAalY++3/Ht0h8crzz739ENSMCZK40b0dOvb1c0kZUmimmf9K8t4Zgx
         Fao+oOBxd4WqUDkaMoDp6QkT7HgLYirHRqq+Fk9tpRQi8On7xp9MwFMWUauS7YXIVztA
         W9VmcStAzDZlNyQOegil/seXWpDF/Iz/wobtU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KtUav8kJRw7NW9MJAIseBMSxLDruLjM6HXWwKu/0M74=;
        b=NcTxgcCS639dk8/0NDEX15dRi4pQIk2wkVH93YcnsqrWMpotInlNdyH/AOreMAuQ2r
         d7g9dJe/IqLmG2AvoHMbTVrgCtCXfA90BthPh6sO/1vejX9XTYjU6r4OmfbyIToQR8P9
         jxRY7D6xXMus742LTnSz47q/6iVwtsVAe2OfPA5gIMSEv8jvTuMDf4LDvOnD3Lmv3LLa
         ZseqncaKZPZ/lQDWKUThGtNDDnqM2c0he5+QSpPbkrFd56NOgAVehaa+58wNNqioznWu
         ngHdEUkaetPuP3V8ncc3SsPVfoQ8GShaDouuTL/3Ig6OB/Pn/Oo4LQKjb0+m4hdt/iFV
         3nww==
X-Gm-Message-State: AOAM53219jr7Udx24pYMd/WMLWbVqeRRw4WPZZoIpuz6867U9hJRWu70
        zZKI4Bt1ri5SC6Y8epV4XeMxng==
X-Google-Smtp-Source: ABdhPJwXBmp6C1isCRM1EzGs2j/sEIzbekMjfQYDts14g/FnXYPAwZwvsuLxGAshJVtz3JQiRyN6iw==
X-Received: by 2002:a63:1822:: with SMTP id y34mr15725223pgl.364.1598540657751;
        Thu, 27 Aug 2020 08:04:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o15sm298606pgr.62.2020.08.27.08.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 08:04:16 -0700 (PDT)
Date:   Thu, 27 Aug 2020 08:04:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jann Horn <jannh@google.com>, Jeff Moyer <jmoyer@redhat.com>,
        linux-fsdevel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <asarai@suse.de>,
        io-uring@vger.kernel.org
Subject: Re: [PATCH v4 3/3] io_uring: allow disabling rings during the
 creation
Message-ID: <202008270803.6FD7F63@keescook>
References: <20200813153254.93731-1-sgarzare@redhat.com>
 <20200813153254.93731-4-sgarzare@redhat.com>
 <202008261248.BB37204250@keescook>
 <20200827071802.6tzntmixnxc67y33@steredhat.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827071802.6tzntmixnxc67y33@steredhat.lan>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 27, 2020 at 09:18:02AM +0200, Stefano Garzarella wrote:
> On Wed, Aug 26, 2020 at 12:50:31PM -0700, Kees Cook wrote:
> > On Thu, Aug 13, 2020 at 05:32:54PM +0200, Stefano Garzarella wrote:
> > > This patch adds a new IORING_SETUP_R_DISABLED flag to start the
> > > rings disabled, allowing the user to register restrictions,
> > > buffers, files, before to start processing SQEs.
> > > 
> > > When IORING_SETUP_R_DISABLED is set, SQE are not processed and
> > > SQPOLL kthread is not started.
> > > 
> > > The restrictions registration are allowed only when the rings
> > > are disable to prevent concurrency issue while processing SQEs.
> > > 
> > > The rings can be enabled using IORING_REGISTER_ENABLE_RINGS
> > > opcode with io_uring_register(2).
> > > 
> > > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > 
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > 
> > Where can I find the io_uring selftests? I'd expect an additional set of
> > patches to implement the selftests for this new feature.
> 
> Since the io_uring selftests are stored in the liburing repository, I created
> a new test case (test/register-restrictions.c) in my fork and I'll send it
> when this series is accepted. It's available in this repository:
> 
> https://github.com/stefano-garzarella/liburing (branch: io_uring_restrictions)

Ah-ha; thank you! Looks good. :)

-- 
Kees Cook
