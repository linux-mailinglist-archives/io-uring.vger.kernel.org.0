Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12E0450CCA8
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236637AbiDWRmM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:42:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiDWRmM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:42:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108751C82C8
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:15 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id k4so6223721plk.7
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cBDOnD6PE89fA5NB0k+XIgLS3kV4y38p84ECag9wjkE=;
        b=e8mVRFvIguy7s6IlYWL2KBtTIDqJ5IAKfe1Jfw5QQuQXpnwzh27dHAda9sV2ODK5TC
         EECeVMi76x8JmWokEoAj4sUp7pAIR0o06xaeE/BZPRXDI/NmoM8hMLxI9KcclR8hlQ1Q
         6HpGzMIx0Nv0OZgfgTm+DJE09QkMuCTu2K0iM2vdC7QlibiFjKqHhD1/Ra6E+Sapfl4n
         RG4he2C2OIilYCQm2/UeOpTELB4fOYu54U9WVRrIUsxpuKUWS9YfeRkcKBAqh47Vf0mV
         /GUwUrD1w8pOV9VAC//jikIlLZNNju7yHvb1/8vcRBXEvhfJy6ElK/MIed3md5vgpQ+V
         K9Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cBDOnD6PE89fA5NB0k+XIgLS3kV4y38p84ECag9wjkE=;
        b=6BGVkDAI6kEXHfDWmm8W3N/79/d4SiPGaIPLlhBbSB8geaEYsBVHRmJa5P8gZEKX25
         3xbBHaZ91kVqysfQXdcrPPYM3W5RuNTHwDwXSKZAfjPQI5vc8ih3sK/++hC2RvsJe4eb
         qQ3QOLPNkEs+GLPJ4Y57vJWGFs/YDZUwU9hOD9pQzicqlBBahGbcIoYCy8+PS56q9QOR
         b6v6EXLvnc7bcbJgGVZh+zkw38oGmoUvg8GYjra9c1G0SwgbY0sNM+zIOAI/zdoReMaF
         fYg8lIHlgVRUDKVftAZvcrsxoka0myKW5OXbvPCQ3ir5aWF4Yv51SrTzKfosBIt4GPaq
         Almg==
X-Gm-Message-State: AOAM533od6LlEnNeSIaF+nKSeTreM4AV3WwbQZuscbg7VP8xPEb4BkHw
        yRyMQHnNy1kHU9/AYOf2z1iTJW3qE2smHG1R
X-Google-Smtp-Source: ABdhPJxS+VuYZs1eSVfrFbFmVOTqbtSM3cKOJp3LFF0ulVFM8aRbbpLpzNvdUZ0+S937K83tAn+OZA==
X-Received: by 2002:a17:902:f64c:b0:156:4349:7e9b with SMTP id m12-20020a170902f64c00b0015643497e9bmr10444461plg.139.1650735554313;
        Sat, 23 Apr 2022 10:39:14 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e16-20020a63ee10000000b0039d1c7e80bcsm5198854pgi.75.2022.04.23.10.39.13
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 10:39:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET v2 next 0/5] Add support for non-IPI task_work
Date:   Sat, 23 Apr 2022 11:39:06 -0600
Message-Id: <20220423173911.651905-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Unless we're using SQPOLL, any task_work queue will result in an IPI
to the target task unless it's running in the kernel already. This isn't
always needed, particularly not for the common case of not sharing the
ring. In certain workloads, this can provide a 5-10% improvement. Some
of this is due the cost of the IPI, and some from needlessly
interrupting the target task when the work could just get run when
completions are being waited for.

Patches 1..4 are prep patches, patch 5 is the actual change.

v2:
- Switch sq_flags to atomic_t and use atomic bitop helpers rather than
  add helpers using try_cmpxchg() for setting/clearing of flags.
  Suggested by Pavel.

-- 
Jens Axboe


