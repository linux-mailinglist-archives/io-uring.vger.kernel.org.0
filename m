Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561FD34A04D
	for <lists+io-uring@lfdr.de>; Fri, 26 Mar 2021 04:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhCZDg0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 23:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhCZDgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 23:36:07 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A713C06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 20:36:06 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u5so6311104ejn.8
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 20:36:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=LXU7t747LhChb7LEpjd0zru/jdmQVp/KYGrnp7Jiul8=;
        b=SsGZnB+UudlzKyivzUVLMgZpI3kHpuykcnGf+SI9fWx8PH+uQBC6jH3liiT6aXjbNV
         FBs0jhQIW2+Hd7dA/9sfUBjT7H+xumNa+o6wEiHTljFAUethOf3+qQzuUqhPPB2YUf32
         CQBV6bC4GgRMytirMFNOAgVQGSSthefPKmZSX9g4JHgOTjyfQkDbwGgLOcd0N4NsC3el
         sSCiSzDWcq07+lj3VR31xRYlwmdF0c6Fo3vx/yTiGbqyTf55T8fNqSdVCp8YRb5VYBC+
         Iz+Tp4X7Zkuw/zXXj9G7/5ObhdzSxAW5r4wUTvL/wnWZabucELqjq/Z5TFnWk/y6GAc2
         AC4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=LXU7t747LhChb7LEpjd0zru/jdmQVp/KYGrnp7Jiul8=;
        b=Y9PDys/1knW+oR9gpJoCzLzBAc15XKdq/iMxCI2zJn1GbWVRvMZDfGpnL2xXJ3uNlU
         PJzDfngXmkb/FMnNDuB4QDmDC6j/59kBPLP0U1rN4rTVBW8Pk0vlKihlSCVwbXXKWoCH
         sStMHpG5iq2QpEtt2w5+5KHRD6eozk/ti7z3ODY5DlhvKsvHDz+WbFb0RS8J1Pr+jvfK
         4x2wkmOPB3TWVBPuW8Yvm8wkWU3LKpvHIO55GGpyyRMem58pSmTw8L08YqicQ8Pbk8n7
         G5oPNUH2xPv0VwGE5YK9/3HiZrBdKotzF5hiF5Xg2nf6LVRwIEqiainZw1iuNue+RKPL
         8TFg==
X-Gm-Message-State: AOAM531yJiFffC/bHFwdxrsjfXYuPDQVdpiWHZmaRu/90AJC/wQ9/ETv
        xnHoGkR/Ocmq/7PkxMRJUO65OJsdh+3uDdNjDPafN0Dut8FYGg==
X-Google-Smtp-Source: ABdhPJzOg09Z+ZKDGFCQd+JqPlW6hYCh4fi1fI7sgRZYZa3BWSuLFL9h7TITUHUF03qAH9N6kYim+iPbY+9P19P8c2M=
X-Received: by 2002:a17:906:4d44:: with SMTP id b4mr13030673ejv.338.1616729764919;
 Thu, 25 Mar 2021 20:36:04 -0700 (PDT)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Thu, 25 Mar 2021 23:35:54 -0400
Message-ID: <CAM1kxwjT66zgh8k=Jnkhn5-UHrBfMjSDyKyrKhuhtCESo9tMew@mail.gmail.com>
Subject: [POSSIBLE BUG] sendmsg ops returning -ETIME
To:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

i wrote a quic performance tool to research maximal quic server
performance namely syscalls vs io-uring and quic library vs library
(in an apples to apples scenario).

i'm having some issues with the stability of the io-uring networking
layer... and at least thought my rings were just overflowing, but they
aren't. during most runs, all of a sudden submitted sendmsg ops start
failing and returning -ETIME... even though there are absolutely no
timeouts associated with those operations. and it's always that -ETIME
error delivered once things start to fail.

the only performance test implemented so far is a 1GB transfer over
udp over ipv6 loopback. my working guess at the moment is that the
operation pressure rate is exposing some kind of bug somewhere in
io-ring?

i just posted the project on github. the README is basic but i think
provides enough instructions to run the binaries and see for yourself.

let me know what data i can extract so we can quickly rule this
definitely my bug or definitely an io-uring bug. it's really the
bizzare -ETIME that makes me think it might not be mine.

the code is super brief, check perf.networking.cpp

https://github.com/victorstewart/quicperf
