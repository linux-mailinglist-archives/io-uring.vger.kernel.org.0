Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29DE605580
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 04:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbiJTC0o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 22:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiJTC0i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 22:26:38 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D22194233
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 19:26:31 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id i3so18968852pfk.9
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 19:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zht8V38nFNefb9qqz7Ua2Z6wXrsI+X/zK2yZgvKaQo0=;
        b=tDy5rCNWE3JPgi+UTxtAOOkHblObki8IsPFm2kBjS1d5AHgdLmnBgVG6BsqxenAh7v
         Sm69u/WkJ/sFnGQzDBxLxFf+5z93wcyzXYNJmECy2EG1y03OqWlJLF0aaEHp4GnHOAgi
         A4GqchKg8+8M5XByRFB6YHEj3v9b5obWN+aMVJqEOGIonQW2xA+y5z7Vkfc+/NGnqfPM
         FMtEKOITlXFINgBQc/Cld0h+QG8STu+jHBzOWcKyJwDy1+mltmawJTJkLO1frZorbFTP
         xXB9/cIbFbps5wJpNwIZWtiKKPwW6yx3fsZnzK7Z9s5OPSZI/o9kldKaYOUj80i0AFuT
         8oYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zht8V38nFNefb9qqz7Ua2Z6wXrsI+X/zK2yZgvKaQo0=;
        b=cF6OUNcIPs2xkIe1M96yytUkPKpJw2MTa0OMH2Sk/KBYZ42CHxSASzi6szzUoSSn41
         7VE/P/g6P+AX0DV2c16HAs52jT17lL/sr3QCvVjwWYw7Pgx5QQCTRJ/L513fAbxfJx8X
         4X6iMwFNDgJUL9faPtK/MxEAwtXy4p7M9dsQUs7s6h/UMMlNBZoLf9USnus7uLFL5/f4
         xcHeiwrtuY4XvBzevua58bKO/GA/d+OPXUQ5SzEZpszG46+W7fT0Of0BVT+Vc/TeN3Zu
         JSk0zrNzTX/02GXJs6eEI6zi0BmMYNIscqY+0+N7BtFEhjvQ/mYzh5BBTpMxCVaNqyg8
         0R7A==
X-Gm-Message-State: ACrzQf38/hhD6PlBQO20HK9A4/dyOgLqfnwI8TJEhLyVGzu0Ior9s1Cf
        xRTlDc9RvyR0SGEz1m3ASG7bDEfeOjPxX0BM
X-Google-Smtp-Source: AMsMyM7PnUklTNryL7T4otE56hKTXtmlIjFL3NfFuu9rxHAP6nB9aIW1/bsUXHaLAin1VLPOjtW63g==
X-Received: by 2002:a65:4084:0:b0:463:aa4:49cf with SMTP id t4-20020a654084000000b004630aa449cfmr9703034pgp.164.1666232790001;
        Wed, 19 Oct 2022 19:26:30 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n190-20020a6227c7000000b00565cf8c52c8sm12435892pfn.174.2022.10.19.19.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 19:26:29 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
Cc:     Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cover.1666229889.git.asml.silence@gmail.com>
References: <cover.1666229889.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 0/2] don't fallback if sock doesn't undestand zc
Message-Id: <166623278919.153364.1971861550250409025.b4-ty@kernel.dk>
Date:   Wed, 19 Oct 2022 19:26:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 20 Oct 2022 02:42:34 +0100, Pavel Begunkov wrote:
> Prefer failinig requests over copying when we're dealing with
> protocols that don't support io_uring zerocopy send. The patches
> are split to make backporting easier.
> 
> Pavel Begunkov (2):
>   io_uring/net: fail zc send for unsupported protocols
>   io_uring/net: fail zc sendmsg for unsupported protocols
> 
> [...]

Applied, thanks!

[1/2] io_uring/net: fail zc send for unsupported protocols
      commit: cf6d01d79d3ea2274891c79cb51fa80dfde39acd
[2/2] io_uring/net: fail zc sendmsg for unsupported protocols
      commit: 9f92d171efe73abc3d026ed9e21f08b482075782

Best regards,
-- 
Jens Axboe


