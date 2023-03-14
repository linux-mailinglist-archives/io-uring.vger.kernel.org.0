Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1AF6B9CD3
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 18:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbjCNRRZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 13:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCNRRX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 13:17:23 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A2DCB1EC7
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:05 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id s7so1384619ilv.12
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 10:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678814224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lefiG/uAkEcV1BRyRf/HRKxbon4BPGRBCOKPSS2VBnk=;
        b=3mWctYrDQAaBfFITDTjAmFPmmjArIlYCzeBoHbyh3DsRHR3qRyWPcnzOD+63Uaesqr
         Wh9lhQRwaXe7yvyl3W/xGOBzah0Qlr0xKd8X0YFJ7Y613KITP3zUYWEsXQmKK/mucLs8
         eiNzGYP+9CdYwM428vAwzXwpiTxSA30220ZOep9Mtzd7sUZ9DhaJkQOsGlQ+Usl2lRQR
         X4OzoxNKlq5kZkMNbH7gECUz/721a0t+oILbfxHx/YKqOfG37ab6y2ygHaY8FwOXVVH6
         a2vOOR1HDWpxzociRkOGF52kmpVKmEZNOptcDi8HeksmTWQI2xgzvt59dg7dt1INQn9S
         7Hng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lefiG/uAkEcV1BRyRf/HRKxbon4BPGRBCOKPSS2VBnk=;
        b=nNbvquvrqLWP6OasnhHGU1qyKyXD6f/98BuzMa5xYvtyLhqfG8lWpcf0/Q2M0zTI5i
         yBlY60CjC/R7mwdmueEMXxf7ss7TspM1GZl3uwLpvswpm0qytJqGEaKhvrmT/J935xy9
         51R3DSVS3WQj3xwc1KzF54FC+ieFjZrNTdSD8cbiNKizt5AwThAsrD1MvbrebchotPJs
         8xR3qHA8qHMHGTE7c7GhswAUECRpm/8RHo+LRte6V1oDNZKjn7LVO4FP9Y27GkQO7Ybg
         eONILljspFGX7X3erhU3AK1ED2Rhr9e+0h8NNCufE7Y0hZ+FGlD27+OAe9RSlilw0z8a
         FN1Q==
X-Gm-Message-State: AO0yUKW3cso3dvreEtTn7jrQQzt/BIYim8IBGWD/H5XsT0LQrl7Ps/id
        b6zCzYqmDMLpoG3GISrFlszC8j5ijR9G4FiRnJPboA==
X-Google-Smtp-Source: AK7set/qSosqb1GYFHPq7tUKZzwQMEwN3678C+QoiNk2JcZabLsnuXJ/aK/x+JRgCN0SfRVBiR4yzg==
X-Received: by 2002:a05:6e02:1d16:b0:316:ef1e:5e1f with SMTP id i22-20020a056e021d1600b00316ef1e5e1fmr10774837ila.1.1678814224144;
        Tue, 14 Mar 2023 10:17:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o12-20020a056e02068c00b003179b81610csm948950ils.17.2023.03.14.10.17.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:17:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     deller@gmx.de
Subject: [PATCHSET 0/5] User mapped provided buffer rings
Date:   Tue, 14 Mar 2023 11:16:37 -0600
Message-Id: <20230314171641.10542-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

One issue that became apparent when running io_uring code on parisc is
that for data shared between the application and the kernel, we must
ensure that it's placed correctly to avoid aliasing issues that render
it useless.

The first patch in this series is from Helge, and ensures that the
SQ/CQ rings are mapped appropriately. This makes io_uring actually work
there.

Patches 2..4 are prep patches for patch 5, which adds a variant of
ring mapped provided buffers that have the kernel allocate the memory
for them and the application mmap() it. This brings these mapped
buffers in line with how the SQ/CQ rings are managed too.

I'm not fully sure if this ONLY impacts archs that set SHM_COLOUR,
of which there is only parisc, or if SHMLBA setting archs (of which
there are others) are impact to any degree as well...

-- 
Jens Axboe


