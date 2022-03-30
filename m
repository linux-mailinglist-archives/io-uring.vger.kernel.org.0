Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1508E4ECE15
	for <lists+io-uring@lfdr.de>; Wed, 30 Mar 2022 22:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244302AbiC3U3e (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Mar 2022 16:29:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbiC3U3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Mar 2022 16:29:33 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B3D36B70
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 13:27:45 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id q11so26172061iod.6
        for <io-uring@vger.kernel.org>; Wed, 30 Mar 2022 13:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=bO7j0SrMzPYX9+tPRcw8XwDRSLZtiJmDxQySnumKTUw=;
        b=mvsSSIQCR2Lr9bhzy6pnBtpj3uqReTguuxE7BtSYf3jf8X0UdthyFqLJjbdo0HYlIL
         WJP2xk0HV7Jf87RvACN1dxoZNPI+MUWkWPJByNXwK8asokjchD3+mzImnzIMZoTCaEOU
         r5qC8A6XYydVrBwa2bbdVxf1uw5e0ZEah6/AyjRy0caSzA7AN66h8SxsHzC92WNmEou0
         8pW1apce+FYmPjEor1iJK3DxHYvQaOKkUmCRZgPAERP+7dzByyL7lpOKY8UegRKp1O/d
         MKv7mQq/xDoO1PC8fOGLRaSC62tD4jh7/OO0AGeQ/NF7X6cHwRbIm4oOQEu7/8pxModH
         n66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=bO7j0SrMzPYX9+tPRcw8XwDRSLZtiJmDxQySnumKTUw=;
        b=VSRR7zWPeN7zuZxRUudzuypL0UWnddCKoVe4lErofoy5+NaVDQLipa2x7ZDlLXJ7YZ
         OqFa5R8FzG3ZwvrSIyTndNh8CCwvZMEc2PyFKncmDC2mfrlXPC6UgaNinn4bJoLGnniY
         BqZJfo5q6B9+dEeCREWBKdJlbR1Ds7eirVhDZEIDLkM2CMM3HiV5SCpv4hGtB+wlEIV6
         K+xXhtyFaWrzhIlNMIhNi8xdSoxDppejR2mHJA/Bc/r04SMLFUyexBeLjkyA+WC+o0Ad
         s4CR5SzWZVbGvfgAnid3Qu29GRGC4uOy2PViDZxgBOiajBQ21eTCO/SHhYWjIt708S3S
         bI7g==
X-Gm-Message-State: AOAM533/mkwmCU0JYl+dallgl8n4IU3RS694kKgpclJs3rb+k/wUIwx0
        J2JH5c/VvA0IMvcZV4K122fu/g==
X-Google-Smtp-Source: ABdhPJzLP8f34rH3mSZEj+s9WwKrpGWdjaSjRjDGXnMgQklV+T+EUCruxSaY9dFbPAotssJ0CfpwxQ==
X-Received: by 2002:a5d:840e:0:b0:649:c671:6594 with SMTP id i14-20020a5d840e000000b00649c6716594mr12785783ion.19.1648672065238;
        Wed, 30 Mar 2022 13:27:45 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id v3-20020a92ab03000000b002c9d9d896eesm2486877ilh.68.2022.03.30.13.27.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Mar 2022 13:27:44 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Stefan Roesch <shr@fb.com>, kernel-team@fb.com
Cc:     viro@zeniv.linux.org.uk, christian.brauner@ubuntu.com
In-Reply-To: <20220323154420.3301504-1-shr@fb.com>
References: <20220323154420.3301504-1-shr@fb.com>
Subject: Re: [PATCH v13 0/4] io_uring: add xattr support
Message-Id: <164867206347.288397.17239948549986263927.b4-ty@kernel.dk>
Date:   Wed, 30 Mar 2022 14:27:43 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 23 Mar 2022 08:44:16 -0700, Stefan Roesch wrote:
> This adds the xattr support to io_uring. The intent is to have a more
> complete support for file operations in io_uring.
> 
> This change adds support for the following functions to io_uring:
> - fgetxattr
> - fsetxattr
> - getxattr
> - setxattr
> 
> [...]

Applied, thanks!

[1/4] fs: split off setxattr_copy and do_setxattr function from setxattr
      commit: bbe6239e931bbb57983dcf94eacc8aaa757d26b0
[2/4] fs: split off do_getxattr from getxattr
      commit: 9c8ebeb51e866b9d0fa16fa628797d7e9483a6fc
[3/4] io_uring: add fsetxattr and setxattr support
      commit: 7c0773d493344a03e40a71c66fbe080c1fd87acb
[4/4] io_uring: add fgetxattr and getxattr support
      commit: b2fdcc6667b89e4da68b5543b641e809145432f8

Best regards,
-- 
Jens Axboe


