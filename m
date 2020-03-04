Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D273179757
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 19:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgCDSAV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 13:00:21 -0500
Received: from mail-io1-f43.google.com ([209.85.166.43]:42915 "EHLO
        mail-io1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgCDSAV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 13:00:21 -0500
Received: by mail-io1-f43.google.com with SMTP id q128so3380892iof.9
        for <io-uring@vger.kernel.org>; Wed, 04 Mar 2020 10:00:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuEfcCoMAImkgigMzhIaVr0HhmqoAZg4l9c7CBFCwbk=;
        b=NlH0vEEoMZJIFFV2c+l7XTfbYQJd27Xz52XdQYx0qyn0abP370tzeGHEtr7n67xoSb
         HoDcyWMIACZM9OXuVjJGzuz3cuFpgVXSMWh4DGU6AXArdLGy+EquYWz2L6HC+5P5gzSA
         uvi2MhWqVU7mdPOeAI0XCdzDSXiJcuQn5hdyc7B93/MjDtqkw8BSsaecSmPDfRkEJbeG
         NbId69V9wQHhyomBzfyiG2Azb8BOThCDx1xT9SQuNNWeo2azoXwQiIac0kOxYuQVsTAs
         yU15ua+eCjGySjwDehFwx1A1oxmw+/Is4gM5l3m0LYOfCN15LiuC09OHfazkvo63WNOM
         lJ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kuEfcCoMAImkgigMzhIaVr0HhmqoAZg4l9c7CBFCwbk=;
        b=BtKvhTKNV+WJKL05n+xoCgE5Dg7OiWFKuj9xbM4NXp+8Gv/Z2DW0Del8HDViGxZSQj
         VokWvrlZzbE7HgS/Ty3BiOR22I0dWxsRKdPa615NS56H6sgZigjnMRSlbHluCrh5B24q
         /2E/navGuusI5fqhCZW7YdIWHUl3m3hwkAksGmI93JbcBgh/DNz1YRA6+E9y7sD7eTva
         a/KciIl1ZCH/SayXtEgyLQXGydluNuqw+qTfVBkvza1aJTAj7G7E62jDNG+vZ4VOuA7B
         Mn8QIWjXRoM3ljYcG+XDbiBfnBMpjBcWDiAAICYxJ2klumiap7Z55fCsW/ouoI8yCDVq
         09Lw==
X-Gm-Message-State: ANhLgQ1d8ZP5y+iyeoQeyrwnakQmI8Adzi06TUzL94YtCQwds5H08NHU
        sU3XWTBKoEM7ETR1vsMjVWUhYsSvS5I=
X-Google-Smtp-Source: ADFU+vvmn7OlvGP12KG+GKpKNtBGk99iGmOiC5D0FPhAMe93oZHHonTCNlFhiu/pxrbRWrVgkT7Ldw==
X-Received: by 2002:a5e:871a:: with SMTP id y26mr3019024ioj.283.1583344819375;
        Wed, 04 Mar 2020 10:00:19 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p23sm6715187ioo.54.2020.03.04.10.00.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:00:18 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     jlayton@kernel.org, josh@joshtriplett.org
Subject: [PATCHSET v2 0/6] Support selectable file descriptors
Date:   Wed,  4 Mar 2020 11:00:10 -0700
Message-Id: <20200304180016.28212-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One of the fabled features with chains has long been the desire to
support things like:

<open fileX><read from fileX><close fileX>

in a single chain. This currently doesn't work, since the read/close
depends on what file descriptor we get on open.

The original attempt at solving this provided a means to pass
descriptors between chains in a link, this version takes a different
route. Based on Josh's support for O_SPECIFIC_FD, we can instead control
what fd value we're going to get out of open (or accept). With that in
place, we don't need to do any magic to make this work. The above chain
then becomes:

<open fileX with fd Y><read from fd Y><close fd Y>

which is a lot more useful, and allows any sort of weird chains without
needing to nest "last open" file descriptors.

Updated the test program to use this approach:

https://git.kernel.dk/cgit/liburing/plain/test/orc.c?h=fd-select

which forces the use of fd==89 for the open, and then uses that for the
read and close.

Outside of this adaptation, fixed a few bugs and cleaned things up.

-- 
Jens Axboe


