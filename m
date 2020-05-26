Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62AD01E31D1
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2020 00:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390558AbgEZV7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 17:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390421AbgEZV7u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 17:59:50 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDB8C03E96E
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 14:59:50 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i68so17593471qtb.5
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 14:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nl/uXXKU7gTdY5ohqQbCJW8fZVN8yq+KGlncMZ1Utts=;
        b=nh34cblOgwiv74eH3cFlA/wA4QPin0iFdvZX2diA2WCH+OrXis3zyeuuWzA54DelhQ
         SuzIIwRk1yEdHMvT1ZAK0iPEx4Gf73gj1m2jCYzx+gJ0MKd6W+qIKfoxn0tVsuedldyz
         ETY7+HCE0x4OkNgdJkhIpKHjhE9l6dJHPLW5SJgnmaJJySodrzQv8SvNciZrePoNE1if
         L5ZYy3rMqudBO7SGWL/xh64XXFlZDyBS20E7QoDcNkz5Bd6Hq+VQZOkrFoLl1FkCYwqo
         qOk/Vn+EXOMcfLvX8ZhfvKqFbEYkf5YQgKuGlljHXQQG3EXc9xXqaOLUh9r/iNPB+4aj
         yDGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nl/uXXKU7gTdY5ohqQbCJW8fZVN8yq+KGlncMZ1Utts=;
        b=Yt0Y4X7foU2T2rOUUjKUcumiq7WT/ixvq7Yq0IM0OFWjxr+0mZrd1Y3sORIlYvUUN2
         9v9SBDiQpf4ltvi0DHZ7p5AFAwK+swlZgNkbcSVNBIZibH4rpx2iYFVU5B5XWyHskmoy
         4Yccpwe7pXs8xyxy0x5xG4DKXDl4Wk6Z4ym4tdXfTdOJe8fAPaEBHv5mRBLJtA2fvI89
         VJbel3a2oj7rXZw5RZsMkkM2BERlLo8HbZMIrd/guYBRUrz8nyz3bhiTl6wLkryf0F7z
         YscHAhv+M7n4opdfFSD7hvJFnsnr6+R1nC4KJmVc7yoxxI6fnRJo0QLdU9moVyP3uAat
         KEaA==
X-Gm-Message-State: AOAM530g3hF6JAMx3Xpmxu4TB88xaIrKtu8oeltNh/7+VpIhxIouy9rR
        H22glYa5ENKZKwGrzEfsBbCaGw==
X-Google-Smtp-Source: ABdhPJzX5h84kpHsjgtNxRHPc/cukPKzafKyWsPDDU1bqRVn4uMwJWaSC2lQ6IhSym3XUFrWfm9Nmw==
X-Received: by 2002:ac8:34d0:: with SMTP id x16mr1065099qtb.300.1590530389796;
        Tue, 26 May 2020 14:59:49 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2921])
        by smtp.gmail.com with ESMTPSA id o66sm791243qka.60.2020.05.26.14.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 14:59:49 -0700 (PDT)
Date:   Tue, 26 May 2020 17:59:25 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 04/12] mm: add support for async page locking
Message-ID: <20200526215925.GC6781@cmpxchg.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-5-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-5-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:15PM -0600, Jens Axboe wrote:
> Normally waiting for a page to become unlocked, or locking the page,
> requires waiting for IO to complete. Add support for lock_page_async()
> and wait_on_page_locked_async(), which are callback based instead. This

wait_on_page_locked_async() is actually in the next patch, requiring
some back and forth to review. I wonder if this and the next patch
could be merged to have the new API and callers introduced together?

> allows a caller to get notified when a page becomes unlocked, rather
> than wait for it.
> 
> We add a new iocb field, ki_waitq, to pass in the necessary data for this
> to happen. We can unionize this with ki_cookie, since that is only used
> for polled IO. Polled IO can never co-exist with async callbacks, as it is
> (by definition) polled completions. struct wait_page_key is made public,
> and we define struct wait_page_async as the interface between the caller
> and the core.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
