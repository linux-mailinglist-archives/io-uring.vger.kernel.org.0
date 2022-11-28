Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6734063AAA4
	for <lists+io-uring@lfdr.de>; Mon, 28 Nov 2022 15:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiK1OPv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Nov 2022 09:15:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiK1OPt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Nov 2022 09:15:49 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A8E2188C
        for <io-uring@vger.kernel.org>; Mon, 28 Nov 2022 06:15:46 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id e7-20020a17090a77c700b00216928a3917so14123719pjs.4
        for <io-uring@vger.kernel.org>; Mon, 28 Nov 2022 06:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HfUJYq7G47MzzTuau0KWiEvHR/P0v0C3Vt90Nu0s9w4=;
        b=bMPU2L8vsLHfGnSnuq+zbeiIr0GzsIaKO9dg1OTewlDKA50QM1ylIalbtux+MTiwvD
         kOHSKE/gHxEV1Mk0fxREwOJeDE0YRm9D7XgpYv7vezAup7ngX08A4uhuYRbcaYa/oOxx
         1dqT1+dA7+PbjqUHUC2nH3PD1uLabsWVw92EjwsZ5Wx6NSaWVtIlGuEB0No36TbVx+m7
         OCsrvehTR9mYfTZfIjGRbly2SMKC6mqRhgaj9j/dQt1rQKnXVsNOXS0pxTZNo5V07Rc2
         RW2KemvFyAMermOywlDEgl/3M7Itt6Qfp0yQdgRfb+kN0JcIc/PfI2yNAsugyIsrlKRY
         YBUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HfUJYq7G47MzzTuau0KWiEvHR/P0v0C3Vt90Nu0s9w4=;
        b=7XlRZkmgIhWnJs2NZ+P4Jwv/RqeWz78W5zaqScp6gZCOzXH+5pnV/YCGL84cqsXnGo
         sUfixGfJtcDo61lxtI8J+DLtfN1QB9CtWr5HcNvJegJ3jcNiak+zY5dMqEdpRt4ObXpl
         BN5xJOAGODAu6rJoODyDZHuwVYhyUdRbo48Gz+ADPMW/0Ur87sQyIdIre56AnDs1jjmq
         ALsIEuhVVZwr9s+H1mAUj9JGI19PKb0zlWyzuDx7b48eGw+6C/u/dmrYgVAVh9Pj2DZb
         O1HudiKb9C/UPPfa3zwXXqWfa/NtmC1KRL4Zj1dsuKChuVRAIKjkHABzJ5ugOc8OPjoI
         AA/A==
X-Gm-Message-State: ANoB5pkZsxHBAuUlNeRzh23/npV8F3twC6NyjmRCANFOXxC7gb/Ye/FH
        2RY3B+do+WbeKPVth4eql1KjmGu+ZyAtlsM4
X-Google-Smtp-Source: AA0mqf4RlfduB70qFQfkFKxWY27m/b1gGNmiA1/yu87ZLAAWgKKUfcAaK/s4FdnIWc3vhomHL7d34w==
X-Received: by 2002:a17:902:e886:b0:185:4ec3:c703 with SMTP id w6-20020a170902e88600b001854ec3c703mr33291278plg.165.1669644945553;
        Mon, 28 Nov 2022 06:15:45 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id v2-20020a626102000000b005609d3d3008sm8331640pfb.171.2022.11.28.06.15.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 06:15:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     Gilang Fachrezy <gilang4321@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        VNLX Kernel Department <kernel@vnlx.org>,
        Dylan Yudaken <dylany@meta.com>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
In-Reply-To: <20221124162633.3856761-1-ammar.faizi@intel.com>
References: <20221124162633.3856761-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing v2 0/8] Ensure we mark non-exported functions and variables as static
Message-Id: <166964494429.5513.5606852896761842745.b4-ty@kernel.dk>
Date:   Mon, 28 Nov 2022 07:15:44 -0700
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

On Thu, 24 Nov 2022 23:28:53 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> This is a v2 revision.
> 
> This series is a -Wmissing-prototypes enforcement. -Wmissing-prototypes
> is a clang C compiler flag that warns us if we have functions or
> variables that are not used outisde the translation unit, but not marked
> as static.
> 
> [...]

Applied, thanks!

[1/8] queue: Fix typo "entererd" -> "entered"
      (no commit info)
[2/8] queue: Mark `__io_uring_flush_sq()` as static
      (no commit info)
[3/8] test/io_uring_setup: Remove unused functions
      (no commit info)
[4/8] ucontext-cp: Remove an unused function
      (no commit info)
[5/8] tests: Mark non-exported functions as static
      (no commit info)
[6/8] ucontext-cp: Mark a non-exported function as static
      (no commit info)
[7/8] test/Makefile: Omit `-Wmissing-prototypes` from the C++ compiler flags
      (no commit info)
[8/8] github: Add `-Wmissing-prototypes` for GitHub CI bot
      (no commit info)

Best regards,
-- 
Jens Axboe


