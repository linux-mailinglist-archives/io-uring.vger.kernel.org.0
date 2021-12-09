Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C9746E107
	for <lists+io-uring@lfdr.de>; Thu,  9 Dec 2021 03:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhLICyj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Dec 2021 21:54:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbhLICyj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Dec 2021 21:54:39 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58CD6C0617A2
        for <io-uring@vger.kernel.org>; Wed,  8 Dec 2021 18:51:06 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id l8so4117009qtk.6
        for <io-uring@vger.kernel.org>; Wed, 08 Dec 2021 18:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B979q6ddQLG5Ot2SrtxCZEXqDjlc8fbt8EspuchXQ0A=;
        b=SLpEHH7qPnsB6X6iZm1ONom9E3gFdxFLT8KucVziTopLYhI0eqTTM2NpQctWKopKOd
         IHOcAXkaCqZzZcpPv2cHI8dXAq/84HfHr+3XDoSzpSpvNbIK9rCT0ViJ4HkiXVkc3G2V
         Ib31bLMBA3D3Q2dvpN1QPVSJI+Lrs1qEh0wTW6Zu815iME5aLX8DcEl0flXmNYbiAx6H
         9JhTsPVPyQvvXxTgsYWVVdYouZVRQq7JjAWHbKRsPCIfmjPHGFh1As7QbZZRWE2lpyfF
         FkqZmdgZ++AzS5HFeEqjbFaoy8Bxm0XMksGMfTGGWJHPwrpT2NQ73nadShshznJVvCj+
         JX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B979q6ddQLG5Ot2SrtxCZEXqDjlc8fbt8EspuchXQ0A=;
        b=QuTaDRkvqlUawI4k/jtCTygATvIq1R9VqdBKyxQZJwfDKGOSwSB1IzBcIWQLAqEe3A
         +w0sAj8qllaLMPwUWQJP8u8TKj/gvlaqUaoEGjq+i1y00QzcKV3kwwnP19WOr0VpO3o7
         aiQYx5WEmD1PmYMeqYcKTocP3vAbUCKIWgAfer7gKL+/9AxRMpd/mqN00ZN7a11PNmdJ
         WFBYuwrJyAIzpRiwHqA+4pGmvqj3b8ZurMPOv4clzIz8dU8wW/971kpkPKRLxJKh8PlE
         DikKIdGjuBDrTO33Vruk8iQhKc15oovA1W9p4jW7WZ1XxNUwhVOiVTVJY4+aT6x0rMUP
         RRXA==
X-Gm-Message-State: AOAM530eAqHlhoLD/NQ52/YF7qYmQ1RyiwoSlSKjsu5PQZkuzXbNdBh+
        5s65MqSCb5kY9ERf6cZ98nzG2g==
X-Google-Smtp-Source: ABdhPJxg5TPBkxtZgnny57BOOmkxFtLUUU+nohfMeGsO+R62PsrQwW7PYLiURSO0uYF+oftpgSnmJg==
X-Received: by 2002:a05:622a:287:: with SMTP id z7mr13414308qtw.223.1639018265306;
        Wed, 08 Dec 2021 18:51:05 -0800 (PST)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id h11sm2398516qko.18.2021.12.08.18.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 18:51:04 -0800 (PST)
Date:   Wed, 8 Dec 2021 21:51:03 -0500
From:   Josef Bacik <josef@toxicpanda.com>
To:     syzbot <syzbot+21e6887c0be14181206d@syzkaller.appspotmail.com>
Cc:     asml.silence@gmail.com, axboe@kernel.dk, clm@fb.com,
        dsterba@suse.com, fgheet255t@gmail.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wqu@suse.com
Subject: Re: [syzbot] INFO: task hung in io_uring_cancel_generic (2)
Message-ID: <YbFvF7J220iAHqHJ@localhost.localdomain>
References: <000000000000e016c205d1025f4c@google.com>
 <000000000000fadd4905d2a9c7e8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000fadd4905d2a9c7e8@google.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 08, 2021 at 02:12:09PM -0800, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 741ec653ab58f5f263f2b6df38157997661c7a50
> Author: Qu Wenruo <wqu@suse.com>
> Date:   Mon Sep 27 07:22:01 2021 +0000
> 
>     btrfs: subpage: make end_compressed_bio_writeback() compatible
>

This isn't the right patch, this is x86 so sectorsize == pagesize, so this patch
didn't change anything at all.  Also unless the local fs is btrfs with
compression enabled I'm not entirely sure how this would even matter, the
reproducer seems to be purely io_uring related.  Thanks,

Josef 
