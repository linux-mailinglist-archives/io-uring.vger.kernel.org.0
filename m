Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9879BA66
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbjIKWKF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244543AbjIKUkb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 16:40:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F1F1A7
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-68e3c6aa339so878563b3a.1
        for <io-uring@vger.kernel.org>; Mon, 11 Sep 2023 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1694464825; x=1695069625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NM/rYxfi60wOxmBRLrySZoZz5h9oz3/bbgbtBuEWIcE=;
        b=WSYmwC2WzXh5ADXyQbL4DocdexUTOppr4kpasHmIrpCa26zArQTHR0/gBLY4yR8Zrv
         Y10wfPTOv2c2LzQSb3VezzCgtSD27ewLQ2oTnQtLojg0ZOFoTZc1Rt2r2y4H+xIecUGB
         aEt8A4dEbpJTlpMms0eoCnuXtn/+FgMsCwq8Ryce/rwP74FPGitD4ohIOhRhG2mnn2eZ
         yUcrGL6DdIe+ZWJQDF86JYOXJzg5EgIU1LOcZ+My6GXC0s1GckQQO468Z7rGxt7Fit61
         lljIlq4p3472A4R1qD49a0iFc4BDsHHFUyCIyVASgR4G6j+NnbJmMLGu0CAihpExa6SG
         TsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694464825; x=1695069625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NM/rYxfi60wOxmBRLrySZoZz5h9oz3/bbgbtBuEWIcE=;
        b=ORZ+8bY8BHZT8LY93VBic4BcS8Qfu6ogOEpsJ3BcZXCIpuVJHc2x/j/id5uA3NyAHW
         7QIofUZYh/P7CAdxL4mLRqOBQWuTjJVRRZV53fJzWuoVhLVm/jh7IBUYNDhrEDtssr2g
         Ie7mYr3pJpSVOmUIRFe/MRRtuo6vkFTdZW9xVaMrt4zeJ9J4E6t/5n8tQMWHuEtJ880T
         eU5cpFCNIfPN8k0LxRzrL6YbnwW4PJkenyrttRaAd1gjB+NFtB+61aQ1Ubw5BC1LTzQM
         JTNeLmmoQwCqPHs1DWIlHesPdC15V9NPHc4EQpV2blwPI2KgHtqHJyTWXxWt3Hx5CpBx
         F+Iw==
X-Gm-Message-State: AOJu0YxuGQGu8YsTPst40oOlwJXVLK1Bdm5SkAWvd30uSax+feGlYQCq
        BTPR/DJj2tEV9pnI0pphac7RUaUr7d4YDPkHN3+/3g==
X-Google-Smtp-Source: AGHT+IFseReyAc2r6ZU3E1AUp7ItA0e0fUU05APHq9UaNTTRVat0DYYHfTra+3kmwNDWJ+gJiktYXA==
X-Received: by 2002:a05:6a00:2b86:b0:68c:7089:cb8 with SMTP id dv6-20020a056a002b8600b0068c70890cb8mr10648912pfb.2.1694464825445;
        Mon, 11 Sep 2023 13:40:25 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ef22-20020a056a002c9600b0068fe5a5a566sm100544pfb.142.2023.09.11.13.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 13:40:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCHSET 0/3] Add support for multishot reads
Date:   Mon, 11 Sep 2023 14:40:18 -0600
Message-Id: <20230911204021.1479172-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

We support multishot for other request types, generally in the shape of
a flag for the request. Doing a flag based approach with reads isn't
straightforward, as the read/write flags are in the RWF_ space. Instead,
add a separate opcode for this, IORING_OP_READ_MULTISHOT.

This can only be used provided buffers, like other multishot request
types that read/receive data.

It can also only be used for pollable file types, like a tun device or
pipes, for example. File types that are always readable (or seekable),
like regular files, cannot be used with multishot reads.

-- 
Jens Axboe


