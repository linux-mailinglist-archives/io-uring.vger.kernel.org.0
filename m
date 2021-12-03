Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414184677CE
	for <lists+io-uring@lfdr.de>; Fri,  3 Dec 2021 14:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380981AbhLCNGw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Dec 2021 08:06:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239885AbhLCNGv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Dec 2021 08:06:51 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68440C06173E
        for <io-uring@vger.kernel.org>; Fri,  3 Dec 2021 05:03:27 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id y16so3549207ioc.8
        for <io-uring@vger.kernel.org>; Fri, 03 Dec 2021 05:03:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ND29YhDtqe38nf0VEXnMETJ4EHQdmJsgvTdT8SGMNTw=;
        b=I17DLxEkEFOdiutC2WnLZnpohKiiwuo/BmlS/lk6dPLtoJl8fEqT6n12o4lqSFCuJ6
         tgef45gL2yQQavUOiWSavX0mHsp02r/FYRg0X20CthXb3AcLvqSV7yYUEmXq/tS/bYRY
         5Bbp1Cd5/Zq733RO/7dhg5EOh4KDpuEyB2y03T/sTKK/cgWy3ngi0gQml4WZJhxmUB6D
         dHByJDjdxkOAXu7FSmpLjhqVPxvebr8YV3MsbdQ2T8Po5Xk1a7B31I8HZ+GyxNwJfSXh
         orgDDIHf0YRgB6vTC7sjAuYOnAsXyv5OT9pX3YJBhZS9TnLJA2BipMVFUsjOD5s7V3bj
         r2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ND29YhDtqe38nf0VEXnMETJ4EHQdmJsgvTdT8SGMNTw=;
        b=5zlq+SbQoZNFAdc9XPknB4kG04b+bFgZscpWoKFea483WOTBuKTIekY9laPmOIH7xQ
         Lus1HR/nR9fWBx4uyR9PyAjP+CqH0VNJsF9XTRlUcv2+TqCO405N8FVJ+Xe049ZqmrHc
         k/77yKsNx+1j8gfguoVnlp3ePu7W8MIwURnGrx/Kn7T0uD4ImUHTAOwyMIJ5QXB9vItB
         LOxwBgt+18qqnOMy1bU0p1nsRNfV+Rj7LEYVGtTFzV/aztPYD8t5brPCWgzhLw/nkpg0
         /bIiE7srkiOehXh/7I/i5ooLvbPRdNn1dmlm+zuSj+o06RelpGdGHXS+N4c4Qfah0IF7
         Nvrg==
X-Gm-Message-State: AOAM5321zJfkHYe22k6iplvML7A1Ct4yjlQqLw9vb8y/22tvzG7eJXe1
        o7VyH3Jpl8iaWI9CmLJ/Wl0XKkxbuGqnvwT9dyKKtVZw
X-Google-Smtp-Source: ABdhPJwr05T1Jrs6UJDXM2IRpC1si9IyvEi4GIuYpQRzNhJ60z82kMhTwZWWWb3D5iSXHWyc78hSg31uLxsUPmCFvoc=
X-Received: by 2002:a02:a816:: with SMTP id f22mr24579283jaj.81.1638536606504;
 Fri, 03 Dec 2021 05:03:26 -0800 (PST)
MIME-Version: 1.0
From:   Hiroaki Nakamura <hnakamur@gmail.com>
Date:   Fri, 3 Dec 2021 22:02:51 +0900
Message-ID: <CAN-DUMSSQ8_5Zi+ULhHZKEC535U3ZiqtS=o3VcXUV1yk2==pvA@mail.gmail.com>
Subject: [Question] Is it expected link_timeout linked to send returns -ENOENT?
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, there.

I wrote an example for send + link_timeout and found link_timeout
returns -ENOENT.
Is this an expected behavior?

My example is at
https://github.com/hnakamur/liburing/commit/3a19659cda50dec05c59d80716b69f0390c5c600

If the timeout is very short like < 1000 nanoseconds, cqe->res for
link_timeout is -ENOENT.
If the timeout is long like > 1000 nanoseconds, cqe->res for
link_timeout is -ECANCELED.
In both cases, the send operation is executed successfully.

I read the explanation for IORING_OP_LINK_TIMEOUT at
https://manpages.ubuntu.com/manpages/jammy/en/man2/io_uring_enter.2.html
but it says nothing about ENOENT.

Thanks,

--
)Hioraki Nakamura) hnakamur@gmail.com
