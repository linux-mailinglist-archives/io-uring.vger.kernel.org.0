Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7752B1D5666
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 18:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbgEOQoC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 12:44:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:21722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbgEOQoC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 12:44:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589561041;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h8s8eLV7Rc+UskCAa0sA5YpsdyL5CTF8FfVq7I1LuUs=;
        b=hssR55sxlTd8FOoGt8PXmsU5N/mtpcbmg+hr9T1S9z8DH6GIhlP5uOPZYvPx3q1P0RlJww
        D9mLLf6lkzl1ta/g44HV8bZrGXEaTDYNdsPf2IG9O0d1rOfFi9uHxKbKd+EzPwPX19/m9f
        PJP0nVLslrFcA7yJdc80t4GtbNzW3Kw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-7dnm4H1ZMcOq4ixL5efdWQ-1; Fri, 15 May 2020 12:43:59 -0400
X-MC-Unique: 7dnm4H1ZMcOq4ixL5efdWQ-1
Received: by mail-wr1-f72.google.com with SMTP id q13so1444749wrn.14
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 09:43:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h8s8eLV7Rc+UskCAa0sA5YpsdyL5CTF8FfVq7I1LuUs=;
        b=q+7PXe9OFVgaDd5bK3KsU260HVdxDjYSbzgSEYBDhYstdVffW682fcgEzMSxwD32aM
         zARGNIG6uNUw9X+xTk3tXzL3W0sPiMy2ujZERcQ3DCO9Axjfug4pDK7VdfQpHgJEMwSS
         CHPAoT8MG0fJiR3DXvApkpB6t9O3fmzd0sCcTPlu1qyKn/Hyp0rRSH1nD/3GZhS6aeAo
         pA8PMo0pbDUPdllShaR3iYnfXw1bur+8CWT9rOlmcZKAAAJYXJn/I7ptknlS6AH21HXw
         zsqjgkIjs6IjYAH5to3fMu+190bWbf4P0MwnDI1GsXVM0RtbE6ZuhyT/HPAiLPiUivya
         vV9w==
X-Gm-Message-State: AOAM533fziHxrggbbKF8ILYWSLomeEQ8Oijr0OkAwFx7VjeLuHhSrDi6
        xCdHJ0+igAWpP5+3xCOI59iOnpNFHBQY0mH+N5iB8spEaFJSGv+xTXKGNKFcSL3dVT1a8dNrnLX
        V8T8TKu9laJLz/EZvQXc=
X-Received: by 2002:adf:fb0f:: with SMTP id c15mr5474775wrr.410.1589561038161;
        Fri, 15 May 2020 09:43:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxVxv8YeBI017ZlprJOj3SpfAuk3f/y4sCzwxDUE6/aJPp1jvhYyofCGOptkFrZN2iuUiJ8Qg==
X-Received: by 2002:adf:fb0f:: with SMTP id c15mr5474764wrr.410.1589561037980;
        Fri, 15 May 2020 09:43:57 -0700 (PDT)
Received: from steredhat.redhat.com ([79.49.207.108])
        by smtp.gmail.com with ESMTPSA id k131sm4678790wma.2.2020.05.15.09.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:43:57 -0700 (PDT)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [PATCH liburing 4/5] man/io_uring_register.2: add IORING_CQ_EVENTFD_DISABLED description
Date:   Fri, 15 May 2020 18:43:30 +0200
Message-Id: <20200515164331.236868-5-sgarzare@redhat.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200515164331.236868-1-sgarzare@redhat.com>
References: <20200515164331.236868-1-sgarzare@redhat.com>
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

