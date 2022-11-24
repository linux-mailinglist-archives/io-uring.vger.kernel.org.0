Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79CF46379E4
	for <lists+io-uring@lfdr.de>; Thu, 24 Nov 2022 14:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiKXNZN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Nov 2022 08:25:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiKXNZL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Nov 2022 08:25:11 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BDF13D3A
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:25:10 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jn7so1445232plb.13
        for <io-uring@vger.kernel.org>; Thu, 24 Nov 2022 05:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+tug0I1NwssgRDHq6k+Qmpi8bfrwch+IoJYnGWlVLQ=;
        b=ctMWW2KzY5FAya8MG/6VNJ3u/poOr8TDoCI7xej1Q6V2mGeCnfVUL5Eu9iUqazodSe
         Ix/RBgdYBQ5AQl+b0SwiZgHR2kwdP9kN/4zB/1rlOks/OIxdoBwtPaNULdorVhvzj61L
         UMrBPbpwFYxrXIQJ4j8Ic1CSYos1RtDgct0INT+aiUCcOZC1RnDova37hkzJoo0eFf0N
         N5plFhA8asJ4l6WHETvIj4+eod2cw91crav3WcoV6gHJuC+GivjSbQhXBL6bkVF+xWk+
         X8vahFqdKSKzyOrK1pGKgjY1SidH3WaGK1arS/ZhGR0kVyewVaAec3ZvhnvcXztmvAMz
         0s0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+tug0I1NwssgRDHq6k+Qmpi8bfrwch+IoJYnGWlVLQ=;
        b=4yFb5wv6Hf8YKOkBGFrUSi5HrSwBOrGjhIR2nvK8JtfR1LVv/j/UGai8CKvMQkahxf
         It1RcAzaBBbz6u8Ge+yWts/qRdyM5gHsim4yScHebW4kXCCpd/KqYN3dlF+/12nja1Jv
         RkchhbQlTkHeIUgXYwCYpOsz0XboZ0JZ8X3C4bWGXZdzrkhiGOWz0i0nIQXpHZfhj0mc
         cOq6KF/3Jc9vIAAU+dmiOZ8r0yGMMvdOgswmgL5rQv9m6XD6iBVEXh+kEiC3fzZOuctf
         8GLXbGvIAzt9wZCPGUrWZ+0qyVGbSQhGNTFnpdTQKtnecTykWVw+MIeUqHor2FX8Y5WJ
         coDg==
X-Gm-Message-State: ANoB5pk8LSXLyBBB3ncYX1lxWgnOw5qzw2jd9dxKJPWL87T64BRyJfmo
        b+utzsgk0GwAwYZuk9wIT73yPi7kfVikEaE2
X-Google-Smtp-Source: AA0mqf6N6ZQY86gZW3wx31K8/4Fee16Kv9hQiGGMk0bLkKKOibQbdQayGwjPBKy3no54EFpOlVMLrw==
X-Received: by 2002:a17:90b:3c0a:b0:212:510b:5851 with SMTP id pb10-20020a17090b3c0a00b00212510b5851mr34846318pjb.57.1669296310479;
        Thu, 24 Nov 2022 05:25:10 -0800 (PST)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id x8-20020a170902a38800b0018912c37c8fsm1278130pla.129.2022.11.24.05.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 05:25:09 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20221124103042.4129289-1-dylany@meta.com>
References: <20221124103042.4129289-1-dylany@meta.com>
Subject: Re: [PATCH liburing 0/2] tests for deferred multishot completions
Message-Id: <166929630942.50735.5964782149427153998.b4-ty@kernel.dk>
Date:   Thu, 24 Nov 2022 06:25:09 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 24 Nov 2022 02:30:40 -0800, Dylan Yudaken wrote:
> This adds a couple of tests that expose some trickier corner cases for
> multishot APIS, specifically in light of the latest series to batch &
> defer multishot completion.
> 
> 
> Dylan Yudaken (2):
>   Add a test for errors in multishot recv
>   add a test for multishot downgrading
> 
> [...]

Applied, thanks!

[1/2] Add a test for errors in multishot recv
      (no commit info)
[2/2] add a test for multishot downgrading
      (no commit info)

Best regards,
-- 
Jens Axboe


