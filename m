Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEF05F4514
	for <lists+io-uring@lfdr.de>; Tue,  4 Oct 2022 16:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbiJDODi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Oct 2022 10:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJDODg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Oct 2022 10:03:36 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 588C35D0F4
        for <io-uring@vger.kernel.org>; Tue,  4 Oct 2022 07:03:36 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id n192so10573045iod.3
        for <io-uring@vger.kernel.org>; Tue, 04 Oct 2022 07:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:from:to:cc:subject:date;
        bh=UpY7eTUV8e2y5ryliujNB+eIJLuvP9ZcaUYCZDTqaaw=;
        b=uZNvlLZrpZCgRQJHTMieOviXYMjtY3FP5efJyJ6mL3tG7FCN+ZRG2oguYZ3z5w9Ocm
         A1urA6pWW1wYh18saGLMGPqpHcewLRG8iDZKySiipKN2JGmfokxn4hKzG7WlOY+oT7xe
         BaECLqBJ/yKGLiwXRSLc2rPUL+fTX3zXPvWDgWpUB0i+M6xdPJiRX31R4zXQBMoegddO
         qa1PVMK0H4IlJShZG6CtTH8q+LZxKRNjK/uZNW4J1JbfvRTks4DaeoDjD5eS56YuRhat
         AV8fucwh5DMPFBiAp/4DkB99Dmkv7ZZ35ETl1QHv52dGzZfai8EMNYZeed9CcVqIMCBV
         +srg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UpY7eTUV8e2y5ryliujNB+eIJLuvP9ZcaUYCZDTqaaw=;
        b=eIOU6XDNMFUiALikszEDCzk12DgCBUHVwbfEDax5xQvG9IN2ddaL8gvUrhbzEYgNQQ
         JkAHA0p0BDkUyevPiWz4FAdBZDajTJ8eDjRZGU0GGbJRMIc6HIbytdG9VnlXLymEhmjy
         RBxxWRmic+6pJCErpdZfHtgY0//ZYlg1Y0lwRtfq/3Nh0cnGnsihUZ1VkvpOZPL/SlJS
         namrHwFEI3j86B/DJ/H4GUtrhb5RoZ9/S6N/aEuruZEBNtlnPI8nD4WQ8p3XkNcOOE7q
         ChFT+yxvnufZ9OB3knUSYU1HFUMeXz1x+dMEak9frzz9uPbcWpOeAlpp8DAeAhelqBM9
         jU6g==
X-Gm-Message-State: ACrzQf0y/B/6XxgFnw37FhwoYo1pQrURqDgqlBM8JttKHstjk1RQB+vu
        Un+H0hQvRnnUAS1QnPNpwGKPcC4297KSiA==
X-Google-Smtp-Source: AMsMyM6C/N/sZ6Yqt61/x6NfZZaSggScagZrBbqtvnKLSVhc6plaaya4Jxhvij9uxRdbp2/g74F8sQ==
X-Received: by 2002:a05:6638:2648:b0:35a:74cf:7b0c with SMTP id n8-20020a056638264800b0035a74cf7b0cmr12466460jat.205.1664892215286;
        Tue, 04 Oct 2022 07:03:35 -0700 (PDT)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id f5-20020a02a105000000b0036332a07adcsm2462089jag.173.2022.10.04.07.03.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 07:03:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com>
References: <6d798f65ed4ab8db3664c4d3397d4af16ca98846.1664849932.git.asml.silence@gmail.com>
Subject: Re: [PATCH for-6.1 1/1] io_uring: correct pinned_vm accounting
Message-Id: <166489221439.37976.9096121404573262672.b4-ty@kernel.dk>
Date:   Tue, 04 Oct 2022 08:03:34 -0600
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

On Tue, 4 Oct 2022 03:19:08 +0100, Pavel Begunkov wrote:
> ->mm_account should be released only after we free all registered
> buffers, otherwise __io_sqe_buffers_unregister() will see a NULL
> ->mm_account and skip locked_vm accounting.
> 
> 

Applied, thanks!

[1/1] io_uring: correct pinned_vm accounting
      commit: 0a80de2c7f64c4cb211bdecf4a96d93d039ec1b1

Best regards,
-- 
Jens Axboe


