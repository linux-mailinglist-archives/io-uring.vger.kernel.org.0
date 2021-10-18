Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1C84310D7
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 08:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhJRGwY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 02:52:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhJRGwY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 02:52:24 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84439C061745;
        Sun, 17 Oct 2021 23:50:13 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id y67so14947413iof.10;
        Sun, 17 Oct 2021 23:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=35HhG4S5DxehocgaGfcU5e8SCuyXdTPRj7tXaFVxy8A=;
        b=pQ9MFH2vpyPbYCzn4S3YaUS2XwHiePprThsWHioOIUgi4H7Wd36cFvXr7gz8Jhbxxt
         id61l5nhCTGWfK3Xxl2/wcckl8i2aTdm/aFRHwhMSVRFolVITn4HWHQ/GjEzHUffr9i4
         othUA6W7ApCW5Jm8CGJMB3WhT1W0Ib23tLh4b6BTFe3CYnGBKuJO4Utv89kpiGbYjHH6
         FDg9qyXqPbkNaGBdzeVZZKc4XV8hd8pkWldMdX26io8TDvPkmowf9mfp1/LzodUhy1EO
         Hg/xsDaizyje9hw51tJ3qvhyJaI+PyW/tJwxogWVWhz1LepSlPaLmYpQ0NRXov5V19Ny
         emiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=35HhG4S5DxehocgaGfcU5e8SCuyXdTPRj7tXaFVxy8A=;
        b=rayq3odOLOfc0pLTInjrO8fpoI5Z1RbDl5QbuRPuxR7Xu7SQw2jgOz1ZL8Le2yBBrA
         Ca+EYE+aGOVu1WQVFAYG4p3zkNZNf+tnfMqoeLf2fjdYDfRdcVVFK3ZmNi9FPKUy6a/o
         hcxoRjo+4h2ZNEwI1NPztr+HCeQnh7GyoxcmrzgRYmPCx9CfTnTzzB+Z0SeKauiwECI+
         a2BxYsIVirr3EqRc5R43zZfsAoinyXneN/+j0ZI0VB5qRczoOi1hLhXMLRxPyeV2W1Qm
         dyFqqv2yIVLqdw773phx+5tjRkyzdMwu2kDkvKWOx5Q7ILcgEJEErmD7hpteyjeYqkSq
         FMCA==
X-Gm-Message-State: AOAM530oTnwLWqPuZbTr+oWEZMHWV1VfKqqLEBG0kJev6kHXOfP4ep9X
        t+QgyvMz0cRJwySI33zQLx7hl6RR394=
X-Google-Smtp-Source: ABdhPJwjg5QkbYfwgxgApvC1BHjgcyuh1pvHfgX35XypK7KNLn0XwfHZ3V2aQJ2y/g5urABBisqZVQ==
X-Received: by 2002:a05:6602:140d:: with SMTP id t13mr13042402iov.120.1634539812998;
        Sun, 17 Oct 2021 23:50:12 -0700 (PDT)
Received: from localhost.localdomain (node-17-161.flex.volo.net. [76.191.17.161])
        by smtp.googlemail.com with ESMTPSA id h2sm6090868ioh.14.2021.10.17.23.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 23:50:12 -0700 (PDT)
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1] fs/io_uring: Remove unnecessary condition in io_write
Date:   Mon, 18 Oct 2021 02:49:59 -0400
Message-Id: <20211018064958.19157-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This commit removes the unnecessary 'force_nonblock' condition from
the if statement. The if statement is already inside of an if whose
condition is 'if (force_nonblock)' so including it here is gratuitous.

Signed-off-by: Noah Goldstein <goldstein.w.n@gmail.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d7613c7355c..d1e672e7a2d1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3602,7 +3602,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 			goto copy_iov;
 
 		/* file path doesn't support NOWAIT for non-direct_IO */
-		if (force_nonblock && !(kiocb->ki_flags & IOCB_DIRECT) &&
+		if (!(kiocb->ki_flags & IOCB_DIRECT) &&
 		    (req->flags & REQ_F_ISREG))
 			goto copy_iov;
 
-- 
2.29.2

