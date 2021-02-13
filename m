Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30CE531AD02
	for <lists+io-uring@lfdr.de>; Sat, 13 Feb 2021 17:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBMQPX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 Feb 2021 11:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhBMQOv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 Feb 2021 11:14:51 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D001DC061574
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id a16so1408519plh.8
        for <io-uring@vger.kernel.org>; Sat, 13 Feb 2021 08:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6CO+t81Eh/TurcnME6EGLjp/KgrnKKdnAnu5VxjUvoA=;
        b=x6Hbb0+pcN96bLijs1CJjy1d2DmA+ZK/c9D5VcYvWLsnpw7fSYReziNFXWloaZmvYw
         BqMDtFLgI1aYSHvJgJhZBtvoUg9W6SCu3tZPKRQebXYNye75YqE3uXZePp2t2GBmPbTu
         SuyuIhB1Gch0W4a7XxQxcK5fVnImwYs3jR0IahxHulge//ecoxUPpxMyatKuccSz4PSj
         rzP84udXzEBJPkIpkKuDK3jWVsoOWShFtSad9WVnaBaZle+2/d6fJHDeHmLc9rqP47W2
         aM3Yv0lUimTqqqry9O7JoSL7/8qOR/HExye3NmVDvlUQIqsDTVJui8gkJuBgfT223ZRE
         Pv4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6CO+t81Eh/TurcnME6EGLjp/KgrnKKdnAnu5VxjUvoA=;
        b=b3kpHS2ZIu5o68grxAMH+H/KLF2v187r707TZqZ34kgad1gMCXFdhKBS8jhw6b62M+
         joHziuNV3Uhsf3595ZdMidfLsRcqci9EOALz/STlirCbzzYo2UvGa2nRN58Swh40VMxo
         QDUnd78vJP2kJGE3oTifUl9VKmOpnLAmfGjmaTweLoCO9/mdxmKHCUBbDzhaapW5WXh3
         dcGzPF2XJGKaefp1La8CuHrqwmtoOVlUwC1TJBWz41YAC4heFIJ0LPMzNKm/PmLVlx6T
         UwItMhO+clAy5hqamCDoHcnC6/T1efhfgTEuWZD6hqboupPEWfo/BOW7tupKSr/L4Q9F
         sjaQ==
X-Gm-Message-State: AOAM530KuKEqf8MhTPymCZeVifazGN1qBml3vIc07EtzGKMP29NLVtc5
        4p5GdDOXAHyQ7ZKgmZjevMbuD3yJRGFrNg==
X-Google-Smtp-Source: ABdhPJzoyrXwjP2Oe3T2ym4nffHaj/WWDeCd7+ZF9ul0y/vqurjKy91zDEJiYAlriuV5+mX6QL6PWQ==
X-Received: by 2002:a17:90a:ea0b:: with SMTP id w11mr7752440pjy.140.1613232851042;
        Sat, 13 Feb 2021 08:14:11 -0800 (PST)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 124sm11984975pfd.59.2021.02.13.08.14.09
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Feb 2021 08:14:10 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Free request caches for exiting task
Date:   Sat, 13 Feb 2021 09:14:03 -0700
Message-Id: <20210213161406.1610835-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

Now that we account these requests, on the off chance that we're sharing
the ring, be nice and prune caches belonging to an exiting task.

Two prep patches to get there, final one-liner hooks it up.

-- 
Jens Axboe


