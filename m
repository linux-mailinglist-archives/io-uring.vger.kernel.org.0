Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C48AF509335
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 00:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377849AbiDTWyO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 18:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356355AbiDTWyO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 18:54:14 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4376D2251E
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:51:26 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id x191so3048398pgd.4
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 15:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=Ut5Hlr9FZUAzXOlea/UmV64wKqZjWe43XM2WiAFcPgc=;
        b=EK8/iMO2o0VmILnX6rhN/JXl18UWhyMNThiA+9RMnWQrqDDSFGNYbOVFrntnzKj3Ut
         O240npaeR7/aweWrpo594iogXVpD/MRW2yyIt7JAAC2xg6piaSnzueEBXfDOZVq/qxwd
         /9tGVID8j0xsieLCeDPBr5deB88goOeAVPZCZtx/QC175qmO8HR1OPfNqssLtWZ7M0IR
         QbIcM2QImZckalcvID5UjOfh1K5xsDCCfGtmblvdvuKQBNn7hazj/ojQ1hMCj93xIzL9
         wmHPJpXsuAHK/8mJy2doS5Jc2tUE6YMTQrIx93a0XQ5KvoEH552fVar74swiS+iQPJVx
         HsMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=Ut5Hlr9FZUAzXOlea/UmV64wKqZjWe43XM2WiAFcPgc=;
        b=APDKw4WCd5z0rla0FdZRQCSL8HOymG3JyhIJ0vydEj4BDUsUMySZDzPxq9Ad0teiIU
         Atif0JXhpFnG9PT4DPKX0FDedccqHzaTJfqVEesyQOTLSXuzlOKUc+0Bts38Vz+NFcQ6
         du+UUmtiZLtnpfyHLRZq8phbLrXXqtfjbxVBXqepLPDt56LAhKnyM1yGpiBa+q7+2/x8
         RhHXLq+ir77kZeGJTx0tQI0uMr/3pdwP/E11wiDTjkGqLaIIckMJJ/nkeF4IYWh0W/D9
         JzO4H9oTIyWvzk6Enrvy2NcZV1/j6fo/1pzIXfX680kNEcJl0uSqzPJky1nU9S33Lhu8
         iV0w==
X-Gm-Message-State: AOAM532cyZQ70LJ9OSHVRktyqvqbVRYRgMzbH1WqEhZ/ivTm31uvNsWC
        iW+g+cTyW7SKEcIpYiT8ZNFzJFtD3sWEag==
X-Google-Smtp-Source: ABdhPJwGt15taETkaEz+l5g53yHnu1HHTgsSRWHBAF5OLyCekCaS3kKtiku21q7uZbhb9kCN59oJjA==
X-Received: by 2002:a63:5723:0:b0:3aa:3c53:35f0 with SMTP id l35-20020a635723000000b003aa3c5335f0mr8797936pgb.461.1650495085755;
        Wed, 20 Apr 2022 15:51:25 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:4975:46c0:9a40:772a:e789:f8db])
        by smtp.gmail.com with ESMTPSA id n4-20020a637204000000b00398522203a2sm21362558pgc.80.2022.04.20.15.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 15:51:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     kernel-team@fb.com, io-uring@vger.kernel.org, shr@fb.com
In-Reply-To: <20220420191451.2904439-1-shr@fb.com>
References: <20220420191451.2904439-1-shr@fb.com>
Subject: Re: [PATCH v2 00/12] add large CQE support for io-uring
Message-Id: <165049508483.559887.15785156729960849643.b4-ty@kernel.dk>
Date:   Wed, 20 Apr 2022 16:51:24 -0600
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

On Wed, 20 Apr 2022 12:14:39 -0700, Stefan Roesch wrote:
> This adds the large CQE support for io-uring. Large CQE's are 16 bytes longer.
> To support the longer CQE's the allocation part is changed and when the CQE is
> accessed.
> 
> The allocation of the large CQE's is twice as big, so the allocation size is
> doubled. The ring size calculation needs to take this into account.
> 
> [...]

Applied, thanks!

[01/12] io_uring: support CQE32 in io_uring_cqe
        commit: be428af6b204c2b366dd8b838bea87d1d4d9f2bd
[02/12] io_uring: wire up inline completion path for CQE32
        commit: 8fc4fbc38db6538056498c88f606f958fbb24bfd
[03/12] io_uring: change ring size calculation for CQE32
        commit: d09d3b8f2986899ff8f535c91d95c137b03595ec
[04/12] io_uring: add CQE32 setup processing
        commit: a81124f0283879a7c5e77c0def9c725e84e79cb1
[05/12] io_uring: add CQE32 completion processing
        commit: c7050dfe60c484f9084e57c2b1c88b8ab1f8a06d
[06/12] io_uring: modify io_get_cqe for CQE32
        commit: f23855c3511dffa54069c9a0ed513b79bec39938
[07/12] io_uring: flush completions for CQE32
        commit: 8a5be11b11449a412ef89c46a05e9bbeeab6652d
[08/12] io_uring: overflow processing for CQE32
        commit: 2f1bbef557e9b174361ecd2f7c59b683bbca4464
[09/12] io_uring: add tracing for additional CQE32 fields
        commit: b4df41b44f8f358f86533148aa0e56b27bca47d6
[10/12] io_uring: support CQE32 in /proc info
        commit: 9d1b8d722dc06b9ab96db6e2bb967187c6185727
[11/12] io_uring: enable CQE32
        commit: cae6c1bdf9704dee2d3c7803c36ef73ada19e238
[12/12] io_uring: support CQE32 for nop operation
        commit: 460527265a0a6aa5107a7e4e4640f8d4b2088455

Best regards,
-- 
Jens Axboe


