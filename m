Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9830E4ED941
	for <lists+io-uring@lfdr.de>; Thu, 31 Mar 2022 14:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234232AbiCaMHu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Mar 2022 08:07:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233982AbiCaMHt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Mar 2022 08:07:49 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25483EABD
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 05:06:02 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id x2so23203434plm.7
        for <io-uring@vger.kernel.org>; Thu, 31 Mar 2022 05:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=AWiPUcw4u/78EyL+R5HOco7m2qLKGFC7N4h40AYC66s=;
        b=p2vZ0dAilaxljpYsXLfKmdTFooYdX0Cy7eKddt+hr3w5p321TlogBTYHVCl/leoofp
         38JtSMBIgXVj3UCnQ/0ebmWNhChVkpqjG0Gaza++JP5ppCfXrDQhTQOilh3wf/iZsIcs
         T44m3iXEWBv6eA5gMNFHrbLLDN2ZlisJCjqxg1TK4VxdD2cqMUO8alTDEUl7nymIsBTz
         zx8BkHI8uQRVFCd4/qUj2PCT2md6nvzeM5TnBMXR5wZBMTcLqeJP//Y0ZO676b4/1T/X
         zcSAPRM7xUMVoqEm2WHG2wLLaVUjcsSqXgbvLCAWD1EMQTKImQb0/7Km3NWY4rCGLk4i
         70+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=AWiPUcw4u/78EyL+R5HOco7m2qLKGFC7N4h40AYC66s=;
        b=N5O9UcT4KHy0+rlpfRDpnD6+Fk2YYvNX6uVIiRqSt1JtI/dvQBrOGAJxF2DFUC3Kuz
         6vrdzWmiw4YBsajMJhIfcvizzoBLfSVCuk3fAtSe+0Mt5t7SMypXLmpPBLZurFGUUNn0
         +l2THylyJdI+gCujW2jVcEu5BorZ8A1z0QPoRm9SZUp+9g7scHMbJe7+EUFMfNxOlhWU
         fW080jiZNyNpho6YnL/w3Awtg26ge6dlOKTqBTi3LqFS+BMsPGNprT3UJH8GfAFrHmpa
         AidSvf0KgwVvj6GGDGv5vUIvbRZRTO3saTkzmAr7E4o1BKb53BSgWS6sOg1kEJtplJdb
         wRNg==
X-Gm-Message-State: AOAM531NUIOzGT7a0o52zg1ECOgcEMCKNag0n4dGxaaPGAzpn4vMuB7C
        l/R2uakY8vHk/hqwdTNY9qy+Rg==
X-Google-Smtp-Source: ABdhPJwVG/HonqEkvNd80mIVqnjDWe50Vnj0Nwgy1il3/F6wiGeInf3b8Pjr+M2lyNL+j6ZyZ2tXZA==
X-Received: by 2002:a17:90b:1c07:b0:1c7:5324:c68e with SMTP id oc7-20020a17090b1c0700b001c75324c68emr5724952pjb.202.1648728362083;
        Thu, 31 Mar 2022 05:06:02 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j18-20020a633c12000000b0038204629cc9sm22613616pga.10.2022.03.31.05.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 05:06:01 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     kernel-team@fb.com, Stefan Roesch <shr@fb.com>,
        io-uring@vger.kernel.org
In-Reply-To: <20220323154457.3303391-1-shr@fb.com>
References: <20220323154457.3303391-1-shr@fb.com>
Subject: Re: [PATCH v2 0/4] liburing: support xattr functions
Message-Id: <164872836104.7822.14431301848392143198.b4-ty@kernel.dk>
Date:   Thu, 31 Mar 2022 06:06:01 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 23 Mar 2022 08:44:53 -0700, Stefan Roesch wrote:
> Add xattr support and testing to liburing
> 
> Patch 1: liburing: update io_uring
>   Update io_uring.h with io_uring kernel changes.
> 
> Patch 2: liburing: add fsetxattr and setxattr
>   Add new helper functions for fsetxattr and setxattr support
>   in liburing.
> 
> [...]

Applied, thanks!

[1/4] liburing: Update io_uring in liburing
      (no commit info)
[2/4] liburing: add helper functions for setxattr and fsetxattr
      (no commit info)
[3/4] liburing: Add helper functions for fgetxattr and getxattr
      (no commit info)
[4/4] liburing: Add new test program to verify xattr support
      (no commit info)

Best regards,
-- 
Jens Axboe


