Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23E00696A4B
	for <lists+io-uring@lfdr.de>; Tue, 14 Feb 2023 17:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbjBNQuE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 11:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbjBNQuC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 11:50:02 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63242CFF8
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 08:49:32 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id d16so6065537ioz.12
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 08:49:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wvRzbwHCCIyGJ/eexGCRoULjk4heOIKx1gbvLO47zBg=;
        b=rtr2tr2UiV/UwAcWFPmtgxqZBQ6ETxTwnub7kIwga7lZD/lbaGRAG8cpqu10cew5iw
         k4FEbnzbWyNMbj3kqtA03kxRRtiGb8E8Lg6K4diftTiXFrFk+sSvACBVy3srNOD911WW
         cbyAujPjNoR9r5aEHwgfu03osVxZTEBbAG80GXzqz68AEiTKe24Fc56+gPNsLP0/D2pr
         4uQmH/EzuTUFARzqmHzrIrHD96LjNWIAQwrUpkYJSCvuJYF1JLgk1K70+hmgQwYPy6gS
         2NFPwZXaateRz6iQGi2xgor6HLdeNIDY6Hm0tB1lJHX0NCe1IDOxzdFOzUYomEFzCeyC
         jBGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wvRzbwHCCIyGJ/eexGCRoULjk4heOIKx1gbvLO47zBg=;
        b=51EB0wp/LxhFoFisdu4XkIg0uChBcYkIpAQkOfwD5X4iOjjzgw0FIjX1lq4MwMHusy
         YrBTV5hMCsPx8cRJAroQa7bhxSDnlJrMsfysz3sNm7ybAhdlCznntYWLZucfH8fOA5+4
         GwW4mm3wFAD3sanjtbHc2ClvoTjS7ctvvdUOiASPziqqbpkg08SxDCnkQK6WRacicjlL
         pz+u1eA5QAxTqruQ0skWVvPB2gtKhyq7jcO3LzVuQQ80A218TYe8PfunKCpEkgrlPbu9
         LmRzvknN481Etq+zqM23+6fm8yP+RoIPK2KtSV3YGtHEcVpHYnoCDOGWxXrvfD1IDMco
         auqA==
X-Gm-Message-State: AO0yUKWAo72uYkeWk279RzsS6Zq/Y+5EO5zCgCYxF0OhC8aXaKHNIW3R
        xlvcZndVvnrukDQD8EIt/HfT3hpBGFAcZAa7
X-Google-Smtp-Source: AK7set+jsgVJBewLePjWvT9cJL4PpvU+8vGV62JR+wIxBoCemyyceFGgeUZZvltH7XYOltbeU4Lwrg==
X-Received: by 2002:a6b:7f03:0:b0:716:8f6a:f480 with SMTP id l3-20020a6b7f03000000b007168f6af480mr2294569ioq.0.1676393369387;
        Tue, 14 Feb 2023 08:49:29 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id p22-20020a6b8d16000000b007219624f89fsm5317001iod.11.2023.02.14.08.49.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 08:49:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Dwiky Rizky Ananditya <kyzsuki@gnuweeb.org>
In-Reply-To: <20230214164613.2844230-1-alviro.iskandar@gnuweeb.org>
References: <20230214164613.2844230-1-alviro.iskandar@gnuweeb.org>
Subject: Re: [PATCH] test/fsnotify: Skip fsnotify test if sys/fanotify.h
 not available
Message-Id: <167639336871.45205.17442199191224558297.b4-ty@kernel.dk>
Date:   Tue, 14 Feb 2023 09:49:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 14 Feb 2023 16:46:13 +0000, Alviro Iskandar Setiawan wrote:
> Fix build on Termux (Android). Most android devices don't have
> <sys/fanotify.h> on Termux. Skip the test if it's not available.
> 
> 

Applied, thanks!

[1/1] test/fsnotify: Skip fsnotify test if sys/fanotify.h not available
      commit: 2f4296d06878cf5f8abc75549cdabcb96e34d8fa

Best regards,
-- 
Jens Axboe



