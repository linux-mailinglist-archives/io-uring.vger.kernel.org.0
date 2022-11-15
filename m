Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CF562AF45
	for <lists+io-uring@lfdr.de>; Wed, 16 Nov 2022 00:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbiKOXPO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Nov 2022 18:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229826AbiKOXOw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Nov 2022 18:14:52 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF576160
        for <io-uring@vger.kernel.org>; Tue, 15 Nov 2022 15:14:51 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id w23so8370677ply.12
        for <io-uring@vger.kernel.org>; Tue, 15 Nov 2022 15:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXteisCHfC2Jumrw0QvvayC/9D0lzkigAdFvBDLcATY=;
        b=TAP0ZPmLYjiS8S4IxBaVRNgvn+VUdzCoHzzZErXsb4OpAFvPvrE0pr0QNqVfcoweNm
         QPoVZjQVtsQFgcR1xUtl2IdFIvrni1wTZW56xQUBDAo4sxk8BMLk67DuBNpT3tykon41
         UGNyiZjKWl0Da1Ghcw5okzrac1hx8Uf6uzzjZFtlL1heepoezJZ/VTW642ALYUh1vRTp
         oOFueBcfiQoSkxVXKZgrFqu5dglDsFHR0LrGCbj1c85eOh8cGNVsVIKRGA8GaZTcUYHN
         9rmwrxn5xz4IUArMorT1tjvAzmvYxT5QDBSivVqLHqDXL89M81kRmtRH5gq8jl4lge5e
         1UOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXteisCHfC2Jumrw0QvvayC/9D0lzkigAdFvBDLcATY=;
        b=4UwOwftoPprXtrEeSPxWZo+/j/kV6chGvcbl3xl7fYme0DBpNd+HWOjPsC1/vNTO1V
         OjC7nIB3VoFcNkZr9n61J0pViAc+c7ektSqdwtKi259WeCSuazkgpNEELFQpHBYA60yS
         wdNd0wI7cMM5iZX/R382uKFIkxPGgsOaJPlhWynPHMTn2+Xw+DXUUrUbiYgRWTC2VNwQ
         KC4hMacSKW8pAh2L28pcBs3dVFBDIkS0GKP0aoiuNnZ7xS7D2md77Zjiwa6T9SKBEoy5
         99sKH7zV9Qwf9EIzQA4ZA7zAeoEoMuRIWDYTWrQ9xjae1YJxagyQBLuGjedtfTBD1D9v
         cBRQ==
X-Gm-Message-State: ANoB5pkBNsUNy8KuigGorBTsVlK4TZsjubSE0a11ItXkVB4Dl7bc3l7H
        L84BOl2og4OAbsB51BSwHNPFbQZhH9tBag==
X-Google-Smtp-Source: AA0mqf7wU9j2Lqlq2FWr3yJ/1dcSF+lcDwpBE242qiy8AiCfTME1tF0OWckzDdpyHCfq1+0cQQj5Ew==
X-Received: by 2002:a17:90a:990d:b0:212:d909:a41e with SMTP id b13-20020a17090a990d00b00212d909a41emr723629pjp.48.1668554090893;
        Tue, 15 Nov 2022 15:14:50 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id h13-20020a170902f54d00b0017f7c4e2604sm10501404plf.296.2022.11.15.15.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 15:14:50 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20221115212614.1308132-1-ammar.faizi@intel.com>
References: <20221115212614.1308132-1-ammar.faizi@intel.com>
Subject: Re: (subset) [PATCH v1 0/2] io_uring uapi updates
Message-Id: <166855408973.7702.1716032255757220554.b4-ty@kernel.dk>
Date:   Tue, 15 Nov 2022 16:14:49 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-28747
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 16 Nov 2022 04:29:51 +0700, Ammar Faizi wrote:
> From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
> 
> Hi Jens,
> 
> io_uring uapi updates:
> 
> 1) Don't force linux/time_types.h for userspace. Linux's io_uring.h is
>    synced 1:1 into liburing's io_uring.h. liburing has a configure
>    check to detect the need for linux/time_types.h (Stefan).
> 
> [...]

Applied, thanks!

[1/2] io_uring: uapi: Don't force linux/time_types.h for userspace
      commit: 958bfdd734b6074ba88ee3abc69d0053e26b7b9c

Best regards,
-- 
Jens Axboe


