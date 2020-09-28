Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3BE027AD3F
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 13:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgI1Lwl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 07:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgI1Lwk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 07:52:40 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A16AC061755
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 04:52:40 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k18so823793wmj.5
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 04:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+cR8stXtwIS9PcL5iHKjEUX9KOekIx8A2XVD3lACK40=;
        b=rhpfK4Xfe+sa0ypECy0qohZ4DnxOkH7KnUrkwxxU7KLWNSVAeBKwwVMop0zDaeVXX7
         IiFTXq5evBgjlk60lAPKhndrDxfw+Rgw2tSBRh4zl+hab0YADh8sOWtTHWWMKTwkRV06
         yBVp8twoJGeaRXudW85t+XLd199zwy1ELqM0MqZ637rR303zYf4jKE0TO1TO8G2/mh47
         bdDU9C1qugJ0AZUX6+kNHG0pgMwLWR9p3F2YJG+Sjo4cfYaGVNnSxRlvEQ9hls53W2dB
         xE4uah/QZY/gt7wD1qdWk645s9hsdX00Ch7UAGpDNl7xvaAmdoYcywdyqnNd9ySnwg2i
         6Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+cR8stXtwIS9PcL5iHKjEUX9KOekIx8A2XVD3lACK40=;
        b=Ikps7oSw4XaFiLSamClY9MiddbeJsms5VI7t6/dE8R1gymmtFQwNXNbTD5ZB1xVLbt
         Rub5sBNn2zZFM2IQ1zBRS1yavmsgqRAqG5eFXOspf/81B90gXMJOG9WxiCekJCPtUUFM
         SR0pA99hR0/apZrB/hhkwxj1sIysQ2EGyGWZeqpxv1bDmTUO2hIUQjdCwzzlBEX/HnzF
         +on2yZzwNwEtdUZheq0Oy/w81tX0k/9HuSsZf9mtv0NGgj4p8P7eZzc2mG2VauLxTeWZ
         i5BKeTYKBUGolm6dIC6Cv8a8ObM4zDID/6J0pPzY5nO9EV4B4MrB2iTmL72hxzNnseXZ
         5xug==
X-Gm-Message-State: AOAM5336mlKZy8fkPZiaRzG/dKIFRbxk3TroT5L21HWlDDNcZKDcYyK4
        qF2850q6m+eBFiuqUbUCUfv/oTlY4pU=
X-Google-Smtp-Source: ABdhPJzqNRolvg+B4szyDknerqchQsqAnOsO/XdpIUfsQgFjp6NBAmP10EhwnaDyS5YiKpcD3/lRzg==
X-Received: by 2002:a1c:408a:: with SMTP id n132mr1172991wma.45.1601293958969;
        Mon, 28 Sep 2020 04:52:38 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-140.range109-152.btcentralplus.com. [109.152.100.140])
        by smtp.gmail.com with ESMTPSA id l4sm1275282wrc.14.2020.09.28.04.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 04:52:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/2] ->flush() fixes
Date:   Mon, 28 Sep 2020 14:49:48 +0300
Message-Id: <cover.1601293611.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It might fix flush() problems reported by syzkaller, but I haven't
verified it. Jens, please tell if there was a good reason to have
io_sq_thread_stop() in io_uring_flush().

Pavel Begunkov (2):
  io_uring: fix use-after-free ->files
  io_uring: fix unsynchronised removal of sq_data

 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

-- 
2.24.0

