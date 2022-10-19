Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37D7B60524B
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 23:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiJSVya (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 17:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbiJSVy3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 17:54:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6920D13DCD
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 14:54:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x31-20020a17090a38a200b0020d2afec803so1229139pjb.2
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 14:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dmaiG0mqhRVhDlkwxyR3vqIrwy7kD//8rZBjTNS4ZCY=;
        b=xij/oxAKlurU/mjfYh6DELZTmKOIxn/TrKqPDkJGdxW0bwBWz0rzVWIPR/wD9GuMUS
         5MJysY950JwuBRGLzlLeQzdrNuJ3A7JIsk+5NnsP7mJ7tCqA01lx2aulb0aeGh01dA/H
         BionALeTklzDKL8seWyyAGi+gni9IPfWaylVQ/C2CTtALm1yOsgLfOtYh8yLjRhApWsh
         RIH+ZELaJy97DSy5thjg8kWFF27NrVGKSNBlkds4lUW90v+sZRraPN0YrF8M6kS1AGyx
         lXNrpPRSvB0V80YEFI+L6KApNxKR58KHcDhjV0x9zpNUid/OjGc0806VKHKmPUkaQoHI
         hTIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dmaiG0mqhRVhDlkwxyR3vqIrwy7kD//8rZBjTNS4ZCY=;
        b=LtAaNV1pa472idDIRiFqsoK4LsIVex7Poc18/MZoY/EQgSqChlVaXmuWA5SXMbLCic
         VhFjpaaPIoFy1eWkNIvTKyDQ1SOwG2CI0VAnyiDKbkVQBIXQ2Mm7f0B8JhPmFlaAEXFF
         M9USL4a+WHUJyuIje6wttO4vbjG5B20uYiSedvtytks6o3IzMHncUSv1yCJti/DoZZZn
         FuhKR0fzmVhc5+sALQjuySHQ75wtv8GDhknzhzdSOvplR9AAHFiSw5PWgGoi5MHCJh/w
         qVcvSRXRRoRdnis3TtxiacHxxayoZwly+HDdq/yD4JaaG2iMMr/c5nAG2ZTjLS/SGi3m
         Gxlg==
X-Gm-Message-State: ACrzQf1bQL20FoPsy36BaQpVL5oU9LDBSRIxEkhAPLdjAhhg1u67GO9t
        rtrqt/TBc3htM73zdd0/2W10R/pWpSxsOj7C
X-Google-Smtp-Source: AMsMyM484jKcBM3ePeMhhk993p0ReJ+Zi1ns8/mB6AubjJqSd94JmHXqrS3j7mJ5Yl7lDvLs9k/F0Q==
X-Received: by 2002:a17:902:e982:b0:17f:ca1f:aa44 with SMTP id f2-20020a170902e98200b0017fca1faa44mr10598586plb.76.1666216467365;
        Wed, 19 Oct 2022 14:54:27 -0700 (PDT)
Received: from [127.0.0.1] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902cec500b00178a8f4d4f2sm11186255plg.74.2022.10.19.14.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 14:54:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
In-Reply-To: <41f1cf670c1ac33adf263942b8ebc68f3b32001b.1666210567.git.asml.silence@gmail.com>
References: <41f1cf670c1ac33adf263942b8ebc68f3b32001b.1666210567.git.asml.silence@gmail.com>
Subject: Re: [PATCH liburing 1/1] tests: use only UDP/TCP for zc testing
Message-Id: <166621646676.138165.4200681713071828531.b4-ty@kernel.dk>
Date:   Wed, 19 Oct 2022 14:54:26 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailer: b4 0.11.0-dev-d9ed3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 19 Oct 2022 21:17:51 +0100, Pavel Begunkov wrote:
> The initial implementation only supports TCP and UDP, so use them for
> testing.
> 
> 

Applied, thanks!

[1/1] tests: use only UDP/TCP for zc testing
      commit: 63561adfcb81062e9a394a570073883171d6c8b0

Best regards,
-- 
Jens Axboe


