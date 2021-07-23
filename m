Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195B43D4014
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 19:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhGWRTS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 13:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbhGWRTS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 13:19:18 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60221C061575
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id j21so3556327ioo.6
        for <io-uring@vger.kernel.org>; Fri, 23 Jul 2021 10:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ku2lRzPPr3/1tUMRfaXeeYqk+Gn1GfmJR8TkRXETJ+w=;
        b=JaazHHwtaOxVS/k1SF89Cjkakjbhn2jHUfbbShqRTxkGFs9OMtSh0mW2TEGUoZPgqp
         chlcdRx/r9gCblUzKCut1e6z0lFDQiy5KsRjvE3tih/fQPCmXH5A0pjAifeqh5fAsrUZ
         MEea1uf9PByX4nemScuHNqcXxTBQLcvoNxaRS1WpudQDNtwuy/sAsjvN0oF/bxsk0pgS
         TJThnBUnI27zJ366H7RPSDvVDs0G2EUlpJ+QF9sQL4vYgOqugDmEaQcaPq5xr49edd6S
         zkjdNV9/lZheJ6HHQpv2BA17syxwyGDJA/X1JKtPYqbKLZeloHMcYcaqi3M7KTNRbXj4
         55Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ku2lRzPPr3/1tUMRfaXeeYqk+Gn1GfmJR8TkRXETJ+w=;
        b=XMZoL0KyjLTD1jCox8BK6p57XRzeW2/Sufo5qjeKIH6SG51PY6HUNdTpECCRIyn7Id
         9cN15wyFpILQRf/vqirgK/Jm96bHDFBp4apg2fIkbVa69StKloTrk7DGsi4F4vO+geez
         wk3jxTJsDhNZ+/8+W5JH59aIBUvYgOHszvJnjm9TtNqAehUnNqIwTmSuL3Ffms25V+3w
         poIDng7QnLNz38eU5j5CfyxlSdAZVAyKlp13b/kRKtNhNEbAfxH19ck9IpM/qX1yHxkL
         SFtqit2w0oJDZua1vSpxwqj4JeJYKd/TZR8nJF1XesSx4f6VoeyOjgFRTiZj6qOF069E
         rQoA==
X-Gm-Message-State: AOAM532UqsD9yKEksA3KI5gY/i7K1fSX5qe9V+5uDuqeGGNcILwnWGQ/
        Hij5B7Cn2xXDjHyiKNJvxgkBqli6OuqHi9TJ
X-Google-Smtp-Source: ABdhPJxniG9NvuhWDdp1U6hpvHGVJVwnZj12tUpEBLU2JFHvlaHv/7eBaJ+HY/AjKamerFrvHTwXuQ==
X-Received: by 2002:a05:6638:130b:: with SMTP id r11mr5132495jad.79.1627063189513;
        Fri, 23 Jul 2021 10:59:49 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id u13sm17696533iot.29.2021.07.23.10.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 10:59:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     viro@zeniv.linux.org.uk
Subject: [PATCH 0/2] Harden async submit checks
Date:   Fri, 23 Jul 2021 11:59:43 -0600
Message-Id: <20210723175945.354481-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Patch 1 ensures that we don't resubmit from release, which doesn't
make sense for the reasons outlined in that patch. Patch 2 just adds
a proactive safety check in case we do add a bug that can cause that
to happen, as it might be problematic for those future cases if they
can happen for request types that won't naturally fail.

-- 
Jens Axboe


