Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B90673014D
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 16:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245427AbjFNOKV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 10:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245504AbjFNOKB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 10:10:01 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5CD213F
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 07:09:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51493ec65d8so11631707a12.2
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 07:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1686751788; x=1689343788;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UUOrTL2Xu9y7kRjcCaEz+8n16xewr2Pdx9KRbYMspYM=;
        b=ezFw3Ms7IXQRQzZ/496ULHL94L2YWhqiRcL8vgy2vhkdeD4lZ9YAdfDlLMdtdVDkLx
         JCkL5siQvJlI6UqVZaSptsSujq4awBwPx57L5Yi9DM+Y+bfQ+nH/XmkthuPMfhEKt3KH
         RWPNhnvFVCVt/+1I6ZGP7oJKwFRZRu9TY0xYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686751788; x=1689343788;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UUOrTL2Xu9y7kRjcCaEz+8n16xewr2Pdx9KRbYMspYM=;
        b=OHOSAvPSuYlCl/09Z/b9/SphMKrV+o/vj3pKUebcNjy/l3TW0Hiw3q80ZMrXcBX+Ia
         +mg4ipxiQV1gFyLVkV8LXLCb3HjO3bMW1hDzHqBMl15Op6Pn1AuSTB9ncdyfiAQmtn8g
         Jxz8cVcxhSvFBFsds0yZdIH8gRyjrnGYDRGupuDfddYa1upWNONmML5qHjkVdYoQnZ0Q
         d6T9azeIDySHmLPXLUqm33IGjFNDrgj6eaba+N+c56z/S5p4e9mDFzfetgdRzhlAf0F2
         NbNRqw2edtCMrqbZrjuQKo/IbXv9N6djEFIIOCszREOuyiSHffaxcnuIBRhA5ZcTl4dj
         eNsw==
X-Gm-Message-State: AC+VfDyZAzohiPh45xox+aJCo3hxbqEZrdHteHtMT2qQTj+GZMzLorrb
        vpe4k1YwYfTc38SqYretp0e8v3jOoHbmDUROzwjsA0UQYfGPBVEXasM=
X-Google-Smtp-Source: ACHHUZ7AczZGYjJEHEWJ80aUfYUhHzOz4yaM6EiqIpoX/p/EFIJsXcViiFvXZy9S0pTDmUInx3991nudr18Y6rN38f4=
X-Received: by 2002:aa7:d319:0:b0:515:4066:2acf with SMTP id
 p25-20020aa7d319000000b0051540662acfmr8771936edq.8.1686751787658; Wed, 14 Jun
 2023 07:09:47 -0700 (PDT)
MIME-Version: 1.0
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Wed, 14 Jun 2023 16:09:35 +0200
Message-ID: <CAJPywTLDhb5MkYS7PTi7=sXwm=5r9AbPKz3fDq4XGbqKvA-g=A@mail.gmail.com>
Subject: io-wrk threads on socket vs non-socket
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi!

I'm playing with io-uring, and I found the io-wrk thread situation confusin=
g.

(A) In one case, I have a SOCK_DGRAM socket (blocking), over which I
do IORING_OP_RECVMSG. This works well, and unless I mark the sqe as
IOSQE_ASYNC, it doesn't seem to start an io-wrk kernel thread.

(B) However, the same can't be said of another situation. In the
second case I have a tap file descriptor (blocking), which doesn't
support "Socket operations on non-socket", so I must do
IORING_OP_READV. This however seems to start a new io-wrk for each
readv request:

$ pstree -pt `pidof tapuring`
tapuring(44932)=E2=94=80=E2=94=AC=E2=94=80{iou-wrk-44932}(44937)
                =E2=94=9C=E2=94=80{iou-wrk-44932}(44938)
                =E2=94=9C=E2=94=80{iou-wrk-44932}(44939)
                =E2=94=9C=E2=94=80{iou-wrk-44932}(44940)
                =E2=94=9C=E2=94=80{iou-wrk-44932}(44941)
                =E2=94=9C=E2=94=80{iou-wrk-44932}(44942)

I would expect both situations to behave the same way.

The manpage for IOSQE_ASYNC:

       IOSQE_ASYNC
              Normal operation for io_uring is to try and issue an sqe
              as non-blocking first, and if that fails, execute it in an
              async manner. To support more efficient overlapped
              operation of requests that the application knows/assumes
              will always (or most of the time) block, the application
              can ask for an sqe to be issued async from the start. Note
              that this flag immediately causes the SQE to be offloaded
              to an async helper thread with no initial non-blocking
              attempt.  This may be less efficient and should not be
              used liberally or without understanding the performance
              and efficiency tradeoffs.

This seems to cover the tap file descriptor case. It tries to readv
and when that fails a new io-wrk is spawned. Fine. However, as I
described it seems this is not true for sockets, as without
IOSQE_ASYNC the io-wrk thread is _not_ spawned there?

Is the behaviour different due to socket vs non-socket or readv vs recvmsg?

Please advise.

Marek
