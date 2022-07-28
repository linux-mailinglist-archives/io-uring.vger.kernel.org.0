Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 407FF583FA3
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 15:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239040AbiG1NKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 09:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbiG1NKR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 09:10:17 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4204363CB
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 06:10:16 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d10so1882686pfd.9
        for <io-uring@vger.kernel.org>; Thu, 28 Jul 2022 06:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=2NVf+itYTntZxP9B0iYHti1/imfgFu1hLm4YzestRpU=;
        b=hxaHAu18W9By/GDUSysQJrn9eV9niftD58DkOuPqw5yC+eRyUZIU/OzNLzDNqeIIVy
         kriUd3u71RJXMOj65MCLF1E1IWyovJSZNCslWciXDkAFlklfW9s8wRn4El3J//niFquO
         fz7qTvBfb1gOEJ5hBtNCXGK8Hcjv0MSikqUiumw7v2gvkyV+jdlgoDqp+1yZcyZ4kZBN
         CHw8c62OQ0MkwJQxbpL6gQ67EGorI8MKhRbxs8kXP7oxBiMsxqP6wdlY/Sayeynoe++V
         z4ns8cTnTnhciD5K3gpI6b6e9GYCcfRrk9lSbiICRF5AkB+IbcUKhuJfox0JkB+0j8Js
         JTyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=2NVf+itYTntZxP9B0iYHti1/imfgFu1hLm4YzestRpU=;
        b=iVVFLKkXHSeEyeREbFL5LslbJwXgRnc7fDMmMWOJkuyQVoh+PKst8tKgmY0zFgac6q
         QWrqwj04k6VYOaMsQ6IrnRbZEK+p8ha+X6/3GJs389Y2FG4Mru4c/q/5ykAC/31jFBjr
         gYgiWwWBSkZJC4Vq7kZhihcgjSfdLz9CJ2v/0Xy4Ap79y4rkO+ngDdYlfwzzI8pSKHnL
         Md1UbrWDtYqYPWGfHOD+f08LrwIMzPMj5igqRPR/bpW3YhQ4j2ex1cZoLAA0Foi3XAIa
         72JOo7p9QoETkwpJV4UoTDChW+YXDljZZhQJ0MubTksGln9pMht+gkQCkbnkQZoPqP9b
         D+gw==
X-Gm-Message-State: AJIora9KzM8TpYAnyYMr8uaEYusoZG1O1jLTr+AUiG73660TDeZXwADa
        wEvmDNsMRSlMPovoKUv2mlGqhroXI0E9Aw==
X-Google-Smtp-Source: AGRyM1tHB7PLe3C10GtaGt7cu3vPHU6YYHhdXJP/RjiDBIuVS7fSapIv6EQY8/xoV8Md86QjHR/XUQ==
X-Received: by 2002:a63:1e5f:0:b0:419:d6bf:b9d7 with SMTP id p31-20020a631e5f000000b00419d6bfb9d7mr23408240pgm.593.1659013815739;
        Thu, 28 Jul 2022 06:10:15 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id w187-20020a6230c4000000b0052c456eafe1sm682039pfw.176.2022.07.28.06.10.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 06:10:15 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ankit.kumar@samsung.com
Cc:     io-uring@vger.kernel.org, joshi.k@samsung.com
In-Reply-To: <20220728093327.32580-1-ankit.kumar@samsung.com>
References: <CGME20220728093902epcas5p40813f72b828e68e192f98819d29b2863@epcas5p4.samsung.com> <20220728093327.32580-1-ankit.kumar@samsung.com>
Subject: Re: [PATCH liburing v3 0/5] Add basic test for nvme uring passthrough commands
Message-Id: <165901381508.1769583.17350291271011652053.b4-ty@kernel.dk>
Date:   Thu, 28 Jul 2022 07:10:15 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, 28 Jul 2022 15:03:22 +0530, Ankit Kumar wrote:
> This patchset adds a way to test NVMe uring passthrough commands with
> nvme-ns character device. The uring passthrough was introduced with 5.19
> io_uring.
> 
> To send nvme uring passthrough commands we require helpers to fetch NVMe
> char device (/dev/ngXnY) specific fields such as namespace id, lba size etc.
> 
> [...]

Applied, thanks!

[1/5] configure: check for nvme uring command support
      commit: 7fc6c1e89f1b83f2bb80a974a40126d10ab95d46
[2/5] io_uring.h: sync sqe entry with 5.20 io_uring
      commit: 893b9d13b7571eb99d124c0804c48e331b4dbe3b
[3/5] nvme: add nvme opcodes, structures and helper functions
      commit: 612101cc61063eed06d5bd232b1ab7a43732f227
[4/5] test: add io_uring passthrough test
      commit: b593422fd0d624b6d1a59d0cc5a674dfdf22db6e
[5/5] test/io_uring_passthrough: add test case for poll IO
      commit: ba10a0e0b3039aab43352f08631845f25aa2b225

Best regards,
-- 
Jens Axboe


