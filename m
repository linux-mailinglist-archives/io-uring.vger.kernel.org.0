Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EAC5B1E88
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 15:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232404AbiIHNT2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 09:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232392AbiIHNT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 09:19:26 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB4AF56E7
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 06:19:17 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id g14so12770346qto.11
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 06:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=t3AIoEdxLklUxJhZuRgTE0ZgbVDpOfOMa+f5H31fp8U=;
        b=2syY6wI2LrfQiL9tPugq3WH57mYUUsLNxQsj5s/1TAaRqgGPK16/oVCPub2IV4SKBO
         0WiAtTmpACPF5uaJUvqdy4knzBt9Fc04OsSfssonTLzDHtH/9Lqhue1aPN0LPzABSbD0
         L1zY17ylNu8An9DxyKwkE1bO0eko+QL5FRvYVJi8eqLHM07nXcz8fNwqUEGEkuPCjwea
         DYTZo7AHKOl3YXudG0D0eU5mpbyLUP+gXjbVvShjm9xVGDNVybW80p1g79Z797V5c362
         t4cKUXRq/gZodgUFiJ8AZT0TUSF1HxUc8/BLS2QxU1v9GnCp+zWoad6blFMjYnv8R+mk
         z7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=t3AIoEdxLklUxJhZuRgTE0ZgbVDpOfOMa+f5H31fp8U=;
        b=R+4+5He7kTR1PBteLExOk+E60JHEAJ5fmVm4zaxYXit2a9wGk7gqajgWW80PreayqD
         buGGcVqsTD7gr2pWVTtktuvcEY4nO9SdKQJHr8mGfbwsHrprVUvRZ63MACobj8MOXEip
         oWDp0L7ZcRSqfNrU2oq5Fz7a6tg9NXpiC5YLLOtcTGp6548pV4EuL7VKZEjzUt+vkXNy
         P9mmcmM4ZhK0HMpDJD3b3uAIJZeqCbLm7mqFzRa1gGsI9tnhezSZFU7FfFkg0ZlR6Qbr
         iSO+yCAIlwS2mnjm5v67mGJHBrk34p9GMmZavpjPvW1hN0YCl+hT/exbxusz+X3q8XqI
         +ZIQ==
X-Gm-Message-State: ACgBeo1pnRg1qrWYwb2Iaiz4Mj7BZcVoPvT3E5J0IHF8A8dh9pElvc/O
        5btZ75xyqDOMKEJ4i72zKoYmDA==
X-Google-Smtp-Source: AA6agR50R5+r2bzVBIPJ4PjbnEVIoBYtqIKObmTAxPyc4OSLoye1L+MrlMCVk7IHOLWfD9Y3AZwjrQ==
X-Received: by 2002:a05:622a:1b92:b0:343:6cd6:a972 with SMTP id bp18-20020a05622a1b9200b003436cd6a972mr7800949qtb.262.1662643156738;
        Thu, 08 Sep 2022 06:19:16 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id t32-20020a05622a182000b0033aac3da27dsm14625472qtc.19.2022.09.08.06.19.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 06:19:16 -0700 (PDT)
Date:   Thu, 8 Sep 2022 09:19:15 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, fdmanana@gmail.com
Subject: Re: [PATCH v2 02/12] btrfs: implement a nowait option for tree
 searches
Message-ID: <Yxnr0/7w8VC6ObEJ@localhost.localdomain>
References: <20220908002616.3189675-1-shr@fb.com>
 <20220908002616.3189675-3-shr@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220908002616.3189675-3-shr@fb.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Sep 07, 2022 at 05:26:06PM -0700, Stefan Roesch wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
> or anything.  Accomplish this by adding a path->nowait flag that will
> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
> either of these cases.  For now we only need this for reads, so only the
> read side is handled.  Add an ASSERT() to catch anybody trying to use
> this for writes so they know they'll have to implement the write side.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>

Should update my changelog to say use -EAGAIN instead of -EWOULDBLOCK.  Thanks,

Josef
