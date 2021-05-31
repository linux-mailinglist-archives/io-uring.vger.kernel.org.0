Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFB8395DBE
	for <lists+io-uring@lfdr.de>; Mon, 31 May 2021 15:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231912AbhEaNuu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 31 May 2021 09:50:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38541 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232989AbhEaNrn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 31 May 2021 09:47:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622468762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y54MkJ1DkDPUmNpg6ptgLnrQ5/7BnVMsItBiTZSYR8Q=;
        b=Mek8ndKnCF4xvYU5PqUiIpL1CAsUguqFnK8vvcMepLiFw9M/cpHLnFrLPlX59e086+ffmW
        h9DUah/x9IuSstnEo1lsTA/DsUMKGAexzAzcbPlgygCNOehkNseeEM6LkF0e1qCspGQ7bN
        VFg1kWrcnTr472TDHFvKl9/944LfQv0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-AjF5-yO5PKy1ZPlxqlSV7A-1; Mon, 31 May 2021 09:45:57 -0400
X-MC-Unique: AjF5-yO5PKy1ZPlxqlSV7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E7774189C44F;
        Mon, 31 May 2021 13:45:54 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3B5B5C1B4;
        Mon, 31 May 2021 13:45:52 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>, linux-audit@redhat.com,
        io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 2/2] audit: block PERM fields being used with io_uring filtering
Date:   Mon, 31 May 2021 09:44:55 -0400
Message-Id: <8d1435a4b5db9139cc8eebce633f14872dd3a007.1622467740.git.rgb@redhat.com>
In-Reply-To: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
References: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The commit ("audit: add filtering for io_uring records") added support for
filtering io_uring operations.  The PERM field is invalid for io_uring
filtering, so block it.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditfilter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index bcdedfd1088c..d75acb014ccd 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -336,6 +336,10 @@ static int audit_field_valid(struct audit_entry *entry, struct audit_field *f)
 		if (entry->rule.listnr != AUDIT_FILTER_FS)
 			return -EINVAL;
 		break;
+	case AUDIT_PERM:
+		if (entry->rule.listnr == AUDIT_FILTER_URING_EXIT)
+			return -EINVAL;
+		break;
 	}
 
 	switch (entry->rule.listnr) {
-- 
2.27.0

