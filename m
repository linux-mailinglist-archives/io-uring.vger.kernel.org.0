Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876174240D3
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 17:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238996AbhJFPJb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 11:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbhJFPJa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 11:09:30 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2448C061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 08:07:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id v17so9788938wrv.9
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 08:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ArDKphYLncu5kQS5MdPe5wjpx2gWHjWPQka5LLSiB+g=;
        b=Wt3jkqhnagW5zpxL2gf/ImdA1eWfy9SgrGXJHQszSCwuPIt93totn2XXAtZDrMz3K+
         y0Un+yPm7zvQBlWekKcn+Pd9NEk4pUzOOYMltB96ECl04PIzlbtundZ3InRHPantlH3d
         JELWbmAexK/pVCC6twLOE9LkKb2v01/kzEb+AOu4qyVIOmKlpJX67YUlJGJSmYwS6BZJ
         cldXchQ4X/9bNHmUutY0ZHA5As20L3Tcw8NM4A5j/xFv/RElWJysHL3042YFMMYrxkkL
         DmJIiXxTW0yJcsJqsMIcg8HNwI5Q4yW2ILRGLXpNqsMi/7qbRWAzx4LJCt1pVSPzZL1J
         H0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ArDKphYLncu5kQS5MdPe5wjpx2gWHjWPQka5LLSiB+g=;
        b=06IMXNrRqtRggfrvqkJuLOSE93iBMAjlOIIreUg8OOAkRlWvFOCIyeXeZdWIB2FQ6b
         H1njrtC/8KTWIi+ZsaiehKaFkpqsU5LdKZ7sOGyrZBfvmCMAHdb6YIUPHwV3jjVDjnNX
         9Eum14Bpr7ZUm1Be4tCyYflWvaZ+eqLyuFgCBZ7dKFCGymvLpRyGYJU0iHlG2zY38iIP
         WVp2TNjv4T5jWE5VRYLyRH9H9qMtZmsnijFhpIiFlbJxGGyvxQ3xLvxirrckOxhGSfAg
         rw6TNNjwM8qZ5LVdqg+hIp2+bbY7B3gojmGS788Ct3b49L4F4sjKiiMNa4DEdbeO3TaN
         Kxdw==
X-Gm-Message-State: AOAM531Z7gh8DITgZXJ/Gmpg54CqdlSvCJyZaM89ch27JFS6wiyBbqZW
        Enmek3UiOdKWP/YXHD6aklSEiwIcubM=
X-Google-Smtp-Source: ABdhPJyk/iKH6+IFkhX7XEoVGR0+cyoxZEJa2s8ot9zsKJUBX5VpdKV28RvJ1tKvUeZ85GWsecVUBQ==
X-Received: by 2002:a7b:c18b:: with SMTP id y11mr10739711wmi.62.1633532856229;
        Wed, 06 Oct 2021 08:07:36 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id o7sm24678368wro.45.2021.10.06.08.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 08:07:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/5] bunch of random cleanup for-next
Date:   Wed,  6 Oct 2021 16:06:45 +0100
Message-Id: <cover.1633532552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Mix of small optimisations and some additions for safety

Pavel Begunkov (5):
  io_uring: optimise plugging
  io_uring: safer fallback_work free
  io_uring: reshuffle io_submit_state bits
  io_uring: optimise out req->opcode reloading
  io_uring: remove extra io_ring_exit_work wake up

 fs/io_uring.c | 72 +++++++++++++++++++++++++--------------------------
 1 file changed, 35 insertions(+), 37 deletions(-)

-- 
2.33.0

