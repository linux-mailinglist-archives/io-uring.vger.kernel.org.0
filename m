Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B048B1563CD
	for <lists+io-uring@lfdr.de>; Sat,  8 Feb 2020 11:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgBHK3C (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Feb 2020 05:29:02 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:37352 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726876AbgBHK3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Feb 2020 05:29:02 -0500
Received: by mail-ed1-f42.google.com with SMTP id cy15so2440068edb.4;
        Sat, 08 Feb 2020 02:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mLHy+cUU4NFex+vChTIEpURGCsi2ARiFH9yKOSIpVA=;
        b=eVtetN3M3uCaPCCqLJrETLoe+LLIOkpA0IRuNR6DcTvcZVQZCqdLFdwRJKZn84yZBm
         ddnv8Lv3DtNvse3BDMlyxnaMCocX5r0urnqZ8J7FG5Exk9LOGwYJGqn8vqpJXrtw+0Op
         SsDpL8ZZrNsKvzQA3zkzCqyszSGcqDmBxKZRTjE4lolsEiA2Kq87II8GeNh9PtNPzTcr
         VHDw69qDPDxZJ7Hkw48cVDHtODcmsK+m3K6Tpzerfy7FrMlSNI/hhxfnzmSNh8MHWprd
         8ypiaNCpShYt6fdV4lLp1PKQNK7oIjR0IrHLYGemy8Q/SU60vRtNeZN3vOtBP7QPEkoA
         NqEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3mLHy+cUU4NFex+vChTIEpURGCsi2ARiFH9yKOSIpVA=;
        b=XKr7IQdm8VKLGSe0wDPmsG8RzfVvOd9ssTtRx3Gqzom+gcYl+4J1rR9pCNu67fkN2T
         4lsf24odg0mhRZG/uXaV0q+9xihC7lQjxk2YKIZ0P/uUtkfqsmR3iMKqf8D05lBV2aHS
         jkif77W27SdNrQFAg/l+nLT/4/3Acr25du3OrimczU05u9s8DwXFSgdWuA258QXQOrOX
         zr/dFDqXRunSD27h2u6RLyuqC906L5NzIpwSwJQDa4QRm6j/+oEIp9goUiIYnIgeAFSq
         ucDm6Mw8cLq27qQKBEZ526dBtNp1MCRza1/6ppP8eR1dvSqKQ1bBszp+X/w484XEWi4m
         SeYQ==
X-Gm-Message-State: APjAAAXwQfTTBa5RCsVli+8NM7Z/Hilno7dhek3AkXIe93vyUZYfkV4C
        RmfyPZ9EM3EESCRQMIOcgyqzHtaZ
X-Google-Smtp-Source: APXvYqxJkcVs3TAKxyRIKtlLD/Un8y/wWJSvTcnv0JCUA21JdKbGHBnukQ+NPBN1K5X51VxM11+niA==
X-Received: by 2002:a17:906:848e:: with SMTP id m14mr3477114ejx.152.1581157740646;
        Sat, 08 Feb 2020 02:29:00 -0800 (PST)
Received: from localhost.localdomain ([109.126.145.62])
        by smtp.gmail.com with ESMTPSA id f13sm257742edq.26.2020.02.08.02.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Feb 2020 02:28:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] address resourse leaks
Date:   Sat,  8 Feb 2020 13:28:01 +0300
Message-Id: <cover.1581157341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This fixes the last prep/submission-related leaking hole I found.
The first patch is only for read/write/send/recv, so may be 5.5-ported
if needed. The second one doing the same but for openat{,2} and statx.

Pavel Begunkov (2):
  io_uring: fix double prep iovec leak
  io_uring: fix openat/statx's filename leak

 fs/io_uring.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

-- 
2.24.0

