Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739D938D023
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 23:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEUVv1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 17:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhEUVv0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 17:51:26 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABB5C0613ED
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:02 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id 1so16432518qtb.0
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 14:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:date:message-id:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=f09L8q774yElps/q7XGUKb4sfj1FooPKo1rTwaATVjY=;
        b=znVcls6DkVB0sVL6+jD/9JcWr4lkoF/HyhjCDR7szM/mtlcELz5tjynwyvADsaeGjJ
         Ci2ZtktqdQ7vvAHG1CkmU+JYeu8VskETW6DKJLrZC+AJ7gCBEKCtx5lBAfBs7soiX0un
         VSX4OhKcQ59USVuY3Mg8EmSpc7+09aWtrqR/2nogTANEz57o8MP5acAV8J3AkOhIYWR6
         mRYJuxpkX4TG7NBxpMvcjB+0Ibl+aSyGFL+7KxBf3VKvwF4K1BUGSzWscUpnPOJXPQ7G
         F5Kb9PuJ/awOhVz17CLccVCBrJiePX4RhA74wRaXJutgnHX5NMdqM8BbBKLHP4ooNk8B
         8ABQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f09L8q774yElps/q7XGUKb4sfj1FooPKo1rTwaATVjY=;
        b=c6EM6D4gr7Ir1I789YXnVNQjUiPVBYW1GMnSdVduMvJLnhz/ZMk3WBOj/WZ6zPvcyx
         HKVetTMUALYrQxZPWvnJ8PPnc48DtkNikLeN9V7tVYGEzTB3a2Y/DIa12SzSMKVakegn
         3VSYEK7lMvk/tf5hXiEj3fIvpEQI7yKHcvNvk8MexSbc8FE6pCCW8a7EXeFbD5kUdQsD
         2XjXsmWja+1pT/dwO3+unyWGp3CfGoB247P1ATmMTsHt8dNNMAgFzWdDpt7lUYHWwjiW
         0ciNsukBqGkw8QYKJS83PYxe6xBL0XW4pQzN4wOCNSgqvH4tXR8yjNfzjq8UdoI1F40d
         vDhg==
X-Gm-Message-State: AOAM533F1bWsMZZlXYV5Bz7PZ0WD4lyDRzdVWn2eTxx7IZbCDTm6AzBi
        FTDCBXQX7ElEMFkR7H8uVyQG
X-Google-Smtp-Source: ABdhPJxuLAQxlJc3vlIKo5MhSE0jYBBMFo/5T/BQwD64uE91fX+g/jksNikqD/j2cApaI8yZp4SBOA==
X-Received: by 2002:a05:622a:144b:: with SMTP id v11mr14090251qtx.372.1621633801743;
        Fri, 21 May 2021 14:50:01 -0700 (PDT)
Received: from localhost (pool-96-237-52-188.bstnma.fios.verizon.net. [96.237.52.188])
        by smtp.gmail.com with ESMTPSA id s20sm5846297qke.2.2021.05.21.14.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:50:01 -0700 (PDT)
Subject: [RFC PATCH 3/9] audit: dev/test patch to force io_uring auditing
From:   Paul Moore <paul@paul-moore.com>
To:     linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Date:   Fri, 21 May 2021 17:50:00 -0400
Message-ID: <162163380070.8379.13984065725601277137.stgit@sifl>
In-Reply-To: <162163367115.8379.8459012634106035341.stgit@sifl>
References: <162163367115.8379.8459012634106035341.stgit@sifl>
User-Agent: StGit/1.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

WARNING - This patch is intended only to aid in the initial dev/test
of the audit/io_uring support, it is not intended to be merged.

With this patch, you can emit io_uring operation audit records with
the following commands (the first clears any blocking rules):

  % auditctl -D
  % auditctl -a exit,always -S io_uring_enter

Signed-off-by: DO NOT COMMIT
---
 kernel/auditsc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 729849d41631..d8aa2c690bf9 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1898,6 +1898,10 @@ void __audit_uring_exit(int success, long code)
 		audit_log_uring(ctx);
 		return;
 	}
+#if 1
+	/* XXX - temporary hack to force record generation */
+	ctx->current_state = AUDIT_RECORD_CONTEXT;
+#endif
 
 	/* this may generate CONFIG_CHANGE records */
 	if (!list_empty(&ctx->killed_trees))

