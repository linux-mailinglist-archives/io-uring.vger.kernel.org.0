Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05C181B7DC2
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2020 20:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgDXSVe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Apr 2020 14:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgDXSVd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Apr 2020 14:21:33 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1FAC09B048
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 11:21:32 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id c16so10181922ilr.3
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2020 11:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tCiVit0VG3KBQjqLDag8RVtGOpUDh+mCOuLbU+1aRD0=;
        b=DI4S8Eswyw2eyP5Y78DgsiFN4s84xlODSy7s+DG5nUXBAKPHY8gYmupI3R3Ab62DuD
         itY1p47ioOwd5OQDw3LzCTMV9xnMY7QjaN0uAmxSFUlD5LQ+/URGop+n4grQX7LXRxZA
         SI/Ecbx3RtJLu0gQBlxFZq2dc6QKX4MHnBrdUkXPBD4R7IlMKRel0xQ4Pv5sWKFgml6g
         zLmgevcC1/kIX04TdL7sZF2RpwV+2evQkBT1QmR2sf9jNJ5vFM8K/GETXoSf5PQi99Sy
         2EogIRw7lGsuA2pazw4XwZ0OPnq8vmcuvM4Y5tYCfX21fZxYustPfGoI3t5W9HQHd42V
         iKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tCiVit0VG3KBQjqLDag8RVtGOpUDh+mCOuLbU+1aRD0=;
        b=AQNw64GEmC6Mw86NSCNbTDPDLVnjEvcBWRB5kHhFt4sysrDf2bU3lCpHinlcUNKIgo
         obtfjsoD3tp64BDg2SO69KNSGd9tLM1htLgBEO6O4IpGvo2d1iXNbYTvQwHajh6XQfIE
         iZw3/9DSk6z96A81zgkxyuHOQduUa1d5Z+5gAfx0dsxyrPcc/KC6DNk2EJTiLbrQp8dO
         ED1e8mvtVL0/N1wquqZURvKU4/ajKJsswKWBemyL8FR1heLj3T3WNQ6LOoQDjJy4w2MB
         oxGwyUI8tuxFVhw/O5o9/sS6xcOJpsqthogVmQxFSs6SY7SDPQeKKEE8YVjzXGghEajV
         2n2g==
X-Gm-Message-State: AGi0PuaEgRVNOzKr0DSSbIf1SokeBjmi1GuK03c1kUiYAXgmpTV1Rcid
        TfESGzBcE2m8+S9B3WmVH9b8PaPH8fal/34ou6g=
X-Google-Smtp-Source: APiQypJSt3yckcG1PG+0qHVO1B5ADwdiXuqf9yFYsMQhtvPSxbTCCBIvtEbhDtXHUxMe6fVoqo+A8ot62nqXZQGoVjI=
X-Received: by 2002:a92:4b11:: with SMTP id m17mr10205010ilg.42.1587752491619;
 Fri, 24 Apr 2020 11:21:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200423081918.GA172719@localhost> <99e94e7d-fbb6-1a73-e03b-e8b4a15d886e@kernel.dk>
In-Reply-To: <99e94e7d-fbb6-1a73-e03b-e8b4a15d886e@kernel.dk>
From:   Ed Baunton <edbaunton@gmail.com>
Date:   Fri, 24 Apr 2020 14:21:20 -0400
Message-ID: <CAF6hZUDW9zfLNuEP=CGiG7X0UAbQQJHjA3yO35A_xx9hNuxNuA@mail.gmail.com>
Subject: Re: Multiple mmap/mprotect/munmap operations in a batch?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Josh Triplett <josh@joshtriplett.org>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Is there any restriction as to what calls shouldn't be covered with
io_uring? I see the scope is growing over time. For example would
directory operations be appropriate?

Ed

On Thu, 23 Apr 2020 at 11:13, Jens Axboe <axboe@kernel.dk> wrote:
>
> On 4/23/20 2:19 AM, Josh Triplett wrote:
> > What would it take for io_uring to support mmap, mprotect, and munmap
> > operations?
>
> Not very much, wiring up something like madvise as an example:
>
> https://git.kernel.dk/cgit/linux-block/commit/?id=c1ca757bd6f4632c510714631ddcc2d13030fe1e
>
> > What would it take to process a batch of such operations efficiently
> > without repeatedly poking mmap_sem and such?
>
> Probably just a bit of refactoring, to enable calling the needed helpers
> with the mmap_sem already held.
>
> --
> Jens Axboe
>
