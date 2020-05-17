Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04FB31D678E
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgEQLDf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727839AbgEQLDe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:03:34 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9875FC061A0C;
        Sun, 17 May 2020 04:03:34 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id h188so5497326lfd.7;
        Sun, 17 May 2020 04:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eX2hhdYXAY6cQWp3qZfQipnJT+tE/JVeO5y9PXYMiyc=;
        b=ODK3g1ueObl/PTjmHpm4iPH3I+9Ynk8D5RU4U8kJSBve9NqyU4TY8kXHqNclkglcUj
         57LMCYqWXcDzgG4mCaOaCR0AY8AtYyZK6XpgPwrnYt3ofLzVG9eYXazQcyQ0iV/E02ac
         9tyr9kPLjLDQwooZLTsVbvQ5FdHSDMRMYQ6C9gwSoJriK25iNA1dQLzMnbIejqwiHvb9
         6fC4GAFHk3FPRofwOZP5nFtdrx5doSK2lzE9zqH4CdIe16psVb9/NzEr4Z0l+BED1MVJ
         1URvsQ/zxHvXHMrZXRrsHeNd75E0cN/ukoY/e3Ay7KW3opwlfNrOznRW8v4FYEMAqwad
         AnKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eX2hhdYXAY6cQWp3qZfQipnJT+tE/JVeO5y9PXYMiyc=;
        b=BaOgp1y69tM7QcySnzN6oVbd1P4UMMSoOKwH+TcDP5l1OGNcLxwD6ptZQmeiYz6uWC
         3Q0nPr8N3qoN+0upiw3OTJtQ8+h8McsxURoucw340qJuJg8ASEPbfNdJqdi9pWku78cw
         Q8/EeiEdByUAtVdFSoThBq49DoNbLpigqb/s4BpUSIQVcAm4i0ytQplrCeoh+v9yyMaA
         8q4UIuqBZ0g6IMO25hrSK9I4GYXR7maGj39MxLuzo93S554yqfzcBdVnurfjbSQO/yXB
         GABPcj64IWIsCM6AyfOQUPlHplLSphrLnAgwT91Bb8RXLoiHWI6vR9G47XdJwyxV5n0o
         gXew==
X-Gm-Message-State: AOAM530EmKN9wuUJ19G5VMdzUNsAxEAlzAuqzrd9oidwAjFGKX1DKReK
        bA8weglOLdhAlPPexd3MQm2dsxOb
X-Google-Smtp-Source: ABdhPJyiBfmWwqcseomv/5PVCeSRKEdXxSDEk7TWsi5B2qzamnudTrlvwrD2UZ6rQdV9Fr8w3bIX0g==
X-Received: by 2002:a19:150:: with SMTP id 77mr3326626lfb.71.1589713413093;
        Sun, 17 May 2020 04:03:33 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w25sm1080333lfn.42.2020.05.17.04.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:03:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH for-5.7 0/2] fortify async punt preparation
Date:   Sun, 17 May 2020 14:02:10 +0300
Message-Id: <cover.1589712727.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[2] fixes FORCE_ASYNC. I don't want to go through every bit, so
not sure whether this is an actual issue with [1], but it's just
safer this way. Please, consider it for-5.7

IMHO, all preparation thing became a bit messy, definitely could use
some rethinking in the future.

Pavel Begunkov (2):
  io_uring: don't prepare DRAIN reqs twice
  io_uring: fix FORCE_ASYNC req preparation

 fs/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

-- 
2.24.0

