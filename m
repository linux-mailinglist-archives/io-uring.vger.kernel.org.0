Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611226E70CC
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 03:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjDSBjP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 21:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDSBjN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 21:39:13 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BD01FD4
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:39:12 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1a6684fd760so5137345ad.0
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681868352; x=1684460352;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y/3h0uMGU2Byg6O6T0xddPMpoVMfS+ns1qQz9fduUgQ=;
        b=hkzzpjVCFWFiCKS4xebfz2Bwe8SVzzD4DbQadOXcMtQWxFrOOZSjwULmA9zEEqtbrC
         kU7TmvxINwIpdq1B23XouRfHmnoqHaHCamtm6Jotdtyjs5htCMupXhEzt1MPXzJSR5qm
         ljTt20shGbhcSzNfMq8Kc+cOeskbPuiRJ0+d9SeJyO5OgpSXPVSm2AJB3bkW+RdXb8r6
         FgTOKNxSuiDUxeqdCiKmVzcqePCw4/3cBfxnKdIpYKvbB05emV9Jnb8ZjBDmELLgie5J
         uU33k2NB5z209FWMCsh19SNa9CUReIAR82nsQMCdZ3EqTnun9i/fyOl3FsO30bTR9R5h
         xH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681868352; x=1684460352;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y/3h0uMGU2Byg6O6T0xddPMpoVMfS+ns1qQz9fduUgQ=;
        b=Z0BN0GmNbAxWLQ8rYVTASERIpUR8JNIjssBQK31ZWZTZ3leiyf4OrQ0RYBuLt3WZ+f
         ih2ghXzNNo6sD0zD1/mHO9pG2yq6hQLIinboc0DxWvU5ABTcyOIB83OuQkh9T9l6tu1e
         03JLWdHjCo/F+qqJbIuv9SoxXaDUdxcesuLL26UC2tNzoO1a28Gee2+8LKf43pZsPoRr
         /poAFLjCI+LY//Yub2UqaK8xgK99zJGMYO2JSBp0KOyr1fMCEfeCo6l5mu2BKTaV97tt
         9e7YXf+YHZbKJ7wZ3APJAITA10jBZWW9nnLzJFFnZAFP9L4NVWn8RWgaoHltz81spJHU
         AyuA==
X-Gm-Message-State: AAQBX9e6B9AX39rpZ7GE3tVss2uM/EAV2Gs5HuJQAJYEJTrHPNzMrvMX
        TlWmR3MGWKMRcwoouVf1PLsVNmamSN8SZG2w0NI=
X-Google-Smtp-Source: AKy350bZU0Z0toS7DjGKdybFBPhkkroQroJnhZD4esOT/Er1IGynlmUTkE+U7vqfCPz4HNLXqQ/c1g==
X-Received: by 2002:a17:902:d4c4:b0:1a6:6edd:d143 with SMTP id o4-20020a170902d4c400b001a66eddd143mr19811942plg.6.1681868352162;
        Tue, 18 Apr 2023 18:39:12 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b6-20020a170902d88600b001a64851087bsm10242007plz.272.2023.04.18.18.39.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 18:39:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        David Wei <davidhwei@meta.com>
Cc:     io-uring@vger.kernel.org
In-Reply-To: <20230418225817.1905027-1-davidhwei@meta.com>
References: <20230418225817.1905027-1-davidhwei@meta.com>
Subject: Re: [PATCH v4] io_uring: add support for multishot timeouts
Message-Id: <168186835123.340981.13070185209888390249.b4-ty@kernel.dk>
Date:   Tue, 18 Apr 2023 19:39:11 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.13-dev-00303
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On Tue, 18 Apr 2023 15:58:18 -0700, David Wei wrote:
> A multishot timeout submission will repeatedly generate completions with
> the IORING_CQE_F_MORE cflag set. Depending on the value of the `off'
> field in the submission, these timeouts can either repeat indefinitely
> until cancelled (`off' = 0) or for a fixed number of times (`off' > 0).
> 
> Only noseq timeouts (i.e. not dependent on the number of I/O
> completions) are supported.
> 
> [...]

Applied, thanks!

[1/1] io_uring: add support for multishot timeouts
      commit: ea97f6c8558e83cb457c3b5f53351e4fd8519ab1

Best regards,
-- 
Jens Axboe



