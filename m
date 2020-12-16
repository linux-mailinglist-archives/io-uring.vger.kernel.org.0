Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79D4A2DC5DC
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 19:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgLPSEF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 13:04:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728969AbgLPSEF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 13:04:05 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB32FC0617A7
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 10:03:19 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id a3so3297580wmb.5
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 10:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4OMLeTnocdXkI8S1wmdugEs/trA543kWe7Ll9FnoZ8=;
        b=Oesy3tqtvt7immDHLptaeAdp9pvH+gEeg/lzRxdkL8kyuARC4gKkORFWbhQCNdlH8s
         +qxMb+ekzDMbfWAuTbofEneEaeIRz0cn/k5U/cYdK1ZIsq4KO3VzCu7TWba/c/4bZ/Tc
         MnDdK0vPmuXaiwimW9/RsPTWKk/Xzipv+LFF4LLJabfpnC4lez/oaUW2tAMXfrXvk5Xr
         dg20KK4BfOgEmFkz6RIXtSipftI/ngdez23arIz9SsSMHe6HXtJ112hPn1FEi4eh8e+s
         iIh+NnCQ+EY3NHQeS7mr+MLn+in89Kqvii5vnopCDA62zTowy9uNrxOcJfx3SvQZH2Vg
         okmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4OMLeTnocdXkI8S1wmdugEs/trA543kWe7Ll9FnoZ8=;
        b=ThlXtpujGc+icXMqvcbsmqpLVIjzrfAZiJLuxnTcyaQ1ql8DChPz4fDtOew3isSh2n
         JJ0hl2WTfrupU1tC7ME0dJ4MkkhWW9Hf1SYpw+K+T3wH7qXrXg0DGdLOGIJdGm/izWtZ
         O4xPbUTrjIMM3bjYF6wOSzjWBRMiPpTxhQd8MzJwRge24tGZgR2dxU7Hers24ymr6pXt
         U5g7gJEBTAIrE3dx6elXCwcLfBwXXgm7gYfO205R2rTgckgTlaoAxkaLcT0NpshjTp4z
         Ur/LekW4+tR9GXy3Bw+f8wXtUkkcQ1wNBSJKq3Ov5ZCrxAhghGF0Fc9yqB4bWBxqOKVG
         xcCg==
X-Gm-Message-State: AOAM531sINhAVBPWoqWKmh00aX19Z7Ig9n2KEvV+GGkdYgAIzFS6VLTw
        78D61vnxbKBPIyT1Log79IL8YrVbJsJiGdfx
X-Google-Smtp-Source: ABdhPJwFS7otTErfVHRnJroj7nAGGBjz+wlnxOVh/0z0wnZYpTYkaMm+sbRwc75l4uZwunuVvlNf1A==
X-Received: by 2002:a1c:f406:: with SMTP id z6mr4556950wma.123.1608141796583;
        Wed, 16 Dec 2020 10:03:16 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id b13sm4311281wrt.31.2020.12.16.10.03.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Dec 2020 10:03:15 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com, netdev@vger.kernel.org
Subject: [PATCH net-next v4] udp:allow UDP cmsghdrs through io_uring 
Date:   Wed, 16 Dec 2020 18:03:12 +0000
Message-Id: <20201216180313.46610-1-v@nametag.social>
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


