Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9152AE1C9
	for <lists+io-uring@lfdr.de>; Tue, 10 Nov 2020 22:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731880AbgKJVbV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Nov 2020 16:31:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731805AbgKJVbV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Nov 2020 16:31:21 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA77C0613D1
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 13:31:19 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id ay21so37951edb.2
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 13:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dKZYbt06bmNBI3K317UwdWWh7b6jTkgXGb8baAKRNhQ=;
        b=DfVG9U7pqpvgsILu9dvSoSI1MgkOIdR5KI4rKxfmOdT3VjuQOChGML5P9Utw/Pvior
         hJYhj7Fpwpdj2IedB70j61DlRNbpjKXYcrq6OXTFsRFVK/Y3u02UjD1iBue+RzLnHT4V
         38Fyqa2OjxaDrlhDGQv9PmPZQIS50ZP+K3GYE5tUamZHN1LUiBpJ35AwqEi7frd2Gd5Z
         u4kp2B+3CwqF20jcjUbpbdroMTppdC2HlFBMdXegtQR2EGtQT0RsfEh6ya/RQRcf27d2
         OgZCqN3XyZnUxJomrRMsZ25BGu8oldOwRPTv5lBSGGTj1qmI8vtABgmiMelrTKUYTJ22
         EVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=dKZYbt06bmNBI3K317UwdWWh7b6jTkgXGb8baAKRNhQ=;
        b=QDnJhnTdNlHo70R2VItte4Znv11i79OQ8YwGmH353/RHdgfkS3gX2Mx5EMV7r2drPn
         Ux7Dl3JTfqCvpWGfdPNfPtzaDlfF4AqM/ZljJKP/VHDRCJl2qgZn/YWyUTDbDrOtm0TO
         5+cIK6D+KnrZp0w/B1CwvG6irUhUQoNFGpDWM9+UZF+L2Q5KjkIlAmro2HM8ORB2SRlG
         kVMHuEt9oNizDEJ8hsEmOMp+BmkPu14wBfSw3kfx+CQ+V9Z1ByFu2g8SXG1HYOxwF+4v
         mA0Al/hS6NUA6yTTcSx4HPMRgxRNuCokipZimf1r55AL1lfzKqQW+Wn4qkIiWcCs7IT5
         QYyw==
X-Gm-Message-State: AOAM5339R7gVjKHO9oaBlBnNm4fBjDWxUk5tPO7bQzDUNlRPqwRYW2cH
        ljjiXJnT5v5mnDQ0B6xUVRSYsRKglLt1koHBF9sWVUDfHe3a/Lwp
X-Google-Smtp-Source: ABdhPJzQt9P9oKywsdqvSX3x+jCSa8Ylpw1QE+KCD6hs9/TapCPbW1PEOmaTF3AOMBAeHj+G9rFjIzDQIGnO0anJgck=
X-Received: by 2002:aa7:d9c2:: with SMTP id v2mr1485423eds.95.1605043877749;
 Tue, 10 Nov 2020 13:31:17 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Tue, 10 Nov 2020 21:31:06 +0000
Message-ID: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
Subject: io_uring-only sendmsg + recvmsg zerocopy
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

here=E2=80=99s the design i=E2=80=99m flirting with for "recvmsg and sendms=
g zerocopy"
with persistent buffers patch.

we'd be looking at approx +100% throughput each on the send and recv
paths (per TCP_ZEROCOPY_RECEIVE benchmarks).

these would be io_uring only operations given the sendmsg completion
logic described below. want to get some conscious that this design
could/would be acceptable for merging before I begin writing the code.

the problem with zerocopy send is the asynchronous ACK from the NIC
confirming transmission. and you can=E2=80=99t just block on a syscall til
then. MSG_ZEROCOPY tackled this by putting the ACK on the
MSG_ERRQUEUE. but that logic is very disjointed and requires a double
completion (once from sendmsg once the send is enqueued, and again
once the NIC ACKs the transmission), and requires costly userspace
bookkeeping.

so what i propose instead is to exploit the asynchrony of io_uring.

you=E2=80=99d submit the IORING_OP_SENDMSG_ZEROCOPY operation, and then
sometime later receive the completion event on the ring=E2=80=99s completio=
n
queue (either failure or success once ACK-ed by the NIC). 1 unified
completion flow.

we can somehow tag the socket as registered to io_uring, then when the
NIC ACKs, instead of finding the socket's error queue and putting the
completion there like MSG_ZEROCOPY, the kernel would find the io_uring
instance the socket is registered to and call into an io_uring
sendmsg_zerocopy_completion function. Then the cqe would get pushed
onto the completion queue.

the "recvmsg zerocopy" is straight forward enough. mimicking
TCP_ZEROCOPY_RECEIVE, i'll go into specifics next time.

the other big concern is the lifecycle of the persistent memory
buffers in the case of nefarious actors. but since we already have
buffer registration for O_DIRECT, I assume those mechanics already
address those issues and can just be repurposed?

and so with those persistent memory buffers, you'd only pay the cost
of pinning the memory into the kernel once upon registration, before
you even start your server listening... thus "free". versus pinning
per sendmsg like with MSG_ZEROCOPY... thus "true zerocopy".
