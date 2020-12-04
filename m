Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724C22CEC9C
	for <lists+io-uring@lfdr.de>; Fri,  4 Dec 2020 11:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388063AbgLDK6S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Dec 2020 05:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387968AbgLDK6S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Dec 2020 05:58:18 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0F1C061A55;
        Fri,  4 Dec 2020 02:57:26 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id r18so6131375ljc.2;
        Fri, 04 Dec 2020 02:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zBTOHmaCBscT7mrJGFAgJvf0v3izkjFUmu5nF/K81/w=;
        b=cmgVdetadJqwumpGP80Kpyqqo4l3Yla1L5ejU82mENwtxN6jVs82QI4A24GwinHw4g
         Syl2v4nnV6M4ztXfB1Ymezkis7AcO9l1zRhEzvXzadg6MiolYOFjKoxvmSy12W3pzF8j
         eND0lATuJzrrFMwyE7QQ9P3K/TYKWJljhvbnvML6UuTOlJ3AGJ10sdF8Igp0oDUVSH9n
         Ls4Rm7uREhKrzdOipdH+i4+5pT8s/Q3VXJthUmARWoaOMpKogAfVoaMTDwCSqbqeGWRs
         kP931DHCIOtpmXKgvbN9tq/wYWfs1iXyIr7q3ryg9jnFNbYt4AN92nv2fy4g4YisWpYY
         5gYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zBTOHmaCBscT7mrJGFAgJvf0v3izkjFUmu5nF/K81/w=;
        b=rOQwlusdvTgwsGDLrDYR3F/7AOdMnyGOPusQjQ7oxNNNZ1LSc/ftpEB0nyZN8uCFj6
         gyg7vP1+WEHeoCUBYtb79fMx9LKsAgGioyhwt8cXzb54g9IIWJwJS/4g6JzFDTklEOkS
         C/QiZwOgUUH8AF7SrMibRU70Fq908r97EEKJeyciTM4uQsRsiPr0VU3tbK90K7vy+zs4
         wOnqiRxC+nG3s/6/WLPP226IrZ57C91Svc2ISSeKVb9NJ5JAOYQZl60wQGGqUj1scbip
         D9NsI6/z8X2I+drA8+Yr1j1nFSQ4oVygLfw7iHJniXI1hoTeXy6EogLWE9kFifCtdx43
         IYXA==
X-Gm-Message-State: AOAM532mWyNLKt9k5etEyoPXLekDH71yuucDuod0KozQLJhPcu/ozWkw
        kncnE96YvlEAZu7ba4PlVKP4Ra0JjxIZNw==
X-Google-Smtp-Source: ABdhPJwHksCf9h1Un6+FjHAqLRY1rPwzyzVDSZbz4NO+qkblF9SAQbRvWcCK1IGFIPVVSFRWzitMEQ==
X-Received: by 2002:a2e:b013:: with SMTP id y19mr3199222ljk.50.1607079445116;
        Fri, 04 Dec 2020 02:57:25 -0800 (PST)
Received: from carbon.v ([94.143.149.146])
        by smtp.gmail.com with ESMTPSA id l6sm1531818lfk.150.2020.12.04.02.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Dec 2020 02:57:24 -0800 (PST)
Date:   Fri, 4 Dec 2020 17:57:22 +0700
From:   Dmitry Kadashev <dkadashev@gmail.com>
To:     viro@zeniv.linux.org.uk
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] io_uring: add mkdirat support
Message-ID: <X8oWEkb1Cb9ssxnx@carbon.v>
References: <20201116044529.1028783-1-dkadashev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116044529.1028783-1-dkadashev@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Nov 16, 2020 at 11:45:27AM +0700, Dmitry Kadashev wrote:
> This adds mkdirat support to io_uring and is heavily based on recently
> added renameat() / unlinkat() support.
> 
> The first patch is preparation with no functional changes, makes
> do_mkdirat accept struct filename pointer rather than the user string.
> 
> The second one leverages that to implement mkdirat in io_uring.
> 
> Based on for-5.11/io_uring.
> 
> Dmitry Kadashev (2):
>   fs: make do_mkdirat() take struct filename
>   io_uring: add support for IORING_OP_MKDIRAT
> 
>  fs/internal.h                 |  1 +
>  fs/io_uring.c                 | 58 +++++++++++++++++++++++++++++++++++
>  fs/namei.c                    | 20 ++++++++----
>  include/uapi/linux/io_uring.h |  1 +
>  4 files changed, 74 insertions(+), 6 deletions(-)
> 
> -- 
> 2.28.0
> 

Hi Al Viro,

Ping. Jens mentioned before that this looks fine by him, but you or
someone from fsdevel should approve the namei.c part first.

Thanks,
Dmitry
