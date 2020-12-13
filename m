Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2782D9090
	for <lists+io-uring@lfdr.de>; Sun, 13 Dec 2020 21:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405788AbgLMUcG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 15:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405720AbgLMUcD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 15:32:03 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13F61C0613D6
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:31:22 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id x22so11958039wmc.5
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4OMLeTnocdXkI8S1wmdugEs/trA543kWe7Ll9FnoZ8=;
        b=oi32MlQnEBognFuSVEvUOWLn8/5t46nK5cLcC3NKoU0vacHYlH0rJ2yQHrsIKoGx89
         LRvvIsHM3WFkikNszs+H2Pp43v1A/3tW4aPC5SIYWGA5oeTCI5TqVCfTx7hnuIzLCVLl
         C6/RnhcfNQD6Vcc1v74PVH1yus0PKYsbkGCAP+NWEDIJisNB5WF0JRy43B6gHTzlxPVB
         8b4Q7Sg/SI3nZ7ji/CFOH/YKtlmfCzJ+5W0oKfb+3Ko19qkDgoguOs+pgVx2kO0i9cq1
         EsVllruy7n8C9KCKE1upz4weZyJZ7ZuzvlT7S//qEpCDdIYerYAjToT3/fvDoQkb+LRq
         5YQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4OMLeTnocdXkI8S1wmdugEs/trA543kWe7Ll9FnoZ8=;
        b=pLgv/EqgkzKX1tfCPRXDlFIIz+KjTnVah0uSueWJQMdioculgR2g2JVoKxhhefcjp0
         kHAEX3kf++IwtQSdV2bgFYJ76MozL/fGYg/eUgjKjpERQPn5vIVhwCPb8kTVSyGMp9D8
         qKWz8tgt7kkZJ2aKPnI+HcWqmcQWtp6iM0NdAgHWY0sXKXy8h4/oxejimmkf+VebCMep
         G5VBhAYNmhpcRw3CgGoEQamFd1FSgHAhE3ZvUG9jl14ZJ3qINJc+8UC7UXwqbxEIcVYp
         hmoJ8oqDG6gVvlMUJSlSS1TJP6rTwSiHdp3T2Rz2ANgFAsyExQHLzP/sapP9vofsKppd
         Gt2w==
X-Gm-Message-State: AOAM533Z/f7JFkrpwbFjX7OGh5PFoADEwYRNPFjlteyphZ+kYN5XGZ5A
        8dbTBrvucVgTX+gBcey+QyR4SRHqXaHcGNgToNQ=
X-Google-Smtp-Source: ABdhPJxapBfQbcPIAuuVmUj2G1a0lqHl44TltIPyOy+DY4fhNIkQ5K+SSRiDnIsIW7ABFbVtXqQekg==
X-Received: by 2002:a1c:e1c6:: with SMTP id y189mr23829994wmg.172.1607891480604;
        Sun, 13 Dec 2020 12:31:20 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id j13sm27055007wmi.36.2020.12.13.12.31.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Dec 2020 12:31:20 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com,
        netdev@vger.kernel.org, jannh@google.com
Subject: [PATCH v2] Allow UDP cmsghdrs through io_uring
Date:   Sun, 13 Dec 2020 20:31:11 +0000
Message-Id: <20201213203112.24152-1-v@nametag.social>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch adds PROTO_CMSG_DATA_ONLY to inet_dgram_ops and inet6_dgram_ops so that UDP_SEGMENT (GSO) and UDP_GRO can be used through io_uring.

GSO and GRO are vital to bring QUIC servers on par with TCP throughputs, and together offer a higher
throughput gain than io_uring alone (rate of data transit
considering), thus io_uring is presently the lesser performance choice.

RE http://vger.kernel.org/lpc_net2018_talks/willemdebruijn-lpc2018-udpgso-paper-DRAFT-1.pdf,
GSO is about +~63% and GRO +~82%.

this patch closes that loophole. 

net/ipv4/af_inet.c  | 1 +
net/ipv6/af_inet6.c | 1 +
net/socket.c        | 8 +++++---
3 files changed, 7 insertions(+), 3 deletions(-)


