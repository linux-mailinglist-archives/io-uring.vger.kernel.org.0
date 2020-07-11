Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8212C21C358
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2020 11:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgGKJbS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Jul 2020 05:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgGKJbS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Jul 2020 05:31:18 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D046CC08C5DD
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 02:31:17 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 71so5976825qte.5
        for <io-uring@vger.kernel.org>; Sat, 11 Jul 2020 02:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RiNoald4P65ewGZ3qyOBFYa1p/mffGn8Nb9u85nR6Po=;
        b=iCHI8sBp8m/jRigdwPRMg49nNr6VQtUurXKlRRLPwmHHQcVWHDdJ/HO0RmZXZJJEnK
         y7oVOBFA/0+XBhz4eratYiybJCi2olmv69wCB9jdzOqk3g7SQePHDs3Mhy4Z7sS54LQ9
         qH5tf3L0TsUSVbb2POglsMPEbtHpq0E02fdwYx+kChY4DJieZGWtMaPn4tksKujwOFNI
         ud0P/oHjt6pOAt9n+xwsxG9TMztu9LRklR37StWNmLeDsoWlX8QLSoF+pEZLvzXDDqy+
         C6WYsioxVOTFSI2/Il8QwoH5QQ52gayFvjZNBgz7Ay48sBLAc8CAV4sTprGkv1rLPDa8
         QFtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RiNoald4P65ewGZ3qyOBFYa1p/mffGn8Nb9u85nR6Po=;
        b=f3EinIJmjE/IPdAMQr4YUK923KccVQY8zu3XsNqVa1f2tCnQwggTHODmItQLYn7wm/
         UzTM4WukgT6XvzQUQ2idVJCGzZpJcbcTLrgXPJaT8hhq5jGM3MvmrrgxTv7BbY+k75Ce
         34yYD6gnNU+sisMmSXo1MOagJzlZGOZmKbDslJzLc2Zv0fTaSAk2ARyrnVllgpGr03Gh
         KPTcXcSkl2yakRjBZSvKN/fUvVDQFt8fqYIBacVH463J4wYmdlZMUvNqSfYos4m+VonF
         YMhQ6/Ba/higikmoeChZOKxy6Sh3qdXks3nHQ9UdZJGwX/RWkbR4PcGrONjBQBitcHBv
         H4MQ==
X-Gm-Message-State: AOAM531hqxL+e/dX9N8JG2cSioXmOJ7cd4LttVYGWFyrDhEKKvwHbzMQ
        yH1ASnXiFiYwXuwGE5NoLlUsRGA0vjkP
X-Google-Smtp-Source: ABdhPJxLLCzenMO0y7wauOafO4mpsiFXlQtMYGF0breGuPRUhSG2eOQJT86Eggz+N+0smeIeu71SdHD6Suk4
X-Received: by 2002:a05:6214:14e5:: with SMTP id k5mr48788572qvw.125.1594459875360;
 Sat, 11 Jul 2020 02:31:15 -0700 (PDT)
Date:   Sat, 11 Jul 2020 11:31:11 +0200
Message-Id: <20200711093111.2490946-1-dvyukov@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH] io_uring: fix sq array offset calculation
From:   Dmitry Vyukov <dvyukov@google.com>
To:     axboe@kernel.dk
Cc:     necip@google.com, Dmitry Vyukov <dvyukov@google.com>,
        io-uring@vger.kernel.org, Hristo Venev <hristo@venev.name>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

rings_size() sets sq_offset to the total size of the rings
(the returned value which is used for memory allocation).
This is wrong: sq array should be located within the rings,
not after them. Set sq_offset to where it should be.

Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: io-uring@vger.kernel.org
Cc: Hristo Venev <hristo@venev.name>
Fixes: 75b28affdd6a ("io_uring: allocate the two rings together")

---
This looks so wrong and yet io_uring works.
So I am either missing something very obvious here,
or io_uring worked only due to lucky side-effects
of rounding size to power-of-2 number of pages
(which gave it enough slack at the end),
maybe reading/writing some unrelated memory
with some sizes.
If I am wrong, please poke my nose into what I am not seeing.
Otherwise, we probably need to CC stable as well.
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca8abde48b6c7..c4c3731ed41e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7063,6 +7063,9 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 		return SIZE_MAX;
 #endif
 
+	if (sq_offset)
+		*sq_offset = off;
+
 	sq_array_size = array_size(sizeof(u32), sq_entries);
 	if (sq_array_size == SIZE_MAX)
 		return SIZE_MAX;
@@ -7070,9 +7073,6 @@ static unsigned long rings_size(unsigned sq_entries, unsigned cq_entries,
 	if (check_add_overflow(off, sq_array_size, &off))
 		return SIZE_MAX;
 
-	if (sq_offset)
-		*sq_offset = off;
-
 	return off;
 }
 
-- 
2.27.0.383.g050319c2ae-goog

