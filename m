Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9512792A55
	for <lists+io-uring@lfdr.de>; Tue,  5 Sep 2023 18:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350069AbjIEQe7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Sep 2023 12:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354820AbjIEOoR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Sep 2023 10:44:17 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B086F199
        for <io-uring@vger.kernel.org>; Tue,  5 Sep 2023 07:44:14 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-34bbc394fa0so1990365ab.1
        for <io-uring@vger.kernel.org>; Tue, 05 Sep 2023 07:44:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1693925054; x=1694529854; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j09CxfP7Q9c0us68Fz35zVFIrzbKcMJUU91bdn4MiJs=;
        b=z7aFB/p1HB1Caf4HGAmTGuPhtaCkYeGHQGLcUI4w4ijNNaAtyh2K+AQoGHBEc+nHYt
         psLdFhryQmQazRwEcsNWM+PqORloAJfYhjX9R7mynk0FHiACggNLq9VGDz11jCyINkwy
         j45uOvMG4IhMMc45BaxEvI1uUs8XD1XFL5RYdAy/5MQbWFOj11vE+fuiExx6x7VdaIV/
         Ju7ivMcOXThNhIriiL7DxTcLUIkFEMp9IZZwh4jNFi3gTkdVjSkbNIzdhnhHozBuPNCG
         n/y2lbnStTj6zSE/QIwo7qxudrUqOovbRy4Rc+veHziZ3dnSr9VQeI0hZ8qF1nrOQgs7
         b6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693925054; x=1694529854;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j09CxfP7Q9c0us68Fz35zVFIrzbKcMJUU91bdn4MiJs=;
        b=CTTxHjzW55AUcW3jK+HMGnhmCMDUG7Ql81cjeY2ex8+8txpTrp5ZS9sR7OTzTVoVXm
         e/zumuhgs6K/eC2iaFgaMlNPwQvxUnI7K6l/mzuRYIomvXhae1JYiZYasyHpScxw3Zlw
         9Qsrh39wZ8FZGviV+ebeTKZzqrC0brXENT4nF9OozLH3gkdlefQW8jaWp3w6t0yDsNCu
         KfYWj+iZHxQ6ocibG6+TBbp9IvsLVOdttsom8kUJ/8hicX57iAwRhy2ez2NhB/Jdlcjr
         5RdNxfaoGzCFDaEZ5jWlvxi13cMymhuhYxUIBwPCmNw0upc29ZHdhkxMZfFzTswU/Z3b
         7CwQ==
X-Gm-Message-State: AOJu0YzEMpv+/C4Rc0KHFxRo+XK1pdVfzalwjFVXiKHDkM0t91PP1vX2
        yLoUtfd9/uU/i7mFoHYirJbquQ==
X-Google-Smtp-Source: AGHT+IEqR7NZpLw0o7Jy5Fy6ggwR2P/wQtoDxjAfsShcmCERKsOPbno+7dCzN+xZIM5O4CBXw7WwSA==
X-Received: by 2002:a92:d785:0:b0:34d:18b:aeca with SMTP id d5-20020a92d785000000b0034d018baecamr13282187iln.3.1693925054096;
        Tue, 05 Sep 2023 07:44:14 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id m10-20020a92caca000000b003426356a35asm4188519ilq.0.2023.09.05.07.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Sep 2023 07:44:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     matteorizzo@google.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        asml.silence@gmail.com, Jeff Moyer <jmoyer@redhat.com>
Cc:     corbet@lwn.net, akpm@linux-foundation.org, keescook@chromium.org,
        ribalda@chromium.org, rostedt@goodmis.org, jannh@google.com,
        chenhuacai@kernel.org, gpiccoli@igalia.com, ldufour@linux.ibm.com,
        evn@google.com, poprdi@google.com, jordyzomer@google.com,
        krisman@suse.de, andres@anarazel.de
In-Reply-To: <x49y1i42j1z.fsf@segfault.boston.devel.redhat.com>
References: <x49y1i42j1z.fsf@segfault.boston.devel.redhat.com>
Subject: Re: [PATCH v5] io_uring: add a sysctl to disable io_uring
 system-wide
Message-Id: <169392505265.592530.1699660694804027481.b4-ty@kernel.dk>
Date:   Tue, 05 Sep 2023 08:44:12 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-034f2
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 21 Aug 2023 17:15:52 -0400, Jeff Moyer wrote:
> Introduce a new sysctl (io_uring_disabled) which can be either 0, 1, or
> 2. When 0 (the default), all processes are allowed to create io_uring
> instances, which is the current behavior.  When 1, io_uring creation is
> disabled (io_uring_setup() will fail with -EPERM) for unprivileged
> processes not in the kernel.io_uring_group group.  When 2, calls to
> io_uring_setup() fail with -EPERM regardless of privilege.
> 
> [...]

Applied, thanks!

[1/1] io_uring: add a sysctl to disable io_uring system-wide
      commit: 76d3ccecfa186af3120e206d62f03db1a94a535f

Best regards,
-- 
Jens Axboe



