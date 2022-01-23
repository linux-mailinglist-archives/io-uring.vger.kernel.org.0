Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C95497309
	for <lists+io-uring@lfdr.de>; Sun, 23 Jan 2022 17:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233982AbiAWQg2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Jan 2022 11:36:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbiAWQg1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Jan 2022 11:36:27 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00EC06173D
        for <io-uring@vger.kernel.org>; Sun, 23 Jan 2022 08:36:27 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id 9so1106806iou.2
        for <io-uring@vger.kernel.org>; Sun, 23 Jan 2022 08:36:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=t2ihpCOT9aaIultqn19S2wUG+GAbHURR2h3vej3cW94=;
        b=ztHpdqXLKbUiaxeIH0fjcRSyeNmSBOVd+Iy42LMWdBhx2IECF0fz42MSnjhQjM5R1L
         T4kwmgi7rpwU37dQdhSjhaw0UxqEaAkPwq/uJYfKRxuUzS9KiNp/P9TwBZaWXfW0F0qQ
         B68XwGrPFNxaRtgDAsJXjrbyVlR3pvjjCwUedw1GptPjBwcGlsLlNlTdNOeSZ40EdrqW
         6MNe7eqn+gggrZSFrttxWjs5xnZUKjwWZonnxkDV30e0d0uYZLMzTsHpAdOGkMbPaWdt
         W1xpUtUBDJukh12wFsSYOTksqCrP7LIu4oWoVejF52e3/2980HyvUnH1fMmyQlKMU/1W
         7WSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=t2ihpCOT9aaIultqn19S2wUG+GAbHURR2h3vej3cW94=;
        b=hrtybY9h0P44nZUQDWu8k/83gshu+nv2A7sOO1GyaTPT03jvjul1NhE9qMRiNJapJk
         fg4kbIPWA3zUYt/8nXBUXDZrm2jy8poc+SU0gmm+qWuvx3Bq6kbhZ5ddAgCJhozqJ3uI
         drkM21ZpRvkOT8zPALLezg6ehH+XPVYCxOYPZDC6qzRFvoYXs+/G/HLei/KT/zt7fv8W
         vBWPHrmJddOXMTngX74QW8dlk/+hM+njOGXbeFXDbUK+zlaYX1h3oCE9QvXuzjs2ZEJO
         eqHPkgsXmiF7a+A6gr1KygknPbqOwj3d0Jlw724A34r0KmCSsd3npQoMOeZ1fDxTpNWA
         zYuA==
X-Gm-Message-State: AOAM531uCPxlp8YiCdEGoKxHM52AUSSee2qD62PIEhfldG7Z+9N0PPPK
        xW46zhsmZewG+tRxlbcSh2qn0w==
X-Google-Smtp-Source: ABdhPJxDZP1a7NWn+WocNMuiTpLJayZqYXFFEiBnYYzSNqc2LNPKv+G7681AWMhWQR4hL8GUShaamg==
X-Received: by 2002:a05:6602:2250:: with SMTP id o16mr1010646ioo.88.1642955786978;
        Sun, 23 Jan 2022 08:36:26 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id p5sm4780061iof.50.2022.01.23.08.36.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 08:36:26 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Alviro Iskandar Setiawan <alviro.iskandar@gmail.com>,
        Tea Inside Mailing List <timl@vger.teainside.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@gnuweeb.org>,
        Miyasaki Kohaku <kohaku.mski@gmail.com>
In-Reply-To: <20220123074230.3353274-1-ammarfaizi2@gnuweeb.org>
References: <20220123074230.3353274-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH] nolibc: Don't use `malloc()` and `free()` as the function name
Message-Id: <164295578635.5600.9693251485824219620.b4-ty@kernel.dk>
Date:   Sun, 23 Jan 2022 09:36:26 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, 23 Jan 2022 14:42:30 +0700, Ammar Faizi wrote:
> Miyasaki reports that liburing with CONFIG_NOLIBC breaks apps that
> use libc. The first spotted issue was a realloc() call that results
> in an invalid pointer, and then the program exits with SIGABRT.
> 
> The cause is liburing nolibc overrides malloc() and free() from the
> libc (especially when we statically link the "liburing.a" to the apps
> that use libc).
> 
> [...]

Applied, thanks!

[1/1] nolibc: Don't use `malloc()` and `free()` as the function name
      commit: 29ff69397fa13478b5619201347c51159874279e

Best regards,
-- 
Jens Axboe


