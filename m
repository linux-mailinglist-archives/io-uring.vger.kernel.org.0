Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18A2C2961D7
	for <lists+io-uring@lfdr.de>; Thu, 22 Oct 2020 17:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368713AbgJVPqQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Oct 2020 11:46:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368712AbgJVPqQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Oct 2020 11:46:16 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC9FC0613CE
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id i1so3041034wro.1
        for <io-uring@vger.kernel.org>; Thu, 22 Oct 2020 08:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kyKh0+aivw665GDrfHhPk3SR2NvF52liFKQfGMEmB9g=;
        b=mH1iuKyo7loIRx8q4FKbhy4TtWEWceUnQwgEt7yEgXqSMsqoqKiTfrrMGKcyl2/dC3
         ReDKR7Oj+uin9DZSrhefBwvnFYJQa7fYQ/xRDNm5nFDrnbdqjsCos1JP0bPbFVGiKu9Y
         Bkk7hK3U/loyYU5zPXHP27reeIUSB6mkj7gkV2Lavtl2fT65kJsW063CwaFUXy8XMq2g
         p1OG6qr+cgnMp2xzACi6fWXcs4AxoFRR2y9MZfZMexnyn2yj1JiQIAr8LNsagVVKGhV4
         dufzMT2iNLfY7L0larYkGXwaD7L4vapRcGwfRMYhcJ6lHwoaPqtLerxpBzdknSExq/v4
         VU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kyKh0+aivw665GDrfHhPk3SR2NvF52liFKQfGMEmB9g=;
        b=m0MIif99TDMdmXGRMGbKJEQamJ0OTWrcjdg3OTGbw2ht04krlCcIxWLzZE8Q0Y1+6o
         EFmiHanM6TJjahZXlBt+JzHNRzQrKpeFa91bRCTUI+qUHmQcWnXlanfNb2ZiJN2eCh4C
         OZJLvTBZVFNY1U5pIEXqt0mmYto9pd0cWYjA2LuARaMpfzVuylumISAopjh02t+1pZAt
         zrsK5PbX1R1NczZyE9Vk7OdF0wuJnFfggtlq45eH89p64gzdZY0Oi+TlqvuP4YkaLqBb
         R/18Ds3Z/6v4XZe2WJ/I5JY/JIRlYe1Sk6crg2vBd/d6mEeSGWvUM+U3ZIy1iA1BgLpa
         SfSg==
X-Gm-Message-State: AOAM530b0r7hsKwwtrF1vPtjWyakwnu5PoYRbsz1OS2YXVoh1vaPSNou
        tg5nPsGogz+T+0HknrPnGVA=
X-Google-Smtp-Source: ABdhPJwhn7KXbB78fPSmgvP4z+AeqyWjEQCb/QNigEFXW14geolZWKybQhagdqt/fw5Hwjmd8zh/Qg==
X-Received: by 2002:a5d:5482:: with SMTP id h2mr3367189wrv.165.1603381574297;
        Thu, 22 Oct 2020 08:46:14 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-164.range109-152.btcentralplus.com. [109.152.100.164])
        by smtp.gmail.com with ESMTPSA id s11sm4329536wrm.56.2020.10.22.08.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 08:46:13 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 0/4] clean up linked timeouts
Date:   Thu, 22 Oct 2020 16:43:07 +0100
Message-Id: <cover.1603381140.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These are preparations for future patches but looks good by itself,
so sending upfront.

Pavel Begunkov (4):
  io_uring: remove opcode check on ltimeout kill
  io_uring: dont adjust LINK_HEAD in cancel ltimeout
  io_uring: always clear LINK_TIMEOUT after cancel
  io_uring: don't defer put of cancelled ltimeout

 fs/io_uring.c | 60 +++++++++++++++++----------------------------------
 1 file changed, 20 insertions(+), 40 deletions(-)

-- 
2.24.0

