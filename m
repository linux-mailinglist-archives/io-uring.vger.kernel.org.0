Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4847698B25
	for <lists+io-uring@lfdr.de>; Thu, 16 Feb 2023 04:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjBPDYd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Feb 2023 22:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBPDYc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Feb 2023 22:24:32 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6D5C7
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 19:24:31 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 16so606506pfo.8
        for <io-uring@vger.kernel.org>; Wed, 15 Feb 2023 19:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676517871;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1CxXVwJvCGxbjVLdA6DHb6xyckHUyCHSVSgGkRQjt50=;
        b=N1C4S8OUx3gL48Sj22kdzKzqy0JlUSEyWkZ0wJxR86y2BOMoEiNuED9/wIqYl6EafK
         UCpBXcIsvZycdO+9oxLFg1mhbiWfDBuCjlB8kD0m/5/vFAvpzxwIza1+ZeG4KQTUFaVU
         Jzynds2ptMKi0PrMqw89enoLR+pjpgl20IyOJ92NvrWhuw/NvTuSUPwcoT4S6upG20YV
         o2VrWzWzfphHfQGCsabLrbYRLjKHmfew99RjxOiRV6JglhcLG6URl3Ccw2CQ8+GFg/jx
         NczQt+PC0oZDNRAwYzkqGDVaJM1APtTnXub6vKWalMgiDCsCi/9IyOv5qmzRCYaw/bSe
         JHAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676517871;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CxXVwJvCGxbjVLdA6DHb6xyckHUyCHSVSgGkRQjt50=;
        b=tRDL/+wQRnizImdpcAZJ2ueKB9GaandmmzLdWB/TRfzMGm46jQoZfwJ/wQ+rcn6Jru
         aQxj6GofopJaY+PqZMxRh13O6WltonVwb70tz+gnBp3/mkrN3Ifew4itC7jmYVviRXfH
         dGO97WuMfRS6M4Hq0EMq2c9ywrdrXMAqEywJLzzT76Q01ueskyS8boGum2ME7EpBGuO9
         IaTORoWRiFiZD4mKCWXvWMKCneuIdL7YgUlS0flNwI4DM89wer1jDiIIoyzp2AUbAYlT
         ZYyOia8oj/iXbMwL9H08iNyjvkuxI37VNdfhCXxSb1eLW7fcyhmTNotf0F+V44nMWWhq
         QbXw==
X-Gm-Message-State: AO0yUKWpemAUGaWJO3IAnUwySV7HHGwwrMK0knsDwaSV5yBjlXtu9sgv
        yQhxGQxucvcz7AcdtxcpUTUUlw==
X-Google-Smtp-Source: AK7set9iGY1Slp6qvesKRBrqY77wNZOHJDRfriucWC07srPWSrUoHNZe7WZvzaiVlzXi52QGYIk/QA==
X-Received: by 2002:a62:d104:0:b0:5a8:bbd7:d7aa with SMTP id z4-20020a62d104000000b005a8bbd7d7aamr3596157pfg.1.1676517870626;
        Wed, 15 Feb 2023 19:24:30 -0800 (PST)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id a13-20020a62e20d000000b005906dbf5f80sm85300pfi.163.2023.02.15.19.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 19:24:30 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
References: <f2396369e638284586b069dbddffb8c992afba95.1676419314.git.josh@joshtriplett.org>
Subject: Re: [PATCHv2] io_uring: Support calling io_uring_register with a
 registered ring fd
Message-Id: <167651786995.206662.11602698726754502938.b4-ty@kernel.dk>
Date:   Wed, 15 Feb 2023 20:24:29 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 14 Feb 2023 16:42:22 -0800, Josh Triplett wrote:
> Add a new flag IORING_REGISTER_USE_REGISTERED_RING (set via the high bit
> of the opcode) to treat the fd as a registered index rather than a file
> descriptor.
> 
> This makes it possible for a library to open an io_uring, register the
> ring fd, close the ring fd, and subsequently use the ring entirely via
> registered index.
> 
> [...]

Applied, thanks!

[1/1] io_uring: Support calling io_uring_register with a registered ring fd
      commit: 04eb372cac91a4f70c9b921c1b86758f5553d311

Best regards,
-- 
Jens Axboe



