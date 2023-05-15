Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B924702D41
	for <lists+io-uring@lfdr.de>; Mon, 15 May 2023 14:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240863AbjEOM6G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 May 2023 08:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbjEOM5v (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 May 2023 08:57:51 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F060D19BC;
        Mon, 15 May 2023 05:57:39 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-965fc25f009so2060995366b.3;
        Mon, 15 May 2023 05:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684155458; x=1686747458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=c/WsGoeYdsta1UG6dgZw3dmI3fN5/OIDDolXmg/WRRc=;
        b=YU4eezWDd4O8MqB2M3V8utHWot7vHfTtP2uaqLS8d8wnxLQAU21hnJqPw7DOSQXoGS
         Bj3ryWBSX23baVEAbWvm27PTEdtODNMMXOb+rcJSLg6VAR/dwZr9sceBWMvIKwu24wWi
         vjSBiayGlYXtaSTGriB2o7b7yKpvFA2C5Hphe9C4xvSU5fGJh+VXKxEZxHGzYs1cfiov
         1dQyVezaNuVQhSLgzaUx2ZYWMZfQockOKQOtTRx0KTJ81RgkReS01eT+DBKUB1db8kH3
         LTPe7fqBXTL//cvJ75olUmcU0Feiz6kwgYNWKwwPYod2J7NkycnD5vcePClf/qzck4Y0
         u8DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684155458; x=1686747458;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c/WsGoeYdsta1UG6dgZw3dmI3fN5/OIDDolXmg/WRRc=;
        b=EOQeLAWr0ZaVpl2SwARR1YhlYo6IQDvUxukKVt0wQ9icMoeyRZ/RgvufchZuwKkpAq
         MgyvjvbId/Stv+TXWpgW0SreYyaHnAZN1v/O1cdq8l/ZB1kLLuDmgHyUK1MySM+WtAH0
         xDsY1zdN2RHpcooQlSwhMdNGTrPZqUsBh8g8HzNCcIz5MBsGcb+sJ1EH59+LVi984W+a
         wzbkdms4AetVpMnLZNFYfEE/JmHGws+eGIC5041gXKgaJcxCaFniAsETCmUz4Q28Mo75
         wq6bkf9wzuxvafVwXsmqlKYSP88W3Z7xPR83zpqYDY7u/9kmFpdA3RJkbQgtFfwMSIDg
         vibQ==
X-Gm-Message-State: AC+VfDw39RfbEpYrdNdu0Glzec6w93cTjbAxEtUr3RmRP8fcSpT5sWqZ
        VH9LaDsJKlFq3DLHy70u0iiKNPwrdxo=
X-Google-Smtp-Source: ACHHUZ4TEnFDdtXxeZc6ughmF/ZD5RUK/PID1KZQLAzF4qZ5PJ3lyI+mF6zlYitrqJDanrOFDFYZdQ==
X-Received: by 2002:a17:907:3f25:b0:969:edf8:f73b with SMTP id hq37-20020a1709073f2500b00969edf8f73bmr23011931ejc.60.1684155458207;
        Mon, 15 May 2023 05:57:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6366])
        by smtp.gmail.com with ESMTPSA id m13-20020a17090672cd00b0096ace7ae086sm4003685ejl.174.2023.05.15.05.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 May 2023 05:57:37 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joshi.k@samsung.com, Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next 0/2] Enable IOU_F_TWQ_LAZY_WAKE for passthrough
Date:   Mon, 15 May 2023 13:54:41 +0100
Message-Id: <cover.1684154817.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

Let cmds to use IOU_F_TWQ_LAZY_WAKE and enable it for nvme passthrough.

The result should be same as in test to the original IOU_F_TWQ_LAZY_WAKE [1]
patchset, but for a quick test I took fio/t/io_uring with 4 threads each
reading their own drive and all pinned to the same CPU to make it CPU
bound and got +10% throughput improvement.

[1] https://lore.kernel.org/all/cover.1680782016.git.asml.silence@gmail.com/

Pavel Begunkov (2):
  io_uring/cmd: add cmd lazy tw wake helper
  nvme: optimise io_uring passthrough completion

 drivers/nvme/host/ioctl.c |  4 ++--
 include/linux/io_uring.h  | 18 ++++++++++++++++--
 io_uring/uring_cmd.c      | 16 ++++++++++++----
 3 files changed, 30 insertions(+), 8 deletions(-)


base-commit: 9a48d604672220545d209e9996c2a1edbb5637f6
-- 
2.40.0

