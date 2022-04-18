Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5671A505EBE
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 21:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbiDRT4S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 15:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236327AbiDRT4R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 15:56:17 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990502C65C
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:37 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id k23so28742467ejd.3
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9cKw+Dpj1nFhQGKyaWfal2Y1nmSrGZoV6D+wEgL5G+A=;
        b=UWdH8flnZd4NrHaGegPUh6eeHBAbHNTuXFOU7D1SbYidlPxialsvi17l16Hmj/4B7c
         JS/+DTl41YN3SEAkgJvTLBLKx8FLCWsrsSnkpC8LzHSsoNpl/29bdUDzVTG0JCCDzttQ
         pbYc7Z8m/C6KheNOuKyID4Bwe/UK1n5tGzp6as1PkN3sBL5hgxLEibXVJVWJ5VSYspBG
         alCrMzMSoKr3TkrvOJGg8f3ancaBrE8Ka7cyBwkdW+3BLC9+OB8FGxk1U+4l3HWedsJ3
         cZQvosJsOAnEJfirB+fOyWTTQ7IMgzaf177PDmDq/1EYRK/3om1+vSGuoNJnqG94+g19
         yyAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9cKw+Dpj1nFhQGKyaWfal2Y1nmSrGZoV6D+wEgL5G+A=;
        b=MiaEow50iCDpF2vV//mCVKvq3E8kxrSNchhTFfcahUmGabzFrIkMghOpOhPdJZFsnA
         R/I+NuEQ5c/5JcPDjtyeJAlKcJ/y1HOB4Hm5uzRjRlfxxHfkdh/vzhBhjheZnbFNDNYa
         xZdTWJLD7KFMOPyccpdRwqjWbvvz8VkQMwIYsDnkfNwrLyk7aT825mBjc3H5VwYS2sMF
         Vb1l2WBYLhFk9zv310iurKyudE59/BHnUn8RjolcJ1zM2LTArgvr8u8lQ+CJALCe8hvI
         cBlDECXLFkSWV6qq//aq4nPCNbxJ7rwVlYCFuyKmrQLZYa46r1aJ610DWar1CgCjgbuC
         +a0Q==
X-Gm-Message-State: AOAM532PcElSyYO88KXEP/3gzyDBu2jKeDo3PbTEFPMssat4nKP/fSSO
        GGqhT6Qh/wp1SrsETe2lOMlQdi4kfTQ=
X-Google-Smtp-Source: ABdhPJwnKZ5cK154yi/4wJVplqhFckcK9x7deDoHAeOP+fj7SCrs/llvIYjEq9JBeL9HmUEzta4gBw==
X-Received: by 2002:a17:907:7d9f:b0:6ef:8552:6a52 with SMTP id oz31-20020a1709077d9f00b006ef85526a52mr9110102ejc.490.1650311615804;
        Mon, 18 Apr 2022 12:53:35 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.70])
        by smtp.gmail.com with ESMTPSA id bf11-20020a0564021a4b00b00423e997a3ccsm1629143edb.19.2022.04.18.12.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 12:53:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 0/5] random 5.19 patches
Date:   Mon, 18 Apr 2022 20:51:10 +0100
Message-Id: <cover.1650311386.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
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

Resending some leftovers

Pavel Begunkov (5):
  io_uring: use right helpers for file assign locking
  io_uring: refactor io_assign_file error path
  io_uring: store rsrc node in req instead of refs
  io_uring: add a helper for putting rsrc nodes
  io_uring: kill ctx arg from io_req_put_rsrc

 fs/io_uring.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

-- 
2.35.2

