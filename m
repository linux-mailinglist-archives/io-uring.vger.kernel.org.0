Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14495670FA
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 16:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbiGEO0H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 10:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbiGEO0H (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 10:26:07 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7748D64
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 07:26:06 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 67so2004395pfy.5
        for <io-uring@vger.kernel.org>; Tue, 05 Jul 2022 07:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=fyqTOUBnfuHQOoTkWg/jS9nTsZbB4JufyVxsY6cmEso=;
        b=VJUbv0OHU6WQC0sYlNiLvOhxresVLEFPiBetNpf+qms+IqyoCztDHnyi/TCggr1zJK
         X2VblH73ZHrmp89feir8DHFs3bV/viIRKIt7W1tisDR1bmTNNgEa4T5cK302XpzNfuYz
         Yc0wrT95dvXMavJ+dd9YKPBoRJTkqStLo0Xkw02v1M5aB9gnicPaREDu/f7MBQUpaeoX
         p8oNDfRrOBquAXpVW6qNwy3hjGttDjO0egtlaSFN0DgaxWV5MdM4C443KzGdVZXFFhfy
         LwcTLvYHtv4/GTSLnglKC+Pqih9QiUDYovHYcyh93nLMj0zLFPiiCb9FyV548yaIwJ+J
         /QSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=fyqTOUBnfuHQOoTkWg/jS9nTsZbB4JufyVxsY6cmEso=;
        b=R0Uj9qrD01xFFxiNWREmx2HedCZ1J1UfZhF5XBCZh10mLkc9HfxFrxTokhapVhPDHo
         DYrhsVOoAk9yVGKkWRv/OTGK7XvcDUJam4+p6zWA8DE58tqygyqcbItmDB7Mfx8pnn+8
         BD80rkijuCWBeVWopkLQQ3LuRfYeWjJ0AebJC2wGu0msPGzEII9ZRiY+OwKrEzGE2cbl
         V2uRQ24+lo7JniLo7ktCggdtv/mvWJBFcFaNnoGhBLGya3XT156K21SaB6rKJuJeJvJN
         qyKK26r6znoTCtsNMZANguk7K3nXwNbcAs2HnU45L/skObbv+d7M1NKnsboWL6yFfGO7
         cwGA==
X-Gm-Message-State: AJIora/6wDOM+75kItvLSuXCiAxWwgWg25yfdm7PQ9sQeUTMbnqdDBQe
        r1+8weBJ+5Q9V3vsqj2BP5QyAw==
X-Google-Smtp-Source: AGRyM1txzWgF1VDKjKX97JDfJ0NHfEnWOXyVIA6gq71RiWrtOoQJwgbQFSVArF6ge1+hpIBYE0/v9Q==
X-Received: by 2002:a63:1710:0:b0:40d:dd27:789b with SMTP id x16-20020a631710000000b0040ddd27789bmr29604644pgl.386.1657031166349;
        Tue, 05 Jul 2022 07:26:06 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090aba1600b001ec71be4145sm15038047pjr.2.2022.07.05.07.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jul 2022 07:26:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     io-uring@vger.kernel.org, fernandafmr12@gnuweeb.org,
        asml.silence@gmail.com, alviro.iskandar@gnuweeb.org,
        gwml@vger.gnuweeb.org, howeyxu@tencent.com
In-Reply-To: <20220705073920.367794-1-ammar.faizi@intel.com>
References: <20220705073920.367794-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v5 00/10] aarch64 support
Message-Id: <165703116507.1918701.13905356149364349396.b4-ty@kernel.dk>
Date:   Tue, 05 Jul 2022 08:26:05 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, 5 Jul 2022 14:43:50 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This is v5 revision of aarch64 support.
> 
> This series contains nolibc support for aarch64 and one extra irrelevant
> cleanup (patch #1). The missing bit from aarch64 is get_page_size()
> which is a bit complicated to implement without libc.
> 
> [...]

Applied, thanks!

[01/10] CHANGELOG: Fixup missing space
        commit: 3b70ce9c946a2a6623b23f88e1f38ae3a6f9e0ee
[02/10] arch: syscall: Add `__sys_open()` syscall
        commit: 27c678f1698871bbdcd6ccb853a54374e62e9532
[03/10] arch: syscall: Add `__sys_read()` syscall
        commit: 420e43f8bde3bb564c32702dabd416fc8b6154f4
[04/10] arch: Remove `__INTERNAL__LIBURING_LIB_H` checks
        commit: bd2bed0057d0875726eff0587bf0be92fe9d246e
[05/10] arch/aarch64: lib: Add `get_page_size()` function
        commit: c6bc86e2125bcd6fa10ff2b128cd86486acadff6
[06/10] lib: Style fixup for #if / #elif / #else / #endif
        commit: 090fd8441bf70d4db35796946cb7703b4e13e794
[07/10] lib: Enable nolibc support for aarch64
        commit: e7ad97fb51b116dfa653f55508d7be131a65d8f2
[08/10] test: Add nolibc test
        commit: 46d3e1df5f434156916abd0578110d0477bf56f7
[09/10] .github: Enable aarch64 nolibc build for GitHub bot
        commit: b86c5c795ed83add45f1c4e9955509093f2d9709
[10/10] CHANGELOG: Note about aarch64 support
        commit: 41f9e992d11e0fde0406b706afce31f6926e13de

Best regards,
-- 
Jens Axboe


