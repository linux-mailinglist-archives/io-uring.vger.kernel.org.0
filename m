Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B628D2794D8
	for <lists+io-uring@lfdr.de>; Sat, 26 Sep 2020 01:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgIYXks (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Sep 2020 19:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgIYXks (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Sep 2020 19:40:48 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E9C0613CE
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 16:40:48 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id 19so3634415qtp.1
        for <io-uring@vger.kernel.org>; Fri, 25 Sep 2020 16:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wbTW0N3pi00kDwcqmPd1UFIZvUvq8Ftlt0qpbFDenUI=;
        b=DwXuIxH8zb2QzBgOtcPoqKXfqplqsXOlTr+dswWKq1bXytRtsLo/aW9sEYLPWcq6ao
         wxubO5OmtQ/OpOta0M/LcGE3L5ln2TodASyANzDVVZZ3ds+eDf2uVo3FxMcNWSin5/4h
         81oqTaR1rwsQ/pGB48gtoPpVvFmF1jXAg4Ms/5RTuTiZrdz5inasXrs1tqg9Yjxl6H26
         CybgdaOhno8yPtaqXvMlEXnEEf7A90yCDrxaVsGtnisUYB0JJ9KRpfx4XB0pYbLqO0Yd
         SdIJjt3ILufF5zMGpjo8X90WCkfaM676yoaoe6qWGp3SfA7czOo73JJzefAZx6/cv7gs
         Q31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wbTW0N3pi00kDwcqmPd1UFIZvUvq8Ftlt0qpbFDenUI=;
        b=DfmoXlEuvPm4YJLpEtIWYzPhKHTtL6+XuuZmQRkeLV/lsA/EYvP/eLHrlE46+/e7hT
         FJA5ayvDnO/kninLEGN9EdEFJLQwaCPXcQflWNCBM/fAoTadwyGHnvtHSeeldMUVudqb
         jsGkYSTle2m+iIhu2hVLYYafpOrk8Km8ndMp2xH0GtrY2qsMg93i8n4P7g5wK74DObnT
         o/g8CRiJkBwuynWQFPHYUIBNyZxVV6CuQ6ZoBnYJIONVe9ZcXRdIKQmJbxWajAALkrpt
         4gLj0LeBwgZaQchHwLfEU+6UYhlss7BbLVv+jr1isr65Knu6RLUadSZUBrR6oviUeIhq
         C1Aw==
X-Gm-Message-State: AOAM531T0nfgHH47ZbeemBovPZAdmqWhM/34o/rca/F4LVQntsQI8VQU
        lhO73kwCMfA+26AVlJsddCEBBo1bAJP2ZCE0dsCo0iwc+s5SPw==
X-Google-Smtp-Source: ABdhPJxXHAt+nfhvgRWLjgw5wZgd6eA6NVp8c/9aKZtbAcZEj/3CiXz3q7h9By+R4oUs0VHTNt0nzQgok6hXW1KLVkw=
X-Received: by 2002:ac8:3713:: with SMTP id o19mr2215692qtb.256.1601077247610;
 Fri, 25 Sep 2020 16:40:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAAss7+rWKd7QCLaizuWa0dFETzzVajWR4Dw7g+ToC0LLHcA08w@mail.gmail.com>
 <9f1ac2d3-6491-bd5a-99ea-8274a8a19e2b@kernel.dk>
In-Reply-To: <9f1ac2d3-6491-bd5a-99ea-8274a8a19e2b@kernel.dk>
From:   Josef <josef.grieb@gmail.com>
Date:   Sat, 26 Sep 2020 01:40:36 +0200
Message-ID: <CAAss7+psYrRTdgbX0hFniUUmuBNTPbzRKGGg7v1E1N+C08FE8A@mail.gmail.com>
Subject: Re: SQPOLL fd close(2) question
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     norman@apache.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> If you have a file registered, that holds a reference to it. So when
> you then otherwise close it in the app, it's similar to having done
> a dup() on it and just closing the original. So yes, this is known and
> expected, I'm afraid.

Thanks for clarification, the only way to delete the file registered
reference is to use io_uring_unregister_files right?
I don't think that we can support SQPOLL for 5.8/5.9, but at least for 5.10+ :)

---
Josef Grieb
