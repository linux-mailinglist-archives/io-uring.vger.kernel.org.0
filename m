Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBC15505BD1
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 17:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345602AbiDRPtz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 11:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345800AbiDRPtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 11:49:22 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425BB3D1F2
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 08:24:33 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id t4so8709941ilo.12
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=aOnNCxMKq+/Rsz/pFginayE+NCwvi9hoip6Zb+pVRbQ=;
        b=klhKmb1jMRt2vRyHrqlQ9ox3qk53pBSG3QZGDyuIe9pgcC3rqwjaEjIianiVQyGb2W
         KzANTAiouGJJrgjeUyOhT8s+OZZH9rlIAcUNYr7Mqi4M0KVrVk9p5W+uq5DscvHZEJoP
         CP+Jh+Ir4G2BAANOdlUPK+kSXdy5OP2nOqcNz07J5Rc/iPEUF/Bg8iJSNx5QC6u8RM/3
         E4vE4hmeMS2Nd8DQTCqQCUOxtfapE+6WRF1fwmCWX4J+Aqmn18pFtz1GiMy8ZLCcHtlw
         a7Htuy1fpHI7SkOX7x2p4RWi1Uw2qjtwso8I1C0leZQrHe9XKtbO5DLM6K/YbMiscnXF
         XEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=aOnNCxMKq+/Rsz/pFginayE+NCwvi9hoip6Zb+pVRbQ=;
        b=CrECyQIv4t0PzH71i3dROzBpAIjffkvhrB0ZG5lMqNDvWgE4cNhzISKjG9VtTd5NK+
         Mw0cx2uCR9JKkp6a1VAMEdl9TrBIfpMAzGF3LKLDhkyvJGzT9ux6pV+I/9yEAEA9t/DV
         0LAqHOY19VnQ7nk5xpoOGD1pygu+6wc3Bq7KGarH3JaE7ZDRNIMpehqKNi481TpPH048
         bfjeDQlXAtk+po3H0ENWKlZFQzFaXaTziMRER2TmvKLm2cTAzjyebritHc76uKojkbz9
         KjhDggELIMMZITKA9WA7WBJ2LjXahyC84RGyco6ieGds9dMQpbVVmHW3mRb/PmsrZ7K4
         8GiQ==
X-Gm-Message-State: AOAM531AZJ4eFBdp33XRparDRfHH8s0/mi0E3PqXO03cKrrtxKx+jQAV
        wblNxnGpIL6qcTua0Wnndb00dG0ZnVw20g==
X-Google-Smtp-Source: ABdhPJz9HUZ6kVPeND7Cs/c7g4zZPPy2e4Fbz3C4BNaSq3Fv+CyojIRbKJTzL+BDsz5oveeee9YmvQ==
X-Received: by 2002:a92:9406:0:b0:2be:6ace:7510 with SMTP id c6-20020a929406000000b002be6ace7510mr4670240ili.291.1650295472381;
        Mon, 18 Apr 2022 08:24:32 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id 5-20020a6b1405000000b0065064262ef4sm7107892iou.30.2022.04.18.08.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 08:24:31 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     ammarfaizi2@gnuweeb.org
Cc:     gwml@vger.gnuweeb.org, alviro.iskandar@gnuweeb.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org
In-Reply-To: <20220414224001.187778-1-ammar.faizi@intel.com>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
Subject: Re: [PATCH liburing 0/3] Add x86 32-bit support for the nolibc build
Message-Id: <165029547167.51424.16558504366840819458.b4-ty@kernel.dk>
Date:   Mon, 18 Apr 2022 09:24:31 -0600
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

On Fri, 15 Apr 2022 05:41:37 +0700, Ammar Faizi wrote:
> This series adds nolibc support for x86 32-bit. There are 3 patches in
> this series:
> 
> 1) Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit.
> 2) Provide `get_page_size()` function for x86 32-bit.
> 3) Add x86 32-bit native syscall support.
> 
> [...]

Applied, thanks!

[1/3] arch/syscall-defs: Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit
      commit: 2afb268164ba99ebe720add3632b4051651296b6
[2/3] arch/x86/lib: Provide `get_page_size()` function for x86 32-bit
      commit: 48342e4c482349718eeecd34b3026d3d6aa78794
[3/3] arch/x86/syscall: Add x86 32-bit native syscall support
      commit: b7d8dd8bbf5b8550c8a0c1ed70431cd8050709f0

Best regards,
-- 
Jens Axboe


