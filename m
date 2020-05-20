Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B21D1DBABD
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2020 19:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgETRHp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 13:07:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23504 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726619AbgETRHp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 13:07:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589994464;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8s8eLV7Rc+UskCAa0sA5YpsdyL5CTF8FfVq7I1LuUs=;
        b=jFEi36XTiYFihuBECoR+lkY8sKMOIvSlx+iDa4OTwUa1bhkCWneTnrxktm5N7OQN6HYSXI
        IPi+54zVOC3J8yL4X4Hmybz+qX7koclQaeBK+7WpLP4VKIQTgMp82mf85a2cb++4ha3b6H
        N1iqL1KuPM7D5bxQeSLjGyeuzp6gvjI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-TX4Vq5NpPyayPAYhd8p7Qg-1; Wed, 20 May 2020 13:07:42 -0400
X-MC-Unique: TX4Vq5NpPyayPAYhd8p7Qg-1
Received: by mail-wm1-f72.google.com with SMTP id f62so1518584wme.3
        for <io-uring@vger.kernel.org>; Wed, 20 May 2020 10:07:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8s8eLV7Rc+UskCAa0sA5YpsdyL5CTF8FfVq7I1LuUs=;
        b=TMDjtuuOHLiGmf4k0rqiOb9GxZkoE/u6pfiM3rHHlGnRKh9wjcgRnm3r8DlEq39Eo5
         8hdJnW3fzrZJIYJx54zqZr0okwUVAwqHMmJ12lh56N3mczwhHM8IWVJknseYiPSPBEZt
         nMhThzeXH0SEL+OxD1qwUpD2HZqCg0OSpPZ+2SEQpufuN7zXUrqSV9s4IlxpdjxYBVst
         H3iHxmBLUllBTLsk+DXeU5NENXrC+W8uiwEdcSaoBxVPePqLSzgiSub3SDUwYfJfNpQQ
         v0eEqVFgg6wSdqfaSz3tnWW2O9fVqWmviiiIS2JlJnhfiBmkvDHgYhhphhgY1JlNUdZc
         lhhw==
X-Gm-Message-State: AOAM530eq+JLaIaxVSFgfMd9UvV7TAoV3ybQycAwrGg9lH6rTnQtjOG2
        0Lb2z6wTrtG+Kah3rzMLun8UOed7A6aKrufklGQ/FEkWomS+B+H9wtfWcwPNvz3NgoDIHm1XytY
        s2rtew5rK0hftedyCRco=
X-Received: by 2002:a1c:29c2:: with SMTP id p185mr5106271wmp.7.1589994461626;
        Wed, 20 May 2020 10:07:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXwz+s1k2t4Yt/PPpgCx537sWFWIohMV+6cLRupqxNVklTI9TSnTh39ma356x642wRy6d4eA==
X-Received: by 2002:a1c:29c2:: with SMTP id p185mr5106256wmp.7.1589994461441;
        Wed, 20 May 2020 10:07:41 -0700 (PDT)
Received: from steredhat.redhat.com (host108-207-dynamic.49-79-r.retail.telecomitalia.it. [79.49.207.108])
        by smtp.gmail.com with ESMTPSA id s8sm522512wrg.50.2020.05.20.10.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 10:07:40 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH liburing v2 4/5] man/io_uring_register.2: add IORING_CQ_EVENTFD_DISABLED description
Date:   Wed, 20 May 2020 19:07:13 +0200
Message-Id: <20200520170714.68156-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200520170714.68156-1-sgarzare@redhat.com>
References: <20200520170714.68156-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 man/io_uring_register.2 | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/man/io_uring_register.2 b/man/io_uring_register.2
index e64f688..5022c03 100644
--- a/man/io_uring_register.2
+++ b/man/io_uring_register.2
@@ -168,6 +168,14 @@ must contain a pointer to the eventfd file descriptor, and
 .I nr_args
 must be 1. Available since 5.2.
 
+An application can temporarily disable notifications, coming through the
+registered eventfd, by setting the
+.B IORING_CQ_EVENTFD_DISABLED
+bit in the
+.I flags
+field of the CQ ring.
+Available since 5.8.
+
 .TP
 .B IORING_REGISTER_EVENTFD_ASYNC
 This works just like
-- 
2.25.4

