Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0A069F961
	for <lists+io-uring@lfdr.de>; Wed, 22 Feb 2023 17:54:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231805AbjBVQyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Feb 2023 11:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjBVQyH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Feb 2023 11:54:07 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C5F32CCE
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:06 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id i24so3642019ila.7
        for <io-uring@vger.kernel.org>; Wed, 22 Feb 2023 08:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H//dDKnyV1gvc5I609D1GDjd61B3XJmKhA4pZYVM4iw=;
        b=ddXEtayTkAtIzNVkUCSkqgCKHKZzBsRjfHkB4SXGsnLtrpyobziz6U7SAVQdIFGR/J
         FAcWlAYI3Tj9dpbehnL5q6HYWDaeBoHOdrLeJAXI9kSCPpX14On3FKqVoaH3dhaVfmtR
         yuDEbrlPtzefIZ+UFrEn9j/xYMApiAoVQiUktK7imX4LuPdDIDnBSlC09JLAkJoBb3hj
         X+ZXSR4lrzaMhD/iBlQGr6z7xasGFzeURG0xTadVU2jsu6bM/PKPdujDwxWbvCw8Llrp
         QsXOc+PbpuYS25+VpGMrZ6UqdPJEXky6GSOxAgVwhcRqcve5sQp/kxqOE3Q6lmfpsQ7T
         4yKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H//dDKnyV1gvc5I609D1GDjd61B3XJmKhA4pZYVM4iw=;
        b=3VwPnjSPx08B+s1ljPqRslM8PeZ2zS5hKnQYSaDSUFnw3iVTdlVrwk0t4eRlcBggDj
         EcZP7fDN0TDaheQe/07lP5f23mosQiIVjVU8cUu2JLV2PwMFBkROw6AggvthM9k3/Cr9
         ZglrjM4SELkRDfPb94FB+zJ770b9CI6UKIWGxcbVoku8bxnzADYTZCfTRgie1Llz0gIr
         7o2oGQP4VKmVmUNT6J7WS9beUAyMeeQ8xp9n5CVt7GLgdX1VjmfTIDYAphXoAXFvavm0
         c9g6c20nNOzdIVulBwFFiUcKRcdBsecsvzkGFBZVPccWVVwveORVOLq8DO0FprnrVaG6
         xvGQ==
X-Gm-Message-State: AO0yUKXInHgvYEapqNvkF6MFT2qQepw1qcQElE6frSdszfWkOuqd/9wq
        zvYyNlS0SFLVZv0NViYImlY/UA==
X-Google-Smtp-Source: AK7set8O5a89VAO33p8ojreImEnrnWHnlKP/mFQ9ku2oNT8uiGKaXWzVyjzBw7MmMWnwANo5S4xG6Q==
X-Received: by 2002:a05:6e02:1caf:b0:314:1121:dd85 with SMTP id x15-20020a056e021caf00b003141121dd85mr5314925ill.1.1677084845565;
        Wed, 22 Feb 2023 08:54:05 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x17-20020a029711000000b003a7dc5a032csm997371jai.145.2023.02.22.08.54.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Feb 2023 08:54:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <cover.1676941370.git.asml.silence@gmail.com>
References: <cover.1676941370.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 0/7] test sends with huge pages
Message-Id: <167708484463.23363.15624381216996618725.b4-ty@kernel.dk>
Date:   Wed, 22 Feb 2023 09:54:04 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-ada30
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 21 Feb 2023 01:05:51 +0000, Pavel Begunkov wrote:
> Add huge pages support for zc send benchmark and huge pages
> tests in send-zerocopy.c.
> 
> Pavel Begunkov (7):
>   tests/send: don't use a constant for page size
>   send: improve buffer iteration
>   send: test send with hugetlb
>   examples/zc: add a hugetlb option
>   test/send: don't use SO_ZEROCOPY if not available
>   tests/send: improve error reporting
>   tests/send: sends with offsets
> 
> [...]

Applied, thanks!

[1/7] tests/send: don't use a constant for page size
      (no commit info)
[2/7] send: improve buffer iteration
      (no commit info)
[3/7] send: test send with hugetlb
      (no commit info)
[4/7] examples/zc: add a hugetlb option
      (no commit info)
[5/7] test/send: don't use SO_ZEROCOPY if not available
      (no commit info)
[6/7] tests/send: improve error reporting
      (no commit info)
[7/7] tests/send: sends with offsets
      (no commit info)

Best regards,
-- 
Jens Axboe



