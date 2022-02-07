Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB484AC43E
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 16:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238618AbiBGPqa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 10:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379639AbiBGPoL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 10:44:11 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C597EC0401D2
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 07:44:10 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id b5so5040051ile.11
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 07:44:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=Ko7utT61KQM+vnI1dXkol9PWA1E2/Jgt+cxVzxGcXT0=;
        b=ZZY8gU8z+UUez1b9ohUVeo8KMZps07sOCWCFRkg/7ttY17GG/0HOFesNlLcrl8dBg5
         fmeyfErMckJfmxBzHzRtDbiLWjhYWyaGjZKlXOE1Xor06BUGcSgGzMl5XYNxiWD2jwVL
         xFLy9t+BDldE8tUfzecxr61kUeex1AkbJsPpyu3VDGBO7nmsKlK35Cf9MHOTLj5DfUTY
         3+nJoPhccbOyiSS7GgMfvXZ5QQnUQXjRRQnlO91K8X+/4ojxRlr0BGy7b/6r1dS9VJvY
         rKaImVlb3KpOPtvCZTqXNgLvrbLAtytM21Wmz0KnsKZqKJKBWWcgeNHBuSf5y1+pMDZJ
         96RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Ko7utT61KQM+vnI1dXkol9PWA1E2/Jgt+cxVzxGcXT0=;
        b=GRhLlhhsPAd2TIhBeOwIyvdGSmQvgt6H3E8mMiFxOP0eiJz681s9rSJqSXrJ6glT+R
         YtCeIY31GyiovOVHrLL3nElfTMmlKlDPMfhzFaBxHAkmrIfgW4LGgZUcqWBVl58wGe5k
         IgkU/c2bAErEetSFkuA0mWEX+p4eu3NrX/60I15Gb2kOs+Ug57LaP8tz0r9W1N13CxUg
         vVtLS+UShtkhh03HM97YUbymh3NZZ2DsVPrKfeAw6WzvAprFL4REF8zVFqDM30pvwu64
         STNpjA4U9K+VrNZrguIgOW1zhl//3suC3ol/OVJLRO7EvoAVhwgH1qRk2fk+K5wMQwfl
         vkqA==
X-Gm-Message-State: AOAM531sTpH6gV4taFcIzFW197TJFaCPuD6BhN4qRjAWx48C0nT8EbVY
        NG626p+kQNEeW8gw2GxQYBxHNw==
X-Google-Smtp-Source: ABdhPJziZtkcrEPotcCiTBug6aK8Cq29kEOJlLvRQSssL2peEbGixAa0oVSVB4kXLrjuLtLWp+vp1Q==
X-Received: by 2002:a05:6e02:20e1:: with SMTP id q1mr69357ilv.172.1644248650174;
        Mon, 07 Feb 2022 07:44:10 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id u26sm6145534ior.52.2022.02.07.07.44.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 07:44:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Shakeel Butt <shakeelb@google.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        io-uring@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220125051736.2981459-1-shakeelb@google.com>
References: <20220125051736.2981459-1-shakeelb@google.com>
Subject: Re: [PATCH] mm: io_uring: allow oom-killer from io_uring_setup
Message-Id: <164424864739.20474.1005758721065319672.b4-ty@kernel.dk>
Date:   Mon, 07 Feb 2022 08:44:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 24 Jan 2022 21:17:36 -0800, Shakeel Butt wrote:
> On an overcommitted system which is running multiple workloads of
> varying priorities, it is preferred to trigger an oom-killer to kill a
> low priority workload than to let the high priority workload receiving
> ENOMEMs. On our memory overcommitted systems, we are seeing a lot of
> ENOMEMs instead of oom-kills because io_uring_setup callchain is using
> __GFP_NORETRY gfp flag which avoids the oom-killer. Let's remove it and
> allow the oom-killer to kill a lower priority job.
> 
> [...]

Applied, thanks!

[1/1] mm: io_uring: allow oom-killer from io_uring_setup
      commit: 0a3f1e0beacf6cc8ae5f846b0641c1df476e83d6

Best regards,
-- 
Jens Axboe


