Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5167EBA2
	for <lists+io-uring@lfdr.de>; Fri, 27 Jan 2023 17:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbjA0Qxx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Jan 2023 11:53:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232774AbjA0Qxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Jan 2023 11:53:52 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B39B1C5AA
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 08:53:37 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id r71so2146616iod.2
        for <io-uring@vger.kernel.org>; Fri, 27 Jan 2023 08:53:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eOH7xqvB/4Xfz5+u+39zFVrarxAxFEjWqbZdqWpGThA=;
        b=BUJhTiNSuGT0F1K3I6YeRH3BDovwxFdAmFAq43qmsz0AW5VuAgkDwPJ+AZB98M14Ut
         1PTy3w0iXa1uJiChKkhyDlhlkHxua/JSRHYAmlev5R4c9m9ytgHWb18XVoxqvhkq8aJB
         7aeloj1G4iJ93cLx+bxE8EAz5cmL47NmLMAJLTjp4gc+zfg1K0ys7YkgeK3YbgMrGxns
         +XokxiPTZVgA5nvbIAC813ZHHLRO3VebsumA3dBCUFsWgcfMEQwE5JvhXxX4Z46hWA8G
         hNgWgBmWREGlbUDPMEA74sfbYaGM1QT01VUXSR4N/Ao3Jbo82sCyudE41ZsJJUvWIaA0
         tdJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eOH7xqvB/4Xfz5+u+39zFVrarxAxFEjWqbZdqWpGThA=;
        b=mJeB0wsc3kQWrJQSch7FJG1P3xFS8R5rNCivhuXvM1ynUo6fqZYVrQuw0LNjZAcoTx
         VJCJqLJ2Qq9unz3iZnRo5pWbpXg9+YusDyxjAxED2DexQ4iFJ560UjqRxZJehyyD3CAq
         ITw32ecAZM8s0oGqQj+IxQpyYFovXQPlDB4KhwytcELkZKQmGnO/cjKelEAqgOqh8w7/
         MLRlGHNGPkXP1zMEsT9PdYoYma/jXPeVR9BufZoURFL/POo8HaNa7LDWiwHBuZd4Bxf8
         WUtnZdNXfvgDSnG551+XEc8nuJlkUyWpmQ1FxKoIRRPQ0f17CnQiqXh/zb6AK3zwqa+8
         ZKhQ==
X-Gm-Message-State: AFqh2kpnEsIG27CBy4muyUCe4s738F3I8NACJX8vpLIeeh8e3q1DkoEW
        V9+sAezF2Kgk5dX43CnIpWTN6KiTPkQXTY7Y
X-Google-Smtp-Source: AMrXdXvLkc0+6slGKaUR0Un7aLVoB2HQHzXqNfvNU2AORcwWQKS9/BbyFvCm+5wL6ahYtpnE5eXnYA==
X-Received: by 2002:a6b:8fcd:0:b0:704:d16d:4a59 with SMTP id r196-20020a6b8fcd000000b00704d16d4a59mr6164040iod.2.1674838415904;
        Fri, 27 Jan 2023 08:53:35 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u4-20020a02cb84000000b0039db6cffcbasm1620587jap.71.2023.01.27.08.53.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 08:53:35 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCH for-next 0/2] Fixes for CONFIG_PREEMPT_NONE
Date:   Fri, 27 Jan 2023 09:53:30 -0700
Message-Id: <20230127165332.71970-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.0
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

Just a few minor fixes for CONFIG_PREEMPT_NONE, where we a) either need
to reschedule (IOPOLL), or b) should reschedule if we're looping for a
potentially long time.

-- 
Jens Axboe


