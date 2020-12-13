Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20E92D90A0
	for <lists+io-uring@lfdr.de>; Sun, 13 Dec 2020 21:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgLMUoa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 15:44:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405992AbgLMUoa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 15:44:30 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051DDC0613D3
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:43:49 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 3so13447130wmg.4
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p5W8xooiatgG0d3Tr1+XcSMxrzUNwcfZJE9maGUqkas=;
        b=Y5LJdFHw2NGBL5DC1sDNQaO2tSrVTKmiNQ2HsyktUrySyDc0E0J7qEMACfha6ppfhq
         9jrLnsOnNisd5maT1AsOgzZ1sCwsx1I8xeS6dtruHTydAO5DKDYZJ3fVsdIFQuHc+5gs
         9n/cxhSwiNsP+lr7oZqu1D0Mgzk716zDCH4k7gwIyy5cV8v6r2a7WhAfiWAPs73zKYC8
         zC1XszhFY98F/jzx+9RfWylNFzD7PGOdQyJS0+TyuckZw8YFcVftFXGuIwoe8cWpQ0Hb
         r31Z0XWBjGMAFy9gnfZKIIYOjDlH3c9R5tC9lSKRLGh3wiJwPQAgqQuz5tvfY+g7aUCL
         3UdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p5W8xooiatgG0d3Tr1+XcSMxrzUNwcfZJE9maGUqkas=;
        b=CmVJLY4Gkn8coKGCuTpuXWk1z2b4L7ULvIT9iULDke1OxfgUiWGgw0EkgyOnD6k+CO
         nZsISc1YbRkDO6zdqGv0thKEX3HEMYoOMBo1nh/IHcvEdHil9M8c85v8APFZeFER9Zdz
         dUoBkeeYGA2ChB5dZ3TAHdezkFLP5ld936NrisQRqsiWnhMFBSfoVUNaAA9yiUsq1iRE
         ed0UgHQroUztzaXhU3oLI+nuxvZXUmltZmaUAkwWIuQnTZtE7cfrKrTdGr8V5JfMKV1H
         28ZGo5xfyQ6mzsFbs0Gr4rZ5DtI47wp+W71Gcprz0kOr6t0T7bbOGh/7YvVVCkPk6akx
         rYEg==
X-Gm-Message-State: AOAM532rxiZxcP30H+qgI3h7Y6t3x6n8ChwzflSm1cmzdYOqoIwG4YrO
        Zk6rF/G18lymi9ia4fYFPF9GIM+vOXOqMb7VFDM=
X-Google-Smtp-Source: ABdhPJwkchOsRlgjpgEHs0MEMrcAMB4zJFwvCHRanpokwC57wbph1fxSIVGNd6CX+QovfmfvUMf8ag==
X-Received: by 2002:a1c:2c83:: with SMTP id s125mr24569174wms.161.1607892228461;
        Sun, 13 Dec 2020 12:43:48 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id 34sm28264885wrh.78.2020.12.13.12.43.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Dec 2020 12:43:47 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com,
        netdev@vger.kernel.org, jannh@google.com
Subject: [PATCH v3] Allow UDP cmsghdrs through io_uring
Date:   Sun, 13 Dec 2020 20:43:38 +0000
Message-Id: <20201213204339.24445-1-v@nametag.social>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

here we go, figured it out. sorry about that.

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


