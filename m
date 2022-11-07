Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6A9A61FF6B
	for <lists+io-uring@lfdr.de>; Mon,  7 Nov 2022 21:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbiKGUSO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Nov 2022 15:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232398AbiKGUSN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Nov 2022 15:18:13 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CE4192A1
        for <io-uring@vger.kernel.org>; Mon,  7 Nov 2022 12:18:12 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id q21so6956496iod.4
        for <io-uring@vger.kernel.org>; Mon, 07 Nov 2022 12:18:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PWVHELIA4JZujIu4GdRj/WKoXShCLkw2CfTZ/fmgqM=;
        b=A6cLXqZOVAw0YQBSJZm44wJ8l9KOdoYQ8KOIJiTjKNRTTSYsmroqRhk5xJL/lNDIAD
         Zqq8qN9+9Nd5vWH9C3wiiGN2hPME83CKWtSBTDbjY8Q3Wfyw2tLSjUFSPRk7ETZBrEh/
         SsmmwfNO4Qqzf0OY1ktvGIBGI5RepoyRMlVr2mNT1E4MY1wNM5jcIGzzhMXen7om7xqG
         VFCR9cM0z8K0GgiTTCT4YCe3/akAkjairc0MJnebNl1Wdqr9FaWm2RjJkOGvVORAyMXQ
         xdLKz6qVZynYbHVOsWdhYPHcm0vG4rAHdecGP/TGtGDcGNg5QDuPLXCJLenIKs3gaDdU
         HMBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+PWVHELIA4JZujIu4GdRj/WKoXShCLkw2CfTZ/fmgqM=;
        b=2dEhQPlC+stGmtSHqZzf0GkfHPFKNPtVHAEkXAGFOVT2H72w1l5cSvRnCvTL1xHhSi
         mkttHYv4FyU5w3Ld0l2LLG8N4Xi8rbHjpXajdHcg+fZFWx3QduQmdhs+vvHwKqejmroY
         t6BU8L//NzPybilQi/kEzxqAmbxrTw8xtmZ8YtwjHwHKR02LTrAbeGdyGnOf1ykfDgqq
         S8McNMHgftwk8KUvGhDXG+poeOQhhVSrv6sZ7Nj4/vXulWpwQBBRyooMvi6+jyDVpbvG
         iBCgw6j1dBnW4gRZaQTqRMfsHTSQcUck6nP9HPQ8LJTGcepsAgfwgxCaRcJUhPU+Pl24
         sjNQ==
X-Gm-Message-State: ACrzQf0BsYT32KNVm/Kcy43vVluWGixQ8mfhpKMZReP8g3INnJ5SLVyU
        HXwmY8igDKw4eeWwLANld6PlkP5Ba7yhDlEJ
X-Google-Smtp-Source: AMsMyM4kQB99Xwkav8xFyuBRYScxlsqb6G1x801N3sP7coFdug5Pl44EnWNv3VCUj/337h6eXkQmnA==
X-Received: by 2002:a05:6602:2b06:b0:67f:fdf6:ffc2 with SMTP id p6-20020a0566022b0600b0067ffdf6ffc2mr32645438iov.111.1667852291491;
        Mon, 07 Nov 2022 12:18:11 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q3-20020a056e02106300b00300e7a459aasm3129010ilj.38.2022.11.07.12.18.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:18:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Dylan Yudaken <dylany@meta.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, kernel-team@fb.com
In-Reply-To: <20221107130404.360691-1-dylany@meta.com>
References: <20221107130404.360691-1-dylany@meta.com>
Subject: Re: [PATCH liburing] Do not always expect multishot recv to stop posting events
Message-Id: <166785229052.23588.9277094867339486082.b4-ty@kernel.dk>
Date:   Mon, 07 Nov 2022 13:18:10 -0700
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

On Mon, 7 Nov 2022 05:04:04 -0800, Dylan Yudaken wrote:
> Later kernels can have a fix that does not stop multishot from posting
> events, and would just continue in overflow mode.
> 
> 

Applied, thanks!

[1/1] Do not always expect multishot recv to stop posting events
      commit: 0d4fdb416718a70a4a90c5c4722b38cf44849195

Best regards,
-- 
Jens Axboe


