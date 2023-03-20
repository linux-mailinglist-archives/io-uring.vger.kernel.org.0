Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72236C234E
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 22:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjCTVAG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 17:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbjCTVAA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 17:00:00 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A1325942
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:59:50 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id s7so7165097ilv.12
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 13:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679345989; x=1681937989;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b2xtN+cTIO7H6iYMw46QYaYZEP/mnMZnzY869dDWxEg=;
        b=AO2z2Z0BFhA7itRoYIdGbWfs0r6HDbRjYfq3xhODwdTLXjVqNtPnkFpPkrDItl74o0
         /LSsb6JC1HuESORvq7QgMuiX7Bco/LvZqIkljGcNxaTrBNw0nMbNux5mTepjsEk7koxI
         dFw3WG0OwXYv/65eS7EHLlsrWxM44NsE2wxbAhXaP9naB4n4uEM2DMYHBO42DpfNY1RR
         KC7tfO+xPeu2/S4z3AcMVuw0vQ6KuqHmWpfbOf5NIMzq8A1X8TWqZ0042I41kU+FeavU
         6VDvHuTJvhrl9mjwjDn0AhusVHJaHurHbgOK3EDLKGii+aLuO+maLir1Apt87KFRDjw5
         Xxhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679345989; x=1681937989;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b2xtN+cTIO7H6iYMw46QYaYZEP/mnMZnzY869dDWxEg=;
        b=JG6SAg96dmYI8XuECK4rMnLaHRSl1OUwu+IkcdjKps4FoBJUkHaP3LkkEqtkTgX3vV
         vgVi0GmuAh/YP+gk5gVI8hSehzKCASFHt2YIsvYakcm07Tx+2niCt9uV9s34YKMwMMzw
         DyTNxSqSPEHi6qHphyiHPdOJt9ynnHZAnUp63PNTegUVW2c9aT+b5I3P1mCAq5U1C5jE
         DyMmgk+2dfb36Z7YOesAbBxeAYz0LdDIVbJ2Rhd/dM3aiJSjHXz9UhZQKWXpUFQlln8F
         xbwVmDp1194hauJ2KyuhZ3zeODpvu/YvLODwEGZtVNxBVWc81YD1s7AYrZ3EZCykxsfj
         naNA==
X-Gm-Message-State: AO0yUKVqyeKMWteLtKdLOp/x9loxtmbLsTudnKB0LrdtBXL4agcD4/MB
        0qoWTMPR6cSu0fMxzO8kdqDF67U9R1t9kKUWRW7iPg==
X-Google-Smtp-Source: AK7set9xj4UHYy0IFuaTHn7N+HXwbXU4TOrpC2SyZrHI1fEwCbAzSR6n4ZRdK5ZyJ5zO5oAzZnXXsA==
X-Received: by 2002:a05:6e02:1a84:b0:316:67be:1b99 with SMTP id k4-20020a056e021a8400b0031667be1b99mr622199ilv.0.1679345989306;
        Mon, 20 Mar 2023 13:59:49 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f15-20020a056e0212af00b00313fa733bcasm3091366ilr.25.2023.03.20.13.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 13:59:48 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        Keith Busch <kbusch@meta.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Keith Busch <kbusch@kernel.org>
In-Reply-To: <20230320194926.3353144-1-kbusch@meta.com>
References: <20230320194926.3353144-1-kbusch@meta.com>
Subject: Re: [PATCHv2] blk-mq: remove hybrid polling
Message-Id: <167934598874.203909.14226439075837496354.b4-ty@kernel.dk>
Date:   Mon, 20 Mar 2023 14:59:48 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-2eb1a
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Mon, 20 Mar 2023 12:49:26 -0700, Keith Busch wrote:
> io_uring provides the only way user space can poll completions, and that
> always sets BLK_POLL_NOSLEEP. This effectively makes hybrid polling dead
> code, so remove it and everything supporting it.
> 
> 

Applied, thanks!

[1/1] blk-mq: remove hybrid polling
      commit: aa939e415c6c49cabcab2bc16fda2bc38ca0c235

Best regards,
-- 
Jens Axboe



