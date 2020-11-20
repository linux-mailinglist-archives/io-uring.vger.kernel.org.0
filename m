Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41A22BAF5A
	for <lists+io-uring@lfdr.de>; Fri, 20 Nov 2020 16:54:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729562AbgKTPyJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Nov 2020 10:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbgKTPyJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Nov 2020 10:54:09 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9B2C0613CF
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 07:54:08 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id 7so13558426ejm.0
        for <io-uring@vger.kernel.org>; Fri, 20 Nov 2020 07:54:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NWLFMpmpk16byrG9tVX1RSfHASoGJ955HOnaql6R3uw=;
        b=YGUUaaS7Mdb1ubsSnWk5geOhwWhkAS1hYPsAeavjiWVLEYk3r52KCaq2OxF+kIT7rH
         OXwwnZ/3xrXZZEjE+LAK53eCWuipUTNQyM/6X4yGUxVRB9fvhMZ5Oa2FzyTByQkZM932
         MSiH0J6i9TnHsouywhu8R60bbZgbPo3q/nu8AzkGlQaZCfEzTjqMiWrULDZWBD+lEDWT
         iL1a+jL1pBFAhOvcuJ2iBio6zfAZpK+KSQYnseGlZ1YC0O6tdvEJisuGdVV7G5QoH02B
         nJH2KRpWWBLpzJqllMdPtEwqfQAbRCf2ZcC1BcIBjaJqoWH9JnUwYcUnkKVcbXnCZGht
         WSzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NWLFMpmpk16byrG9tVX1RSfHASoGJ955HOnaql6R3uw=;
        b=CPZaNpLmSA/jkjoE4oeKP5iwRTpYADNkklHsPv3ZDlkOT5msC3+4AFD96P5+UVRaUy
         jFy1iWavPN3KNVwvgmLoNdmG0BcjVN/I5YfW+7ku/2V5gOnJ1G/St537DMFXpNadybyE
         ZDRXj32sqpcWMmmPoIbfKXQzg+1mJfyGO4XUYdVPGfOa63ovyhFLKv4rSdgEv/gvkcGM
         PQ/MJUNQOiNf/kmWVkARcFcR9QUIbTQSW/DYGbxdboZyxvNXpIDNcITasooHunFlkd/z
         0/wctvuQ0ygfjnHQHTMGYm1bO/GrAqu202QjWWODlNaxgpiqzdGCUr32Xejwa3fHD5cp
         YQAw==
X-Gm-Message-State: AOAM533UgHhdQaA30OwGFuigF5Z4UZvOh3vs7Ib/PBxH9hv8B7MIn6Jv
        N7X8uhlYjaERyg13+JJiPG98U+IEDOQXdQ==
X-Google-Smtp-Source: ABdhPJzFlLyGHCX0kAVe3iMW3jB0cZKrg8bk7UJSofS7tnR3cMyypT5imBVZN0WklY5UlOToi03MEg==
X-Received: by 2002:a17:906:17d0:: with SMTP id u16mr2713416eje.452.1605887646861;
        Fri, 20 Nov 2020 07:54:06 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id y24sm1253956edt.15.2020.11.20.07.54.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2020 07:54:06 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.11 0/2] submission cleanups
Date:   Fri, 20 Nov 2020 15:50:49 +0000
Message-Id: <cover.1605886827.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

2 small patches cleaning up io_req_init() and file related submit_state.

Pavel Begunkov (2):
  io_uring: change submit file state invariant
  io_uring: fix miscounting ios_left

 fs/io_uring.c | 42 +++++++++++++++++++-----------------------
 1 file changed, 19 insertions(+), 23 deletions(-)

-- 
2.24.0

