Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66C324B129
	for <lists+io-uring@lfdr.de>; Thu, 20 Aug 2020 10:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgHTIgf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Aug 2020 04:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgHTIg2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Aug 2020 04:36:28 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DF1C061757
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 01:36:27 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id bs17so946870edb.1
        for <io-uring@vger.kernel.org>; Thu, 20 Aug 2020 01:36:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NoB5tFXDjjDNJ83bomtBeKLAS97OUGNKu4jbIR5S0HU=;
        b=PcgS8di7xtGs6na48Bm42qBGEp4e+fjt+TALGSUJTYnJWMRQn3NH6kZdj28lrgTs9K
         n3VWgKiUjsjK8d5SVgElr3weaGdJlkMiZi2oEP6FZzIM78Ba5lZ48Pbp7ORAj8r1d3Pu
         0u3yEtyHI6BMaQtyE7258kTW+EPOcfm0wf/spb2JMbOFlCUtfOGP7DDgYbosG40e99uI
         hS6uqNZljBen86bj5s9TNOVl6Zc1R59b+sgwwzNUL7oTUY5bD2JSwosPDEPoNruJwNlF
         N+FwEFxD5MGGQS1DhKEX3y8nZhJPhgfK8WNZOXyVtUUiCQf/bCvW2jbQtrbGySNxGYYt
         IMAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NoB5tFXDjjDNJ83bomtBeKLAS97OUGNKu4jbIR5S0HU=;
        b=RevL8y7+sTpB3XRFo2MCFJ0EBmZSFCSEBrEkrmlAe1tRU/aln5Q7DoR/O1TUL2rciS
         PdQ7iP7bIiiaBnIhWxh1Zdv8SBQWfgof0U+ML9PdbTMBsNqZk+bwJicFtuFERm9mqeIM
         iRMkT8YChqCrcXbpLX3kzhki0a0Fia6Dytgtyl4odf5QDK2aJeLFWRGDYbnPy25zBxog
         EsHvn4lBGOQXQpBajVb9fxLr6yFFoouza9s8OhecG4Q9MKwRj4labulZDj+xJ+L8RpJo
         9nVefjUehcnr1+dpur5138V/cUCDtMElA9c883uf+E54A8QAXGOsI6DtT6w9Ui+dBBLM
         zt3w==
X-Gm-Message-State: AOAM530RgSVnIYpLX2/kPkKUQCzbjWdtXYAQ6QY2RCbAKQs/B3zaa29/
        6jZBUR+Jbt5fsHtAYbix95A=
X-Google-Smtp-Source: ABdhPJwIMJxyR0baHDIHkRuF/ZCa+4Eobg6MKdggHdeRxO6oett1aTwZKe6G+hQ8Uxx04ARTSHNMAw==
X-Received: by 2002:a05:6402:3193:: with SMTP id di19mr1884301edb.224.1597912586347;
        Thu, 20 Aug 2020 01:36:26 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.225])
        by smtp.gmail.com with ESMTPSA id a23sm888601eds.37.2020.08.20.01.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 01:36:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH] io_uring: comment on kfree(iovec) checks
Date:   Thu, 20 Aug 2020 11:34:10 +0300
Message-Id: <7dd37adcb8a6fabd700205e2bcf62ccdc30681f3.1597912327.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

kfree() handles NULL pointers well, but io_{read,write}() checks it
because of performance reasons. Leave a comment there for those who are
tempted to patch it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 938112826dd1..ea2d1cb5c422 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3204,6 +3204,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	kiocb_done(kiocb, ret, cs);
 	ret = 0;
 out_free:
+	/* it's reportedly faster than delegating the null check to kfree() */
 	if (iovec)
 		kfree(iovec);
 	return ret;
@@ -3300,6 +3301,7 @@ static int io_write(struct io_kiocb *req, bool force_nonblock,
 			return -EAGAIN;
 	}
 out_free:
+	/* it's reportedly faster than delegating the null check to kfree() */
 	if (iovec)
 		kfree(iovec);
 	return ret;
-- 
2.24.0

