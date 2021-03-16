Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5033D551
	for <lists+io-uring@lfdr.de>; Tue, 16 Mar 2021 15:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235139AbhCPOBL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 16 Mar 2021 10:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231547AbhCPOAj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 16 Mar 2021 10:00:39 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB954C06174A
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 07:00:38 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u4so21620904edv.9
        for <io-uring@vger.kernel.org>; Tue, 16 Mar 2021 07:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=sVi+L5XdyClnJVsBexTs858K98fNeb9zmJUcGmnXVvg=;
        b=c9vRldAPcq5eNdKvkHYBrBqeVD9kZaPv8BZyRwHOeg92bqplKLer4iihDJC7nok14D
         Cg0pnWL5Y3IyZVAARLdgN9F6rlrvUmJ0UrmyAV+ss9x195ce3ISuuq5mn9a5IkHfSzN2
         crrICZsj7y3+VwgPJB7YMX5jAzP4f0+i9k7ZJCcGyR6tQJsv6w60Z1LmdV+5JcmvwtBF
         89PRjiSsXmCT1ZV1PcEflyhb2OWTYV1L0AfROMBaScc0bL1SaIBrAjPLHRHYrQ17aarQ
         h3/S3wVk8AjtIW4awLesJ0z38/fAyDH7sUz7jI3FsrogNhHuvcOojyjObdGZkmarskdc
         hvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=sVi+L5XdyClnJVsBexTs858K98fNeb9zmJUcGmnXVvg=;
        b=gCYh/uQbEB4rSzg7XnD8pXWwP/UFvgnFHMAH/y8/4MUan+cZIgRC5pr0LoVaBDdZNj
         Mk3GxTX5xfHsAY8c/M+jBoXgS5gypxGna3vn5LXXorHkgGaMSgTInO26ONMHqLwBx77l
         6mkgcBtxBap9aV6X7dlw9uVxlOCvkznHeyihQvkFSNcNTLfqWqYEGVWEzwEguT9SF2Ja
         BaRbkPGzfjS2nibk8qJgn8RDDWUAi9WoV7NuN1o5aooUCmP351orCu2K1DFQqYBIcchZ
         KRgDywbop2s3yLcHRo7I6LuMkdPNDsVIppNEAdBi9zFHQFOqt0aoYzGPl017yR9AjaH/
         VNmQ==
X-Gm-Message-State: AOAM531pIj3e2+rhhm8qP47obqOoyf2grbGSFW1tOFkSaEsB0fOFPHyf
        ZIG0JT/44ddtbkXzvPnfoZufqMi5XVCLwA==
X-Google-Smtp-Source: ABdhPJxrWWhLYir6K50UPwKHoY6ejSLSSP6FYqd54E3dcBy+NlJFNQ5inLTM5dEo5LQ5+Jz+Hq9vRw==
X-Received: by 2002:aa7:da48:: with SMTP id w8mr35441240eds.81.1615903232490;
        Tue, 16 Mar 2021 07:00:32 -0700 (PDT)
Received: from ?IPv6:2a02:908:2612:d580:58ac:fe88:50d8:ed7? ([2a02:908:2612:d580:58ac:fe88:50d8:ed7])
        by smtp.googlemail.com with ESMTPSA id q16sm9206272ejd.15.2021.03.16.07.00.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Mar 2021 07:00:31 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: IORING_OP_RECVMSG not respects non-blocking nature of the fd
Message-Id: <371592A7-A199-4F5C-A906-226FFC6CEED9@googlemail.com>
Date:   Tue, 16 Mar 2021 15:00:30 +0100
To:     io-uring <io-uring@vger.kernel.org>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi there,

I think I found a bug in the current io_uring implementation. It seems =
like recvmsg currently not respect when a fd is set to non-blocking.  At =
the moment recvmsg never returns in this case. I can work around this by =
using MSG_DONTWAIT but I don=E2=80=99t think this should be needed.

I am using the latest 5.12 code base atm.

Bye
Norman

