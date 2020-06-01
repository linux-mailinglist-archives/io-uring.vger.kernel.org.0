Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D581EA595
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgFAOOJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:14:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAOOJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:14:09 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2242C05BD43;
        Mon,  1 Jun 2020 07:14:07 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id 9so9447201ilg.12;
        Mon, 01 Jun 2020 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=ePYJ3n1wUzeXPCn11j556JI1onQobJ6wbYHp2A8HxFc=;
        b=nSU/tqEddTlQDqRI4R6v0pKNQO+EeflEwHyKs9inPcJxqhofvwm3J2kelEn2FeUgLc
         NfiADBTDzLV2ZFGL/Kz5MdHOtOu9GgBw/K4BOk6hQ79t65WuxuvBinFOi3t9hB3ZN5aj
         941/LxMs6IwG0bwWb+b8S5gb4JpVSDS+ldWVZ2ismCZnbbcZISHLnW4WXP5CuYe9bqa3
         pU9WT6n6huE9DqRVQX/KfEnxMcmcua5dkAkUK6PWhZ71Z4O7AF8fM8CbOCK0Xli2TdqA
         GSmyFXTuEC9VfLRlYFCkCtdzxvuJS0XpNufjGQbMFliLkzfPkGWLundbxeiUAunidurF
         i5Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=ePYJ3n1wUzeXPCn11j556JI1onQobJ6wbYHp2A8HxFc=;
        b=L/+NiBjr98Wcc/AJiHtJO1TTbgQjtjLLluuPdrpTGfk/IlGx1VY3DoWlOoFzxJ55BR
         854qtW8u+DL2Nu2KZnRQQW4BzCuEJoQFLDpq6p73d/XjXf5klQnSNUumilibrqc1qkcn
         DeyP+Z+9m1yYq0t3/LRANZP1LtBYQ+U/TYh+LhCTOWo1429otlV2f930c2pmOTRLOJ8/
         ClU6nl2Qm4j1vmXT1HoGdB/OrVWQXIXOgtXWKMLSgtcnSwJedDhpAW+DaqGg2lDw+wG2
         Zk3liBbEO4x4TKqZepm4WjdEiI7WdzP5HQ9wzhkR+1isXfDyFRTb/Jg/A3EasuDc3z3t
         kOBA==
X-Gm-Message-State: AOAM532CuMTWuFJntiqg/uRbKXj5OvGhHHCMT/H+yEX9oi+/1eAwsyrz
        1YmySIhNxVLaQIFF7InUCYTCGi6qS+jebg7A6q0mfFQhqVw=
X-Google-Smtp-Source: ABdhPJycb2BOuU73pUf37zmKT47x8ZLzDWE/7Xt/P0FbXIzgkvwZUWDWfDK8UojdncISaNnYb989z8jt8gJ3b4tnJ/o=
X-Received: by 2002:a92:7311:: with SMTP id o17mr22818251ilc.176.1591020847142;
 Mon, 01 Jun 2020 07:14:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200526195123.29053-1-axboe@kernel.dk> <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk> <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk> <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
 <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
 <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com> <cdb3ac15-0c41-6147-35f1-41b2a3be1c33@kernel.dk>
In-Reply-To: <cdb3ac15-0c41-6147-35f1-41b2a3be1c33@kernel.dk>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 1 Jun 2020 16:13:54 +0200
Message-ID: <CA+icZUUfxAc9LaWSzSNV4tidW2KFeVLkDhU30OWbQP-=2bYFHw@mail.gmail.com>
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 1, 2020 at 4:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/1/20 7:35 AM, Sedat Dilek wrote:
> > Hi Jens,
> >
> > with Linux v5.7 final I switched to linux-block.git/for-next and reverted...
> >
> > "block: read-ahead submission should imply no-wait as well"
> >
> > ...and see no boot-slowdowns.
>
> Can you try with these patches applied instead? Or pull my async-readahead
> branch from the same location.
>

Yes, I can do that.
I pulled from linux-block.git#async-readahead and will report later.

Any specific testing desired by you?

- Sedat -
