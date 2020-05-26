Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777021E2914
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 19:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389224AbgEZRfp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 13:35:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388784AbgEZRfn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 13:35:43 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA8AC03E96D;
        Tue, 26 May 2020 10:35:42 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id l21so24730596eji.4;
        Tue, 26 May 2020 10:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vcMNbORvIjJ2la5oap9DjFcpa/YIWrMblMOSotFUClk=;
        b=eSRk60Z5I56xBZBdTUOJ4envTL5Y2lMwiTIgL3XrXP55VyO69IGkjPTk3A2j28qsls
         WxDRQHHyqrRmj4zaTjZpWvMXu70IX2Vn4G32CRw/BDz90FS2TKchSp0zUMio8tS2pJMr
         JyJHt7ArONILqWOmA3/NHq0lN6QOxuZYQBp/kRqi41D7m7Kr78WSodKMNODAtijMrl3d
         b5+V0hxU2Cs/Fje9MyjVUlpyS/RBOW9cmjMTIn22l3/OLzbklxTJ6VslXi01IHWPSXkT
         XhcgWQJl+tUZVzcXWnX5U0+ydAaWif7uuzysOw3Vp2bDo7v27HF4+uvaGjn8TgZj1DLr
         PJuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vcMNbORvIjJ2la5oap9DjFcpa/YIWrMblMOSotFUClk=;
        b=lVDJgcGgaiA/fIxi2exF4KbFR+AD5iMhFr6+SEC2ax5FTXlcm57l/4q0pADXgycpzt
         f7VAAGfa8MF2B9n6ovBPtaQk1/WZOpNVsdaI+0a1vtoZDKPrhfW7yD6GFKSVTVZDapBn
         aRF1lJb2areeudQuWjlUdS9LHHfguIEnzhPi3/6bUPBmtmaIPDfK+k6kSC5P58RWzd1Y
         ZddTeTzp1n0X1uPWTCUGyBCIwsl5C2iXSmtZ4xQ3toCC4l7T1uQtTXFSiSyccjOAGfee
         aMBWMx5yoEyTFWcb8/hZpBhkg9E9gKPGrSZR1bJHC+6f5emtIa4IsIgThAFRfLeMMopP
         HP9g==
X-Gm-Message-State: AOAM5330Y+lUcWPgJpT0hz54+lK294FC67lTCdYfwEB0MzGH3f4+ZUFX
        XdQWNAvfvPmZAj/waI6217c=
X-Google-Smtp-Source: ABdhPJyK0sQ6Non1RS6u11ZqHLO9HSHJJemplDjJkxZGjagrE5vFaLeEv/X6XvyHlterzThMRcBJ/g==
X-Received: by 2002:a17:906:4088:: with SMTP id u8mr2156486ejj.444.1590514541446;
        Tue, 26 May 2020 10:35:41 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm391326ejc.94.2020.05.26.10.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 10:35:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] random patches for 5.8
Date:   Tue, 26 May 2020 20:34:01 +0300
Message-Id: <cover.1590513806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nothing insteresting in particular, just start flushing stashed patches.
Ones in this series are pretty easy and short.

Pavel Begunkov (6):
  io_uring: fix flush req->refs underflow
  io_uring: simplify io_timeout locking
  io_uring: don't re-read sqe->off in timeout_prep()
  io_uring: separate DRAIN flushing into a cold path
  io_uring: get rid of manual punting in io_close
  io_uring: let io_req_aux_free() handle fixed files

 fs/io_uring.c | 64 ++++++++++++++++++++-------------------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

-- 
2.24.0

