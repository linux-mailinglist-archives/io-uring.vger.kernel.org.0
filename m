Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FD2A54F873
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 15:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiFQNpM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 09:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382020AbiFQNpK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 09:45:10 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E2F2870D
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:45:08 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c196so4238685pfb.1
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 06:45:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c76fXaAfArnOXlQRDh+w4D9G1Nvd1KIitLS1dqTmvmU=;
        b=cy+NJO0B6drZbaZ2ZjRm4Mk/mAHppqoy5ZRRMFi6/gsAAXnz4/FYd7DpbkWb8XIbmi
         NGMaYGElYXHVMBhnBOCuBNHRxMt3tjTW2jfRt9yyyDv2bH93P9sAMPHbM/hKDMNWS8UG
         fttfRV7dQklG00FhFCdohtC42uon1tMRO5nr8FgMRP1bn2EvMaBLj3B1dPombamZeFKD
         Wg2T0kFSPiFK99uyIj4aNM3/YEfF1AKe0hXpXswOnyjfnrL1+6WKetikI+8k9xT4Z1oa
         vwMJsahJf+WHEyCw5u1zO+kAK+kDFdNBPNG9vjueUJ8Yvzt2vAI9i3VLUnQtRgXhmjj4
         fIdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c76fXaAfArnOXlQRDh+w4D9G1Nvd1KIitLS1dqTmvmU=;
        b=W9obKU/CEsyEJ9Di6X3bl8N7Zv0RAmVXz1ubo2cbNLeOTBmTz4NlV0/ZvUNwJDbZdm
         NLKnQyana+D2g18qZNTiAaRI39gIzMHTUat7dMdwpgEetcw8GwGBBxCiJzLE9WvO3IrJ
         KHuB/5o7MblQNkoZjFQYc0I372v8F4sZ4SaPXd9ZMIGgoCba+NAOLUcI48X8yR0hh9BO
         l2a/jhdsq2rA5C7Al7EN69v3ZaAxpw5tAu+Xpf5L2caOlzhYWNiGZ7oS+Qqb3DNfp6DP
         yMRTKnbKS5WXoU5wy44nC21N1rOgYLR3kvXa4ILuadHkiYh5nZjuPpC2yR1rbzkZGcXw
         vDpA==
X-Gm-Message-State: AJIora+7uzM2Cp+GYtnySjPU/cpqa1g9+/EzKTiWg2NHEmxsLZTwzQbw
        JwFQvViEjcnVB1FJoZwrEagdv1Q7A5/RNw==
X-Google-Smtp-Source: AGRyM1uXywkU3KE9R8nVzReQuHWmJSWqxyq+lb6kVC13PhT9AjYC8jfRhMJVgsrLg999ljeoLj0/2w==
X-Received: by 2002:a63:5c56:0:b0:3fc:824d:fc57 with SMTP id n22-20020a635c56000000b003fc824dfc57mr9284365pgm.561.1655473507984;
        Fri, 17 Jun 2022 06:45:07 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a1709027fcd00b0016392bd5060sm2214075plb.142.2022.06.17.06.45.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 06:45:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET RFC for-next 0/2] Add direct descriptor ring passing
Date:   Fri, 17 Jun 2022 07:45:02 -0600
Message-Id: <20220617134504.368706-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

One of the things we currently cannot do with direct descriptors is pass
it to another application or ring. This adds support for doing so, through
the IORING_OP_MSG_RING ring-to-ring messaging opcode.

Some unresolved questions in patch 2 that need debating.

-- 
Jens Axboe


