Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 133A952349F
	for <lists+io-uring@lfdr.de>; Wed, 11 May 2022 15:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237778AbiEKNsH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 May 2022 09:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231463AbiEKNsH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 May 2022 09:48:07 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86FE324F3D
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:48:06 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id p8so2029703pfh.8
        for <io-uring@vger.kernel.org>; Wed, 11 May 2022 06:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=7dUFOAr9HRSYaQk2tNQyvAWNs1vBs/f30/GWbXxlFcM=;
        b=RqEFXzLoP5oTZ+qyubaAnAlP+7ZVBm8acmBYu9H/Xiv36LUl8vBFMhqaO5mN3dGDS/
         e1xytbvscTavXRwgrErr3Apm05V4/rjqB0CpwyrAe3mX50a2UZ6S0xy0iy3vbTZR+Ydq
         a7m99ftDKbYx7ZSuIJu7jO/L9tiw+JJmOSyZQp1o+HamBuMNc0uiHDLBzch+C4yd7le8
         YztLRGpmqkGoR1+s80VBb+VlHwvEdniJYMPbLJXcuAgbfD7+GDacrYE3hHp8nvt6RJYw
         K6JSsis7tPhZVZbOwM1RBRSSl1z+duTVi9LFlQbKLn+RLqAns09XTBP1Gu//zXHADtzH
         kqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=7dUFOAr9HRSYaQk2tNQyvAWNs1vBs/f30/GWbXxlFcM=;
        b=IAN2II9uXMzWNRYOxqZnmSMaoynew1WMyGxWfY8c6GuaWUcuZw9A1K/qnlddF+t36/
         hW+KmF0KfQf1XjNp1u36k1pHFnDneBD7KUOFcAi+NJKE+Q7rpWZE5t3dm9DWN/z5/JMW
         UheMY4G1nZjRtq5/ho4J1ryiiOGjVKiKzy8pwNtKD3NbLw+7B07Ib/UO85yiz86Q8s7U
         m11IaS/i4409AvHtXXa4LUqKjpSKBsrbZC3KLe8Th2YYojSBsyv939BGOOQK9ZxlYFQH
         wzkN2Rp5X6oSxIps7D0tAxtF1Dwrx8No+l439AXJ4lMxz+xggEY5Mg2QEqUA6A8dbB2k
         2mOg==
X-Gm-Message-State: AOAM5303+FLMokOYolk8H92FOltEMAruWjABzAAOQw4GdVUQ73GmBd2K
        IfHB9RRviJBCXigcF/8N2Kc1aQ==
X-Google-Smtp-Source: ABdhPJxH4Q61wDahvW9YLo4TjvGtuXz0L3U7Z+ppbQpBtxhTE0wQq+/OhEsP7FJ/0EZ7O2smzzv6AQ==
X-Received: by 2002:a63:5d0a:0:b0:399:40fd:2012 with SMTP id r10-20020a635d0a000000b0039940fd2012mr21291391pgb.454.1652276885996;
        Wed, 11 May 2022 06:48:05 -0700 (PDT)
Received: from [127.0.1.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id y19-20020a170902d65300b0015e8d4eb273sm1888009plh.189.2022.05.11.06.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 06:48:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>, joshi.k@samsung.com
Cc:     joshiiitr@gmail.com, anuj20.g@samsung.com, shr@fb.com,
        ming.lei@redhat.com, linux-nvme@lists.infradead.org,
        io-uring@vger.kernel.org, mcgrof@kernel.org, gost.dev@samsung.com,
        asml.silence@gmail.com
In-Reply-To: <20220511054750.20432-1-joshi.k@samsung.com>
References: <CGME20220511055306epcas5p3bf3b4c1e32d2bb43db12785bd7caf5da@epcas5p3.samsung.com> <20220511054750.20432-1-joshi.k@samsung.com>
Subject: Re: [PATCH v5 0/6] io_uring passthrough for nvme
Message-Id: <165227688477.38900.11020258804345924077.b4-ty@kernel.dk>
Date:   Wed, 11 May 2022 07:48:04 -0600
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

On Wed, 11 May 2022 11:17:44 +0530, Kanchan Joshi wrote:
> This series is against "for-5.19/io_uring-passthrough" branch (linux-block).
> Patches to be refreshed on top of 2bb04df7c ("io_uring: support CQE32").
> 
> uring-cmd is the facility to enable io_uring capabilities (async is one
> of those) for any arbitrary command (ioctl, fsctl or whatever else)
> exposed by the command-providers (driver, fs etc.). The series
> introduces uring-cmd, and connects nvme passthrough (over generic device
> /dev/ngXnY) to it.
> 
> [...]

Applied, thanks!

[1/6] fs,io_uring: add infrastructure for uring-cmd
      commit: ee692a21e9bf8354bd3ec816f1cf4bff8619ed77
[2/6] block: wire-up support for passthrough plugging
      commit: 1c2d2fff6dc04662dc8e86b537989643e1abeed9
[3/6] nvme: refactor nvme_submit_user_cmd()
      commit: bcad2565b5d64700cf68cc9d48618ab817ff5bc4
[4/6] nvme: wire-up uring-cmd support for io-passthru on char-device.
      commit: 456cba386e94f22fa1b1426303fdcac9e66b1417
[5/6] nvme: add vectored-io support for uring-cmd
      commit: f569add47119fa910ed7711b26b8d38e21f7ea77
[6/6] io_uring: finish IOPOLL/ioprio prep handler removal
      (no commit info)

Best regards,
-- 
Jens Axboe


