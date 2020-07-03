Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8542131CB
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 04:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbgGCCkS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jul 2020 22:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgGCCkS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jul 2020 22:40:18 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17A3C08C5C1
        for <io-uring@vger.kernel.org>; Thu,  2 Jul 2020 19:40:17 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z24so10023907ljn.8
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2020 19:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pY1zmuqLqCEdS/VLal5ncqX2RzevlQB07OvZeqJKvBw=;
        b=uyCLPkLwGXSwCNC9nd4vZCNP5qZ9f4fx0g0yj/dAXa+/BfUXfqAxhi5LIRSunzHHO/
         dw3JWSG9nVTH3YoGAWSStw8/xT/Mn/8tw7rWrItZBrovDs1/ybUh0hK3ZjmGBKzbGZPe
         Crnv3FGk72EATa4uE0AGOo9qv8e2HmGZIR/euZVoz5fv7S9GjjGvnP/usdG5MgYGWjtW
         hIDcUHYcscYcTK93rUr2FWKURcr8igJybQZ5Lugmua+3V8v1SEbWV1px+zgis4e7JPPX
         rm5O047F3TaiIRG2nz+CVfLqTaHaZkgVFw1K0jDTTIXSeNVuLafJ6FrSqS4wDm+ALes4
         FiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pY1zmuqLqCEdS/VLal5ncqX2RzevlQB07OvZeqJKvBw=;
        b=pr8w39ytqgHSimEzyOfldBQcJLt9yFi51nb6BeyqhzmboP5BoMjf3k7+hBQRoPtPTm
         hTM8lhCSK9chLzZthQwexKhCNScx0k1tlLAIriYxRHvl+6SysIZSdvZCxGB7Rc0Hcq37
         HAUUApm3Ivwky8vzccjI23Lq2zs4BL+cHeWfuCE2XK8HqbnLLFHzTJv/IR3DzxdkbUB0
         g2bVmPTqYiXttvi0uIMO5iBkkqaaRh42DFaQ8cnhWIL04TF+5XALsUl8lHURDTQ+Pk7H
         zk1oeN51tRpGl7i6Q/aZSdVkKhRJ2mh8jlzrtifLk8Qpjc7sTFh1Q2zuFnmOQvPUsrxv
         Kvsg==
X-Gm-Message-State: AOAM533hEllmQeMHHcG9gKo/JRP1RmUR6yYXyEXlgemFXyhq0H2dmTm2
        +3a3BMDNS4SRZa8Xa0Xe9286k38/iZWMyMMPx91qtaxZmJE=
X-Google-Smtp-Source: ABdhPJyi3y9Anp5u0pnxE6WzpZmnu3dPcHHy5ekI903PMLQmsBCea7UX5Ad8QzHrrAmTfhZFqcHDPCFTrQcFEdXXRyc=
X-Received: by 2002:a05:651c:21c:: with SMTP id y28mr7713930ljn.139.1593744015974;
 Thu, 02 Jul 2020 19:40:15 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593424923.git.asml.silence@gmail.com> <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
In-Reply-To: <1221be71ac8977607748d381f90439af4781c1e5.1593424923.git.asml.silence@gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 3 Jul 2020 04:39:48 +0200
Message-ID: <CAG48ez2yJdH3W_PHzvEuwpORB6MoTf9M5nOm1JL3H-wAnkJBBA@mail.gmail.com>
Subject: Re: [PATCH 5/5] io_uring: fix use after free
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jun 29, 2020 at 10:44 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
> After __io_free_req() put a ctx ref, it should assumed that the ctx may
> already be gone. However, it can be accessed to put back fallback req.
> Free req first and then put a req.

Please stick "Fixes" tags on bug fixes to make it easy to see when the
fixed bug was introduced (especially for ones that fix severe issues
like UAFs). From a cursory glance, it kinda seems like this one
_might_ have been introduced in 2b85edfc0c90ef, which would mean that
it landed in 5.6? But I can't really tell for sure without investing
more time; you probably know that better.

And if this actually does affect existing releases, please also stick
a "Cc: stable@vger.kernel.org" tag on it so that the fix can be
shipped to users of those releases.
