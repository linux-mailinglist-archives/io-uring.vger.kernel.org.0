Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1C124ADA8C
	for <lists+io-uring@lfdr.de>; Tue,  8 Feb 2022 14:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244918AbiBHN6D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Feb 2022 08:58:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbiBHN6D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Feb 2022 08:58:03 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B61D0C03FECE
        for <io-uring@vger.kernel.org>; Tue,  8 Feb 2022 05:58:02 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id z35so1922211pfw.2
        for <io-uring@vger.kernel.org>; Tue, 08 Feb 2022 05:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=TWs/pi13W9s3W1BKYFNV7ZvPA+qtn2fXWAaFncVNBc4=;
        b=h1dFK7T+x6tKeDpUl4n3poDM9S+jOvviadfLmhPCX+gbYVpqjzsWT1XlEUG4QMsJtl
         9lA76BKvnt2aj9GqEN2H8rOyxkUUNdU+/dUUKTevvoKT8+jfWnaBF2/N9lOfmBB49IRu
         INHnA2at1qEqhnlZvfA9Tgham9FSWtGzPFQXe8UlN2PxT7J27j9+ZQpcSrm21h3+S23L
         iu7lum6Dkjc0ixmjWSDonMksCILvz+WeAgkkstdkw0tSD9qMtcY5J4Y+JeGOGxdkYiC7
         WCcNcgFAeRN3T20wd3uz706ZzsK+nx8xS4rUXHmxFv/TW+gVHgVu5vod4pGhs91HJB+b
         ZZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=TWs/pi13W9s3W1BKYFNV7ZvPA+qtn2fXWAaFncVNBc4=;
        b=KbnAghJFn96PllOTj8IT4XMBlElZ6Lwax67D1WC0ARfl5/VbbtrI/PYA5oNXn9JJ8T
         YWtusKGebIIGlLdQ34TX8N5+6iKngSIiwPLKLa87W1lgUbCgJu4dn/Uk1oxLzKxcKemq
         Gn8YpkKdEL9v3b6IDVg6ND45MqExGxf46JE4LZQURJk34cqIKCo7H/VeXtfYNn8tJ5c8
         iBkNO7IciV1rsz8J5ULs6RSAiLsKZ9yIvvs82dJEx6Io9ILduqR0oE29E0S1p95KVFXB
         B4zvru+qNxQgd7gU4O2I7Vlu0NrioLTU/c5CVOfebcZz9my6stT7Vt8tu9TBRQcrKjZt
         vmvw==
X-Gm-Message-State: AOAM5316PoK6DNU76X/xIJdl6VbkzZCQwsXioUYqz0rLOw9VSf61S1+b
        a3WW5pY9Tqu8MO/ivxpMzUnv0A==
X-Google-Smtp-Source: ABdhPJy7q/1xZcvfVJMi6L+HZwmnOXPzp77GcmF1iJM72OVwmKxFxaYTjzQtUQFdpbLTmrwsi3bseQ==
X-Received: by 2002:a62:15c3:: with SMTP id 186mr4589768pfv.59.1644328682188;
        Tue, 08 Feb 2022 05:58:02 -0800 (PST)
Received: from [192.168.1.116] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x33sm17673119pfh.178.2022.02.08.05.58.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Feb 2022 05:58:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>
Cc:     io-uring@vger.kernel.org, llvm@lists.linux.dev,
        Usama Arif <usama.arif@bytedance.com>,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>
In-Reply-To: <20220207162410.1013466-1-nathan@kernel.org>
References: <20220207162410.1013466-1-nathan@kernel.org>
Subject: Re: [PATCH] io_uring: Fix use of uninitialized ret in io_eventfd_register()
Message-Id: <164432868079.113641.15442485560114247466.b4-ty@kernel.dk>
Date:   Tue, 08 Feb 2022 06:58:00 -0700
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

On Mon, 7 Feb 2022 09:24:11 -0700, Nathan Chancellor wrote:
> Clang warns:
> 
>   fs/io_uring.c:9396:9: warning: variable 'ret' is uninitialized when used here [-Wuninitialized]
>           return ret;
>                  ^~~
>   fs/io_uring.c:9373:13: note: initialize the variable 'ret' to silence this warning
>           int fd, ret;
>                      ^
>                       = 0
>   1 warning generated.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Fix use of uninitialized ret in io_eventfd_register()
      commit: 4c65723081332607ca331072b0f8a90189e2e447

Best regards,
-- 
Jens Axboe


