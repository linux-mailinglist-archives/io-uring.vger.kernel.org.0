Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B1660553
	for <lists+io-uring@lfdr.de>; Fri,  6 Jan 2023 18:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbjAFRIq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Jan 2023 12:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbjAFRIp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Jan 2023 12:08:45 -0500
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518847CBCA
        for <io-uring@vger.kernel.org>; Fri,  6 Jan 2023 09:08:44 -0800 (PST)
Received: by mail-il1-x12f.google.com with SMTP id a9so642857ilp.6
        for <io-uring@vger.kernel.org>; Fri, 06 Jan 2023 09:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/pi3d90P5aVRL3z1bvp5jzNEWiIqSFyOafKfU6GQ/2s=;
        b=elbhSMQQq08bVlgo7j7XJhbslO49iQ9jPa4188SkzsIfh9dRlLFo8RNE2vKlhUdE9o
         0xc34KZXjXROY4LhcH47O6QGie69XQDB1XI5jM9vLqW8WhdS8rSH+8fJ59UvMDbv8fxY
         XKj5wwjqf0TUPdiVnoKtLtEBJ0D7MQDia3czYitGuOZ+vPVrkZB8NfRE28XB+RrZtr4G
         R7jF4lJNhC4VoFnyosfJxUC3WG2KZifygSWhXu5tLLRgViISwYzJC3ikUHOz9UNarQF5
         FuYNv4orzYVml/lJkOuKipkcE39An1exL0tnrdbF2zQDzBRa7EilcsuWVlkh9n6jr/2u
         QJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/pi3d90P5aVRL3z1bvp5jzNEWiIqSFyOafKfU6GQ/2s=;
        b=aWIHpImITrQWVxHe/604s97gVwSakOPBomwQEZrGTmYj8vtefIYz4/goKEGJ1dmZlF
         Ym4URLV8EXw9/9cT0nSnXVBynCJHbiq2fPppdrCfqbF8Ife7P6X67FVK70gu+v8pmCSu
         TnG3gs4ZanOZcyJVy7NZSd7RlQlEozo5ppu5bk30jqeR+i/o6rcVmWhx7o5zPllgnMwx
         BUsBXoVgcw93e3r3UZZ2hEJVEn3UD6kFBsrj2W4UY9bgoYieLI7w59RGrnzc3wMXekf2
         VqShVY9hKmte/zJP+mMr1SXtO6RDfbOwnU/Sp0Xgi180idCVrXjHPAmOZ55j21OhbUZk
         L+pw==
X-Gm-Message-State: AFqh2krDTizNKfHxGPOt8V4FrT35bBJM/6ZMQU6YZktfFge++zID0emG
        RoN4PNu9XBUi8l8OVadautLBQue3NwymY8NK
X-Google-Smtp-Source: AMrXdXu4NxJLeb5/fLoMI08J50knLr+LqGkXuZLUHHk+5FledlIzOPdvASEMiHUjX9htnN4Ky7KUhg==
X-Received: by 2002:a92:d307:0:b0:30b:d947:6bc8 with SMTP id x7-20020a92d307000000b0030bd9476bc8mr7698801ila.1.1673024923597;
        Fri, 06 Jan 2023 09:08:43 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id l14-20020a92700e000000b0030c27c9eea4sm503642ilc.33.2023.01.06.09.08.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 09:08:43 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Gilang Fachrezy <gilang4321@gmail.com>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
In-Reply-To: <20230106154259.556542-1-ammar.faizi@intel.com>
References: <20230106154259.556542-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v1 0/2] liburing micro-optimzation
Message-Id: <167302492290.43194.3789226051413344473.b4-ty@kernel.dk>
Date:   Fri, 06 Jan 2023 10:08:42 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-cc11a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Fri, 06 Jan 2023 22:42:57 +0700, Ammar Faizi wrote:
> This series contains liburing micro-optimzation. There are two patches
> in this series:
> 
> ## Patch 1
> - Fix bloated memset due to unexpected vectorization.
>   Clang and GCC generate an insane vectorized memset() in nolibc.c.
>   liburing doesn't need such a powerful memset(). Add an empty inline ASM
>   to prevent the compilers from over-optimizing the memset().
> 
> [...]

Applied, thanks!

[1/2] nolibc: Fix bloated memset due to unexpected vectorization
      commit: 913ca9a93fd67a5e5a911d71a33a6de7a1a41101
[2/2] register: Simplify `io_uring_register_file_alloc_range()` function
      commit: 8ab80b483518d51903c9eed24cf0e1ba826010fc

Best regards,
-- 
Jens Axboe


