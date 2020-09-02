Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4AB25A926
	for <lists+io-uring@lfdr.de>; Wed,  2 Sep 2020 12:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgIBKJg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 06:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726247AbgIBKJe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 06:09:34 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21C2C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 03:09:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id b79so3886025wmb.4
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 03:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=oicetB2c/Fl+CHL9P3am1TygoNB3oWjnx5BIstF8tIw=;
        b=MDPpFW9IH3F8Efkh7thBELoX3KEqGoHZlTGTdypbZUVyAYDQe/SC4dAGuntnZRwoaL
         A8HrpI/bewGa3z1Y0g2sZChHX7cgHr8h/HAVz8rdNNencLUDMPcEp6jsD7PLDhA+DjSc
         /X+OamWvUF6gnXVTt4xrW7wUaARJpOj4FG0ISePniz9GSDEKU4UCQJCDGlJirbnjYAYc
         JakzEVrj+ouBV8lq5/6HxbEl0MfaeEucK2+wHvR1sAoS08x8DmIDez06YE+BHGEo+06B
         spp27KJq9tWYCsOuSFcsQrj0xbUrQzM3R5rQmTS6SDHWmeNwYMLkMU+EPIsBYw8tUgZO
         UbMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=oicetB2c/Fl+CHL9P3am1TygoNB3oWjnx5BIstF8tIw=;
        b=jhwcFsccq2k5fo4G8XXmlh2PMDP4hi3YHjS7Ao783I5r7nhPX0iT1lRWeNJ+71dpY1
         1uKEZU7XTmK9aBP9p/cAYPkZN+F1PcCpRXHN9TkYBQQ/rMFmQC8rYyiB2VtYg/7ThLnD
         R8FV9BRY1hBkvQk82RC0ufQQyVUKfEMU64cgufwlPUp4QlxBS8FP6p6VeNK5laiXKoG6
         FJ8ibBOo3qg7xa0wGl6tV1fNbJYG43ad6lXLtwmETbiHInocH6annOFZg0eGOmp6K/YN
         ozXko19rU0GqREOQzC52T2NEgsscKvu4voSM0+qEtl1zOGSybfQA8+qR/xYawFBdr9Sk
         n8oA==
X-Gm-Message-State: AOAM531dKOdgkHlvofU+y5MXEaHyXtZwI/K+ByiM5kSB+wc0nseywcGt
        RtKgw2utKqdUbocR6hn/rPIX5lEs7/cGCg==
X-Google-Smtp-Source: ABdhPJwIxzRLgEXsusPVwDITDBFaKysU9xK9GoTZvNwp0Zi4M9e8phH2aQxGkvhEe0m+83XDZESZsw==
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr6037835wmi.107.1599041371193;
        Wed, 02 Sep 2020 03:09:31 -0700 (PDT)
Received: from macbook-pro.lan (ip-95-222-154-235.hsi15.unitymediagroup.de. [95.222.154.235])
        by smtp.googlemail.com with ESMTPSA id d190sm6318334wmd.23.2020.09.02.03.09.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Sep 2020 03:09:30 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: IORING_OP_READ and O_NONBLOCK behaviour
Message-Id: <28EF4A51-2B6D-4857-A9E8-2E28E530EFA6@googlemail.com>
Date:   Wed, 2 Sep 2020 12:09:29 +0200
Cc:     Josef <josef.grieb@gmail.com>
To:     io-uring@vger.kernel.org
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi there,

We are currently working on integrating io_uring into netty and found =
some =E2=80=9Csuprising=E2=80=9D behaviour which seems like a bug to me.

When a socket is marked as non blocking (accepted with O_NONBLOCK flag =
set) and there is no data to be read IORING_OP_READ should complete =
directly with EAGAIN or EWOULDBLOCK. This is not the case and it =
basically blocks forever until there is some data to read. Is this =
expected ?

This seems to be somehow related to a bug that was fixed for =
IO_URING_ACCEPT with non blocking sockets:
=
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?h=3Dv5.8&id=3De697deed834de15d2322d0619d51893022c90ea2

Thanks
Norman

