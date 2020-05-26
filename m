Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09E671E30D6
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 23:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391168AbgEZVCq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390584AbgEZVCp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 17:02:45 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E621FC03E96D
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 14:02:44 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f189so22226770qkd.5
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 14:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PYvRBfRL1Chxl6N02AVU3ob8SeK5Em8eIPxgIgFZVfM=;
        b=TbpZRzX63dJ2+Ocj8xjAqu83TXAj654ic7kUQQn6sWS1KWcK9gwcqjgZsyZcUIifNm
         y3WmFIKT2TCVYWOhVk7VoVhncFO6EXhqjqKMvkCcxtQhgi0bGMCnqPds7h09Bqr5YHfo
         uicADVWEac+ikHItmqbtxBydLHlwflxYNmoXHhIDzZ/r9Q2c3oMrB/w1kPlJ6E7QvNgI
         M/PSAdTcXnkGIRETpLeFBzvgnIv6v19LIZh7DUAHIUtzaQ4pMhVM8K3oonrgaRuUiJ+F
         hS2gO+7lSvlwQ3iS6VTPyFS/IW42kEqEHkUuRW7RTyDUHz3EZasnQtYKqJAf39e428Ko
         hxWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PYvRBfRL1Chxl6N02AVU3ob8SeK5Em8eIPxgIgFZVfM=;
        b=Emqxvq0bOlx9v9IjX4n4DOgJtkivSqhGSCpmCFHiheng438wJHZxomC6Wyk5zC+yu3
         MXLXVIcD8Xjt1mG+RwndyBbqTR70uDoRBKbq4az+cyndYCNt3xAULtYzQ7BSE8nvtpsU
         f96N24bOfBGOvS6uHaY2Nf01aravJNnYA+r2iL8TssMc0jRtmH0v6XlFdOj18Mdxr9Gu
         gCibgxyZWgGsagNgygQqOFvb9eFdKU3v990gcrVgMCcT+1bde9nsxCTr9zFd2uF8M6uI
         zNZFtH8vXDEh3s+pYD+ZU914Rpg3mFZQG3VJ/B+/UjPy4apSN5WdPxUcRQQN1jZsdpKG
         RoPw==
X-Gm-Message-State: AOAM533YWKVge0Yi4yPg6gWYa3qEFp4aEUFHQ8din8c/B55n7dgnXd1G
        uJfRrsjAZ2iySEOpESle74JPWMDRRDE=
X-Google-Smtp-Source: ABdhPJzOoMAaa/N7eYEB2bm3jnQJnePbljNoUWleNJ1ftEKJ5QLQcvc9lRiUScEF1va75YvzjLbyeg==
X-Received: by 2002:a37:9dc5:: with SMTP id g188mr750928qke.193.1590526964151;
        Tue, 26 May 2020 14:02:44 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2921])
        by smtp.gmail.com with ESMTPSA id 66sm717594qtg.84.2020.05.26.14.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 14:02:43 -0700 (PDT)
Date:   Tue, 26 May 2020 17:02:20 -0400
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 03/12] mm: abstract out wake_page_match() from
 wake_page_function()
Message-ID: <20200526210220.GB6781@cmpxchg.org>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200526195123.29053-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526195123.29053-4-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, May 26, 2020 at 01:51:14PM -0600, Jens Axboe wrote:
> No functional changes in this patch, just in preparation for allowing
> more callers.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
