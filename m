Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B356650E88A
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 20:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244542AbiDYSsb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 14:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244535AbiDYSsa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 14:48:30 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408A271F
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:45:26 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id 125so16856540iov.10
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 11:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=8QZYeqMmmPhtmGtzpw0dz6qMCroU1Z0OCHPZrzHg80A=;
        b=zHgr+QcaoRj/O/5MY6AVp3CGvJ0Tqzpd5+TJihBaJ/2irwwlF0FNrmLafvByQybFg5
         XxEapurPHOQszn3ADgJOLds2VWRW7QiK089DuXMlKZ7K23sJCE52gqLWWV2Gc3d7cQ/4
         8pr1jU2kZnq5pnnDz93O2sxXPJp7lDbOtdkkjS92KzcLqapGSEldmFGxenM7OqEUmuwF
         ioeAvf9Z2SE9h+hsQMchduI+z2Dry8bOaJ7vjys3CTRJsQrQnH8pgUGSE0Lnu8zqOkLk
         MotRRbpBatr2MvnsfOru607LKVjmv/Bx3j4+TtoEyjtNUyZvqDehRK5huwiq0+Ssgcne
         pQNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=8QZYeqMmmPhtmGtzpw0dz6qMCroU1Z0OCHPZrzHg80A=;
        b=4oFSMTNfVBGlfX6JcHkOBjfKUbQRWegbdRdObeY7nCfZkpbm91X0uBiywCAKT4ulzk
         9jU0pOD1qo4X+TEt5Fse2PxvRQLcDNZnNyhJ94LWBX6r2Z54wdFstTgGTigDyuS2gvMo
         usGOi97RAIslSiNiYtNxXjdRs2oCLJ/Dt5+oRD8VXuGneHNuVmYVpRbYgtWsk+snWL0I
         XSTV5PUx6ZuyeDx3XPdCossUlEB5zcLQYOd1SV32JJtZtK82LaUSSBVG/DYq//H1TaMM
         EX49ErIx3jHHPvd0XDeRtvquvnjSvUw6xcupfoq9HiO4ZogGVdReu5boUlSz0IFWuffb
         cp5w==
X-Gm-Message-State: AOAM533j+Xz0suWqOls6AwvzaqVcG9Chxp3OYVJ/sKNXDZVileebrNrv
        P2pRIbdrmo1R1jjQz2vri7DRYj6ypsEeZg==
X-Google-Smtp-Source: ABdhPJxxN3h32+5eWi1RE8tg3MbuF+HjSRf729ucqdG5uDEXE8h/G5gDN3OBbxR+TQsfGoiRorOVgw==
X-Received: by 2002:a05:6638:2588:b0:32a:beec:a5cc with SMTP id s8-20020a056638258800b0032abeeca5ccmr7367188jat.191.1650912325778;
        Mon, 25 Apr 2022 11:45:25 -0700 (PDT)
Received: from [127.0.1.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s5-20020a0566022bc500b0065490deaf19sm8087775iov.31.2022.04.25.11.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 11:45:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     shr@fb.com, kernel-team@fb.com, io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com
In-Reply-To: <20220425182639.2446370-1-shr@fb.com>
References: <20220425182639.2446370-1-shr@fb.com>
Subject: Re: [PATCH v3 0/6] liburing: add support for large CQE sizes
Message-Id: <165091232481.1545902.5319952459011821184.b4-ty@kernel.dk>
Date:   Mon, 25 Apr 2022 12:45:24 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 25 Apr 2022 11:26:33 -0700, Stefan Roesch wrote:
> This adds support for large CQE sizes in the liburing layer. The large CQE
> sizes double the size compared to the default CQE size.
> 
> To support larger CQE sizes the mmap call needs to be modified to map a larger
> memory region for large CQE's. For default CQE's the size of the mapping stays
> the same.
> Also the ring size calculation needs to change.
> 
> [...]

Applied, thanks!

[1/6] liburing: Update io_uring.h with large CQE kernel changes
      commit: b6d43c2a9f3d3e4e4d1c9f273c9ba95375c9c8f1
[2/6] liburing: increase mmap size for large CQE's
      commit: b5c39257d0ae1b61a6b2f9cf6b1c92d9dff9bf0c
[3/6] liburing: return correct ring size for large CQE's
      commit: 485929f4d8a1b2fae0c7066741fa642e1910e6ca
[4/6] liburing: index large CQE's correctly
      commit: 7a5aa844c3faa4f9a562fff2ad7d9de4413cb5f8
[5/6] liburing: add large CQE tests to nop test
      commit: 2922db753d50e96b7ae0022f2943dd0b4b91fa9d
[6/6] liburing: Test all configurations with NOP test
      commit: 9aae4a158d5139c5ce326f76472fd174e9a68a18

Best regards,
-- 
Jens Axboe


