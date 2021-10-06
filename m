Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F71424073
	for <lists+io-uring@lfdr.de>; Wed,  6 Oct 2021 16:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238932AbhJFOwy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 10:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbhJFOwy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 10:52:54 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADCFC061753
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 07:51:01 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id l6so1792593plh.9
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 07:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amikom.ac.id; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rlVywWv29DwWeKmdhk6n1kC3HI4UWZCJ2gpXVz5wRDA=;
        b=SNF0Sjb9LGgTmawWcPn1ATvgJBnIwZ7CoJTs6td6ZYA14rJofbSq8X6wCIecZGbKa6
         wYsPwhfGqd3IJl9MmT9Zt0gqXYKSICEUWgwzZw0Y43fiuU68dEk2J3oD7ot5A6dgkYRK
         MLQ5Ky53oO/zcH5+RFEvRVXfbM8+Brl+u0+mmwQpL6JyNNRL92zf1/YuBn+iIAw7m0b6
         w35MUtNkBAlm52tTC8DzkkKOJqmZzzkCcIZet4xiU/v7Gly1wzJ0fa2nmQBsYwqzGffM
         Pqm5VAi4YxvZqrXdZaDQj88ptNKt5zqJA7HaDAM3w9zuLcRR/iIKDu5OlQKA2HfVMkQx
         soNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rlVywWv29DwWeKmdhk6n1kC3HI4UWZCJ2gpXVz5wRDA=;
        b=He1nHAp6S7xuuzCnOhs2WEFCWkboFqKfsvj2X1CAt8Mfh+3ZwjuxBjHvONyTU6IrV0
         L0Obn26gesSr3Z3J8vM8/FXdBlGhaOBzjqNjctSSU9TCQfip/4uCYp5GR9RSSU4CuHS/
         hqiBBOAEmpyluDR22XJR0+6zyxgayV8FapjzS19MpVtcEPYg08apI2SNL6Un9PHq/vLq
         jugc5LnX8el4ouylYHpUN95qK9JkEpOg8+UXChvHywfto6wzKpiwPhSrfWMFNYnVPl3N
         fQCxkq84f8QWJJ8aL9ySUz2oNo8fXcutKDNM4rG10RIEdggJJNcvGKCcO7yWqk8g5Sge
         Bu/Q==
X-Gm-Message-State: AOAM533kbvekW4D+WwRFEMOY33YmJejpPLNZSnw+633XTplVAli4BKf2
        Asxemm+qMlzmoXZeb5rXsD98ZA==
X-Google-Smtp-Source: ABdhPJxQV12+m2SJab5tJlmeOki2P1IoF0rqOduhyoaQ7EHK6BJYTQCfT5rdF1sAVCqsCGPDMy5pGQ==
X-Received: by 2002:a17:90a:49:: with SMTP id 9mr11413656pjb.80.1633531861397;
        Wed, 06 Oct 2021 07:51:01 -0700 (PDT)
Received: from integral.. ([182.2.71.97])
        by smtp.gmail.com with ESMTPSA id y197sm19155429pfc.56.2021.10.06.07.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 07:51:00 -0700 (PDT)
From:   Ammar Faizi <ammar.faizi@students.amikom.ac.id>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>
Cc:     Bedirhan KURT <windowz414@gnuweeb.org>,
        Louvian Lyndal <louvianlyndal@gmail.com>,
        Ammar Faizi <ammar.faizi@students.amikom.ac.id>
Subject: [PATCH v1 RFC liburing 1/6] configure: Add LIBURING_NOLIBC variable
Date:   Wed,  6 Oct 2021 21:49:07 +0700
Message-Id: <20211006144911.1181674-2-ammar.faizi@students.amikom.ac.id>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
References: <20211006144911.1181674-1-ammar.faizi@students.amikom.ac.id>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

To support build liburing without libc.

Link: https://github.com/axboe/liburing/issues/443
Signed-off-by: Ammar Faizi <ammar.faizi@students.amikom.ac.id>
---
 configure | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/configure b/configure
index a7caa07..3dec81a 100755
--- a/configure
+++ b/configure
@@ -357,6 +357,13 @@ print_config "has_memfd_create" "$has_memfd_create"
 
 
 #############################################################################
+if test "$LIBURING_NOLIBC" = "y" -o "$LIBURING_NOLIBC" = "yes" -o "$LIBURING_NOLIBC" = "1"; then
+  output_sym "LIBURING_NOLIBC"
+  LIBURING_NOLIBC="yes"
+else
+  LIBURING_NOLIBC="no"
+fi
+print_config "LIBURING_NOLIBC" "$LIBURING_NOLIBC"
 
 if test "$__kernel_rwf_t" = "yes"; then
   output_sym "CONFIG_HAVE_KERNEL_RWF_T"
-- 
2.30.2

