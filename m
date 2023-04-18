Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1B36E655E
	for <lists+io-uring@lfdr.de>; Tue, 18 Apr 2023 15:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjDRNHX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 09:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbjDRNHV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 09:07:21 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F62E1BD
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id xd13so39089792ejb.4
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 06:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681823229; x=1684415229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QH21MposTdKYhotLK06DVrC1pAm1KGaKinaxkkkAJyI=;
        b=A+71X2cXw6yQEvWEBJNfiiD7XPSBU/MTlKVzMLphV/uPFpdhMbDXOOsnsceDcItx80
         Lrf3f1taxP6zBSJlURfJ+mRJwA6hgtj5imxI7XMMa3j89nCv9RQ9Gi47ijjfPrg6B3rf
         wZku68YhcufQy8shIOq/Nnle4XFqsLI6R2nXgEj7UEPm3kU1P0BbQxcQBwdxcRDQLm+L
         cV0mGZ00J3+SSsB2zfuiGnFMIXEhfMhQPgDVXXLMpH26DuJiDla2AzdR1Yu6zBlG3RWB
         1U1SYeVzwQ7a6FvajpDTBaPVpqtshGP0X7/azeLjvqDW1VGe/QmqOKdjt+ZLzb1Qqlpz
         DJ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681823229; x=1684415229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QH21MposTdKYhotLK06DVrC1pAm1KGaKinaxkkkAJyI=;
        b=hpihzendgk5CALs8cjjmtHjBtz/PYgl0L/QRoObv365A/75zOJZWQdBvzaX6/WrnXo
         d+QIhpVdPEwChnyVg4DW9Jx13t8kc4jD33K/MneVbm5jN7opCBgf22kcoNZvPOS8Pjyo
         OuQXW+YYmBbsZlgbRkTGZWjqxbSH+WwoyXsb+6jqLJIOkR93eidEVKI4avp4RspuaSC3
         /XZRLuOwLfOr3tqlL9VCHmcZXzFp7+ZxPokJ330chzo0k4jbdrxWcs7rfz/4DYGS8b1x
         oV+5DUWdfx5zN/bT/leKrWxw66Ktx2Mr27fafZHDOCcmhDA17bAQwlp1zOuNROWToMxM
         p18A==
X-Gm-Message-State: AAQBX9fMAFxz7//qyGdl0NGwn+ya3mbZMFz/EU7kRu6PDf7iassoQFbL
        tUnB3xBjpjIApetzFe3UkowxhGY189g=
X-Google-Smtp-Source: AKy350Y2EssRdTM7R3tN7QGICFI8Pg4p/nxdHX1truAS5aEVZjgLMS6j8hTIGV2eYJ5mnIiLvnXQhw==
X-Received: by 2002:a17:906:4708:b0:94f:764e:e311 with SMTP id y8-20020a170906470800b0094f764ee311mr6533134ejq.16.1681823228818;
        Tue, 18 Apr 2023 06:07:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:cfa6])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm7924919ejh.101.2023.04.18.06.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 06:07:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/8] io_uring/rsrc: remove unused io_rsrc_node::llist
Date:   Tue, 18 Apr 2023 14:06:34 +0100
Message-Id: <8e7d764c3f947489fde88d0927c3060d2e1bb599.1681822823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681822823.git.asml.silence@gmail.com>
References: <cover.1681822823.git.asml.silence@gmail.com>
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

->llist was needed for rsrc node destruction offload, which is removed
now. Get rid of the unused field.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 732496afed4c..525905a30a55 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -44,7 +44,6 @@ struct io_rsrc_node {
 		struct io_rsrc_data		*rsrc_data;
 	};
 	struct list_head		node;
-	struct llist_node		llist;
 	int				refs;
 
 	/*
-- 
2.40.0

