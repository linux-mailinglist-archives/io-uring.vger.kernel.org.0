Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE202AA5EE
	for <lists+io-uring@lfdr.de>; Sat,  7 Nov 2020 15:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725845AbgKGOXI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 Nov 2020 09:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbgKGOXH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 Nov 2020 09:23:07 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5F2C0613CF
        for <io-uring@vger.kernel.org>; Sat,  7 Nov 2020 06:23:07 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id b9so4161904edu.10
        for <io-uring@vger.kernel.org>; Sat, 07 Nov 2020 06:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=IxQB43synbJ5nQZOOTPekPl6h3yFxCWA875CNU04Hfg=;
        b=wpE+jutmHTYKV6aDm1GEJ/cIxJKcoMgs/qPKp7/VUBKRBBVJjudEGKuTO/8h57VCGK
         liNuMs6QAAAD+pj2KqmxgEJemnAuNyQc1fK3PyuQK1hCIEkNxu4tEZIGit07bjjVBljC
         nYZI5D26JEYwsATlzd75ksJm7wYmLIC4Y5zNr2zTNmop1/9HJjBCnFgPnCDRc2Rm14Hg
         czIdSB3YakdjY7FDN8wBSiEfsf7bTOaJT631/qMilRl3oxbG7BiaVKolFVYYVIhd11UH
         eGHhLb6FbyorwQteY+SRi0qslLlQwXhkY5k5S1AFV+TnsQ2GX4C4W65HvERlZaGVSUZn
         Vf0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=IxQB43synbJ5nQZOOTPekPl6h3yFxCWA875CNU04Hfg=;
        b=FklVvZwtmMbsNyeFhVwdAexCXOEOGOzfM2aYblH5BJQqWC6tG8HtxO0Ha2uRofLwoC
         eLKhaYKY/VofyJ9xUgxEPUosH5XAZ8MHJZ0ccoCTGuFR3vDxuXRHe342cUgoJucOQC/T
         oYFTM//EKDajna5zDm26U+vvio1vWUFl6leBmDKHsSGrXJgxuV2giP4fzrFLfUrOU9X0
         2e/j1deVl0SQSP5T0XutPALBlmBaZSJAcbPjmfDKyrH57vK2+oRlD+/w0BQaJmFehIIt
         h4ZsiyoUsuShamNf7AdiWRlbfZYTsUnkR1v13U/tdTRDwzQy9SYCW6uoi/mKjGULMZxI
         T2oQ==
X-Gm-Message-State: AOAM530Qlveu8dq/3YTWRbbcvZP0OY1NYp81n6COgD+bvuD1FqOP2fpt
        wnxu8415P3PMl8gu/Vxvwh0V6P+YU1mkAtLLK4AG95ITNoXqqA==
X-Google-Smtp-Source: ABdhPJxZVNS2ZivCa+wvAvE7EZt8vVRZoQZkJZlDpW0sVJfAzbPfFglZBdYhkbPFL2d13F5VMhZouC2zxPEJp5VfcsY=
X-Received: by 2002:aa7:d9c2:: with SMTP id v2mr6922775eds.95.1604758985767;
 Sat, 07 Nov 2020 06:23:05 -0800 (PST)
MIME-Version: 1.0
From:   Victor Stewart <v@nametag.social>
Date:   Sat, 7 Nov 2020 14:22:54 +0000
Message-ID: <CAM1kxwhuVfkofDXKaeW4J6Khy2Jp3UcXALQ4SdP9Okk_w7zjNg@mail.gmail.com>
Subject: allowing msg_name and msg_control
To:     io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

RE Jen's proposed patch here
https://lore.kernel.org/io-uring/45d7558a-d0c8-4d3f-c63a-33fd2fb073a5@kernel.dk/

and RE what Stefan just mentioned in the "[PATCH 5.11] io_uring: don't
take fs for recvmsg/sendmsg" thread a few minutes ago... "Can't we
better remove these checks and allow msg_control? For me it's a
limitation that I would like to be removed."... which I coincidentally
just read when coming on here to advocate the same.

I also require this for a few vital performance use cases:

1) GSO (UDP_SEGMENT to sendmsg)
2) GRO (UDP_GRO from recvmsg)

GSO and GRO are super important for QUIC servers... essentially
bringing a 3-4x performance improvement that brings them in line with
TCP efficiency.

Would also allow the usage of...

3) MSG_ZEROCOPY (to receive the sock_extended_err from recvmsg)

it's only a single digit % performance gain for large sends (but a
minor crutch until we get registered buffer sendmsg / recvmsg, which I
plan on implementing).

So if there's an agreed upon plan on action I can take charge of all
the work and get this done ASAP.

#Victor
