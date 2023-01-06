Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B07166099C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 23:39:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbjAFWjo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 17:39:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235860AbjAFWjn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 17:39:43 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12AA87295
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 14:39:41 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id n63so1464033iod.7
        for <io-uring@vger.kernel.org>; Fri, 06 Jan 2023 14:39:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B8JyunlHx89aJ1DIcnU1d6CAIOc8LCkoiYgUFT+hW1A=;
        b=IK8yrSYg0nR3j8zdG2BWDoB6bWyG3L+teq4qTLGrouGweE1VI1RK4J1suUkuKGzko3
         H+l6q0Uu9HMjhnWIMKAqRwPC6OHTOmTVczBsVs9QulD6qqLvK3s04TmKU+G6ENAnqccQ
         5SjQHvLFeNM8MkGkv3fMg3i3mIyIkE9Lz+Wp9wgO0+KYoOgl/fGeaygrR39ggu6UrR4T
         nte/3sbcIIkzp81TdZLw/pn6I41dv+WaeVPEuCaKc4a+9MTkCQ1GECxU/LzlLWOUylAQ
         R2f2V4p34dBZDsUMaYBBD4vSQ/LMUN4mqdCijsNcQVuNL35xRMmvtEorweQwG8wqMr+K
         j4xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B8JyunlHx89aJ1DIcnU1d6CAIOc8LCkoiYgUFT+hW1A=;
        b=IHmDsjk96qrEiMtZ9euDmFBVkL7bVIn9/9pq/n7oeI72PEbp4NKeF4mu3kZ6X2JGGe
         MANJfWSi9u39ACb0oj2hgtw7fXZeNPRFXziBkhBzhMnc3ucliKVEtoVUJMcpv1m4IyQY
         D10eeWm3hdcBx20EX6ZanjYY92MJWABa0584Pft4Ft7GTHyUcV38TeeeIABmglwuyXlk
         8ArQZ36xp0PMZB1ibHhTkg58WIGbaJvE9oHZ5hiL4NheqOOoSB0UavM3k6OW7RAMtD3Q
         I6B09VzaABZfpzpFXkCXz9aFN9HFG2JyReVa2uaUtFORvb6rQrpveU6Qom0HnpAqeDCa
         E3QA==
X-Gm-Message-State: AFqh2kpGcS+0XHBvm8QoiGngvkdoBEjTJUGtX/Z6g2BBpyoJW4mx+2IC
        dI41+097Z+F9/CdsNlXN/Td1Lg==
X-Google-Smtp-Source: AMrXdXsP2pADr+KUESdgw0Osko2ASnuPYVREmaUskDlnIe1gnQQxg141QIIE6oDR1/Cxg/U9jE0vnQ==
X-Received: by 2002:a6b:7d46:0:b0:6ed:1ad7:56bc with SMTP id d6-20020a6b7d46000000b006ed1ad756bcmr8173152ioq.0.1673044781177;
        Fri, 06 Jan 2023 14:39:41 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id d97-20020a0285ea000000b0039deb26853csm669292jai.10.2023.01.06.14.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 14:39:40 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20230106155202.558533-1-ammar.faizi@intel.com>
References: <20230106155202.558533-1-ammar.faizi@intel.com>
Subject: Re: [RFC PATCH liburing v1 0/2] Always enable CONFIG_NOLIBC if
 supported and deprecate --nolibc option
Message-Id: <167304477992.67146.5312219906954771753.b4-ty@kernel.dk>
Date:   Fri, 06 Jan 2023 15:39:39 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-cc11a
X-Spam-Status: No, score=-0.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 06 Jan 2023 22:52:00 +0700, Ammar Faizi wrote:
> This is an RFC patchset. It's already build-tested.
> 
> Currently, the default liburing compilation uses libc as its dependency.
> liburing doesn't depend on libc when it's compiled on x86-64, x86
> (32-bit), and aarch64. There is no benefit to having libc.so linked to
> liburing.so on those architectures.
> 
> [...]

Applied, thanks!

[1/2] github: Remove nolibc build on the GitHub CI bot
      commit: 439cff00aa9a3b8bc6b88787ffca90d32655ce2f
[2/2] configure: Always enable `CONFIG_NOLIBC` if the arch is supported
      commit: bfb432f4cce52cb3e3bd9c1823e94ff29bd4fb80

Best regards,
-- 
Jens Axboe


