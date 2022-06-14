Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC63554B3AA
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:43:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbiFNOiD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:38:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244916AbiFNOh4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:56 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFD7193E6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:55 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id m39-20020a05600c3b2700b0039c511ebbacso6337874wms.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xtoDyDvNXPTaclwDuSrBJ25RRT45S7N/gTULdXm19LA=;
        b=eqahh/BIRPOKHJ6IPjJII9pfU50/U3Tn0P9DivGktoH/rehdFNOHRPat/7lRq9BZnR
         S6orsQX/1bxk28H9V5nNzRqU9gZ6pKDQ2LrtpUnUayolrDNfFSYrNzBCXK42KfKxW4w3
         suNnlCkwOHSlbOWYI2HxvB6G1ZY22zOqvVwfFCA296KXtnFa/ZMvdZgJ+AZzVEy+IkuW
         Uv4ML6l0gOpzkSo/xNC5Qw1AMqu6Dinhqqpa4hevEXWalJxThTUFJ8SIH/5oDDuBBZGI
         MInICFTrIwaPwYHO/r55f5gAuLsfWYHtPvxtfec44HNOneIWMl5ITw1XrjdkdgD6XDbE
         PdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xtoDyDvNXPTaclwDuSrBJ25RRT45S7N/gTULdXm19LA=;
        b=sz4C2iOZvd5WOIC+o09Md34rzxcDrAeaiX4S2CbVT1saBtJPotvc4pVj3Dngrk8aWp
         ASk3Dw4UloT3h4iyHPs/mjiqgPoxENKbFxUTf+BUz1CkOMSU1a53tJc1/TE4/sm7lb26
         UuJaEVoTZiVj0T09hRMifgoJI7V5KrFa8H9YVBCmpY9fOah++VkolfAHnnipsO3F+82U
         MCIXl0tmX8jl01r+oEMZBFYCRGjU1ASL3DFTg7YuGddTKJGaKO062DghGbAnJg//oEmg
         8MJkERSf7VmfzKUbj2R6DPta9WBTUfFEz5PzINHamBXqUHeEQL3E3McODM1B34LcUEtm
         UZVg==
X-Gm-Message-State: AOAM5333vDfeYu58SA8tEOmTX5mdxI7OA67rCZ6sNo1/k/jkTNcVcFw6
        ZbxTG3NC61Svd+WaKy8VCLJCSC+7eeW23Q==
X-Google-Smtp-Source: ABdhPJyCYGYmdX1Urx6qpYVz1tndgiqPqRPETCMfeuMOVogo/JTeCjGD3D+/QCQVWy3AXTKzxRWgyQ==
X-Received: by 2002:a7b:c389:0:b0:39c:49fe:25d3 with SMTP id s9-20020a7bc389000000b0039c49fe25d3mr4553278wmj.83.1655217475119;
        Tue, 14 Jun 2022 07:37:55 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id a4-20020adff7c4000000b0021033caa332sm12353064wrq.42.2022.06.14.07.37.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:54 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Hao Xu <howeyxu@tencent.com>
Subject: [PATCH for-next v2 14/25] io_uring: poll: remove unnecessary req->ref set
Date:   Tue, 14 Jun 2022 15:37:04 +0100
Message-Id: <010576dc7ac2cbc6059958795adeaf6cef1e02a5.1655213915.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213915.git.asml.silence@gmail.com>
References: <cover.1655213915.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

We now don't need to set req->refcount for poll requests since the
reworked poll code ensures no request release race.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0df5eca93b16..73584c4e3e9b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -683,7 +683,6 @@ int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
 		return -EINVAL;
 
-	io_req_set_refcount(req);
 	req->apoll_events = poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
-- 
2.36.1

