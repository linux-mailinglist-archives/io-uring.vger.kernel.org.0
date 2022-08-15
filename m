Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D15594A98
	for <lists+io-uring@lfdr.de>; Tue, 16 Aug 2022 02:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352455AbiHPAEy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Aug 2022 20:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356653AbiHPACo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Aug 2022 20:02:44 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF40169C6E
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 13:24:05 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 24so7426163pgr.7
        for <io-uring@vger.kernel.org>; Mon, 15 Aug 2022 13:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=eW65fB0ov3YPNyTYxNrPr0o8xEfpay8/U7jZbxm267szMaq3EZBEp1BygP54C9ab2p
         xiLPtKjTIok/hmfeElWjxkntOSxfnZEC0XcZ3Q8FAUxlHTJBo5gy9xa4L4afUCHIJ/HU
         wEGo8h3+bgfSdOPukdYe3p5dUMU/zJrYYZ3NykK9+tA8oEPS7V9GoP7Uag7lZP3EB5kM
         ZCCcyQn46gCE3D75/+inncTRX7rO+ML6yK2nyFHo6V1C/9Tjpl7o7OPQFNuaB/mSu7AP
         lnid9vmWnG2M2GtP7nDGv+C0seMpO1HKFTlkwzgDoQxsRj7ju8VdvLkDYX0Tzi/cJaOr
         iRMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=ej3T27wdcOl5hgxFKEEvscpLUDARFbq7IX1O4+1Fbq8=;
        b=5NVaokx9xQkTKhIOEB9LMHlGSOPSGnha3uh6Ok9uQzICT47elVwwEPl9Q8nfVr+ArU
         OEv38SqbsGdxeQLP3JultbqCNAWQfA+WZyHJHFqzsZzW0A5fNxPAzGRKWYvp75Bb7BPh
         cLJ4+K5CGRqeN9zvRrfFuEr2Tx0WdQeaFs3kd9wjb82M5bgCJDhWgeZ1wAopw+Cr+2d5
         oc+QB5pWSLvjPfbjPZ7LQyfDKZtGc324vICtrP1Ge2FQMbuEzZzp/QhzAHl5EtHj4CVR
         +QE0W0t2RAJbkLzhCMQXIXg2QcUpUek9/jgI4ueCBQiF86wQ64sDFllPChYIebtm/tBk
         bqRg==
X-Gm-Message-State: ACgBeo3bbwiSw2050I8GW2fy8F6XdU7u1UZetc2imfDF840FrVnXKMIr
        oGtm1BC1B3Ja+wf6IeUJJJPQ49kMc39nonhj91U=
X-Google-Smtp-Source: AA6agR4usvTfehjwvhIfPGl+GcttPUA6wM5xU1qOq0ZlZJTdby8mkJRHzc2mGFGSxgDF+XeOECPGRYPzftT/ChMUU+Y=
X-Received: by 2002:a63:6345:0:b0:41d:649a:af3d with SMTP id
 x66-20020a636345000000b0041d649aaf3dmr15277089pgb.354.1660595044277; Mon, 15
 Aug 2022 13:24:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:522:cb53:b0:45c:8ea1:fdc3 with HTTP; Mon, 15 Aug 2022
 13:24:03 -0700 (PDT)
Reply-To: wijh555@gmail.com
From:   "Prof. Chin Guang" <poolcatfish@gmail.com>
Date:   Mon, 15 Aug 2022 13:24:03 -0700
Message-ID: <CADP_ptcFcV+ntiQvwAGNG9g=-0wvxi1b66vH3+gxfegiZZqaUg@mail.gmail.com>
Subject: Good Day,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

-- 
Hello,
We the Board Directors believe you are in good health, doing great and
with the hope that this mail will meet you in good condition, We are
privileged and delighted to reach you via email" And we are urgently
waiting to hear from you. and again your number is not connecting.

Sincerely,
Prof. Chin Guang
