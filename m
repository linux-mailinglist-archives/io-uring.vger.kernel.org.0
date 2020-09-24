Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EBA6277914
	for <lists+io-uring@lfdr.de>; Thu, 24 Sep 2020 21:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgIXTUk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Sep 2020 15:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726841AbgIXTUk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Sep 2020 15:20:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4380AC0613CE
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 12:20:40 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id z1so442443wrt.3
        for <io-uring@vger.kernel.org>; Thu, 24 Sep 2020 12:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=xyEBeA8m4naW5+jFbqtbRJtR7ToHGWN4L8Qc/cncdO4=;
        b=HquJq59tweD4ZIdJiv+vfCk6BC1n0FQ/EEwiyddeAQ57GIQ8a0KN6ALbFB2N2Hiu1c
         D/h1qAIo3pQFTYobeCEGOQIskGm0lsnviEFzOHgSJ3SdcmKyWV3sMIdmxBfiJ7v3StJy
         6QvWbmAE4Raur6olXk1x1Zua5xYW7HzjaA/NwLFKNxoHpypywiV6d5HJPi2Rk6AcK0lO
         BdvDIgYZcAC9MkqoeAoB3wmcFFwH4xUT5lGSAQom1s5n4jhwOw5KyGscknwVKhPsQ7Xn
         t8UXNA8WoV3OZmYK+wrBzO1tXQewpu2Xfet84f7/eehVPul+mgPc5NOvjLFnmtRymXUJ
         gTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=xyEBeA8m4naW5+jFbqtbRJtR7ToHGWN4L8Qc/cncdO4=;
        b=OvWHwKgCI61wR+2ZfeP/JaXIvASPc0YIFXbrQuLEd2DneLqZzFkLCO3wfFAYA8wRND
         VvntKecvkTVIQUF2lizx/nLRebacrSRrXXp3W8ZkvPuaZU6H8QWleqjy3xSydDNqvo9D
         +FXr8yOfXoxg7CEPCD6JIM6vJuqCed75YzL8hk6VTO8FuTO9EUY50EE+euFrjq7LCMUl
         4QgIB42dOsTL2uI1foc+6dg8D3QRPxYdSuMlVxudF2Q6gjpDS2sz2PHP60lCYLiyPkB/
         o5T9F3hbVFNr2Dp7DPTxO0+ZKuz5xNNWUJ0/qvbwWTHNd/bDE85NBnjBY/Zn6dRDh0la
         UF+w==
X-Gm-Message-State: AOAM530pZraxrNIzzhx8VK0cexCCuRtf/O3O/QnYCL0MnVNigkTp7Q3W
        Wj5ncyg4s6vm3fof3g/xwoRmVtyGzJVSPQ==
X-Google-Smtp-Source: ABdhPJx4nYrzmCKu75pVT8CbXYyrWXBJXmVS4HuL4LntCqzrTc9AtQ+xVse5oAScd1TOZY7KyDlbnA==
X-Received: by 2002:adf:8405:: with SMTP id 5mr448171wrf.143.1600975238707;
        Thu, 24 Sep 2020 12:20:38 -0700 (PDT)
Received: from macbook-pro.lan (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.googlemail.com with ESMTPSA id d19sm297475wmd.0.2020.09.24.12.20.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2020 12:20:38 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Support for recvmmsg / sendmmsg
Message-Id: <303D2FBF-3482-4A6B-8945-7FB8130D8418@googlemail.com>
Date:   Thu, 24 Sep 2020 21:20:37 +0200
To:     io-uring@vger.kernel.org
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi there,

I am currently working on support for Datagrams in Netty using io_uring. =
One of the things that I noticed is that there is no recvmmsg / sendmmsg =
atm. You can argue that this may not be needed as I can jus submit =
multiple IORING_OP_* operations and so emulate it. While this is mostly =
true it would be still nice to have support for these calls because of:

* Issuing multiple IORING_OP_SENDMSG / RECVMSG is not the same as just =
issue one of them as I need to call io_uring_enter(=E2=80=A6) earlier to =
ensure I not =E2=80=9Coverflow=E2=80=9D the submission queue.
* Having multiple IORING_OP_SENDMSG / RECVMSG makes it more complicated =
in terms of keeping state in some cases

So would it be possible to add these ? For now I have implemented my own =
=E2=80=9Cbatching=E2=80=9D but its a way more complicated as I would =
love to :/

Thanks
Norman

