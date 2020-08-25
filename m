Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41698251A90
	for <lists+io-uring@lfdr.de>; Tue, 25 Aug 2020 16:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725998AbgHYOPP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Aug 2020 10:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgHYOPM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Aug 2020 10:15:12 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CC1C061574
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 07:15:12 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id p25so11036009qkp.2
        for <io-uring@vger.kernel.org>; Tue, 25 Aug 2020 07:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+q/Y9Z8M5jFm+p3bIMgmS4dOLk/L3b5vpQ1zNJvOTzw=;
        b=EUATDmABSbnXL+6hswKIjlsT1ssOEMg3CwgUwdawDJ6Gf+Xpidqfvg2SJUSRu8JIRw
         /GGyzhojsFYiDOO1YXKf3iBHyPNQQo2bvNHj/dC4fiIUw0x8QIeinw4jhBPW6myHsJpl
         AwED1TJsaC3b33dhlUyJvIbIx4YCOBAEUcSKC+1dRpXK1QxEFc8utISr18YpkJ5xTjpa
         Ka8pMBaNTHTGc0dE3hyR9KBFLlX2/+/6rG+y8ckmzlZRaIf4rTxnk10rwsBpaYhkQZPK
         8vkfE1FdZLuUBzbF4aXxwf+nKfPCg2EYOx57XjSMTEhgcKkwPIgqDMO5TbDEqbOhfe7j
         dggA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+q/Y9Z8M5jFm+p3bIMgmS4dOLk/L3b5vpQ1zNJvOTzw=;
        b=s9NqIrhNGMJcJtlvJusevmCrq7q88u7sX0PeK/UGSwbHDcKKWDniCChm1LfE+2KZ9Z
         bxk/7shrWfSnppA0PZAyuU4Z6GBxibdki3jJs2b228BDTGTVfPLyZ+WngYDAAEVIKptY
         bBB12b7lbKgsxDAsPXWkjGFwDg7cFl0WLN7D0VYvH+2w/cmYcyRP5scJXaWmq5kgAixG
         CtxFmcx0/d2pYcfhxgm3DO+jqT9BC7l3r8SDc+1RT1cO3XFhoUOWqJstTlHGE06vM59L
         wtu8A62vhTETw/VZJeehzJd36WiuphbEclyAUbPTA3TdC4RcrVTdGOI0+rcDU6pWFqEW
         NPTg==
X-Gm-Message-State: AOAM532PoeawkMQ7Ap0xOzKaIqV330/ZPVWsGjmb+vjyXaZSg5F0VLg8
        uri7erG7h4tlECETrQ2+yBoQb0tPFl1ha6b6qaA=
X-Google-Smtp-Source: ABdhPJyazhVkJAkU6MpSPsSKooedaROm+eB9g1+mPl1ms4qlB5EeSWPSSc/xAEJJdSxYkx0sSF9oV8QdloIq31Ex55Y=
X-Received: by 2002:a05:620a:1495:: with SMTP id w21mr1660975qkj.499.1598364909166;
 Tue, 25 Aug 2020 07:15:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAF-ewDqBd4gSLGOdHE8g57O_weMTH0B-WbfobJud3h6poH=fBg@mail.gmail.com>
 <7a148c5e-4403-9c8e-cc08-98cd552a7322@kernel.dk> <CAF-ewDpvLwkiZ3sJMT64e=efCRFYVkt2Z71==1FztLg=vZN8fg@mail.gmail.com>
 <06d07d6c-3e91-b2a7-7e03-f6390e787085@kernel.dk> <da7b74d2-5825-051d-14a9-a55002616071@kernel.dk>
 <CAF-ewDrMO-qGOfXdZUyaGBzH+yY3EBPHCO_bMvj6yXhZeCFaEw@mail.gmail.com>
 <282f1b86-0cf3-dd8d-911f-813d3db44352@kernel.dk> <CAF-ewDrRqiYqXHhbHtWjsc0VuJQLUynkiO13zH_g2RZ1DbVMMg@mail.gmail.com>
 <ddc3c126-d1bd-a345-552b-35b35c507575@kernel.dk> <42573664-450d-bfe4-aa96-ca1ae0704adb@kernel.dk>
 <CAF-ewDqffa=e-EBOdreX9S7CXagM-ohQSsyyDMooDR83W9kjGg@mail.gmail.com> <8076e289-2e0b-5676-aaac-eff94245a298@kernel.dk>
In-Reply-To: <8076e289-2e0b-5676-aaac-eff94245a298@kernel.dk>
From:   Dmitry Shulyak <yashulyak@gmail.com>
Date:   Tue, 25 Aug 2020 17:14:57 +0300
Message-ID: <CAF-ewDrtgSpoannR9HOw-pLKCS3j-dYeoEHJ8c4pG=abfLaRuA@mail.gmail.com>
Subject: Re: Large number of empty reads on 5.9-rc2 under moderate load
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I was doing readv with the same tool that i shared earlier:
go test ./fs -run=xx -bench=BenchmarkReadAt/os_5 -benchtime=8000000x -cpu=256

On 5.8.3 it is consistently > 100 mb/s, on 5.9-rc2 ~50 mb/s on my device.
with uring i was getting > 250 mb/s, and now ~70 mb/s.

double checked if there is any difference with writev, and i don't see any.


On Tue, 25 Aug 2020 at 16:39, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 8/25/20 2:52 AM, Dmitry Shulyak wrote:
> > this patch fixes the issue with 0 reads. there seems to be a
> > regression that is not specific to uring,
> > regular syscall reads slowed down noticeably.
>
> Do you have a test case? Related to specific system calls, or just
> overall? My initial suspicion would be Yet Another one of the
> security fixes...
>
> --
> Jens Axboe
>
