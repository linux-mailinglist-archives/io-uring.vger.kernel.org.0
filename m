Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A00157CF31
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 17:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiGUPdw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Jul 2022 11:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiGUPdk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Jul 2022 11:33:40 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FD888137
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:32:47 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id x64so1627562iof.1
        for <io-uring@vger.kernel.org>; Thu, 21 Jul 2022 08:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=FmyExEL62abKjLGhub3xYmsZYhcRxJJ+x5gO4qRGz0o=;
        b=24pK2KUKf4NirwSefvKry1EF1hsM12aHo4CkykMA5UKEUSwJevY2SSlKQoj4yVha1x
         a2XCeruuSuz/RKOnDOAjh0RBw0MD3Vx7Svvq+MrmiEUFIyj7JI8+OnqIFxS0mS9Htuy3
         VDPkGnYx4tdWcOIwFH08VbBoxuDYDh+3kAqydSmSVXSKYEz/8adns2t5a7+U+4KhUTw7
         L8xpBUG4Jzv2ZY9YEEMJ3BJSPObPwufy9rqkkE3xlDn6bF/29nPtAx3DATGcX89AyxCH
         jbLs11Y/hZ9nZvkw6Rwb/ej8SO/lxQbO4S33FyskIMtiQOF5pgdiLd7ECqJYy8V6gw9u
         YnfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=FmyExEL62abKjLGhub3xYmsZYhcRxJJ+x5gO4qRGz0o=;
        b=nu1XBZVKLWFzQ4xshZDafxXnLZ85nIl7AotHCfhiTPqTOt/vRLL8qMGif9uQ3qwSka
         mDyjA45SGfL4TJB1t/KFrRufdnAuz7jXNMizhAfYGgJpu7F7qh6PkKxC0xJHGUrmfLc6
         NRT4zawnSoLt2ule62CEEvOHwgSBEbE7UH+VbrK1C4kB8IsfTVF6n7N4N6A9WqNrfZIy
         nKB+GRuSzJVnMgYFGHJtmYoM+oyhQ3kaRvuGZJHMf2kqbnUcDje+YS+Es2C3swYB3Ffr
         1PCUptaNxj8O3B5bCYgtAjtTx3L49EpYmXHz8a2/eYU36AamKEG/5fexMAksBXJC8zEF
         +Hig==
X-Gm-Message-State: AJIora+nRIMp3WIlXF4siL8pDPT/GDo1zGWMuBciL1cxJhY8T12S4jOb
        G8WKJhStpvtw3Ro9vmFXkbI7WA==
X-Google-Smtp-Source: AGRyM1udMHX54Beyo+KsX58hL2wxkxxhbFqW1SpJzB3qBPJ3AOojxgixFb7l44hwA4vo/tAJRuTGXw==
X-Received: by 2002:a05:6638:1a13:b0:33f:1f32:6248 with SMTP id cd19-20020a0566381a1300b0033f1f326248mr22408240jab.53.1658417565862;
        Thu, 21 Jul 2022 08:32:45 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f13-20020a02a10d000000b0033f3dd2e7e7sm891150jag.44.2022.07.21.08.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:32:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     howeyxu@tencent.com, gwml@vger.gnuweeb.org,
        io-uring@vger.kernel.org, fernandafmr12@gnuweeb.org,
        asml.silence@gmail.com
In-Reply-To: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org>
References: <20220721090443.733104-1-ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing] Delete `src/syscall.c` and get back to use `__sys_io_uring*` functions
Message-Id: <165841756488.96243.3609313686511469611.b4-ty@kernel.dk>
Date:   Thu, 21 Jul 2022 09:32:44 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 21 Jul 2022 16:04:43 +0700, Ammar Faizi wrote:
> Back when I was adding nolibc support for liburing, I added new
> wrapper functions for io_uring system calls. They are ____sys_io_uring*
> functions (with 4 underscores), all defined as an inline function.
> 
> I left __sys_uring* functions (with 2 underscores) live in syscall.c
> because I thought it might break the user if we delete them. But it
> turned out that I was wrong, no user should use these functions
> because we don't export them. This situation is reflected in
> liburing.map and liburing.h which don't have those functions.
> 
> [...]

Applied, thanks!

[1/1] Delete `src/syscall.c` and get back to use `__sys_io_uring*` functions
      commit: 4aa1a8aefc3dc3875621c64cef0087968e57181d

Best regards,
-- 
Jens Axboe


