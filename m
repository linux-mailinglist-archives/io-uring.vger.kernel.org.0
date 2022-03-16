Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9174DBAD0
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 00:04:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235337AbiCPXFV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 19:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiCPXFU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 19:05:20 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C964113CD5
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 16:04:04 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id i11so2320054plr.1
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 16:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sR0Nc68zrFe+UDGv4ECoTG/8iib9RckqR6uqcI2uIxc=;
        b=U9HAJVddMOXwVyMRr73Kzq5ktl7XdjjBS8YAdRJmwPRtkmaWG0Xj8fc1Vd7ocWhlUO
         w4sKI4agOmYNEKpWeTcr5Kkv5zK0JqzM25CV0mQylbRyH8VaXH1G7+E8s5ZEZLKFyZ90
         COR3pLVCnKbHzLD28I9TNtdedufKgi+K6mjDw8Rl+49gpXuT8Pa+xx6yaWmKau39k5bG
         7rI7Dg4wV33dAqvoaxS7Wio8jU6Gf1c/iAf1Oc3ZiDyA7b1dEvb0wgVh2BN2Z/Wmane4
         Ub7bmtpJmj9wCc4Fbxwp3VMBaNTcnilMUFK6sYeHb0yl6YwDbs9JbM4yYqWXDj/qm5XU
         eugw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sR0Nc68zrFe+UDGv4ECoTG/8iib9RckqR6uqcI2uIxc=;
        b=YlsSCWTDoWWUwEvIHb1njNV4tgOf/rme7WthbVHWhB4Z91bgH9PeljziIH4OqylFBD
         4I//oz1OlPyg7qgXUcUe7MZmhhtZiD901rr0gG7nTZVIXQenO1oeEgUVeb16FRiP1NCx
         6tsi/a8Wbl/hcfnOV18XRmEHKdCDoEKqHOU45S9YZT3/Jz9+dL/ObPrLhweiayQXYNgV
         Zk+ZJ4SsuWiC6iDPOyqAkMG9eVdkZzNSqu7WEAlLmYxQmm+c1iraPbHkOJVTuPNwOSJ9
         k7c1hgPKQ6h/NrgJpCl9BE1u8rZh4qbMTTo7K7dN+rchlFQuZ709YQkCuPt+SpF6Qb+R
         +geg==
X-Gm-Message-State: AOAM533hw+MXt8JuUyzLUG3PKE053iPgN4JB3zB175z+yKytaxI65q7+
        GcxL/ZcbedVyhSujl1HhuowrHJrLXLqoWhVO
X-Google-Smtp-Source: ABdhPJzml2qB5BAwff0JkqijfPpzuZI3KdWd+vn1MKYlwCIJWomc1UzoSBK6BTgUVfwhgjXGhC40Fg==
X-Received: by 2002:a17:902:e5ca:b0:152:54c1:f87f with SMTP id u10-20020a170902e5ca00b0015254c1f87fmr2126715plf.59.1647471843835;
        Wed, 16 Mar 2022 16:04:03 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q17-20020aa79831000000b004f769d0c323sm4538351pfl.100.2022.03.16.16.04.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 16:04:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Reduce poll based overhead
Date:   Wed, 16 Mar 2022 17:03:53 -0600
Message-Id: <20220316230355.300656-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Networked workloads are intensive on the poll arming side, as most
receive operations will be triggered async by poll. For that kind
of poll triggering, we have allocated req->apoll dynamically and
that serves as our poll entry. This means that the poll->events
and poll->head are not part of the io_kiocb cachelines, and hence
often not hot in the completion path. When profiling workloads,
io_poll_check_events() shows up as hotter than it should be, exactly
because we have to pull in this cacheline separately.

Cache state in the io_kiocb itself instead, which avoids pulling
in unnecessary data in the poll task_work path. This reduces overhead
by about 3-4%.

-- 
Jens Axboe


