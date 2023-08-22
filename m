Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40C1F784BAA
	for <lists+io-uring@lfdr.de>; Tue, 22 Aug 2023 22:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjHVUyb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Aug 2023 16:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjHVUya (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Aug 2023 16:54:30 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FBB1B0
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 13:54:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-53ff4f39c0fso5489423a12.0
        for <io-uring@vger.kernel.org>; Tue, 22 Aug 2023 13:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692737668; x=1693342468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lRgd1KNmRMx4zIlDV0n2Rv4fJsAox9YCLsfqlY6N7KE=;
        b=X1efAPKURjcmJWZf/u4Cc3mIopom2QDLrm2ITCY8W1HZH0InGbch5WskxyMs7VL1Vj
         8qKifDcxkiESCorRyj38cfQUioC72WiJ/hPqJNL+8nq+HuONgKQGX8bRJ+pprZ70MDjN
         z3CUIYixkpzhxw3aC1al4Km/jqT9gAT3nmmdpgLwUFDe1Kgl+oaCVhjIuk5hgQg62qEB
         Cmc1NB4iBCxM5S2zVDKvlCCsP2qo/MGwbA7h3lAzQdl4J4pv8jqyBdU+n8XQ3NCZ7KWg
         eiSVl+4Om0HjDFSO0DgCATSfJFa+kEUz0NZ+yZJmdUR9ydj33t2WQ3HvzHo6awQRMUqk
         oNlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692737668; x=1693342468;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lRgd1KNmRMx4zIlDV0n2Rv4fJsAox9YCLsfqlY6N7KE=;
        b=lLNLi/xJmIycB4We4l+JwIjAxnqMbZuIzY8+gZtuSQIqewNG1UTV2CAEZG9Hw3d4+1
         yusuwbuALWybAfqjPzaUw3JC8a/X/SDqs1nU+TVMGU4s/dt78fhT4+sfzAqC27CbnN7m
         7xj5aSovRj8Tppk6PIvhbP6U3aQSchzKSFPowVpm2Sgw/NOW0I53E+CD49nPwEZhBmvq
         zEB5rg2EANCXCtu5qi8cu7rMuiPs51lkuFA57aRHWYsHF7eDHIJs+d0zQFAVrl8fCty1
         NVHokY2Cj03KgshrZqYSHelCTDYPayHbp7I/jn2ZDfmIZnUGBdQ/g0DlBeVCwGCgNE1X
         hPbg==
X-Gm-Message-State: AOJu0YxjPZFWxGGKhcjykMq/aoDtFnDR8Jo7or4yWvdFIwBYn1m3PQTg
        UZo4eqoMKCEXOz+G27sVwxVkCww=
X-Google-Smtp-Source: AGHT+IHxZxHtXPclq+Y4ek62oaizIsBbD7UKg4F6HU/umgCda9ze+LtHe5HYhP+MjwZpe/qY5j6HIIg=
X-Received: from hmarynka.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:925])
 (user=ovt job=sendgmr) by 2002:a17:902:f353:b0:1bc:a3b:e902 with SMTP id
 q19-20020a170902f35300b001bc0a3be902mr3999399ple.3.1692737668562; Tue, 22 Aug
 2023 13:54:28 -0700 (PDT)
Date:   Tue, 22 Aug 2023 20:54:24 +0000
In-Reply-To: <20230119180225.466835-1-axboe@kernel.dk>
Mime-Version: 1.0
References: <20230119180225.466835-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <20230822205425.1385767-1-ovt@google.com>
Subject: [PATCH 0/2] Fix locking for MSG_RING and IOPOLL targets
From:   Oleksandr Tymoshenko <ovt@google.com>
To:     axboe@kernel.dk
Cc:     asml.silence@gmail.com, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

Does this patchset need to be backported to 6.1?

Thank you
