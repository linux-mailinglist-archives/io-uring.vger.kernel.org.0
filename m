Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2D632497C9
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 09:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHSHzc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 03:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgHSHza (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 03:55:30 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA39C061389
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 00:55:30 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id v22so17153393qtq.8
        for <io-uring@vger.kernel.org>; Wed, 19 Aug 2020 00:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zv/HE5z/9SmihVOWVHVy7kmaGXxIx5BbUCPhM4bmkJI=;
        b=bhDfrHCar4umWQC/5pQTx3cyoCspu9ddfdUY758vWp5Ex23r4+eDueDhIoN3ftPMuH
         BLHhoWCQneiERQyqdEVeTuaVZ8iJYsZg+cGDL7tCZAD95jVF3Ovo8YKeClCPOTevtISQ
         8/6DLC6R3n8ltx9LD/iRiFsMOtLNcv6/gk55z8bnhMH6KDFLL/PTCspYJbudUjaC5NgQ
         f5Lt/p/YGMPN/yxQ8gTel6NYoeTu34rcv+EFuBFdlKowmBzpnaDgu8eAjF2TbKFnzook
         kZw9w+B7XAdWcEXrZjID5W3PZVIgSgQGxdnLOMNp7JqyLppFf8i2rG1PGpyfMYB5/9+4
         GCdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zv/HE5z/9SmihVOWVHVy7kmaGXxIx5BbUCPhM4bmkJI=;
        b=GedSeil2TjA3PSazM5oY+167Q/E5/OsflhD783LSzKXNCLA2opLa2Zq/+3UX8FhFaq
         SOB9/K1W/WAKJTDEaqrvpceAni0DEDoh/0KoMzc9hPhrWDkAuVVPQpkCNBHWKaqHp4ag
         JhiSeVt6kh5mC8XckEfP71LF/2BsX1IsLufb2bY3LowsZM1WPxDfGwp7ZHAjbSPqQ/JA
         /k+7WSogaamylIRa8tASF5O059+4k7wZy/G8PBegLD32VgEZSsefQ81jlAsbTmaqd6Vr
         wvAiltbES1C9jBiBaMYnULf4ZhnAlmIlDTI7G5UrFl/8lQGhZzuD+gKWnorhmQ2j9ZYP
         Oj0Q==
X-Gm-Message-State: AOAM532ZxPvsj0nQNeUJhaOBjNP6OVmawrOEtqfeMsUKWgqEmAJQT5Ij
        BNRPEuo9AefHJWixs2QhfURJ7OpWyPego9tll2FLU/0Cdls=
X-Google-Smtp-Source: ABdhPJy9Bgm4mJXsul/r3204P9Lm1mIpLO7uyKp9aUUrnUOzEoJNBUwNEvIsVH2nNvgGGG1N3pI2t76GX06NupBU4+E=
X-Received: by 2002:aed:2825:: with SMTP id r34mr20121401qtd.321.1597823729448;
 Wed, 19 Aug 2020 00:55:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDrOHDxpSAm8Or37m-k5K4u+b3H2YwnA-KpkFuVa+1vBOw@mail.gmail.com>
 <477c2759-19c1-1cb8-af4c-33f87f7393d7@kernel.dk> <CAF-ewDp5i0MmY8Xw6XZDZZTJu_12EH9BuAFC59pEdhhp57c0dQ@mail.gmail.com>
 <004a0e61-80a5-cba1-0894-1331686fcd1a@kernel.dk> <CAF-ewDqANgn-F=9bQiXZtLyPXOs2Dwi-CHS=80hXpiZYGrJjgg@mail.gmail.com>
 <af9ffef1-fe53-e4d5-069b-8cfba31273c2@kernel.dk>
In-Reply-To: <af9ffef1-fe53-e4d5-069b-8cfba31273c2@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Wed, 19 Aug 2020 10:55:18 +0300
Message-ID: <CAF-ewDrW-7hRuQ1QkNzJVbBWM5U4cTMi1reB=e=-dTuh8WymMg@mail.gmail.com>
Subject: Re: Very low write throughput on file opened with O_SYNC/O_DSYNC
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

reproducer with liburing -
https://github.com/dshulyak/liburing/blob/async-repro/test/async-repro.c
i am using self-written library in golang for interacting with uring,
but i can reproduce the same issue with that snippet consistently.

On Tue, 18 Aug 2020 at 19:42, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/18/20 9:09 AM, Dmitry Shulyak wrote:
> > it worked, but there are some issues.
> > with o_dsync and even moderate submission rate threads are stuck in
> > some cpu task (99.9% cpu consumption), and make very slow progress.
> > have you expected it? it must be something specific to uring, i can't
> > reproduce this condition by writing from 2048 threads.
>
> Do you have a reproducer I can run? Curious what that CPU spin is,
> that obviously shouldn't happen.
>
> --
> Jens Axboe
>
