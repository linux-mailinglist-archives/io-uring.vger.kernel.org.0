Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2B2E43E92C
	for <lists+io-uring@lfdr.de>; Thu, 28 Oct 2021 22:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhJ1UD3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Oct 2021 16:03:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56013 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhJ1UD1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Oct 2021 16:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635451259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JHJiC6cOVGdhcSs+84oKP84K4Oite900jLyOZGq/UOI=;
        b=dj987aif+LfkHHhSmK2wP0TlUjh2PuinYSJppCt2H5hdzU6Xydr34D01X6RDcRNhqXQaPE
        EYUbFO4+TsOmh/O95YJ/XshALdjnI95WMxafbQctVPaOZ+1HcxKb5C0Vzereba7R+Y07j6
        USGp84LizQT75kL0exYM2cxf6bwzfjw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-4426yf1SPo6YLKO-TbilYg-1; Thu, 28 Oct 2021 16:00:57 -0400
X-MC-Unique: 4426yf1SPo6YLKO-TbilYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D693710151E5
        for <io-uring@vger.kernel.org>; Thu, 28 Oct 2021 20:00:56 +0000 (UTC)
Received: from madcap2.tricolour.com (unknown [10.3.128.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 452601A26A;
        Thu, 28 Oct 2021 20:00:38 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Linux-Audit Mailing List <linux-audit@redhat.com>
Cc:     io-uring@vger.kernel.org, Steve Grubb <sgrubb@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH v3 1/7] add basic support for the AUDIT_URINGOP record type
Date:   Thu, 28 Oct 2021 15:59:33 -0400
Message-Id: <20211028195939.3102767-2-rgb@redhat.com>
In-Reply-To: <20211028195939.3102767-1-rgb@redhat.com>
References: <20211028195939.3102767-1-rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel support to audit io_uring operations was added with commit
5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to
io_uring").  Add basic support to recognize the "AUDIT_URINGOP" record.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 lib/libaudit.h    | 4 ++++
 lib/msg_typetab.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/lib/libaudit.h b/lib/libaudit.h
index 4e532177aa11..08b7d22678aa 100644
--- a/lib/libaudit.h
+++ b/lib/libaudit.h
@@ -307,6 +307,10 @@ extern "C" {
 #define AUDIT_EVENT_LISTENER	1335 /* audit mcast sock join/part */
 #endif
 
+#ifndef AUDIT_URINGOP
+#define AUDIT_URINGOP		1336 /* io_uring operations */
+#endif
+
 #ifndef AUDIT_OPENAT2
 #define AUDIT_OPENAT2		1337 /* openat2 open_how flags */
 #endif
diff --git a/lib/msg_typetab.h b/lib/msg_typetab.h
index 030b1952f2cb..f8ae4514893b 100644
--- a/lib/msg_typetab.h
+++ b/lib/msg_typetab.h
@@ -127,6 +127,7 @@ _S(AUDIT_TIME_INJOFFSET,             "TIME_INJOFFSET"                )
 _S(AUDIT_TIME_ADJNTPVAL,             "TIME_ADJNTPVAL"                )
 _S(AUDIT_BPF,                        "BPF"                           )
 _S(AUDIT_EVENT_LISTENER,             "EVENT_LISTENER"                )
+_S(AUDIT_URINGOP,                    "URINGOP"                       )
 _S(AUDIT_OPENAT2,                    "OPENAT2"                       )
 _S(AUDIT_AVC,                        "AVC"                           )
 _S(AUDIT_SELINUX_ERR,                "SELINUX_ERR"                   )
-- 
2.27.0

