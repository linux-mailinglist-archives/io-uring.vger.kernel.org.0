Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0575FE5BF
	for <lists+io-uring@lfdr.de>; Fri, 14 Oct 2022 00:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiJMW6m (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 13 Oct 2022 18:58:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiJMW6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 13 Oct 2022 18:58:36 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A246619C06A
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 15:58:32 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r3so3750053yba.5
        for <io-uring@vger.kernel.org>; Thu, 13 Oct 2022 15:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KnEPgQ7/1M3nE73Ny0uZ1ZS3cIjvE47yx5dogHZ14F0=;
        b=S2qsP5dnfovUEG46isxtwl0fVlzP8SHRsN5AAvOMZ4KOFoXRiC8DI2Npa4pIFSrUXl
         G9BfMT4jsn1Cbizp9aIvEcTpmFwVEJpZE01Y7J/F1l2WwXJd8w5CH2NcOL5hdE2DejMU
         KAtkP3R3kd0h1RrQo0IT8Ubjf4ih4DTppQiwN6BCswx6ixV8pn7/yM5pHrxqemfXcs2w
         6flgBfB9FkCXKZ9tkOUd6kiKCZxlnqm1xpPrUXzk+aHHA3NXNRjxPQnUunRTNt3BAiZ+
         8Xrok7yOnnhRlWBHgDA9yWJqRcTdgGDbKB9PM9ThmOKL2mOvVyeT8/mkYGloiXLpZ1yK
         8aaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KnEPgQ7/1M3nE73Ny0uZ1ZS3cIjvE47yx5dogHZ14F0=;
        b=C5fxSEjuoD+1CwSnkhK4sWv/lZtCIQgN7SvoR98rzHMJxsea2ziytXbnI+4hXLH/Ua
         pzrA0lqgL73nkAv8Yf8rw56gBAnFahrDHq4yZg9p+Iz1xuvX0v2eLlaFlr3wN3bE3chI
         LxRahKiRIfKhwrWsHFVO7YPsO8DqFkeRcyZwzR+QL9ZAg1bFobVMY8WU1rERNc0gPkwb
         3jL2fMk4H7M3fRwrqOfCzHjAvR44eNaSRsBYWpui4H6HY8mE+rCBEkFVAJMngNA7WzGX
         7vaRICccOULP+NsCdQsnvruDaFsuZAlo71L/geky0lXUYyJiAsUSQr/cNnDhx8HT3Q+o
         7XAQ==
X-Gm-Message-State: ACrzQf1ravM+WUJck5AfLO2mg7j1LFTfr7hKmpLFNiGBhYkmh3+uJNaB
        UoMHTj2yIIsUwLN67QlIwp9nHZE4bJSDZAWpKNLJAlb2dA==
X-Google-Smtp-Source: AMsMyM5ih7aIyE/itMFOg5aAsBU7bsZau1O0I8/0YnYnqUrnfKUDGs/aCTE+/WLOTRFy6orQ/56jTErz6dIE1MHKuJY=
X-Received: by 2002:a25:22d4:0:b0:6c3:6ec7:3dc9 with SMTP id
 i203-20020a2522d4000000b006c36ec73dc9mr1499496ybi.520.1665701884814; Thu, 13
 Oct 2022 15:58:04 -0700 (PDT)
MIME-Version: 1.0
References: <cf6cbd11-e0a6-3d5f-bf93-ddc393e39fdd@kernel.dk> <CAHC9VhQYYw4fScp9KSD=RjtKvXj6B1aia6SWnkfeM=U5ekp1Ag@mail.gmail.com>
In-Reply-To: <CAHC9VhQYYw4fScp9KSD=RjtKvXj6B1aia6SWnkfeM=U5ekp1Ag@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 13 Oct 2022 18:57:53 -0400
Message-ID: <CAHC9VhQCLQogAFSvAy4AtL8VzHX9dtUetFsV2HpqR0FVWkiiYQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring/opdef: remove 'audit_skip' from SENDMSG_ZC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 7, 2022 at 2:35 PM Paul Moore <paul@paul-moore.com> wrote:
> On Fri, Oct 7, 2022 at 2:28 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > The msg variants of sending aren't audited separately, so we should not
> > be setting audit_skip for the zerocopy sendmsg variant either.
> >
> > Fixes: 493108d95f14 ("io_uring/net: zerocopy sendmsg")
> > Reported-by: Paul Moore <paul@paul-moore.com>
> > Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> Thanks Jens.
>
> Reviewed-by: Paul Moore <paul@paul-moore.com>

Hi Jens, I just wanted to check on this, are you planning to send this
to Linus during the v6.1-rcX cycle?

-- 
paul-moore.com
