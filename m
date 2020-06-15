Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167901F8FFC
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 09:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgFOHer (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 03:34:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgFOHer (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 03:34:47 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BA7C061A0E;
        Mon, 15 Jun 2020 00:34:47 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id y17so15919090wrn.11;
        Mon, 15 Jun 2020 00:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ukK4zFne86yZ3R5xdFsOwfHvSClN/6bEp/4TyWNFPJM=;
        b=tKTpzUVXx9nSguXDgrqEPRg1oXI1LNHmCRK2onjXy1dMwlj2XEPGys7NOcwFVlUkoy
         kFXR0kbZnacox2VWUnGcjpyxWBj4fZS+HpXvJhOM0LyDq2c5yLQcKNRcAX8wzJhanGDZ
         fG5mV4rQsaxxvud2R7OMLpjQuEsAxEVzXogSXOx8hVJFyTAujIuk/NiPpfcUjMwUyaZp
         It9Kd+ce3Ihq0WB+R5ZQTS0GT6BDS1PhrUm6GDrMr8ooEapvAgaLx99RjLMrc2SUUibQ
         H867weh6c4z0bXXm/5WDxUsUDA4atbnhQnF5Cba+L/NvrFG6sQmLWWr6PKsQXqEp/K/1
         33bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ukK4zFne86yZ3R5xdFsOwfHvSClN/6bEp/4TyWNFPJM=;
        b=TskQOnennVwFDfs87fd7LwTUNmOTqVE6NdlZkoEcVyBsIpObqUDaTaA3j6fZQDqaVi
         8fetpy+ObyuLJQbChMq7syFpDDhrcasF6iE+mqWpCP7IFiVC5yhR49Xbzkd0rxeShxby
         WS0OONgPcPdGy8EkwMJOLZvicP5jpSNLlVA2XpAdZIEpiumgW4CiH4AA1HljRDwWy/+c
         P9ANzGJAR6ghVSNfDI53KD4HOzZY7dKCq8OQ0Kl8pV8sO+hhpjQERyjqF3Iz52mt7Sm4
         /FQIC5/OUosW5lqwa0lc6H/+kTs8NJgy6sJM6+eRR2kGQTSIMzmH07846e29b3tN+VnZ
         tphA==
X-Gm-Message-State: AOAM533nkAlgoOyIA3Ar1haKlYnzXD+f1By1ktBoojmlwmthpJnAPZMK
        ypZQVwYqo8H6OdZ8gmllWhc=
X-Google-Smtp-Source: ABdhPJzSRTuVD5B29PYAeKUrAmcKJ41se2Zoa+vP+UWsBKeG4IJOp6WebJSp7iQe5ec5Fx5uOJdbUw==
X-Received: by 2002:adf:f0d2:: with SMTP id x18mr27222235wro.250.1592206485816;
        Mon, 15 Jun 2020 00:34:45 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id l17sm20271324wmi.16.2020.06.15.00.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 00:34:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ebiederm@xmission.com
Subject: [PATCH 0/2] don't use pid for request cancellation
Date:   Mon, 15 Jun 2020 10:33:12 +0300
Message-Id: <cover.1592206077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Cancel requests of an extiting task based on ->task address. As
reported by Eric W. Biederman, using pid for this purpose is not
right.

note: rebased on top of "cancel all" patches

Pavel Begunkov (2):
  io_uring: lazy get task
  io_uring: cancel by ->task not pid

 fs/io-wq.h    |  1 -
 fs/io_uring.c | 46 ++++++++++++++++++++++++++++------------------
 2 files changed, 28 insertions(+), 19 deletions(-)

-- 
2.24.0

