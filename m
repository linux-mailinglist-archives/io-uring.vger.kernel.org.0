Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD13570EB84
	for <lists+io-uring@lfdr.de>; Wed, 24 May 2023 04:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbjEXCsz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 May 2023 22:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbjEXCsz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 May 2023 22:48:55 -0400
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B992E9
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 19:48:54 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-55554c33bf3so371934eaf.2
        for <io-uring@vger.kernel.org>; Tue, 23 May 2023 19:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684896533; x=1687488533;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=69sYZJTuX6Lrw84qrKaU0dB7F2owPKoGTgGGIqmtYQs=;
        b=jDCjQAKbSpwe/INlt7A5QFlLmWFVMYJq4wpRUwv3agKFahg3Gig4WVlgnDdnA0YAc+
         d0YecH/EcGiAdutZfeJWVN2I2szw//LRef75qUnt9UMQllX1Lps7PhFafD8z2QslDpnf
         sEbhSFhJ/pNhjXO+dhZtG8JiAj2y4EK1H0xks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684896533; x=1687488533;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=69sYZJTuX6Lrw84qrKaU0dB7F2owPKoGTgGGIqmtYQs=;
        b=VYIJmr8GLpRBxKjxgt8pwot+T8z0jkj6Q4PKMLAPuh0UVH3Ve5PSY5SA2YbEaASKOF
         GX08TuIia9OxewDXfOzWuog6XEYbEDuFdeoV+yCJJcdOgOwO18nXq8sNSoFMEQcFIGJ3
         4oLLbQS+0yqmcm2QMu+fFPOovU/+uFhz0tOKi9dxL8jbnLMrShbtPXYiRdckFD40PVM3
         UYU5pqHLotEPIj8Nbr+XClkh2IPlqcetKIFHCrTyE6AMVWG4ifnuVYhret/MReq3018o
         a9FP+iaO+Yqtu5rJ8VCSTBriEauqWQOvRMfEL0+C9AvQlsTz76JP3m6iaJLtZQ6yJ7TO
         fhdw==
X-Gm-Message-State: AC+VfDyhtUC1gupe8HP6pPDZebhQ8Yn0XNzhYAwwx9SsOZE2Kz9aaehT
        jlSB/RLHnpumhqCGfu+/nwD6EzdzpuwzBC5dpESsddYlenUhzDzpygE=
X-Google-Smtp-Source: ACHHUZ5ttPf3DgljPdYl6Rhy5wSKCOnDdWRh4IDTy99SayqZOMn7xKlfKwCC2aoE57YvbykqRcLEyWtMBIc/yTHsIzk=
X-Received: by 2002:a4a:9cd2:0:b0:54f:8511:b1a with SMTP id
 d18-20020a4a9cd2000000b0054f85110b1amr6389674ook.0.1684896533247; Tue, 23 May
 2023 19:48:53 -0700 (PDT)
MIME-Version: 1.0
From:   Jeff Xu <jeffxu@chromium.org>
Date:   Tue, 23 May 2023 19:48:41 -0700
Message-ID: <CABi2SkUp45HEt7eQ6a47Z7b3LzW=4m3xAakG35os7puCO2dkng@mail.gmail.com>
Subject: Protection key in io uring kthread
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi
I have a question on the protection key in io_uring. Today, when a
user thread enters the kernel through syscall, PKRU is preserved, and
the kernel  will respect the PKEY protection of memory.

For example:
sys_mprotect_pkey((void *)ptr, size, PROT_READ | PROT_WRITE, pkey);
pkey_write_deny(pkey); <-- disable write access to pkey for this thread.
ret = read(fd, ptr, 1); <-- this will fail in the kernel.

I wonder what is the case for io_uring, since read is now async, will
kthread have the user thread's PKUR ?

In theory, it is possible, i.e. from io_uring_enter syscall. But I
don't know the implementation details of io_uring, hence asking the
expert in this list.

Thanks!
-Jeff
