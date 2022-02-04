Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1664A9CD2
	for <lists+io-uring@lfdr.de>; Fri,  4 Feb 2022 17:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbiBDQT0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Feb 2022 11:19:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237439AbiBDQT0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Feb 2022 11:19:26 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D4FC061714
        for <io-uring@vger.kernel.org>; Fri,  4 Feb 2022 08:19:26 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id p63so7911802iod.11
        for <io-uring@vger.kernel.org>; Fri, 04 Feb 2022 08:19:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=xWqbg7HKWafttkcHGFcWJczC+YjsUZmrSZqnk9ayHeU=;
        b=brvYI80Lp/yn7dYipZqdtSGUx265nCvxweZdD1SYHwjAR7hTqA9NNGpvOiJ6Wri1Tg
         +PHBf9asrFKsnDzbFxOrolmY3iLvmFgrODiHVCehOswoCQpI0Hu7CAtONmgxh7PV1yAt
         sjbyuOwJLz66MoocMVcUwTCNsr3DakZM3QjgcOhtUp3P6H5bJ3Ay/IRcbB7Rg9A0vRNT
         KT1219eK5RbZyGbUuvmBNgzld+kPKi5BzUFoWkBdeDu+UYeT64rjs00EJ7Fv5z3bB78A
         QsHxwoM3GbYHGnp0HxvKpr3AmMlJZMm74sCaJZD5QLZqF21JJXIziT/rHekUMJ1YvebF
         u+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=xWqbg7HKWafttkcHGFcWJczC+YjsUZmrSZqnk9ayHeU=;
        b=Pj2fGGMjQaOOlXkTwFEtF1N5QXJuCJtCg67LDC4JeJ7eQRXj2mctSwa8AZ2khDAj7t
         uBClZ/AUSpzHQvj07I01kZjsdQEEu+fZL8BvLQ0XiwXnBp47u0mFJu5EkaGQOuSJsX6z
         /Qh8DrtrOkkS0mTb1DbkpyXwm9IfAU0uO2/ZPZcC5w3hJvEyX02YFZ6ER/PWpbwpE4N0
         nzU39mhha14cMeOG8KeaPOb6sS/Yo9YrODDwbhDDrR5rg3PysDv9ikjr3ws0sliiVOjJ
         Vo+yph9Axu+JMKHP7C03hPLTusBJEPhUTXdzlS1cJywH/s0Xfjn/h8HCuekfDOVblF/K
         Y+/g==
X-Gm-Message-State: AOAM533NHQ5fmJosQxP0Ptc9hmAnIkwC/rLLZYxSZTb4IloDsSJNnRbp
        z+1VMD/KtLq6IQcBgJG3LIjI/Q==
X-Google-Smtp-Source: ABdhPJyITJZ/M5Y6pzolJN77hW8YovE+DxRgfR2XDezdYrwOJmZzGWaaorXrRcjHe15BeR11ytfLkg==
X-Received: by 2002:a05:6638:338c:: with SMTP id h12mr1651841jav.285.1643991565571;
        Fri, 04 Feb 2022 08:19:25 -0800 (PST)
Received: from x1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id k1sm1093435iov.6.2022.02.04.08.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 08:19:25 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org, Usama Arif <usama.arif@bytedance.com>
Cc:     fam.zheng@bytedance.com
In-Reply-To: <20220204145117.1186568-1-usama.arif@bytedance.com>
References: <20220204145117.1186568-1-usama.arif@bytedance.com>
Subject: Re: [PATCH v6 0/5] io_uring: remove ring quiesce in io_uring_register
Message-Id: <164399156486.497439.15709679441946471600.b4-ty@kernel.dk>
Date:   Fri, 04 Feb 2022 09:19:24 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, 4 Feb 2022 14:51:12 +0000, Usama Arif wrote:
> Ring quiesce is currently used for registering/unregistering eventfds,
> registering restrictions and enabling rings.
> 
> For opcodes relating to registering/unregistering eventfds, ring quiesce
> can be avoided by creating a new RCU data structure (io_ev_fd) as part
> of io_ring_ctx that holds the eventfd_ctx, with reads to the structure
> protected by rcu_read_lock and writes (register/unregister calls)
> protected by a mutex.
> 
> [...]

Applied, thanks!

[1/5] io_uring: remove trace for eventfd
      commit: 054f8098d98be4c53ef317e9dd745bb5759f61d9
[2/5] io_uring: avoid ring quiesce while registering/unregistering eventfd
      commit: b77e315a96445e5f19a83546c73d2abbcedfa5db
[3/5] io_uring: avoid ring quiesce while registering async eventfd
      commit: 13bcfd43fd0ef5e0de306e6ffb566970499b6888
[4/5] io_uring: avoid ring quiesce while registering restrictions and enabling rings
      commit: 1769f1468f4697409ee44f494940b5381acc1bae
[5/5] io_uring: remove ring quiesce for io_uring_register
      commit: 971d72eb476604fc91a8e82f0421e6f599f9c300

Best regards,
-- 
Jens Axboe


