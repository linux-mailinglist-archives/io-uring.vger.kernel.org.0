Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 637734EB275
	for <lists+io-uring@lfdr.de>; Tue, 29 Mar 2022 19:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240039AbiC2RJ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 29 Mar 2022 13:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238507AbiC2RJ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 29 Mar 2022 13:09:29 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC43258FCF
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:46 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id z6so21796693iot.0
        for <io-uring@vger.kernel.org>; Tue, 29 Mar 2022 10:07:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vNnvqn3cTsS8jE6Oj+nGIHZ9v3Kg9ka6yEmKQnLXhig=;
        b=np42iMSWqwCIOeNnR7Khdr6T8jOL3LM7ms1Ai+s2evLori532ANgXedEuYx8KYrtFT
         poRKKJxDLinbP3oHqxLye4dq8R1gvX2Op0lLjWbrnxB05iSUnWMNHOeZRcT8p1PNiroa
         L0AbnTROTeiJykDIqq7Sg5zKO6h+ajrqi26EvGLWjyYe+9MGLjQaOq8MaV2kqx0P+MPX
         nGCWD1CaRlXfZiCaFNzusqjY/cJ+Icm8Qw8pEI59+SG2/gxEx2hgyIk1Zzg/ZlVh4gBw
         SjPbiZCGoYqfBounFFZVbMAaAfk8t6V1VikifLOaKf1YNtoxXZKm1nMGIIyUcSetRE7r
         ZiFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vNnvqn3cTsS8jE6Oj+nGIHZ9v3Kg9ka6yEmKQnLXhig=;
        b=lXs6wNE302ZAIvrqTJ541Pp5rHJaBEVVg/+0QwXYn4rxs0L4hh+CUlQuBRBZpxIdZd
         LrwsKK2318GshQrwDam3uTqSU56rFBML7VYP4zIufoC2KrPFogrmib039+4tRBcY/e+w
         Fwv2nj80NTu+J8PKxr7l6DGDksmMDNgr0fz0m1ZSoyE5AWTfpybqjVN/aj3ahyZqV1n5
         N7EBfTQ9T4GT1laK9HZA0HwG2Pg9m2SgowTAlV7AW2U2x2okiiL5C8AXdmxKYunlQhay
         KnpnfsOj68dCj6CqeIraMXBdXtGLf1APDJ7z//nOroziAsMOZUqcBrvGDyLT4gXGVrCE
         Bgfw==
X-Gm-Message-State: AOAM532XYa430PKfCvc5RlfXANkEEH1lohr4Rb6YWO38mGDu13VP/dYO
        6z8tvTVdj7tNdPZiGRHj65SDymKL+1PRUEcQ
X-Google-Smtp-Source: ABdhPJz211RtR8NfyhDikdND+O10IdxJTEF2d30iSC/noSbpsLmFJ3p6L0QnZU8bZR/X9Y2Iqhsp3w==
X-Received: by 2002:a05:6602:150c:b0:64c:6878:25ed with SMTP id g12-20020a056602150c00b0064c687825edmr8267255iow.27.1648573665247;
        Tue, 29 Mar 2022 10:07:45 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a5d9483000000b00640d3d4acabsm9383069ioj.44.2022.03.29.10.07.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 10:07:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET 0/5] Fix early file assignment for links
Date:   Tue, 29 Mar 2022 11:07:37 -0600
Message-Id: <20220329170742.164434-1-axboe@kernel.dk>
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

Most of this is prep patches, but the purpose is to make sure that we
treat file assignment for links appropriately. If not, then we cannot
use direct open/accept with links while avoiding separate submit+wait
cycles.

-- 
Jens Axboe


