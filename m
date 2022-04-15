Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B14995020F2
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 05:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349117AbiDODny (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 23:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241106AbiDODnu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 23:43:50 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7022C117
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 20:41:23 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n18so6239263plg.5
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 20:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=uEgagIcyAvoKSkj8mMlFvqjXFPgLq4OxZbBNaeudVV8=;
        b=UVII1pY1olYi8werhXUi323qXH+Zo3YvCQlD8eLEvqxCfE7JAgWOBjA5leZpcn523Q
         9yYC64sKhamdtEr42hiFBXV2aaQgkUkaPnmvHoCmAUPpf+he2nKBkjSQ+41JFEFgw74Q
         tfC7HDiU8CEAXrZ5n7HDw0/iE2KJp+g02QDFDMWf+9gP7Z98qqF3KCEL0f27l+894Lid
         OnanwO5iUsnKAaf1w+/8KF14yW82F29aN3zsRk/UV2JpZ4i5VncdTjRDcfcEN/1fFPlL
         W2/GXhmdJAshTLjsuBTyEyDafu/jkSvUqlgXK9H684Jwmdp0hUiUneWxir9Boi8Ku1DC
         84ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=uEgagIcyAvoKSkj8mMlFvqjXFPgLq4OxZbBNaeudVV8=;
        b=na+nuqEH5K5hpYdc9ZCnO8V5fhGDt6NzuGmKFlxFz0375f+zWa6nNH63o5qSAlm1QA
         BBjHK6YcpJmQ/BP5GE4G4DfNxnR+MDQcjT0rHXDpYcaARG4E2kF5RZyM1pTLu9r58R/+
         AaOM6o7JVSBuWCbu73t7qrg+aF3Ajb5QUZoEKuyUbkMyeYlsDX7PHtvDGdlo2gDn0vWa
         ndiXgZfGLu6zAm5reZ1MgNmDv0gtsK7jv7otCQQRFjjwkgNB9bKRt8La6xZ6OB8yEz1E
         WVWZEva/6ZtcYRT+/3AYQJt374JbLcq+w6/9/zzQKJxkEL/8kBbjdvebX0LIUF5fo/o9
         nwOw==
X-Gm-Message-State: AOAM531PeQwec1Lv2eEP72QB4rpCiO3oMBmhZyrLNGgDMX0I0eSNP84y
        Ms13D71Kzs5z/QBpPMjXGaC5OF9eD4j31w==
X-Google-Smtp-Source: ABdhPJxB8wgLQ/Iimmo5bqRc2eKHOKJqY5bkr8UO2dlG84fWRfZr/XIriZEfiXGXGYf/6XkX5jxM9w==
X-Received: by 2002:a17:902:8547:b0:156:7efe:477a with SMTP id d7-20020a170902854700b001567efe477amr50030514plo.47.1649994082676;
        Thu, 14 Apr 2022 20:41:22 -0700 (PDT)
Received: from [192.168.4.166] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id u3-20020a17090add4300b001ca56ea162bsm3144369pjv.33.2022.04.14.20.41.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 20:41:22 -0700 (PDT)
Message-ID: <5a044858-2a95-f8e8-aa56-c71df89fc860@kernel.dk>
Date:   Thu, 14 Apr 2022 21:41:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: abort file assignment prior to assigning creds
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We need to either restore creds properly if we fail on the file
assignment, or just do the file assignment first instead. Let's do
the latter as it's simpler, should make no difference here for
file assignment.

Link: https://lore.kernel.org/lkml/000000000000a7edb305dca75a50@google.com/
Reported-by: syzbot+60c52ca98513a8760a91@syzkaller.appspotmail.com
Fixes: 6bf9c47a3989 ("io_uring: defer file assignment")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ab674a0d269b..4479013854d2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7111,13 +7111,14 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	const struct cred *creds = NULL;
 	int ret;
 
+	if (unlikely(!io_assign_file(req, issue_flags)))
+		return -EBADF;
+
 	if (unlikely((req->flags & REQ_F_CREDS) && req->creds != current_cred()))
 		creds = override_creds(req->creds);
 
 	if (!io_op_defs[req->opcode].audit_skip)
 		audit_uring_entry(req->opcode);
-	if (unlikely(!io_assign_file(req, issue_flags)))
-		return -EBADF;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:

-- 
Jens Axboe

