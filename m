Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E312DE7FA
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 18:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgLRRWN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 12:22:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgLRRWM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 12:22:12 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78160C0617A7
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:21:32 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id 2so1768404qtt.10
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 09:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+qkoctPWOd1b0HdkiAWk4/8HvGxBxVX+RAg5mAD4ykk=;
        b=YEkuOBAiMYxlZ4dLKKp6ois2GgdbrDlq9G8TBo7Wd95EcdkhXGjCqkTPZyp7PuXVy4
         ayJrk8sp8bCa7i1l9E4cXfA1ez5gKesd+rI+6Qrw0lUMXf5Dq9AJP7na9KmvQJzq7KhI
         tGuIm2Sm2LtfQoVJfxe5vXlYZYNiHldwP8C40yOIXqyWf7ShBX1TC9bjWIY6fCsdCM2M
         VUR/gcCaqhP7oznSypT9FRttr1crOj/1PcKIntC1dOgZsq1+NPepCqZe/hdjpDVJfWqP
         R/25Yj3i7mXgE6pVeXYlYlM5+kUopnQ2HfvzzPAFNvpCqvbK74NXeZDHcoSnZ+FWb/SO
         3fcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+qkoctPWOd1b0HdkiAWk4/8HvGxBxVX+RAg5mAD4ykk=;
        b=R4Gas5maMHpI4UW4gAr05jxS/iBPykXtMVfmrz8i6SSLgn83B17EssclrgAbqyfM7C
         0+HbdFhTMnEicAQ6t6UGcXIkARlQlVF5NVZIxhrF9fUg+JOFGVzeTmF/MfiGCnXQb+Nu
         auxJxq+8WZ63PnSvVLqNXQv7xvW+enosqR26HR/36GmlabMkAYxR12AjhE6ccz6SHLFA
         6+eRep9+QI7XTFc/DiUHbmYPATn9plmpZnbZPfVx8aUjByrtXib4zr2Ms4/IP5eyXeLz
         s8nY5FEc2KNsfBo2Ob9k9CA7QzIY/EpNKBnFakVA6kfa5qkYnbdAmmzgwe6upmGNa2tq
         4khQ==
X-Gm-Message-State: AOAM5315AiOMRPVg4iRVZyI4em1WbkAvjOTpEcbOp7mIUGSrJE9oE2E6
        2V3njR1uZKfJMbk6nvRW+0zy9X5/39fI+rNxLjqktpQ4A+o=
X-Google-Smtp-Source: ABdhPJzBTNMtOdPHXf6pzOK0ohw7Ui6qs6XdvfaC7jQzR7sEuqZNvLt7KXEM0Q0MxKqajZmpEStJMwPKf1L3m33ik3k=
X-Received: by 2002:ac8:75c8:: with SMTP id z8mr5026066qtq.256.1608312091684;
 Fri, 18 Dec 2020 09:21:31 -0800 (PST)
MIME-Version: 1.0
References: <CAOKbgA66u15F+_LArHZFRuXU9KAiq_K0Ky2EnFSh6vRv23UzSw@mail.gmail.com>
 <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
In-Reply-To: <7d263751-e656-8df7-c9eb-09822799ab14@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Fri, 18 Dec 2020 18:21:20 +0100
Message-ID: <CAAss7+oi9LFaPpXfdCkEEzFFgcTcvq=Z9Pg7dXwg5i=0cu-5Ug@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Dmitry Kadashev <dkadashev@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> I've read through this thread, but haven't had time to really debug it
> yet. I did try a few test cases, and wasn't able to trigger anything.
> The signal part is interesting, as it would cause parallel teardowns
> potentially. And I did post a patch for that yesterday, where I did spot
> a race in the user mm accounting. I don't think this is related to this
> one, but would still be useful if you could test with this applied:
>
> https://lore.kernel.org/io-uring/20201217152105.693264-3-axboe@kernel.dk/T/#u

as you expected it didn't work, unfortunately I couldn't reproduce
that in C..I'll try to debug in netty/kernel


--
Josef
