Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8A773EFA5
	for <lists+io-uring@lfdr.de>; Tue, 27 Jun 2023 02:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229457AbjF0AY5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jun 2023 20:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjF0AY4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jun 2023 20:24:56 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A93D10F5
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 17:24:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id 98e67ed59e1d1-25f0e0bbcaaso1879996a91.3
        for <io-uring@vger.kernel.org>; Mon, 26 Jun 2023 17:24:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687825494; x=1690417494;
        h=content-disposition:mime-version:reply-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wCxpTNqORZ5+AzLGSEy9l2LgMLxfoUaOQ8AaMT5efkA=;
        b=Kh7M1PAauPBz+06KP4fCzIkxRuUXrwS77EKYZsuQuxQbpu9on9qCCSg6/mGOYryERz
         ezsO6pTfRZxWoEvs9vvKxjfuHl3Zh3hr2Ed81kac36A94Yt3CJHrm9GrXNEBRn4J+UGX
         qbc0CaSmqPe1IiAoE6qHjrRqfPSvtAmhcTMHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687825494; x=1690417494;
        h=content-disposition:mime-version:reply-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wCxpTNqORZ5+AzLGSEy9l2LgMLxfoUaOQ8AaMT5efkA=;
        b=Le7ZgKOOZl3iQKV1yF+OUEdXusGNesX3N5CwOE+iObs613lzG2yfVHFqsMLCA+EeKO
         d54OMERNPPbPZ5l+rYebSzos5r4R5oHrQaEH3bdhsmuzpP2faBR3YnUB+1ckTAQ/ZuUu
         dOM2bi9CMU9N5cr0OFqJskVHERaOmKHBjOCev00nNY/+w0HXXf4txIChOrnOlhxaYBB9
         ZHuN6vVf+eZGo93cRhoNqeW9TstmzbWegMdfv6R6usqrN3jZ3PN+lCDl1MOI5eSMzTH4
         hC+gXtGWu6S5AjhOa8yyT75oRHVietZL/j0pF4XHUK9NBSuXj2lmCnUtnL6sUHJX2Sxd
         utbQ==
X-Gm-Message-State: AC+VfDyTiswD6RCwFI24gcO4BGrnd5RdJhM4RGOdNkhhEpfPaPeMAIdb
        vDOU9KI22KD6r2iqao53/vpDxQ==
X-Google-Smtp-Source: ACHHUZ6BFP3qpFF6l4dcxNqSJJ90xw43tigw2rKcrCWRiOEI+WI1NZDcJqI999MRTf5pU/llJ9qo5A==
X-Received: by 2002:a17:90a:bf03:b0:262:f029:6946 with SMTP id c3-20020a17090abf0300b00262f0296946mr3588289pjs.9.1687825494565;
        Mon, 26 Jun 2023 17:24:54 -0700 (PDT)
Received: from google.com (KD124209188001.ppp-bb.dion.ne.jp. [124.209.188.1])
        by smtp.gmail.com with ESMTPSA id x187-20020a6363c4000000b005533b6cb3a6sm4605506pgb.16.2023.06.26.17.24.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 17:24:54 -0700 (PDT)
Date:   Tue, 27 Jun 2023 09:24:50 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring updates for 6.5
Message-ID: <20230627002450.GK2934656@google.com>
Reply-To: CAHk-=wjKb24aSe6fE4zDH-eh8hr-FB9BbukObUVSMGOrsBHCRQ@mail.gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/26/23 1:40?PM, Linus Torvalds wrote:
>
> mm/zsmalloc.c:
>        set_freeobj(zspage, (unsigned int)(-1UL));

[..]

> both of which are impressively confused. There's sadly a number of
> other cases too.
>
> That zsmalloc.c case is impressively crazy. First you use the wrong
> type, then you use the wrong operation, and then you use a cast to fix
> it all up. Absolutely none of which makes any sense, and it should
> just have used "-1".

That zsmalloc code is gone, you should not see it after you pull
MM patches from Andrew.
